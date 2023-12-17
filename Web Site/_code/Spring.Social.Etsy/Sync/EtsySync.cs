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
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Web;
using System.Net;
using System.Threading;
using System.Threading.Tasks;
using System.Diagnostics;
using SplendidCRM;

using Microsoft.Extensions.Caching.Memory;

namespace Spring.Social.Etsy
{
	public class EtsySync
	{
		private IMemoryCache         Cache              ;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private ExchangeSecurity     ExchangeSecurity   ;
		private SyncError            SyncError          ;

		public  static bool bInsideSyncAll      = false;
		public  static bool bInsideItems        = false;
		public  static bool bInsideCustomers    = false;
		public  static bool bInsideInvoices     = false;

		public EtsySync(IMemoryCache memoryCache, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, ExchangeSecurity ExchangeSecurity, SyncError SyncError)
		{
			this.Cache               = memoryCache        ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.SyncError           = SyncError          ;
		}

		public bool EtsyEnabled()
		{
			bool bEtsyEnabled = Sql.ToBoolean(Application["CONFIG.Etsy.Enabled"]);
#if DEBUG
			//bEtsyEnabled = true;
#endif
			if ( bEtsyEnabled )
			{
				string sClientID         = Sql.ToString(Application["CONFIG.Etsy.ClientID"        ]);
				string sOAuthAccessToken = Sql.ToString(Application["CONFIG.Etsy.OAuthAccessToken"]);
				bEtsyEnabled = !Sql.IsEmptyString(sOAuthAccessToken) && !Sql.IsEmptyString(sClientID);
			}
			return bEtsyEnabled;
		}

		public Guid EtsyUserID()
		{
			Guid gEtsy_USER_ID = Sql.ToGuid(Application["CONFIG.Etsy.UserID"]);
			if ( Sql.IsEmptyGuid(gEtsy_USER_ID) )
				gEtsy_USER_ID = new Guid("00000000-0000-0000-0000-000000000013");  // Use special Etsy user. 
			return gEtsy_USER_ID;
		}

		public Spring.Social.Etsy.Api.IEtsy CreateApi()
		{
			Spring.Social.Etsy.Api.IEtsy Etsy = null;
			string sEtsyShopID       = Sql.ToString(Application["CONFIG.Etsy.ShopID"          ]);
			string sEtsyClientID     = Sql.ToString(Application["CONFIG.Etsy.ClientID"        ]);
			string sEtsyClientSecret = Sql.ToString(Application["CONFIG.Etsy.ClientSecret"    ]);
			string sOAuthAccessToken    = Sql.ToString(Application["CONFIG.Etsy.OAuthAccessToken"]);
			
			Spring.Social.Etsy.Connect.EtsyServiceProvider EtsyServiceProvider = new Spring.Social.Etsy.Connect.EtsyServiceProvider(sEtsyShopID, sEtsyClientID, sEtsyClientSecret);
			Etsy = EtsyServiceProvider.GetApi(sOAuthAccessToken);
			return Etsy;
		}

		public bool RefreshAccessToken(StringBuilder sbErrors)
		{
			bool bSuccess = false;
			string sEtsyShopID        = Sql.ToString(Application["CONFIG.Etsy.ShopID"           ]);
			string sEtsyClientID      = Sql.ToString(Application["CONFIG.Etsy.ClientID"         ]);
			string sEtsyClientSecret  = Sql.ToString(Application["CONFIG.Etsy.ClientSecret"     ]);
			string sOAuthAccessToken  = Sql.ToString(Application["CONFIG.Etsy.OAuthAccessToken" ]);
			string sOAuthRefreshToken = Sql.ToString(Application["CONFIG.Etsy.OAuthRefreshToken"]);
			//string sOAuthExpiresAt              = Sql.ToString(Application["CONFIG.Etsy.OAuthExpiresAt"   ]);
			try
			{
				// 03/12/2022 Paul.  Instead of trying to track the expiration, just request a new access token every time. 
				DateTime dtOAuthExpiresAt = DateTime.MinValue;
				// 03/12/2022 Paul.  Need to make sure that a new token is retrieved even if values are null or date has expired. 
				if ( Sql.IsEmptyString(sOAuthAccessToken) || dtOAuthExpiresAt == DateTime.MinValue ||  DateTime.Now.AddHours(1) > dtOAuthExpiresAt )
				{
					Spring.Social.Etsy.Connect.EtsyServiceProvider EtsyServiceProvider = new Spring.Social.Etsy.Connect.EtsyServiceProvider(sEtsyShopID, sEtsyClientID, sEtsyClientSecret);
					Spring.Social.OAuth2.OAuth2Parameters parameters = new Spring.Social.OAuth2.OAuth2Parameters();
					EtsyServiceProvider.OAuthOperations.RefreshAccessAsync(sOAuthRefreshToken, parameters)
						.ContinueWith<Spring.Social.OAuth2.AccessGrant>(task =>
						{
							if ( task.Status == System.Threading.Tasks.TaskStatus.RanToCompletion && task.Result != null )
							{
								DateTime dtExpires = (task.Result.ExpireTime.HasValue ? task.Result.ExpireTime.Value.ToLocalTime() : DateTime.Now.AddHours(8));
								sOAuthAccessToken  = task.Result.AccessToken     ;
								sOAuthRefreshToken = task.Result.RefreshToken    ;
								//sOAuthExpiresAt    = dtExpires.ToShortDateString() + " " + dtExpires.ToShortTimeString();
							}
							else
							{
								// 03/12/2022 Paul.  If there is an error, clear the in-memory value only. We want to allow a retry. 
								Application["CONFIG.Etsy.OAuthAccessToken"] = String.Empty;
								throw(new Exception("Could not refresh Etsy access token.", task.Exception));
							}
							return null;
						}).Wait();
					SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								Application["CONFIG.Etsy.OAuthAccessToken"  ] = sOAuthAccessToken ;
								Application["CONFIG.Etsy.OAuthRefreshToken" ] = sOAuthRefreshToken;
								//Application["CONFIG.Etsy.OAuthExpiresAt"    ] = sOAuthExpiresAt   ;
								SqlProcs.spCONFIG_Update("system", "Etsy.OAuthAccessToken"  , Sql.ToString(Application["CONFIG.Etsy.OAuthAccessToken"  ]), trn);
								SqlProcs.spCONFIG_Update("system", "Etsy.OAuthRefreshToken" , Sql.ToString(Application["CONFIG.Etsy.OAuthRefreshToken" ]), trn);
								//SqlProcs.spCONFIG_Update("system", "Etsy.OAuthExpiresAt"    , Sql.ToString(Application["CONFIG.Etsy.OAuthExpiresAt"    ]), trn);
								trn.Commit();
								bSuccess = true;
							}
							catch
							{
								trn.Rollback();
								throw;
							}
						}
					}
				}
				
			}
			catch(Exception ex)
			{
				sbErrors.Append(Utils.ExpandException(ex));
			}
			return bSuccess;
		}

		private bool ValidateEtsy(Spring.Social.Etsy.Api.IEtsy Etsy)
		{
			IList<Spring.Social.Etsy.Api.Product> products = Etsy.ProductOperations.GetModified(DateTime.MinValue);
#if DEBUG
			if ( products != null )
			{
				foreach ( Spring.Social.Etsy.Api.Product product in products )
				{
					Debug.WriteLine(product.ToString());
				}
			}
#endif
/*
			IList<Spring.Social.Etsy.Api.Customer> customers = Etsy.CustomerOperations.GetModified(DateTime.MinValue);
#if DEBUG
			if ( customers != null )
			{
				foreach ( Spring.Social.Etsy.Api.Customer customer in customers )
				{
					Debug.WriteLine(customer.ToString());
				}
			}
#endif
			IList<Spring.Social.Etsy.Api.Order> orders = Etsy.OrderOperations.GetModified(DateTime.MinValue);
#if DEBUG
			if ( orders != null )
			{
				foreach ( Spring.Social.Etsy.Api.Order order in orders )
				{
					Debug.WriteLine(order.ToString());
				}
			}
#endif
*/
			return true;
		}

		public bool ValidateEtsy(string sShopName, string sOAuthClientID, string sOAuthClientSecret, string sOAuthAccessToken, StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
					HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create("https://api.etsy.com/v3/application/openapi-ping");
					objRequest.Headers.Add("cache-control", "no-cache");
					objRequest.Headers.Add("x-api-key", sOAuthClientID);
					objRequest.KeepAlive         = false;
					objRequest.AllowAutoRedirect = false;
					objRequest.Timeout           = 12000;  // 12 seconds
					objRequest.Method            = "GET";
					string sResponse = String.Empty;
					using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
					{
						if ( objResponse != null )
						{
							if ( objResponse.StatusCode != HttpStatusCode.OK && objResponse.StatusCode != HttpStatusCode.Found )
							{
								throw(new Exception(objResponse.StatusCode + " " + objResponse.StatusDescription));
							}
							else
							{
								using ( StreamReader stm = new StreamReader(objResponse.GetResponseStream()) )
								{
									sResponse = stm.ReadToEnd();
									Debug.WriteLine(sResponse);
								}
							}
						}
					}
				
				Spring.Social.Etsy.Api.IEtsy Etsy = null;
				Spring.Social.Etsy.Connect.EtsyServiceProvider EtsyServiceProvider = new Spring.Social.Etsy.Connect.EtsyServiceProvider(sShopName, sOAuthClientID, sOAuthClientSecret);
				Etsy = EtsyServiceProvider.GetApi(sOAuthAccessToken);
				bValidSource = ValidateEtsy(Etsy);
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			return bValidSource;
		}

		public bool ValidateEtsy(StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Spring.Social.Etsy.Api.IEtsy Etsy = this.CreateApi();
				bValidSource = ValidateEtsy(Etsy);
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			return bValidSource;
		}

