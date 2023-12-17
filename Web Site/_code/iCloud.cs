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
using System.Collections.Generic;
using System.Xml;
using System.Text;
using System.Text.Json;
using System.Net;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Diagnostics;
using Microsoft.AspNetCore.Http;
using SplendidCRM;

namespace iCloud
{
	public class iCloudSession
	{
		public string   ClientToken              { get; set; }
		public string   AppleID                  { get; set; }
		public string   PrincipalID              { get; set; }
		public string   FullName                 { get; set; }
		public string   FirstName                { get; set; }
		public string   LastName                 { get; set; }
		public string   PrimaryEmail             { get; set; }
		public string   DataclassReminders       { get; set; }
		public string   DataclassMediaStream     { get; set; }
		public string   DataclassBookmarks       { get; set; }
		public string   DataclassContacts        { get; set; }
		public string   DataclassCalendars       { get; set; }
		public string   DataclassContent         { get; set; }
		public string   DataclassMail            { get; set; }
		public string   DataclassMobileDocuments { get; set; }
		public string   DataclassUbiquity        { get; set; }
		public string   DataclassNotes           { get; set; }

		public string   ContactsPrincipalHref    { get; set; }
		public string   ContactsURL              { get; set; }
		public DateTime ContactsLastModified     { get; set; }
		public string   ContactsCTag             { get; set; }
		public string   ContactsCTagUrl          { get; set; }

		public string   CalendarPrincipalHref    { get; set; }
		public string   CalendarURL              { get; set; }
		public DateTime CalendarLastModified     { get; set; }
		public string   CalendarCTag             { get; set; }
		public string   CalendarCTagUrl          { get; set; }

		public iCloudSession(string sContactsCTag, string sCalendarCTag)
		{
			this.ContactsCTag = sContactsCTag;
			this.CalendarCTag = sCalendarCTag;
		}
	}

	[DataContract]
	public class iCloudSession2
	{
		[DataContract]
		public class DsInfo
		{
			[DataMember] public string   lastName                  { get; set; }
			[DataMember] public bool     iCDPEnabled               { get; set; }
			[DataMember] public bool     tantorMigrated            { get; set; }
			[DataMember] public string   dsid                      { get; set; }
			[DataMember] public bool     hsaEnabled                { get; set; }
			[DataMember] public bool     ironcadeMigrated          { get; set; }
			[DataMember] public string   locale                    { get; set; }
			[DataMember] public bool     brZoneConsolidated        { get; set; }
			[DataMember] public bool     isManagedAppleID          { get; set; }
			[DataMember(Name="gilligan-invited")]
			             public bool     gilliganInvited           { get; set; }
			[DataMember] public string[] appleIdAliases            { get; set; }
			[DataMember] public int      hsaVersion                { get; set; }
			[DataMember] public bool     isPaidDeveloper           { get; set; }
			[DataMember] public string   countryCode               { get; set; }
			[DataMember] public string   notificationId            { get; set; }
			[DataMember] public bool     primaryEmailVerified      { get; set; }
			[DataMember] public string   aDsID                     { get; set; }
			[DataMember] public bool     locked                    { get; set; }
			[DataMember] public bool     hasICloudQualifyingDevice { get; set; }
			[DataMember] public string   primaryEmail              { get; set; }
			
			[DataContract]
			public class AppleIdEntries
			{
				[DataMember] public bool     isPrimary             { get; set; }
				[DataMember] public string   type                  { get; set; }
				[DataMember] public string   value                 { get; set; }
			}
			[DataMember] public AppleIdEntries[] appleIdEntries    { get; set; }
			
			[DataMember(Name="gilligan-enabled")]
			             public bool     gilliganEnabled           { get; set; }
			[DataMember] public string   fullName                  { get; set; }
			[DataMember] public string   languageCode              { get; set; }
			[DataMember] public string   appleId                   { get; set; }
			[DataMember] public string   firstName                 { get; set; }
			[DataMember] public string   iCloudAppleIdAlias        { get; set; }
			[DataMember] public bool     notesMigrated             { get; set; }
			[DataMember] public bool     hasPaymentInfo            { get; set; }
			[DataMember] public bool     pcsDeleted                { get; set; }
			[DataMember] public string   appleIdAlias              { get; set; }
			[DataMember] public bool     brMigrated                { get; set; }
			[DataMember] public int      statusCode                { get; set; }
			[DataMember] public bool     familyEligible            { get; set; }
		}
		[DataMember] public DsInfo dsInfo;

		[DataMember] public bool     hasMinimumDeviceForPhotosWeb  { get; set; }
		[DataMember] public bool     iCDPEnabled                   { get; set; }

		[DataContract]
		public class WebServices
		{
			[DataContract]
			public class WebService
			{
				[DataMember] public bool     pcsRequired           { get; set; }
				[DataMember] public string   uploadUrl             { get; set; }
				[DataMember] public string   url                   { get; set; }
				[DataMember] public string   status                { get; set; }
				[DataMember] public string   iReporter_GCBD_URL    { get; set; }
				[DataContract]
				public class ICloudEnv
				{
					[DataMember] public string   shortId           { get; set; }
					[DataMember] public string   vipSuffix         { get; set; }
				}
				[DataMember] public ICloudEnv iCloudEnv            { get; set; }
			}

			[DataMember] public WebService   reminders             { get; set; }
			[DataMember] public WebService   ckdatabasews          { get; set; }
			[DataMember] public WebService   photosupload          { get; set; }
			[DataMember] public WebService   photos                { get; set; }
			[DataMember] public WebService   drivews               { get; set; }
			[DataMember] public WebService   uploadimagews         { get; set; }
			[DataMember] public WebService   schoolwork            { get; set; }
			[DataMember] public WebService   cksharews             { get; set; }
			[DataMember] public WebService   ireporter             { get; set; }
			[DataMember] public WebService   findme                { get; set; }
			[DataMember] public WebService   ckdeviceservice       { get; set; }
			[DataMember] public WebService   iworkthumbnailws      { get; set; }
			[DataMember] public WebService   calendar              { get; set; }
			[DataMember] public WebService   docws                 { get; set; }
			[DataMember] public WebService   settings              { get; set; }
			[DataMember] public WebService   ubiquity              { get; set; }
			[DataMember] public WebService   streams               { get; set; }
			[DataMember] public WebService   keyvalue              { get; set; }
			[DataMember] public WebService   archivews             { get; set; }
			[DataMember] public WebService   push                  { get; set; }
			[DataMember] public WebService   iwmb                  { get; set; }
			[DataMember] public WebService   iworkexportws         { get; set; }
			[DataMember] public WebService   geows                 { get; set; }
			[DataMember] public WebService   account               { get; set; }
			[DataMember] public WebService   fmf                   { get; set; }
			[DataMember] public WebService   contacts              { get; set; }
		}
		[DataMember] public WebServices webservices                { get; set; }
		[DataMember] public bool        pcsEnabled                 { get; set; }
		
		[DataContract]
		public class ConfigBag
		{
			[DataContract]
			public class Urls
			{
				[DataMember] public string   accountCreateUI       { get; set; }
				[DataMember] public string   accountLoginUI        { get; set; }
				[DataMember] public string   accountLogin          { get; set; }
				[DataMember] public string   accountRepairUI       { get; set; }
				[DataMember] public string   downloadICloudTerms   { get; set; }
				[DataMember] public string   repairDone            { get; set; }
				[DataMember] public string   accountAuthorizeUI    { get; set; }
				[DataMember] public string   vettingUrlForEmail    { get; set; }
				[DataMember] public string   accountCreate         { get; set; }
				[DataMember] public string   getICloudTerms        { get; set; }
				[DataMember] public string   vettingUrlForPhone    { get; set; }
			}
			[DataMember] public Urls     urls                      { get; set; }
			[DataMember] public bool     accountCreateEnabled      { get; set; }
		}
		[DataMember] public ConfigBag configBag  { get; set; }

		[DataMember] public bool     hsaTrustedBrowser             { get; set; }
		[DataMember] public string[] appsOrder                     { get; set; }
		[DataMember] public int      version                       { get; set; }
		[DataMember] public bool     isExtendedLogin               { get; set; }
		[DataMember] public bool     pcsServiceIdentitiesIncluded  { get; set; }
		[DataMember] public bool     hsaChallengeRequired          { get; set; }
		
		[DataContract]
		public class RequestInfo
		{
			[DataMember] public string   country                   { get; set; }
			[DataMember] public string   timeZone                  { get; set; }
			[DataMember] public string   region                    { get; set; }
		}
		[DataMember] public RequestInfo  requestInfo               { get; set; }
		[DataMember] public bool         pcsDeleted                { get; set; }
		
		[DataContract]
		public class ICloudInfo
		{
			[DataMember] public bool     SafariBookmarksHasMigratedToCloudKit { get; set; }
		}
		[DataMember] public ICloudInfo iCloudInfo                  { get; set; }
		
		[DataContract]
		public class Apps
		{
			[DataContract]
			public class AppsInfo
			{
				[DataMember] public bool     isQualifiedForBeta     { get; set; }
				[DataMember] public bool     canLaunchWithOneFactor { get; set; }
				[DataMember] public bool     isHidden               { get; set; }
			}

			[DataMember] public AppsInfo calendar                   { get; set; }
			[DataMember] public AppsInfo reminders                  { get; set; }
			[DataMember] public AppsInfo keynote                    { get; set; }
			[DataMember] public AppsInfo settings                   { get; set; }
			[DataMember] public AppsInfo mail                       { get; set; }
			[DataMember] public AppsInfo numbers                    { get; set; }
			[DataMember] public AppsInfo photos                     { get; set; }
			[DataMember] public AppsInfo pages                      { get; set; }
			[DataMember] public AppsInfo notes3                     { get; set; }
			[DataMember] public AppsInfo find                       { get; set; }
			[DataMember] public AppsInfo iclouddrive                { get; set; }
			[DataMember] public AppsInfo newspublisher              { get; set; }
			[DataMember] public AppsInfo fmf                        { get; set; }
			[DataMember] public AppsInfo contacts                   { get; set; }
		}
		[DataMember] public Apps apps { get; set; }

		public CookieCollection Cookies;
	}

	public class iCloudService
	{
		protected HttpApplicationState Application;
		public string Username     { get; set; }
		public string Password     { get; set; }
		public string ContactsCTag { get; set; }
		public string CalendarCTag { get; set; }
		public string MmeDeviceID  { get; set; }

		protected static string clientId             = "60C1537C-389B-4FA3-92C2-E0BCFB648026";
		protected static string clientBuildNumber    = "1P24";
		protected static string loginOrCreateAccount = String.Empty;
		protected static string sSetupCookie         = String.Empty;
		protected static string sMmeClientInfo       = "<PC> <Windows; 6.1.7600/SP0.0; W> <com.apple.AOSKit/88>";
		protected static string sUserAgent           = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/603.3.1 (KHTML, like Gecko) Version/10.1.2 Safari/603.3.1";

		public iCloudService(HttpApplicationState Application)
		{
			this.Application = Application;
			//clientBuildNumber = SplendidCRM.Sql.ToString(Application["SplendidVersion"]);
		}

		public string ConvertHREFtoUID(string sHREF)
		{
			string sUID = sHREF;
			sUID = sUID.Replace(".vcf", String.Empty);
			string[] arr = sUID.Split('/');
			sUID = arr[arr.Length - 1];
			return sUID;
		}

		public void setUserCredentials(string username, string password, string sContactsCTag, string sCalendarCTag, string sMmeDeviceID)
		{
			Username     = username;
			Password     = password;
			ContactsCTag = sContactsCTag;
			CalendarCTag = sCalendarCTag;
			MmeDeviceID  = sMmeDeviceID;
		}

		public iCloudSession2 QueryClientLoginToken(bool bValidate)
		{
#if true
			iCloudSession2 Session = null;
			if ( !bValidate && Application["iCloud.Session2." + Username] != null )
			{
				Session = Application["iCloud.Session2." + Username] as iCloudSession2;
			}
			else
			{
				// https://www.snip2code.com/Snippet/65033/Request-Contact-List-From-iCloud
				string url = "https://setup.icloud.com/setup/ws/1/login?clientBuildNumber=" + clientBuildNumber + "&clientId=" + clientId;
				HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(url);
				objRequest.ContentType = "application/json";
				objRequest.Method      = "POST";
				objRequest.UserAgent   = sUserAgent;
				objRequest.Referer     = "https://www.icloud.com";
				objRequest.Headers.Add("Origin" , "https://www.icloud.com");
				objRequest.CookieContainer = new CookieContainer();
			
				Dictionary<string, object> login = new Dictionary<string, object>();
				login.Add("apple_id"      , Username);
				login.Add("password"      , Password);
				login.Add("extended_login", true    );
				string requestDetails = JsonSerializer.Serialize(login);
				byte[] bytes = Encoding.ASCII.GetBytes(requestDetails);
				objRequest.ContentLength = bytes.Length;
				using ( Stream outputStream = objRequest.GetRequestStream() )
				{
					outputStream.Write(bytes, 0, bytes.Length);
				}
				bool bTokenFound = false;
				using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
				{
					if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found )
					{
						using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
						{
							DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(iCloudSession2));
							Session = (iCloudSession2) serializer.ReadObject(objResponse.GetResponseStream());
							Session.Cookies = objResponse.Cookies;
							// 03/18/2013 Paul.  We are noticing an exception when accessing the cookie. 
							if ( objResponse.Cookies != null )
							{
								foreach ( Cookie cookie in objResponse.Cookies )
								{
									//Debug.WriteLine(cookie.ToString());
									// 07/12/2020 Paul.  Token is valid for about 14 days. 
									if ( cookie.Name == "X-APPLE-WEBAUTH-TOKEN" )
									{
										Debug.WriteLine("X-APPLE-WEBAUTH-TOKEN Expires " + cookie.Expires.ToString());
										bTokenFound = true;
									}
								}
							}
							if ( bTokenFound )
							{
								Application["iCloud.Session2." + Username] = Session;
							}
							else
							{
								throw(new Exception(SplendidCRM.L10N.Term(Application, "en-US", "Users.ERR_ICLOUD_SECURITY_CODE_REQUIRED")));
							}
						}
					}
				}
			}
			if ( Application["iCloud.Session2." + Username] != null )
			{
				string locale = "en_US";
				string url = Session.webservices.contacts.url.Replace(":443", String.Empty) + "/co/startup?clientBuildNumber=" + clientBuildNumber + "&clientId=" + clientId + "&clientVersion=2.1&dsid=" + Session.dsInfo.dsid + "&locale=" +locale  + "&order=last%2Cfirst";
				HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(url);
				objRequest.ContentType = "application/json";
				objRequest.Method      = "GET";
				objRequest.UserAgent   = sUserAgent;
				objRequest.Referer     = "https://www.icloud.com";
				objRequest.Headers.Add("Origin" , "https://www.icloud.com");
				objRequest.CookieContainer = new CookieContainer();
				if ( Session.Cookies != null )
				{
					foreach ( Cookie cookie in Session.Cookies )
					{
						//if ( cookie.Name == "X-APPLE-WEBAUTH-TOKEN" || cookie.Name == "X-APPLE-WEBAUTH-USER" )
							objRequest.CookieContainer.Add(cookie);
					}
				}
				using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
				{
					if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found )
					{
						using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
						{
							string sResponse = readStream.ReadToEnd();
						}
					}
				}
				// https://github.com/prabhu/iCloud
				url = Session.webservices.push.url.Replace(":443", String.Empty) + "/refreshWebAuth?clientBuildNumber=" + clientBuildNumber + "&clientId=" + clientId + "&dsid=" + Session.dsInfo.dsid;
				objRequest = (HttpWebRequest) WebRequest.Create(url);
				objRequest.ContentType = "application/json";
				objRequest.Method      = "GET";
				objRequest.UserAgent   = sUserAgent;
				objRequest.Referer     = "https://www.icloud.com";
				objRequest.Headers.Add("Origin" , "https://www.icloud.com");
				objRequest.CookieContainer = new CookieContainer();
				if ( Session.Cookies != null )
				{
					foreach ( Cookie cookie in Session.Cookies )
					{
						//if ( cookie.Name == "X-APPLE-WEBAUTH-TOKEN" || cookie.Name == "X-APPLE-WEBAUTH-USER" )
							objRequest.CookieContainer.Add(cookie);
					}
				}
				using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
				{
					if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found )
					{
						using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
						{
							string sResponse = readStream.ReadToEnd();
							Debug.WriteLine(sResponse);
							/*
							DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(iCloudSession2));
							iCloudSession2 Session3 = (iCloudSession2) serializer.ReadObject(objResponse.GetResponseStream());
							//Session.Cookies = objResponse.Cookies;
							// 03/18/2013 Paul.  We are noticing an exception when accessing the cookie. 
							if ( objResponse.Cookies != null )
							{
								foreach ( Cookie cookie in objResponse.Cookies )
								{
									//Debug.WriteLine(cookie.ToString());
									// 07/12/2020 Paul.  Token is valid for about 14 days. 
									if ( cookie.Name == "X-APPLE-WEBAUTH-TOKEN" )
									{
										Debug.WriteLine("X-APPLE-WEBAUTH-TOKEN Expires " + cookie.Expires.ToString());
									}
								}
							}
							*/
						}
					}
				}
			}
			return Session;
