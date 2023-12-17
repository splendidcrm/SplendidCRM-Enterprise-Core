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

namespace Spring.Social.QuickBooks
{
	public class QuickBooksSync
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
		public  static bool bInsideTaxRates     = false;
		public  static bool bInsidePaymentTypes = false;
		public  static bool bInsidePaymentTerms = false;
		public  static bool bInsideItems        = false;
		public  static bool bInsideCustomers    = false;
		public  static bool bInsideInvoices     = false;
		public  static bool bInsideEstimates    = false;
		public  static bool bInsidePayments     = false;
		public  static bool bInsideCreditMemos  = false;

		public QuickBooksSync(IMemoryCache memoryCache, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, ExchangeSecurity ExchangeSecurity, SyncError SyncError)
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

		public string PrimarySortField(string sModule)
		{
			string sFieldName = String.Empty;
			string sAppMode   = Sql.ToString(Application["CONFIG.QuickBooks.AppMode"]);
			if ( sAppMode == "Online" )
			{
				switch ( sModule )
				{
					case "Accounts":  sFieldName = "DisplayName";  break;
					case "Invoices":  sFieldName = "DocNumber"  ;  break;
					case "Orders"  :  sFieldName = "DocNumber"  ;  break;
					case "Quotes"  :  sFieldName = "DocNumber"  ;  break;
				}
			}
			else
			{
				switch ( sModule )
				{
					case "Accounts":  sFieldName = "NAME"           ;  break;
					case "Invoices":  sFieldName = "ReferenceNumber";  break;
					case "Orders"  :  sFieldName = "ReferenceNumber";  break;
					case "Quotes"  :  sFieldName = "ReferenceNumber";  break;
				}
			}
			return sFieldName;
		}

		public bool QuickBooksEnabled()
		{
			bool bQuickBooksEnabled = Sql.ToBoolean(Application["CONFIG.QuickBooks.Enabled"]);
#if DEBUG
			//bQuickBooksEnabled = true;
#endif
			if ( bQuickBooksEnabled )
			{
				string sAppMode = Sql.ToString (Application["CONFIG.QuickBooks.AppMode"]);
				if ( sAppMode == "Online" )
				{
					string sOAuthAccessToken       = Sql.ToString(Application["CONFIG.QuickBooks.OAuthAccessToken"      ]);
					string sOAuthAccessTokenSecret = Sql.ToString(Application["CONFIG.QuickBooks.OAuthAccessTokenSecret"]);
					bQuickBooksEnabled = !Sql.IsEmptyString(sOAuthAccessToken) && !Sql.IsEmptyString(sOAuthAccessTokenSecret);
				}
				else
				{
					bQuickBooksEnabled = false;
				}
			}
			return bQuickBooksEnabled;
		}

		public Guid QuickBooksUserID()
		{
			Guid gQUICKBOOKS_USER_ID = Sql.ToGuid(Application["CONFIG.QuickBooks.UserID"]);
			if ( Sql.IsEmptyGuid(gQUICKBOOKS_USER_ID) )
				gQUICKBOOKS_USER_ID = new Guid("00000000-0000-0000-0000-000000000004");  // Use special QuickBooks user. 
			return gQUICKBOOKS_USER_ID;
		}

		public Spring.Social.QuickBooks.Api.IQuickBooks CreateApi()
		{
			Spring.Social.QuickBooks.Api.IQuickBooks quickBooks = null;
			//string sOAuthCountryCode       = Sql.ToString(Application["CONFIG.QuickBooks.OAuthCountryCode"      ]);
			string sOAuthCompanyID         = Sql.ToString(Application["CONFIG.QuickBooks.OAuthCompanyID"        ]);
			string sOAuthClientID          = Sql.ToString(Application["CONFIG.QuickBooks.OAuthClientID"         ]);
			string sOAuthClientSecret      = Sql.ToString(Application["CONFIG.QuickBooks.OAuthClientSecret"     ]);
			string sOAuthAccessToken       = Sql.ToString(Application["CONFIG.QuickBooks.OAuthAccessToken"      ]);
			string sOAuthAccessTokenSecret = Sql.ToString(Application["CONFIG.QuickBooks.OAuthAccessTokenSecret"]);
			
			Spring.Social.QuickBooks.Connect.QuickBooksServiceProvider quickBooksServiceProvider = new Spring.Social.QuickBooks.Connect.QuickBooksServiceProvider(sOAuthClientID, sOAuthClientSecret);
			quickBooks = quickBooksServiceProvider.GetApi(sOAuthAccessToken, sOAuthAccessTokenSecret, sOAuthCompanyID);
			return quickBooks;
		}

