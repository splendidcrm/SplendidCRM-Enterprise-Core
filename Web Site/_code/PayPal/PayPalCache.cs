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
using System.Web;
using System.Data;
using System.Collections.Specialized;
//using Mono.Security.Cryptography;

using Microsoft.Extensions.Caching.Memory;

namespace SplendidCRM
{
	/// <summary>
	/// Summary description for PayPalCache.
	/// </summary>
	public class PayPalCache
	{
		private HttpApplicationState Application        = new HttpApplicationState();
		private IMemoryCache         Cache              ;
		
		public PayPalCache(IMemoryCache memoryCache)
		{
			this.Cache               = memoryCache        ;
		}

		// 08/16/2015 Paul.  Add CARD_TOKEN for use with PayPal REST API. 
		public string PayPalClientID()
		{
			return Sql.ToString(Application["CONFIG.PayPal.ClientID"]);
		}

		public string PayPalClientSecret()
		{
			return Sql.ToString(Application["CONFIG.PayPal.ClientSecret"]);
		}

		public string PayPalWebServiceURL()
		{
			if ( Sql.ToBoolean(Application["CONFIG.PayPal.Sandbox"]) )
				return "https://api.sandbox.paypal.com/2.0/";
			else
				return "https://api.paypal.com/2.0/";
		}

		// 10/14/2008 Paul.  Used for Authorization & Capture, Direct Payments and Express Checkout. 
		public string PayPalAuthorizationURL()
		{
			if ( Sql.ToBoolean(Application["CONFIG.PayPal.Sandbox"]) )
				return "https://api-aa.sandbox.paypal.com/2.0/";
			else
				return "https://api-aa.paypal.com/2.0/";
		}

		// 10/15/2007 Paul.  Cache the PayPal data, but for a very short period of time. 
		public DateTime DefaultCacheExpiration()
		{
			return DateTime.Now.AddMinutes(1);
		}

		public void ClearTransaction(string sTransactionID)
		{
			// 11/15/2009 Paul.  It is better to get the cache from the Runtime object instead of the context. 
			Cache.Remove("PayPal.Transaction." + sTransactionID);
		}

		// 07/08/2023 Paul.  TODO.  Support PayPal. 
/*
		public DataSet Transaction(string sTransactionID)
		{
			// 11/15/2009 Paul.  It is better to get the cache from the Runtime object instead of the context. 
			DataSet ds = Cache.Get("PayPal.Transaction." + sTransactionID) as DataSet;
			if ( ds == null )
			{
				// 11/15/2009 Paul.  We need a version of the certificate function that accepts the application. 
				PayPalAPI api = CreatePayPalAPI();
				ds = api.GetTransactionDetails(sTransactionID);
				Cache.Set("PayPal.Transaction." + sTransactionID, ds, this.DefaultCacheExpiration());
			}
			return ds;
		}
*/

