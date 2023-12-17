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
using System.Xml;
using System.Data;
using System.Data.Common;
using System.Text;
using System.Collections.Generic;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

using ExchangeNotificationService;

namespace SplendidCRM.ExchangeService2007
{
	[ApiController]
	[Produces("application/xml")]
	[Consumes("application/xml")]
	[Route("/ExchangeService2007.asmx")]
	public class ExchangeService2007 : ControllerBase
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private SyncError            SyncError          ;
		private ExchangeSecurity     ExchangeSecurity   ;
		private ExchangeUtils        ExchangeUtils      ;
		private ExchangeSync         ExchangeSync       ;

		public ExchangeService2007(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, SyncError SyncError, ExchangeSecurity ExchangeSecurity, ExchangeUtils ExchangeUtils, ExchangeSync ExchangeSync)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.SyncError           = SyncError          ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.ExchangeUtils       = ExchangeUtils      ;
			this.ExchangeSync        = ExchangeSync       ;
		}

		public class SampleData
		{
			public string   Name      { get; set; }
			public DateTime Now       { get; set; }
			public bool     Male      { get; set; }
			public Decimal  Age       { get; set; }
		}

		[AllowAnonymous]
		[HttpPost("[action]")]
		public SendNotificationResultType SendNotification(SendNotificationResponseType SendNotification1)
		{
			SendNotificationResultType result = new SendNotificationResultType();
			result.SubscriptionStatus = SubscriptionStatusType.OK;
			
			try
			{
				foreach ( ResponseMessageType rmt in SendNotification1.ResponseMessages.Items )
				{
					if ( rmt.ResponseCode != ResponseCodeType.NoError )
					{
						if (  rmt.ResponseCode == ResponseCodeType.ErrorAccessDenied 
						   || rmt.ResponseCode == ResponseCodeType.ErrorAccountDisabled
						   || rmt.ResponseCode == ResponseCodeType.ErrorAddressSpaceNotFound
						   || rmt.ResponseCode == ResponseCodeType.ErrorExpiredSubscription
						   || rmt.ResponseCode == ResponseCodeType.ErrorFolderNotFound
						   || rmt.ResponseCode == ResponseCodeType.ErrorImpersonateUserDenied
						   || rmt.ResponseCode == ResponseCodeType.ErrorImpersonationDenied
						   || rmt.ResponseCode == ResponseCodeType.ErrorImpersonationFailed
						   || rmt.ResponseCode == ResponseCodeType.ErrorInternalServerError
						   )
						{
							result.SubscriptionStatus = SubscriptionStatusType.Unsubscribe;
						}
						SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "ExchangeService2007.SendNotification: " + rmt.ResponseCode.ToString() + " - " + rmt.MessageText);
						SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "ExchangeService2007.SendNotification: " + rmt.ResponseCode.ToString() + " - " + rmt.MessageText);
					}
					
					if ( rmt is SendNotificationResponseMessageType )
					{
						NotificationType notification = (rmt as SendNotificationResponseMessageType).Notification;
						
						// Get the subscription identifier.
						Guid gUSER_ID = Guid.Empty;
						Microsoft.Exchange.WebServices.Data.PushSubscription push = null;
						// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
						ExchangeSync.GetPushSubscription(notification.SubscriptionId, ref push, ref gUSER_ID);
						if ( push == null || Sql.IsEmptyGuid(gUSER_ID) )
						{
							result.SubscriptionStatus = SubscriptionStatusType.Unsubscribe;
							SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "ExchangeService2007.SendNotification: Subscription not found for " + notification.SubscriptionId);
						}
						else
						{
							ExchangeSession Session = ExchangeSecurity.LoadUserACL(gUSER_ID);
							string sEXCHANGE_ALIAS = Sql.ToString(Session["EXCHANGE_ALIAS"]);
							string sEXCHANGE_EMAIL = Sql.ToString(Session["EXCHANGE_EMAIL"]);
							// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
							string sMAIL_SMTPUSER  = Sql.ToString(Session["MAIL_SMTPUSER" ]);
							string sMAIL_SMTPPASS  = Sql.ToString(Session["MAIL_SMTPPASS" ]);
							// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
							Guid   gEXCHANGE_ID    = Guid.Empty;
							if ( Sql.ToBoolean(Session["OFFICE365_OAUTH_ENABLED"]) )
								gEXCHANGE_ID = Sql.ToGuid(Session["USER_ID"]);
							Microsoft.Exchange.WebServices.Data.ExchangeService service = ExchangeUtils.CreateExchangeService(sEXCHANGE_ALIAS, sEXCHANGE_EMAIL, sMAIL_SMTPUSER, sMAIL_SMTPPASS, gEXCHANGE_ID);
							DataTable dtUserFolders = SplendidCache.ExchangeFolders(gUSER_ID);
							DataView vwUserFolders = new DataView(dtUserFolders);
							
							// 04/26/2010 Paul.  Use a separate flag for events as there will be many of these, with lots of them being ignored. 
							bool bVERBOSE_EVENTS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseEvents"]);
							// 03/19/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
							//string sCRM_FOLDER_NAME = Sql.ToString(Application["CONFIG.Exchange.CrmFolderName"]);
							//if ( Sql.IsEmptyString(sCRM_FOLDER_NAME) )
							//	sCRM_FOLDER_NAME = "SplendidCRM";
							// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
							string sCALENDAR_CATEGORY = Sql.ToString(Application["CONFIG.Exchange.Calendar.Category"]);
							string sCONTACTS_CATEGORY = Sql.ToString(Application["CONFIG.Exchange.Contacts.Category"]);
							StringBuilder sbErrors = new StringBuilder();
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( IDbConnection con = dbf.CreateConnection() )
							{
								con.Open();
								foreach ( BaseNotificationEventType evtBase in notification.Items )
								{
									bool bUpdateWatermark = false;
									string sItemID         = String.Empty;
									string sParentFolderId = String.Empty;
									if ( evtBase is MovedCopiedEventType )
									{
										MovedCopiedEventType evt = evtBase as MovedCopiedEventType;
										sParentFolderId = evt.ParentFolderId.Id;
										if ( evt.Item is ItemIdType )
											sItemID = (evt.Item as ItemIdType).Id;
										if ( bVERBOSE_EVENTS )
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ExchangeService2007.SendNotification: MovedCopiedEventType - " + sParentFolderId + ", " + sItemID);
									}
									else if ( evtBase is ModifiedEventType )
									{
										ModifiedEventType evt = evtBase as ModifiedEventType;
										sParentFolderId = evt.ParentFolderId.Id;
										if ( evt.Item is ItemIdType )
											sItemID = (evt.Item as ItemIdType).Id;
										if ( bVERBOSE_EVENTS )
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ExchangeService2007.SendNotification: ModifiedEventType - " + sParentFolderId + ", " + sItemID);
									}
									// 04/22/2010 Paul.  Created events will generate BaseObjectChangedEventType. 
									else if ( evtBase is BaseObjectChangedEventType )
									{
										BaseObjectChangedEventType evt = evtBase as BaseObjectChangedEventType;
										sParentFolderId = evt.ParentFolderId.Id;
										if ( evt.Item is ItemIdType )
											sItemID = (evt.Item as ItemIdType).Id;
										if ( bVERBOSE_EVENTS )
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ExchangeService2007.SendNotification: BaseObjectChangedEventType - " + sParentFolderId + ", " + sItemID);
									}
									else
									{
										if ( bVERBOSE_EVENTS )
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ExchangeService2007.SendNotification: " + evtBase.GetType().FullName);
									}
									if ( !Sql.IsEmptyString(sItemID) && !Sql.IsEmptyString(sParentFolderId) )
									{
										vwUserFolders.RowFilter = "REMOTE_KEY = '" + sParentFolderId + "'";
										if ( vwUserFolders.Count > 0 )
										{
											DataRowView row = vwUserFolders[0];
											string sREMOTE_KEY        = Sql.ToString (row["REMOTE_KEY"       ]);
											string sMODULE_NAME       = Sql.ToString (row["MODULE_NAME"      ]);
											Guid   gPARENT_ID         = Sql.ToGuid   (row["PARENT_ID"        ]);
											string sPARENT_NAME       = Sql.ToString (row["PARENT_NAME"      ]);
											bool   bWELL_KNOWN_FOLDER = Sql.ToBoolean(row["WELL_KNOWN_FOLDER"]);
											if ( bVERBOSE_EVENTS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ExchangeService2007.SendNotification: " + sEXCHANGE_ALIAS + " event in " + sMODULE_NAME + " " + sPARENT_NAME);

											// 04/22/2010 Paul.  We need to get the ItemClass before we attempt to bind the specific type. 
											// http://www.outlookexchange.com/articles/home/outlookobjectmodel.asp
											string sItemClass  = String.Empty;
											try
											{
												Microsoft.Exchange.WebServices.Data.PropertySet setItemClass = new Microsoft.Exchange.WebServices.Data.PropertySet(Microsoft.Exchange.WebServices.Data.ItemSchema.ItemClass, Microsoft.Exchange.WebServices.Data.ItemSchema.Categories);
												Microsoft.Exchange.WebServices.Data.Item item = null;
												try
												{
													// 03/27/2013 Paul.  Item may have moved to a different folder before we get a chance to process, so just ignore the "The specified object was not found in the store" error. 
													item = Microsoft.Exchange.WebServices.Data.Item.Bind(service, sItemID, setItemClass);
												}
												catch
												{
												}
												if ( item != null )
												{
													sItemClass  = item.ItemClass;
													if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Contacts" && sItemClass == "IPM.Contact" )
													{
														// 04/07/2010 Paul.  The subscription means that we will get a change event for all items, 
														// so we need to make sure and filter only those that are marked as SplendidCRM. 
														// 03/19/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
														// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
														if ( Sql.IsEmptyString(sCONTACTS_CATEGORY) || item.Categories.Contains(sCONTACTS_CATEGORY) )
														{
															Microsoft.Exchange.WebServices.Data.Contact contact = Microsoft.Exchange.WebServices.Data.Contact.Bind(service, sItemID);
															// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
															ExchangeSync.ImportContact(Session, service, con, sEXCHANGE_ALIAS, gUSER_ID, contact, sbErrors);
															bUpdateWatermark = true;
														}
													}
													else if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Calendar" && sItemClass == "IPM.Appointment" )
													{
														// 04/07/2010 Paul.  The subscription means that we will get a change event for all items, 
														// so we need to make sure and filter only those that are marked as SplendidCRM. 
														// 03/19/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
														// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
														if ( Sql.IsEmptyString(sCALENDAR_CATEGORY) || item.Categories.Contains(sCALENDAR_CATEGORY) )
														{
															// 03/26/2013 Paul.  When an appointment is created using Outlook Web Access, it seems to create and delete multiple records. 
															// A few others have reported this problem and it only seems to happen with appointments. 
															Microsoft.Exchange.WebServices.Data.Appointment appointment = null;
															try
															{
																// 11/03/2014 Paul.  This call should be the same as above as the FirstClassProperties should be used.  But keep as a separate call to minimize changes. 
																appointment = Microsoft.Exchange.WebServices.Data.Appointment.Bind(service, sItemID);
																// 11/03/2014 Paul.  Get body as plain text. 
																if ( Sql.ToBoolean(Application["CONFIG.Exchange.Appointment.PlainText"]) )
																{
																	Microsoft.Exchange.WebServices.Data.PropertySet psPlainText = new Microsoft.Exchange.WebServices.Data.PropertySet(Microsoft.Exchange.WebServices.Data.BasePropertySet.FirstClassProperties, Microsoft.Exchange.WebServices.Data.AppointmentSchema.Body);
																	psPlainText.RequestedBodyType = Microsoft.Exchange.WebServices.Data.BodyType.Text;
																	// 11/18/2014 Paul.  We are not getting the full item here, so just grab the body. 
																	try
																	{
																		Microsoft.Exchange.WebServices.Data.Appointment appointment1 = Microsoft.Exchange.WebServices.Data.Appointment.Bind(service, sItemID, psPlainText);
																		appointment.Body.BodyType = appointment1.Body.BodyType;
																		appointment.Body.Text     = appointment1.Body.Text    ;
																		//SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sItemID + ControlChars.CrLf + "BodyText: " + appointment.Body.Text);
																	}
																	catch(Exception ex)
																	{
																		string sError = "ExchangeService2007.SendNotification: ";
																		sError += Utils.ExpandException(ex) + ControlChars.CrLf;
																		sError += "Error retrieving BodyText " + sREMOTE_KEY + " for " + sEXCHANGE_ALIAS + ". " + ControlChars.CrLf;
																		SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
																	}
																}
															}
															catch
															{
															}
															// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
															if ( appointment != null )
																ExchangeSync.ImportAppointment(Session, service, con, sEXCHANGE_ALIAS, gUSER_ID, appointment, sbErrors);
															bUpdateWatermark = true;
														}
													}
													else if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Sent Items" && sItemClass == "IPM.Note" )
													{
														Microsoft.Exchange.WebServices.Data.EmailMessage email = Microsoft.Exchange.WebServices.Data.EmailMessage.Bind(service, sItemID);
														// 03/11/2012 Paul.  Sent Items first need to be processed before the message can be imported. 
														ExchangeSync.ImportSentItem(Session, con, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
														bUpdateWatermark = true;
													}
													// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
													else if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Inbox" && sItemClass == "IPM.Note" )
													{
														Microsoft.Exchange.WebServices.Data.EmailMessage email = Microsoft.Exchange.WebServices.Data.EmailMessage.Bind(service, sItemID);
														// 07/05/2017 Paul.  Sent Items first need to be processed before the message can be imported. 
														ExchangeSync.ImportInbox(Session, con, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
														bUpdateWatermark = true;
													}
													else if ( sItemClass == "IPM.Note" )
													{
														Microsoft.Exchange.WebServices.Data.EmailMessage email = Microsoft.Exchange.WebServices.Data.EmailMessage.Bind(service, sItemID);
														// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
														ExchangeSync.ImportMessage(Session, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
														bUpdateWatermark = true;
													}
												}
											}
											catch(Exception ex)
											{
												string sError = "ExchangeService2007.SendNotification: Error retrieving " + sREMOTE_KEY + " for " + sEXCHANGE_ALIAS + ". " + ControlChars.CrLf;
												sError += "ItemClass = " + sItemClass + ". " + ControlChars.CrLf;
												sError += Utils.ExpandException(ex) + ControlChars.CrLf;
												SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
												sbErrors.AppendLine(sError);
											}
										}
										if ( bUpdateWatermark )
										{
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													SqlProcs.spEXCHANGE_USERS_UpdateWatermark(gUSER_ID, evtBase.Watermark, trn);
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
							}
						}
					}
				}
				// 04/26/2010 Paul.  If there was an error and we are going to Unsubscribe, then we need to remove from our subscription dictionary. 
				// We are doing this after processing any data that we have received. 
				if ( result.SubscriptionStatus == SubscriptionStatusType.Unsubscribe )
				{
					foreach ( ResponseMessageType rmt in SendNotification1.ResponseMessages.Items )
					{
						if ( rmt is SendNotificationResponseMessageType )
						{
							NotificationType notification = (rmt as SendNotificationResponseMessageType).Notification;
							
							Guid gUSER_ID = Guid.Empty;
							Microsoft.Exchange.WebServices.Data.PushSubscription push = null;
							// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
							ExchangeSync.GetPushSubscription(notification.SubscriptionId, ref push, ref gUSER_ID);
							if ( !Sql.IsEmptyGuid(gUSER_ID) )
							{
								// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
								ExchangeSync.StopPushSubscription(gUSER_ID);
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
			return result;
		}
	}
}