#pragma warning disable CS1998
		public async ValueTask Sync(CancellationToken token)
		{
			Sync();
		}
#pragma warning restore CS1998

		public void Sync()
		{
			Sync(false);
		}

#pragma warning disable CS1998
		public async ValueTask SyncAll(CancellationToken token)
		{
			SyncAll();
		}
#pragma warning restore CS1998

		public void SyncAll()
		{
			Sync(true);
		}

		public void Sync(bool bSyncAll)
		{
			// 02/06/2014 Paul.  New Etsy factory to allow Remote and Online. 
			bool bEtsyEnabled = EtsyEnabled();
			if ( !bInsideSyncAll && bEtsyEnabled )
			{
				bInsideSyncAll = true;
				try
				{
					StringBuilder sbErrors = new StringBuilder();

					string sOAuthAccessToken = Sql.ToString(Application["CONFIG.Etsy.OAuthAccessToken"]);
					string sOAuthExpiresAt   = Sql.ToString(Application["CONFIG.Etsy.OAuthExpiresAt"  ]);
					if ( !Sql.IsEmptyString(sOAuthAccessToken) )
					{
						DateTime dtOAuthExpiresAt = Sql.ToDateTime(sOAuthExpiresAt);
						// 04/27/2015 Paul.  We need to reconnect when within a 30-day window of expiration. 
						// 09/09/2015 Paul.  Need to make sure that a new token is retrieved even if values are null or date has expired. 
						if ( DateTime.Now.AddDays(15) > dtOAuthExpiresAt )
						{
							this.RefreshAccessToken(sbErrors);
							if ( sbErrors.Length > 0 )
							{
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "Failed to reconnect Etsy Online Access Token: " + sbErrors.ToString());
								// 04/27/2015 Paul.  If there is an error, clear the in-memory value only. We want to allow a retry. 
								Application["CONFIG.Etsy.OAuthAccessToken"] = String.Empty;
								return;
							}
						}
					
						Guid gETSY_USER_ID = this.EtsyUserID();
						Etsy.UserSync User = new Etsy.UserSync(Session, Security, SplendidError, ExchangeSecurity, SyncError, this, gETSY_USER_ID, bSyncAll);
						Sync(User, sbErrors);
					}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
				finally
				{
					bInsideSyncAll = false;
				}
			}
		}

		private DateTime DefaultCacheExpiration()
		{
			return DateTime.Now.AddHours(12);
		}

		#region Sync individual modules
		public void SyncItems(Object sender)
		{
			Etsy.UserSync User = sender as Etsy.UserSync;
			if ( User != null )
			{
				try
				{
					if ( EtsyEnabled() )
					{
						Spring.Social.Etsy.Api.IEtsy Etsy = this.CreateApi();
						if ( Etsy != null )
						{
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( IDbConnection con = dbf.CreateConnection() )
							{
								con.Open();
								Etsy.Item item = new Etsy.Item(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, Etsy, SplendidCache.ProductTypes());
								if ( !bInsideItems )
								{
									try
									{
										bInsideItems = true;
										StringBuilder sbErrors = new StringBuilder();
										Sync(dbf, con, User, item, sbErrors);
										Cache.Remove("Etsy.Items");
									}
									finally
									{
										bInsideItems = false;
									}
								}
							}
						}
					}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
			}
		}

		public void SyncCustomers(Object sender)
		{
			Etsy.UserSync User = sender as Etsy.UserSync;
			if ( User != null )
			{
				try
				{
					if ( EtsyEnabled() )
					{
						Spring.Social.Etsy.Api.IEtsy Etsy = this.CreateApi();
						if ( Etsy != null )
						{
							bool bShortStateName   = Sql.ToBoolean(Application["CONFIG.GoogleMaps.ShortStateName"     ]);
							bool bShortCountryName = Sql.ToBoolean(Application["CONFIG.GoogleMaps.ShortCountryName"   ]);
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( IDbConnection con = dbf.CreateConnection() )
							{
								con.Open();
								using ( DataTable dtCustomers = ACCOUNTS_SYNC(dbf, con, User.USER_ID) )
								{
									Etsy.Customer customer = new Etsy.Customer(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, Etsy, dtCustomers, bShortStateName, bShortCountryName);
									if ( !bInsideCustomers )
									{
										try
										{
											bInsideCustomers = true;
											StringBuilder sbErrors = new StringBuilder();
											Sync(dbf, con, User, customer, sbErrors);
										}
										finally
										{
											bInsideCustomers = false;
										}
									}
								}
							}
						}
					}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
			}
		}

		public void SyncInvoices(Object sender)
		{
			Etsy.UserSync User = sender as Etsy.UserSync;
			if ( User != null )
			{
				try
				{
					if ( EtsyEnabled() )
					{
						Spring.Social.Etsy.Api.IEtsy Etsy = this.CreateApi();
						if ( Etsy != null )
						{
							bool bShortStateName   = Sql.ToBoolean(Application["CONFIG.GoogleMaps.ShortStateName"     ]);
							bool bShortCountryName = Sql.ToBoolean(Application["CONFIG.GoogleMaps.ShortCountryName"   ]);
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( IDbConnection con = dbf.CreateConnection() )
							{
								con.Open();
								using ( DataTable dtCurrencies = CURRENCIES() )
								{
									using ( DataTable dtShippers = SHIPPERS(dbf, con) )
									{
										using ( DataTable dtTaxRates = TAX_RATES_SYNC(dbf, con, User.USER_ID) )
										{
											using ( DataTable dtItems = PRODUCT_TEMPLATES_SYNC(dbf, con, User.USER_ID) )
											{
												using ( DataTable dtCustomers = ACCOUNTS_SYNC(dbf, con, User.USER_ID) )
												{
													using ( DataTable dtPaymentTerms = PAYMENT_TERMS_SYNC(dbf, con, User.USER_ID) )
													{
														string sDiscountAccountId = String.Empty;
														Etsy.Invoice invoice = new Etsy.Invoice(Session, Security, Sql, SqlProcs, SplendidError, ExchangeSecurity, SyncError, Etsy, dtCurrencies, dtShippers, dtTaxRates, dtItems, dtCustomers, dtPaymentTerms, sDiscountAccountId, dbf, con, bShortStateName, bShortCountryName);
														if ( !bInsideInvoices )
														{
															try
															{
																bInsideInvoices = true;
																StringBuilder sbErrors = new StringBuilder();
																Sync(dbf, con, User, invoice, sbErrors);
															}
															finally
															{
																bInsideInvoices = false;
															}
														}
													}
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
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
			}
		}

		#endregion

		#region Sync Tables
		private DataTable SHIPPERS(SplendidCRM.DbProviderFactory dbf, IDbConnection con)
		{
			DataTable dt = new DataTable();
			string sSQL = String.Empty;
			sSQL = "select ID   as SYNC_LOCAL_ID" + ControlChars.CrLf
			     + "     , NAME as SYNC_NAME    " + ControlChars.CrLf
			     + "  from vwSHIPPERS           " + ControlChars.CrLf
			     + " order by NAME              " + ControlChars.CrLf;
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					da.Fill(dt);
				}
			}
			return dt;
		}

		private DataTable TAX_RATES_SYNC(SplendidCRM.DbProviderFactory dbf, IDbConnection con, Guid gUSER_ID)
		{
			DataTable dt = new DataTable();
			string sSQL = String.Empty;
			// 02/26/2015 Paul.  We need to use ETSY_TAX_VENDOR when setting the TaxCodeTaxRate. 
			sSQL = "select SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_KEY                               " + ControlChars.CrLf
			     + "     , ETSY_TAX_VENDOR                         " + ControlChars.CrLf
			     + "  from vwTAX_RATES_SYNC                              " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'EtsyOnline'   " + ControlChars.CrLf
			     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					da.Fill(dt);
				}
			}
			return dt;
		}

		private DataTable PAYMENT_TYPES_SYNC(SplendidCRM.DbProviderFactory dbf, IDbConnection con, Guid gUSER_ID)
		{
			DataTable dt = new DataTable();
			string sSQL = String.Empty;
			sSQL = "select SYNC_NAME                                     " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_KEY                               " + ControlChars.CrLf
			     + "  from vwPAYMENT_TYPES_SYNC                          " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'EtsyOnline'   " + ControlChars.CrLf
			     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					da.Fill(dt);
				}
			}
			return dt;
		}

		private DataTable PAYMENT_TERMS_SYNC(SplendidCRM.DbProviderFactory dbf, IDbConnection con, Guid gUSER_ID)
		{
			DataTable dt = new DataTable();
			string sSQL = String.Empty;
			sSQL = "select SYNC_NAME                                     " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_KEY                               " + ControlChars.CrLf
			     + "  from vwPAYMENT_TERMS_SYNC                          " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'EtsyOnline'   " + ControlChars.CrLf
			     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					da.Fill(dt);
				}
			}
			return dt;
		}

		private DataTable PRODUCT_TEMPLATES_SYNC(SplendidCRM.DbProviderFactory dbf, IDbConnection con, Guid gUSER_ID)
		{
			DataTable dt = new DataTable();
			string sSQL = String.Empty;
			sSQL = "select SYNC_NAME                                     " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_KEY                               " + ControlChars.CrLf
			     + "  from vwPRODUCT_TEMPLATES_SYNC                      " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'EtsyOnline'   " + ControlChars.CrLf
			     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					da.Fill(dt);
				}
			}
			return dt;
		}

		private DataTable CURRENCIES()
		{
			DataTable dt = new DataTable();
			bool bEnableMultiCurrency = Sql.ToBoolean(Application["CONFIG.Etsy.EnableMultiCurrency"]);
			if ( bEnableMultiCurrency )
			{
				dt = SplendidCache.Currencies  ();
			}
			else
			{
				dt = new DataTable();
				dt.Columns.Add("ID"             , Type.GetType("System.Guid"   ));
				dt.Columns.Add("NAME"           , Type.GetType("System.String" ));
				dt.Columns.Add("SYMBOL"         , Type.GetType("System.String" ));
				dt.Columns.Add("NAME_SYMBOL"    , Type.GetType("System.String" ));
				dt.Columns.Add("CONVERSION_RATE", Type.GetType("System.Decimal"));
				dt.Columns.Add("ISO4217"        , Type.GetType("System.String" ));
			}
			return dt;
		}

		private DataTable ACCOUNTS_SYNC(SplendidCRM.DbProviderFactory dbf, IDbConnection con, Guid gUSER_ID)
		{
			DataTable dt = new DataTable();
			string sSQL = String.Empty;
			sSQL = "select SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_KEY                               " + ControlChars.CrLf
			     + "  from vwACCOUNTS_SYNC                               " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'EtsyOnline'   " + ControlChars.CrLf
			     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					da.Fill(dt);
				}
			}
			return dt;
		}

		private DataTable INVOICES_SYNC(SplendidCRM.DbProviderFactory dbf, IDbConnection con, Guid gUSER_ID)
		{
			DataTable dt = new DataTable();
			string sSQL = String.Empty;
			sSQL = "select SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_KEY                               " + ControlChars.CrLf
			     + "  from vwINVOICES_SYNC                               " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'EtsyOnline'   " + ControlChars.CrLf
			     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					da.Fill(dt);
				}
			}
			return dt;
		}
		#endregion

		public void Sync(Etsy.UserSync User, StringBuilder sbErrors)
		{
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.Etsy.VerboseStatus"     ]);
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "EtsySync.Sync Start.");
			
			Spring.Social.Etsy.Api.IEtsy Etsy = this.CreateApi();
			if ( Etsy != null )
			{
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					try
					{
						con.Open();
						
						bool bSyncItems                = true;
						bool bSyncCustomers            = true;
						bool bSyncInvoices             = Sql.ToBoolean(Application["CONFIG.Etsy.SyncInvoices"       ]);
						bool bEnableMultiCurrency      = Sql.ToBoolean(Application["CONFIG.Etsy.EnableMultiCurrency"]);
						bool bShortStateName           = Sql.ToBoolean(Application["CONFIG.GoogleMaps.ShortStateName"     ]);
						bool bShortCountryName         = Sql.ToBoolean(Application["CONFIG.GoogleMaps.ShortCountryName"   ]);
						
						DataTable dtShippers = Cache.Get("Etsy.Shippers") as DataTable;
						if ( dtShippers == null )
						{
							dtShippers = SHIPPERS(dbf, con);
							Cache.Set("Etsy.Shippers", dtShippers, DefaultCacheExpiration());
						}
						
						DataTable dtTaxRates = Cache.Get("Etsy.TaxRates") as DataTable;
						if ( dtTaxRates == null )
						{
							dtTaxRates = TAX_RATES_SYNC(dbf, con, User.USER_ID);
							Cache.Set("Etsy.TaxRates", dtTaxRates, DefaultCacheExpiration());
						}
						
						DataTable dtPaymentTypes = Cache.Get("Etsy.PaymentTypes") as DataTable;
						if ( dtPaymentTypes == null )
						{
							dtPaymentTypes = PAYMENT_TYPES_SYNC(dbf, con, User.USER_ID);
							Cache.Set("Etsy.PaymentTypes", dtPaymentTypes, DefaultCacheExpiration());
						}
						
						DataTable dtPaymentTerms = Cache.Get("Etsy.PaymentTerms") as DataTable;
						if ( dtPaymentTerms == null )
						{
							dtPaymentTerms = PAYMENT_TERMS_SYNC(dbf, con, User.USER_ID);
							Cache.Set("Etsy.PaymentTerms", dtPaymentTerms, DefaultCacheExpiration());
						}
						
						DataTable dtItems = Cache.Get("Etsy.Items") as DataTable;
						Etsy.Item item = new Etsy.Item(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, Etsy, SplendidCache.ProductTypes());
						if ( bSyncItems && (bSyncInvoices) && (dtItems == null || User.SyncAll) )
						{
							if ( !bInsideItems )
							{
								try
								{
									bInsideItems = true;
									Sync(dbf, con, User, item, sbErrors);
								}
								finally
								{
									bInsideItems = false;
								}
							}
							dtItems = PRODUCT_TEMPLATES_SYNC(dbf, con, User.USER_ID);
							Cache.Set("Etsy.Items", dtItems, DefaultCacheExpiration());
						}
						
						// 02/13/2015 Paul.  Default to USD.  vwCurrencies will be empty if using US Etsy Online as it only supports USD. 
						// https://developer.intuit.com/docs/0100_accounting/0300_developer_guides/currency
						DataTable dtCurrencies = null;
						if ( bSyncInvoices )
						{
							dtCurrencies = CURRENCIES();
						}
						
						using ( DataTable dtCustomers = ACCOUNTS_SYNC(dbf, con, User.USER_ID) )
						{
							Etsy.Customer customer = new Etsy.Customer(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, Etsy, dtCustomers, bShortStateName, bShortCountryName);
							if ( bSyncCustomers )
							{
								if ( !bInsideCustomers )
								{
									try
									{
										bInsideCustomers = true;
										Sync(dbf, con, User, customer, sbErrors);
									}
									finally
									{
										bInsideCustomers = false;
									}
								}
							}
							string sDiscountAccountId = String.Empty;
							if ( bSyncInvoices )
							{
								Etsy.Invoice invoice = new Etsy.Invoice(Session, Security, Sql, SqlProcs, SplendidError, ExchangeSecurity, SyncError, Etsy, dtCurrencies, dtShippers, dtTaxRates, dtItems, dtCustomers, dtPaymentTerms, sDiscountAccountId, dbf, con, bShortStateName, bShortCountryName);
								if ( !bInsideInvoices )
								{
									try
									{
										bInsideInvoices = true;
										Sync(dbf, con, User, invoice, sbErrors);
									}
									finally
									{
										bInsideInvoices = false;
									}
								}
							}
						}
					}
					catch(Exception ex)
					{
						SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
						SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
						sbErrors.AppendLine(Utils.ExpandException(ex));
					}
					finally
					{
						if ( bVERBOSE_STATUS )
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "EtsySync.Sync Done.");
					}
				}
			}
		}

		public void Sync(SplendidCRM.DbProviderFactory dbf, IDbConnection con, Etsy.UserSync User, Etsy.QObject qo, StringBuilder sbErrors)
		{
			ExchangeSession Session = ExchangeSecurity.LoadUserACL(User.USER_ID);
			Guid gUSER_ID = User.USER_ID;
			bool bSyncAll = User.SyncAll;
			
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.Etsy.VerboseStatus"     ]);
			string sCONFLICT_RESOLUTION = Sql.ToString (Application["CONFIG.Etsy.ConflictResolution"]);
			string sDIRECTION           = Sql.ToString (Application["CONFIG.Etsy.Direction"         ]);
			// 03/09/2015 Paul.  Establish maximum number of records to process at one time. 
			int    nMAX_RECORDS         = Sql.ToInteger(Application["CONFIG.Etsy.MaxRecords"        ]);
			Guid   gTEAM_ID             = Sql.ToGuid  (Session["TEAM_ID"]);
			if ( sDIRECTION.ToLower().StartsWith("bi") )
				sDIRECTION = "bi-directional";
			else if ( sDIRECTION.ToLower().StartsWith("to crm"  ) || sDIRECTION.ToLower().StartsWith("from quickbooks") )
				sDIRECTION = "to crm only";
			else if ( sDIRECTION.ToLower().StartsWith("from crm") || sDIRECTION.ToLower().StartsWith("to quickbooks"  ) )
				sDIRECTION = "from crm only";
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.EtsyTableName + ".Sync: " + sDIRECTION);
			try
			{
				string sSQL = String.Empty;
				DateTime dtStartModifiedDate = DateTime.MinValue;
				if ( !bSyncAll )
				{
					sSQL = "select max(SYNC_REMOTE_DATE_MODIFIED_UTC)            " + ControlChars.CrLf
					     + "  from vw" + qo.CRMTableName + "_SYNC                " + ControlChars.CrLf
					     + " where SYNC_SERVICE_NAME     = N'EtsyOnline'   " + ControlChars.CrLf
					     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
						DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(cmd.ExecuteScalar());
						if ( dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC > DateTime.MinValue )
							dtStartModifiedDate = dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC.ToLocalTime().AddSeconds(1);
					}
				}
				
				DateTime dtStartSelect = DateTime.Now;
				IList<Spring.Social.Etsy.Api.QBase> lst = qo.SelectModified(dtStartModifiedDate);
				if ( bVERBOSE_STATUS )
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.EtsyTableName + ".Sync: Query took " + (DateTime.Now - dtStartSelect).Seconds.ToString() + " seconds. Using last modified " + dtStartModifiedDate.ToString());
				if ( lst.Count > 0 )
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.EtsyTableName + ".Sync: " + lst.Count.ToString() + " " + qo.EtsyTableName + " to import.");
				// 05/31/2012 Paul.  Sorting should not be necessary as the order of the line items should match the display order. 
				foreach ( Spring.Social.Etsy.Api.QBase qb in lst )
				{
					qo.SetFromEtsy(qb.Id);
					bool bImported = qo.Import(Session, con, gUSER_ID, sDIRECTION, sbErrors);
				}
				
				// 07/03/2014 Paul.  Some of the views exceed 30 characters, so this will not support Oracle. 
				// 01/27/2015 Paul.  View name changed so as to support Oracle. 
				sSQL = "select vw" + qo.CRMTableName + ".*                                                                   " + ControlChars.CrLf
				     + "     , vw" + qo.CRMTableName + "_SYNC.SYNC_ID                                                        " + ControlChars.CrLf
				     + "     , vw" + qo.CRMTableName + "_SYNC.SYNC_REMOTE_KEY                                                " + ControlChars.CrLf
				     + "     , vw" + qo.CRMTableName + "_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC                                   " + ControlChars.CrLf
				     + "     , vw" + qo.CRMTableName + "_SYNC.SYNC_REMOTE_DATE_MODIFIED_UTC                                  " + ControlChars.CrLf
				     + "  from            " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_QBOnline") + "  vw" + qo.CRMTableName + ControlChars.CrLf
				     + "  left outer join vw" + qo.CRMTableName + "_SYNC                                                     " + ControlChars.CrLf
				     + "               on vw" + qo.CRMTableName + "_SYNC.SYNC_SERVICE_NAME     = N'EtsyOnline'         " + ControlChars.CrLf
				     + "              and vw" + qo.CRMTableName + "_SYNC.SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID      " + ControlChars.CrLf
				     + "              and vw" + qo.CRMTableName + "_SYNC.SYNC_LOCAL_ID         = vw" + qo.CRMTableName + ".ID" + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
					ExchangeSecurity.Filter(Session, cmd, gUSER_ID, qo.CRMModuleName, "view");
						
					// 03/28/2010 Paul.  All that is important is that the current date is greater than the last sync date. 
					cmd.CommandText += "   and (    vw" + qo.CRMTableName + "_SYNC.ID is null" + ControlChars.CrLf;
					cmd.CommandText += "         or vw" + qo.CRMTableName + ".DATE_MODIFIED_UTC > vw" + qo.CRMTableName + "_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC" + ControlChars.CrLf;
					/*
					// 03/03/2015 Paul.  Including line item changes in the query is taking way too long. 
					if ( qo.EtsyTableName == "Invoices" )
					{
						Etsy.LineItem qoli = (qo as Etsy.QOrder).CreateLineItem();
						cmd.CommandText += "         or exists (" + ControlChars.CrLf;
						cmd.CommandText += "                    select vw" + qoli.CRMTableName + ".*                                                                     " + ControlChars.CrLf;
						cmd.CommandText += "                         , vw" + qoli.CRMTableName + "_SYNC.SYNC_ID                                                          " + ControlChars.CrLf;
						cmd.CommandText += "                         , vw" + qoli.CRMTableName + "_SYNC.SYNC_REMOTE_KEY                                                  " + ControlChars.CrLf;
						cmd.CommandText += "                         , vw" + qoli.CRMTableName + "_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC                                     " + ControlChars.CrLf;
						cmd.CommandText += "                         , vw" + qoli.CRMTableName + "_SYNC.SYNC_REMOTE_DATE_MODIFIED_UTC                                    " + ControlChars.CrLf;
						cmd.CommandText += "                      from            " + Sql.MetadataName(con, "vw" + qoli.CRMTableName + "_QBOnline") + "  vw" + qoli.CRMTableName + ControlChars.CrLf;
						cmd.CommandText += "                      left outer join vw" + qoli.CRMTableName + "_SYNC                                                       " + ControlChars.CrLf;
						cmd.CommandText += "                                   on vw" + qoli.CRMTableName + "_SYNC.SYNC_SERVICE_NAME     = N'EtsyOnline'           " + ControlChars.CrLf;
						cmd.CommandText += "                                  and vw" + qoli.CRMTableName + "_SYNC.SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID        " + ControlChars.CrLf;
						cmd.CommandText += "                                  and vw" + qoli.CRMTableName + "_SYNC.SYNC_LOCAL_ID         = vw" + qoli.CRMTableName + ".ID" + ControlChars.CrLf;
						cmd.CommandText += "                     where vw" + qoli.CRMTableName + "." + qoli.CRMParentFieldName + " = vw" + qo.CRMTableName + ".ID        " + ControlChars.CrLf;
						cmd.CommandText += "                       and (    vw" + qoli.CRMTableName + "_SYNC.ID is null" + ControlChars.CrLf;
						cmd.CommandText += "                             or vw" + qoli.CRMTableName + ".DATE_MODIFIED_UTC > vw" + qoli.CRMTableName + "_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC" + ControlChars.CrLf;
						cmd.CommandText += "                           )" + ControlChars.CrLf;
						cmd.CommandText += "                   )" + ControlChars.CrLf;
					}
					*/
					cmd.CommandText += "       )" + ControlChars.CrLf;
					if ( !Sql.IsEmptyString(qo.CRMTableSort) )
						cmd.CommandText += " order by vw" + qo.CRMTableName + "." + qo.CRMTableSort + ControlChars.CrLf;
					else
						cmd.CommandText += " order by vw" + qo.CRMTableName + ".DATE_MODIFIED_UTC" + ControlChars.CrLf;
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						using ( DataTable dt = new DataTable() )
						{
							if ( nMAX_RECORDS > 0 )
								Sql.LimitResults(cmd, nMAX_RECORDS);
							da.Fill(dt);
							if ( dt.Rows.Count > 0 && !qo.IsReadOnly )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.EtsyTableName + ".Sync: " + dt.Rows.Count.ToString() + " " + qo.CRMModuleName + " to send.");
							// 02/02/2015 Paul.  TaxRates are read only. 
							for ( int i = 0; i < dt.Rows.Count && !qo.IsReadOnly; i++ )
							{
								DataRow row = dt.Rows[i];
								Guid     gID                             = Sql.ToGuid    (row["ID"                           ]);
								Guid     gASSIGNED_USER_ID               = (qo.CRMAssignedUser ? Sql.ToGuid(row["ASSIGNED_USER_ID"]) : Guid.Empty);
								Guid     gSYNC_ID                        = Sql.ToGuid    (row["SYNC_ID"                      ]);
								string   sSYNC_REMOTE_KEY                = Sql.ToString  (row["SYNC_REMOTE_KEY"              ]);
								DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
								DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
								DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
								string   sSYNC_ACTION                    = Sql.IsEmptyGuid(gSYNC_ID) ? "local new" : "local changed";
#if !DEBUG
								if ( SplendidInit.bEnableACLFieldSecurity )
								{
									bool bApplyACL = false;
									foreach ( DataColumn col in dt.Columns )
									{
										Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, qo.CRMModuleName, col.ColumnName, gASSIGNED_USER_ID);
										if ( !acl.IsReadable() )
										{
											row[col.ColumnName] = DBNull.Value;
											bApplyACL = true;
										}
									}
									if ( bApplyACL )
										dt.AcceptChanges();
								}