#else
			iCloudSession Session = new iCloudSession(this.ContactsCTag, this.CalendarCTag);
			if ( String.IsNullOrEmpty(loginOrCreateAccount) || String.IsNullOrEmpty(sSetupCookie) )
			{
				if ( String.IsNullOrEmpty(MmeDeviceID) )
					MmeDeviceID = Guid.NewGuid().ToString();
				
				// https://developer.apple.com/forums/thread/11382
				//HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create("https://setup.icloud.com/configurations/init");
				HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create("https://setup.icloud.com/setup/ws/1/login");
				objRequest.Headers.Add("cache-control", "no-cache");
				objRequest.PreAuthenticate   = true ;
				objRequest.KeepAlive         = true ;
				objRequest.AllowAutoRedirect = false;
				objRequest.Timeout           = 10000;  //10 seconds
				objRequest.Method            = "GET";
				objRequest.UserAgent         = sUserAgent;
				objRequest.Headers.Add("X-Mme-Client-Info", sMmeClientInfo);
				objRequest.Headers.Add("X-Mme-Device-Id"  , MmeDeviceID   );
				objRequest.Headers.Add("X-Mme-Nac-Version", "11A457");
				objRequest.Headers.Add("X-Mme-Timezone"   , "EST"   );
				objRequest.Headers.Add("Accept-Language"  , "en-US" );
				//objRequest.Headers.Add("Accept-Encoding"  , "gzip, deflate");
				
				using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
				{
					if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found )
					{
						using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
						{
							string sResponse = readStream.ReadToEnd();
							// 03/18/2013 Paul.  We are noticing an exception when accessing the cookie. 
							if ( objResponse.Headers != null && objResponse.Headers.HasKeys() && objResponse.Headers.GetValues("Set-Cookie") != null )
							{
								foreach ( string sCookie in objResponse.Headers.GetValues("Set-Cookie") )
								{
									string[] arrCookiePairs = sCookie.Split(';');
									if ( arrCookiePairs[0].StartsWith("NSC_") )
									{
										sSetupCookie = arrCookiePairs[0];
										break;
									}
								}
							}
							int nEnd = sResponse.IndexOf("</plist>");
							if ( nEnd > 0 )
							{
								sResponse = sResponse.Substring(0, nEnd + 8);
							}
							
							XmlDocument xml = new XmlDocument();
							xml.LoadXml(sResponse);
							XmlNode keys = xml.DocumentElement.SelectSingleNode("dict/dict");
							if ( keys != null )
							{
								string sLastKey = String.Empty;
								foreach ( XmlNode item in keys.ChildNodes )
								{
									if ( item.Name == "key" )
									{
										sLastKey = item.InnerText;
									}
									else if ( item.Name == "string" )
									{
										switch ( sLastKey )
										{
											//case "newAccountUI"                   :  newAccountUI                    = item.InnerText; break;
											//case "qualifyDevice"                  :  qualifyDevice                   = item.InnerText; break;
											case "loginOrCreateAccount"           :  loginOrCreateAccount            = item.InnerText; break;
											//case "checkAppleIdAvailabilityUrl"    :  checkAppleIdAvailabilityUrl     = item.InnerText; break;
											//case "registerWebToken"               :  registerWebToken                = item.InnerText; break;
											//case "qualifySession"                 :  qualifySession                  = item.InnerText; break;
											//case "rampAlert"                      :  rampAlert                       = item.InnerText; break;
											//case "updateAccountUI"                :  updateAccountUI                 = item.InnerText; break;
											//case "qualifyCert"                    :  qualifyCert                     = item.InnerText; break;
											//case "emailTosUrl"                    :  emailTosUrl                     = item.InnerText; break;
											//case "initiateVetting"                :  initiateVetting                 = item.InnerText; break;
											//case "authenticate"                   :  authenticate                    = item.InnerText; break;
											//case "getAccountSettings"             :  getAccountSettings              = item.InnerText; break;
											//case "checkMeEmailAvailabilityUrl"    :  checkMeEmailAvailabilityUrl     = item.InnerText; break;
											//case "createAndRegisterAppleIdBaseUrl":  createAndRegisterAppleIdBaseUrl = item.InnerText; break;
											//case "completeVetting"                :  completeVetting                 = item.InnerText; break;
											//case "registerWebBasic"               :  registerWebBasic                = item.InnerText; break;
											//case "activateMeEmailUrl"             :  activateMeEmailUrl              = item.InnerText; break;
										}
									}
								}
							}
						}
					}
				}
			}
			else
			{
				if ( !bValidate && Application["iCloud.Session." + Username] != null )
				{
					Session = Application["iCloud.Session." + Username] as iCloudSession;
				}
			}
			if ( String.IsNullOrEmpty(Session.ClientToken) && !String.IsNullOrEmpty(loginOrCreateAccount) )
			{
				Uri uriLoginOrCreateAccount = new Uri(loginOrCreateAccount);
				HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(loginOrCreateAccount);
				objRequest.Headers.Add("cache-control", "no-cache");
				objRequest.PreAuthenticate   = true ;
				objRequest.KeepAlive         = true ;
				objRequest.AllowAutoRedirect = false;
				objRequest.Timeout           = 10000;  //10 seconds
				objRequest.Method            = "GET";
				objRequest.UserAgent         = sUserAgent;
				objRequest.Headers.Add("X-Mme-Client-Info", sMmeClientInfo);
				objRequest.Headers.Add("X-Mme-Device-Id"  , MmeDeviceID   );
				objRequest.Headers.Add("X-Mme-Timezone"   , "EST"   );
				objRequest.Headers.Add("Accept-Language"  , "en-US" );
				//objRequest.Headers.Add("Accept-Encoding"  , "gzip, deflate");
				objRequest.CookieContainer = new CookieContainer();
				string[] arrSetupCookie = sSetupCookie.Split('=');
				string sCookieName  = arrSetupCookie[0];
				string sCookieValue = String.Empty;
				// 03/25/2013 Paul.  When there is an error, the cookie will be blank. 
				if ( arrSetupCookie.Length > 1 )
					sCookieValue = arrSetupCookie[1];
				if ( !String.IsNullOrEmpty(sCookieName) )
					objRequest.CookieContainer.Add(new Cookie(sCookieName, sCookieValue, "/", uriLoginOrCreateAccount.Host));
				// 12/13/2011 Paul.  Provide the authorization header to skip the server rejection. 
				//objRequest.Credentials = new NetworkCredential(sUsername, sPassword);
				byte[] authBytes = System.Text.Encoding.UTF8.GetBytes(Username + ":" + Password);
				objRequest.Headers["Authorization"] = "Basic " + Convert.ToBase64String(authBytes);
				
				using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
				{
					if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found )
					{
						using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
						{
							string sResponse = readStream.ReadToEnd();
							XmlDocument xml = new XmlDocument();
							xml.LoadXml(sResponse);
							XmlNode keys = xml.DocumentElement.SelectSingleNode("dict");
							if ( keys != null )
							{
								string sLastKey = String.Empty;
								foreach ( XmlNode item in keys.ChildNodes )
								{
									if ( item.Name == "key" )
									{
										sLastKey = item.InnerText;
									}
									else if ( item.Name == "dict" )
									{
										if ( sLastKey == "tokens" )
										{
											string sLastKey2 = String.Empty;
											foreach ( XmlNode item2 in item.ChildNodes )
											{
												if ( item2.Name == "key" )
												{
													sLastKey2 = item2.InnerText;
												}
												else if ( item2.Name == "string" )
												{
													if ( sLastKey2 == "mmeAuthToken" )
													{
														Session.ClientToken = item2.InnerText;
													}
												}
											}
										}
										else if ( sLastKey == "appleAccountInfo" )
										{
											string sLastKey2 = String.Empty;
											foreach ( XmlNode item2 in item.ChildNodes )
											{
												if ( item2.Name == "key" )
												{
													sLastKey2 = item2.InnerText;
												}
												else if ( item2.Name == "string" )
												{
													switch ( sLastKey2 )
													{
														case "appleId"     :  Session.AppleID      = item2.InnerText;  break;
														case "dsPrsID"     :  Session.PrincipalID  = item2.InnerText;  break;
														case "fullName"    :  Session.FullName     = item2.InnerText;  break;
														case "firstName"   :  Session.FirstName    = item2.InnerText;  break;
														case "lastName"    :  Session.LastName     = item2.InnerText;  break;
														case "primaryEmail":  Session.PrimaryEmail = item2.InnerText;  break;
													}
												}
											}
										}
										else if ( sLastKey == "com.apple.mobileme" )
										{
											string sLastKey2 = String.Empty;
											foreach ( XmlNode item2 in item.ChildNodes )
											{
												if ( item2.Name == "key" )
												{
													sLastKey2 = item2.InnerText;
												}
												else if ( item2.Name == "dict" && sLastKey2.StartsWith("com.apple.Dataclass") )
												{
													string sLastKey3 = String.Empty;
													foreach ( XmlNode item3 in item2.ChildNodes )
													{
														if ( item3.Name == "key" )
														{
															sLastKey3 = item3.InnerText;
														}
														else if ( item3.Name == "string" )
														{
															if ( sLastKey3 == "url" )
															{
																switch ( sLastKey2 )
																{
																	case "com.apple.Dataclass.Reminders"      : Session.DataclassReminders       = item3.InnerText;  break;
																	case "com.apple.Dataclass.MediaStream"    : Session.DataclassMediaStream     = item3.InnerText;  break;
																	case "com.apple.Dataclass.Bookmarks"      : Session.DataclassBookmarks       = item3.InnerText;  break;
																	case "com.apple.Dataclass.Contacts"       : Session.DataclassContacts        = item3.InnerText;  break;
																	case "com.apple.Dataclass.Calendars"      : Session.DataclassCalendars       = item3.InnerText;  break;
																	case "com.apple.Dataclass.Content"        : Session.DataclassContent         = item3.InnerText;  break;
																	case "com.apple.Dataclass.Mail"           : Session.DataclassMail            = item3.InnerText;  break;
																	case "com.apple.Dataclass.MobileDocuments": Session.DataclassMobileDocuments = item3.InnerText;  break;
																	case "com.apple.Dataclass.Ubiquity"       : Session.DataclassUbiquity        = item3.InnerText;  break;
																	case "com.apple.Dataclass.Notes"          : Session.DataclassNotes           = item3.InnerText;  break;
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
				if ( !bValidate && !String.IsNullOrEmpty(Session.ClientToken) )
				{
					Application["iCloud.Session." + Username] = Session;
				}
			}
			return Session.ClientToken;
#endif
		}
	}
}

namespace iCloud.Contacts
{
	public class ContactsService : iCloudService
	{
		public ContactsService(HttpApplicationState Application) : base(Application)
		{
		}

		private void GetContactsPrincipalHref(iCloudSession Session, byte[] authBytes)
		{
			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.DataclassContacts);
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "PROPFIND";
			objRequest.Accept            = "*/*";
			objRequest.UserAgent         = "AppleZDAV/3.0.20";
			objRequest.ContentType       = "text/xml; charset=utf-8";
			objRequest.Headers["Authorization"] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			
			StringBuilder sbRequest = new StringBuilder();
			sbRequest.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
			sbRequest.AppendLine("<propfind xmlns=\"DAV:\">");
			sbRequest.AppendLine("	<prop>");
			sbRequest.AppendLine("		<current-user-principal />");
			sbRequest.AppendLine("		<principal-collection-set />");
			sbRequest.AppendLine("	</prop>");
			sbRequest.AppendLine("</propfind>");
			/*
			objRequest.ContentLength = sbRequest.Length;
			using ( StreamWriter stm = new StreamWriter(objRequest.GetRequestStream(), System.Text.Encoding.UTF8) )
			{
				stm.Write(sbRequest.ToString());
			}
			*/
			// 12/14/2011 Paul.  We are having problems using streams. 
			// Cannot close stream until all bytes are written.
			byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
				{
					using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
					{
						string sResponse = readStream.ReadToEnd();
						XmlDocument xml = new XmlDocument();
						xml.LoadXml(sResponse);
						XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
						nsmgr.AddNamespace("defaultns", "DAV:");
						XmlNode xCurrentUserPrincipalUrl = xml.DocumentElement.SelectSingleNode("defaultns:response/defaultns:propstat/defaultns:prop/defaultns:current-user-principal/defaultns:href", nsmgr);
						if ( xCurrentUserPrincipalUrl != null )
						{
							Session.ContactsPrincipalHref = xCurrentUserPrincipalUrl.InnerText;
							if ( Session.ContactsPrincipalHref.StartsWith("/") )
							{
								Uri urlDataclassContacts = new Uri(Session.DataclassContacts);
								Session.ContactsPrincipalHref = urlDataclassContacts.Scheme + "://" + urlDataclassContacts.Host + Session.ContactsPrincipalHref;
							}
						}
					}
				}
			}
		}

		private void GetContactsURL(iCloudSession Session, byte[] authBytes)
		{
			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.ContactsPrincipalHref);
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "PROPFIND";
			objRequest.Accept            = "*/*";
			objRequest.UserAgent         = "AppleZDAV/3.0.20";
			objRequest.ContentType       = "text/xml; charset=utf-8";
			objRequest.Headers["Authorization"] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			
			StringBuilder sbRequest = new StringBuilder();
			sbRequest.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
			sbRequest.AppendLine("<propfind xmlns=\"DAV:\" xmlns:I=\"urn:ietf:params:xml:ns:caldav\" xmlns:C=\"urn:ietf:params:xml:ns:carddav\" xmlns:A=\"http://calendarserver.org/ns/\">");
			sbRequest.AppendLine("	<prop>");
			sbRequest.AppendLine("		<resourcetype />");
			sbRequest.AppendLine("		<principal-URL />");
			sbRequest.AppendLine("		<current-user-principal />");
			sbRequest.AppendLine("		<principal-collection-set />");
			sbRequest.AppendLine("		<I:calendar-user-address-set />");
			sbRequest.AppendLine("		<I:calendar-user-type />");
			sbRequest.AppendLine("		<I:schedule-inbox-URL />");
			sbRequest.AppendLine("		<I:schedule-outbox-URL />");
			sbRequest.AppendLine("		<I:calendar-home-set />");
			sbRequest.AppendLine("		<C:addressbook-home-set />");
			sbRequest.AppendLine("		<A:getctag />");
			sbRequest.AppendLine("		<A:dropbox-home-URL />");
			sbRequest.AppendLine("		<A:email-address-set />");
			sbRequest.AppendLine("		<A:first-name />");
			sbRequest.AppendLine("		<A:last-name />");
			sbRequest.AppendLine("	</prop>");
			sbRequest.AppendLine("</propfind>");
			/*
			objRequest.ContentLength = sbRequest.Length;
			using ( StreamWriter stm = new StreamWriter(objRequest.GetRequestStream(), System.Text.Encoding.UTF8) )
			{
				stm.Write(sbRequest.ToString());
			}
			*/
			// 12/14/2011 Paul.  We are having problems using streams. 
			// Cannot close stream until all bytes are written.
			byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
				{
					using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
					{
						string sResponse = readStream.ReadToEnd();
						XmlDocument xml = new XmlDocument();
						xml.LoadXml(sResponse);
						XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
						nsmgr.AddNamespace("defaultns", "DAV:");
						nsmgr.AddNamespace("carddav"  , "urn:ietf:params:xml:ns:carddav");
						XmlNode xAddressBook = xml.DocumentElement.SelectSingleNode("defaultns:response/defaultns:propstat/defaultns:prop/carddav:addressbook-home-set/defaultns:href", nsmgr);
						if ( xAddressBook != null )
						{
							Session.ContactsURL = xAddressBook.InnerText;
						}
					}
				}
			}
		}

		private void GetCTagUrl(iCloudSession Session, byte[] authBytes)
		{
			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.ContactsURL);
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "PROPFIND";
			objRequest.UserAgent         = "AppleZDAV/3.0.20";
			objRequest.ContentType       = "text/xml; charset=utf-8";
			objRequest.Accept            = "text/xml";
			objRequest.Headers["Accept-Charset"] = "utf-8";
			objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			objRequest.Headers["Depth"         ] = "1";
			objRequest.Headers["Brief"         ] = "t";
			
			StringBuilder sbRequest = new StringBuilder();
			sbRequest.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
			sbRequest.AppendLine("<propfind xmlns=\"DAV:\" xmlns:I=\"urn:ietf:params:xml:ns:caldav\" xmlns:A=\"http://calendarserver.org/ns/\" xmlns:M=\"http://cal.me.com/_namespace/\" xmlns:MG=\"http://me.com/_namespace/\" xmlns:C=\"http://apple.com/ns/ical/\">");
			sbRequest.AppendLine("	<prop>");
			sbRequest.AppendLine("		<displayname />");
			sbRequest.AppendLine("		<resourcetype />");
			sbRequest.AppendLine("		<current-user-privilege-set />");
			sbRequest.AppendLine("		<current-user-principal />");
			sbRequest.AppendLine("		<modificationdate />");
			sbRequest.AppendLine("		<getlastmodified />");
			sbRequest.AppendLine("		<owner />");
			sbRequest.AppendLine("		<I:supported-calendar-component-set />");
			sbRequest.AppendLine("		<I:supported-calendar-data />");
			sbRequest.AppendLine("		<I:calendar-description />");
			sbRequest.AppendLine("		<I:calendar-timezone />");
			sbRequest.AppendLine("		<I:schedule-default-calendar-URL />");
			sbRequest.AppendLine("		<A:getctag />");
			sbRequest.AppendLine("		<A:invite />");
			sbRequest.AppendLine("		<A:calendar-availability />");
			sbRequest.AppendLine("		<A:push-transports />");
			sbRequest.AppendLine("		<A:pushkey />");
			sbRequest.AppendLine("		<A:shared-url />");
			sbRequest.AppendLine("		<A:source />");
			sbRequest.AppendLine("		<MG:bulk-requests />");
			sbRequest.AppendLine("		<C:calendar-order />");
			sbRequest.AppendLine("		<C:calendar-color />");
			sbRequest.AppendLine("		<C:calendar-enabled />");
			sbRequest.AppendLine("		<C:refreshrate />");
			sbRequest.AppendLine("	</prop>");
			sbRequest.AppendLine("</propfind>");
			
			byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
				{
					using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
					{
						string sResponse = readStream.ReadToEnd();
						XmlDocument xml = new XmlDocument();
						xml.LoadXml(sResponse);
						XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
						nsmgr.AddNamespace("defaultns", "DAV:");
						nsmgr.AddNamespace("carddav"  , "urn:ietf:params:xml:ns:carddav");
						nsmgr.AddNamespace("calsvr"   , "http://calendarserver.org/ns/");
						XmlNode xAddressBook = xml.DocumentElement.SelectSingleNode("defaultns:response/defaultns:propstat/defaultns:prop/defaultns:resourcetype/carddav:addressbook", nsmgr);
						if ( xAddressBook != null )
						{
							XmlNode xProp = xAddressBook.ParentNode.ParentNode;
							XmlNode xGetLastModified = xProp.SelectSingleNode("defaultns:getlastmodified", nsmgr);
							if( xGetLastModified != null )
							{
								try
								{
									Session.ContactsLastModified = DateTime.Parse(xGetLastModified.InnerText);
								}
								catch
								{
								}
							}
							// 12/19/2011 Paul.  Only update CTag if it is empty. 
							// 02/06/2012 Paul.  Only update CTag after a query operation. 
							/*
							if ( String.IsNullOrEmpty(Session.ContactsCTag) )
							{
								XmlNode xGetCTag = xProp.SelectSingleNode("calsvr:getctag", nsmgr);
								if ( xGetCTag != null )
								{
									Session.ContactsCTag = xGetCTag.InnerText;
								}
							}
							*/
							XmlNode xResponse = xProp.ParentNode.ParentNode;
							XmlNode xCTagUrl = xResponse.SelectSingleNode("defaultns:href", nsmgr);
							if( xCTagUrl != null )
							{
								Session.ContactsCTagUrl = xCTagUrl.InnerText;
								if ( Session.ContactsCTagUrl.StartsWith("/") )
								{
									Uri urlContactsURL = new Uri(Session.ContactsURL);
									Session.ContactsCTagUrl = urlContactsURL.Scheme + "://" + urlContactsURL.Host + Session.ContactsCTagUrl;
								}
								if ( !Session.ContactsCTagUrl.EndsWith("/") )
									Session.ContactsCTagUrl += "/";
							}
						}
					}
				}
			}
		}

		// http://www.rfc-editor.org/rfc/rfc6352.txt
		public List<ContactEntry> Query()
		{
			List<ContactEntry> lst = new List<ContactEntry>();
			
			iCloudSession Session = Application["iCloud.Session." + Username] as iCloudSession;
			if ( Session == null )
				QueryClientLoginToken(false);

			byte[] authBytes = System.Text.Encoding.UTF8.GetBytes(Session.PrincipalID + ":" + Session.ClientToken);
			if ( String.IsNullOrEmpty(Session.ContactsPrincipalHref) )
			{
				GetContactsPrincipalHref(Session, authBytes);
			}
			if ( String.IsNullOrEmpty(Session.ContactsURL) )
			{
				GetContactsURL(Session, authBytes);
			}
			if ( String.IsNullOrEmpty(Session.ContactsCTagUrl) )
			{
				GetCTagUrl(Session, authBytes);
			}
			List<string> items = new List<string>();
			if ( items.Count == 0 )
			{
				HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.ContactsCTagUrl);
				objRequest.Headers.Add("cache-control", "no-cache");
				objRequest.PreAuthenticate   = true ;
				objRequest.KeepAlive         = true ;
				objRequest.AllowAutoRedirect = false;
				objRequest.Timeout           = 20000;  //20 seconds
				objRequest.Method            = "PROPFIND";
				objRequest.UserAgent         = "AppleZDAV/3.0.20";
				objRequest.ContentType       = "text/xml; charset=utf-8";
				objRequest.Accept            = "text/xml";
				objRequest.Headers["Accept-Charset"] = "utf-8";
				objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
				objRequest.Headers["Depth"         ] = "1";
				objRequest.Headers["Brief"         ] = "t";
				
				StringBuilder sbRequest = new StringBuilder();
				sbRequest.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
				//sbRequest.AppendLine("<propfind xmlns=\"DAV:\" xmlns:A=\"http://calendarserver.org/ns/\">");
				//sbRequest.AppendLine("	<prop>");
				//sbRequest.AppendLine("		<A:getctag />");
				//sbRequest.AppendLine("	</prop>");
				//sbRequest.AppendLine("</propfind>");
				sbRequest.AppendLine("<propfind xmlns=\"DAV:\" xmlns:A=\"http://calendarserver.org/ns/\" xmlns:CS=\"http://calendarserver.org/ns/\">");
				sbRequest.AppendLine("	<prop>");
				sbRequest.AppendLine("		<A:getctag />");
				sbRequest.AppendLine("		<CS:uid />");
				sbRequest.AppendLine("	</prop>");
				sbRequest.AppendLine("</propfind>");
				
				byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
				objRequest.ContentLength = by.Length;
				objRequest.GetRequestStream().Write(by, 0, by.Length);
				
				using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
				{
					if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
					{
						using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
						{
							string sResponse = readStream.ReadToEnd();
							XmlDocument xml = new XmlDocument();
							xml.LoadXml(sResponse);
							XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
							nsmgr.AddNamespace("defaultns", "DAV:");
							nsmgr.AddNamespace("calsvr"   , "http://calendarserver.org/ns/");
							XmlNodeList nlHref = xml.DocumentElement.SelectNodes("defaultns:response/defaultns:href", nsmgr);
							foreach ( XmlNode xHref in nlHref )
							{
								// 12/14/2011 Paul.  The first item in the list is the ctag for the list itself. 
								// It could be a folder or category thing, so just ignore anything ending in a slash. 
								// Another option would be to only include urls ending in .vcf. 
								if ( !xHref.InnerText.EndsWith("/") )
								{
									items.Add(xHref.InnerText);
								}
							}
						}
					}
				}
			}
			if ( items.Count > 0 )
			{
				HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.ContactsCTagUrl);
				objRequest.Headers.Add("cache-control", "no-cache");
				objRequest.PreAuthenticate   = true ;
				objRequest.KeepAlive         = true ;
				objRequest.AllowAutoRedirect = false;
				objRequest.Timeout           = 20000;  //20 seconds
				objRequest.Method            = "REPORT";
				objRequest.UserAgent         = "AppleZDAV/3.0.20 (OL/14; Win/6.1.0.0)";
				objRequest.ContentType       = "text/xml; charset=utf-8";
				objRequest.Accept            = "text/xml";
				objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
				
				StringBuilder sbRequest = new StringBuilder();
				sbRequest.AppendLine("<?xml version=\"1.0\"?>");
				sbRequest.AppendLine("<V:addressbook-multiget xmlns=\"DAV:\"  xmlns:V=\"urn:ietf:params:xml:ns:carddav\" xmlns:CS=\"http://calendarserver.org/ns/\">");
				sbRequest.AppendLine("	<prop>");
				sbRequest.AppendLine("		<getetag />");
				sbRequest.AppendLine("		<getcontenttype />");
				sbRequest.AppendLine("		<V:address-data />");
				sbRequest.AppendLine("		<CS:uid />");
				sbRequest.AppendLine("	</prop>");
				foreach ( string sItemPath in items )
				{
					sbRequest.AppendLine("	<href>" + sItemPath + "</href>");
				}
				sbRequest.AppendLine("</V:addressbook-multiget>");
				
				byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
				objRequest.ContentLength = by.Length;
				objRequest.GetRequestStream().Write(by, 0, by.Length);
				
				using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
				{
					if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
					{
						using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
						{
							string sResponse = readStream.ReadToEnd();
							XmlDocument xml = new XmlDocument();
							xml.LoadXml(sResponse);
							XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
							nsmgr.AddNamespace("defaultns", "DAV:");
							nsmgr.AddNamespace("CD"       , "urn:ietf:params:xml:ns:carddav");
							nsmgr.AddNamespace("CS"       , "http://calendarserver.org/ns/" );

							XmlNodeList nlResponse = xml.DocumentElement.SelectNodes("defaultns:response", nsmgr);
							foreach ( XmlNode xResponse in nlResponse )
							{
								ContactEntry item = new ContactEntry();
								XmlNode xHref        = xResponse.SelectSingleNode("defaultns:href"  , nsmgr);
								XmlNode xStatus      = xResponse.SelectSingleNode("defaultns:status", nsmgr);
								XmlNode xGetETag     = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/defaultns:getetag", nsmgr);
								XmlNode xAddressData = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/CD:address-data"  , nsmgr);
								XmlNode xUID         = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/CS:uid"           , nsmgr);
								if ( xHref != null && xGetETag != null && xUID != null && xAddressData != null )
								{
									item.Href = xHref.InnerText;
									item.ETag = xGetETag.InnerText;
									item.UID  = xUID.InnerText;
									item.Parse(xAddressData.InnerText);
									lst.Add(item);
								}
								else if ( xHref != null && xStatus != null && xStatus.InnerText == "HTTP/1.1 404 Not Found" )
								{
									// 01/12/2012 Paul.  A deleted item will only have the HREF.  Convert the HREF to a UID. 
									item.Href    = xHref.InnerText;
									item.UID     = ConvertHREFtoUID(item.Href);
									item.Deleted = true;
									item.Updated = DateTime.Now;
									lst.Add(item);
								}
							}
						}
					}
				}
			}
			return lst;
		}

		public List<ContactEntry> SyncQuery(bool bSyncAll)
		{
			List<ContactEntry> lst = new List<ContactEntry>();
			
			iCloudSession Session = Application["iCloud.Session." + Username] as iCloudSession;
			if ( Session == null )
				QueryClientLoginToken(false);

			byte[] authBytes = System.Text.Encoding.UTF8.GetBytes(Session.PrincipalID + ":" + Session.ClientToken);
			if ( String.IsNullOrEmpty(Session.ContactsPrincipalHref) )
			{
				GetContactsPrincipalHref(Session, authBytes);
			}
			if ( String.IsNullOrEmpty(Session.ContactsURL) )
			{
				GetContactsURL(Session, authBytes);
			}
			if ( String.IsNullOrEmpty(Session.ContactsCTagUrl) )
			{
				GetCTagUrl(Session, authBytes);
			}

			string sNewCTag = Session.ContactsCTag;
			List<string> items = new List<string>();
			if ( items.Count == 0 )
			{
				HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.ContactsCTagUrl);
				objRequest.Headers.Add("cache-control", "no-cache");
				objRequest.PreAuthenticate   = true ;
				objRequest.KeepAlive         = true ;
				objRequest.AllowAutoRedirect = false;
				objRequest.Timeout           = 20000;  //20 seconds
				objRequest.Method            = "REPORT";
				objRequest.UserAgent         = "AppleZDAV/3.0.20";
				objRequest.ContentType       = "text/xml; charset=utf-8";
				objRequest.Accept            = "text/xml";
				objRequest.Headers["Accept-Charset"] = "utf-8";
				objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
				objRequest.Headers["Depth"         ] = "1";
				objRequest.Headers["Brief"         ] = "t";
				
				StringBuilder sbRequest = new StringBuilder();
				sbRequest.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
				sbRequest.AppendLine("<sync-collection xmlns=\"DAV:\" xmlns:A=\"http://calendarserver.org/ns/\">");
				if ( bSyncAll || String.IsNullOrEmpty(sNewCTag) )
					sbRequest.AppendLine("	<sync-token />");
				else
					sbRequest.AppendLine("	<sync-token>" + sNewCTag + "</sync-token>");
				sbRequest.AppendLine("	<prop>");
				sbRequest.AppendLine("		<getetag />");
				sbRequest.AppendLine("	</prop>");
				sbRequest.AppendLine("</sync-collection>");
				
				byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
				objRequest.ContentLength = by.Length;
				objRequest.GetRequestStream().Write(by, 0, by.Length);
				
				using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
				{
					if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
					{
						using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
						{
							string sResponse = readStream.ReadToEnd();
							XmlDocument xml = new XmlDocument();
							xml.LoadXml(sResponse);
							XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
							nsmgr.AddNamespace("defaultns", "DAV:");
							
							XmlNodeList nlHref = xml.DocumentElement.SelectNodes("defaultns:response/defaultns:href", nsmgr);
							foreach ( XmlNode xHref in nlHref )
							{
								// 12/14/2011 Paul.  The first item in the list is the ctag for the list itself. 
								// It could be a folder or category thing, so just ignore anything ending in a slash. 
								// Another option would be to only include urls ending in .vcf. 
								if ( !xHref.InnerText.EndsWith("/") )
								{
									items.Add(xHref.InnerText);
								}
							}
							XmlNode xSyncToken = xml.DocumentElement.SelectSingleNode("defaultns:sync-token", nsmgr);
							if ( xSyncToken != null )
							{
								sNewCTag = xSyncToken.InnerText;
							}
						}
					}
				}
			}
			if ( items.Count > 0 )
			{
				HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.ContactsCTagUrl);
				objRequest.Headers.Add("cache-control", "no-cache");
				objRequest.PreAuthenticate   = true ;
				objRequest.KeepAlive         = true ;
				objRequest.AllowAutoRedirect = false;
				objRequest.Timeout           = 20000;  //20 seconds
				objRequest.Method            = "REPORT";
				objRequest.UserAgent         = "AppleZDAV/3.0.20 (OL/14; Win/6.1.0.0)";
				objRequest.ContentType       = "text/xml; charset=utf-8";
				objRequest.Accept            = "text/xml";
				objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
				
				StringBuilder sbRequest = new StringBuilder();
				sbRequest.AppendLine("<?xml version=\"1.0\"?>");
				sbRequest.AppendLine("<V:addressbook-multiget xmlns=\"DAV:\"  xmlns:V=\"urn:ietf:params:xml:ns:carddav\" xmlns:CS=\"http://calendarserver.org/ns/\">");
				sbRequest.AppendLine("	<prop>");
				sbRequest.AppendLine("		<getetag />");
				sbRequest.AppendLine("		<getcontenttype />");
				sbRequest.AppendLine("		<V:address-data />");
				sbRequest.AppendLine("		<CS:uid />");
				sbRequest.AppendLine("	</prop>");
				foreach ( string sItemPath in items )
				{
					sbRequest.AppendLine("	<href>" + sItemPath + "</href>");
				}
				sbRequest.AppendLine("</V:addressbook-multiget>");
				
				byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
				objRequest.ContentLength = by.Length;
				objRequest.GetRequestStream().Write(by, 0, by.Length);
				
				using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
				{
					if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
					{
						using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
						{
							string sResponse = readStream.ReadToEnd();
							XmlDocument xml = new XmlDocument();
							xml.LoadXml(sResponse);
							XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
							nsmgr.AddNamespace("defaultns", "DAV:");
							nsmgr.AddNamespace("CD"       , "urn:ietf:params:xml:ns:carddav");
							nsmgr.AddNamespace("CS"       , "http://calendarserver.org/ns/" );

							XmlNodeList nlResponse = xml.DocumentElement.SelectNodes("defaultns:response", nsmgr);
							foreach ( XmlNode xResponse in nlResponse )
							{
								ContactEntry item = new ContactEntry();
								XmlNode xHref        = xResponse.SelectSingleNode("defaultns:href", nsmgr);
								// 01/12/2012 Paul.  Status for a deleted record is at the same level has href. 
								// Status at an active record is under propstat. 
								XmlNode xStatus      = xResponse.SelectSingleNode("defaultns:status", nsmgr);
								XmlNode xGetETag     = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/defaultns:getetag", nsmgr);
								XmlNode xAddressData = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/CD:address-data"  , nsmgr);
								XmlNode xUID         = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/CS:uid"           , nsmgr);
								if ( xHref != null && xGetETag != null && xUID != null && xAddressData != null )
								{
									item.Href = xHref.InnerText;
									item.ETag = xGetETag.InnerText;
									item.UID  = xUID.InnerText;
									item.Parse(xAddressData.InnerText);
									lst.Add(item);
								}
								else if ( xHref != null && xStatus != null && xStatus.InnerText == "HTTP/1.1 404 Not Found" )
								{
									// 01/12/2012 Paul.  A deleted item will only have the HREF.  Convert the HREF to a UID. 
									item.Href    = xHref.InnerText;
									item.UID     = ConvertHREFtoUID(item.Href);
									item.Deleted = true;
									item.Updated = DateTime.Now;
									lst.Add(item);
								}
							}
							Session.ContactsCTag = sNewCTag;
						}
					}
				}
			}
			else
			{
				Session.ContactsCTag = sNewCTag;
			}
			this.ContactsCTag = sNewCTag;
			return lst;
		}

		// http://www.rfc-editor.org/rfc/rfc6352.txt
		public ContactEntry Insert(ContactEntry contact)
		{
			iCloudSession Session = Application["iCloud.Session." + Username] as iCloudSession;
			if ( Session == null )
				QueryClientLoginToken(false);

			if ( String.IsNullOrEmpty(Session.ContactsCTag) )
			{
				Query();
			}

			string sSyncTag  = Session.ContactsCTag;
			byte[] authBytes = System.Text.Encoding.UTF8.GetBytes(Session.PrincipalID + ":" + Session.ClientToken);
			
			contact.UID = "CZTL-" + Guid.NewGuid().ToString();
			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.ContactsCTagUrl + contact.UID + ".vcf");
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "PUT";
			objRequest.UserAgent         = "AppleZDAV/3.0.20 (OL/14.0.0.4760; Win/6.1.0.0)";
			objRequest.ContentType       = "text/vcard; charset=utf-8";
			objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			objRequest.Headers["If-None-Match" ] = "*";
			
			string sRequest = contact.CreateVCard();
			byte[] by = Encoding.UTF8.GetBytes(sRequest);
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.NoContent || objResponse.StatusCode == HttpStatusCode.Found || objResponse.StatusCode == HttpStatusCode.Created || (int) objResponse.StatusCode == 207 )
				{
					contact.ETag = objResponse.Headers["ETag"];
				}
			}

			objRequest = (HttpWebRequest) WebRequest.Create(Session.ContactsCTagUrl);
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "REPORT";
			objRequest.UserAgent         = "AppleZDAV/3.0.20";
			objRequest.ContentType       = "text/xml; charset=utf-8";
			objRequest.Accept            = "text/xml";
			objRequest.Headers["Accept-Charset"] = "utf-8";
			objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			objRequest.Headers["Depth"         ] = "1";
			objRequest.Headers["Brief"         ] = "t";
			
			StringBuilder sbRequest = new StringBuilder();
			sbRequest.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
			// 12/19/2011 Paul.  Can't seem to get the UID directly from the ETAG, so we need to use the sync-token. 
			sbRequest.AppendLine("<sync-collection xmlns=\"DAV:\" xmlns:A=\"http://calendarserver.org/ns/\">");
			sbRequest.AppendLine("	<sync-token>" + sSyncTag + "</sync-token>");
			sbRequest.AppendLine("	<prop>");
			sbRequest.AppendLine("		<getetag />");
			sbRequest.AppendLine("	</prop>");
			sbRequest.AppendLine("</sync-collection>");

			by = Encoding.UTF8.GetBytes(sbRequest.ToString());
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
				{
					using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
					{
						string sResponse = readStream.ReadToEnd();
						XmlDocument xml = new XmlDocument();
						xml.LoadXml(sResponse);
						XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
						nsmgr.AddNamespace("defaultns", "DAV:");
						nsmgr.AddNamespace("CS"       , "http://calendarserver.org/ns/" );

						XmlNodeList nlResponse = xml.DocumentElement.SelectNodes("defaultns:response", nsmgr);
						foreach ( XmlNode xResponse in nlResponse )
						{
							XmlNode xHref        = xResponse.SelectSingleNode("defaultns:href", nsmgr);
							XmlNode xGetETag     = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/defaultns:getetag", nsmgr);
							XmlNode xUID         = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/CS:uid"           , nsmgr);
							if ( xHref != null && xGetETag != null && xGetETag.InnerText == contact.ETag )
							{
								if ( xUID != null && !String.IsNullOrEmpty(xUID.InnerText) )
								{
									contact.UID = xUID.InnerText;
								}
								else
								{
									contact.UID = ConvertHREFtoUID(xHref.InnerText);
								}
								break;
							}
						}
					}
#if DEBUG
					if ( !String.IsNullOrEmpty(contact.UID) )
					{
						// 01/07/2012 Paul.  After updating, get again so that we can compare the two. 
						ContactEntry contactNew = Get(contact.UID);
						contact.RawContent = contactNew.RawContent;
						return contactNew;
					}
#endif
				}
			}
			return contact;
		}

		public ContactEntry Update(ContactEntry contact)
		{
			iCloudSession Session = Application["iCloud.Session." + Username] as iCloudSession;
			if ( Session == null )
				QueryClientLoginToken(false);

			if ( String.IsNullOrEmpty(Session.ContactsCTag) )
			{
				Query();
			}

			byte[] authBytes = System.Text.Encoding.UTF8.GetBytes(Session.PrincipalID + ":" + Session.ClientToken);
			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.ContactsCTagUrl + contact.UID + ".vcf");
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "PUT";
			objRequest.UserAgent         = "AppleZDAV/3.0.20 (OL/14.0.0.4760; Win/6.1.0.0)";
			objRequest.ContentType       = "text/vcard; charset=utf-8";
			objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			
			string sRequest = contact.CreateVCard();
			byte[] by = Encoding.UTF8.GetBytes(sRequest);
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.NoContent || objResponse.StatusCode == HttpStatusCode.Found || objResponse.StatusCode == HttpStatusCode.Accepted || (int) objResponse.StatusCode == 207 )
				{
					contact.ETag = objResponse.Headers["ETag"];
#if DEBUG
					if ( !String.IsNullOrEmpty(contact.UID) )
					{
						// 01/07/2012 Paul.  After updating, get again so that we can compare the two. 
						ContactEntry contactNew = Get(contact.UID);
						contact.RawContent = contactNew.RawContent;
						return contactNew;
					}
#endif
				}
			}
			return contact;
		}

		public void Delete(ContactEntry contact)
		{
			iCloudSession Session = Application["iCloud.Session." + Username] as iCloudSession;
			if ( Session == null )
				QueryClientLoginToken(false);

			if ( String.IsNullOrEmpty(Session.ContactsCTag) )
			{
				Query();
			}

			byte[] authBytes = System.Text.Encoding.UTF8.GetBytes(Session.PrincipalID + ":" + Session.ClientToken);
			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.ContactsCTagUrl + contact.UID + ".vcf");
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "DELETE";
			objRequest.UserAgent         = "AppleZDAV/3.0.20 (OL/14.0.0.4760; Win/6.1.0.0)";
			objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.NoContent )
				{
				}
			}
		}

		public ContactEntry Get(string sUID)
		{
			iCloudSession Session = Application["iCloud.Session." + Username] as iCloudSession;
			if ( Session == null )
				QueryClientLoginToken(false);

			byte[] authBytes = System.Text.Encoding.UTF8.GetBytes(Session.PrincipalID + ":" + Session.ClientToken);
			if ( String.IsNullOrEmpty(Session.ContactsPrincipalHref) )
			{
				GetContactsPrincipalHref(Session, authBytes);
			}
			if ( String.IsNullOrEmpty(Session.ContactsURL) )
			{
				GetContactsURL(Session, authBytes);
			}
			if ( String.IsNullOrEmpty(Session.ContactsCTagUrl) )
			{
				GetCTagUrl(Session, authBytes);
			}

			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.ContactsCTagUrl);
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "REPORT";
			objRequest.UserAgent         = "AppleZDAV/3.0.20 (OL/14; Win/6.1.0.0)";
			objRequest.ContentType       = "text/xml; charset=utf-8";
			objRequest.Accept            = "text/xml";
			objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			
			StringBuilder sbRequest = new StringBuilder();
			sbRequest.AppendLine("<?xml version=\"1.0\"?>");
			sbRequest.AppendLine("<V:addressbook-multiget xmlns=\"DAV:\"  xmlns:V=\"urn:ietf:params:xml:ns:carddav\" xmlns:CS=\"http://calendarserver.org/ns/\">");
			sbRequest.AppendLine("	<prop>");
			sbRequest.AppendLine("		<getetag />");
			sbRequest.AppendLine("		<getcontenttype />");
			sbRequest.AppendLine("		<V:address-data />");
			sbRequest.AppendLine("		<CS:uid />");
			sbRequest.AppendLine("	</prop>");
