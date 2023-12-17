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
using System.Net;
using System.Web;
using System.Data;
using System.Text;
using System.Text.Json;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Diagnostics;
using Spring.Json;

using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Caching.Memory;

namespace SplendidCRM
{
	public class SignedPDFData
	{
		public Guid gIMAGE_ID           { get; set; }
		public Guid gNOTE_ID            { get; set; }
		public Guid gNOTE_ATTACHMENT_ID { get; set; }
		public Guid gREPORT_ID          { get; set; }
	}

	public class OrderUtils
	{
		private IMemoryCache         Cache              ;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private SplendidDefaults     SplendidDefaults   = new SplendidDefaults();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private SyncError            SyncError          ;
		private SplendidCRM.Crm.Modules          Modules              ;
		private SplendidCRM.Crm.NoteAttachments  NoteAttachments      ;
		private ReportsAttachmentView            ReportsAttachmentView;

		public OrderUtils(IMemoryCache memoryCache, IHttpContextAccessor httpContextAccessor, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, SyncError SyncError, SplendidCRM.Crm.Modules Modules, SplendidCRM.Crm.NoteAttachments NoteAttachments, ReportsAttachmentView ReportsAttachmentView)
		{
			this.Cache               = memoryCache        ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.SyncError           = SyncError          ;
			this.Modules             = Modules            ;
			this.NoteAttachments     = NoteAttachments    ;
			this.ReportsAttachmentView = ReportsAttachmentView;
		}

		public void DiscountPrice(string sPRICING_FORMULA, float fPRICING_FACTOR, Decimal dCOST_PRICE, Decimal dLIST_PRICE, ref Decimal dDISCOUNT_PRICE)
		{
			if ( fPRICING_FACTOR > 0 )
			{
				switch ( sPRICING_FORMULA )
				{
					case "Fixed"             :
						break;
					case "ProfitMargin"      :
						dDISCOUNT_PRICE = dCOST_PRICE * 100 / (100 - (Decimal) fPRICING_FACTOR);
						break;
					case "PercentageMarkup"  :
						dDISCOUNT_PRICE = dCOST_PRICE * (1 + (Decimal) (fPRICING_FACTOR /100));
						break;
					case "PercentageDiscount":
						dDISCOUNT_PRICE = (dLIST_PRICE * (Decimal) (1 - (fPRICING_FACTOR /100))*100)/100;
						break;
					case "FixedDiscount":
						dDISCOUNT_PRICE = dLIST_PRICE - (Decimal) fPRICING_FACTOR;
						break;
					case "IsList"            :
						dDISCOUNT_PRICE = dLIST_PRICE;
						break;
				}
			}
		}
		
		public void DiscountValue(string sPRICING_FORMULA, float fPRICING_FACTOR, Decimal dCOST_PRICE, Decimal dLIST_PRICE, ref Decimal dDISCOUNT_VALUE)
		{
			if ( fPRICING_FACTOR > 0 )
			{
				switch ( sPRICING_FORMULA )
				{
					case "PercentageDiscount":
						dDISCOUNT_VALUE = (dLIST_PRICE * (Decimal) (fPRICING_FACTOR /100)*100)/100;
						break;
					case "FixedDiscount"     :
						dDISCOUNT_VALUE = (Decimal) fPRICING_FACTOR;
						break;
				}
			}
		}
		
		public void DiscountPrice(Guid gDISCOUNT_ID, Decimal dCOST_PRICE, Decimal dLIST_PRICE, ref Decimal dDISCOUNT_PRICE, ref string sPRICING_FORMULA, ref float fPRICING_FACTOR)
		{
			DataTable dtDISCOUNTS = SplendidCache.Discounts();
			if ( dtDISCOUNTS != null )
			{
				DataRow[] row = dtDISCOUNTS.Select("ID = '" + gDISCOUNT_ID.ToString() + "'");
				if ( row.Length == 1 )
				{
					sPRICING_FORMULA = Sql.ToString(row[0]["PRICING_FORMULA"]);
					fPRICING_FACTOR  = Sql.ToFloat (row[0]["PRICING_FACTOR" ]);
					DiscountPrice(sPRICING_FORMULA, fPRICING_FACTOR, dCOST_PRICE, dLIST_PRICE, ref dDISCOUNT_PRICE);
				}
			}
		}
		