		public StringDictionary Countries()
		{
			// 11/15/2009 Paul.  It is better to get the cache from the Runtime object instead of the context. 
			StringDictionary dict = Cache.Get("PayPal.Contries") as StringDictionary;
			if ( dict == null )
			{
				dict = new StringDictionary();
				dict.Add("AFGHANISTAN", "AF");
				dict.Add("�LAND ISLANDS", "AX");
				dict.Add("ALBANIA", "AL");
				dict.Add("ALGERIA", "DZ");
				dict.Add("AMERICAN SAMOA", "AS");
				dict.Add("ANDORRA", "AD");
				dict.Add("ANGOLA", "AO");
				dict.Add("ANGUILLA", "AI");
				dict.Add("ANTARCTICA", "AQ");
				dict.Add("ANTIGUA AND BARBUDA", "AG");
				dict.Add("ARGENTINA", "AR");
				dict.Add("ARMENIA", "AM");
				dict.Add("ARUBA", "AW");
				dict.Add("AUSTRALIA", "AU");
				dict.Add("AUSTRIA", "AT");
				dict.Add("AZERBAIJAN", "AZ");
				dict.Add("BAHAMAS", "BS");
				dict.Add("BAHRAIN", "BH");
				dict.Add("BANGLADESH", "BD");
				dict.Add("BARBADOS", "BB");
				dict.Add("BELARUS", "BY");
				dict.Add("BELGIUM", "BE");
				dict.Add("BELIZE", "BZ");
				dict.Add("BENIN", "BJ");
				dict.Add("BERMUDA", "BM");
				dict.Add("BHUTAN", "BT");
				dict.Add("BOLIVIA", "BO");
				dict.Add("BOSNIA AND HERZEGOVINA", "BA");
				dict.Add("BOTSWANA", "BW");
				dict.Add("BOUVET ISLAND", "BV");
				dict.Add("BRAZIL", "BR");
				dict.Add("BRITISH INDIAN OCEAN TERRITORY", "IO");
				dict.Add("BRUNEI DARUSSALAM", "BN");
				dict.Add("BULGARIA", "BG");
				dict.Add("BURKINA FASO", "BF");
				dict.Add("BURUNDI", "BI");
				dict.Add("CAMBODIA", "KH");
				dict.Add("CAMEROON", "CM");
				dict.Add("CANADA", "CA");
				dict.Add("CAPE VERDE", "CV");
				dict.Add("CAYMAN ISLANDS", "KY");
				dict.Add("CENTRAL AFRICAN REPUBLIC", "CF");
				dict.Add("CHAD", "TD");
				dict.Add("CHILE", "CL");
				dict.Add("CHINA", "CN");
				dict.Add("CHRISTMAS ISLAND", "CX");
				dict.Add("COCOS (KEELING) ISLANDS", "CC");
				dict.Add("COLOMBIA", "CO");
				dict.Add("COMOROS", "KM");
				dict.Add("CONGO", "CG");
				dict.Add("CONGO, THE DEMOCRATIC REPUBLIC OF THE", "CD");
				dict.Add("COOK ISLANDS", "CK");
				dict.Add("COSTA RICA", "CR");
				dict.Add("COTE D'IVOIRE", "CI");
				dict.Add("CROATIA", "HR");
				dict.Add("CUBA", "CU");
				dict.Add("CYPRUS", "CY");
				dict.Add("CZECH REPUBLIC", "CZ");
				dict.Add("DENMARK", "DK");
				dict.Add("DJIBOUTI", "DJ");
				dict.Add("DOMINICA", "DM");
				dict.Add("DOMINICAN REPUBLIC", "DO");
				dict.Add("ECUADOR", "EC");
				dict.Add("EGYPT", "EG");
				dict.Add("EL SALVADOR", "SV");
				dict.Add("EQUATORIAL GUINEA", "GQ");
				dict.Add("ERITREA", "ER");
				dict.Add("ESTONIA", "EE");
				dict.Add("ETHIOPIA", "ET");
				dict.Add("FALKLAND ISLANDS (MALVINAS)", "FK");
				dict.Add("FAROE ISLANDS", "FO");
				dict.Add("FIJI", "FJ");
				dict.Add("FINLAND", "FI");
				dict.Add("FRANCE", "FR");
				dict.Add("FRENCH GUIANA", "GF");
				dict.Add("FRENCH POLYNESIA", "PF");
				dict.Add("FRENCH SOUTHERN TERRITORIES", "TF");
				dict.Add("GABON", "GA");
				dict.Add("GAMBIA", "GM");
				dict.Add("GEORGIA", "GE");
				dict.Add("GERMANY", "DE");
				dict.Add("GHANA", "GH");
				dict.Add("GIBRALTAR", "GI");
				dict.Add("GREECE", "GR");
				dict.Add("GREENLAND", "GL");
				dict.Add("GRENADA", "GD");
				dict.Add("GUADELOUPE", "GP");
				dict.Add("GUAM", "GU");
				dict.Add("GUATEMALA", "GT");
				dict.Add("GUERNSEY", "GG");
				dict.Add("GUINEA", "GN");
				dict.Add("GUINEA-BISSAU", "GW");
				dict.Add("GUYANA", "GY");
				dict.Add("HAITI", "HT");
				dict.Add("HEARD ISLAND AND MCDONALD ISLANDS", "HM");
				dict.Add("HOLY SEE (VATICAN CITY STATE)", "VA");
				dict.Add("HONDURAS", "HN");
				dict.Add("HONG KONG", "HK");
				dict.Add("HUNGARY", "HU");
				dict.Add("ICELAND", "IS");
				dict.Add("INDIA", "IN");
				dict.Add("INDONESIA", "ID");
				dict.Add("IRAN, ISLAMIC REPUBLIC OF", "IR");
				dict.Add("IRAQ", "IQ");
				dict.Add("IRELAND", "IE");
				dict.Add("ISLE OF MAN", "IM");
				dict.Add("ISRAEL", "IL");
				dict.Add("ITALY", "IT");
				dict.Add("JAMAICA", "JM");
				dict.Add("JAPAN", "JP");
				dict.Add("JERSEY", "JE");
				dict.Add("JORDAN", "JO");
				dict.Add("KAZAKHSTAN", "KZ");
				dict.Add("KENYA", "KE");
				dict.Add("KIRIBATI", "KI");
				dict.Add("KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF", "KP");
				dict.Add("KOREA, REPUBLIC OF", "KR");
				dict.Add("KUWAIT", "KW");
				dict.Add("KYRGYZSTAN", "KG");
				dict.Add("LAO PEOPLE'S DEMOCRATIC REPUBLIC", "LA");
				dict.Add("LATVIA", "LV");
				dict.Add("LEBANON", "LB");
				dict.Add("LESOTHO", "LS");
				dict.Add("LIBERIA", "LR");
				dict.Add("LIBYAN ARAB JAMAHIRIYA", "LY");
				dict.Add("LIECHTENSTEIN", "LI");
				dict.Add("LITHUANIA", "LT");
				dict.Add("LUXEMBOURG", "LU");
				dict.Add("MACAO", "MO");
				dict.Add("MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF", "MK");
				dict.Add("MADAGASCAR", "MG");
				dict.Add("MALAWI", "MW");
				dict.Add("MALAYSIA", "MY");
				dict.Add("MALDIVES", "MV");
				dict.Add("MALI", "ML");
				dict.Add("MALTA", "MT");
				dict.Add("MARSHALL ISLANDS", "MH");
				dict.Add("MARTINIQUE", "MQ");
				dict.Add("MAURITANIA", "MR");
				dict.Add("MAURITIUS", "MU");
				dict.Add("MAYOTTE", "YT");
				dict.Add("MEXICO", "MX");
				dict.Add("MICRONESIA, FEDERATED STATES OF", "FM");
				dict.Add("MOLDOVA, REPUBLIC OF", "MD");
				dict.Add("MONACO", "MC");
				dict.Add("MONGOLIA", "MN");
				dict.Add("MONTSERRAT", "MS");
				dict.Add("MOROCCO", "MA");
				dict.Add("MOZAMBIQUE", "MZ");
				dict.Add("MYANMAR", "MM");
				dict.Add("NAMIBIA", "NA");
				dict.Add("NAURU", "NR");
				dict.Add("NEPAL", "NP");
				dict.Add("NETHERLANDS", "NL");
				dict.Add("NETHERLANDS ANTILLES", "AN");
				dict.Add("NEW CALEDONIA", "NC");
				dict.Add("NEW ZEALAND", "NZ");
				dict.Add("NICARAGUA", "NI");
				dict.Add("NIGER", "NE");
				dict.Add("NIGERIA", "NG");
				dict.Add("NIUE", "NU");
				dict.Add("NORFOLK ISLAND", "NF");
				dict.Add("NORTHERN MARIANA ISLANDS", "MP");
				dict.Add("NORWAY", "NO");
				dict.Add("OMAN", "OM");
				dict.Add("PAKISTAN", "PK");
				dict.Add("PALAU", "PW");
				dict.Add("PALESTINIAN TERRITORY, OCCUPIED", "PS");
				dict.Add("PANAMA", "PA");
				dict.Add("PAPUA NEW GUINEA", "PG");
				dict.Add("PARAGUAY", "PY");
				dict.Add("PERU", "PE");
				dict.Add("PHILIPPINES", "PH");
				dict.Add("PITCAIRN", "PN");
				dict.Add("POLAND", "PL");
				dict.Add("PORTUGAL", "PT");
				dict.Add("PUERTO RICO", "PR");
				dict.Add("QATAR", "QA");
				dict.Add("REUNION", "RE");
				dict.Add("ROMANIA", "RO");
				dict.Add("RUSSIAN FEDERATION", "RU");
				dict.Add("RWANDA", "RW");
				dict.Add("SAINT HELENA", "SH");
				dict.Add("SAINT KITTS AND NEVIS", "KN");
				dict.Add("SAINT LUCIA", "LC");
				dict.Add("SAINT PIERRE AND MIQUELON", "PM");
				dict.Add("SAINT VINCENT AND THE GRENADINES", "VC");
				dict.Add("SAMOA", "WS");
				dict.Add("SAN MARINO", "SM");
				dict.Add("SAO TOME AND PRINCIPE", "ST");
				dict.Add("SAUDI ARABIA", "SA");
				dict.Add("SENEGAL", "SN");
				dict.Add("SERBIA AND MONTENEGRO", "CS");
				dict.Add("SEYCHELLES", "SC");
				dict.Add("SIERRA LEONE", "SL");
				dict.Add("SINGAPORE", "SG");
				dict.Add("SLOVAKIA", "SK");
				dict.Add("SLOVENIA", "SI");
				dict.Add("SOLOMON ISLANDS", "SB");
				dict.Add("SOMALIA", "SO");
				dict.Add("SOUTH AFRICA", "ZA");
				dict.Add("SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS", "GS");
				dict.Add("SPAIN", "ES");
				dict.Add("SRI LANKA", "LK");
				dict.Add("SUDAN", "SD");
				dict.Add("SURINAME", "SR");
				dict.Add("SVALBARD AND JAN MAYEN", "SJ");
				dict.Add("SWAZILAND", "SZ");
				dict.Add("SWEDEN", "SE");
				dict.Add("SWITZERLAND", "CH");
				dict.Add("SYRIAN ARAB REPUBLIC", "SY");
				// 10/04/2009 Paul.  Reduce to Taiwan as that is what we have stored in the database. 
				dict.Add("TAIWAN", "TW");
				dict.Add("TAJIKISTAN", "TJ");
				dict.Add("TANZANIA, UNITED REPUBLIC OF", "TZ");
				dict.Add("THAILAND", "TH");
				dict.Add("TIMOR-LESTE", "TL");
				dict.Add("TOGO", "TG");
				dict.Add("TOKELAU", "TK");
				dict.Add("TONGA", "TO");
				dict.Add("TRINIDAD AND TOBAGO", "TT");
				dict.Add("TUNISIA", "TN");
				dict.Add("TURKEY", "TR");
				dict.Add("TURKMENISTAN", "TM");
				dict.Add("TURKS AND CAICOS ISLANDS", "TC");
				dict.Add("TUVALU", "TV");
				dict.Add("UGANDA", "UG");
				dict.Add("UKRAINE", "UA");
				dict.Add("UNITED ARAB EMIRATES", "AE");
				dict.Add("UNITED KINGDOM", "GB");
				dict.Add("UNITED STATES", "US");
				dict.Add("UNITED STATES MINOR OUTLYING ISLANDS", "UM");
				dict.Add("URUGUAY", "UY");
				dict.Add("UZBEKISTAN", "UZ");
				dict.Add("VANUATU", "VU");
				dict.Add("VENEZUELA", "VE");
				dict.Add("VIET NAM", "VN");
				dict.Add("VIRGIN ISLANDS, BRITISH", "VG");
				dict.Add("VIRGIN ISLANDS, U.S.", "VI");
				dict.Add("WALLIS AND FUTUNA", "WF");
				dict.Add("WESTERN SAHARA", "EH");
				dict.Add("YEMEN", "YE");
				dict.Add("ZAMBIA", "ZM");
				dict.Add("ZIMBABWE", "ZW");
				// 09/13/2013 Paul.  Keep this list in memory for a long time. 
				Cache.Set("PayPal.Contries", dict, DateTime.Now.AddYears(1));
			}
			return dict;
		}