//			sbRequest.AppendLine("	<V:filter>");
//			sbRequest.AppendLine("		<V:prop-filter name=\"uid\">");
//			sbRequest.AppendLine("			<V:text-match collation=\"i;octet\" match-type=\"equals\">" + sUID + "</V:text-match>");
//			sbRequest.AppendLine("		</V:prop-filter>");
//			sbRequest.AppendLine("	</V:filter>");
			// 01/04/2012 Paul.  The Calendar ID does not include the scheme or host.  The Contact ID does include the scheme and host. 
			sbRequest.AppendLine("	<href>" + Session.ContactsCTagUrl + sUID + ".vcf" + "</href>");
			sbRequest.AppendLine("</V:addressbook-multiget>");
			
			byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
				{
					using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
					{
						string sResponse = readStream.ReadToEnd();
						XmlDocument xml = new XmlDocument();
						xml.LoadXml(sResponse);
						XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
						nsmgr.AddNamespace("defaultns", "DAV:");
						nsmgr.AddNamespace("CD"       , "urn:ietf:params:xml:ns:carddav");
						nsmgr.AddNamespace("CS"       , "http://calendarserver.org/ns/" );

						XmlNodeList nlResponse = xml.DocumentElement.SelectNodes("defaultns:response", nsmgr);
						foreach ( XmlNode xResponse in nlResponse )
						{
							ContactEntry item = new ContactEntry();
							XmlNode xHref        = xResponse.SelectSingleNode("defaultns:href", nsmgr);
							XmlNode xGetETag     = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/defaultns:getetag", nsmgr);
							XmlNode xAddressData = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/CD:address-data"  , nsmgr);
							XmlNode xUID         = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/CS:uid"           , nsmgr);
							if ( xHref != null && xGetETag != null && xUID != null && xAddressData != null )
							{
								item.Href = xHref.InnerText;
								item.ETag = xGetETag.InnerText;
								item.UID  = xUID.InnerText;
								item.Parse(xAddressData.InnerText);
								return item;
							}
						}
					}
				}
			}
			return null;
		}
	}

	#region ContactEntry
	public class Name
	{
		public Name()
		{
		}

		public string AdditionalNamePhonetics { get; set; }
		public string AdditonalName           { get; set; }
		public string FamilyName              { get; set; }
		public string FamilyNamePhonetics     { get; set; }
		public string FullName                { get; set; }
		public string GivenName               { get; set; }
		public string GivenNamePhonetics      { get; set; }
		public string NamePrefix              { get; set; }
		public string NameSuffix              { get; set; }
	}

	public class EMail
	{
		public EMail()
		{
		}
		public EMail(string emailAddress)
		{
			Address = emailAddress;
		}

		public string Type     { get; set; }
		public bool   Internet { get; set; }
		public bool   Primary  { get; set; }
		public string Address  { get; set; }
	}

	public class PhoneNumber
	{
		public PhoneNumber()
		{
		}
		public PhoneNumber(string init)
		{
		}

		public string Type    { get; set; }
		public bool   Voice   { get; set; }
		public bool   Fax     { get; set; }
		public bool   Primary { get; set; }
		public string Uri     { get; set; }
		public string Value   { get; set; }
	}

	public class StructuredPostalAddress
	{
		public StructuredPostalAddress()
		{
		}

		public string Type             { get; set; }
		public string Agent            { get; set; }
		public string City             { get; set; }
		public string Country          { get; set; }
		public string FormattedAddress { get; set; }
		public string Housename        { get; set; }
		public string Label            { get; set; }
		public string MailClass        { get; set; }
		public string Neighborhood     { get; set; }
		public string Pobox            { get; set; }
		public string Postcode         { get; set; }
		public bool   Primary          { get; set; }
		public string Region           { get; set; }
		public string Street           { get; set; }
		public string Subregion        { get; set; }
		public string Usage            { get; set; }
	}

	public class Organization
	{
		public Organization()
		{
		}

		public string Type           { get; set; }
		public string Department     { get; set; }
		public bool   Home           { get; set; }
		public string JobDescription { get; set; }
		public string Label          { get; set; }
		public string Location       { get; set; }
		public string Name           { get; set; }
		public bool   Other          { get; set; }
		public bool   Primary        { get; set; }
		public string Symbol         { get; set; }
		public string Title          { get; set; }
	}

	public class Relation
	{
		public Relation()
		{
		}

		public string Type  { get; set; }
		public string Label { get; set; }
		public string Value { get; set; }
	}

	public class ContactEntry
	{
		#region Properties
		public string RawContent         { get; set; }
		public bool   Deleted            { get; set; }
		public string UID                { get; set; }
		public string ETag               { get; set; }
		public string Href               { get; set; }
		public string BillingInformation { get; set; }
		public string Birthday           { get; set; }
		public string Initials           { get; set; }
		public string Location           { get; set; }
		public string MaidenName         { get; set; }
		public string Mileage            { get; set; }
		public Name   Name               { get; set; }
		public string Nickname           { get; set; }
		public string Title              { get; set; }
		public string Organization       { get; set; }
		public string Department         { get; set; }
		public string PhotoEtag          { get; set; }
		public Uri    PhotoUri           { get; set; }
		public string Priority           { get; set; }
		public string Sensitivity        { get; set; }
		public string Messenger          { get; set; }
		public string WebSite            { get; set; }
		public string ShortName          { get; set; }
		public string Subject            { get; set; }
		public string Content            { get; set; }
		public DateTime Updated          { get; set; }
		public List<StructuredPostalAddress> PostalAddresses;
		public List<PhoneNumber            > Phonenumbers   ;
		public List<Relation               > Relations      ;
		public List<EMail                  > Emails         ;
		public List<string                 > UnknownLines   ;
		#endregion

		public ContactEntry()
		{
			PostalAddresses = new List<StructuredPostalAddress>();
			Phonenumbers    = new List<PhoneNumber            >();
			Relations       = new List<Relation               >();
			Emails          = new List<EMail                  >();
			UnknownLines    = new List<string                 >();
		}

		private List<string> ParseTypes(string sLine)
		{
			List<string> lst = new List<string>();
			string[] arrLine = sLine.Split(';');
			// 01/26/2012 Paul.  Skip the first item as it is the item type, not properties of the item. 
			for ( int i = 1; i < arrLine.Length; i++ )
			{
				if ( arrLine[i].ToUpper().StartsWith("TYPE=") )
				{
					string[] arrType = arrLine[i].Split('=');
					lst.Add(arrType[1].ToUpper());
				}
				else if ( !arrLine[i].Contains("=") )
					lst.Add(arrLine[i].ToUpper());
			}
			return lst;
		}

		// http://en.wikipedia.org/wiki/VCard
		// http://www.imc.org/pdi/vcard-21.doc
		// http://en.wikipedia.org/wiki/ICalendar
		// http://www.ietf.org/rfc/rfc2445.txt
		public void Parse(string sAddress)
		{
			try
			{
				this.RawContent = sAddress;
#if DEBUG
				Debug.WriteLine(sAddress);
#endif
				if ( sAddress.StartsWith("BEGIN:VCARD") )
				{
					this.Name = new Name();
					using ( MemoryStream stm = new MemoryStream(System.Text.UTF8Encoding.UTF8.GetBytes(sAddress)) )
					{
						using ( StreamReader rdr = new StreamReader(stm) )
						{
							string sLine = null;
							while ( (sLine = rdr.ReadLine()) != null )
							{
								// 12/14/2011 Paul.  There can be multiple colons in the line, so don't use split. 
								if ( sLine.Contains(":") )
								{
									string[] arrLine = new string[2];
									int nSeparator = sLine.IndexOf(':');
									arrLine[0] = sLine.Substring(0, nSeparator);
									arrLine[1] = sLine.Substring(nSeparator + 1);
									switch ( arrLine[0] )
									{
										case "BEGIN"  :  break;
										case "END"    :  rdr.ReadToEnd();  break;
										case "VERSION":  break;
										case "PRODID" :  break;  // Product ID
										case "UID"    :  this.UID       = arrLine[1];  break;  // UID
										case "URL"    :  this.WebSite   = arrLine[1];  break;  // WebSite
										case "IMPP"   :  this.Messenger = arrLine[1];  break;  // Instant Messenger
										case "NOTE"   :  this.Content   = arrLine[1].Replace("\\n", "\n");  break;  // Description
										case "REV"    :  // Revision Date  yyyyMMddTHHmmssZ
										{
											try
											{
												// "2011-12-13T04:59:54Z"
												this.Updated = SplendidCRM.Utils.CalDAV_ParseDate(arrLine[1]);
											}
											catch
											{
											}
											break;
										}
										case "FN"     :// Full Name
										{
											this.Name.FullName = arrLine[1];
											break;
										}
										case "N"      :  // Name
										{
											// 1. Last Name
											// 2. First Name
											// 3. Salutation
											string[] arrName = arrLine[1].Split(';');
											this.Name.FamilyName = arrName[0];
											if ( arrName.Length > 1 )
											{
												this.Name.GivenName = arrName[1];
												if ( arrName.Length > 2 )
												{
													this.Name.NamePrefix = arrName[2];
												}
											}
											break;
										}
										case "ORG"    :  // Organization
										{
											string[] arrName = arrLine[1].Split(';');
											this.Organization = arrName[0];
											if ( arrName.Length > 1 )
											{
												this.Department = arrName[1];
											}
											break;
										}
										case "TITLE"  :  // Title
										{
											this.Title = arrLine[1];
											break;
										}
										default:
										{
											if ( sLine.StartsWith("EMAIL") )
											{
												List<string> arrType  = ParseTypes(arrLine[0]);
												EMail itm = new EMail();
												itm.Address = arrLine[1];
												foreach ( string sType in arrType )
												{
													foreach ( string sSubType in sType.Split(',') )
													{
														if ( sSubType == "PREF" )
															itm.Primary = true;
														else if ( sSubType == "INTERNET" )
															itm.Internet = true;
														else
															itm.Type = sSubType;
													}
												}
												this.Emails.Add(itm);
											}
											else if ( sLine.StartsWith("TEL") )
											{
												List<string> arrType  = ParseTypes(arrLine[0]);
												PhoneNumber itm = new PhoneNumber();
												itm.Value = arrLine[1];
												foreach ( string sType in arrType )
												{
													foreach ( string sSubType in sType.Split(',') )
													{
														if ( sSubType == "PREF" )
															itm.Primary = true;
														else if ( sSubType == "VOICE" )
															itm.Voice = true;
														else if ( sSubType == "FAX" )
															itm.Fax = true;
														else
															itm.Type = sSubType;
													}
												}
												this.Phonenumbers.Add(itm);
											}
											else if ( sLine.StartsWith("ADR") || (arrLine[0].StartsWith("item") && arrLine[0].Contains(".ADR")) )
											{
												List<string> arrType  = ParseTypes(arrLine[0]);
												// 1. Post Office Address
												// 2. Extended Address
												// 3. Street
												// 4. Locality
												// 5. Region
												// 6. Postal Code
												// 7. Country
												// 01/11/2012 Paul.  Need to unescape the comma. 
												string[] arrParts = arrLine[1].Replace("\\,", ",").Split(';');
												StructuredPostalAddress itm = new StructuredPostalAddress();
												//itm.FormattedAddress;
												if ( arrParts.Length > 0 ) itm.Pobox    = arrParts[0];
												if ( arrParts.Length > 2 ) itm.Street   = arrParts[2];
												if ( arrParts.Length > 3 ) itm.City     = arrParts[3];
												if ( arrParts.Length > 4 ) itm.Region   = arrParts[4];
												if ( arrParts.Length > 5 ) itm.Postcode = arrParts[5];
												if ( arrParts.Length > 6 ) itm.Country  = arrParts[6];
												foreach ( string sType in arrType )
												{
													foreach ( string sSubType in sType.Split(',') )
													{
														if ( sSubType == "PREF" )
															itm.Primary = true;
														else
															itm.Type = sSubType;
													}
												}
												this.PostalAddresses.Add(itm);
											}
											// BDAY;value=date:1970-01-01
											else if ( sLine.StartsWith("BDAY") )
											{
												this.Birthday  = arrLine[1];  // Birthdate
											}
											else
											{
												UnknownLines.Add(sLine);
											}
											break;
										}
									}
								}
							}
						}
					}
				}
			}
			catch //(Exception ex)
			{
			}
		}

		public string CreateVCard()
		{
			StringBuilder sbVCard = new StringBuilder();
			sbVCard.AppendLine("BEGIN:VCARD");
			sbVCard.AppendLine("VERSION:3.0");
			sbVCard.AppendLine("PRODID:-//Apple Inc.//Address Book 6.1//EN");

			if ( this.Updated == DateTime.MinValue )
				this.Updated = DateTime.Now;
			sbVCard.AppendLine("UID:" + this.UID);
			// 01/11/2012 Paul.  REV not REF. 
			sbVCard.AppendLine("REV:" + this.Updated.ToUniversalTime().ToString("yyyyMMddTHHmmssZ"));
			sbVCard.AppendLine("N:"  + this.Name.FamilyName + ";" + this.Name.GivenName + ";" + this.Name.NamePrefix + ";" + ";");
			sbVCard.AppendLine("FN:" + this.Name.FullName);
			if ( !String.IsNullOrEmpty(this.Organization) || !String.IsNullOrEmpty(this.Department) )
			{
				sbVCard.Append("ORG:");
				sbVCard.Append(this.Organization);
				if ( !String.IsNullOrEmpty(this.Department) )
				{
					sbVCard.Append(";");
					sbVCard.Append(this.Department);
				}
				sbVCard.AppendLine();
			}
			if ( !String.IsNullOrEmpty(this.Title) )
			{
				sbVCard.AppendLine("TITLE:" + this.Title);
			}
			if ( !String.IsNullOrEmpty(this.Birthday ) ) sbVCard.AppendLine("BDAY:"  + this.Birthday );
			if ( !String.IsNullOrEmpty(this.Messenger) ) sbVCard.AppendLine("IMPP:"  + this.Messenger);
			foreach ( PhoneNumber phone in this.Phonenumbers )
			{
				if ( !String.IsNullOrEmpty(phone.Value) )
				{
					string sType = phone.Type;
					string sPref = (phone.Primary ? ";type=PREF" : String.Empty);
					if ( String.IsNullOrEmpty(sType) )
						sType = "OTHER";
					if ( phone.Voice )
						sType += ";type=VOICE";
					// 01/28/2012 Paul.  We only support a single work fax. 
					if ( phone.Fax )
						sType = "WORK;type=FAX";
					sbVCard.AppendLine("TEL;type=" + sType + sPref + ":" + phone.Value);
				}
			}
			foreach ( EMail email in this.Emails )
			{
				if ( !String.IsNullOrEmpty(email.Address) )
				{
					string sType = email.Type;
					string sPref = (email.Primary ? ";type=PREF" : String.Empty);
					if ( String.IsNullOrEmpty(sType) )
						sType = "OTHER";
					if ( email.Internet )
						sType += ";type=INTERNET";
					sbVCard.AppendLine("EMAIL;type=" + sType + sPref + ":" + email.Address);
				}
			}
			int nItemIndex = 0;
			foreach ( StructuredPostalAddress address in this.PostalAddresses )
			{
				string sType = address.Type;
				string sPref = (address.Primary ? ";type=PREF" : String.Empty);
				if ( String.IsNullOrEmpty(sType) )
					sType = "OTHER";
				
				string sPobox    = !String.IsNullOrEmpty(address.Pobox   ) ? address.Pobox    : String.Empty;
				string sStreet   = !String.IsNullOrEmpty(address.Street  ) ? address.Street   : String.Empty;
				string sRegion   = !String.IsNullOrEmpty(address.Region  ) ? address.Region   : String.Empty;
				string sCity     = !String.IsNullOrEmpty(address.City    ) ? address.City     : String.Empty;
				string sPostcode = !String.IsNullOrEmpty(address.Postcode) ? address.Postcode : String.Empty;
				string sCountry  = !String.IsNullOrEmpty(address.Country ) ? address.Country  : String.Empty;
				sStreet = sStreet.Replace("\r\n", "\n");
				sStreet = sStreet.Replace("\r"  , "\n");
				sStreet = sStreet.Replace("\n"  , "\\n");
				
				sbVCard.Append("item" + (nItemIndex+1).ToString() + ".ADR" + ";type=" + sType + sPref + ":");
				sbVCard.Append(sPobox         );  // 1. Post Office Address
				sbVCard.Append(";"            );  // 2. Extended Address
				sbVCard.Append(";" + sStreet  .Replace(",", "\\,"));  // 3. Street
				sbVCard.Append(";" + sCity    .Replace(",", "\\,"));  // 4. Locality
				sbVCard.Append(";" + sRegion  .Replace(",", "\\,"));  // 5. Region
				sbVCard.Append(";" + sPostcode.Replace(",", "\\,"));  // 6. Postal Code
				sbVCard.Append(";" + sCountry .Replace(",", "\\,"));  // 7. Country
				sbVCard.AppendLine();
				nItemIndex++;
			}
			if ( !String.IsNullOrEmpty(this.Content) )
			{
				string sContent = this.Content;
				sContent = sContent.Replace("\r\n", "\n");
				sContent = sContent.Replace("\r"  , "\n");
				sContent = sContent.Replace("\n"  , "\\n");
				sbVCard.AppendLine("NOTE:"  + sContent);
			}
			foreach ( string sUnknown in this.UnknownLines )
			{
				sbVCard.AppendLine(sUnknown);
			}
			sbVCard.AppendLine("END:VCARD");
			this.RawContent = sbVCard.ToString();
#if DEBUG
			Debug.WriteLine(this.RawContent);
#endif
			return this.RawContent;
		}
	}
	#endregion
}

