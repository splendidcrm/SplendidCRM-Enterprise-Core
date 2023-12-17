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
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Diagnostics;

using Microsoft.AspNetCore.SignalR;
using Microsoft.AspNetCore.Authorization;

using Twilio.Base;
using Twilio.Clients;
using Twilio.Rest.Api.V2010.Account;

namespace SplendidCRM
{
	/// <summary>
	/// Summary description for TwilioManager.
	/// </summary>
	public class TwilioManager
	{
		private IHubContext<TwilioManagerHub> hubContext;
		private IHubClients                   Clients;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidCRM.Crm.Config           Config           = new SplendidCRM.Crm.Config();

		#region arrCountryCodes
		private static string[] arrCountryCodes = new string[]
			{ "+1"    //  United States of America
			, "+20"   //  Egypt (Arab Republic of)
			, "+212"  //  Morocco (Kingdom of)
			, "+213"  //  Algeria (People's Democratic Republic of)
			, "+216"  //  Tunisia
			, "+218"  //  Libya (Socialist People's Libyan Arab Jamahiriya)
			, "+220"  //  Gambia (Republic of the)
			, "+221"  //  Senegal (Republic of)
			, "+222"  //  Mauritania (Islamic Republic of)
			, "+223"  //  Mali (Republic of)
			, "+224"  //  Guinea (Republic of)
			, "+225"  //  C�te d'Ivoire (Republic of)
			, "+226"  //  Burkina Faso
			, "+227"  //  Niger (Republic of the)
			, "+228"  //  Togolese Republic
			, "+229"  //  Benin (Republic of)
			, "+230"  //  Mauritius (Republic of)
			, "+231"  //  Liberia (Republic of)
			, "+232"  //  Sierra Leone
			, "+233"  //  Ghana
			, "+234"  //  Nigeria (Federal Republic of)
			, "+235"  //  Chad (Republic of)
			, "+236"  //  Central African Republic
			, "+237"  //  Cameroon (Republic of)
			, "+238"  //  Cape Verde (Republic of)
			, "+239"  //  Sao Tome and Principe (Democratic Republic of)
			, "+240"  //  Equatorial Guinea (Republic of)
			, "+241"  //  Gabonese Republic
			, "+242"  //  Congo (Republic of the)
			, "+243"  //  Democratic Republic of the Congo
			, "+244"  //  Angola (Republic of)
			, "+245"  //  Guinea-Bissau (Republic of)
			, "+246"  //  Diego Garcia
			, "+247"  //  Ascension
			, "+248"  //  Seychelles (Republic of)
			, "+249"  //  Sudan (Republic of the)
			, "+250"  //  Rwanda (Republic of)
			, "+251"  //  Ethiopia (Federal Democratic Republic of)
			, "+252"  //  Somali Democratic Republic
			, "+253"  //  Djibouti (Republic of)
			, "+254"  //  Kenya (Republic of)
			, "+255"  //  Tanzania (United Republic of)
			, "+256"  //  Uganda (Republic of)
			, "+257"  //  Burundi (Republic of)
			, "+258"  //  Mozambique (Republic of)
			, "+260"  //  Zambia (Republic of)
			, "+261"  //  Madagascar (Republic of)
			, "+262"  //  French Departments and Territories in the Indian Ocean j
			, "+263"  //  Zimbabwe (Republic of)
			, "+264"  //  Namibia (Republic of)
			, "+265"  //  Malawi
			, "+266"  //  Lesotho (Kingdom of)
			, "+267"  //  Botswana (Republic of)
			, "+268"  //  Swaziland (Kingdom of)
			, "+269"  //  Comoros (Union of the) c
			, "+269"  //  Mayotte c
			, "+27"   //  South Africa (Republic of)
			, "+290"  //  Saint Helena a
			, "+290"  //  Tristan da Cunha a
			, "+291"  //  Eritrea
			, "+297"  //  Aruba
			, "+298"  //  Faroe Islands
			, "+299"  //  Greenland (Denmark)
			, "+30"   //  Greece
			, "+31"   //  Netherlands (Kingdom of the)
			, "+32"   //  Belgium
			, "+33"   //  France
			, "+34"   //  Spain
			, "+350"  //  Gibraltar
			, "+351"  //  Portugal
			, "+352"  //  Luxembourg
			, "+353"  //  Ireland
			, "+354"  //  Iceland
			, "+355"  //  Albania (Republic of)
			, "+356"  //  Malta
			, "+357"  //  Cyprus (Republic of)
			, "+358"  //  Finland
			, "+359"  //  Bulgaria (Republic of)
			, "+36"   //  Hungary (Republic of)
			, "+370"  //  Lithuania (Republic of)
			, "+371"  //  Latvia (Republic of)
			, "+372"  //  Estonia (Republic of)
			, "+373"  //  Moldova (Republic of)
			, "+374"  //  Armenia (Republic of)
			, "+375"  //  Belarus (Republic of)
			, "+376"  //  Andorra (Principality of)
			, "+377"  //  Monaco (Principality of)
			, "+378"  //  San Marino (Republic of)
			, "+379"  //  Vatican City State f
			, "+380"  //  Ukraine
			, "+381"  //  Serbia (Republic of)
			, "+382"  //  Montenegro (Republic of)
			, "+385"  //  Croatia (Republic of)
			, "+386"  //  Slovenia (Republic of)
			, "+387"  //  Bosnia and Herzegovina
			, "+388"  //  Group of countries, shared code
			, "+389"  //  The Former Yugoslav Republic of Macedonia
			, "+39"   //  Italy
			, "+39"   //  Vatican City State
			, "+40"   //  Romania
			, "+41"   //  Switzerland (Confederation of)
			, "+420"  //  Czech Republic
			, "+421"  //  Slovak Republic
			, "+423"  //  Liechtenstein (Principality of)
			, "+43"   //  Austria
			, "+44"   //  United Kingdom of Great Britain and Northern Ireland
			, "+45"   //  Denmark
			, "+46"   //  Sweden
			, "+47"   //  Norway
			, "+48"   //  Poland (Republic of)
			, "+49"   //  Germany (Federal Republic of)
			, "+500"  //  Falkland Islands (Malvinas)
			, "+501"  //  Belize
			, "+502"  //  Guatemala (Republic of)
			, "+503"  //  El Salvador (Republic of)
			, "+504"  //  Honduras (Republic of)
			, "+505"  //  Nicaragua
			, "+506"  //  Costa Rica
			, "+507"  //  Panama (Republic of)
			, "+508"  //  Saint Pierre and Miquelon (Collectivit� territoriale de la R�publique fran�aise)
			, "+509"  //  Haiti (Republic of)
			, "+51"   //  Peru
			, "+52"   //  Mexico
			, "+53"   //  Cuba
			, "+54"   //  Argentine Republic
			, "+55"   //  Brazil (Federative Republic of)
			, "+56"   //  Chile
			, "+57"   //  Colombia (Republic of)
			, "+58"   //  Venezuela (Bolivarian Republic of)
			, "+590"  //  Guadeloupe (French Department of)
			, "+591"  //  Bolivia (Republic of)
			, "+592"  //  Guyana
			, "+593"  //  Ecuador
			, "+594"  //  French Guiana (French Department of)
			, "+595"  //  Paraguay (Republic of)
			, "+596"  //  Martinique (French Department of)
			, "+597"  //  Suriname (Republic of)
			, "+598"  //  Uruguay (Eastern Republic of)
			, "+599"  //  Netherlands Antilles
			, "+60"   //  Malaysia
			, "+61"   //  Australia i
			, "+62"   //  Indonesia (Republic of)
			, "+63"   //  Philippines (Republic of the)
			, "+64"   //  New Zealand
			, "+65"   //  Singapore (Republic of)
			, "+66"   //  Thailand
			, "+670"  //  Democratic Republic of Timor-Leste
			, "+672"  //  Australian External Territories g
			, "+673"  //  Brunei Darussalam
			, "+674"  //  Nauru (Republic of)
			, "+675"  //  Papua New Guinea
			, "+676"  //  Tonga (Kingdom of)
			, "+677"  //  Solomon Islands
			, "+678"  //  Vanuatu (Republic of)
			, "+679"  //  Fiji (Republic of)
			, "+680"  //  Palau (Republic of)
			, "+681"  //  Wallis and Futuna (Territoire fran�ais d'outre-mer)
			, "+682"  //  Cook Islands
			, "+683"  //  Niue
			, "+685"  //  Samoa (Independent State of)
			, "+686"  //  Kiribati (Republic of)
			, "+687"  //  New Caledonia (Territoire fran�ais d'outre-mer)
			, "+688"  //  Tuvalu
			, "+689"  //  French Polynesia (Territoire fran�ais d'outre-mer)
			, "+690"  //  Tokelau
			, "+691"  //  Micronesia (Federated States of)
			, "+692"  //  Marshall Islands (Republic of the)
			, "+7"    //  Russian Federation, Kazakhstan
			, "+800"  //  International Freephone Service
			, "+808"  //  International Shared Cost Service (ISCS)
			, "+81"   //  Japan
			, "+82"   //  Korea (Republic of)
			, "+84"   //  Viet Nam (Socialist Republic of)
			, "+850"  //  Democratic People's Republic of Korea
			, "+852"  //  Hong Kong, China
			, "+853"  //  Macao, China
			, "+855"  //  Cambodia (Kingdom of)
			, "+856"  //  Lao People's Democratic Republic
			, "+86"   //  China (People's Republic of)
			, "+870"  //  Inmarsat SNAC
			, "+875"  //  Reserved - Maritime Mobile Service Applications
			, "+876"  //  Reserved - Maritime Mobile Service Applications
			, "+877"  //  Reserved - Maritime Mobile Service Applications
			, "+878"  //  Universal Personal Telecommunication Service (UPT) e
			, "+879"  //  Reserved for national non-commercial purposes
			, "+880"  //  Bangladesh (People's Republic of)
			, "+881"  //  Global Mobile Satellite System (GMSS), shared code n
			, "+882"  //  International Networks, shared code o
			, "+883"  //  International Networks, shared code p, q
			, "+886"  //  Taiwan, China
			, "+888"  //  Telecommunications for Disaster Relief (TDR) k
			, "+90"   //  Turkey
			, "+91"   //  India (Republic of)
			, "+92"   //  Pakistan (Islamic Republic of)
			, "+93"   //  Afghanistan
			, "+94"   //  Sri Lanka (Democratic Socialist Republic of)
			, "+95"   //  Myanmar (Union of)
			, "+960"  //  Maldives (Republic of)
			, "+961"  //  Lebanon
			, "+962"  //  Jordan (Hashemite Kingdom of)
			, "+963"  //  Syrian Arab Republic
			, "+964"  //  Iraq (Republic of)
			, "+965"  //  Kuwait (State of)
			, "+966"  //  Saudi Arabia (Kingdom of)
			, "+967"  //  Yemen (Republic of)
			, "+968"  //  Oman (Sultanate of)
			, "+969"  //  Reserved - reservation currently under investigation
			, "+970"  //  Reserved l
			, "+971"  //  United Arab Emirates h
			, "+972"  //  Israel (State of)
			, "+973"  //  Bahrain (Kingdom of)
			, "+974"  //  Qatar (State of)
			, "+975"  //  Bhutan (Kingdom of)
			, "+976"  //  Mongolia
			, "+977"  //  Nepal (Federal Democratic Republic of)
			, "+979"  //  International Premium Rate Service (IPRS)
			, "+98"   //  Iran (Islamic Republic of)
			, "+992"  //  Tajikistan (Republic of)
			, "+993"  //  Turkmenistan
			, "+994"  //  Azerbaijani Republic
			, "+995"  //  Georgia
			, "+996"  //  Kyrgyz Republic
			, "+998"  //  Uzbekistan (Republic of)
			, "+999"  //  Reserved for future global service
			};
		#endregion