		// 09/13/2013 Paul.  PayTrace requires 2-character state codes. 
		public StringDictionary States()
		{
			StringDictionary dict = Cache.Get("PayPal.States") as StringDictionary;
			if ( dict == null )
			{
				dict = new StringDictionary();
				dict.Add("ALABAMA"                       , "AL");
				dict.Add("ALASKA"                        , "AK");
				dict.Add("ARIZONA"                       , "AZ");
				dict.Add("ARKANSAS"                      , "AR");
				dict.Add("CALIFORNIA"                    , "CA");
				dict.Add("COLORADO"                      , "CO");
				dict.Add("CONNECTICUT"                   , "CT");
				dict.Add("DELAWARE"                      , "DE");
				dict.Add("FLORIDA"                       , "FL");
				dict.Add("GEORGIA"                       , "GA");
				dict.Add("HAWAII"                        , "HI");
				dict.Add("IDAHO"                         , "ID");
				dict.Add("ILLINOIS"                      , "IL");
				dict.Add("INDIANA"                       , "IN");
				dict.Add("IOWA"                          , "IA");
				dict.Add("KANSAS"                        , "KS");
				dict.Add("KENTUCKY"                      , "KY");
				dict.Add("LOUISIANA"                     , "LA");
				dict.Add("MAINE"                         , "ME");
				dict.Add("MARYLAND"                      , "MD");
				dict.Add("MASSACHUSETTS"                 , "MA");
				dict.Add("MICHIGAN"                      , "MI");
				dict.Add("MINNESOTA"                     , "MN");
				dict.Add("MISSISSIPPI"                   , "MS");
				dict.Add("MISSOURI"                      , "MO");
				dict.Add("MONTANA"                       , "MT");
				dict.Add("NEBRASKA"                      , "NE");
				dict.Add("NEVADA"                        , "NV");
				dict.Add("NEW HAMPSHIRE"                 , "NH");
				dict.Add("NEW JERSEY"                    , "NJ");
				dict.Add("NEW MEXICO"                    , "NM");
				dict.Add("NEW YORK"                      , "NY");
				dict.Add("NORTH CAROLINA"                , "NC");
				dict.Add("NORTH DAKOTA"                  , "ND");
				dict.Add("OHIO"                          , "OH");
				dict.Add("OKLAHOMA"                      , "OK");
				dict.Add("OREGON"                        , "OR");
				dict.Add("PENNSYLVANIA"                  , "PA");
				dict.Add("RHODE ISLAND"                  , "RI");
				dict.Add("SOUTH CAROLINA"                , "SC");
				dict.Add("SOUTH DAKOTA"                  , "SD");
				dict.Add("TENNESSEE"                     , "TN");
				dict.Add("TEXAS"                         , "TX");
				dict.Add("UTAH"                          , "UT");
				dict.Add("VERMONT"                       , "VT");
				dict.Add("VIRGINIA"                      , "VA");
				dict.Add("WASHINGTON"                    , "WA");
				dict.Add("WEST VIRGINIA"                 , "WV");
				dict.Add("WISCONSIN"                     , "WI");
				dict.Add("WYOMING"                       , "WY");
				dict.Add("AMERICAN SAMOA"                , "AS");
				dict.Add("DISTRICT OF COLUMBIA"          , "DC");
				dict.Add("FEDERATED STATES OF MICRONESIA", "FM");
				dict.Add("GUAM"                          , "GU");
				dict.Add("MARSHALL ISLANDS"              , "MH");
				dict.Add("NORTHERN MARIANA ISLANDS"      , "MP");
				dict.Add("PALAU"                         , "PW");
				dict.Add("PUERTO RICO"                   , "PR");
				dict.Add("VIRGIN ISLANDS"                , "VI");
				// 09/13/2013 Paul.  Keep this list in memory for a long time. 
				Cache.Set("PayPal.States", dict, DateTime.Now.AddYears(1));
			}
			return dict;
		}
	}
}