		public void DiscountValue(Guid gDISCOUNT_ID, Decimal dCOST_PRICE, Decimal dLIST_PRICE, ref Decimal dDISCOUNT_VALUE, ref string sDISCOUNT_NAME, ref string sPRICING_FORMULA, ref float fPRICING_FACTOR)
		{
			DataTable dtDISCOUNTS = SplendidCache.Discounts();
			if ( dtDISCOUNTS != null )
			{
				DataRow[] row = dtDISCOUNTS.Select("ID = '" + gDISCOUNT_ID.ToString() + "'");
				if ( row.Length == 1 )
				{
					sPRICING_FORMULA = Sql.ToString(row[0]["PRICING_FORMULA"]);
					fPRICING_FACTOR  = Sql.ToFloat (row[0]["PRICING_FACTOR" ]);
					sDISCOUNT_NAME   = Sql.ToString(row[0]["NAME"           ]);
					DiscountValue(sPRICING_FORMULA, fPRICING_FACTOR, dCOST_PRICE, dLIST_PRICE, ref dDISCOUNT_VALUE);
				}
			}
		}

		public class Signature_2DLineGraphic
		{
			public double width ;
			public double height;
			public string REPORT_ID;
			public List<List<List<double>>> lines { get; set; }
		}

		public byte[] CreateSignatureImage(Signature_2DLineGraphic lineGraphic)
		{
			byte[] png = null;

			// http://keith-wood.name/signature.html
			using ( Bitmap b = new Bitmap((int)Math.Round(lineGraphic.width), (int)Math.Round(lineGraphic.height)) )
			{
				using ( Graphics g = Graphics.FromImage(b) )
				{
					// Make sure the image is drawn Smoothly (this makes the pen lines look smoother)
					g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;
 
					// Set the background to white 
					g.Clear(Color.White);
 
					// Create a pen to draw the signature with 
					Pen pen = new Pen(Color.Black, 2);
 
					// Smooth out the pen, making it rounded 
					pen.DashCap = System.Drawing.Drawing2D.DashCap.Round;
 
					// Last point a line finished at 
					Point LastPoint = new Point();
					bool hasLastPoint = false;
 
					// Draw the signature on the bitmap 
					foreach ( List<List<double>> line in lineGraphic.lines )
					{
						foreach ( List<double> point in line )
						{
							var x = (int)Math.Round(point[0]);
							var y = (int)Math.Round(point[1]);
 							if ( hasLastPoint )
							{
								g.DrawLine(pen, LastPoint, new Point(x, y));
							}
 							LastPoint.X = x;
							LastPoint.Y = y;
							hasLastPoint = true;
						}
						hasLastPoint = false;
					}
				}
				using ( MemoryStream stream = new MemoryStream() )
				{
					b.Save(stream, ImageFormat.Png);
					png = stream.ToArray();
				}
			}
			return png;
		}

		public Guid GetSignatureReportID(string sDETAIL_NAME)
		{
			DataTable dt = SplendidCache.DynamicButtons(sDETAIL_NAME);
			foreach ( DataRow row in dt.Rows )
			{
				string sURL_FORMAT = Sql.ToString(row["URL_FORMAT"]);
				// ../Reports/SignaturePopup.aspx?ID=E0082268-2FFE-4C25-B700-83F3E5254167&QUOTE_ID={0}
				if ( sURL_FORMAT.Contains("SignaturePopup.aspx?") )
				{
					int nStart = sURL_FORMAT.IndexOf("?");
					sURL_FORMAT = sURL_FORMAT.Substring(nStart + 1);
					string[] arrParameters = sURL_FORMAT.Split('&');
					for ( int iParam = 0; iParam < arrParameters.Length; iParam++ )
					{
						string[] arrNameValue = arrParameters[iParam].Split('=');
						if ( arrNameValue.Length == 2 && arrNameValue[0].ToUpper() == "ID" )
						{
							return Sql.ToGuid(arrNameValue[1]);
						}
					}
				}
			}
			return Guid.Empty;
		}