namespace iCloud.Calendar
{
	public class CalendarService : iCloudService
	{
		public CalendarService(HttpApplicationState Application) : base(Application)
		{
		}

		private void GetCalendarPrincipalHref(iCloudSession Session, byte[] authBytes)
		{
			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.DataclassCalendars);
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "PROPFIND";
			objRequest.Accept            = "*/*";
			objRequest.UserAgent         = "AppleZDAV/3.0.20";
			objRequest.ContentType       = "text/xml; charset=utf-8";
			objRequest.Headers["Authorization"] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			
			// 12/27/2011 Paul.  Sync Calendar\06_Request.txt
			StringBuilder sbRequest = new StringBuilder();
			sbRequest.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
			sbRequest.AppendLine("<propfind xmlns=\"DAV:\">");
			sbRequest.AppendLine("	<prop>");
			sbRequest.AppendLine("		<current-user-principal />");
			sbRequest.AppendLine("		<principal-collection-set />");
			sbRequest.AppendLine("	</prop>");
			sbRequest.AppendLine("</propfind>");
			/*
			objRequest.ContentLength = sbRequest.Length;
			using ( StreamWriter stm = new StreamWriter(objRequest.GetRequestStream(), System.Text.Encoding.UTF8) )
			{
				stm.Write(sbRequest.ToString());
			}
			*/
			// 12/14/2011 Paul.  We are having problems using streams. 
			// Cannot close stream until all bytes are written.
			byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
				{
					using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
					{
						string sResponse = readStream.ReadToEnd();
						XmlDocument xml = new XmlDocument();
						xml.LoadXml(sResponse);
						XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
						nsmgr.AddNamespace("defaultns", "DAV:");
						XmlNode xCurrentUserPrincipalUrl = xml.DocumentElement.SelectSingleNode("defaultns:response/defaultns:propstat/defaultns:prop/defaultns:current-user-principal/defaultns:href", nsmgr);
						if ( xCurrentUserPrincipalUrl != null )
						{
							Session.CalendarPrincipalHref = xCurrentUserPrincipalUrl.InnerText;
							if ( Session.CalendarPrincipalHref.StartsWith("/") )
							{
								Uri urlDataclassCalendars = new Uri(Session.DataclassCalendars);
								Session.CalendarPrincipalHref = urlDataclassCalendars.Scheme + "://" + urlDataclassCalendars.Host + Session.CalendarPrincipalHref;
							}
						}
					}
				}
			}
		}

		private void GetCalendarURL(iCloudSession Session, byte[] authBytes)
		{
			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.CalendarPrincipalHref);
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "PROPFIND";
			objRequest.Accept            = "*/*";
			objRequest.UserAgent         = "AppleZDAV/3.0.20";
			objRequest.ContentType       = "text/xml; charset=utf-8";
			objRequest.Headers["Authorization"] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			
			// 12/27/2011 Paul.  Sync Calendar\07_Request.txt
			StringBuilder sbRequest = new StringBuilder();
			sbRequest.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
			sbRequest.AppendLine("<propfind xmlns=\"DAV:\" xmlns:I=\"urn:ietf:params:xml:ns:caldav\" xmlns:C=\"urn:ietf:params:xml:ns:carddav\" xmlns:A=\"http://calendarserver.org/ns/\">");
			sbRequest.AppendLine("	<prop>");
			sbRequest.AppendLine("		<resourcetype />");
			sbRequest.AppendLine("		<principal-URL />");
			sbRequest.AppendLine("		<current-user-principal />");
			sbRequest.AppendLine("		<principal-collection-set />");
			sbRequest.AppendLine("		<I:calendar-user-address-set />");
			sbRequest.AppendLine("		<I:calendar-user-type />");
			sbRequest.AppendLine("		<I:schedule-inbox-URL />");
			sbRequest.AppendLine("		<I:schedule-outbox-URL />");
			sbRequest.AppendLine("		<I:calendar-home-set />");
			sbRequest.AppendLine("		<C:addressbook-home-set />");
			sbRequest.AppendLine("		<A:getctag />");
			sbRequest.AppendLine("		<A:dropbox-home-URL />");
			sbRequest.AppendLine("		<A:email-address-set />");
			sbRequest.AppendLine("		<A:first-name />");
			sbRequest.AppendLine("		<A:last-name />");
			sbRequest.AppendLine("	</prop>");
			sbRequest.AppendLine("</propfind>");
			/*
			objRequest.ContentLength = sbRequest.Length;
			using ( StreamWriter stm = new StreamWriter(objRequest.GetRequestStream(), System.Text.Encoding.UTF8) )
			{
				stm.Write(sbRequest.ToString());
			}
			*/
			// 12/14/2011 Paul.  We are having problems using streams. 
			// Cannot close stream until all bytes are written.
			byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
				{
					using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
					{
						string sResponse = readStream.ReadToEnd();
						XmlDocument xml = new XmlDocument();
						xml.LoadXml(sResponse);
						XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
						nsmgr.AddNamespace("defaultns", "DAV:");
						nsmgr.AddNamespace("caldav"   , "urn:ietf:params:xml:ns:caldav");
						XmlNode xCalendar = xml.DocumentElement.SelectSingleNode("defaultns:response/defaultns:propstat/defaultns:prop/caldav:calendar-home-set/defaultns:href", nsmgr);
						if ( xCalendar != null )
						{
							Session.CalendarURL = xCalendar.InnerText;
						}
					}
				}
			}
		}

		// http://www.ietf.org/rfc/rfc5689.txt
		private bool CreateFolder(iCloudSession Session, byte[] authBytes, string sFolderName)
		{
			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.CalendarURL + Guid.NewGuid().ToString() + "/");
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "MKCOL";
			objRequest.Accept            = "*/*";
			objRequest.UserAgent         = "AppleZDAV/3.0.20 (OL/14.0.0.4760; Win/6.1.0.0)";
			objRequest.ContentType       = "text/xml";
			objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			
			// 12/27/2011 Paul.  Sync Calendar\10_Request.txt
			StringBuilder sbRequest = new StringBuilder();
			sbRequest.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
			sbRequest.AppendLine("<mkcol xmlns=\"DAV:\" xmlns:C=\"urn:ietf:params:xml:ns:caldav\">");
			sbRequest.AppendLine("	<set>");
			sbRequest.AppendLine("		<prop>");
			sbRequest.AppendLine("			<resourcetype>");
			sbRequest.AppendLine("				<collection/>");
			sbRequest.AppendLine("				<C:calendar/>");
			sbRequest.AppendLine("			</resourcetype>");
			sbRequest.AppendLine("			<C:supported-calendar-component-set>");
			sbRequest.AppendLine("				<C:comp name=\"VEVENT\" />");
			sbRequest.AppendLine("			</C:supported-calendar-component-set>");
			sbRequest.AppendLine("			<displayname>" + sFolderName +"</displayname>");
			sbRequest.AppendLine("		</prop>");
			sbRequest.AppendLine("	</set>");
			sbRequest.AppendLine("</mkcol>");

			byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			bool bCreated = false;
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Created )
				{
					bCreated = true;
				}
			}
			return bCreated;
		}

		private void GetCTagUrl(iCloudSession Session, byte[] authBytes)
		{
			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.CalendarURL);
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "PROPFIND";
			objRequest.Accept            = "*/*";
			objRequest.UserAgent         = "AppleZDAV/3.0.20";
			objRequest.ContentType       = "text/xml; charset=utf-8";
			objRequest.Accept            = "text/xml";
			objRequest.Headers["Accept-Charset"] = "utf-8";
			objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			objRequest.Headers["Depth"         ] = "1";
			objRequest.Headers["Brief"         ] = "t";
			
			// 12/27/2011 Paul.  Sync Calendar\10_Request.txt
			StringBuilder sbRequest = new StringBuilder();
			sbRequest.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
			sbRequest.AppendLine("<propfind xmlns=\"DAV:\" xmlns:I=\"urn:ietf:params:xml:ns:caldav\" xmlns:A=\"http://calendarserver.org/ns/\" xmlns:M=\"http://cal.me.com/_namespace/\" xmlns:MG=\"http://me.com/_namespace/\" xmlns:C=\"http://apple.com/ns/ical/\">");
			sbRequest.AppendLine("	<prop>");
			sbRequest.AppendLine("		<displayname />");
			sbRequest.AppendLine("		<resourcetype />");
			sbRequest.AppendLine("		<current-user-privilege-set />");
			sbRequest.AppendLine("		<current-user-principal />");
			sbRequest.AppendLine("		<modificationdate />");
			sbRequest.AppendLine("		<getlastmodified />");
			sbRequest.AppendLine("		<owner />");
			sbRequest.AppendLine("		<I:supported-calendar-component-set />");
			sbRequest.AppendLine("		<I:supported-calendar-data />");
			sbRequest.AppendLine("		<I:calendar-description />");
			sbRequest.AppendLine("		<I:calendar-timezone />");
			sbRequest.AppendLine("		<I:schedule-default-calendar-URL />");
			sbRequest.AppendLine("		<A:getctag />");
			sbRequest.AppendLine("		<A:invite />");
			sbRequest.AppendLine("		<A:calendar-availability />");
			sbRequest.AppendLine("		<A:push-transports />");
			sbRequest.AppendLine("		<A:pushkey />");
			sbRequest.AppendLine("		<A:shared-url />");
			sbRequest.AppendLine("		<A:source />");
			sbRequest.AppendLine("		<MG:bulk-requests />");
			sbRequest.AppendLine("		<C:calendar-order />");
			sbRequest.AppendLine("		<C:calendar-color />");
			sbRequest.AppendLine("		<C:calendar-enabled />");
			sbRequest.AppendLine("		<C:refreshrate />");
			sbRequest.AppendLine("	</prop>");
			sbRequest.AppendLine("</propfind>");
			
			byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			string sResponse = String.Empty;
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
				{
					using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
					{
						sResponse = readStream.ReadToEnd();
					}
				}
			}
			
			if ( !String.IsNullOrEmpty(sResponse) )
			{
				XmlDocument xml = new XmlDocument();
				xml.LoadXml(sResponse);
				XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
				nsmgr.AddNamespace("defaultns", "DAV:");
				nsmgr.AddNamespace("caldav"   , "urn:ietf:params:xml:ns:caldav");
				nsmgr.AddNamespace("calsvr"   , "http://calendarserver.org/ns/");
				XmlNode xCalendar = xml.DocumentElement.SelectSingleNode("defaultns:response/defaultns:propstat/defaultns:prop[defaultns:displayname='SplendidCRM']", nsmgr);
				if ( xCalendar != null )
				{
					XmlNode xProp = xCalendar;
					XmlNode xGetLastModified = xProp.SelectSingleNode("defaultns:getlastmodified", nsmgr);
					if( xGetLastModified != null )
					{
						try
						{
							Session.CalendarLastModified = DateTime.Parse(xGetLastModified.InnerText);
						}
						catch
						{
						}
					}
					// 12/19/2011 Paul.  Only update CTag if it is empty. 
					// 02/06/2012 Paul.  Only update CTag after a query operation. 
					/*
					if ( String.IsNullOrEmpty(Session.CalendarCTag) )
					{
						XmlNode xGetCTag = xProp.SelectSingleNode("calsvr:getctag", nsmgr);
						if ( xGetCTag != null )
						{
							Session.CalendarCTag = xGetCTag.InnerText;
						}
					}
					*/
					// 12/27/2011 Paul.  We get the default calendar, not the home. 
					XmlNode xResponse = xProp.ParentNode.ParentNode;
					XmlNode xCTagUrl = xResponse.SelectSingleNode("defaultns:href", nsmgr);
					if( xCTagUrl != null )
					{
						Session.CalendarCTagUrl = xCTagUrl.InnerText;
						if ( Session.CalendarCTagUrl.StartsWith("/") )
						{
							Uri urlCalendarURL = new Uri(Session.CalendarURL);
							Session.CalendarCTagUrl = urlCalendarURL.Scheme + "://" + urlCalendarURL.Host + Session.CalendarCTagUrl;
						}
						if ( !Session.CalendarCTagUrl.EndsWith("/") )
							Session.CalendarCTagUrl += "/";
					}
				}
				// 01/11/2012 Paul.  If the SplendidCRM calendar does not exist, then create it. 
				else
				{
					if ( CreateFolder(Session, authBytes, "SplendidCRM") )
					{
						// 01/11/2012 Paul.  We need to create a new request. 
						objRequest = (HttpWebRequest) WebRequest.Create(Session.CalendarURL);
						objRequest.Headers.Add("cache-control", "no-cache");
						objRequest.PreAuthenticate   = true ;
						objRequest.KeepAlive         = true ;
						objRequest.AllowAutoRedirect = false;
						objRequest.Timeout           = 20000;  //20 seconds
						objRequest.Method            = "PROPFIND";
						objRequest.Accept            = "*/*";
						objRequest.UserAgent         = "AppleZDAV/3.0.20";
						objRequest.ContentType       = "text/xml; charset=utf-8";
						objRequest.Accept            = "text/xml";
						objRequest.Headers["Accept-Charset"] = "utf-8";
						objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
						objRequest.Headers["Depth"         ] = "1";
						objRequest.Headers["Brief"         ] = "t";
						
						// 01/11/2012 Paul.  The existing by array will work fine. 
						objRequest.ContentLength = by.Length;
						objRequest.GetRequestStream().Write(by, 0, by.Length);
						using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
						{
							if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
							{
								using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
								{
									sResponse = readStream.ReadToEnd();
								}
							}
						}
						if ( !String.IsNullOrEmpty(sResponse) )
						{
							xml = new XmlDocument();
							xml.LoadXml(sResponse);
							nsmgr = new XmlNamespaceManager(xml.NameTable);
							nsmgr.AddNamespace("defaultns", "DAV:");
							nsmgr.AddNamespace("caldav"   , "urn:ietf:params:xml:ns:caldav");
							nsmgr.AddNamespace("calsvr"   , "http://calendarserver.org/ns/");
							xCalendar = xml.DocumentElement.SelectSingleNode("defaultns:response/defaultns:propstat/defaultns:prop[defaultns:displayname='SplendidCRM']", nsmgr);
							if ( xCalendar != null )
							{
								XmlNode xProp = xCalendar;
								XmlNode xGetLastModified = xProp.SelectSingleNode("defaultns:getlastmodified", nsmgr);
								if( xGetLastModified != null )
								{
									try
									{
										Session.CalendarLastModified = DateTime.Parse(xGetLastModified.InnerText);
									}
									catch
									{
									}
								}
								// 12/19/2011 Paul.  Only update CTag if it is empty. 
								if ( String.IsNullOrEmpty(Session.CalendarCTag) )
								{
									XmlNode xGetCTag = xProp.SelectSingleNode("calsvr:getctag", nsmgr);
									if ( xGetCTag != null )
									{
										Session.CalendarCTag = xGetCTag.InnerText;
									}
								}
								// 12/27/2011 Paul.  We get the default calendar, not the home. 
								XmlNode xResponse = xProp.ParentNode.ParentNode;
								XmlNode xCTagUrl = xResponse.SelectSingleNode("defaultns:href", nsmgr);
								if( xCTagUrl != null )
								{
									Session.CalendarCTagUrl = xCTagUrl.InnerText;
									if ( Session.CalendarCTagUrl.StartsWith("/") )
									{
										Uri urlCalendarURL = new Uri(Session.CalendarURL);
										Session.CalendarCTagUrl = urlCalendarURL.Scheme + "://" + urlCalendarURL.Host + Session.CalendarCTagUrl;
									}
									if ( !Session.CalendarCTagUrl.EndsWith("/") )
										Session.CalendarCTagUrl += "/";
								}
							}
						}
					}
					// 12/28/2011 Paul.  If the SplendidCRM calendar does not exist, then use the default.  Must have failed to create. 
					if ( String.IsNullOrEmpty(Session.CalendarCTagUrl) )
					{
						xCalendar = xml.DocumentElement.SelectSingleNode("defaultns:response/defaultns:propstat/defaultns:prop/caldav:schedule-default-calendar-URL/defaultns:href", nsmgr);
						if ( xCalendar != null )
						{
							XmlNode xProp = xCalendar.ParentNode.ParentNode;
							XmlNode xGetLastModified = xProp.SelectSingleNode("defaultns:getlastmodified", nsmgr);
							if( xGetLastModified != null )
							{
								try
								{
									Session.CalendarLastModified = DateTime.Parse(xGetLastModified.InnerText);
								}
								catch
								{
								}
							}
							// 12/19/2011 Paul.  Only update CTag if it is empty. 
							if ( String.IsNullOrEmpty(Session.CalendarCTag) )
							{
								XmlNode xGetCTag = xProp.SelectSingleNode("calsvr:getctag", nsmgr);
								if ( xGetCTag != null )
								{
									Session.CalendarCTag = xGetCTag.InnerText;
								}
							}
							// 12/27/2011 Paul.  We get the default calendar, not the home. 
							/*
							XmlNode xResponse = xProp.ParentNode.ParentNode;
							XmlNode xCTagUrl = xResponse.SelectSingleNode("defaultns:href", nsmgr);
							if( xCTagUrl != null )
							{
								Session.CalendarCTagUrl = xCTagUrl.InnerText;
							}
							*/
							Session.CalendarCTagUrl = xCalendar.InnerText;
							if ( Session.CalendarCTagUrl.StartsWith("/") )
							{
								Uri urlCalendarURL = new Uri(Session.CalendarURL);
								Session.CalendarCTagUrl = urlCalendarURL.Scheme + "://" + urlCalendarURL.Host + Session.CalendarCTagUrl;
							}
							if ( !Session.CalendarCTagUrl.EndsWith("/") )
								Session.CalendarCTagUrl += "/";
						}
					}
				}
			}
		}

		public List<AppointmentEntry> Query(HttpContext Context)
		{
			List<AppointmentEntry> lst = new List<AppointmentEntry>();
			
			iCloudSession Session = Application["iCloud.Session." + Username] as iCloudSession;
			if ( Session == null )
				QueryClientLoginToken(false);

			byte[] authBytes = System.Text.Encoding.UTF8.GetBytes(Session.PrincipalID + ":" + Session.ClientToken);
			if ( String.IsNullOrEmpty(Session.CalendarPrincipalHref) )
			{
				GetCalendarPrincipalHref(Session, authBytes);
			}
			if ( String.IsNullOrEmpty(Session.CalendarURL) )
			{
				GetCalendarURL(Session, authBytes);
			}
			if ( String.IsNullOrEmpty(Session.CalendarCTagUrl) )
			{
				GetCTagUrl(Session, authBytes);
			}
			List<string> items = new List<string>();
			if ( items.Count == 0 && !String.IsNullOrEmpty(Session.CalendarCTagUrl) )
			{
				HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.CalendarCTagUrl);
				objRequest.Headers.Add("cache-control", "no-cache");
				objRequest.PreAuthenticate   = true ;
				objRequest.KeepAlive         = true ;
				objRequest.AllowAutoRedirect = false;
				objRequest.Timeout           = 20000;  //20 seconds
				objRequest.Method            = "REPORT";
				objRequest.UserAgent         = "AppleZDAV/3.0.42 (OL/14; Win/6.1.1.0)";
				objRequest.ContentType       = "text/xml";
				objRequest.Accept            = "text/xml";
				objRequest.Headers["Accept-Charset"] = "utf-8";
				objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
				objRequest.Headers["Depth"         ] = "1";
				objRequest.Headers["Brief"         ] = "t";
				
				StringBuilder sbRequest = new StringBuilder();
				sbRequest.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
				sbRequest.AppendLine("<sync-collection xmlns=\"DAV:\" xmlns:A=\"http://calendarserver.org/ns/\">");
				sbRequest.AppendLine("	<sync-token />");
				sbRequest.AppendLine("	<prop>");
				sbRequest.AppendLine("		<getetag />");
				sbRequest.AppendLine("	</prop>");
				sbRequest.AppendLine("</sync-collection>");
				
				byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
				objRequest.ContentLength = by.Length;
				objRequest.GetRequestStream().Write(by, 0, by.Length);
				
				using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
				{
					if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
					{
						using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
						{
							string sResponse = readStream.ReadToEnd();
							XmlDocument xml = new XmlDocument();
							xml.LoadXml(sResponse);
							XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
							nsmgr.AddNamespace("defaultns", "DAV:");
							
							XmlNodeList nlHref = xml.DocumentElement.SelectNodes("defaultns:response/defaultns:href", nsmgr);
							foreach ( XmlNode xHref in nlHref )
							{
								// 12/14/2011 Paul.  The first item in the list is the ctag for the list itself. 
								// It could be a folder or category thing, so just ignore anything ending in a slash. 
								// Another option would be to only include urls ending in .ics. 
								if ( !xHref.InnerText.EndsWith("/") )
								{
									items.Add(xHref.InnerText);
								}
							}
						}
					}
				}
			}
			if ( items.Count > 0 )
			{
				HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.CalendarCTagUrl);
				objRequest.Headers.Add("cache-control", "no-cache");
				objRequest.PreAuthenticate   = true ;
				objRequest.KeepAlive         = true ;
				objRequest.AllowAutoRedirect = false;
				objRequest.Timeout           = 20000;  //20 seconds
				objRequest.Method            = "REPORT";
				objRequest.UserAgent         = "AppleZDAV/3.0.20 (OL/14; Win/6.1.0.0)";
				objRequest.ContentType       = "text/xml";
				objRequest.Accept            = "text/xml";
				objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
				
				StringBuilder sbRequest = new StringBuilder();
				sbRequest.AppendLine("<?xml version=\"1.0\"?>");
				sbRequest.AppendLine("<C:calendar-multiget xmlns=\"DAV:\"  xmlns:C=\"urn:ietf:params:xml:ns:caldav\">");
				sbRequest.AppendLine("	<prop>");
				sbRequest.AppendLine("		<getetag/>");
				sbRequest.AppendLine("		<getcontenttype/>");
				sbRequest.AppendLine("		<C:calendar-data/>");
				sbRequest.AppendLine("	</prop>");
				foreach ( string sItemPath in items )
				{
					sbRequest.AppendLine("	<href>" + sItemPath + "</href>");
				}
				sbRequest.AppendLine("</C:calendar-multiget>");
				
				byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
				objRequest.ContentLength = by.Length;
				objRequest.GetRequestStream().Write(by, 0, by.Length);
				
				using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
				{
					if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
					{
						using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
						{
							string sResponse = readStream.ReadToEnd();
							XmlDocument xml = new XmlDocument();
							xml.LoadXml(sResponse);
							XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
							nsmgr.AddNamespace("defaultns", "DAV:");
							nsmgr.AddNamespace("CD"       , "urn:ietf:params:xml:ns:caldav");
							nsmgr.AddNamespace("CS"       , "http://calendarserver.org/ns/" );

							XmlNodeList nlResponse = xml.DocumentElement.SelectNodes("defaultns:response", nsmgr);
							foreach ( XmlNode xResponse in nlResponse )
							{
								AppointmentEntry item = new AppointmentEntry();
								XmlNode xHref         = xResponse.SelectSingleNode("defaultns:href"  , nsmgr);
								XmlNode xStatus       = xResponse.SelectSingleNode("defaultns:status", nsmgr);
								XmlNode xGetETag      = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/defaultns:getetag", nsmgr);
								XmlNode xCalendarData = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/CD:calendar-data" , nsmgr);
								if ( xHref != null && xGetETag != null && xCalendarData != null )
								{
									item.Href = xHref.InnerText;
									item.ETag = xGetETag.InnerText;
									item.Parse(Context, xCalendarData.InnerText);
									lst.Add(item);
								}
								else if ( xHref != null && xStatus != null && xStatus.InnerText == "HTTP/1.1 404 Not Found" )
								{
									// 01/12/2012 Paul.  A deleted item will only have the HREF.  Convert the HREF to a UID. 
									item.Href    = xHref.InnerText;
									item.UID     = ConvertHREFtoUID(item.Href);
									item.Deleted = true;
									item.Updated = DateTime.Now;
									lst.Add(item);
								}
							}
						}
					}
				}
			}
			return lst;
		}

		public List<AppointmentEntry> SyncQuery(HttpContext Context, bool bSyncAll)
		{
			List<AppointmentEntry> lst = new List<AppointmentEntry>();
			
			iCloudSession Session = Application["iCloud.Session." + Username] as iCloudSession;
			if ( Session == null )
				QueryClientLoginToken(false);

			byte[] authBytes = System.Text.Encoding.UTF8.GetBytes(Session.PrincipalID + ":" + Session.ClientToken);
			if ( String.IsNullOrEmpty(Session.CalendarPrincipalHref) )
			{
				GetCalendarPrincipalHref(Session, authBytes);
			}
			if ( String.IsNullOrEmpty(Session.CalendarURL) )
			{
				GetCalendarURL(Session, authBytes);
			}
			if ( String.IsNullOrEmpty(Session.CalendarCTagUrl) )
			{
				GetCTagUrl(Session, authBytes);
			}

			string sNewCTag = this.CalendarCTag;
			List<string> items = new List<string>();
			if ( items.Count == 0 && !String.IsNullOrEmpty(Session.CalendarCTagUrl) )
			{
				HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.CalendarCTagUrl);
				objRequest.Headers.Add("cache-control", "no-cache");
				objRequest.PreAuthenticate   = true ;
				objRequest.KeepAlive         = true ;
				objRequest.AllowAutoRedirect = false;
				objRequest.Timeout           = 20000;  //20 seconds
				objRequest.Method            = "REPORT";
				objRequest.UserAgent         = "AppleZDAV/3.0.42 (OL/14; Win/6.1.1.0)";
				objRequest.ContentType       = "text/xml";
				objRequest.Accept            = "text/xml";
				objRequest.Headers["Accept-Charset"] = "utf-8";
				objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
				objRequest.Headers["Depth"         ] = "1";
				objRequest.Headers["Brief"         ] = "t";
				
				StringBuilder sbRequest = new StringBuilder();
				sbRequest.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
				sbRequest.AppendLine("<sync-collection xmlns=\"DAV:\" xmlns:A=\"http://calendarserver.org/ns/\">");
				if ( bSyncAll || String.IsNullOrEmpty(sNewCTag) )
					sbRequest.AppendLine("	<sync-token />");
				else
					sbRequest.AppendLine("	<sync-token>" + sNewCTag + "</sync-token>");
				sbRequest.AppendLine("	<prop>");
				sbRequest.AppendLine("		<getetag />");
				sbRequest.AppendLine("	</prop>");
				sbRequest.AppendLine("</sync-collection>");
				
				byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
				objRequest.ContentLength = by.Length;
				objRequest.GetRequestStream().Write(by, 0, by.Length);
				
				using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
				{
					if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
					{
						using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
						{
							string sResponse = readStream.ReadToEnd();
							XmlDocument xml = new XmlDocument();
							xml.LoadXml(sResponse);
							XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
							nsmgr.AddNamespace("defaultns", "DAV:");
							
							XmlNodeList nlHref = xml.DocumentElement.SelectNodes("defaultns:response/defaultns:href", nsmgr);
							foreach ( XmlNode xHref in nlHref )
							{
								// 12/14/2011 Paul.  The first item in the list is the ctag for the list itself. 
								// It could be a folder or category thing, so just ignore anything ending in a slash. 
								// Another option would be to only include urls ending in .ics. 
								if ( !xHref.InnerText.EndsWith("/") )
								{
									items.Add(xHref.InnerText);
								}
							}
							XmlNode xSyncToken = xml.DocumentElement.SelectSingleNode("defaultns:sync-token", nsmgr);
							if ( xSyncToken != null )
							{
								sNewCTag = xSyncToken.InnerText;
							}
						}
					}
				}
			}
			if ( items.Count > 0 )
			{
				HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.CalendarCTagUrl);
				objRequest.Headers.Add("cache-control", "no-cache");
				objRequest.PreAuthenticate   = true ;
				objRequest.KeepAlive         = true ;
				objRequest.AllowAutoRedirect = false;
				objRequest.Timeout           = 20000;  //20 seconds
				objRequest.Method            = "REPORT";
				objRequest.UserAgent         = "AppleZDAV/3.0.20 (OL/14; Win/6.1.0.0)";
				objRequest.ContentType       = "text/xml";
				objRequest.Accept            = "text/xml";
				objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
				
				StringBuilder sbRequest = new StringBuilder();
				sbRequest.AppendLine("<?xml version=\"1.0\"?>");
				sbRequest.AppendLine("<C:calendar-multiget xmlns=\"DAV:\"  xmlns:C=\"urn:ietf:params:xml:ns:caldav\">");
				sbRequest.AppendLine("	<prop>");
				sbRequest.AppendLine("		<getetag/>");
				sbRequest.AppendLine("		<getcontenttype/>");
				sbRequest.AppendLine("		<C:calendar-data/>");
				sbRequest.AppendLine("	</prop>");
				foreach ( string sItemPath in items )
				{
					sbRequest.AppendLine("	<href>" + sItemPath + "</href>");
				}
				sbRequest.AppendLine("</C:calendar-multiget>");
				
				byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
				objRequest.ContentLength = by.Length;
				objRequest.GetRequestStream().Write(by, 0, by.Length);
				
				using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
				{
					if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
					{
						using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
						{
							string sResponse = readStream.ReadToEnd();
							XmlDocument xml = new XmlDocument();
							xml.LoadXml(sResponse);
							XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
							nsmgr.AddNamespace("defaultns", "DAV:");
							nsmgr.AddNamespace("CD"       , "urn:ietf:params:xml:ns:caldav");
							nsmgr.AddNamespace("CS"       , "http://calendarserver.org/ns/" );

							XmlNodeList nlResponse = xml.DocumentElement.SelectNodes("defaultns:response", nsmgr);
							foreach ( XmlNode xResponse in nlResponse )
							{
								AppointmentEntry item = new AppointmentEntry();
								XmlNode xHref         = xResponse.SelectSingleNode("defaultns:href"  , nsmgr);
								XmlNode xStatus       = xResponse.SelectSingleNode("defaultns:status", nsmgr);
								XmlNode xGetETag      = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/defaultns:getetag", nsmgr);
								XmlNode xCalendarData = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/CD:calendar-data" , nsmgr);
								if ( xHref != null && xGetETag != null && xCalendarData != null )
								{
									item.Href = xHref.InnerText;
									item.ETag = xGetETag.InnerText;
									item.Parse(Context, xCalendarData.InnerText);
									// 01/15/2012 Paul.  Modifications on the iCloud web site do not chagne the DTStamp or LastModified date. 
									// Since we can't trust the date value, if the date is older than 10 minutes, then use Now. 
									if ( item.Updated.AddMinutes(10) < DateTime.Now )
										item.Updated = DateTime.Now;
									lst.Add(item);
								}
								else if ( xHref != null && xStatus != null && xStatus.InnerText == "HTTP/1.1 404 Not Found" )
								{
									// 01/12/2012 Paul.  A deleted item will only have the HREF.  Convert the HREF to a UID. 
									item.Href    = xHref.InnerText;
									item.UID     = ConvertHREFtoUID(item.Href);
									item.Deleted = true;
									item.Updated = DateTime.Now;
									lst.Add(item);
								}
							}
							Session.CalendarCTag = sNewCTag;
						}
					}
				}
			}
			else
			{
				Session.CalendarCTag = sNewCTag;
			}
			this.CalendarCTag = sNewCTag;
			return lst;
		}

		public AppointmentEntry Insert(HttpContext Context, AppointmentEntry appointment)
		{
#if DEBUG
			Debug.WriteLine("CalendarService.Insert " + appointment.UID);
#endif
			iCloudSession Session = Application["iCloud.Session." + Username] as iCloudSession;
			if ( Session == null )
				QueryClientLoginToken(false);

			if ( String.IsNullOrEmpty(Session.CalendarCTag) )
			{
				Query(Context);
			}

			string sSyncTag  = Session.CalendarCTag;
			byte[] authBytes = System.Text.Encoding.UTF8.GetBytes(Session.PrincipalID + ":" + Session.ClientToken);
			
			appointment.UID = "CZTL-" + Guid.NewGuid().ToString();
			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.CalendarCTagUrl + appointment.UID + ".ics");
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "PUT";
			objRequest.UserAgent         = "AppleZDAV/3.0.20 (OL/14.0.0.4760; Win/6.1.0.0)";
			objRequest.ContentType       = "text/calendar; charset=utf-8";
			objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			objRequest.Headers["If-None-Match" ] = "*";
			
			// 02/11/2012 Paul.  We are getting a forbidden error when creating an appointment.  Try to fix by including the PrincipalID for the organizer. 
			string sRequest = appointment.CreateVCalendar(Context, Session.PrincipalID);
			byte[] by = Encoding.UTF8.GetBytes(sRequest);
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.NoContent || objResponse.StatusCode == HttpStatusCode.Found || objResponse.StatusCode == HttpStatusCode.Created || (int) objResponse.StatusCode == 207 )
				{
					appointment.ETag = objResponse.Headers["ETag"];
				}
			}

			objRequest = (HttpWebRequest) WebRequest.Create(Session.CalendarCTagUrl);
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "REPORT";
			objRequest.UserAgent         = "AppleZDAV/3.0.20";
			objRequest.ContentType       = "text/xml; charset=utf-8";
			objRequest.Accept            = "text/xml";
			objRequest.Headers["Accept-Charset"] = "utf-8";
			objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			objRequest.Headers["Depth"         ] = "1";
			objRequest.Headers["Brief"         ] = "t";
			
			StringBuilder sbRequest = new StringBuilder();
			sbRequest.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
			// 12/19/2011 Paul.  Can't seem to get the UID directly from the ETAG, so we need to use the sync-token. 
			sbRequest.AppendLine("<sync-collection xmlns=\"DAV:\" xmlns:A=\"http://calendarserver.org/ns/\">");
			sbRequest.AppendLine("	<sync-token>" + sSyncTag + "</sync-token>");
			sbRequest.AppendLine("	<prop>");
			sbRequest.AppendLine("		<getetag />");
			sbRequest.AppendLine("	</prop>");
			sbRequest.AppendLine("</sync-collection>");

			by = Encoding.UTF8.GetBytes(sbRequest.ToString());
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
				{
					using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
					{
						string sResponse = readStream.ReadToEnd();
						XmlDocument xml = new XmlDocument();
						xml.LoadXml(sResponse);
						XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
						nsmgr.AddNamespace("defaultns", "DAV:");
						nsmgr.AddNamespace("CS"       , "http://calendarserver.org/ns/" );

						XmlNodeList nlResponse = xml.DocumentElement.SelectNodes("defaultns:response", nsmgr);
						foreach ( XmlNode xResponse in nlResponse )
						{
							XmlNode xHref        = xResponse.SelectSingleNode("defaultns:href", nsmgr);
							XmlNode xGetETag     = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/defaultns:getetag", nsmgr);
							XmlNode xUID         = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/CS:uid"           , nsmgr);
							if ( xHref != null && xGetETag != null && xGetETag.InnerText == appointment.ETag )
							{
								if ( xUID != null && !String.IsNullOrEmpty(xUID.InnerText) )
								{
									appointment.UID = xUID.InnerText;
								}
								else
								{
									appointment.UID = xHref.InnerText;
									appointment.UID = appointment.UID.Replace(".ics", String.Empty);
									string[] arr = appointment.UID.Split('/');
									appointment.UID = arr[arr.Length - 1];
								}
								break;
							}
						}
					}
#if DEBUG
					if ( !String.IsNullOrEmpty(appointment.UID) )
					{
						// 01/07/2012 Paul.  After updating, get again so that we can compare the two. 
						AppointmentEntry appointmentNew = Get(Context, appointment.UID);
						return appointmentNew;
					}
#endif
				}
			}
			return appointment;
		}

		public AppointmentEntry Update(HttpContext Context, AppointmentEntry appointment)
		{
#if DEBUG
			Debug.WriteLine("CalendarService.Update " + appointment.UID);
#endif
			iCloudSession Session = Application["iCloud.Session." + Username] as iCloudSession;
			if ( Session == null )
				QueryClientLoginToken(false);

			if ( String.IsNullOrEmpty(Session.CalendarCTag) )
			{
				Query(Context);
			}

			byte[] authBytes = System.Text.Encoding.UTF8.GetBytes(Session.PrincipalID + ":" + Session.ClientToken);
			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.CalendarCTagUrl + appointment.UID + ".ics");
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "PUT";
			objRequest.UserAgent         = "AppleZDAV/3.0.20 (OL/14.0.0.4760; Win/6.1.0.0)";
			objRequest.ContentType       = "text/calendar; charset=utf-8";
			objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			
			// 02/11/2012 Paul.  We are getting a forbidden error when creating an appointment.  Try to fix by including the PrincipalID for the organizer. 
			string sRequest = appointment.CreateVCalendar(Context, Session.PrincipalID);
			byte[] by = Encoding.UTF8.GetBytes(sRequest);
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.NoContent || objResponse.StatusCode == HttpStatusCode.Found || objResponse.StatusCode == HttpStatusCode.Accepted || (int) objResponse.StatusCode == 207 )
				{
					appointment.ETag = objResponse.Headers["ETag"];
#if DEBUG
					// 01/07/2012 Paul.  After updating, get again so that we can compare the two. 
					AppointmentEntry appointmentNew = Get(Context, appointment.UID);
					return appointmentNew;
#endif
				}
			}
			return appointment;
		}

		public void Delete(HttpContext Context, string sUID)
		{
#if DEBUG
			Debug.WriteLine("CalendarService.Delete " + sUID);
#endif
			iCloudSession Session = Application["iCloud.Session." + Username] as iCloudSession;
			if ( Session == null )
				QueryClientLoginToken(false);

			if ( String.IsNullOrEmpty(Session.CalendarCTag) )
			{
				Query(Context);
			}

			byte[] authBytes = System.Text.Encoding.UTF8.GetBytes(Session.PrincipalID + ":" + Session.ClientToken);
			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.CalendarCTagUrl + sUID + ".ics");
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "DELETE";
			objRequest.UserAgent         = "AppleZDAV/3.0.20 (OL/14.0.0.4760; Win/6.1.0.0)";
			objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.NoContent )
				{
				}
			}
		}

		public AppointmentEntry Get(HttpContext Context, string sUID)
		{
#if DEBUG
			Debug.WriteLine("CalendarService.Get " + sUID);
#endif
			iCloudSession Session = Application["iCloud.Session." + Username] as iCloudSession;
			if ( Session == null )
				QueryClientLoginToken(false);

			byte[] authBytes = System.Text.Encoding.UTF8.GetBytes(Session.PrincipalID + ":" + Session.ClientToken);
			if ( String.IsNullOrEmpty(Session.CalendarPrincipalHref) )
			{
				GetCalendarPrincipalHref(Session, authBytes);
			}
			if ( String.IsNullOrEmpty(Session.CalendarURL) )
			{
				GetCalendarURL(Session, authBytes);
			}
			if ( String.IsNullOrEmpty(Session.CalendarCTagUrl) )
			{
				GetCTagUrl(Session, authBytes);
			}

			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(Session.CalendarCTagUrl);
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.PreAuthenticate   = true ;
			objRequest.KeepAlive         = true ;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 20000;  //20 seconds
			objRequest.Method            = "REPORT";
			objRequest.UserAgent         = "AppleZDAV/3.0.20 (OL/14; Win/6.1.0.0)";
			objRequest.ContentType       = "text/xml";
			objRequest.Accept            = "text/xml";
			objRequest.Headers["Authorization" ] = "X-MobileMe-AuthToken " + Convert.ToBase64String(authBytes);
			
			Uri urlCalendarURL = new Uri(Session.CalendarURL);
			StringBuilder sbRequest = new StringBuilder();
			sbRequest.AppendLine("<?xml version=\"1.0\"?>");
			sbRequest.AppendLine("<C:calendar-multiget xmlns=\"DAV:\"  xmlns:C=\"urn:ietf:params:xml:ns:caldav\">");
			sbRequest.AppendLine("	<prop>");
			sbRequest.AppendLine("		<getetag/>");
			sbRequest.AppendLine("		<getcontenttype/>");
			sbRequest.AppendLine("		<C:calendar-data/>");
			sbRequest.AppendLine("	</prop>");
			// 01/04/2012 Paul.  The Calendar ID does not include the scheme or host.  The Contact ID does include the scheme and host. 
			sbRequest.AppendLine("	<href>" + Session.CalendarCTagUrl.Replace(urlCalendarURL.Scheme + "://" + urlCalendarURL.Host, String.Empty) + sUID + ".ics" + "</href>");
			sbRequest.AppendLine("</C:calendar-multiget>");
			
			byte[] by = Encoding.UTF8.GetBytes(sbRequest.ToString());
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found || (int) objResponse.StatusCode == 207 )
				{
					using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
					{
						string sResponse = readStream.ReadToEnd();
						XmlDocument xml = new XmlDocument();
						xml.LoadXml(sResponse);
						XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
						nsmgr.AddNamespace("defaultns", "DAV:");
						nsmgr.AddNamespace("CD"       , "urn:ietf:params:xml:ns:caldav");
						nsmgr.AddNamespace("CS"       , "http://calendarserver.org/ns/" );

						XmlNodeList nlResponse = xml.DocumentElement.SelectNodes("defaultns:response", nsmgr);
						foreach ( XmlNode xResponse in nlResponse )
						{
							AppointmentEntry item = new AppointmentEntry();
							XmlNode xHref         = xResponse.SelectSingleNode("defaultns:href", nsmgr);
							XmlNode xGetETag      = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/defaultns:getetag", nsmgr);
							XmlNode xCalendarData = xResponse.SelectSingleNode("defaultns:propstat/defaultns:prop/CD:calendar-data" , nsmgr);
							if ( xHref != null && xGetETag != null && xCalendarData != null )
							{
								item.Href = xHref.InnerText;
								item.ETag = xGetETag.InnerText;
								item.Parse(Context, xCalendarData.InnerText);
								return item;
							}
						}
					}
				}
			}
			return null;
		}
	}

	#region AppointmentEntry
	public class Where
	{
		public class RelType
		{
			public const string EVENT           = "0";
			public const string EVENT_ALTERNATE = "event.alternate";
			public const string EVENT_PARKING   = "event.parking";

			public string Value { get; set; }

			public RelType()
			{
			}
		}
		
		public string Label       { get; set; }
		public string Rel         { get; set; }
		public string ValueString { get; set; }

		public Where()
		{
		}
		
		public Where(string rel, string label, string value)
		{
			Label       = rel  ;
			Rel         = label;
			ValueString = value;
		}
	}

	public class Reminder
	{
		public enum ReminderMethod
		{
			alert       = 0,
			all         = 1,
			email       = 2,
			none        = 3,
			sms         = 4,
			unspecified = 5,
		}
		
		public DateTime AbsoluteTime { get; set; }
		public int      Days         { get; set; }
		public int      Hours        { get; set; }
		public int      Minutes      { get; set; }
		public Reminder.ReminderMethod Method;

		public Reminder()
		{
			Method = new Reminder.ReminderMethod();
		}
	}

	public class When
	{
		public bool     AllDay      { get; set; }
		public DateTime EndTime     { get; set; }
		public DateTime StartTime   { get; set; }
		public string   ValueString { get; set; }
		public List<Reminder> Reminders;

		public When()
		{
			Reminders = new List<Reminder>();
		}
		public When(DateTime start, DateTime end)
		{
			this.AllDay    = false;
			this.StartTime = start;
			this.EndTime   = end  ;
			Reminders = new List<Reminder>();
		}
		public When(DateTime start, DateTime end, bool allDay)
		{
			this.AllDay    = allDay;
			this.StartTime = start ;
			this.EndTime   = end   ;
			Reminders = new List<Reminder>();
		}
	}

	public class Who
	{
		public class AttendeeStatus
		{
			public const string EVENT_ACCEPTED  = "event.accepted" ;
			public const string EVENT_DECLINED  = "event.declined" ;
			public const string EVENT_INVITED   = "event.invited"  ;
			public const string EVENT_TENTATIVE = "event.tentative";

			public string Value = String.Empty;

			public override string ToString()
			{
				return Value;
			}
		}

		public class AttendeeType
		{
			public const string EVENT_OPTIONAL = "event.optional";
			public const string EVENT_REQUIRED = "event.required";

			public string Value { get; set; }

			public AttendeeType()
			{
			}
		}

		public class RelType
		{
			public const string EVENT_ATTENDEE   = "event.attendee"  ;
			public const string EVENT_ORGANIZER  = "event.organizer" ;
			public const string EVENT_PERFORMER  = "event.performer" ;
			public const string EVENT_SPEAKER    = "event.speaker"   ;
			public const string MESSAGE_BCC      = "message.bcc"     ;
			public const string MESSAGE_CC       = "message.cc"      ;
			public const string MESSAGE_FROM     = "message.from"    ;
			public const string MESSAGE_REPLY_TO = "message.reply-to";
			public const string MESSAGE_TO       = "message.to"      ;
			public const string TASK_ASSIGNED_TO = "task.assigned-to";

			public string Value = String.Empty;
		}

		public string ID          { get; set; }
		public string Name        { get; set; }
		public string Email       { get; set; }
		public bool   RSVP        { get; set; }
		public string Role        { get; set; }
		public string Rel         { get; set; }
		public string Prefix      { get; set; }
		//public string ValueString { get; set; }
		public Who.AttendeeStatus Attendee_Status { get; set; }
		public Who.AttendeeType   Attendee_Type   { get; set; }

		public Who()
		{
			Attendee_Status = new Who.AttendeeStatus();
			Attendee_Type   = new Who.AttendeeType();
		}
	}

	public class Alarm
	{
		public string Action          { get; set; }
		public string Descripton      { get; set; }
		public string AlarmUID        { get; set; }
		public string TriggerDuration { get; set; }
	}

	public class AppointmentEntry
	{
		#region Properties
		private HttpApplicationState Application        = new HttpApplicationState();

		public static string EventStatus_CANCELED  = "event.canceled" ;
		public static string EventStatus_CONFIRMED = "event.confirmed";
		public static string EventStatus_TENTATIVE = "event.tentative";

		public static string Visibility_CONFIDENTIAL= "event.confidential";
		public static string Visibility_DEFAULT     = "event.default"     ;
		public static string Visibility_PRIVATE     = "event.private"     ;
		public static string Visibility_PUBLIC      = "event.public"      ;

		public string RawContent            { get; set; }
		public bool   Deleted               { get; set; }
		public string UID                   { get; set; }
		public string ETag                  { get; set; }
		public string Href                  { get; set; }
		public string Title                 { get; set; }
		public string Content               { get; set; }
		public string TZID                  { get; set; }
		public string RRULE                 { get; set; }
		public DateTime       Created       { get; set; }
		public DateTime       Updated       { get; set; }
		public DateTime       LastModified  { get; set; }
		public string         Status        { get; set; }
		public string         Visibility    { get; set; }
		public List<Where>    Locations     ;
		public List<Who>      Participants  ;
		public List<When>     Times         ;
		public List<Alarm>    Alarms        ;
		#endregion

		public AppointmentEntry()
		{
			Status       = EventStatus_CONFIRMED;
			Visibility   = Visibility_DEFAULT   ;
			Locations    = new List<Where>()    ;
			Participants = new List<Who>()      ;
			Times        = new List<When>()     ;
			Alarms       = new List<Alarm>()    ;
			Times.Add(new When());
		}

		// http://www.imc.org/pdi/
		// http://www.rfc-editor.org/rfc/rfc5545.txt
		public void Parse(HttpContext Context, string sEvent)
		{
			try
			{
				this.RawContent = sEvent;
#if DEBUG
				Debug.WriteLine(sEvent);
#endif
				if ( sEvent.StartsWith("BEGIN:VCALENDAR") )
				{
					// 01/14/2012 Paul.  An appointment created on the iCloud web site may not have a Created or Updated date.  So use now. 
					this.Created = DateTime.Now;
					this.Updated = this.Created;
					// 12/28/2011 Paul.  Attendee data might span lines, but that is painful to parse, so just remove the newline. 
					// 01/05/2012 Paul.  According to the vCalendar spec, CRLF+space can be removed from content lines. RFC 5545 Page 8. 
					sEvent = sEvent.Replace("\r\n ", String.Empty);
					using ( MemoryStream stm = new MemoryStream(System.Text.UTF8Encoding.UTF8.GetBytes(sEvent)) )
					{
						using ( StreamReader rdr = new StreamReader(stm) )
						{
							string sLine = null;
							while ( (sLine = rdr.ReadLine()) != null )
							{
								// 12/14/2011 Paul.  There can be multiple colons in the line, so don't use split. 
								if ( sLine.Contains(":") )
								{
									string[] arrLine = new string[2];
									int nSeparator = sLine.IndexOf(':');
									arrLine[0] = sLine.Substring(0, nSeparator);
									arrLine[1] = sLine.Substring(nSeparator + 1);
									switch ( arrLine[0] )
									{
										case "VERSION":  break;
										case "PRODID" :  break;  // Product ID
										case "BEGIN"  :
										{
											if ( arrLine[1] == "VTIMEZONE" )
											{
												bool bEndSection = false;
												while ( !bEndSection && (sLine = rdr.ReadLine()) != null )
												{
													if ( sLine.Contains(":") )
													{
														arrLine = new string[2];
														nSeparator = sLine.IndexOf(':');
														arrLine[0] = sLine.Substring(0, nSeparator);
														arrLine[1] = sLine.Substring(nSeparator + 1);
														switch ( arrLine[0] )
														{
															case "BEGIN"  :  break;
															case "END"    :
															{
																if ( arrLine[1] == "VTIMEZONE" )
																	bEndSection = true;
																break;
															}
														}
													}
												}
											}
											else if ( arrLine[1] == "VEVENT" )
											{
												bool bEndSection = false;
												while ( !bEndSection && (sLine = rdr.ReadLine()) != null )
												{
													if ( sLine.Contains(":") )
													{
														arrLine = new string[2];
														nSeparator = sLine.IndexOf(':');
														arrLine[0] = sLine.Substring(0, nSeparator);
														arrLine[1] = sLine.Substring(nSeparator + 1);
														switch ( arrLine[0] )
														{
															case "BEGIN"  :
															{
																// 02/11/2012 Paul.  An event can contain one or more alarms. 
																if ( arrLine[1] == "VALARM" )
																{
																	bool bEndAlarm = false;
																	Alarm alarm = new Alarm();
																	this.Alarms.Add(alarm);
																	while ( !bEndAlarm && (sLine = rdr.ReadLine()) != null )
																	{
																		if ( sLine.Contains(":") )
																		{
																			arrLine = new string[2];
																			nSeparator = sLine.IndexOf(':');
																			arrLine[0] = sLine.Substring(0, nSeparator);
																			arrLine[1] = sLine.Substring(nSeparator + 1);
																			switch ( arrLine[0] )
																			{
																				case "BEGIN"  :  break;
																				case "END"    :
																				{
																					if ( arrLine[1] == "VALARM" )
																						bEndAlarm = true;
																					break;
																				}
																				case "ACTION"                :  alarm.Action          = arrLine[1];  break;
																				case "X-WR-ALARMUID"         :  alarm.AlarmUID        = arrLine[1];  break;
																				case "DESCRIPTION"           :  alarm.Descripton      = SplendidCRM.Utils.CalDAV_Unescape(arrLine[1]);  break;
																				case "TRIGGER;VALUE=DURATION":  alarm.TriggerDuration = arrLine[1];  break;
																			}
																		}
																	}
																}
																break;
															}
															case "END"    :
															{
																if ( arrLine[1] == "VEVENT" )
																	bEndSection = true;
																break;
															}
															case "UID"        :  this.UID     = arrLine[1];  break;  // UID
															// 02/11/2012 Paul.  SplendidCRM does not support repeats, so just keep the rule as-is. 
															case "RRULE"      :  this.RRULE   = arrLine[1];  break;  // RRULE
															case "SUMMARY"    :
															{
																this.Title   = SplendidCRM.Utils.CalDAV_Unescape(arrLine[1]);
																break;
															}
															case "DESCRIPTION":  // Description
															{
																this.Content = SplendidCRM.Utils.CalDAV_Unescape(arrLine[1]);
																break;
															}
															case "LOCATION"   :
															{
																Where wLocation = new Where();
																wLocation.ValueString = arrLine[1];
																Locations.Add(wLocation);
																break;
															}
															case "CREATED"    :  // Creation Date  yyyyMMddTHHmmssZ
															{
																// CREATED:20111213T054635Z
																this.Created = SplendidCRM.Utils.CalDAV_ParseDate(arrLine[1]);
																break;
															}
															case "DTSTAMP":  // Revision Date  yyyyMMddTHHmmssZ
															{
																// DTSTAMP:20111213T054648Z
																// 01/15/2012 Paul.  DTStamp seems like the correct Updated time. 
																this.Updated = SplendidCRM.Utils.CalDAV_ParseDate(arrLine[1]);
																break;
															}
															case "LAST-MODIFIED":  // Revision Date  yyyyMMddTHHmmssZ
															{
																// LAST-MODIFIED:20111213T054648Z
																// 01/15/2012 Paul.  LastModified seems to be offset by 4 hours. 
																this.LastModified = SplendidCRM.Utils.CalDAV_ParseDate(arrLine[1]);
																break;
															}
															default:
															{
																if ( arrLine[0].StartsWith("DTSTART") )
																{
																	try
																	{
																		// DTSTART;TZID=America/New_York:20111213T123000
																		int nTZID = arrLine[0].IndexOf("TZID=");
																		if ( nTZID >= 0 )
																			this.TZID = arrLine[0].Substring(nTZID + 5);
																		else
																			this.TZID = String.Empty;
																		// 02/12/2012 Paul.  An All-Day event does not include the time in the date strings. 
																		if ( arrLine[1].Length == 8 )
																		{
																			this.Times[0].StartTime = SplendidCRM.Utils.CalDAV_ParseDate(arrLine[1]);
																			this.Times[0].AllDay    = true;
																		}
																		else if ( arrLine[1].EndsWith("Z") )
																		{
																			this.Times[0].StartTime = SplendidCRM.Utils.CalDAV_ParseDate(arrLine[1]);
																		}
																		else
																		{
																			this.Times[0].StartTime = SplendidCRM.Utils.CalDAV_ParseDate(arrLine[1]);
																			// 03/26/2013 Paul.  iCloud uses linked_timezone values from http://tzinfo.rubyforge.org/doc/. 
																			SplendidCRM.TimeZone oTimeZone = Application["TIMEZONE.TZID." + this.TZID] as SplendidCRM.TimeZone;
																			if ( oTimeZone != null )
																			{
																				this.Times[0].StartTime = oTimeZone.ToServerTime(this.Times[0].StartTime);
																			}
																		}
																	}
																	catch
																	{
																	}
																}
																else if ( arrLine[0].StartsWith("DTEND") )
																{
																	try
																	{
																		// DTEND;TZID=America/New_York:20111213T133000
																		int nTZID = arrLine[0].IndexOf("TZID=");
																		if ( nTZID >= 0 )
																			this.TZID = arrLine[0].Substring(nTZID + 5);
																		else
																			this.TZID = String.Empty;
																		// 02/12/2012 Paul.  An All-Day event does not include the time in the date strings. 
																		if ( arrLine[1].Length == 8 )
																		{
																			this.Times[0].EndTime = SplendidCRM.Utils.CalDAV_ParseDate(arrLine[1]);
																			this.Times[0].AllDay  = true;
																		}
																		else if ( arrLine[1].EndsWith("Z") )
																		{
																			this.Times[0].EndTime = SplendidCRM.Utils.CalDAV_ParseDate(arrLine[1]);
																		}
																		else
																		{
																			this.Times[0].EndTime = SplendidCRM.Utils.CalDAV_ParseDate(arrLine[1]);
																			// 03/26/2013 Paul.  iCloud uses linked_timezone values from http://tzinfo.rubyforge.org/doc/. 
																			SplendidCRM.TimeZone oTimeZone = Application["TIMEZONE.TZID." + this.TZID] as SplendidCRM.TimeZone;
																			if ( oTimeZone != null )
																			{
																				this.Times[0].EndTime = oTimeZone.ToServerTime(this.Times[0].EndTime);
																			}
																		}
																	}
																	catch
																	{
																	}
																}
																else if ( arrLine[0].StartsWith("ORGANIZER") )
																{
																	Who who = new Who();
																	who.Rel = Who.RelType.EVENT_ORGANIZER;
																	who.Prefix = arrLine[0].Substring(9);
																	who.Email  = arrLine[1];
																	string[] arrPrefix = who.Prefix.Split(';');
																	foreach ( string sPrefix in arrPrefix )
																	{
																		if ( sPrefix.Contains("=") )
																		{
																			string[] arrNameValue = sPrefix.Split('=');
																			string sName  = arrNameValue[0];
																			string sValue = arrNameValue[1];
																			if ( sName == "CN" )
																				who.Name = sValue;
																			else if ( sName == "EMAIL" )
																				who.Email = sValue.Replace("\"", String.Empty);
																			else if ( sName == "PARTSTAT" )
																			{
																				switch ( sValue )
																				{
																					case "ACCEPTED" :  who.Attendee_Status.Value = Who.AttendeeStatus.EVENT_ACCEPTED ;  break;
																					case "DECLINED" :  who.Attendee_Status.Value = Who.AttendeeStatus.EVENT_DECLINED ;  break;
																					case "INVITED"  :  who.Attendee_Status.Value = Who.AttendeeStatus.EVENT_INVITED  ;  break;
																					case "TENTATIVE":  who.Attendee_Status.Value = Who.AttendeeStatus.EVENT_TENTATIVE;  break;
																				}
																			}
																		}
																	}
																	if ( arrLine[1].StartsWith("/") )
																		who.ID = arrLine[1];
																	if ( who.Email.StartsWith("mailto:") )
																		who.Email = who.Email.Substring(7);
																	if ( who.Email == "invalid:nomail" )
																		who.Email = String.Empty;
																	Participants.Add(who);
																}
																else if ( arrLine[0].StartsWith("ATTENDEE") && !arrLine[0].Contains("CUTYPE=RESOURCE") )
																{
																	Who who = new Who();
																	who.Rel = Who.RelType.EVENT_ATTENDEE;
																	who.Prefix = arrLine[0].Substring(8);
																	who.Email  = arrLine[1];
																	string[] arrPrefix = who.Prefix.Split(';');
																	foreach ( string sPrefix in arrPrefix )
																	{
																		if ( sPrefix.Contains("=") )
																		{
																			string[] arrNameValue = sPrefix.Split('=');
																			string sName  = arrNameValue[0];
																			string sValue = arrNameValue[1];
																			if ( sName == "CN" )
																				who.Name = sValue;
																			else if ( sName == "EMAIL" )
																				who.Email = sValue.Replace("\"", String.Empty);
																			// 02/12/2012 Paul.  Preserve RSVP and ROLE. 
																			else if ( sName == "RSVP" )
																				who.RSVP = (sValue.ToLower() == "true");
																			else if ( sName == "ROLE" )
																				who.Role = sValue;
																			else if ( sName == "PARTSTAT" )
																			{
																				switch ( sValue )
																				{
																					case "ACCEPTED"    :  who.Attendee_Status.Value = Who.AttendeeStatus.EVENT_ACCEPTED ;  break;
																					case "DECLINED"    :  who.Attendee_Status.Value = Who.AttendeeStatus.EVENT_DECLINED ;  break;
																					case "INVITED"     :  who.Attendee_Status.Value = Who.AttendeeStatus.EVENT_INVITED  ;  break;
																					case "TENTATIVE"   :  who.Attendee_Status.Value = Who.AttendeeStatus.EVENT_TENTATIVE;  break;
																					case "NEEDS-ACTION":  who.Attendee_Status.Value = Who.AttendeeStatus.EVENT_INVITED  ;  break;
																				}
																			}
																		}
																	}
																	if ( arrLine[1].StartsWith("/") )
																		who.ID = arrLine[1];
																	if ( who.Email.StartsWith("mailto:") )
																		who.Email = who.Email.Substring(7);
																	if ( who.Email == "invalid:nomail" )
																		who.Email = String.Empty;
																	Participants.Add(who);
																}
																break;
															}
														}
													}
												}
											}
											break;
										}
										case "END":
										{
											if ( arrLine[1] == "VCALENDAR" )
												rdr.ReadToEnd();
											break;
										}
										default:
										{
											break;
										}
									}
								}
							}
							if ( this.Updated == DateTime.MinValue )
								this.Updated = this.LastModified;
						}
					}
				}
			}
			catch //(Exception ex)
			{
			}
		}

		public string CreateVCalendar(HttpContext Context, string sPrincipalID)
		{
			StringBuilder sbVCalendar = new StringBuilder();
			sbVCalendar.AppendLine("BEGIN:VCALENDAR");
			sbVCalendar.AppendLine("VERSION:2.0");
			sbVCalendar.AppendLine("CALSCALE:GREGORIAN");
			sbVCalendar.AppendLine("PRODID:-//CALENDARSERVER.ORG//NONSGML Version 1//EN");
			// 01/05/2012 Paul.  Lets try not using the timezone data and instead store date in UTC format. 
			/*
			SplendidCRM.TimeZone oTimeZone = Context.Application["TIMEZONE.TZID." + this.TZID] as SplendidCRM.TimeZone;
			if ( oTimeZone == null )
				oTimeZone = Context.Application["TIMEZONE.TZID.America/New_York"] as SplendidCRM.TimeZone;
			if ( oTimeZone == null )
			{
				sbVCalendar.AppendLine("BEGIN:VTIMEZONE");
				sbVCalendar.AppendLine("TZID:"           + oTimeZone.TZID);
				sbVCalendar.AppendLine("TZURL:"          + "http://tzurl.org/zoneinfo-outlook/" + oTimeZone.TZID);
				sbVCalendar.AppendLine("X-LIC-LOCATION:" + oTimeZone.TZID);
				sbVCalendar.AppendLine("BEGIN:DAYLIGHT" );
				sbVCalendar.AppendLine("TZOFFSETFROM:"   + (- oTimeZone.Bias/60).ToString("00") + (oTimeZone.Bias % 60).ToString("00") );
				sbVCalendar.AppendLine("TZOFFSETTO:"     + (-(oTimeZone.Bias + oTimeZone.StandardBias)/60).ToString("00") + (oTimeZone.Bias % 60).ToString("00") );
				sbVCalendar.AppendLine("TZNAME:"         + oTimeZone.DaylightAbbreviation);
				// 01/02/2012 Paul.  Need to figure out how to convert week to 08.  There does not seem to be a clear pattern in the zoneinfo-outlook data. 
				sbVCalendar.AppendLine("DTSTART:"        + "1970" + oTimeZone.DaylightDateMonth.ToString("00") + "08" + "T" + oTimeZone.DaylightDateHour.ToString("00") + oTimeZone.DaylightDateMinute.ToString("00") + "00");
				sbVCalendar.AppendLine("RRULE:"          + "FREQ=YEARLY;BYDAY=" + oTimeZone.DaylightDateWeek.ToString() + "SU;BYMONTH=" + oTimeZone.DaylightDateMonth.ToString());
				sbVCalendar.AppendLine("END:DAYLIGHT"   );
				sbVCalendar.AppendLine("BEGIN:STANDARD" );
				sbVCalendar.AppendLine("TZOFFSETFROM:"   + (- oTimeZone.Bias/60).ToString("00") + (oTimeZone.Bias % 60).ToString("00") );
				sbVCalendar.AppendLine("TZOFFSETTO:"     + (-(oTimeZone.Bias + oTimeZone.StandardBias)/60).ToString("00") + (oTimeZone.Bias % 60).ToString("00") );
				sbVCalendar.AppendLine("TZNAME:"         + oTimeZone.StandardAbbreviation);
				// 01/02/2012 Paul.  Need to figure out how to convert week to 01.  There does not seem to be a clear pattern in the zoneinfo-outlook data. 
				sbVCalendar.AppendLine("DTSTART:"        + "1970" + oTimeZone.StandardDateMonth.ToString("00") + "01" + "T" + oTimeZone.StandardDateHour.ToString("00") + oTimeZone.StandardDateMinute.ToString("00") + "00");
				sbVCalendar.AppendLine("RRULE:"          + "FREQ=YEARLY;BYDAY=" + oTimeZone.StandardDateWeek.ToString() + "SU;BYMONTH=" + oTimeZone.StandardDateMonth.ToString());
				sbVCalendar.AppendLine("END:STANDARD"   );
				sbVCalendar.AppendLine("END:VTIMEZONE"  );
			}
			*/
			if ( this.Created == DateTime.MinValue )
				this.Created = DateTime.Now;
			if ( this.Updated == DateTime.MinValue )
				this.Updated = DateTime.Now;
			
			sbVCalendar.AppendLine("BEGIN:VEVENT");
			sbVCalendar.AppendLine("SEQUENCE:0");
			sbVCalendar.AppendLine("UID:"           + this.UID);
			sbVCalendar.AppendLine("CREATED:"       + this.Created.ToUniversalTime().ToString("yyyyMMddTHHmmssZ"));
			// 01/15/2012 Paul.  Not sure why, but DTSTAMP is not UTC time as it is 4 hours from the LAST-MODIFIED. 
			// DTSTAMP should be placed before LAST-MODIFIED so that LAST-MODIFIED is the last value used. 
			sbVCalendar.AppendLine("DTSTAMP:"       + this.Updated.ToUniversalTime().ToString("yyyyMMddTHHmmssZ"));
			sbVCalendar.AppendLine("LAST-MODIFIED:" + this.Updated.ToUniversalTime().ToString("yyyyMMddTHHmmssZ"));
			// 01/07/2012 Paul.  The folding includes the line header. RFC 5545 Page 9. 
			sbVCalendar.AppendLine(SplendidCRM.Utils.CalDAV_FoldLines("SUMMARY:" + SplendidCRM.Utils.CalDAV_Escape(this.Title)));
			if ( !String.IsNullOrEmpty(this.Content) )
			{
				// 01/05/2012 Paul.  The VCalendar spec requires that we split the line at 75 characters. 
				// We are not going to do that unless iCloud crashes or rejects the data. 
				sbVCalendar.AppendLine(SplendidCRM.Utils.CalDAV_FoldLines("DESCRIPTION:" + SplendidCRM.Utils.CalDAV_Escape(this.Content)));
			}
			if ( this.Locations.Count > 0 )
				sbVCalendar.AppendLine("LOCATION:"  + this.Locations[0].ValueString);
			// 01/05/2012 Paul.  Lets try not using the timezone data and instead store date in UTC format.  RFC 5545 Page 34. 
			//sbVCalendar.AppendLine("DTSTART;TZID=" + this.TZID + ":" + this.Times[0].StartTime.ToString("yyyyMMddTHHmmss"));
			//sbVCalendar.AppendLine("DTEND;TZID="   + this.TZID + ":" + this.Times[0].EndTime  .ToString("yyyyMMddTHHmmss"));
			// 02/12/2012 Paul.  An All-Day event does not include the time in the date strings. 
			TimeSpan ts =this.Times[0].EndTime - this.Times[0].StartTime;
			if ( ts.TotalMinutes == 24 * 60 )
			{
				sbVCalendar.AppendLine("DTSTART:" + this.Times[0].StartTime.ToString("yyyyMMdd"));
				sbVCalendar.AppendLine("DTEND:"   + this.Times[0].EndTime  .ToString("yyyyMMdd"));
			}
			else
			{
				sbVCalendar.AppendLine("DTSTART:" + this.Times[0].StartTime.ToUniversalTime().ToString("yyyyMMddTHHmmss") + "Z");
				sbVCalendar.AppendLine("DTEND:"   + this.Times[0].EndTime  .ToUniversalTime().ToString("yyyyMMddTHHmmss") + "Z");
			}
			// 02/11/2012 Paul.  SplendidCRM does not support repeats, so just keep the rule as-is. 
			// 03/23/2013 Paul.  Recurrences are now supported and we build RRULE. 
			if ( !String.IsNullOrEmpty(this.RRULE) )
			{
				sbVCalendar.AppendLine("RRULE:" + this.RRULE);
			}
			foreach ( Who who in this.Participants )
			{
				StringBuilder sbWho = new StringBuilder();
				if ( who.Rel == Who.RelType.EVENT_ORGANIZER )
					sbWho.Append("ORGANIZER");
				else
					sbWho.Append("ATTENDEE");
				if ( who.Attendee_Status != null && !String.IsNullOrEmpty(who.Attendee_Status.Value) )
				{
					sbWho.Append(";PARTSTAT=");
					switch ( who.Attendee_Status.Value )
					{
						case Who.AttendeeStatus.EVENT_ACCEPTED :  sbWho.Append("ACCEPTED" );  break;
						case Who.AttendeeStatus.EVENT_DECLINED :  sbWho.Append("DECLINED" );  break;
						case Who.AttendeeStatus.EVENT_INVITED  :  sbWho.Append("INVITED"  );  break;
						case Who.AttendeeStatus.EVENT_TENTATIVE:  sbWho.Append("TENTATIVE");  break;
					}
				}
				if ( !String.IsNullOrEmpty(who.Name) )
					sbWho.Append(";CN=" + who.Name);
				// 02/12/2012 Paul.  Preserve RSVP and ROLE. 
				if ( who.RSVP )
					sbWho.Append(";RSVP=TRUE");
				if ( !String.IsNullOrEmpty(who.Role) )
					sbWho.Append(";ROLE=" + who.Role);
				if ( !String.IsNullOrEmpty(who.ID) )
				{
					if ( !String.IsNullOrEmpty(who.Email) )
						sbWho.Append(";EMAIL=\"" + who.Email + "\"");
					sbWho.Append(":" + who.ID);
				}
				else if ( !String.IsNullOrEmpty(who.Email) )
				{
					sbWho.Append(":mailto:" + who.Email);
				}
				// 02/11/2012 Paul.  We are getting a forbidden error when creating an appointment.  Try to fix by including the PrincipalID for the organizer. 
				else if ( who.Rel == Who.RelType.EVENT_ORGANIZER )
				{
					sbWho.Append(":/" + sPrincipalID + "/principal/");
				}
				else
					sbWho.Append(":invalid:nomail");
				sbVCalendar.AppendLine(SplendidCRM.Utils.CalDAV_FoldLines(sbWho.ToString()));
			}
			// 02/11/2012 Paul.  An event can contain one or more alarms. 
			foreach ( Alarm alarm in this.Alarms )
			{
				StringBuilder sbAlarm = new StringBuilder();
				sbAlarm.AppendLine("BEGIN:VALARM");
				sbAlarm.AppendLine("ACTION:" + alarm.Action);
				sbAlarm.AppendLine(SplendidCRM.Utils.CalDAV_FoldLines("DESCRIPTION:" + SplendidCRM.Utils.CalDAV_Escape(alarm.Descripton)));
				sbAlarm.AppendLine("TRIGGER;VALUE=DURATION:" + alarm.TriggerDuration);
				sbAlarm.AppendLine("X-WR-ALARMUID:" + alarm.AlarmUID);
				sbAlarm.AppendLine("END:VALARM");
				sbVCalendar.Append(sbAlarm);
			}
			sbVCalendar.AppendLine("END:VEVENT");

			sbVCalendar.AppendLine("END:VCALENDAR");
			this.RawContent = sbVCalendar.ToString();
#if DEBUG
			Debug.WriteLine(this.RawContent);
#endif
			return this.RawContent;
		}
	}
	#endregion
}