#endif
								// 02/01/2014 Paul.  Reset in Sync() not in SetFromCRM. 
								qo.Reset();
								StringBuilder sbChanges = new StringBuilder();
								try
								{
									DataTable dtLineItems = null;
									if ( qo is QOrder )
									{
										qo.LOCAL_ID = gID;
										dtLineItems = (qo as QOrder).GetLineItemsFromCRM(Session, con, gUSER_ID, true);
									}
									if ( sSYNC_ACTION == "local new" || Sql.IsEmptyString(sSYNC_REMOTE_KEY) )
									{
										// 05/18/2012 Paul.  Allow control of sync direction. 
										if (sDIRECTION == "bi-directional" || sDIRECTION == "from crm only" )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.EtsyTableName + ".Sync: Sending new " + qo.EtsyTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
											qo.SetFromCRM(String.Empty, row, sbChanges);
											// 02/7/2015 Paul.  Line items could have changed, so can't use this flag. 
											if ( qo is Etsy.QOrder )
											{
												(qo as Etsy.QOrder).SetLineItemsFromCRM(Session, con, gUSER_ID, sbChanges);
											}
											sSYNC_REMOTE_KEY = qo.Insert();
										}
									}
									else
									{
										if ( bVERBOSE_STATUS )
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.EtsyTableName + ".Sync: Binding " + qo.EtsyTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
											
										try
										{
											qo.Get(sSYNC_REMOTE_KEY);
											// 03/28/2010 Paul.  We need to double-check for conflicts. 
											// 03/26/2011 Paul.  Updated is in local time. 
											DateTime dtREMOTE_DATE_MODIFIED     = qo.TimeModified;
											DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
											// 03/26/2011 Paul.  The Etsy remote date can vary by 1 millisecond, so check for local change first. 
											if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(10) && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
											{
												if ( sCONFLICT_RESOLUTION == "remote" )
												{
													// 03/24/2010 Paul.  Remote is the winner of conflicts. 
													sSYNC_ACTION = "remote changed";
												}
												else if ( sCONFLICT_RESOLUTION == "local" )
												{
													// 03/24/2010 Paul.  Local is the winner of conflicts. 
													sSYNC_ACTION = "local changed";
												}
												// 03/26/2011 Paul.  The Etsy remote date can vary by 1 millisecond, so check for local change first. 
												else if ( dtDATE_MODIFIED_UTC.AddHours(1) > dtREMOTE_DATE_MODIFIED_UTC )
												{
													// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
													sSYNC_ACTION = "local changed";
												}
												else if ( dtREMOTE_DATE_MODIFIED_UTC.AddHours(1) > dtDATE_MODIFIED_UTC )
												{
													// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
													sSYNC_ACTION = "remote changed";
												}
												else
												{
													sSYNC_ACTION = "prompt change";
												}
											}
											if ( qo.Deleted )
											{
												sSYNC_ACTION = "remote deleted";
											}
										}
										catch(Exception ex)
										{
											string sError = "Error retrieving Etsy " + qo.EtsyTableName + " (" + i.ToString() + ") " + Sql.ToString  (row["NAME"]) + "." + ControlChars.CrLf;
											sError += Utils.ExpandException(ex) + ControlChars.CrLf;
											SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
											sbErrors.AppendLine(sError);
											// 02/04/2015 Paul.  If there is an error, don't treat as remote delete, treat as unsync. 
											sSYNC_ACTION = "remote unsync";
										}
										if ( sSYNC_ACTION == "local changed" )
										{
											// 05/18/2012 Paul.  Allow control of sync direction. 
											if (sDIRECTION == "bi-directional" || sDIRECTION == "from crm only" )
											{
												qo.SetFromCRM(sSYNC_REMOTE_KEY, row, sbChanges);
												// 02/7/2015 Paul.  Line items could have changed, so can't use this flag. 
												if ( qo is Etsy.QOrder )
												{
													(qo as Etsy.QOrder).SetLineItemsFromCRM(Session, con, gUSER_ID, sbChanges);
												}
												if ( bVERBOSE_STATUS )
													SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.EtsyTableName + ".Sync: Sending " + qo.EtsyTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ". " + sbChanges.ToString());
												qo.Update();
											}
										}
									}
									if ( sSYNC_ACTION == "local new" || sSYNC_ACTION == "local changed" )
									{
										if ( !Sql.IsEmptyString(qo.ID) )
										{
											// 03/25/2010 Paul.  Update the modified date after the save. 
											// 03/26/2011 Paul.  Updated is in local time. 
											DateTime dtREMOTE_DATE_MODIFIED     = qo.TimeModified;
											DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													// 03/26/2010 Paul.  Make sure to set the Sync flag. 
													// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
													// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
													if ( qo is QOrder && dtLineItems != null )
													{
														if ( sSYNC_ACTION == "local changed" )
														{
															// 02/19/2015 Paul.  Delete all existing relationships as Etsy may renumber the line items. 
															IDbCommand spSyncLineDelete = SqlProcs.Factory(con, "sp" + qo.CRMTableName + "_LINE_ITEMS_SYNC_Delete");
															spSyncLineDelete.Transaction = trn;
															Sql.SetParameter(spSyncLineDelete, "@MODIFIED_USER_ID", gUSER_ID          );
															Sql.SetParameter(spSyncLineDelete, "@ASSIGNED_USER_ID", gUSER_ID          );
															Sql.SetParameter(spSyncLineDelete, "@SERVICE_NAME"    , "EtsyOnline");
															foreach ( DataRow oLineItem in dtLineItems.Rows )
															{
																Sql.SetParameter(spSyncLineDelete, "@LOCAL_ID"        , Sql.ToGuid  (oLineItem["SYNC_LOCAL_ID"  ]));
																Sql.SetParameter(spSyncLineDelete, "@REMOTE_KEY"      , Sql.ToString(oLineItem["SYNC_REMOTE_KEY"]));
																spSyncLineDelete.ExecuteNonQuery();
															}
														}
														
														IDbCommand spSyncLineUpdate = SqlProcs.Factory(con, "sp" + qo.CRMTableName + "_LINE_ITEMS_SYNC_Update");
														spSyncLineUpdate.Transaction = trn;
														Sql.SetParameter(spSyncLineUpdate, "@MODIFIED_USER_ID"        , gUSER_ID                  );
														Sql.SetParameter(spSyncLineUpdate, "@ASSIGNED_USER_ID"        , gUSER_ID                  );
														Sql.SetParameter(spSyncLineUpdate, "@REMOTE_DATE_MODIFIED"    , dtREMOTE_DATE_MODIFIED    );
														Sql.SetParameter(spSyncLineUpdate, "@REMOTE_DATE_MODIFIED_UTC", dtREMOTE_DATE_MODIFIED_UTC);
														Sql.SetParameter(spSyncLineUpdate, "@SERVICE_NAME"            , "EtsyOnline"        );
														foreach ( QObject oLineItem in (qo as QOrder).LineItems )
														{
															// 03/19/2015 Paul.  A Sales Tax line item is special and may not get a matching Etsy line. 
															if ( !Sql.IsEmptyString(oLineItem.ID) )
															{
																Sql.SetParameter(spSyncLineUpdate, "@LOCAL_ID"                , oLineItem.LOCAL_ID        );
																Sql.SetParameter(spSyncLineUpdate, "@REMOTE_KEY"              , oLineItem.ID              );
																Sql.SetParameter(spSyncLineUpdate, "@RAW_CONTENT"             , oLineItem.RawContent      );
																spSyncLineUpdate.ExecuteNonQuery();
															}
														}
													}
													// 02/19/2015 Paul. Item has not changed, no need to call update procedure. 
													// qo.ProcedureUpdated(gID, sSYNC_REMOTE_KEY, trn, gUSER_ID);
													
													IDbCommand spSyncUpdate = SqlProcs.Factory(con, "sp" + qo.CRMTableName + "_SYNC_Update");
													spSyncUpdate.Transaction = trn;
													Sql.SetParameter(spSyncUpdate, "@MODIFIED_USER_ID"        , gUSER_ID                  );
													Sql.SetParameter(spSyncUpdate, "@ASSIGNED_USER_ID"        , gUSER_ID                  );
													Sql.SetParameter(spSyncUpdate, "@LOCAL_ID"                , gID                       );
													Sql.SetParameter(spSyncUpdate, "@REMOTE_KEY"              , sSYNC_REMOTE_KEY          );
													Sql.SetParameter(spSyncUpdate, "@REMOTE_DATE_MODIFIED"    , dtREMOTE_DATE_MODIFIED    );
													Sql.SetParameter(spSyncUpdate, "@REMOTE_DATE_MODIFIED_UTC", dtREMOTE_DATE_MODIFIED_UTC);
													Sql.SetParameter(spSyncUpdate, "@SERVICE_NAME"            , "EtsyOnline"        );
													Sql.SetParameter(spSyncUpdate, "@RAW_CONTENT"             , qo.RawContent             );
													spSyncUpdate.ExecuteNonQuery();
													trn.Commit();
												}
												catch
												{
													trn.Rollback();
													throw;
												}
											}
										}
									}
									// 02/04/2015 Paul.  If there is an error, don't treat as remote delete, treat as unsync. 
									else if ( sSYNC_ACTION == "remote deleted" || sSYNC_ACTION == "remote unsync" )
									{
										// 08/05/2014 Paul.  Deletes should follow the same direction rules. 
										if (sDIRECTION == "bi-directional" || sDIRECTION == "to crm only" )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.EtsyTableName + ".Sync: Deleting " + qo.CRMTableName + " " + Sql.ToString(row["NAME"]) + ".");
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													// 03/26/2010 Paul.  Make sure to clear the Sync flag. 
													if ( qo is QOrder && dtLineItems != null )
													{
														IDbCommand spSyncLineDelete = SqlProcs.Factory(con, "sp" + qo.CRMTableName + "_LINE_ITEMS_SYNC_Delete");
														spSyncLineDelete.Transaction = trn;
														Sql.SetParameter(spSyncLineDelete, "@MODIFIED_USER_ID", gUSER_ID          );
														Sql.SetParameter(spSyncLineDelete, "@ASSIGNED_USER_ID", gUSER_ID          );
														Sql.SetParameter(spSyncLineDelete, "@SERVICE_NAME"    , "EtsyOnline");
														foreach ( DataRow oLineItem in dtLineItems.Rows )
														{
															Sql.SetParameter(spSyncLineDelete, "@LOCAL_ID"        , Sql.ToGuid  (oLineItem["SYNC_LOCAL_ID"  ]));
															Sql.SetParameter(spSyncLineDelete, "@REMOTE_KEY"      , Sql.ToString(oLineItem["SYNC_REMOTE_KEY"]));
															spSyncLineDelete.ExecuteNonQuery();
														}
													}
													
													IDbCommand spSyncDelete = SqlProcs.Factory(con, "sp" + qo.CRMTableName + "_SYNC_Delete");
													spSyncDelete.Transaction = trn;
													Sql.SetParameter(spSyncDelete, "@MODIFIED_USER_ID", gUSER_ID        );
													Sql.SetParameter(spSyncDelete, "@ASSIGNED_USER_ID", gUSER_ID        );
													Sql.SetParameter(spSyncDelete, "@LOCAL_ID"        , gID             );
													Sql.SetParameter(spSyncDelete, "@REMOTE_KEY"      , sSYNC_REMOTE_KEY);
													Sql.SetParameter(spSyncDelete, "@SERVICE_NAME"    , "Etsy"    );
													spSyncDelete.ExecuteNonQuery();
													
													// 02/04/2015 Paul.  If there is an error, don't treat as remote delete, treat as unsync. 
													if ( sSYNC_ACTION == "remote deleted" )
													{
														IDbCommand spDelete = SqlProcs.Factory(con, "sp" + qo.CRMTableName + "_Delete");
														spDelete.Transaction = trn;
														Sql.SetParameter(spDelete, "@ID"              , gID           );
														Sql.SetParameter(spDelete, "@MODIFIED_USER_ID", gUSER_ID      );
														spDelete.ExecuteNonQuery();
													}
													trn.Commit();
												}
												catch
												{
													trn.Rollback();
													throw;
												}
											}
										}
									}
								}
								catch(Exception ex)
								{
									// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
									string sError = "Error creating Etsy " + qo.EtsyTableName + " (" + i.ToString() + ") " + Sql.ToString  (row["NAME"]) + "." + ControlChars.CrLf;
									sError += sbChanges.ToString();
									sError += Utils.ExpandException(ex) + ControlChars.CrLf;
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									//SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									sbErrors.AppendLine(sError);
								}
							}
						}
					}
				}
				
				// 02/06/2015 Paul.  Deleted records will not be returned by the standard query, so we need a special query to look for sync'd records that are no longer availab.e 
				if ( !qo.IsReadOnly )
				{
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = String.Empty;
						cmd.CommandTimeout = 0;
						cmd.CommandText += "select SYNC_ID                                                       " + ControlChars.CrLf;
						cmd.CommandText += "     , SYNC_LOCAL_ID                                                 " + ControlChars.CrLf;
						cmd.CommandText += "     , SYNC_REMOTE_KEY                                               " + ControlChars.CrLf;
						cmd.CommandText += "  from            vw" + qo.CRMTableName + "_SYNC                     " + ControlChars.CrLf;
						cmd.CommandText += "  left outer join (select vw" + qo.CRMTableName + ".ID               " + ControlChars.CrLf;
						cmd.CommandText += "                        , vw" + qo.CRMTableName + ".DATE_MODIFIED_UTC" + ControlChars.CrLf;
						cmd.CommandText += "                     from      vw" + qo.CRMTableName                   + ControlChars.CrLf;
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, qo.CRMModuleName, "view");
						cmd.CommandText += "                  ) vw" + qo.CRMTableName + "                                                " + ControlChars.CrLf;
						cmd.CommandText += "               on vw" + qo.CRMTableName + ".ID = vw" + qo.CRMTableName + "_SYNC.SYNC_LOCAL_ID" + ControlChars.CrLf;
						cmd.CommandText += " where SYNC_SERVICE_NAME     = N'EtsyOnline'                   " + ControlChars.CrLf;
						cmd.CommandText += "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID                " + ControlChars.CrLf;
						cmd.CommandText += "   and vw" + qo.CRMTableName + ".ID is null                          " + ControlChars.CrLf;
						cmd.CommandText += " order by vw" + qo.CRMTableName + ".DATE_MODIFIED_UTC                " + ControlChars.CrLf;
						Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.EtsyTableName + ".Sync: " + dt.Rows.Count.ToString() + " " + qo.CRMModuleName + " to delete.");
								for ( int i = 0; i < dt.Rows.Count; i++ )
								{
									DataRow row = dt.Rows[i];
									Guid   gID              = Sql.ToGuid  (row["SYNC_LOCAL_ID"  ]);
									string sSYNC_REMOTE_KEY = Sql.ToString(row["SYNC_REMOTE_KEY"]);
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.EtsyTableName + ".Sync: Deleting EtsyOnline (" + sSYNC_REMOTE_KEY + "), CRM " + qo.CRMModuleName + "(" + gID.ToString() + ").");

									DataTable dtLineItems = null;
									if ( qo is QOrder )
									{
										qo.LOCAL_ID = gID;
										LineItem qoli = (qo as QOrder).CreateLineItem();
										cmd.CommandText = String.Empty;
										cmd.Parameters.Clear();
										cmd.CommandTimeout = 0;
										cmd.CommandText += "select SYNC_ID                                                        " + ControlChars.CrLf;
										cmd.CommandText += "     , SYNC_LOCAL_ID                                                  " + ControlChars.CrLf;
										cmd.CommandText += "     , SYNC_REMOTE_KEY                                                " + ControlChars.CrLf;
										cmd.CommandText += "  from            vw" + qoli.CRMTableName + "_SYNC                    " + ControlChars.CrLf;
										// 03/12/2015 Paul.  Use special Deleted views. 
										cmd.CommandText += "       inner join (select ID                                          " + ControlChars.CrLf;
										cmd.CommandText += "                        , DATE_MODIFIED_UTC                           " + ControlChars.CrLf;
										cmd.CommandText += "                     from vw" + qoli.CRMTableName + "_Deleted         " + ControlChars.CrLf;
										cmd.CommandText += "                    where " + qoli.CRMParentFieldName + " = @PARENT_ID" + ControlChars.CrLf;
										cmd.CommandText += "                  ) vw" + qoli.CRMTableName + "                       " + ControlChars.CrLf;
										cmd.CommandText += "               on vw" + qoli.CRMTableName + ".ID = vw" + qoli.CRMTableName + "_SYNC.SYNC_LOCAL_ID" + ControlChars.CrLf;
										cmd.CommandText += " where SYNC_SERVICE_NAME     = N'EtsyOnline'                    " + ControlChars.CrLf;
										cmd.CommandText += "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID                 " + ControlChars.CrLf;
										cmd.CommandText += " order by vw" + qoli.CRMTableName + ".DATE_MODIFIED_UTC               " + ControlChars.CrLf;
										Sql.AddParameter(cmd, "@PARENT_ID"            , gID     );
										Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
										((IDbDataAdapter)da).SelectCommand = cmd;
										dtLineItems = new DataTable();
										da.Fill(dtLineItems);
									}
									try
									{
										if ( sDIRECTION == "bi-directional" || sDIRECTION == "from crm only" )
										{
											qo.Reset();
											qo.ID = sSYNC_REMOTE_KEY;
											qo.Delete();
										}
									}
									catch(Exception ex)
									{
										string sError = "Error deleting EtsyOnline " + qo.EtsyTableName + " " + sSYNC_REMOTE_KEY + "." + ControlChars.CrLf;
										sError += Utils.ExpandException(ex) + ControlChars.CrLf;
										SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										sbErrors.AppendLine(sError);
									}
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											if ( qo is QOrder && dtLineItems != null )
											{
												IDbCommand spSyncLineDelete = SqlProcs.Factory(con, "sp" + qo.CRMTableName + "_LINE_ITEMS_SYNC_Delete");
												spSyncLineDelete.Transaction = trn;
												Sql.SetParameter(spSyncLineDelete, "@MODIFIED_USER_ID", gUSER_ID          );
												Sql.SetParameter(spSyncLineDelete, "@ASSIGNED_USER_ID", gUSER_ID          );
												Sql.SetParameter(spSyncLineDelete, "@SERVICE_NAME"    , "EtsyOnline");
												foreach ( DataRow oLineItem in dtLineItems.Rows )
												{
													Sql.SetParameter(spSyncLineDelete, "@LOCAL_ID"        , Sql.ToGuid  (oLineItem["SYNC_LOCAL_ID"  ]));
													Sql.SetParameter(spSyncLineDelete, "@REMOTE_KEY"      , Sql.ToString(oLineItem["SYNC_REMOTE_KEY"]));
													spSyncLineDelete.ExecuteNonQuery();
												}
											}
											
											IDbCommand spSyncDelete = SqlProcs.Factory(con, "sp" + qo.CRMTableName + "_SYNC_Delete");
											spSyncDelete.Transaction = trn;
											Sql.SetParameter(spSyncDelete, "@MODIFIED_USER_ID", gUSER_ID          );
											Sql.SetParameter(spSyncDelete, "@ASSIGNED_USER_ID", gUSER_ID          );
											Sql.SetParameter(spSyncDelete, "@LOCAL_ID"        , gID               );
											Sql.SetParameter(spSyncDelete, "@REMOTE_KEY"      , sSYNC_REMOTE_KEY  );
											Sql.SetParameter(spSyncDelete, "@SERVICE_NAME"    , "EtsyOnline");
											spSyncDelete.ExecuteNonQuery();
											trn.Commit();
										}
										catch(Exception ex)
										{
											trn.Rollback();
											string sError = "Error deleting SYNC record " + qo.CRMTableName + " " + gID.ToString() + "." + ControlChars.CrLf;
											sError += Utils.ExpandException(ex) + ControlChars.CrLf;
											SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
											sbErrors.AppendLine(sError);
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
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				sbErrors.AppendLine(Utils.ExpandException(ex));
			}
		}
	}
}
