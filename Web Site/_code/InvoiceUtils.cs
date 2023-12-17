/**********************************************************************************************************************
 * SplendidCRM is a Customer Relationship Management program created by SplendidCRM Software, Inc. 
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Enterprise Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 * SplendidCRM owns all proprietary rights, including all copyrights, patents, trade secrets, and 
 * trademarks, in and to the contents of this file.  You will not link to or in any way combine the 
 * contents of this file or any derivatives with any Open Source Code in any manner that would require 
 * the contents of this file to be made available to any third party. 
 * 
 * IN NO EVENT SHALL SPLENDIDCRM BE RESPONSIBLE FOR ANY DAMAGES OF ANY KIND, INCLUDING ANY DIRECT, 
 * SPECIAL, PUNITIVE, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES.  Other limitations of liability 
 * and disclaimers set forth in the License. 
 * 
 *********************************************************************************************************************/
using System;
using System.Data;
using System.Data.Common;
using System.Threading;
using System.Threading.Tasks;
using System.Diagnostics;

namespace SplendidCRM
{
	public class InvoiceUtils
	{
		private DbProviderFactories  DbProviderFactories = new DbProviderFactories();
		private HttpApplicationState Application         = new HttpApplicationState();
		private Sql                  Sql                ;
		private Currency             Currency           = new Currency();
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private PayPalRest           PayPalRest         ;
		private PayTraceUtils        PayTraceUtils      ;
		private AuthorizeNetUtils    AuthorizeNetUtils  ;

		// 04/23/2010 Paul.  Make the inside flag public so that we can access from the SystemCheck. 
		public static bool bInsideProcessPending = false;

		public InvoiceUtils(Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, PayPalRest PayPalRest, PayTraceUtils PayTraceUtils, AuthorizeNetUtils AuthorizeNetUtils)
		{
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.PayPalRest          = PayPalRest         ;
			this.PayTraceUtils       = PayTraceUtils      ;
			this.AuthorizeNetUtils   = AuthorizeNetUtils  ;
		}

#pragma warning disable CS1998
		public async ValueTask ProcessPending(CancellationToken token)
		{
			ProcessPending();
		}
#pragma warning restore CS1998