		public void GetOAuthAuthorizationURL(string sOAuthClientID, string sOAuthClientSecret, string sCALLBACK_URL, ref string sAUTH_TOKEN, ref string sAUTH_KEY, ref string sAUTH_URL, StringBuilder sbErrors)
		{
			try
			{
				Spring.Social.QuickBooks.Connect.QuickBooksServiceProvider quickBooksServiceProvider = new Spring.Social.QuickBooks.Connect.QuickBooksServiceProvider(sOAuthClientID, sOAuthClientSecret);
				Spring.Social.OAuth1.OAuthToken oauthToken = quickBooksServiceProvider.OAuthOperations.FetchRequestTokenAsync(sCALLBACK_URL, null).Result;
				sAUTH_TOKEN = oauthToken.Value ;
				sAUTH_KEY   = oauthToken.Secret;
				sAUTH_URL   = quickBooksServiceProvider.OAuthOperations.BuildAuthorizeUrl(oauthToken.Value, null);
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
		}

		public void GetOAuthAccessToken(string sOAuthClientID, string sOAuthClientSecret, string sAUTH_TOKEN, string sAUTH_KEY, string sAUTH_VERIFIER, ref string sOAUTH_ACCESS_TOKEN, ref string sOAUTH_ACCESS_SECRET, StringBuilder sbErrors)
		{
			try
			{
				Spring.Social.QuickBooks.Connect.QuickBooksServiceProvider quickBooksServiceProvider = new Spring.Social.QuickBooks.Connect.QuickBooksServiceProvider(sOAuthClientID, sOAuthClientSecret);
				Spring.Social.OAuth1.OAuthToken             oauthToken   = new Spring.Social.OAuth1.OAuthToken(sAUTH_TOKEN, sAUTH_KEY);
				Spring.Social.OAuth1.AuthorizedRequestToken requestToken = new Spring.Social.OAuth1.AuthorizedRequestToken(oauthToken, sAUTH_VERIFIER);
				// 10/21/2013 Paul.  We must use the Async call when Spring.NET is compiled using .NET 4.0. 
				Spring.Social.OAuth1.OAuthToken oauthAccessToken = quickBooksServiceProvider.OAuthOperations.ExchangeForAccessTokenAsync(requestToken, null).Result;
				sOAUTH_ACCESS_TOKEN  = oauthAccessToken.Value ;
				sOAUTH_ACCESS_SECRET = oauthAccessToken.Secret;
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
		}

		// 04/27/2015 Paul.  QuickBooks playground that allows testing of OAuth tokens. 
		// https://appcenter.intuit.com/Playground/OAuth/IA/
		public bool ReconnectAccessToken(StringBuilder sbErrors)
		{
			bool bSuccess = false;
			string sOAuthClientID          = Sql.ToString(Application["CONFIG.QuickBooks.OAuthClientID"         ]);
			string sOAuthClientSecret      = Sql.ToString(Application["CONFIG.QuickBooks.OAuthClientSecret"     ]);
			string sOAuthAccessToken       = Sql.ToString(Application["CONFIG.QuickBooks.OAuthAccessToken"      ]);
			string sOAuthAccessTokenSecret = Sql.ToString(Application["CONFIG.QuickBooks.OAuthAccessTokenSecret"]);
			string sOAuthVerifier          = Sql.ToString(Application["CONFIG.QuickBooks.OAuthVerifier"         ]);
			string sOAuthExpiresAt         = Sql.ToString(Application["CONFIG.QuickBooks.OAuthExpiresAt"        ]);
			try
			{
				Spring.Social.QuickBooks.Connect.QuickBooksOAuth1Template oauth = new Spring.Social.QuickBooks.Connect.QuickBooksOAuth1Template(sOAuthClientID, sOAuthClientSecret);
				Spring.Social.OAuth1.OAuthToken             oauthToken       = new Spring.Social.OAuth1.OAuthToken(sOAuthAccessToken, sOAuthAccessTokenSecret);
				Spring.Social.OAuth1.AuthorizedRequestToken requestToken     = new Spring.Social.OAuth1.AuthorizedRequestToken(oauthToken, sOAuthVerifier);
				Spring.Social.OAuth1.OAuthToken             oauthAccessToken = oauth.ReconnectAccessToken(requestToken, null);
				sOAuthAccessToken       = oauthAccessToken.Value ;
				sOAuthAccessTokenSecret = oauthAccessToken.Secret;
				DateTime dtOAuthExpiresAt = DateTime.Now.AddDays(180);
				sOAuthExpiresAt = dtOAuthExpiresAt.ToShortDateString() + " " + dtOAuthExpiresAt.ToShortTimeString();
				
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							Application["CONFIG.QuickBooks.OAuthAccessToken"      ] = sOAuthAccessToken      ;
							Application["CONFIG.QuickBooks.OAuthAccessTokenSecret"] = sOAuthAccessTokenSecret;
							Application["CONFIG.QuickBooks.OAuthExpiresAt"        ] = sOAuthExpiresAt        ;
							SqlProcs.spCONFIG_Update("system", "QuickBooks.OAuthAccessToken"      , Sql.ToString(Application["CONFIG.QuickBooks.OAuthAccessToken"      ]), trn);
							SqlProcs.spCONFIG_Update("system", "QuickBooks.OAuthAccessTokenSecret", Sql.ToString(Application["CONFIG.QuickBooks.OAuthAccessTokenSecret"]), trn);
							SqlProcs.spCONFIG_Update("system", "QuickBooks.OAuthExpiresAt"        , Sql.ToString(Application["CONFIG.QuickBooks.OAuthExpiresAt"        ]), trn);
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
			catch(Exception ex)
			{
				sbErrors.Append(Utils.ExpandException(ex));
			}
			return bSuccess;
		}

		public bool ValidateQuickBooks(string sOAuthCompanyID, string sOAuthCountryCode, string sOAuthClientID, string sOAuthClientSecret, string sOAuthAccessToken, string sOAuthAccessTokenSecret, StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Spring.Social.QuickBooks.Api.IQuickBooks quickBooks = null;
				Spring.Social.QuickBooks.Connect.QuickBooksServiceProvider quickBooksServiceProvider = new Spring.Social.QuickBooks.Connect.QuickBooksServiceProvider(sOAuthClientID, sOAuthClientSecret);
				quickBooks = quickBooksServiceProvider.GetApi(sOAuthAccessToken, sOAuthAccessTokenSecret, sOAuthCompanyID);
				quickBooks.CustomerOperations.GetAll(String.Empty, this.PrimarySortField("Accounts"));
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			return bValidSource;
		}

		public bool ValidateQuickBooks(StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Spring.Social.QuickBooks.Api.IQuickBooks quickBooks = CreateApi();
				quickBooks.CustomerOperations.GetAll(String.Empty, this.PrimarySortField("Accounts"));
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
			// 02/06/2014 Paul.  New QuickBooks factory to allow Remote and Online. 
			bool bQuickBooksEnabled = QuickBooksEnabled();
			if ( !bInsideSyncAll && bQuickBooksEnabled )
			{
				bInsideSyncAll = true;
				try
				{
					StringBuilder sbErrors = new StringBuilder();

					string sOAuthAccessToken = Sql.ToString(Application["CONFIG.QuickBooks.OAuthAccessToken"]);
					string sOAuthExpiresAt   = Sql.ToString(Application["CONFIG.QuickBooks.OAuthExpiresAt"  ]);
					if ( !Sql.IsEmptyString(sOAuthAccessToken) )
					{
						DateTime dtOAuthExpiresAt = Sql.ToDateTime(sOAuthExpiresAt);
						// 04/27/2015 Paul.  We need to reconnect when within a 30-day window of expiration. 
						// 09/09/2015 Paul.  Need to make sure that a new token is retrieved even if values are null or date has expired. 
						if ( DateTime.Now.AddDays(15) > dtOAuthExpiresAt )
						{
							this.ReconnectAccessToken(sbErrors);
							if ( sbErrors.Length > 0 )
							{
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "Failed to reconnect QuickBooks Online Access Token: " + sbErrors.ToString());
								// 04/27/2015 Paul.  If there is an error, clear the in-memory value only. We want to allow a retry. 
								Application["CONFIG.QuickBooks.OAuthAccessToken"] = String.Empty;
								return;
							}
						}
					
						Guid gQUICKBOOKS_USER_ID = this.QuickBooksUserID();
						QuickBooks.UserSync User = new QuickBooks.UserSync(Session, Security, SplendidError, ExchangeSecurity, SyncError, this, gQUICKBOOKS_USER_ID, bSyncAll);
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
		public void SyncTaxRates(Object sender)
		{
			QuickBooks.UserSync User = sender as QuickBooks.UserSync;
			if ( User != null )
			{
				try
				{
					if ( QuickBooksEnabled() )
					{
						Spring.Social.QuickBooks.Api.IQuickBooks quickBooks = this.CreateApi();
						if ( quickBooks != null )
						{
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( IDbConnection con = dbf.CreateConnection() )
							{
								con.Open();
								QuickBooks.TaxCode taxRate = new QuickBooks.TaxCode(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks);
								if ( !bInsideTaxRates )
								{
									try
									{
										bInsideTaxRates = true;
										StringBuilder sbErrors = new StringBuilder();
										Sync(dbf, con, User, taxRate, sbErrors);
										Cache.Remove("QuickBooks.TaxRates");
									}
									finally
									{
										bInsideTaxRates = false;
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

		public void SyncPaymentTypes(Object sender)
		{
			QuickBooks.UserSync User = sender as QuickBooks.UserSync;
			if ( User != null )
			{
				try
				{
					if ( QuickBooksEnabled() )
					{
						Spring.Social.QuickBooks.Api.IQuickBooks quickBooks = this.CreateApi();
						if ( quickBooks != null )
						{
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( IDbConnection con = dbf.CreateConnection() )
							{
								con.Open();
								QuickBooks.PaymentType paymentType = new QuickBooks.PaymentType(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks);
								if ( !bInsidePaymentTypes )
								{
									try
									{
										bInsidePaymentTypes = true;
										StringBuilder sbErrors = new StringBuilder();
										Sync(dbf, con, User, paymentType, sbErrors);
										Cache.Remove("QuickBooks.PaymentTypes");
									}
									finally
									{
										bInsidePaymentTypes = false;
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

		public void SyncPaymentTerms(Object sender)
		{
			QuickBooks.UserSync User = sender as QuickBooks.UserSync;
			if ( User != null )
			{
				try
				{
					if ( QuickBooksEnabled() )
					{
						Spring.Social.QuickBooks.Api.IQuickBooks quickBooks = this.CreateApi();
						if ( quickBooks != null )
						{
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( IDbConnection con = dbf.CreateConnection() )
							{
								con.Open();
								QuickBooks.PaymentTerm paymentTerm = new QuickBooks.PaymentTerm(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks);
								if ( !bInsidePaymentTerms )
								{
									try
									{
										bInsidePaymentTerms = true;
										StringBuilder sbErrors = new StringBuilder();
										Sync(dbf, con, User, paymentTerm, sbErrors);
										Cache.Remove("QuickBooks.PaymentTerms");
									}
									finally
									{
										bInsidePaymentTerms = false;
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

		public void SyncItems(Object sender)
		{
			QuickBooks.UserSync User = sender as QuickBooks.UserSync;
			if ( User != null )
			{
				try
				{
					if ( QuickBooksEnabled() )
					{
						Spring.Social.QuickBooks.Api.IQuickBooks quickBooks = this.CreateApi();
						if ( quickBooks != null )
						{
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( IDbConnection con = dbf.CreateConnection() )
							{
								con.Open();
								QuickBooks.Item item = new QuickBooks.Item(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, SplendidCache.ProductTypes());
								if ( !bInsideItems )
								{
									try
									{
										bInsideItems = true;
										StringBuilder sbErrors = new StringBuilder();
										Sync(dbf, con, User, item, sbErrors);
										Cache.Remove("QuickBooks.Items");
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
			QuickBooks.UserSync User = sender as QuickBooks.UserSync;
			if ( User != null )
			{
				try
				{
					if ( QuickBooksEnabled() )
					{
						Spring.Social.QuickBooks.Api.IQuickBooks quickBooks = this.CreateApi();
						if ( quickBooks != null )
						{
							bool bShortStateName   = Sql.ToBoolean(Application["CONFIG.GoogleMaps.ShortStateName"     ]);
							bool bShortCountryName = Sql.ToBoolean(Application["CONFIG.GoogleMaps.ShortCountryName"   ]);
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( IDbConnection con = dbf.CreateConnection() )
							{
								con.Open();
								using ( DataTable dtCustomers = ACCOUNTS_SYNC(dbf, con, User.USER_ID) )
								{
									QuickBooks.Customer customer = new QuickBooks.Customer(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, dtCustomers, bShortStateName, bShortCountryName);
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
			QuickBooks.UserSync User = sender as QuickBooks.UserSync;
			if ( User != null )
			{
				try
				{
					if ( QuickBooksEnabled() )
					{
						Spring.Social.QuickBooks.Api.IQuickBooks quickBooks = this.CreateApi();
						if ( quickBooks != null )
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
														string sDiscountAccountId = DiscountAccountId(quickBooks);
														QuickBooks.Invoice invoice = new QuickBooks.Invoice(Session, Security, Sql, SqlProcs, SplendidError, ExchangeSecurity, SyncError, quickBooks, dtCurrencies, dtShippers, dtTaxRates, dtItems, dtCustomers, dtPaymentTerms, sDiscountAccountId, dbf, con, bShortStateName, bShortCountryName);
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

		public void SyncEstimates(Object sender)
		{
			QuickBooks.UserSync User = sender as QuickBooks.UserSync;
			if ( User != null )
			{
				try
				{
					if ( QuickBooksEnabled() )
					{
						Spring.Social.QuickBooks.Api.IQuickBooks quickBooks = this.CreateApi();
						if ( quickBooks != null )
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
														string sDiscountAccountId = DiscountAccountId(quickBooks);
														QuickBooks.Estimate estimate = new QuickBooks.Estimate(Session, Security, Sql, SqlProcs, SplendidError, ExchangeSecurity, SyncError, quickBooks, dtCurrencies, dtShippers, dtTaxRates, dtItems, dtCustomers, dtPaymentTerms, sDiscountAccountId, dbf, con, bShortStateName, bShortCountryName);
														if ( !bInsideEstimates )
														{
															try
															{
																bInsideEstimates = true;
																StringBuilder sbErrors = new StringBuilder();
																Sync(dbf, con, User, estimate, sbErrors);
															}
															finally
															{
																bInsideEstimates = false;
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

		public void SyncPayments(Object sender)
		{
			QuickBooks.UserSync User = sender as QuickBooks.UserSync;
			if ( User != null )
			{
				try
				{
					if ( QuickBooksEnabled() )
					{
						Spring.Social.QuickBooks.Api.IQuickBooks quickBooks = this.CreateApi();
						if ( quickBooks != null )
						{
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( IDbConnection con = dbf.CreateConnection() )
							{
								con.Open();
								using ( DataTable dtCurrencies = CURRENCIES() )
								{
									using ( DataTable dtCustomers = ACCOUNTS_SYNC(dbf, con, User.USER_ID) )
									{
										using ( DataTable dtPaymentTypes = PAYMENT_TYPES_SYNC(dbf, con, User.USER_ID) )
										{
											using ( DataTable dtInvoices = INVOICES_SYNC(dbf, con, User.USER_ID) )
											{
												string sPaymentsDepositAccountId = PaymentsDepositAccountId(quickBooks);
												QuickBooks.Payment payment = new QuickBooks.Payment(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, dtCurrencies, dtCustomers, dtPaymentTypes, dtInvoices, sPaymentsDepositAccountId);
												if ( !bInsidePayments )
												{
													try
													{
														bInsidePayments = true;
														StringBuilder sbErrors = new StringBuilder();
														Sync(dbf, con, User, payment, sbErrors);
													}
													finally
													{
														bInsidePayments = false;
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

		public void SyncCreditMemos(Object sender)
		{
			QuickBooks.UserSync User = sender as QuickBooks.UserSync;
			if ( User != null )
			{
				try
				{
					if ( QuickBooksEnabled() )
					{
						Spring.Social.QuickBooks.Api.IQuickBooks quickBooks = this.CreateApi();
						if ( quickBooks != null )
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
														using ( DataTable dtInvoices = INVOICES_SYNC(dbf, con, User.USER_ID) )
														{
															string sPaymentsDepositAccountId = PaymentsDepositAccountId(quickBooks);
															string sDiscountAccountId        = DiscountAccountId(quickBooks);
															QuickBooks.CreditMemo creditMemo = new QuickBooks.CreditMemo(Session, Security, Sql, SqlProcs, SplendidError, ExchangeSecurity, SyncError, quickBooks, dtCurrencies, dtShippers, dtTaxRates, dtItems, dtCustomers, dtInvoices, dtPaymentTerms, sPaymentsDepositAccountId, sDiscountAccountId, dbf, con, bShortStateName, bShortCountryName);
															if ( !bInsideCreditMemos )
															{
																try
																{
																	bInsideCreditMemos = true;
																	StringBuilder sbErrors = new StringBuilder();
																	Sync(dbf, con, User, creditMemo, sbErrors);
																}
																finally
																{
																	bInsideCreditMemos = false;
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
			// 02/26/2015 Paul.  We need to use QUICKBOOKS_TAX_VENDOR when setting the TaxCodeTaxRate. 
			sSQL = "select SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_KEY                               " + ControlChars.CrLf
			     + "     , QUICKBOOKS_TAX_VENDOR                         " + ControlChars.CrLf
			     + "  from vwTAX_RATES_SYNC                              " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'QuickBooksOnline'   " + ControlChars.CrLf
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
			     + " where SYNC_SERVICE_NAME     = N'QuickBooksOnline'   " + ControlChars.CrLf
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
			     + " where SYNC_SERVICE_NAME     = N'QuickBooksOnline'   " + ControlChars.CrLf
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
			     + " where SYNC_SERVICE_NAME     = N'QuickBooksOnline'   " + ControlChars.CrLf
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
			bool bEnableMultiCurrency = Sql.ToBoolean(Application["CONFIG.QuickBooks.EnableMultiCurrency"]);
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
			     + " where SYNC_SERVICE_NAME     = N'QuickBooksOnline'   " + ControlChars.CrLf
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
			     + " where SYNC_SERVICE_NAME     = N'QuickBooksOnline'   " + ControlChars.CrLf
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

		private string PaymentsDepositAccountId(Spring.Social.QuickBooks.Api.IQuickBooks quickBooks)
		{
			string sPaymentsDepositAccount   = Sql.ToString(Application["CONFIG.QuickBooks.PaymentsDepositAccount"]);
			string sPaymentsDepositAccountId = Sql.ToString(Application["QuickBooks.PaymentsDepositAccount." + sPaymentsDepositAccount]);
			if ( !Sql.IsEmptyString(sPaymentsDepositAccount) && Sql.IsEmptyString(sPaymentsDepositAccountId) )
			{
				try
				{
					Spring.Social.QuickBooks.Api.Account account = quickBooks.AccountOperations.GetByName(sPaymentsDepositAccount);
					if ( account != null )
					{
						sPaymentsDepositAccountId = account.Id;
						Application["QuickBooks.PaymentsDepositAccount." + sPaymentsDepositAccount] = sPaymentsDepositAccountId;
					}
				}
				catch
				{
				}
			}
			return sPaymentsDepositAccountId;
		}

		private string DiscountAccountId(Spring.Social.QuickBooks.Api.IQuickBooks quickBooks)
		{
			string sDiscountAccount   = Sql.ToString(Application["CONFIG.QuickBooks.DiscountAccount"]);
			if ( Sql.IsEmptyString(sDiscountAccount) )
				sDiscountAccount = "Discounts given";
			string sDiscountAccountId = Sql.ToString(Application["QuickBooks.DiscountAccount." + sDiscountAccount]);
			if ( !Sql.IsEmptyString(sDiscountAccount) && Sql.IsEmptyString(sDiscountAccountId) )
			{
				try
				{
					Spring.Social.QuickBooks.Api.Account account = quickBooks.AccountOperations.GetByName(sDiscountAccount);
					if ( account != null )
					{
						sDiscountAccountId = account.Id;
						Application["QuickBooks.DiscountAccount." + sDiscountAccount] = sDiscountAccountId;
					}
					else if ( sDiscountAccount == "Discounts given" )
					{
						// 03/06/2016 Paul.  If Discounts given does not exist, then try Discounts. 
						sDiscountAccount = "Discounts";
						account = quickBooks.AccountOperations.GetByName(sDiscountAccount);
						if ( account != null )
						{
							sDiscountAccountId = account.Id;
							Application["QuickBooks.DiscountAccount." + sDiscountAccount] = sDiscountAccountId;
						}
					}
				}
				catch
				{
				}
			}
			return sDiscountAccountId;
		}
		#endregion

		public void Sync(QuickBooks.UserSync User, StringBuilder sbErrors)
		{
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.QuickBooks.VerboseStatus"     ]);
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "QuickBooksSync.Sync Start.");
			
			Spring.Social.QuickBooks.Api.IQuickBooks quickBooks = this.CreateApi();
			if ( quickBooks != null )
			{
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					try
					{
						con.Open();
						
						bool bSyncShipper              = true;
						bool bSyncTaxRates             = true;
						bool bSyncItems                = true;
						bool bSyncCustomers            = true;
						bool bSyncPaymentTerms         = Sql.ToBoolean(Application["CONFIG.QuickBooks.SyncInvoices"       ]);
						bool bSyncEstimates            = Sql.ToBoolean(Application["CONFIG.QuickBooks.SyncQuotes"         ]);
						bool bSyncInvoices             = Sql.ToBoolean(Application["CONFIG.QuickBooks.SyncInvoices"       ]);
						bool bSyncPaymentTypes         = Sql.ToBoolean(Application["CONFIG.QuickBooks.SyncPayments"       ]);
						bool bSyncPayments             = Sql.ToBoolean(Application["CONFIG.QuickBooks.SyncPayments"       ]);
						bool bSyncCreditMemos          = Sql.ToBoolean(Application["CONFIG.QuickBooks.SyncCreditMemos"    ]);
						bool bEnableMultiCurrency      = Sql.ToBoolean(Application["CONFIG.QuickBooks.EnableMultiCurrency"]);
						bool bShortStateName           = Sql.ToBoolean(Application["CONFIG.GoogleMaps.ShortStateName"     ]);
						bool bShortCountryName         = Sql.ToBoolean(Application["CONFIG.GoogleMaps.ShortCountryName"   ]);
						
						DataTable dtShippers = Cache.Get("QuickBooks.Shippers") as DataTable;
						// 02/01/2015 Paul.  QuickBooks Online does not support ShipMethod. 
						//QuickBooks.ShippingMethod shipper = new QuickBooks.ShippingMethod(quickBooks);
						if ( bSyncShipper && (bSyncEstimates || bSyncInvoices) && (dtShippers == null || User.SyncAll) )
						{
							//Sync(dbf, con, User, shipper, sbErrors);
							dtShippers = SHIPPERS(dbf, con);
							Cache.Set("QuickBooks.Shippers", dtShippers, DefaultCacheExpiration());
						}
						
						DataTable dtTaxRates = Cache.Get("QuickBooks.TaxRates") as DataTable;
						// 02/24/2015 Paul.  Change from TaxRate to TaxCode as we need the two values. 
						QuickBooks.TaxCode taxRate = new QuickBooks.TaxCode(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks);
						if ( bSyncTaxRates && (bSyncEstimates || bSyncInvoices) && (dtTaxRates == null || User.SyncAll) )
						{
							if ( !bInsideTaxRates )
							{
								try
								{
									bInsideTaxRates = true;
									Sync(dbf, con, User, taxRate, sbErrors);
								}
								finally
								{
									bInsideTaxRates = false;
								}
							}
							dtTaxRates = TAX_RATES_SYNC(dbf, con, User.USER_ID);
							Cache.Set("QuickBooks.TaxRates", dtTaxRates, DefaultCacheExpiration());
						}
						
						DataTable dtPaymentTypes = Cache.Get("QuickBooks.PaymentTypes") as DataTable;
						QuickBooks.PaymentType paymentType = new QuickBooks.PaymentType(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks);
						if ( bSyncPaymentTypes && bSyncPayments && bSyncInvoices && (dtPaymentTypes == null || User.SyncAll) )
						{
							if ( !bInsidePaymentTypes )
							{
								try
								{
									bInsidePaymentTypes = true;
									Sync(dbf, con, User, paymentType, sbErrors);
								}
								finally
								{
									bInsidePaymentTypes = false;
								}
							}
							dtPaymentTypes = PAYMENT_TYPES_SYNC(dbf, con, User.USER_ID);
							Cache.Set("QuickBooks.PaymentTypes", dtPaymentTypes, DefaultCacheExpiration());
						}
						
						DataTable dtPaymentTerms = Cache.Get("QuickBooks.PaymentTerms") as DataTable;
						QuickBooks.PaymentTerm paymentTerm = new QuickBooks.PaymentTerm(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks);
						if ( bSyncPaymentTerms && bSyncInvoices && (dtPaymentTerms == null || User.SyncAll) )
						{
							if ( !bInsidePaymentTerms )
							{
								try
								{
									bInsidePaymentTerms = true;
									Sync(dbf, con, User, paymentTerm, sbErrors);
								}
								finally
								{
									bInsidePaymentTerms = false;
								}
							}
							dtPaymentTerms = PAYMENT_TERMS_SYNC(dbf, con, User.USER_ID);
							Cache.Set("QuickBooks.PaymentTerms", dtPaymentTerms, DefaultCacheExpiration());
						}
						
						DataTable dtItems = Cache.Get("QuickBooks.Items") as DataTable;
						QuickBooks.Item item = new QuickBooks.Item(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, SplendidCache.ProductTypes());
						if ( bSyncItems && (bSyncEstimates || bSyncInvoices) && (dtItems == null || User.SyncAll) )
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
							Cache.Set("QuickBooks.Items", dtItems, DefaultCacheExpiration());
						}
						
						// 02/13/2015 Paul.  Default to USD.  vwCurrencies will be empty if using US QuickBooks Online as it only supports USD. 
						// https://developer.intuit.com/docs/0100_accounting/0300_developer_guides/currency
						DataTable dtCurrencies = null;
						if ( bSyncEstimates || bSyncInvoices )
						{
							dtCurrencies = CURRENCIES();
						}
						
						using ( DataTable dtCustomers = ACCOUNTS_SYNC(dbf, con, User.USER_ID) )
						{
							QuickBooks.Customer customer = new QuickBooks.Customer(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, dtCustomers, bShortStateName, bShortCountryName);
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
							string sDiscountAccountId = DiscountAccountId(quickBooks);
							if ( bSyncEstimates )
							{
								QuickBooks.Estimate estimate = new QuickBooks.Estimate(Session, Security, Sql, SqlProcs, SplendidError, ExchangeSecurity, SyncError, quickBooks, dtCurrencies, dtShippers, dtTaxRates, dtItems, dtCustomers, dtPaymentTerms, sDiscountAccountId, dbf, con, bShortStateName, bShortCountryName);
								if ( !bInsideEstimates )
								{
									try
									{
										bInsideEstimates = true;
										Sync(dbf, con, User, estimate, sbErrors);
									}
									finally
									{
										bInsideEstimates = false;
									}
								}
							}
							if ( bSyncInvoices )
							{
								QuickBooks.Invoice invoice = new QuickBooks.Invoice(Session, Security, Sql, SqlProcs, SplendidError, ExchangeSecurity, SyncError, quickBooks, dtCurrencies, dtShippers, dtTaxRates, dtItems, dtCustomers, dtPaymentTerms, sDiscountAccountId, dbf, con, bShortStateName, bShortCountryName);
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
								if ( bSyncPayments || bSyncCreditMemos )
								{
									using ( DataTable dtInvoices = INVOICES_SYNC(dbf, con, User.USER_ID) )
									{
										string sPaymentsDepositAccountId = PaymentsDepositAccountId(quickBooks);
										if ( bSyncPayments )
										{
											QuickBooks.Payment payment = new QuickBooks.Payment(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, dtCurrencies, dtCustomers, dtPaymentTypes, dtInvoices, sPaymentsDepositAccountId);
											if ( !bInsidePayments )
											{
												try
												{
													bInsidePayments = true;
													Sync(dbf, con, User, payment, sbErrors);
												}
												finally
												{
													bInsidePayments = false;
												}
											}
										}
										if ( bSyncCreditMemos )
										{
											QuickBooks.CreditMemo creditmemo = new QuickBooks.CreditMemo(Session, Security, Sql, SqlProcs, SplendidError, ExchangeSecurity, SyncError, quickBooks, dtCurrencies, dtShippers, dtTaxRates, dtItems, dtCustomers, dtInvoices, dtPaymentTerms, sPaymentsDepositAccountId, sDiscountAccountId, dbf, con, bShortStateName, bShortCountryName);
											if ( !bInsideCreditMemos )
											{
												try
												{
													bInsideCreditMemos = true;
													Sync(dbf, con, User, creditmemo, sbErrors);
												}
												finally
												{
													bInsideCreditMemos = false;
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
					finally
					{
						if ( bVERBOSE_STATUS )
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "QuickBooksSync.Sync Done.");
					}
				}
			}
		}

		public void Sync(SplendidCRM.DbProviderFactory dbf, IDbConnection con, QuickBooks.UserSync User, QuickBooks.QObject qo, StringBuilder sbErrors)
		{
			ExchangeSession Session = ExchangeSecurity.LoadUserACL(User.USER_ID);
			Guid gUSER_ID = User.USER_ID;
			bool bSyncAll = User.SyncAll;
			
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.QuickBooks.VerboseStatus"     ]);
			string sCONFLICT_RESOLUTION = Sql.ToString (Application["CONFIG.QuickBooks.ConflictResolution"]);
			string sDIRECTION           = Sql.ToString (Application["CONFIG.QuickBooks.Direction"         ]);
			// 03/09/2015 Paul.  Establish maximum number of records to process at one time. 
			int    nMAX_RECORDS         = Sql.ToInteger(Application["CONFIG.QuickBooks.MaxRecords"        ]);
			Guid   gTEAM_ID             = Sql.ToGuid  (Session["TEAM_ID"]);
			if ( sDIRECTION.ToLower().StartsWith("bi") )
				sDIRECTION = "bi-directional";
			else if ( sDIRECTION.ToLower().StartsWith("to crm"  ) || sDIRECTION.ToLower().StartsWith("from quickbooks") )
				sDIRECTION = "to crm only";
			else if ( sDIRECTION.ToLower().StartsWith("from crm") || sDIRECTION.ToLower().StartsWith("to quickbooks"  ) )
				sDIRECTION = "from crm only";
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.QuickBooksTableName + ".Sync: " + sDIRECTION);
			try
			{
				string sSQL = String.Empty;
				DateTime dtStartModifiedDate = DateTime.MinValue;
				if ( !bSyncAll )
				{
					sSQL = "select max(SYNC_REMOTE_DATE_MODIFIED_UTC)            " + ControlChars.CrLf
					     + "  from vw" + qo.CRMTableName + "_SYNC                " + ControlChars.CrLf
					     + " where SYNC_SERVICE_NAME     = N'QuickBooksOnline'   " + ControlChars.CrLf
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
				IList<Spring.Social.QuickBooks.Api.QBase> lst = qo.SelectModified(dtStartModifiedDate);
				if ( bVERBOSE_STATUS )
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.QuickBooksTableName + ".Sync: Query took " + (DateTime.Now - dtStartSelect).Seconds.ToString() + " seconds. Using last modified " + dtStartModifiedDate.ToString());
				if ( lst.Count > 0 )
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.QuickBooksTableName + ".Sync: " + lst.Count.ToString() + " " + qo.QuickBooksTableName + " to import.");
				// 05/31/2012 Paul.  Sorting should not be necessary as the order of the line items should match the display order. 
				foreach ( Spring.Social.QuickBooks.Api.QBase qb in lst )
				{
					qo.SetFromQuickBooks(qb.Id);
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
				     + "               on vw" + qo.CRMTableName + "_SYNC.SYNC_SERVICE_NAME     = N'QuickBooksOnline'         " + ControlChars.CrLf
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
					if ( qo.QuickBooksTableName == "Estimates" || qo.QuickBooksTableName == "Invoices" )
					{
						QuickBooks.LineItem qoli = (qo as QuickBooks.QOrder).CreateLineItem();
						cmd.CommandText += "         or exists (" + ControlChars.CrLf;
						cmd.CommandText += "                    select vw" + qoli.CRMTableName + ".*                                                                     " + ControlChars.CrLf;
						cmd.CommandText += "                         , vw" + qoli.CRMTableName + "_SYNC.SYNC_ID                                                          " + ControlChars.CrLf;
						cmd.CommandText += "                         , vw" + qoli.CRMTableName + "_SYNC.SYNC_REMOTE_KEY                                                  " + ControlChars.CrLf;
						cmd.CommandText += "                         , vw" + qoli.CRMTableName + "_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC                                     " + ControlChars.CrLf;
						cmd.CommandText += "                         , vw" + qoli.CRMTableName + "_SYNC.SYNC_REMOTE_DATE_MODIFIED_UTC                                    " + ControlChars.CrLf;
						cmd.CommandText += "                      from            " + Sql.MetadataName(con, "vw" + qoli.CRMTableName + "_QBOnline") + "  vw" + qoli.CRMTableName + ControlChars.CrLf;
						cmd.CommandText += "                      left outer join vw" + qoli.CRMTableName + "_SYNC                                                       " + ControlChars.CrLf;
						cmd.CommandText += "                                   on vw" + qoli.CRMTableName + "_SYNC.SYNC_SERVICE_NAME     = N'QuickBooksOnline'           " + ControlChars.CrLf;
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
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.QuickBooksTableName + ".Sync: " + dt.Rows.Count.ToString() + " " + qo.CRMModuleName + " to send.");
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
										if ( qo is CreditMemo )
											(qo as CreditMemo).INVOICE_ID = Sql.ToGuid(row["INVOICE_ID"]);
										dtLineItems = (qo as QOrder).GetLineItemsFromCRM(Session, con, gUSER_ID, true);
									}
									if ( sSYNC_ACTION == "local new" || Sql.IsEmptyString(sSYNC_REMOTE_KEY) )
									{
										// 05/18/2012 Paul.  Allow control of sync direction. 
										if (sDIRECTION == "bi-directional" || sDIRECTION == "from crm only" )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.QuickBooksTableName + ".Sync: Sending new " + qo.QuickBooksTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
											qo.SetFromCRM(String.Empty, row, sbChanges);
											// 02/7/2015 Paul.  Line items could have changed, so can't use this flag. 
											if ( qo is QuickBooks.QOrder )
											{
												(qo as QuickBooks.QOrder).SetLineItemsFromCRM(Session, con, gUSER_ID, sbChanges);
											}
											sSYNC_REMOTE_KEY = qo.Insert();
										}
									}
									else
									{
										if ( bVERBOSE_STATUS )
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.QuickBooksTableName + ".Sync: Binding " + qo.QuickBooksTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
											
										try
										{
											qo.Get(sSYNC_REMOTE_KEY);
											// 03/28/2010 Paul.  We need to double-check for conflicts. 
											// 03/26/2011 Paul.  Updated is in local time. 
											DateTime dtREMOTE_DATE_MODIFIED     = qo.TimeModified;
											DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
											// 03/26/2011 Paul.  The QuickBooks remote date can vary by 1 millisecond, so check for local change first. 
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
												// 03/26/2011 Paul.  The QuickBooks remote date can vary by 1 millisecond, so check for local change first. 
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
											string sError = "Error retrieving QuickBooks " + qo.QuickBooksTableName + " (" + i.ToString() + ") " + Sql.ToString  (row["NAME"]) + "." + ControlChars.CrLf;
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
												if ( qo is QuickBooks.QOrder )
												{
													(qo as QuickBooks.QOrder).SetLineItemsFromCRM(Session, con, gUSER_ID, sbChanges);
												}
												if ( bVERBOSE_STATUS )
													SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.QuickBooksTableName + ".Sync: Sending " + qo.QuickBooksTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ". " + sbChanges.ToString());
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
															// 02/19/2015 Paul.  Delete all existing relationships as QuickBooks may renumber the line items. 
															IDbCommand spSyncLineDelete = SqlProcs.Factory(con, "sp" + qo.CRMTableName + "_LINE_ITEMS_SYNC_Delete");
															spSyncLineDelete.Transaction = trn;
															Sql.SetParameter(spSyncLineDelete, "@MODIFIED_USER_ID", gUSER_ID          );
															Sql.SetParameter(spSyncLineDelete, "@ASSIGNED_USER_ID", gUSER_ID          );
															Sql.SetParameter(spSyncLineDelete, "@SERVICE_NAME"    , "QuickBooksOnline");
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
														Sql.SetParameter(spSyncLineUpdate, "@SERVICE_NAME"            , "QuickBooksOnline"        );
														foreach ( QObject oLineItem in (qo as QOrder).LineItems )
														{
															// 03/19/2015 Paul.  A Sales Tax line item is special and may not get a matching QuickBooks line. 
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
													Sql.SetParameter(spSyncUpdate, "@SERVICE_NAME"            , "QuickBooksOnline"        );
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
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.QuickBooksTableName + ".Sync: Deleting " + qo.CRMTableName + " " + Sql.ToString(row["NAME"]) + ".");
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
														Sql.SetParameter(spSyncLineDelete, "@SERVICE_NAME"    , "QuickBooksOnline");
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
													Sql.SetParameter(spSyncDelete, "@SERVICE_NAME"    , "QuickBooks"    );
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
									string sError = "Error creating QuickBooks " + qo.QuickBooksTableName + " (" + i.ToString() + ") " + Sql.ToString  (row["NAME"]) + "." + ControlChars.CrLf;
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
						cmd.CommandText += " where SYNC_SERVICE_NAME     = N'QuickBooksOnline'                   " + ControlChars.CrLf;
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
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.QuickBooksTableName + ".Sync: " + dt.Rows.Count.ToString() + " " + qo.CRMModuleName + " to delete.");
								for ( int i = 0; i < dt.Rows.Count; i++ )
								{
									DataRow row = dt.Rows[i];
									Guid   gID              = Sql.ToGuid  (row["SYNC_LOCAL_ID"  ]);
									string sSYNC_REMOTE_KEY = Sql.ToString(row["SYNC_REMOTE_KEY"]);
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.QuickBooksTableName + ".Sync: Deleting QuickBooksOnline (" + sSYNC_REMOTE_KEY + "), CRM " + qo.CRMModuleName + "(" + gID.ToString() + ").");

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
										cmd.CommandText += " where SYNC_SERVICE_NAME     = N'QuickBooksOnline'                    " + ControlChars.CrLf;
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
										string sError = "Error deleting QuickBooksOnline " + qo.QuickBooksTableName + " " + sSYNC_REMOTE_KEY + "." + ControlChars.CrLf;
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
												Sql.SetParameter(spSyncLineDelete, "@SERVICE_NAME"    , "QuickBooksOnline");
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
											Sql.SetParameter(spSyncDelete, "@SERVICE_NAME"    , "QuickBooksOnline");
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