		public TwilioManager(IHubContext<TwilioManagerHub> hubContext, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError)
		{
			this.hubContext          = hubContext         ;
			this.Clients             = hubContext.Clients ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
		}

		#region Helpers
		private object NullID(Guid gID)
		{
			return Sql.IsEmptyGuid(gID) ? null : gID.ToString();
		}
		
		// 09/25/2013 Paul.  Remove US country code. 
		// http://www.onesimcard.com/how-to-dial/
		// http://en.wikipedia.org/wiki/List_of_country_calling_codes
		// http://www.itu.int/dms_pub/itu-t/opb/sp/T-SP-E.164D-2009-PDF-E.pdf
		public static string RemoveCountryCode(string sNumber)
		{
			if ( sNumber.StartsWith("+") )
			{
				for ( int i = 0; i < arrCountryCodes.Length; i++ )
				{
					if ( sNumber.StartsWith(arrCountryCodes[i]) )
					{
						sNumber = sNumber.Substring(arrCountryCodes[i].Length);
						break;
					}
				}
				if ( sNumber.StartsWith("+") )
					sNumber = sNumber.Substring(1);
			}
			return sNumber;
		}

		public static string ValidateLogin(HttpApplicationState Application, string sAccountSID, string sAuthToken)
		{
			string sSTATUS = String.Empty;
			try
			{
				TwilioRestClient client = new TwilioRestClient(sAccountSID, sAuthToken);
				FetchBalanceOptions options = new FetchBalanceOptions();
				BalanceResource result = BalanceResource.Fetch(options, client);
				if ( sAccountSID != result.AccountSid )
					sSTATUS = sAccountSID;
			}
			catch(Exception ex)
			{
				sSTATUS = ex.Message;
			}
			return sSTATUS;
		}