		public void ProcessPending()
		{
			if ( !bInsideProcessPending )
			{
				bInsideProcessPending = true;
				try
				{
					string sBILLING_INVOICE_FROM_NAME   = Sql.ToString(Application["CONFIG.Billing Invoice From Name"  ]);
					string sBILLING_INVOICE_FROM_EMAIL  = Sql.ToString(Application["CONFIG.Billing Invoice From Email" ]);
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						string sSQL;
						sSQL = "select *                        " + ControlChars.CrLf
						     + "  from vwINVOICES_PendingPayment" + ControlChars.CrLf
						     + " order by INVOICE_NUM           " + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dtINVOICES = new DataTable() )
								{
									da.Fill(dtINVOICES);
									foreach ( DataRow rowINVOICE in dtINVOICES.Rows )
									{
										Guid     gINVOICE_ID   = Sql.ToGuid    (rowINVOICE["ID"                ]);
										Guid     gACCOUNT_ID   = Sql.ToGuid    (rowINVOICE["BILLING_ACCOUNT_ID"]);
										Guid     gCONTACT_ID   = Sql.ToGuid    (rowINVOICE["BILLING_CONTACT_ID"]);
										Decimal  dAMOUNT       = Sql.ToDecimal (rowINVOICE["AMOUNT_DUE"        ]);
										// 01/20/2009 Paul.  Invoice name is just NAME. 
										string   sINVOICE_NAME = Sql.ToString  (rowINVOICE["NAME"              ]);
										string   sINVOICE_NUM  = Sql.ToString  (rowINVOICE["INVOICE_NUM"       ]);
										DateTime dtDUE_DATE    = Sql.ToDateTime(rowINVOICE["DUE_DATE"          ]);
										// 05/07/2013 Paul.  Add Contacts field to support B2C. 
										Guid     gB2C_CONTACT_ID = Guid.Empty;
										if ( Sql.IsEmptyGuid(gACCOUNT_ID) )
											gB2C_CONTACT_ID = gCONTACT_ID;

										// 04/24/2016 Paul.  We need to clear the parameters as we are reusing an existing command.  Odd that we are just now catching this bug. 
										cmd.Parameters.Clear();
										// 11/15/2009 Paul.  We need a way to exclude old credit cards. 
										// Using the expiration date is a simply way, but a better way would be to add a status field to the table. 
										// 01/11/2010 Paul.  Use MetadataName function to trim name when running on Oracle. 
										sSQL = "select *                                 " + ControlChars.CrLf
										     + "  from " + Sql.MetadataName(cmd, "vwACCOUNTS_CREDIT_CARDS_Processing") + ControlChars.CrLf
										     + " where ACCOUNT_ID = @ACCOUNT_ID          " + ControlChars.CrLf
										     + " order by IS_PRIMARY desc                " + ControlChars.CrLf;
										cmd.CommandText = sSQL;
										Sql.AddParameter(cmd, "@ACCOUNT_ID", gACCOUNT_ID);
										using ( DataTable dtCREDIT_CARDS = new DataTable() )
										{
											da.Fill(dtCREDIT_CARDS);
											string sSTATUS = String.Empty;
											int nCreditCardCount = dtCREDIT_CARDS.Rows.Count;
											foreach ( DataRow rowCREDIT_CARD in dtCREDIT_CARDS.Rows )
											{
												Guid gCREDIT_CARD_ID = Sql.ToGuid(rowCREDIT_CARD["ID"]);
												try
												{
													// 04/30/2016 Paul.  Require the Application so that we can get the base currency. 
													Currency cUS_DOLLARS = new Currency();
													Guid gCURRENCY_ID = cUS_DOLLARS.ID;
													// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
													using ( IDbTransaction trn = Sql.BeginTransaction(con) )
													{
														Guid gID = Guid.Empty;
														string sDESCRIPTION = "Payment on invoice #" + sINVOICE_NUM + " at " + DateTime.Now.ToString();
														try
														{
															// 08/06/2009 Paul.  PAYMENT_NUM now uses our number sequence table. 
															// 08/26/2010 Paul.  We need a bank fee field to allow for a difference between allocated and received payment. 
															// 05/07/2013 Paul.  Add Contacts field to support B2C. 
															SqlProcs.spPAYMENTS_Update
																( ref gID
																, Guid.Empty  // gASSIGNED_USER_ID
																, gACCOUNT_ID
																, DateTime.Now
																, "Credit Card"
																, String.Empty  // sCUSTOMER_REFERENCE
																, cUS_DOLLARS.CONVERSION_RATE
																, gCURRENCY_ID
																, dAMOUNT
																, sDESCRIPTION
																, gCREDIT_CARD_ID
																, String.Empty  // PAYMENT_NUM
																, Guid.Empty    // TEAM_ID
																, String.Empty  // TEAM_SET_LIST
																, Decimal.Zero  // BANK_FEE
																, gB2C_CONTACT_ID
																// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
																, String.Empty  // ASSIGNED_SET_LIST
																, trn
																);
															// 06/19/2008 Paul.  The payment needs to be manually assigned to the invoice. 
															Guid gINVOICES_PAYMENT_ID = Guid.Empty;
															SqlProcs.spINVOICES_PAYMENTS_Update
																( ref gINVOICES_PAYMENT_ID
																, gINVOICE_ID
																, gID
																, dAMOUNT
																, trn
																);
															trn.Commit();
														}
														catch(Exception ex1)
														{
															trn.Rollback();
															throw(new Exception(ex1.Message, ex1.InnerException));
														}
														try
														{
															sSTATUS = String.Empty;
															// 09/13/2013 Paul.  Add support for PayTrace. 
															if ( Sql.ToBoolean(Application["CONFIG.PayTrace.Enabled"]) && !Sql.IsEmptyString(Application["CONFIG.PayTrace.UserName"]) )
															{
																try
																{
																	sSTATUS = PayTraceUtils.Charge(gCURRENCY_ID, gINVOICE_ID, gID, gCREDIT_CARD_ID, String.Empty, sINVOICE_NAME);
																}
																catch(Exception ex1)
																{
																	// 09/13/2013 Paul.  Catch the exception and long the error, but continue processing the next credit card. 
																	string sError = ex1.Message + ControlChars.CrLf + "PayTraceUtils.Charge(" + gCONTACT_ID.ToString() + ", " + gINVOICE_ID.ToString() + ", " + gID.ToString() + ", " + gCREDIT_CARD_ID.ToString() + ")";
																	sError += ControlChars.CrLf + ex1.StackTrace;
																	SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
																	sSTATUS = "Failed";
																}
																if ( sSTATUS == "Denied" || sSTATUS == "Expired" || sSTATUS == "Failed" )
																	continue;
																break;
															}
															// 12/16/2013 Paul.  Add support for Authorize.Net
															else if ( Sql.ToBoolean(Application["CONFIG.AuthorizeNet.Enabled"]) && !Sql.IsEmptyString(Application["CONFIG.AuthorizeNet.UserName"]) )
															{
																try
																{
																	sSTATUS = AuthorizeNetUtils.Charge(gCURRENCY_ID, gINVOICE_ID, gID, gCREDIT_CARD_ID, String.Empty, sINVOICE_NAME);
																}
																catch(Exception ex1)
																{
																	// 09/13/2013 Paul.  Catch the exception and long the error, but continue processing the next credit card. 
																	string sError = ex1.Message + ControlChars.CrLf + "AuthorizeNetUtils.Charge(" + gCONTACT_ID.ToString() + ", " + gINVOICE_ID.ToString() + ", " + gID.ToString() + ", " + gCREDIT_CARD_ID.ToString() + ")";
																	sError += ControlChars.CrLf + ex1.StackTrace;
																	SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
																	sSTATUS = "Failed";
																}
																if ( sSTATUS == "Denied" || sSTATUS == "Expired" || sSTATUS == "Failed" )
																	continue;
																break;
															}
															// 08/16/2015 Paul.  Add CARD_TOKEN for use with PayPal REST API. 
															// 12/17/2015 Paul.  Accessing the config values directly follows the above patterns. 
															//else if ( !Sql.IsEmptyString(PayPalCache.PayPalClientID(Application)) && !Sql.IsEmptyString(PayPalCache.PayPalClientSecret(Application)) )
															else if ( !Sql.IsEmptyString(Application["CONFIG.PayPal.ClientID"]) && !Sql.IsEmptyString(Application["CONFIG.PayPal.ClientSecret"]) )
															{
																try
																{
																	sSTATUS = PayPalRest.Charge(gCURRENCY_ID, gCONTACT_ID, gINVOICE_ID, gID, gCREDIT_CARD_ID);
																}
																catch(Exception ex1)
																{
																	string sError = ex1.Message + ControlChars.CrLf + "PayPalRest.Charge(" + gCONTACT_ID.ToString() + ", " + gINVOICE_ID.ToString() + ", " + gID.ToString() + ", " + gCREDIT_CARD_ID.ToString() + ")";
																	sError += ControlChars.CrLf + ex1.StackTrace;
																	SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
																	sSTATUS = "Failed";
																}
																if ( sSTATUS == "Denied" || sSTATUS == "Expired" || sSTATUS == "Failed" )
																	continue;
																break;
															}
															else
															{
																// 01/08/2011 Paul.  Catch exceptions but continue processing. 
																// 07/26/2023 Paul.  No longer going to support DotNetCharge. 
																/*
																try
																{
																	// 09/13/2013 Paul.  Add Contacts field to support B2C. 
																	if ( Sql.IsEmptyString(gACCOUNT_ID) )
																		sSTATUS = SplendidCharge.CC.Charge(Application, gID, gCURRENCY_ID, gB2C_CONTACT_ID, gCREDIT_CARD_ID, String.Empty, sINVOICE_NUM, sDESCRIPTION, dAMOUNT);
																	else
																		sSTATUS = SplendidCharge.CC.Charge(Application, gID, gCURRENCY_ID, gACCOUNT_ID, gCREDIT_CARD_ID, String.Empty, sINVOICE_NUM, sDESCRIPTION, dAMOUNT);
																}
																catch(Exception ex1)
																{
																	// 12/16/2008 Paul.  Catch the exception and long the error, but continue processing the next credit card. 
																	string sError = ex1.Message + ControlChars.CrLf + "SplendidCharge.CC.Charge(" + gACCOUNT_ID.ToString() + ", " + gINVOICE_ID.ToString() + ", " + gID.ToString() + ", " + gCREDIT_CARD_ID.ToString() + ")";
																	// 11/15/2009 Paul.  Include the stack trace to help locate the problem. 
																	sError += ControlChars.CrLf + ex1.StackTrace;
																	SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
																	sSTATUS = "Failed";
																}
																if ( sSTATUS == "Success" )
																	break;
																*/
															}
														}
														catch(Exception ex1)
														{
															throw(new Exception(ex1.Message, ex1.InnerException));
														}
													}
												}
												catch(Exception ex)
												{
													SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
												}
											}
											// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												Guid gQUEUE_ID = Guid.Empty;
												Guid gPAYMENT_TEMPLATE_ID = Guid.Empty;
												try
												{
													if ( sSTATUS == "Success" )
													{
														gPAYMENT_TEMPLATE_ID = Sql.ToGuid(Application["CONFIG.Billing Receipt Template ID"]);
														SqlProcs.spEMAILS_QueueEmailTemplate(ref gQUEUE_ID, sBILLING_INVOICE_FROM_EMAIL, sBILLING_INVOICE_FROM_NAME, "Invoices", gINVOICE_ID, gPAYMENT_TEMPLATE_ID, trn);
													}
													else
													{
														cmd.Parameters.Clear();
														// 09/27/2008 Paul.  On failure, change status of invoice to Under Review. 
														// 10/04/2009 Paul.  The stage must be part of the transaction, otherwise an exception will get thrown. 
														SqlProcs.spINVOICES_UpdateStage(gINVOICE_ID, "Under Review", trn);
													}
													trn.Commit();
												}
												catch(Exception ex1)
												{
													trn.Rollback();
													throw(new Exception(ex1.Message, ex1.InnerException));
												}
											}
										}
									}
								}
							}
						}
					}
				}
				catch(Exception ex)
				{
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				}
				finally
				{
					bInsideProcessPending = false;
				}
			}
		}
	}
}