		public async Task<SignedPDFData> CreateSignedPDF(L10N L10n, TimeZone T10n, string sModuleName, Guid gID, string sSignature)
		{
			OrderUtils.Signature_2DLineGraphic lineGraphic = JsonSerializer.Deserialize<OrderUtils.Signature_2DLineGraphic>(sSignature);
			if ( lineGraphic.lines.Count == 0 )
				throw(new Exception(L10n.Term("Orders.ERR_SIGNATURE_NOT_PROVIDED")));

			byte[] bySignature       = this.CreateSignatureImage(lineGraphic);
			string sTABLE_NAME       = Modules.TableName(sModuleName);
			Guid   gASSIGNED_USER_ID = Security.USER_ID;
			Guid   gTEAM_ID          = Security.TEAM_ID;
			string sTEAM_SET_LIST    = String.Empty;
			// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
			string sASSIGNED_SET_LIST= String.Empty;
			string sDESCRIPTION      = String.Empty;
			string sNOTE_NAME        = Modules.ItemName(sModuleName, gID) + " " + L10n.Term("Orders.LBL_SIGNED"   ) + " " + DateTime.Now.ToString();
			string sIMAGE_NAME       = Modules.ItemName(sModuleName, gID) + " " + L10n.Term("Orders.LBL_SIGNATURE") + " " + DateTime.Now.ToString();
			sIMAGE_NAME              = sIMAGE_NAME.Replace('\\', '_').Replace(':' , '_');
			
			Guid gIMAGE_ID                = Guid.Empty;
			Guid gNOTE_ID                 = Guid.Empty;
			Guid gNOTE_ATTACHMENT_ID      = Guid.Empty;
			Guid gREPORT_ID               = Sql.ToGuid(lineGraphic.REPORT_ID);
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL;
				// 03/31/2016 Paul.  We want the signature note to inherit the team of the parent. 
				// 02/05/2021 Paul.  ASSIGNED_SET_LIST was missing. 
				sSQL = "select ASSIGNED_USER_ID " + ControlChars.CrLf
				     + "     , TEAM_ID          " + ControlChars.CrLf
				     + "     , TEAM_SET_LIST    " + ControlChars.CrLf
				     + "     , ASSIGNED_SET_LIST" + ControlChars.CrLf
				     + "  from vw" + sTABLE_NAME  + ControlChars.CrLf
				     + " where ID = @ID         " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gID);
					using ( IDataReader rdr = cmd.ExecuteReader() )
					{
						if ( rdr.Read() )
						{
							gASSIGNED_USER_ID = Sql.ToGuid  (rdr["ASSIGNED_USER_ID" ]);
							gTEAM_ID          = Sql.ToGuid  (rdr["TEAM_ID"          ]);
							sTEAM_SET_LIST    = Sql.ToString(rdr["TEAM_SET_LIST"    ]);
							sASSIGNED_SET_LIST= Sql.ToString(rdr["ASSIGNED_SET_LIST"]);
						}
					}
				}
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						SqlProcs.spIMAGES_Insert
							( ref gIMAGE_ID
							, gID
							, sIMAGE_NAME + ".png"
							, ".png"
							, "image/png"
							, trn
							);
						SqlProcs.spIMAGES_CONTENT_Update(gIMAGE_ID, bySignature, trn);
						trn.Commit();
					}
					catch
					{
						trn.Rollback();
						throw;
					}
				}
				DataTable dtReport = SplendidCache.Report(gREPORT_ID);
				if ( dtReport.Rows.Count > 0 )
				{
					DataRow rdr = dtReport.Rows[0];
					string sRDL = Sql.ToString  (rdr["RDL"]);
						
					string sPrimaryKey = Crm.Modules.SingularTableName(Modules.TableName(sModuleName)) + "_ID";
					Dictionary<string, string> dictParameters = new Dictionary<string,string>();
					dictParameters[sPrimaryKey   ] = gID.ToString();
					dictParameters["SIGNATURE_ID"] = gIMAGE_ID.ToString();
					AttachmentData data = await ReportsAttachmentView.Render(dictParameters, L10n, T10n, gREPORT_ID, sRDL, "PDF", sModuleName, Guid.Empty);
					byte[] byContent       = data.byContent      ;
					string sFILE_MIME_TYPE = data.sFILE_MIME_TYPE;
					string sFILE_EXT       = data.sFILE_EXT      ;
					string sFILENAME       = sNOTE_NAME + "." + sFILE_EXT;
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spNOTES_Update
								( ref gNOTE_ID
								, sNOTE_NAME
								, sModuleName  // PARENT_TYPE
								, gID          // PARENT_ID
								, Guid.Empty
								, String.Empty
								, gTEAM_ID
								, sTEAM_SET_LIST
								, gASSIGNED_USER_ID
								// 05/17/2017 Paul.  Add Tags module. 
								, String.Empty  // TAG_SET_NAME
								// 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
								, false         // IS_PRIVATE
								// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
								, String.Empty  // ASSIGNED_SET_LIST
								, trn
								);
						
							SqlProcs.spNOTE_ATTACHMENTS_Insert(ref gNOTE_ATTACHMENT_ID, gNOTE_ID, sDESCRIPTION, sFILENAME, sFILE_EXT, sFILE_MIME_TYPE, trn);
							using ( MemoryStream stm = new MemoryStream(byContent) )
							{
								NoteAttachments.LoadFile(gNOTE_ATTACHMENT_ID, stm, trn);
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
			SignedPDFData pdfData = new SignedPDFData();
			pdfData.gIMAGE_ID           = gIMAGE_ID          ;
			pdfData.gNOTE_ID            = gNOTE_ID           ;
			pdfData.gNOTE_ATTACHMENT_ID = gNOTE_ATTACHMENT_ID;
			pdfData.gREPORT_ID          = gREPORT_ID         ;
			return pdfData;
		}

		public class CurrencyLayerETag
		{
			public string   ETag;
			public DateTime Date;
			public float    Rate;
		}

		// 04/30/2016 Paul.  The primary function uses the default currency of the user as the source. 
		public float GetCurrencyConversionRate(HttpApplicationState Application, string sDestinationCurrency, StringBuilder sbErrors)
		{
			// 04/30/2016 Paul.  Require the Application so that we can get the base currency. 
			string sSourceCurrency = SplendidDefaults.BaseCurrencyISO();
			object oRate = Cache.Get("CurrencyLayer." + sSourceCurrency + sDestinationCurrency);
			float dRate = 1.0F;
			if ( oRate == null )
			{
				string sAccessKey      = Sql.ToString (Application["CONFIG.CurrencyLayer.AccessKey"     ]);
				bool   bLogConversions = Sql.ToBoolean(Application["CONFIG.CurrencyLayer.LogConversions"]);
				if ( String.Compare(sSourceCurrency, sDestinationCurrency, true) != 0 )
					dRate = GetCurrencyConversionRate(Application, sAccessKey, bLogConversions, sSourceCurrency, sDestinationCurrency, sbErrors);
			}
			else
			{
				dRate = Sql.ToFloat(oRate);
			}
			return dRate;
		}

		public float GetCurrencyConversionRate(HttpApplicationState Application, string sAccessKey, bool bLogConversions, string sSourceCurrency, string sDestinationCurrency, StringBuilder sbErrors)
		{
			float dRate = 1.0F;
			try
			{
				if ( String.Compare(sSourceCurrency, sDestinationCurrency, true) == 0 )
				{
					dRate = 1.0F;
				}
				else if ( !Sql.IsEmptyString(sAccessKey) )
				{
					bool bUseEncryptedUrl = Sql.ToBoolean(Application["CONFIG.CurrencyLayer.UseEncryptedUrl"]);
					string sBaseURL = (bUseEncryptedUrl ? "https" : "http") + "://apilayer.net/api/live?access_key=";
					HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(sBaseURL + sAccessKey + "&source=" + sSourceCurrency.ToUpper() + "&currencies=" + sDestinationCurrency.ToUpper());
					objRequest.KeepAlive         = false;
					objRequest.AllowAutoRedirect = false;
					objRequest.Timeout           = 15000;  //15 seconds
					objRequest.Method            = "GET";
					// 04/30/2016 Paul.  Support ETags for efficient lookups. 
					CurrencyLayerETag oETag = Application["CurrencyLayer." + sSourceCurrency + sDestinationCurrency] as CurrencyLayerETag;
					if ( oETag != null )
					{
						objRequest.Headers.Add("If-None-Match", oETag.ETag);
						objRequest.IfModifiedSince = oETag.Date;
					}
					using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
					{
						if ( objResponse != null )
						{
							if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found )
							{
								using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
								{
									string sJsonResponse = readStream.ReadToEnd();
									JsonValue json = JsonValue.Parse(sJsonResponse);
									bool   bSuccess   = json.GetValueOrDefault<bool  >("success"  );
									string sTimestamp = json.GetValueOrDefault<string>("timestamp");
									string sSource    = json.GetValueOrDefault<string>("source"   );
									// {"success":false,"error":{"code":105,"info":"Access Restricted - Your current Subscription Plan does not support HTTPS Encryption."}}
									if ( bSuccess && json.ContainsName("quotes") )
									{
										JsonValue jsonQuotes = json.GetValue("quotes");
										dRate = jsonQuotes.GetValueOrDefault<float>(sSourceCurrency.ToUpper() + sDestinationCurrency.ToUpper());
										int nRateLifetime = Sql.ToInteger(Application["CONFIG.CurrencyLayer.RateLifetime"]);
										if ( nRateLifetime <= 0 )
											nRateLifetime = 90;
										Cache.Set("CurrencyLayer." + sSourceCurrency + sDestinationCurrency, dRate, DateTime.Now.AddMinutes(nRateLifetime));
										oETag = new CurrencyLayerETag();
										oETag.ETag = objResponse.Headers.Get("ETag");
										oETag.Rate = dRate;
										DateTime.TryParse(objResponse.Headers.Get("Date"), out oETag.Date);
										Application["CurrencyLayer." + sSourceCurrency + sDestinationCurrency] = oETag;
										
										SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
										using ( IDbConnection con = dbf.CreateConnection() )
										{
											con.Open();
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													Guid gSYSTEM_CURRENCY_LOG = Guid.Empty;
													if ( bLogConversions )
													{
														SqlProcs.spSYSTEM_CURRENCY_LOG_InsertOnly
															( ref gSYSTEM_CURRENCY_LOG
															, "CurrencyLayer"       // SERVICE_NAME
															, sSourceCurrency       // SOURCE_ISO4217
															, sDestinationCurrency  // DESTINATION_ISO4217
															, dRate                 // CONVERSION_RATE
															, sJsonResponse         // RAW_CONTENT
															, trn
															);
													}
													// 04/30/2016 Paul.  We have to update the currency record as it is used inside stored procedures. 
													if ( sSourceCurrency == SplendidDefaults.BaseCurrencyISO() )
													{
														SqlProcs.spCURRENCIES_UpdateRateByISO
															( sDestinationCurrency
															, dRate
															, gSYSTEM_CURRENCY_LOG
															, trn
															);
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
									else if ( json.ContainsName("error") )
									{
										JsonValue jsonError = json.GetValue("error");
										string sInfo = jsonError.GetValue<string>("info");
										sbErrors.Append(sInfo);
									}
									else
									{
										sbErrors.Append("Conversion not found for " + sSourceCurrency + " to " + sDestinationCurrency + ".");
									}
								}
							}
							else if ( objResponse.StatusCode == HttpStatusCode.NotModified )
							{
								dRate = oETag.Rate;
							}
							else
							{
								sbErrors.Append(objResponse.StatusDescription);
							}
						}
					}
				}
				else
				{
					sbErrors.Append("CurrencyLayer access key is empty.");
				}
				if ( sbErrors.Length > 0 )
				{
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "CurrencyLayer " + sSourceCurrency + sDestinationCurrency + ": " + sbErrors.ToString());
				}
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "CurrencyLayer " + sSourceCurrency + sDestinationCurrency + ": " + Utils.ExpandException(ex));
			}
			return dRate;
		}
	}
}