		public static List<MessageResource> ListMessages(HttpApplicationState Application, DateTime dtDateSent, string sFromNumber, string sToNumber, int nPageNumber)
		{
			string sAccountSID  = Sql.ToString(Application["CONFIG.Twilio.AccountSID"]);
			string sAuthToken   = Sql.ToString(Application["CONFIG.Twilio.AuthToken" ]);
			TwilioRestClient client = new TwilioRestClient(sAccountSID, sAuthToken);
			
			// 11/26/2022 Paul.  Update Twilio Rest API. 
			ReadMessageOptions options = new ReadMessageOptions();
			// 11/27/2022 Paul.  Must send null instead of empty string. 
			if ( !Sql.IsEmptyString(sFromNumber) )
				options.From       = sFromNumber;
			if ( !Sql.IsEmptyString(sToNumber) )
				options.To         = sToNumber;
			//options.PageNumber = nPageNumber;
			if ( dtDateSent != DateTime.MinValue )
				options.DateSent = dtDateSent;
			List<MessageResource> lst = new List<MessageResource>();
			ResourceSet<MessageResource> req = MessageResource.Read(options, client);
			if ( req != null )
			{
				IEnumerator<MessageResource> e = req.GetEnumerator();
				if ( e != null )
				{
					while ( e.MoveNext() )
					{
						lst.Add(e.Current);
					}
				}
			}
			return lst;
		}

		public static string SendText(HttpApplicationState Application, SplendidCRM.Crm.Modules Modules, EmailUtils EmailUtils, Guid gID)
		{
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			SplendidCRM.Crm.Config Config = new SplendidCRM.Crm.Config();
			string sAccountSID  = Sql.ToString(Application["CONFIG.Twilio.AccountSID"]);
			string sAuthToken   = Sql.ToString(Application["CONFIG.Twilio.AuthToken" ]);
			string sSiteURL     = Config.SiteURL();
			string sImageURL    = sSiteURL + "Images/EmailImage.aspx?ID=";
			string sCallbackURL = sSiteURL + "TwiML.aspx?ID=" + gID.ToString();
			
			string sMESSAGE_SID = String.Empty;
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL ;
				bool   bReadyToSend  = false;
				string sSUBJECT      = String.Empty;
				string sFROM_NUMBER  = String.Empty;
				string sTO_NUMBER    = String.Empty;
				string sPARENT_TYPE  = String.Empty;
				Guid   gPARENT_ID    = Guid.Empty;
				string sCALLBACK     = String.Empty;
				sSQL = "select *                         " + ControlChars.CrLf
				     + "  from vwSMS_MESSAGES_ReadyToSend" + ControlChars.CrLf
				     + " where ID = @ID                  " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							bReadyToSend = true;
							sPARENT_TYPE = Sql.ToString(rdr["PARENT_TYPE"]);
							gPARENT_ID   = Sql.ToGuid  (rdr["PARENT_ID"  ]);
							sFROM_NUMBER = Sql.ToString(rdr["FROM_NUMBER"]);
							sTO_NUMBER   = Sql.ToString(rdr["TO_NUMBER"  ]);
							sSUBJECT     = Sql.ToString(rdr["NAME"       ]);
							
							if ( !Sql.IsEmptyGuid(gPARENT_ID) )
							{
								DataTable dtParent            = Modules.Parent(sPARENT_TYPE, gPARENT_ID);
								DataView  vwParentColumns     = EmailUtils.SortedTableColumns(dtParent);
								Hashtable hashEnumsColumns    = EmailUtils.EnumColumns(sPARENT_TYPE);
								Hashtable hashCurrencyColumns = new Hashtable();
								if ( dtParent.Rows.Count > 0 )
								{
									string sFillPrefix = String.Empty;
									switch ( sPARENT_TYPE )
									{
										case "Leads"    :
											sFillPrefix = "lead";
											sSUBJECT  = EmailUtils.FillEmail(sSUBJECT , sFillPrefix, dtParent.Rows[0], vwParentColumns, hashCurrencyColumns, hashEnumsColumns);
											sFillPrefix = "contact";
											break;
										case "Prospects":
											sFillPrefix = "prospect";
											sSUBJECT  = EmailUtils.FillEmail(sSUBJECT , sFillPrefix, dtParent.Rows[0], vwParentColumns, hashCurrencyColumns, hashEnumsColumns);
											sFillPrefix = "contact";
											sSUBJECT  = EmailUtils.FillEmail(sSUBJECT , sFillPrefix, dtParent.Rows[0], vwParentColumns, hashCurrencyColumns, hashEnumsColumns);
											break;
										default:
											sFillPrefix = sPARENT_TYPE.ToLower();
											if ( sFillPrefix.EndsWith("ies") )
												sFillPrefix = sFillPrefix.Substring(0, sFillPrefix.Length-3) + "y";
											else if ( sFillPrefix.EndsWith("s") )
												sFillPrefix = sFillPrefix.Substring(0, sFillPrefix.Length-1);
											sSUBJECT  = EmailUtils.FillEmail(sSUBJECT , sFillPrefix, dtParent.Rows[0], vwParentColumns, hashCurrencyColumns, hashEnumsColumns);
											break;
									}
								}
							}
						}
					}
				}
				if ( bReadyToSend )
				{
					// http://www.twilio.com/docs/api/rest/sending-sms
					TwilioRestClient client = new TwilioRestClient(sAccountSID, sAuthToken);
					List<string> arrImages = new List<string>();
					using ( DataTable dtAttachments = new DataTable() )
					{
						sSQL = "select *                     " + ControlChars.CrLf
						     + "  from vwEMAIL_IMAGES        " + ControlChars.CrLf
						     + " where PARENT_ID = @PARENT_ID" + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@PARENT_ID", gID);
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dtAttachments);
							}
						}
						
						if ( dtAttachments.Rows.Count > 0 )
						{
							foreach(DataRow row in dtAttachments.Rows)
							{
								string sFILENAME       = Sql.ToString(row["FILENAME"      ]);
								string sFILE_MIME_TYPE = Sql.ToString(row["FILE_MIME_TYPE"]);
								Guid   gIMAGE_ID       = Sql.ToGuid  (row["ID"            ]);
								arrImages.Add(sImageURL + gIMAGE_ID.ToString());
							}
						}
					}
					// 11/26/2022 Paul.  Update Twilio Rest API. 
					CreateMessageOptions options = new CreateMessageOptions(sTO_NUMBER);
					options.From           = sFROM_NUMBER;
					options.Body           = sSUBJECT    ;
					options.StatusCallback = new Uri(sCallbackURL);
					if ( arrImages.Count > 0 )
					{
						options.MediaUrl = new List<Uri>();
						foreach ( string sImage in arrImages )
						{
							options.MediaUrl.Add(new Uri(sImage));
						}
					}
					MessageResource msg = MessageResource.Create(options, client);
					if ( msg == null && arrImages.Count > 0 )
						throw(new Exception("Cannot send a picture using this phone number."));
					else
						sMESSAGE_SID = msg.Sid;
				}
			}
			return sMESSAGE_SID;
		}

		// 12/23/2013 Paul.  Add SMS_REMINDER_TIME. 
		public static string SendText(HttpApplicationState Application, string sFROM_NUMBER, string sTO_NUMBER, string sSUBJECT)
		{
			SplendidCRM.Crm.Config Config = new SplendidCRM.Crm.Config();
			string sAccountSID  = Sql.ToString(Application["CONFIG.Twilio.AccountSID"]);
			string sAuthToken   = Sql.ToString(Application["CONFIG.Twilio.AuthToken" ]);
			string sSiteURL     = Config.SiteURL();
			string sCallbackURL = String.Empty;
			string sMESSAGE_SID = String.Empty;
			
			TwilioRestClient client = new TwilioRestClient(sAccountSID, sAuthToken);
			// 11/26/2022 Paul.  Update Twilio Rest API. 
			CreateMessageOptions options = new CreateMessageOptions(sTO_NUMBER);
			options.From           = sFROM_NUMBER;
			options.Body           = sSUBJECT    ;
			options.StatusCallback = new Uri(sCallbackURL);
			MessageResource msg = MessageResource.Create(options, client);
			if ( msg != null )
				sMESSAGE_SID = msg.Sid;
			return sMESSAGE_SID;
		}
		#endregion

		public async Task<Guid> CreateSmsMessage(string sMESSAGE_SID, string sFROM_NUMBER, string sTO_NUMBER, string sSUBJECT, string sFROM_LOCATION, string sTO_LOCATION)
		{
			// 06/19/2023 Paul.  Delay just to eliminate warning CS1998. 
			await Task.Delay(1);

			Guid gID = Guid.Empty;
			string sPARENT_TYPE = String.Empty;
			Guid   gPARENT_ID   = Guid.Empty;
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL;
				sSQL = "select *              " + ControlChars.CrLf
				     + "  from vwPHONE_NUMBERS" + ControlChars.CrLf
				     + " where 1 = 1          " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					// 09/25/2013 Paul.  Remove country code as most customers will only use the country code when different than their country. 
					string sNUMBER = TwilioManager.RemoveCountryCode(sFROM_NUMBER);
					Sql.AppendParameter(cmd, sNUMBER, Sql.SqlFilterMode.Contains, "NORMALIZED_NUMBER");
					cmd.CommandText += " order by PARENT_TYPE" + ControlChars.CrLf;
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							sPARENT_TYPE = Sql.ToString(rdr["PARENT_TYPE"]);
							gPARENT_ID   = Sql.ToGuid  (rdr["PARENT_ID"  ]);
						}
					}
				}
			}
			// 09/25/2013 Paul.  Set the default for the team to be the Global team. 
			Guid gTEAM_ID = new Guid("17BB7135-2B95-42DC-85DE-842CAFF927A0");
			SqlProcs.spSMS_MESSAGES_Update
				( ref gID
				, Guid.Empty      // ASSIGNED_USER_ID
				, gTEAM_ID        // TEAM_ID         
				, String.Empty    // TEAM_SET_LIST   
				, Guid.Empty      // MAILBOX_ID      
				, sSUBJECT        // NAME            
				, DateTime.Now    // DATE_TIME       
				, sPARENT_TYPE    // PARENT_TYPE     
				, gPARENT_ID      // PARENT_ID       
				, sFROM_NUMBER    // FROM_NUMBER     
				, sTO_NUMBER      // TO_NUMBER       
				, Guid.Empty      // TO_ID           
				, "inbound"       // TYPE            
				, sMESSAGE_SID    // MESSAGE_SID     
				, sFROM_LOCATION  // FROM_LOCATION   
				, sTO_LOCATION    // TO_LOCATION     
				// 05/17/2017 Paul.  Add Tags module. 
				, String.Empty    // TAG_SET_NAME
				// 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
				, false           // IS_PRIVATE
				// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
				, String.Empty    // ASSIGNED_SET_LIST
				);
			return gID;
		}

		public async Task NewSmsMessage(string sMESSAGE_SID, string sFROM_NUMBER, string sTO_NUMBER, string sSUBJECT, string sFROM_LOCATION, string sTO_LOCATION)
		{
			bool   bLogInboundMessages = Sql.ToBoolean(Application["CONFIG.Twilio.LogInboundMessages"]);
			try
			{
				Guid gID = Guid.Empty;
				if ( bLogInboundMessages )
				{
					gID = await CreateSmsMessage(sMESSAGE_SID, sFROM_NUMBER, sTO_NUMBER, sSUBJECT, sFROM_LOCATION, sTO_LOCATION);
				}
				string sGroupName = Utils.NormalizePhone(TwilioManager.RemoveCountryCode(sTO_NUMBER));
				await Clients.Group(RemoveCountryCode(sGroupName)).SendAsync("incomingMessage", sMESSAGE_SID, sFROM_NUMBER, sTO_NUMBER, sSUBJECT, NullID(gID));
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
			}
		}
	}
}

