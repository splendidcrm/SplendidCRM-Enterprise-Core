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
using System.Web;
using System.Data;
using System.Data.Common;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Diagnostics;

using System.Net;
using System.Net.Http;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace SplendidCRM
{
	/// <summary>
	/// Summary description for AuthorizeNetUtils.
	/// </summary>
	public class AuthorizeNetUtils
	{
		#region enum
		public enum bankAccountTypeEnum
		{
			checking,
			savings,
			businessChecking,
		}

		public enum echeckTypeEnum
		{
			PPD,
			WEB,
			CCD,
			TEL,
			ARC,
			BOC,
		}

		public enum customerTypeEnum
		{
			individual,
			business,
		}

		public enum messageTypeEnum
		{
			Ok,
			Error,
		}

		public enum validationModeEnum
		{
			none,
			testMode,
			liveMode,
			oldLiveMode,
		}

		public enum accountTypeEnum
		{
			Visa,
			MasterCard,
			AmericanExpress,
			Discover,
			JCB,
			DinersClub,
			eCheck,
		}

		public enum cardTypeEnum
		{
			Visa,
			MasterCard,
			AmericanExpress,
			Discover,
			JCB,
			DinersClub,
		}

		public enum transactionStatusEnum
		{
			authorizedPendingCapture,
			capturedPendingSettlement,
			communicationError,
			refundSettledSuccessfully,
			refundPendingSettlement,
			approvedReview,
			declined,
			couldNotVoid,
			expired,
			generalError,
			pendingFinalSettlement,
			pendingSettlement,
			failedReview,
			settledSuccessfully,
			settlementError,
			underReview,
			updatingSettlement,
			voided,
			FDSPendingReview,
			FDSAuthorizedPendingReview,
			returnedItem,
			chargeback,
			chargebackReversal,
			authorizedPendingRelease,
		}

		public enum transactionTypeEnum
		{
			authOnlyTransaction,
			authCaptureTransaction,
			captureOnlyTransaction,
			refundTransaction,
			priorAuthCaptureTransaction,
			voidTransaction,
			getDetailsTransaction,
			authOnlyContinueTransaction,
			authCaptureContinueTransaction,
		}
		#endregion

		#region types
		public class merchantAuthenticationType
		{
			public string name;
			public string transactionKey;
		}

		public class messagesTypeMessage
		{
			public string code;
			public string text;
		}

		public class messagesType
		{
			[JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
			public messageTypeEnum resultCode;
			public messagesTypeMessage[] message;
		}

		public class bankAccountType
		{
			[JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
			public bankAccountTypeEnum accountType  ;
			public string              routingNumber;
			public string              accountNumber;
			public string              nameOnAccount;
			[JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
			public echeckTypeEnum      echeckType   ;
			public string              bankName     ;
			public string              checkNumber  ;
		}

		public class creditCardSimpleType
		{
			[JsonProperty(Order = -3)] public string cardNumber    ;
			[JsonProperty(Order = -2)] public string expirationDate;
		}

		public class creditCardType : creditCardSimpleType
		{
			public string cardCode      ;
			public bool   isPaymentToken;
			public string cryptogram    ;
		}

		public class customerProfileBaseType
		{
			[JsonProperty(Order = -4)] public string merchantCustomerId;
			[JsonProperty(Order = -3)] public string description       ;
			[JsonProperty(Order = -2)] public string email             ;
		}

		public class nameAndAddressType
		{
			[JsonProperty(Order = -9)] public string firstName;
			[JsonProperty(Order = -8)] public string lastName ;
			[JsonProperty(Order = -7)] public string company  ;
			[JsonProperty(Order = -6)] public string address  ;
			[JsonProperty(Order = -5)] public string city     ;
			[JsonProperty(Order = -4)] public string state    ;
			[JsonProperty(Order = -3)] public string zip      ;
			[JsonProperty(Order = -2)] public string country  ;
		}

		public class customerAddressType : nameAndAddressType 
		{
			public string phoneNumber;
			public string faxNumber  ;
			public string email      ;
		}

		public class customerPaymentProfileBaseType
		{
			[JsonProperty(Order = -3)]
			[JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
			public customerTypeEnum    customerType;
			
			[JsonProperty(Order = -2)]
			public customerAddressType billTo      ;
		}

		public class driversLicenseType
		{
			public string number     ;
			public string state      ;
			public string dateOfBirth;
		}

		public class customerPaymentProfileType : customerPaymentProfileBaseType
		{
			public paymentType        payment;
			[JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
			public driversLicenseType driversLicense;
			public string             taxId;
		}

		public class customerPaymentProfileExType : customerPaymentProfileType
		{
			[JsonProperty(Order = 4)] public string customerPaymentProfileId;
		}

		public class customerProfileType : customerProfileBaseType
		{
			public customerPaymentProfileType[] paymentProfiles;
			public customerAddressType[]        shipToList     ;
		}

		public class customerProfileExType : customerProfileBaseType
		{
			public string customerProfileId;
		}

		public class paymentProfile
		{
			public string paymentProfileId;
			public string cardCode        ;
		}

		public class customerProfilePaymentType
		{
			public bool           createProfile    ;
			public string         customerProfileId;
			public paymentProfile paymentProfile   ;
			public string         shippingProfileId;
		}

		public class solutionType
		{
			public string id        ;
			public string name      ;
			public string vendorName;
		}

		public class orderType
		{
			public string invoiceNumber;
			public string description  ;
		}

		public class lineItemType
		{
			public string  itemId     ;
			public string  name       ;
			public string  description;
			public decimal quantity   ;
			public decimal unitPrice  ;
			public bool    taxable    ;
		}

		public class extendedAmountType
		{
			public decimal amount     ;
			public string  name       ;
			public string  description;
		}

		public class customerDataType
		{
			[JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
			public customerTypeEnum   type          ;
			public string             id            ;
			public string             email         ;
			[JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
			public driversLicenseType driversLicense;
			public string             taxId         ;
		}

		public class ccAuthenticationType
		{
			public string authenticationIndicator      ;
			public string cardholderAuthenticationValue;
		}

		public class transRetailInfoType
		{
			public string marketType;
			public string deviceType;

			public transRetailInfoType()
			{
				this.marketType = "2";
			}
		}

		public class settingType
		{
			public string settingName ;
			public string settingValue;
		}

		public class userField
		{
			public string name ;
			public string value;
		}

		public class paymentType
		{
			//[System.Xml.Serialization.XmlElementAttribute("bankAccount", typeof(bankAccountType))]
			//[System.Xml.Serialization.XmlElementAttribute("creditCard", typeof(creditCardType))]
			//[System.Xml.Serialization.XmlElementAttribute("encryptedTrackData", typeof(encryptedTrackDataType))]
			//[System.Xml.Serialization.XmlElementAttribute("opaqueData", typeof(opaqueDataType))]
			//[System.Xml.Serialization.XmlElementAttribute("payPal", typeof(payPalType))]
			//[System.Xml.Serialization.XmlElementAttribute("trackData", typeof(creditCardTrackType))]
			public bankAccountType bankAccount;
			public creditCardType  creditCard ;
		}

		public class transactionRequestType
		{
			public string                     transactionType         ;
			public decimal                    amount                  ;
			public string                     currencyCode            ;
			public paymentType                payment                 ;
			public customerProfilePaymentType profile                 ;
			public solutionType               solution                ;
			public string                     callId                  ;
			public string                     authCode                ;
			public string                     refTransId              ;
			public string                     splitTenderId           ;
			public orderType                  order                   ;
			public object[]                   lineItems               ;
			public extendedAmountType         tax                     ;
			public extendedAmountType         duty                    ;
			public extendedAmountType         shipping                ;
			public bool                       taxExempt               ;
			public string                     poNumber                ;
			public customerDataType           customer                ;
			public customerAddressType        billTo                  ;
			public nameAndAddressType         shipTo                  ;
			public string                     customerIP              ;
			public ccAuthenticationType       cardholderAuthentication;
			public transRetailInfoType        retail                  ;
			public string                     employeeId              ;
			public settingType[]              transactionSettings     ;
			public userField[]                userFields              ;
		}

		public class transactionResponsePrePaidCard
		{
			public string requestedAmount;
			public string approvedAmount ;
			public string balanceOnCard  ;
		}

		public class transactionResponseMessage
		{
			public string code       ;
			public string description;
		}

		public class transactionResponseError
		{
			public string errorCode;
			public string errorText;
		}

		public class transactionResponseSplitTenderPayment
		{
			public string transId           ;
			public string responseCode      ;
			public string responseToCustomer;
			public string authCode          ;
			public string accountNumber     ;
			public string accountType       ;
			public string requestedAmount   ;
			public string approvedAmount    ;
			public string balanceOnCard     ;
		}

		public class transactionResponseSecureAcceptance
		{
			public string SecureAcceptanceUrl;
			public string PayerID            ;
		}

		public class transactionResponse
		{
			public string responseCode   ;
			public string rawResponseCode;
			public string authCode       ;
			public string avsResultCode  ;
			public string cvvResultCode  ;
			public string cavvResultCode ;
			public string transId        ;
			public string refTransID     ;
			public string transHash      ;
			public string testRequest    ;
			public string accountNumber  ;
			public string accountType    ;
			public string splitTenderId ;
			public transactionResponsePrePaidCard          prePaidCard        ;
			public transactionResponseMessage[]            messages           ;
			public transactionResponseError[]              errors             ;
			public transactionResponseSplitTenderPayment[] splitTenderPayments;
			public userField[]                             userFields         ;
			public nameAndAddressType                      shipTo             ;
			public transactionResponseSecureAcceptance     secureAcceptance   ;
		}

		public class createProfileResponse
		{
			public messagesType messages                     ;
			public string       customerProfileId            ;
			public string[]     customerPaymentProfileIdList ;
			public string[]     customerShippingAddressIdList;
		}

		public class batchStatisticType
		{
			public string  accountType              ;
			public decimal chargeAmount             ;
			public int     chargeCount              ;
			public decimal refundAmount             ;
			public int     refundCount              ;
			public int     voidCount                ;
			public int     declineCount             ;
			public int     errorCount               ;
			public decimal returnedItemAmount       ;
			public int     returnedItemCount        ;
			public decimal chargebackAmount         ;
			public int     chargebackCount          ;
			public int     correctionNoticeCount    ;
			public decimal chargeChargeBackAmount   ;
			public int     chargeChargeBackCount    ;
			public decimal refundChargeBackAmount   ;
			public int     refundChargeBackCount    ;
			public decimal chargeReturnedItemsAmount;
			public int     chargeReturnedItemsCount ;
			public decimal refundReturnedItemsAmount;
			public int     refundReturnedItemsCount ;
		}

		public class batchDetailsType
		{
			public string   batchId            ;
			public DateTime settlementTimeUTC  ;
			public DateTime settlementTimeLocal;
			public string   settlementState    ;
			public string   paymentMethod      ;
			public string   marketType         ;
			public string   product            ;
			//[System.Xml.Serialization.XmlArrayItemAttribute("statistic", IsNullable=false)]
			public batchStatisticType[] statistics;
		}

		public class subscriptionPaymentType
		{
			public int id    ;
			public int payNum;
		}

		public class transactionSummaryType
		{
			public string                  transId          ;
			public DateTime                submitTimeUTC    ;
			public DateTime                submitTimeLocal  ;
			public string                  transactionStatus;
			public string                  invoiceNumber    ;
			public string                  firstName        ;
			public string                  lastName         ;
			public string                  accountType      ;
			public string                  accountNumber    ;
			public decimal                 settleAmount     ;
			public string                  marketType       ;
			public string                  product          ;
			public string                  mobileDeviceId   ;
			public subscriptionPaymentType subscription     ;
			public bool                   hasReturnedItems  ;
		}

		public class orderExType : orderType
		{
			public string purchaseOrderNumber;
		}

		public class cardArt
		{
			public string cardBrand      ;
			public string cardImageHeight;
			public string cardImageUrl   ;
			public string cardImageWidth ;
			public string cardType       ;
		}

		public class creditCardMaskedType
		{
			public string  cardNumber    ;
			public string  expirationDate;
			public string  cardType      ;
			public cardArt cardArt       ;
		}

		public class bankAccountMaskedType
		{
			public bankAccountTypeEnum accountType  ;
			public string              routingNumber;
			public string              accountNumber;
			public string              nameOnAccount;
			public echeckTypeEnum      echeckType   ;
			public string              bankName     ;
		}

		public class tokenMaskedType
		{
			public string tokenSource   ;
			public string tokenNumber   ;
			public string expirationDate;
		}

		public class paymentMaskedType
		{
			//[System.Xml.Serialization.XmlElementAttribute("bankAccount", typeof(bankAccountMaskedType))]
			//[System.Xml.Serialization.XmlElementAttribute("creditCard", typeof(creditCardMaskedType))]
			//[System.Xml.Serialization.XmlElementAttribute("tokenInformation", typeof(tokenMaskedType))]
			public creditCardMaskedType  creditCard ;
			public bankAccountMaskedType bankAccount;
			public tokenMaskedType       token      ;
		}

		public class returnedItemType
		{
			public string   id         ;
			public DateTime dateUTC    ;
			public DateTime dateLocal  ;
			public string   code       ;
			public string   description;
		}

		public class FDSFilterType
		{
			public string name  ;
			public string action;
		}

		public class transactionDetailsType
		{
			public string                  transId                  ;
			public string                  refTransId               ;
			public string                  splitTenderId            ;
			public DateTime                submitTimeUTC            ;
			public DateTime                submitTimeLocal          ;
			public string                  transactionType          ;
			public string                  transactionStatus        ;
			public int                     responseCode             ;
			public int                     responseReasonCode       ;
			public subscriptionPaymentType subscription             ;
			public string                  responseReasonDescription;
			public string                  authCode                 ;
			public string                  AVSResponse              ;
			public string                  cardCodeResponse         ;
			public string                  CAVVResponse             ;
			public string                  FDSFilterAction          ;
			//[System.Xml.Serialization.XmlArrayItemAttribute("FDSFilter", IsNullable=false)]
			public FDSFilterType[]         FDSFilters               ;
			public batchDetailsType        batch                    ;
			public orderExType             order                    ;
			public decimal                 requestedAmount          ;
			public decimal                 authAmount               ;
			public decimal                 settleAmount             ;
			public extendedAmountType      tax                      ;
			public extendedAmountType      shipping                 ;
			public extendedAmountType      duty                     ;
			//[System.Xml.Serialization.XmlArrayItemAttribute("lineItem", IsNullable=false)]
			public lineItemType[]          lineItems                ;
			public decimal                 prepaidBalanceRemaining  ;
			public bool                    taxExempt                ;
			public paymentMaskedType       payment                  ;
			public customerDataType        customer                 ;
			public customerAddressType     billTo                   ;
			public nameAndAddressType      shipTo                   ;
			public bool                    recurringBilling         ;
			public string                  customerIP               ;
			public string                  product                  ;
			public string                  marketType               ;
			public string                  mobileDeviceId           ;
			//[System.Xml.Serialization.XmlArrayItemAttribute("returnedItem", IsNullable=false)]
			public returnedItemType[]      returnedItems            ;
			public solutionType            solution                 ;
		}

		public class customerAddressExType : customerAddressType
		{
			public string customerAddressId;
		}

		public class driversLicenseMaskedType
		{
			public string number     ;
			public string state      ;
			public string dateOfBirth;
		}

		public class customerPaymentProfileMaskedType : customerPaymentProfileBaseType
		{
			public string                   customerProfileId       ;
			public string                   customerPaymentProfileId;
			public paymentMaskedType        payment                 ;
			public driversLicenseMaskedType driversLicense          ;
			public string                   taxId                   ;
		}

		public class customerProfileMaskedType : customerProfileExType
		{
			public customerPaymentProfileMaskedType[] paymentProfiles;

			public customerAddressExType[] shipToList;
		}

		#endregion

		#region Request/Response
		public class ANetApiRequest
		{
			[JsonProperty(Order = -2)]
			public merchantAuthenticationType merchantAuthentication;
		}

		public class ANetApiResponse
		{
			public string       refId       ;
			public messagesType messages    ;
			public string       sessionToken;
		}

		public class authenticateTestRequest : ANetApiRequest
		{
		}

		public class authenticateTestResponse : ANetApiResponse
		{
		}

		public class createCustomerProfileRequest : ANetApiRequest
		{
			public customerProfileType profile;
			[JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
			public validationModeEnum validationMode;
		}

		public class createCustomerProfileResponse : ANetApiResponse
		{
			public string customerProfileId;
			public string[] customerPaymentProfileIdList;
			public string[] customerShippingAddressIdList;
			public string[] validationDirectResponseList;
		}

		public class updateCustomerProfileRequest : ANetApiRequest
		{
			public customerProfileExType profile;
		}

		public class updateCustomerProfileResponse : ANetApiResponse
		{
		}

		public class deleteCustomerProfileRequest : ANetApiRequest
		{
			public string customerProfileId;
		}

		public class deleteCustomerProfileResponse : ANetApiResponse 
		{
		}

		public class updateCustomerPaymentProfileRequest : ANetApiRequest
		{
			public string customerProfileId;
			public customerPaymentProfileExType paymentProfile;
			[JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
			public validationModeEnum validationMode;
		}

		public class updateCustomerPaymentProfileResponse : ANetApiResponse
		{
			public string validationDirectResponse;
		}

		public class createTransactionRequest : ANetApiRequest
		{
			public transactionRequestType transactionRequest;
		}

		public class createTransactionResponse : ANetApiResponse
		{
			public transactionResponse   transactionResponse;
			public createProfileResponse profileResponse    ;
		}

		public class getSettledBatchListRequest : ANetApiRequest
		{
			public bool     includeStatistics  ;
			public string   firstSettlementDate;
			public string   lastSettlementDate ;
		}

		public class getSettledBatchListResponse : ANetApiResponse
		{
			// [System.Xml.Serialization.XmlArrayItemAttribute("batch", IsNullable=false)]
			public batchDetailsType[] batchList;
		}

		public class getUnsettledTransactionListRequest : ANetApiRequest
		{
		}

		public class getUnsettledTransactionListResponse : ANetApiResponse
		{
			//[System.Xml.Serialization.XmlArrayItemAttribute("transaction", IsNullable=false)]
			public transactionSummaryType[] transactions;
		}

		public class getTransactionListRequest : ANetApiRequest
		{
			public string batchId;
		}

		public class getTransactionListResponse : ANetApiResponse
		{
			// [System.Xml.Serialization.XmlArrayItemAttribute("transaction", IsNullable=false)]
			public transactionSummaryType[] transactions;
		}

		public class getTransactionDetailsRequest : ANetApiRequest
		{
			public string transId;
		}

		public class getTransactionDetailsResponse : ANetApiResponse
		{
			public transactionDetailsType transaction;
		}

		public class getCustomerProfileIdsRequest : ANetApiRequest
		{
		}

		public class getCustomerProfileIdsResponse : ANetApiResponse
		{
			public string[] ids;
		}

		public class getCustomerProfileRequest : ANetApiRequest
		{
			public string customerProfileId;
		}

		public class getCustomerProfileResponse : ANetApiResponse
		{
			public customerProfileMaskedType profile;
		}

		#endregion

		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;

		public AuthorizeNetUtils(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
		}

		// https://www.authorize.net/support/CNP/helpfiles/Tools/Customer_Information_Manager/Customer_Profile_Fields.htm
		private string CleanseData(string sValue)
		{
			sValue = sValue.Replace("|", String.Empty);
			sValue = sValue.Replace("~", String.Empty);
			sValue = sValue.Replace("+", String.Empty);
			sValue = sValue.Replace("=", String.Empty);
			return sValue;
		}

		private void StandardThrowError(ANetApiResponse result, string sResult)
		{
			if ( result.messages != null )
			{
				if ( result.messages.resultCode == messageTypeEnum.Error )
				{
					if ( result.messages.message != null )
					{
						StringBuilder sb = new StringBuilder();
						foreach ( messagesTypeMessage msg in result.messages.message )
						{
							sb.AppendLine(msg.text);
						}
						throw(new Exception(sb.ToString()));
					}
					else
					{
						throw(new Exception("Unknown error"));
					}
				}
				else if ( result.messages.resultCode != messageTypeEnum.Ok )
				{
					throw(new Exception("Unexpected results: " + sResult));
				}
				else
				{
				}
			}
			else
			{
				throw(new Exception("Unexpected results: " + sResult));
			}
		}

		private string CleanseData(string sValue, int nMaxLength)
		{
			return Sql.MaxLength(CleanseData(sValue), nMaxLength);
		}

		public string ValidateLogin(string sUserName, string sTransactionKey, bool bTestMode)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			sTransactionKey = Security.DecryptPassword(sTransactionKey, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			string sAuthorizeNetEndpoint = (bTestMode ? "https://apitest.authorize.net/xml/v1/request.api" : "https://api.authorize.net/xml/v1/request.api");
			
			// https://developer.authorize.net/api/reference/index.html
			string sSTATUS = String.Empty;
			try
			{
				using ( HttpClient client = new HttpClient() )
				{
					object request = new
					{ authenticateTestRequest = new authenticateTestRequest
						{ merchantAuthentication = new merchantAuthenticationType
							{ name           = sUserName
							, transactionKey = sTransactionKey
							}
						}
					};
					var param = JsonConvert.SerializeObject(request, Formatting.Indented, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore } );
					HttpContent content = new StringContent(param, Encoding.UTF8, "application/json");
					
					HttpResponseMessage response = client.PostAsync(sAuthorizeNetEndpoint, content).Result;
					if ( response.IsSuccessStatusCode )
					{
						string sResult = response.Content.ReadAsStringAsync().Result;
						// http://www.webthingsconsidered.com/2013/08/09/adventures-in-json-parsing-with-c/
						authenticateTestResponse result = JsonConvert.DeserializeObject<authenticateTestResponse>(sResult);
						if ( result.messages != null )
						{
							if ( result.messages.resultCode == messageTypeEnum.Error )
							{
								if ( result.messages.message != null )
								{
									foreach ( messagesTypeMessage msg in result.messages.message )
									{
										string text = msg.text;
										sSTATUS += text;
									}
								}
								else
									sSTATUS = "Unknown error";
							}
							else if ( result.messages.resultCode != messageTypeEnum.Ok )
							{
								sSTATUS = "Unexpected resultCode: " + sResult;
							}
						}
					}
					else
					{
						sSTATUS = response.Content.ReadAsStringAsync().Result;
					}
				}
			}
			catch(Exception ex)
			{
				sSTATUS = ex.Message;
			}
			return sSTATUS;
		}

		public void UpdateCustomerProfile(ref string sCARD_TOKEN, string sNAME, string sCREDIT_CARD_NUMBER, string sSECURITY_CODE, string sBANK_NAME, string sBANK_ROUTING_NUMBER, DateTime dtEXPIRATION_DATE, string sADDRESS_STREET, string sADDRESS_CITY, string sADDRESS_STATE, string sADDRESS_POSTALCODE, string sADDRESS_COUNTRY, string sEMAIL, string sPHONE)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			
			// https://developer.authorize.net/api/reference/index.html#customer-profiles
			// http://developer.authorize.net/api/reference/features/customer_profiles.html

			Dictionary<string, string> dictParams = new Dictionary<string, string>();
			string sUserName       = Sql.ToString (Application["CONFIG.AuthorizeNet.UserName"      ]);
			string sTransactionKey = Sql.ToString (Application["CONFIG.AuthorizeNet.TransactionKey"]);
			bool   bTestMode       = Sql.ToBoolean(Application["CONFIG.AuthorizeNet.TestMode"      ]);
			sTransactionKey = Security.DecryptPassword(sTransactionKey, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			string sAuthorizeNetEndpoint = (bTestMode ? "https://apitest.authorize.net/xml/v1/request.api" : "https://api.authorize.net/xml/v1/request.api");

			using ( HttpClient client = new HttpClient() )
			{
				creditCardType creditCard = new creditCardType
					{ cardNumber     = sCREDIT_CARD_NUMBER
					, expirationDate = dtEXPIRATION_DATE.ToString("yyyy-MM")
					, cardCode       = sSECURITY_CODE
					};

				bankAccountType bankAccount = new bankAccountType
					{ nameOnAccount  = sNAME
					, accountNumber  = sCREDIT_CARD_NUMBER
					, accountType    = bankAccountTypeEnum.checking
					, bankName       = sBANK_NAME
					, routingNumber  = sBANK_ROUTING_NUMBER
					, echeckType     = echeckTypeEnum.WEB
					};

				customerAddressType address = new customerAddressType
					{ address     = CleanseData(sADDRESS_STREET    , 60)
					, city        = CleanseData(sADDRESS_CITY      , 40)
					, state       = CleanseData(sADDRESS_STATE     , 40)
					, zip         = CleanseData(sADDRESS_POSTALCODE, 20)
					, country     = CleanseData(sADDRESS_COUNTRY   , 60)
					, phoneNumber = CleanseData(sPHONE             , 25)
					, email       = CleanseData(sEMAIL             , 255)
					};
				string[] arrNAME = sNAME.Split(' ');
				if ( arrNAME.Length >= 2 )
				{
					address.firstName = CleanseData(arrNAME[0], 50);
					address.lastName  = CleanseData(arrNAME[arrNAME.Length - 1], 50);
				}
				else
				{
					address.company = CleanseData(arrNAME[0], 50);
				}

				customerProfileType profile;
				if ( !Sql.IsEmptyString(sBANK_ROUTING_NUMBER) )
				{
					profile = new customerProfileType
					{
						paymentProfiles = new customerPaymentProfileType[]
						{
							new customerPaymentProfileType
							{
								customerType = customerTypeEnum.individual,
								payment      = new paymentType { bankAccount = bankAccount },
								billTo       = address,
							}
						}
						, email = CleanseData(sEMAIL, 255)
					};
				}
				else
				{
					profile = new customerProfileType
					{
						paymentProfiles = new customerPaymentProfileType[]
						{
							new customerPaymentProfileType
							{
								customerType = customerTypeEnum.individual,
								payment      = new paymentType { creditCard = creditCard },
								billTo       = address,
							}
						}
						, email = CleanseData(sEMAIL, 255)
					};
				}
				
				if ( !Sql.IsEmptyString(sCARD_TOKEN) )
				{
					string[] arrCARD_TOKEN = sCARD_TOKEN.Split(',');
					
					updateCustomerPaymentProfileRequest customerPaymentProfile = new updateCustomerPaymentProfileRequest
						{ merchantAuthentication = new merchantAuthenticationType
							{ name           = sUserName
							, transactionKey = sTransactionKey
							}
						, customerProfileId = arrCARD_TOKEN[0]
						, paymentProfile = new customerPaymentProfileExType
							{ customerPaymentProfileId = arrCARD_TOKEN[1]
							, billTo  = address
							, payment = new paymentType()
							}
						, validationMode = (bTestMode ? validationModeEnum.testMode : validationModeEnum.testMode)
						};
					// 12/16/2015 Paul.  updateCustomerProfileRequest does not allow updating of 
					if ( !Sql.IsEmptyString(sBANK_ROUTING_NUMBER) )
						customerPaymentProfile.paymentProfile.payment.bankAccount = bankAccount;
					else
						customerPaymentProfile.paymentProfile.payment.creditCard = creditCard;

					object request = new { updateCustomerPaymentProfileRequest = customerPaymentProfile } ;
					string param = Newtonsoft.Json.JsonConvert.SerializeObject(request, Formatting.Indented, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore } );
					HttpContent content = new StringContent(param, Encoding.UTF8, "application/json");
					HttpResponseMessage response = client.PostAsync(sAuthorizeNetEndpoint, content).Result;
					if ( response.IsSuccessStatusCode )
					{
						string sResult = response.Content.ReadAsStringAsync().Result;
						// http://www.webthingsconsidered.com/2013/08/09/adventures-in-json-parsing-with-c/
						updateCustomerPaymentProfileResponse result = JsonConvert.DeserializeObject<updateCustomerPaymentProfileResponse>(sResult);
						if ( result.messages != null )
						{
							if ( result.messages.resultCode == messageTypeEnum.Error )
							{
								if ( result.messages.message != null )
								{
									string sSTATUS = String.Empty;
									foreach ( messagesTypeMessage msg in result.messages.message )
									{
										string text = msg.text;
										sSTATUS += text;
									}
									throw(new Exception(sSTATUS));
								}
								else
									throw(new Exception("Unknown error"));
							}
							else if ( result.messages.resultCode != messageTypeEnum.Ok )
							{
								throw(new Exception("Unexpected resultCode: " + sResult));
							}
						}
					}
					else
					{
						throw(new Exception(response.Content.ReadAsStringAsync().Result));
					}
				}
				else
				{
					// merchantCustomerId, description or email must be defined. 
					profile.description = Guid.NewGuid().ToString();

					object request = new
					{ createCustomerProfileRequest = new createCustomerProfileRequest
						{ merchantAuthentication = new merchantAuthenticationType
							{ name           = sUserName
							, transactionKey = sTransactionKey
							}
						, profile = profile
						, validationMode = (bTestMode ? validationModeEnum.testMode : validationModeEnum.testMode)
						}
					};
					string param = Newtonsoft.Json.JsonConvert.SerializeObject(request, Formatting.Indented, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore } );
					HttpContent content = new StringContent(param, Encoding.UTF8, "application/json");
					HttpResponseMessage response = client.PostAsync(sAuthorizeNetEndpoint, content).Result;
					if ( response.IsSuccessStatusCode )
					{
						string sResult = response.Content.ReadAsStringAsync().Result;
						// http://www.webthingsconsidered.com/2013/08/09/adventures-in-json-parsing-with-c/
						createCustomerProfileResponse result = JsonConvert.DeserializeObject<createCustomerProfileResponse>(sResult);
						if ( result.messages != null )
						{
							if ( result.messages.resultCode == messageTypeEnum.Error )
							{
								if ( result.messages.message != null )
								{
									string sSTATUS = String.Empty;
									foreach ( messagesTypeMessage msg in result.messages.message )
									{
										string text = msg.text;
										sSTATUS += text;
									}
									throw(new Exception(sSTATUS));
								}
								else
									throw(new Exception("Unknown error"));
							}
							else if ( result.messages.resultCode == messageTypeEnum.Ok )
							{
								if ( Sql.IsEmptyString(sCARD_TOKEN) )
								{
									sCARD_TOKEN = result.customerProfileId + "," + result.customerPaymentProfileIdList[0];
								}
							}
							else
							{
								throw(new Exception("Unexpected resultCode: " + sResult));
							}
						}
					}
					else
					{
						throw(new Exception(response.Content.ReadAsStringAsync().Result));
					}
				}
			}
		}

		public string Charge(Guid gCURRENCY_ID, Guid gINVOICE_ID, Guid gPAYMENT_ID, Guid gCREDIT_CARD_ID, string sClientIP, string sDESCRIPTION)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			
			// https://developer.authorize.net/api/reference/index.html#customer-profiles
			// http://developer.authorize.net/api/reference/features/customer_profiles.html

			Dictionary<string, string> dictParams = new Dictionary<string, string>();
			string sUserName       = Sql.ToString (Application["CONFIG.AuthorizeNet.UserName"      ]);
			string sTransactionKey = Sql.ToString (Application["CONFIG.AuthorizeNet.TransactionKey"]);
			bool   bTestMode       = Sql.ToBoolean(Application["CONFIG.AuthorizeNet.TestMode"      ]);
			sTransactionKey = Security.DecryptPassword(sTransactionKey, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			string sAuthorizeNetEndpoint = (bTestMode ? "https://apitest.authorize.net/xml/v1/request.api" : "https://api.authorize.net/xml/v1/request.api");

			string   sSTATUS       = "Prevalidation";
			string   sCARD_TOKEN   = String.Empty;
			string[] arrCARD_TOKEN = new string[2];
			Guid     gACCOUNT_ID   = Guid.Empty;
			Decimal  dAMOUNT       = Decimal.Zero;
			string   sINVOICE_NUM  = String.Empty;
			createTransactionRequest create = new createTransactionRequest
				{ merchantAuthentication = new merchantAuthenticationType
					{ name           = sUserName
					, transactionKey = sTransactionKey
					}
				, transactionRequest = new transactionRequestType
					{ transactionType = "authCaptureTransaction"
					, customerIP      = sClientIP
					}
				};

			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL = String.Empty;
				sSQL = "select *                  " + ControlChars.CrLf
				     + "  from vwCREDIT_CARDS_Edit" + ControlChars.CrLf
				     + " where ID = @ID           " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gCREDIT_CARD_ID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							sCARD_TOKEN = Sql.ToString(rdr["CARD_NUMBER"]);
							if ( Sql.ToBoolean(rdr["IS_ENCRYPTED"]) )
							{
								sCARD_TOKEN = Security.DecryptPassword(sCARD_TOKEN, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
							}
							arrCARD_TOKEN = sCARD_TOKEN.Split(',');
							create.transactionRequest.profile = new customerProfilePaymentType
								{ customerProfileId = arrCARD_TOKEN[0]
								, paymentProfile    = new paymentProfile { paymentProfileId = arrCARD_TOKEN[1] }
								};
						}
					}
				}

				// https://www.authorize.net/support/CNP/helpfiles/Tools/Customer_Information_Manager/Customer_Profile_Fields.htm
				sSQL = "select *         " + ControlChars.CrLf
				     + "  from vwINVOICES" + ControlChars.CrLf
				     + " where ID = @ID  " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gINVOICE_ID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							gACCOUNT_ID                         = Sql.ToGuid  (rdr["BILLING_ACCOUNT_ID"         ]);
							if ( Sql.IsEmptyGuid(gACCOUNT_ID) )
								gACCOUNT_ID = Sql.ToGuid(rdr["BILLING_CONTACT_ID"]);
							sINVOICE_NUM                        = Sql.ToString(rdr["INVOICE_NUM"                ]);
							string sPURCHASE_ORDER_NUM          = Sql.ToString(rdr["PURCHASE_ORDER_NUM"         ]);
							string sBILLING_ACCOUNT_NAME        = Sql.ToString(rdr["BILLING_ACCOUNT_NAME"       ]);
							string sBILLING_CONTACT_NAME        = Sql.ToString(rdr["BILLING_CONTACT_NAME"       ]);
							string sBILLING_ADDRESS_STREET      = Sql.ToString(rdr["BILLING_ADDRESS_STREET"     ]);
							string sBILLING_ADDRESS_CITY        = Sql.ToString(rdr["BILLING_ADDRESS_CITY"       ]);
							string sBILLING_ADDRESS_STATE       = Sql.ToString(rdr["BILLING_ADDRESS_STATE"      ]);
							string sBILLING_ADDRESS_POSTALCODE  = Sql.ToString(rdr["BILLING_ADDRESS_POSTALCODE" ]);
							string sBILLING_ADDRESS_COUNTRY     = Sql.ToString(rdr["BILLING_ADDRESS_COUNTRY"    ]);
							string sSHIPPING_ACCOUNT_NAME       = Sql.ToString(rdr["SHIPPING_ACCOUNT_NAME"      ]);
							string sSHIPPING_CONTACT_NAME       = Sql.ToString(rdr["SHIPPING_CONTACT_NAME"      ]);
							string sSHIPPING_ADDRESS_STREET     = Sql.ToString(rdr["SHIPPING_ADDRESS_STREET"    ]);
							string sSHIPPING_ADDRESS_CITY       = Sql.ToString(rdr["SHIPPING_ADDRESS_CITY"      ]);
							string sSHIPPING_ADDRESS_STATE      = Sql.ToString(rdr["SHIPPING_ADDRESS_STATE"     ]);
							string sSHIPPING_ADDRESS_POSTALCODE = Sql.ToString(rdr["SHIPPING_ADDRESS_POSTALCODE"]);
							string sSHIPPING_ADDRESS_COUNTRY    = Sql.ToString(rdr["SHIPPING_ADDRESS_COUNTRY"   ]);

							dAMOUNT = Sql.ToDecimal(rdr["TOTAL_USDOLLAR"]);
							create.transactionRequest.amount   = dAMOUNT;
							create.transactionRequest.order    = new orderType          { invoiceNumber = CleanseData(sINVOICE_NUM, 20) };
							create.transactionRequest.tax      = new extendedAmountType { amount        = Sql.ToDecimal(rdr["TAX_USDOLLAR"     ]) };
							create.transactionRequest.shipping = new extendedAmountType { amount        = Sql.ToDecimal(rdr["SHIPPING_USDOLLAR"]) };
							create.transactionRequest.poNumber = CleanseData(sPURCHASE_ORDER_NUM, 25);
							create.transactionRequest.customer = new customerDataType { id = gACCOUNT_ID.ToString().Replace("-", "").Substring(0, 20) };
							// 12/15/2016 Paul.  PaymentProfile cannot be sent with billing data. 
							/*
							if ( !Sql.IsEmptyString(sBILLING_ADDRESS_STREET) || !Sql.IsEmptyString(sBILLING_ADDRESS_CITY) || !Sql.IsEmptyString(sBILLING_ADDRESS_STATE) || !Sql.IsEmptyString(sBILLING_ADDRESS_POSTALCODE) )
							{
								create.transactionRequest.billTo = new customerAddressType
									{ company = CleanseData(sBILLING_ACCOUNT_NAME      , 50)
									, address = CleanseData(sBILLING_ADDRESS_STREET    , 60)
									, city    = CleanseData(sBILLING_ADDRESS_CITY      , 40)
									, state   = CleanseData(sBILLING_ADDRESS_STATE     , 40)
									, zip     = CleanseData(sBILLING_ADDRESS_POSTALCODE, 20)
									};
								if ( !Sql.IsEmptyString(sBILLING_CONTACT_NAME) )
								{
									string [] arrBILLING_CONTACT_NAME = sBILLING_CONTACT_NAME.Split(' ');
									if ( arrBILLING_CONTACT_NAME.Length >= 2 )
									{
										create.transactionRequest.billTo.firstName = CleanseData(arrBILLING_CONTACT_NAME[0], 50);
										create.transactionRequest.billTo.lastName  = CleanseData(arrBILLING_CONTACT_NAME[arrBILLING_CONTACT_NAME.Length - 1], 50);
									}
								}
							}
							*/
							if ( !Sql.IsEmptyString(sSHIPPING_ADDRESS_STREET) || !Sql.IsEmptyString(sSHIPPING_ADDRESS_CITY) || !Sql.IsEmptyString(sSHIPPING_ADDRESS_STATE) || !Sql.IsEmptyString(sSHIPPING_ADDRESS_POSTALCODE) )
							{
								create.transactionRequest.shipTo = new nameAndAddressType
									{ company = CleanseData(sSHIPPING_ACCOUNT_NAME      , 50)
									, address = CleanseData(sSHIPPING_ADDRESS_STREET    , 60)
									, city    = CleanseData(sSHIPPING_ADDRESS_CITY      , 40)
									, state   = CleanseData(sSHIPPING_ADDRESS_STATE     , 40)
									, zip     = CleanseData(sSHIPPING_ADDRESS_POSTALCODE, 20)
									};
								if ( !Sql.IsEmptyString(sSHIPPING_CONTACT_NAME) )
								{
									string [] arrSHIPPING_CONTACT_NAME = sSHIPPING_CONTACT_NAME.Split(' ');
									if ( arrSHIPPING_CONTACT_NAME.Length >= 2 )
									{
										create.transactionRequest.shipTo.firstName = CleanseData(arrSHIPPING_CONTACT_NAME[0], 50);
										create.transactionRequest.shipTo.lastName  = CleanseData(arrSHIPPING_CONTACT_NAME[arrSHIPPING_CONTACT_NAME.Length - 1], 50);
									}
								}
							}
						}
					}
				}

				Decimal dCALCULATED_TOTAL = Decimal.Zero;
				List<object> arrLineItems = new List<object>();
				sSQL = "select *                       " + ControlChars.CrLf
				     + "  from vwINVOICES_LINE_ITEMS   " + ControlChars.CrLf
				     + " where INVOICE_ID = @INVOICE_ID" + ControlChars.CrLf
				     + " order by POSITION             " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@INVOICE_ID", gINVOICE_ID);
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						using ( DataTable dt = new DataTable() )
						{
							da.Fill(dt);
							if ( dt.Rows.Count > 0 )
							{
								// 12/16/2015 Paul.  Maximum of 30 line items. 
								for ( int i = 0; i < dt.Rows.Count && i < 30; i++ )
								{
									DataRow row = dt.Rows[i];
									Guid    gID                  = Sql.ToGuid   (row["ID"                 ]);
									string  sNAME                = Sql.ToString (row["NAME"               ]);
									string  sMFT_PART_NUM        = Sql.ToString (row["MFT_PART_NUM"       ]);
									string  sVENDOR_PART_NUM     = Sql.ToString (row["VENDOR_PART_NUM"    ]);
									Guid    gPRODUCT_TEMPLATE_ID = Sql.ToGuid   (row["PRODUCT_TEMPLATE_ID"]);
									string  sTAX_CLASS           = Sql.ToString (row["TAX_CLASS"          ]);
									decimal dQUANTITY            = Sql.ToDecimal(row["QUANTITY"           ]);
									decimal dCOST_USDOLLAR       = Sql.ToDecimal(row["COST_USDOLLAR"      ]);
									decimal dLIST_USDOLLAR       = Sql.ToDecimal(row["LIST_USDOLLAR"      ]);
									decimal dUNIT_USDOLLAR       = Sql.ToDecimal(row["UNIT_USDOLLAR"      ]);
									decimal dTAX_USDOLLAR        = Sql.ToDecimal(row["TAX_USDOLLAR"       ]);
									decimal dEXTENDED_USDOLLAR   = Sql.ToDecimal(row["EXTENDED_USDOLLAR"  ]);
									decimal dDISCOUNT_USDOLLAR   = Sql.ToDecimal(row["DISCOUNT_USDOLLAR"  ]);
									string  sITEM_DESCRIPTION    = Sql.ToString (row["DESCRIPTION"        ]);
									if ( dQUANTITY > 0 && (!Sql.IsEmptyString(sMFT_PART_NUM) || !Sql.IsEmptyString(sNAME)) )
									{
										lineItemType item = new lineItemType();
										// 12/16/2015 Paul.  itemId is required, even if empty. 
										if ( !Sql.IsEmptyString(sMFT_PART_NUM    ) ) item.itemId      = CleanseData(sMFT_PART_NUM    ,  31);
										if ( !Sql.IsEmptyString(sNAME            ) ) item.name        = CleanseData(sNAME            ,  31);
										if ( !Sql.IsEmptyString(sITEM_DESCRIPTION) ) item.description = CleanseData(sITEM_DESCRIPTION, 255);
										if ( Sql.IsEmptyString(item.itemId) )
											item.itemId = item.name;
										else if ( Sql.IsEmptyString(item.name) )
											item.name = item.itemId;
										item.quantity    = dQUANTITY     ;
										item.unitPrice   = dUNIT_USDOLLAR;
										item.taxable     = (sTAX_CLASS == "Taxable");
										arrLineItems.Add(new { lineItem = item } );
										dCALCULATED_TOTAL += item.quantity * item.unitPrice;
									}
								}
							}
						}
					}
				}
				// 12/17/2015 Paul.  Only save the line items if the total matches the calculated total. 
				// This is to prevent an exception if the invoice total does not match the calculated total. 
				// The primary issue is due to sales tax calculations.  We perform the calculation on the subtotal, not the line item extended price. 
				// This can lead to a 1 cent difference. 
				dCALCULATED_TOTAL += create.transactionRequest.tax.amount;
				dCALCULATED_TOTAL += create.transactionRequest.shipping.amount;
				if ( dCALCULATED_TOTAL == dAMOUNT && arrLineItems.Count > 0 )
					create.transactionRequest.lineItems = arrLineItems.ToArray();

				Guid gPAYMENTS_TRANSACTION_ID = Guid.Empty;
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						SqlProcs.spPAYMENTS_TRANSACTIONS_InsertOnly
							( ref gPAYMENTS_TRANSACTION_ID
							, gPAYMENT_ID
							, "Authorize.Net"
							, "Sale"
							, dAMOUNT
							, gCURRENCY_ID
							, sINVOICE_NUM
							, sDESCRIPTION
							, gCREDIT_CARD_ID
							, gACCOUNT_ID
							, sSTATUS
							, trn
							);
						trn.Commit();
					}
					catch
					{
						trn.Rollback();
						throw;
					}
				}
				string sAvsCode         = String.Empty;
				string sReferenceNumber = String.Empty;
				string sErrorCode       = String.Empty;
				string sErrorMessage    = String.Empty;
				string sApprovalCode    = String.Empty;
				string sTransactionID   = String.Empty;
				try
				{
					using ( HttpClient client = new HttpClient() )
					{
						object request = new { createTransactionRequest = create };
						string param = Newtonsoft.Json.JsonConvert.SerializeObject(request, Formatting.Indented, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore } );
						HttpContent content = new StringContent(param, Encoding.UTF8, "application/json");
						HttpResponseMessage response = client.PostAsync(sAuthorizeNetEndpoint, content).Result;
						if ( response.IsSuccessStatusCode )
						{
							string sResult = response.Content.ReadAsStringAsync().Result;
							// http://www.webthingsconsidered.com/2013/08/09/adventures-in-json-parsing-with-c/
							createTransactionResponse result = JsonConvert.DeserializeObject<createTransactionResponse>(sResult);
							if ( result.messages != null )
							{
								if ( result.messages.resultCode == messageTypeEnum.Error )
								{
									sSTATUS = "Failed";
									if ( result.transactionResponse != null )
									{
										if ( result.transactionResponse.responseCode == "2" )
											sSTATUS = "Denied";
										else if ( result.transactionResponse.responseCode == "3" )
											sSTATUS = "Failed";
										else if ( result.transactionResponse.responseCode == "4" )
										{
											sSTATUS = "Pending";
											sAvsCode       = result.transactionResponse.avsResultCode;
											sApprovalCode  = result.transactionResponse.authCode;
											sTransactionID = result.transactionResponse.transId;
										}
									}
									if ( result.transactionResponse != null && result.transactionResponse.errors != null )
									{
										StringBuilder sb = new StringBuilder();
										foreach ( transactionResponseError msg in result.transactionResponse.errors )
										{
											sb.AppendLine(msg.errorText);
										}
										sErrorMessage = sb.ToString();
									}
									else if ( result.messages.message != null )
									{
										StringBuilder sb = new StringBuilder();
										foreach ( messagesTypeMessage msg in result.messages.message )
										{
											sb.AppendLine(msg.text);
										}
										sErrorMessage = sb.ToString();
									}
									else
									{
										sErrorMessage = "Unknown error";
									}
								}
								else if ( result.messages.resultCode != messageTypeEnum.Ok || result.transactionResponse == null )
								{
									sSTATUS = "Failed";
									sErrorMessage = "Unexpected results: " + sResult;
								}
								else
								{
									if ( result.transactionResponse.responseCode == "1" )
									{
										sSTATUS = "Success";
										sAvsCode       = result.transactionResponse.avsResultCode;
										sApprovalCode  = result.transactionResponse.authCode;
										sTransactionID = result.transactionResponse.transId;
									}
									else
									{
										// 12/16/2015 Paul.  This path should not be hit, but add code just in case. 
										if ( result.transactionResponse.responseCode == "2" )
											sSTATUS = "Denied";
										else if ( result.transactionResponse.responseCode == "3" )
											sSTATUS = "Failed";
										else if ( result.transactionResponse.responseCode == "4" )
										{
											sSTATUS = "Pending";
											sAvsCode       = result.transactionResponse.avsResultCode;
											sApprovalCode  = result.transactionResponse.authCode;
											sTransactionID = result.transactionResponse.transId;
										}
										if ( result.transactionResponse.errors != null )
										{
											StringBuilder sb = new StringBuilder();
											foreach ( transactionResponseError msg in result.transactionResponse.errors )
											{
												sb.AppendLine(msg.errorText);
											}
											sErrorMessage = sb.ToString();
										}
									}
								}
							}
							else
							{
								sSTATUS = "Failed";
								sErrorMessage = "Unexpected results: " + sResult;
							}
						}
						else
						{
							sSTATUS = "Failed";
							sErrorMessage = response.Content.ReadAsStringAsync().Result;
						}
					}
				}
				catch(Exception ex)
				{
					sErrorMessage = ex.Message;
					sSTATUS = "Failed";
				}
				finally
				{
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spPAYMENTS_TRANSACTIONS_Update
								( gPAYMENTS_TRANSACTION_ID
								, sSTATUS
								, sTransactionID
								, sReferenceNumber
								, sApprovalCode
								, sAvsCode
								, sErrorCode
								, sErrorMessage
								, trn
								);
							trn.Commit();
						}
						catch
						{
							trn.Rollback();
						}
					}
				}
			}
			return sSTATUS;
		}

		public string Refund(string sTransactionID)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			
			// http://developer.authorize.net/api/reference/index.html#payment-transactions-refund-a-transaction

			Dictionary<string, string> dictParams = new Dictionary<string, string>();
			string sUserName       = Sql.ToString (Application["CONFIG.AuthorizeNet.UserName"      ]);
			string sTransactionKey = Sql.ToString (Application["CONFIG.AuthorizeNet.TransactionKey"]);
			bool   bTestMode       = Sql.ToBoolean(Application["CONFIG.AuthorizeNet.TestMode"      ]);
			sTransactionKey = Security.DecryptPassword(sTransactionKey, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			string sAuthorizeNetEndpoint = (bTestMode ? "https://apitest.authorize.net/xml/v1/request.api" : "https://api.authorize.net/xml/v1/request.api");

			string sRefundTransactionId = String.Empty;
			using ( HttpClient client = new HttpClient() )
			{
				getTransactionDetailsRequest transaction = new getTransactionDetailsRequest
					{ merchantAuthentication = new merchantAuthenticationType
						{ name           = sUserName
						, transactionKey = sTransactionKey
						}
					, transId = sTransactionID
					};
				object request = new { getTransactionDetailsRequest = transaction };
				string param = Newtonsoft.Json.JsonConvert.SerializeObject(request, Formatting.Indented, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore } );
				HttpContent content = new StringContent(param, Encoding.UTF8, "application/json");
				HttpResponseMessage response = client.PostAsync(sAuthorizeNetEndpoint, content).Result;
				if ( response.IsSuccessStatusCode )
				{
					string sResult = response.Content.ReadAsStringAsync().Result;
					getTransactionDetailsResponse result = JsonConvert.DeserializeObject<getTransactionDetailsResponse>(sResult);
					StandardThrowError(result, sResult);
					
					if ( result.transaction.transactionStatus == "settledSuccessfully" )
					{
						createTransactionRequest refund = new createTransactionRequest
							{ merchantAuthentication = new merchantAuthenticationType
								{ name           = sUserName
								, transactionKey = sTransactionKey
								}
							, transactionRequest = new transactionRequestType
								{ transactionType = "refundTransaction"
								, amount          = result.transaction.settleAmount
								, refTransId      = sTransactionID
								, payment          = new paymentType()
								}
							};
						if ( result.transaction.customer != null )
						{
							refund.transactionRequest.profile = new customerProfilePaymentType();
							refund.transactionRequest.profile.customerProfileId = result.transaction.customer.id;
						}
						if ( result.transaction.payment.creditCard != null )
						{
							refund.transactionRequest.payment.creditCard = new creditCardType();
							refund.transactionRequest.payment.creditCard.cardNumber     = result.transaction.payment.creditCard.cardNumber    ;
							refund.transactionRequest.payment.creditCard.expirationDate = result.transaction.payment.creditCard.expirationDate;
						}
						else if ( result.transaction.payment.bankAccount != null )
						{
							refund.transactionRequest.payment.bankAccount = new bankAccountType();
							refund.transactionRequest.payment.bankAccount.accountNumber = result.transaction.payment.bankAccount.accountNumber;
							refund.transactionRequest.payment.bankAccount.routingNumber = result.transaction.payment.bankAccount.routingNumber;
							refund.transactionRequest.payment.bankAccount.nameOnAccount = result.transaction.payment.bankAccount.nameOnAccount;
							refund.transactionRequest.payment.bankAccount.accountType   = result.transaction.payment.bankAccount.accountType  ;
							refund.transactionRequest.payment.bankAccount.bankName      = result.transaction.payment.bankAccount.bankName     ;
							refund.transactionRequest.payment.bankAccount.echeckType    = result.transaction.payment.bankAccount.echeckType   ;
						}
						request = new { createTransactionRequest = refund };
					}
					else if ( result.transaction.transactionStatus == "capturedPendingSettlement" )
					{
						createTransactionRequest refund = new createTransactionRequest
							{ merchantAuthentication = new merchantAuthenticationType
								{ name           = sUserName
								, transactionKey = sTransactionKey
								}
							, transactionRequest = new transactionRequestType
								{ transactionType = "voidTransaction"
								, amount          = result.transaction.settleAmount
								, refTransId      = sTransactionID
								}
							};
						request = new { createTransactionRequest = refund };
					}
					else
					{
						throw(new Exception("Cannot refund transaction with status " + result.transaction.transactionStatus));
					}

					param = Newtonsoft.Json.JsonConvert.SerializeObject(request, Formatting.Indented, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore } );
					content = new StringContent(param, Encoding.UTF8, "application/json");
					response = client.PostAsync(sAuthorizeNetEndpoint, content).Result;
					if ( response.IsSuccessStatusCode )
					{
						sResult = response.Content.ReadAsStringAsync().Result;
						// http://www.webthingsconsidered.com/2013/08/09/adventures-in-json-parsing-with-c/
						createTransactionResponse resultRefund = JsonConvert.DeserializeObject<createTransactionResponse>(sResult);
						if ( resultRefund.messages != null )
						{
							string sErrorMessage = String.Empty;
							if ( resultRefund.messages.resultCode == messageTypeEnum.Error )
							{
								if ( resultRefund.transactionResponse != null && resultRefund.transactionResponse.errors != null )
								{
									StringBuilder sb = new StringBuilder();
									foreach ( transactionResponseError msg in resultRefund.transactionResponse.errors )
									{
										sb.AppendLine(msg.errorText);
									}
									sErrorMessage = sb.ToString();
								}
								else if ( resultRefund.messages.message != null )
								{
									StringBuilder sb = new StringBuilder();
									foreach ( messagesTypeMessage msg in resultRefund.messages.message )
									{
										sb.AppendLine(msg.text);
									}
									sErrorMessage = sb.ToString();
								}
								else
								{
									sErrorMessage = "Unknown error";
								}
								throw(new Exception(sErrorMessage));
							}
							else if ( resultRefund.messages.resultCode == messageTypeEnum.Ok && resultRefund.transactionResponse != null )
							{
								sRefundTransactionId = resultRefund.transactionResponse.transId;
							}
						}
					}
				}
				else
				{
					throw(new Exception(response.Content.ReadAsStringAsync().Result));
				}
			}
			return sRefundTransactionId;
		}

		public string Refund(Guid gPAYMENT_ID, Guid gCURRENCY_ID, Guid gACCOUNT_ID, Guid gCREDIT_CARD_ID, string sINVOICE_NUMBER, Decimal dAMOUNT, string sTRANSACTION_NUMBER)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			
			// http://developer.authorize.net/api/reference/index.html#payment-transactions-refund-a-transaction

			Dictionary<string, string> dictParams = new Dictionary<string, string>();
			string sUserName       = Sql.ToString (Application["CONFIG.AuthorizeNet.UserName"      ]);
			string sTransactionKey = Sql.ToString (Application["CONFIG.AuthorizeNet.TransactionKey"]);
			bool   bTestMode       = Sql.ToBoolean(Application["CONFIG.AuthorizeNet.TestMode"      ]);
			sTransactionKey = Security.DecryptPassword(sTransactionKey, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			string sAuthorizeNetEndpoint = (bTestMode ? "https://apitest.authorize.net/xml/v1/request.api" : "https://api.authorize.net/xml/v1/request.api");

			string   sSTATUS       = "Prevalidation";
			string   sCARD_TOKEN   = String.Empty;
			string[] arrCARD_TOKEN = new string[2];
			string   sINVOICE_NUM  = String.Empty;
			createTransactionRequest refund = new createTransactionRequest
				{ merchantAuthentication = new merchantAuthenticationType
					{ name           = sUserName
					, transactionKey = sTransactionKey
					}
				, transactionRequest = new transactionRequestType
					{ transactionType = "refundTransaction"
					, amount          = dAMOUNT
					, refTransId      = sTRANSACTION_NUMBER
					}
				};

			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL = String.Empty;
				sSQL = "select *                  " + ControlChars.CrLf
				     + "  from vwCREDIT_CARDS_Edit" + ControlChars.CrLf
				     + " where ID = @ID           " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gCREDIT_CARD_ID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							sCARD_TOKEN = Sql.ToString(rdr["CARD_NUMBER"]);
							if ( Sql.ToBoolean(rdr["IS_ENCRYPTED"]) )
							{
								sCARD_TOKEN = Security.DecryptPassword(sCARD_TOKEN, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
								arrCARD_TOKEN = sCARD_TOKEN.Split(',');
								refund.transactionRequest.profile = new customerProfilePaymentType
									{ customerProfileId = arrCARD_TOKEN[0]
									, paymentProfile    = new paymentProfile { paymentProfileId = arrCARD_TOKEN[1] }
									};
							}
						}
					}
				}

				Guid gPAYMENTS_TRANSACTION_ID = Guid.Empty;
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						SqlProcs.spPAYMENTS_TRANSACTIONS_InsertOnly
							( ref gPAYMENTS_TRANSACTION_ID
							, gPAYMENT_ID
							, "Authorize.Net"
							, "Refund"
							, dAMOUNT
							, gCURRENCY_ID
							, sINVOICE_NUM
							, String.Empty
							, gCREDIT_CARD_ID
							, gACCOUNT_ID
							, sSTATUS
							, trn
							);
						trn.Commit();
					}
					catch
					{
						trn.Rollback();
						throw;
					}
				}
				string sAvsCode         = String.Empty;
				string sReferenceNumber = String.Empty;
				string sErrorCode       = String.Empty;
				string sErrorMessage    = String.Empty;
				string sApprovalCode    = String.Empty;
				string sTransactionID   = String.Empty;
				try
				{
					using ( HttpClient client = new HttpClient() )
					{
						object request = new { createTransactionRequest = refund };
						string param = Newtonsoft.Json.JsonConvert.SerializeObject(request, Formatting.Indented, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore } );
						HttpContent content = new StringContent(param, Encoding.UTF8, "application/json");
						HttpResponseMessage response = client.PostAsync(sAuthorizeNetEndpoint, content).Result;
						if ( response.IsSuccessStatusCode )
						{
							string sResult = response.Content.ReadAsStringAsync().Result;
							// http://www.webthingsconsidered.com/2013/08/09/adventures-in-json-parsing-with-c/
							createTransactionResponse result = JsonConvert.DeserializeObject<createTransactionResponse>(sResult);
							if ( result.messages != null )
							{
								if ( result.messages.resultCode == messageTypeEnum.Error )
								{
									sSTATUS = "Failed";
									if ( result.transactionResponse != null )
									{
										if ( result.transactionResponse.responseCode == "2" )
											sSTATUS = "Denied";
										else if ( result.transactionResponse.responseCode == "3" )
											sSTATUS = "Failed";
										else if ( result.transactionResponse.responseCode == "4" )
										{
											sSTATUS = "Pending";
											sAvsCode       = result.transactionResponse.avsResultCode;
											sApprovalCode  = result.transactionResponse.authCode;
											sTransactionID = result.transactionResponse.transId;
										}
									}
									if ( result.transactionResponse != null && result.transactionResponse.errors != null )
									{
										StringBuilder sb = new StringBuilder();
										foreach ( transactionResponseError msg in result.transactionResponse.errors )
										{
											sb.AppendLine(msg.errorText);
										}
										sErrorMessage = sb.ToString();
									}
									else if ( result.messages.message != null )
									{
										StringBuilder sb = new StringBuilder();
										foreach ( messagesTypeMessage msg in result.messages.message )
										{
											sb.AppendLine(msg.text);
										}
										sErrorMessage = sb.ToString();
									}
									else
									{
										sErrorMessage = "Unknown error";
									}
								}
								else if ( result.messages.resultCode != messageTypeEnum.Ok || result.transactionResponse == null )
								{
									sSTATUS = "Failed";
									sErrorMessage = "Unexpected results: " + sResult;
								}
								else
								{
									if ( result.transactionResponse.responseCode == "1" )
									{
										sSTATUS = "Success";
										sAvsCode       = result.transactionResponse.avsResultCode;
										sApprovalCode  = result.transactionResponse.authCode;
										sTransactionID = result.transactionResponse.transId;
									}
									else
									{
										// 12/16/2015 Paul.  This path should not be hit, but add code just in case. 
										if ( result.transactionResponse.responseCode == "2" )
											sSTATUS = "Denied";
										else if ( result.transactionResponse.responseCode == "3" )
											sSTATUS = "Failed";
										else if ( result.transactionResponse.responseCode == "4" )
										{
											sSTATUS = "Pending";
											sAvsCode       = result.transactionResponse.avsResultCode;
											sApprovalCode  = result.transactionResponse.authCode;
											sTransactionID = result.transactionResponse.transId;
										}
										if ( result.transactionResponse.errors != null )
										{
											StringBuilder sb = new StringBuilder();
											foreach ( transactionResponseError msg in result.transactionResponse.errors )
											{
												sb.AppendLine(msg.errorText);
											}
											sErrorMessage = sb.ToString();
										}
									}
								}
							}
							else
							{
								sSTATUS = "Failed";
								sErrorMessage = "Unexpected results: " + sResult;
							}
						}
						else
						{
							sSTATUS = "Failed";
							sErrorMessage = response.Content.ReadAsStringAsync().Result;
						}
					}
				}
				catch(Exception ex)
				{
					sErrorMessage = ex.Message;
					sSTATUS = "Failed";
				}
				finally
				{
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spPAYMENTS_TRANSACTIONS_Update
								( gPAYMENTS_TRANSACTION_ID
								, sSTATUS
								, sTransactionID
								, sReferenceNumber
								, sApprovalCode
								, sAvsCode
								, sErrorCode
								, sErrorMessage
								, trn
								);
							trn.Commit();
						}
						catch
						{
							trn.Rollback();
						}
					}
				}
			}
			return sSTATUS;
		}

		public DataTable Transactions(DateTime dtStartDate, DateTime dtEndDate)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			
			// http://developer.authorize.net/api/reference/index.html#transaction-reporting

			Dictionary<string, string> dictParams = new Dictionary<string, string>();
			string sUserName       = Sql.ToString (Application["CONFIG.AuthorizeNet.UserName"      ]);
			string sTransactionKey = Sql.ToString (Application["CONFIG.AuthorizeNet.TransactionKey"]);
			bool   bTestMode       = Sql.ToBoolean(Application["CONFIG.AuthorizeNet.TestMode"      ]);
			sTransactionKey = Security.DecryptPassword(sTransactionKey, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			string sAuthorizeNetEndpoint = (bTestMode ? "https://apitest.authorize.net/xml/v1/request.api" : "https://api.authorize.net/xml/v1/request.api");

			DataTable dtTransactions = new DataTable("TRANSACTIONS");
			dtTransactions.Columns.Add("transId"          , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("submitTimeUTC"    , Type.GetType("System.DateTime"));
			dtTransactions.Columns.Add("submitTimeLocal"  , Type.GetType("System.DateTime"));
			dtTransactions.Columns.Add("transactionStatus", Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("billTo_firstName" , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("billTo_lastName"  , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("accountType"      , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("accountNumber"    , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("settleAmount"     , Type.GetType("System.Decimal" ));
			dtTransactions.Columns.Add("marketType"       , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("product"          , Type.GetType("System.String"  ));

			using ( HttpClient client = new HttpClient() )
			{
				getSettledBatchListRequest batchList = new getSettledBatchListRequest
					{ merchantAuthentication = new merchantAuthenticationType
						{ name           = sUserName
						, transactionKey = sTransactionKey
						}
					, firstSettlementDate = dtStartDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
					, lastSettlementDate  = dtEndDate  .ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
					};
				object request = new { getSettledBatchListRequest = batchList };
				string param = Newtonsoft.Json.JsonConvert.SerializeObject(request, Formatting.Indented, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore } );
				HttpContent content = new StringContent(param, Encoding.UTF8, "application/json");
				HttpResponseMessage response = client.PostAsync(sAuthorizeNetEndpoint, content).Result;
				if ( response.IsSuccessStatusCode )
				{
					string sResult = response.Content.ReadAsStringAsync().Result;
					getSettledBatchListResponse resultBatchList = JsonConvert.DeserializeObject<getSettledBatchListResponse>(sResult);
					StandardThrowError(resultBatchList, sResult);
					if ( resultBatchList.batchList != null )
					{
						foreach ( batchDetailsType batch in resultBatchList.batchList )
						{
							getTransactionListRequest transactionList = new getTransactionListRequest
								{ merchantAuthentication = new merchantAuthenticationType
									{ name           = sUserName
									, transactionKey = sTransactionKey
									}
								, batchId = batch.batchId
								};
							request = new { getTransactionListRequest = transactionList };
							param = Newtonsoft.Json.JsonConvert.SerializeObject(request, Formatting.Indented, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore } );
							content = new StringContent(param, Encoding.UTF8, "application/json");
							response = client.PostAsync(sAuthorizeNetEndpoint, content).Result;
							if ( response.IsSuccessStatusCode )
							{
								sResult = response.Content.ReadAsStringAsync().Result;
								getTransactionListResponse resultTransactionList = JsonConvert.DeserializeObject<getTransactionListResponse>(sResult);
								StandardThrowError(resultTransactionList, sResult);
								if ( resultTransactionList.transactions != null )
								{
									foreach ( transactionSummaryType trn in resultTransactionList.transactions )
									{
										DataRow row = dtTransactions.NewRow();
										dtTransactions.Rows.Add(row);
										row["transId"          ] = trn.transId          ;
										row["submitTimeUTC"    ] = trn.submitTimeUTC    ;
										row["submitTimeLocal"  ] = trn.submitTimeLocal  ;
										row["transactionStatus"] = trn.transactionStatus;
										row["billTo_firstName" ] = trn.firstName        ;
										row["billTo_lastName"  ] = trn.lastName         ;
										row["accountType"      ] = trn.accountType      ;
										row["accountNumber"    ] = trn.accountNumber    ;
										row["settleAmount"     ] = trn.settleAmount     ;
										row["marketType"       ] = trn.marketType       ;
										row["product"          ] = trn.product          ;
									}
								}
							}
							else
							{
								throw(new Exception(response.Content.ReadAsStringAsync().Result));
							}
						}
					}
				}
				else
				{
					throw(new Exception(response.Content.ReadAsStringAsync().Result));
				}

				getUnsettledTransactionListRequest unsettledList = new getUnsettledTransactionListRequest
					{ merchantAuthentication = new merchantAuthenticationType
						{ name           = sUserName
						, transactionKey = sTransactionKey
						}
					};
				request = new { getUnsettledTransactionListRequest = unsettledList };
				param = Newtonsoft.Json.JsonConvert.SerializeObject(request, Formatting.Indented, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore } );
				content = new StringContent(param, Encoding.UTF8, "application/json");
				response = client.PostAsync(sAuthorizeNetEndpoint, content).Result;
				if ( response.IsSuccessStatusCode )
				{
					string sResult = response.Content.ReadAsStringAsync().Result;
					getUnsettledTransactionListResponse resultTransactionList = JsonConvert.DeserializeObject<getUnsettledTransactionListResponse>(sResult);
					StandardThrowError(resultTransactionList, sResult);
					if ( resultTransactionList.transactions != null )
					{
						foreach ( transactionSummaryType trn in resultTransactionList.transactions )
						{
							DataRow row = dtTransactions.NewRow();
							dtTransactions.Rows.Add(row);
							row["transId"          ] = trn.transId          ;
							row["submitTimeUTC"    ] = trn.submitTimeUTC    ;
							row["submitTimeLocal"  ] = trn.submitTimeLocal  ;
							row["transactionStatus"] = trn.transactionStatus;
							row["billTo_firstName" ] = trn.firstName        ;
							row["billTo_lastName"  ] = trn.lastName         ;
							row["accountType"      ] = trn.accountType      ;
							row["accountNumber"    ] = trn.accountNumber    ;
							row["settleAmount"     ] = trn.settleAmount     ;
							row["marketType"       ] = trn.marketType       ;
							row["product"          ] = trn.product          ;
						}
					}
				}
				else
				{
					throw(new Exception(response.Content.ReadAsStringAsync().Result));
				}
			}
			return dtTransactions;
		}

		public DataSet Transaction(string sTransactionID)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			
			// http://developer.authorize.net/api/reference/index.html#transaction-reporting-get-transaction-details

			Dictionary<string, string> dictParams = new Dictionary<string, string>();
			string sUserName       = Sql.ToString (Application["CONFIG.AuthorizeNet.UserName"      ]);
			string sTransactionKey = Sql.ToString (Application["CONFIG.AuthorizeNet.TransactionKey"]);
			bool   bTestMode       = Sql.ToBoolean(Application["CONFIG.AuthorizeNet.TestMode"      ]);
			sTransactionKey = Security.DecryptPassword(sTransactionKey, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			string sAuthorizeNetEndpoint = (bTestMode ? "https://apitest.authorize.net/xml/v1/request.api" : "https://api.authorize.net/xml/v1/request.api");

			DataSet ds = new DataSet();
			DataTable dtTransactions = ds.Tables.Add("TRANSACTIONS");
			dtTransactions.Columns.Add("transId"                  , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("refTransId"               , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("submitTimeUTC"            , Type.GetType("System.DateTime"));
			dtTransactions.Columns.Add("submitTimeLocal"          , Type.GetType("System.DateTime"));
			dtTransactions.Columns.Add("transactionType"          , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("transactionStatus"        , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("responseCode"             , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("responseReasonCode"       , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("responseReasonDescription", Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("authCode"                 , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("AVSResponse"              , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("batchId"                  , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("settlementTimeUTC"        , Type.GetType("System.DateTime"));
			dtTransactions.Columns.Add("settlementTimeLocal"      , Type.GetType("System.DateTime"));
			dtTransactions.Columns.Add("settlementState"          , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("authAmount"               , Type.GetType("System.Decimal" ));
			dtTransactions.Columns.Add("settleAmount"             , Type.GetType("System.Decimal" ));
			dtTransactions.Columns.Add("taxExempt"                , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("creditCard_cardNumber"    , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("creditCard_expirationDate", Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("creditCard_cardType"      , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("bankAccount_routingNumber", Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("bankAccount_accountNumber", Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("bankAccount_nameOnAccount", Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("bankAccount_bankName"     , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("bankAccount_accountType"  , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("bankAccount_echeckType"   , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("token_tokenSource"        , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("token_tokenNumber"        , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("token_expirationDate"     , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("customer_id"              , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("customer_type"            , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("customer_email"           , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("billTo_firstName"         , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("billTo_lastName"          , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("billTo_address"           , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("billTo_city"              , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("billTo_state"             , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("billTo_zip"               , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("billTo_country"           , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("recurringBilling"         , Type.GetType("System.Boolean" ));
			dtTransactions.Columns.Add("product"                  , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("marketType"               , Type.GetType("System.String"  ));
			
			DataTable dtLineItems = ds.Tables.Add("LINE_ITEMS");
			dtLineItems.Columns.Add("transId"          , Type.GetType("System.String"  ));
			dtLineItems.Columns.Add("itemId"           , Type.GetType("System.String"  ));
			dtLineItems.Columns.Add("name"             , Type.GetType("System.String"  ));
			dtLineItems.Columns.Add("description"      , Type.GetType("System.String"  ));
			dtLineItems.Columns.Add("quantity"         , Type.GetType("System.Decimal" ));
			dtLineItems.Columns.Add("unitPrice"        , Type.GetType("System.Decimal" ));
			dtLineItems.Columns.Add("taxable"          , Type.GetType("System.Boolean" ));

			using ( HttpClient client = new HttpClient() )
			{
				getTransactionDetailsRequest transaction = new getTransactionDetailsRequest
					{ merchantAuthentication = new merchantAuthenticationType
						{ name           = sUserName
						, transactionKey = sTransactionKey
						}
					, transId = sTransactionID
					};
				object request = new { getTransactionDetailsRequest = transaction };
				string param = Newtonsoft.Json.JsonConvert.SerializeObject(request, Formatting.Indented, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore } );
				HttpContent content = new StringContent(param, Encoding.UTF8, "application/json");
				HttpResponseMessage response = client.PostAsync(sAuthorizeNetEndpoint, content).Result;
				if ( response.IsSuccessStatusCode )
				{
					string sResult = response.Content.ReadAsStringAsync().Result;
					getTransactionDetailsResponse result = JsonConvert.DeserializeObject<getTransactionDetailsResponse>(sResult);
					StandardThrowError(result, sResult);
					
					DataRow row = dtTransactions.NewRow();
					dtTransactions.Rows.Add(row);
					row["transId"                  ] = result.transaction.transId                  ;
					row["refTransId"               ] = result.transaction.refTransId               ;
					row["submitTimeUTC"            ] = result.transaction.submitTimeUTC            ;
					row["submitTimeLocal"          ] = result.transaction.submitTimeLocal          ;
					row["transactionType"          ] = result.transaction.transactionType          ;
					row["transactionStatus"        ] = result.transaction.transactionStatus        ;
					row["responseCode"             ] = result.transaction.responseCode             ;
					row["responseReasonCode"       ] = result.transaction.responseReasonCode       ;
					row["responseReasonDescription"] = result.transaction.responseReasonDescription;
					row["authCode"                 ] = result.transaction.authCode                 ;
					row["AVSResponse"              ] = result.transaction.AVSResponse              ;
					row["authAmount"               ] = result.transaction.authAmount               ;
					row["settleAmount"             ] = result.transaction.settleAmount             ;
					row["taxExempt"                ] = result.transaction.taxExempt                ;
					if ( result.transaction.batch != null )
					{
						row["batchId"                  ] = result.transaction.batch.batchId            ;
						row["settlementTimeUTC"        ] = result.transaction.batch.settlementTimeUTC  ;
						row["settlementTimeLocal"      ] = result.transaction.batch.settlementTimeLocal;
						row["settlementState"          ] = result.transaction.batch.settlementState    ;
					}
					if ( result.transaction.payment.creditCard != null )
					{
						row["creditCard_cardNumber"    ] = result.transaction.payment.creditCard.cardNumber    ;
						row["creditCard_expirationDate"] = result.transaction.payment.creditCard.expirationDate;
						row["creditCard_cardType"      ] = result.transaction.payment.creditCard.cardType      ;
					}
					if ( result.transaction.payment.bankAccount != null )
					{
						row["bankAccount_routingNumber"] = result.transaction.payment.bankAccount.routingNumber         ;
						row["bankAccount_accountNumber"] = result.transaction.payment.bankAccount.accountNumber         ;
						row["bankAccount_nameOnAccount"] = result.transaction.payment.bankAccount.nameOnAccount         ;
						row["bankAccount_bankName"     ] = result.transaction.payment.bankAccount.bankName              ;
						row["bankAccount_accountType"  ] = result.transaction.payment.bankAccount.accountType.ToString();
						row["bankAccount_echeckType"   ] = result.transaction.payment.bankAccount.echeckType .ToString();
					}
					if ( result.transaction.payment.token != null )
					{
						row["token_tokenSource"        ] = result.transaction.payment.token.tokenSource         ;
						row["token_tokenNumber"        ] = result.transaction.payment.token.tokenNumber         ;
						row["token_expirationDate"     ] = result.transaction.payment.token.expirationDate      ;
					}
					if ( result.transaction.customer != null )
					{
						row["customer_id"              ] = result.transaction.customer.id              ;
						row["customer_type"            ] = result.transaction.customer.type            ;
						row["customer_email"           ] = result.transaction.customer.email           ;
					}
					if ( result.transaction.billTo != null )
					{
						row["billTo_firstName"         ] = result.transaction.billTo.firstName         ;
						row["billTo_lastName"          ] = result.transaction.billTo.lastName          ;
						row["billTo_address"           ] = result.transaction.billTo.address           ;
						row["billTo_city"              ] = result.transaction.billTo.city              ;
						row["billTo_state"             ] = result.transaction.billTo.state             ;
						row["billTo_zip"               ] = result.transaction.billTo.zip               ;
						row["billTo_country"           ] = result.transaction.billTo.country           ;
					}
					row["recurringBilling"         ] = result.transaction.recurringBilling         ;
					row["product"                  ] = result.transaction.product                  ;
					row["marketType"               ] = result.transaction.marketType               ;
					
					if ( result.transaction.lineItems != null )
					{
						foreach ( lineItemType item in result.transaction.lineItems )
						{
							DataRow rowItem = dtLineItems.NewRow();
							dtLineItems.Rows.Add(rowItem);
							
							rowItem["transId"    ] = result.transaction.transId;
							rowItem["itemId"     ] = item.itemId     ;
							rowItem["name"       ] = item.name       ;
							rowItem["description"] = item.description;
							rowItem["quantity"   ] = item.quantity   ;
							rowItem["unitPrice"  ] = item.unitPrice  ;
							rowItem["taxable"    ] = item.taxable    ;
						}
					}
				}
				else
				{
					throw(new Exception(response.Content.ReadAsStringAsync().Result));
				}
			}
			return ds;
		}

		private DataSet CreateCustomerProfileDataSet()
		{
			DataSet ds = new DataSet();
			DataTable dtCustomerProfiles = ds.Tables.Add("CUSTOMER_PROFILES");
			dtCustomerProfiles.Columns.Add("customerProfileId"       , Type.GetType("System.String"  ));
			dtCustomerProfiles.Columns.Add("merchantCustomerId"      , Type.GetType("System.String"  ));
			dtCustomerProfiles.Columns.Add("description"             , Type.GetType("System.String"  ));
			dtCustomerProfiles.Columns.Add("email"                   , Type.GetType("System.String"  ));

			DataTable dtPaymentProfiles = ds.Tables.Add("PAYMENT_PROFILES");
			dtPaymentProfiles.Columns.Add("customerProfileId"        , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("customerPaymentProfileId" , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("customerType"             , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("billTo_firstName"         , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("billTo_lastName"          , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("billTo_address"           , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("billTo_city"              , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("billTo_state"             , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("billTo_zip"               , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("billTo_country"           , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("billTo_phoneNumber"       , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("billTo_faxNumber"         , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("billTo_email"             , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("creditCard_cardNumber"    , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("creditCard_expirationDate", Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("creditCard_cardType"      , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("bankAccount_routingNumber", Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("bankAccount_accountNumber", Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("bankAccount_nameOnAccount", Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("bankAccount_bankName"     , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("bankAccount_accountType"  , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("bankAccount_echeckType"   , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("token_tokenSource"        , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("token_tokenNumber"        , Type.GetType("System.String"  ));
			dtPaymentProfiles.Columns.Add("token_expirationDate"     , Type.GetType("System.String"  ));

			DataTable dtShippingAddresses = ds.Tables.Add("SHIPPING_ADDRESSES");
			dtShippingAddresses.Columns.Add("customerProfileId"      , Type.GetType("System.String"  ));
			dtShippingAddresses.Columns.Add("customerAddressId"      , Type.GetType("System.String"  ));
			dtShippingAddresses.Columns.Add("firstName"              , Type.GetType("System.String"  ));
			dtShippingAddresses.Columns.Add("lastName"               , Type.GetType("System.String"  ));
			dtShippingAddresses.Columns.Add("address"                , Type.GetType("System.String"  ));
			dtShippingAddresses.Columns.Add("city"                   , Type.GetType("System.String"  ));
			dtShippingAddresses.Columns.Add("state"                  , Type.GetType("System.String"  ));
			dtShippingAddresses.Columns.Add("zip"                    , Type.GetType("System.String"  ));
			dtShippingAddresses.Columns.Add("country"                , Type.GetType("System.String"  ));
			dtShippingAddresses.Columns.Add("phoneNumber"            , Type.GetType("System.String"  ));
			dtShippingAddresses.Columns.Add("faxNumber"              , Type.GetType("System.String"  ));
			dtShippingAddresses.Columns.Add("email"                  , Type.GetType("System.String"  ));
			return ds;
		}

		private void SetCustomerProfile(DataSet ds, getCustomerProfileResponse resultTransactionList)
		{
			if ( resultTransactionList.profile != null )
			{
				DataTable dtCustomerProfiles = ds.Tables["CUSTOMER_PROFILES"];
				DataRow row = dtCustomerProfiles.NewRow();
				dtCustomerProfiles.Rows.Add(row);
				row["customerProfileId" ] = resultTransactionList.profile.customerProfileId ;
				row["merchantCustomerId"] = resultTransactionList.profile.merchantCustomerId;
				row["description"       ] = resultTransactionList.profile.description       ;
				row["email"             ] = resultTransactionList.profile.email             ;
				
				if ( resultTransactionList.profile.paymentProfiles != null )
				{
					DataTable dtPaymentProfiles = ds.Tables["PAYMENT_PROFILES"];
					foreach ( customerPaymentProfileMaskedType profile in resultTransactionList.profile.paymentProfiles )
					{
						DataRow rowPayment = dtPaymentProfiles.NewRow();
						dtPaymentProfiles.Rows.Add(rowPayment);
						rowPayment["customerProfileId"        ] = resultTransactionList.profile.customerProfileId;
						rowPayment["customerPaymentProfileId" ] = profile.customerPaymentProfileId         ;
						rowPayment["customerType"             ] = profile.customerType.ToString()          ;
						if ( profile.billTo != null )
						{
							rowPayment["billTo_firstName"         ] = profile.billTo.firstName                 ;
							rowPayment["billTo_lastName"          ] = profile.billTo.lastName                  ;
							rowPayment["billTo_address"           ] = profile.billTo.address                   ;
							rowPayment["billTo_city"              ] = profile.billTo.city                      ;
							rowPayment["billTo_state"             ] = profile.billTo.state                     ;
							rowPayment["billTo_zip"               ] = profile.billTo.zip                       ;
							rowPayment["billTo_country"           ] = profile.billTo.country                   ;
							rowPayment["billTo_phoneNumber"       ] = profile.billTo.phoneNumber               ;
							rowPayment["billTo_faxNumber"         ] = profile.billTo.faxNumber                 ;
							rowPayment["billTo_email"             ] = profile.billTo.email                     ;
						}
						if ( profile.payment != null )
						{
							if ( profile.payment.creditCard != null )
							{
								rowPayment["creditCard_cardNumber"    ] = profile.payment.creditCard.cardNumber    ;
								rowPayment["creditCard_expirationDate"] = profile.payment.creditCard.expirationDate;
								rowPayment["creditCard_cardType"      ] = profile.payment.creditCard.cardType      ;
							}
							if ( profile.payment.bankAccount != null )
							{
								rowPayment["bankAccount_routingNumber"] = profile.payment.bankAccount.routingNumber;
								rowPayment["bankAccount_accountNumber"] = profile.payment.bankAccount.accountNumber;
								rowPayment["bankAccount_nameOnAccount"] = profile.payment.bankAccount.nameOnAccount;
								rowPayment["bankAccount_bankName"     ] = profile.payment.bankAccount.bankName     ;
								rowPayment["bankAccount_accountType"  ] = profile.payment.bankAccount.accountType  ;
								rowPayment["bankAccount_echeckType"   ] = profile.payment.bankAccount.echeckType   ;
							}
							if ( profile.payment.token != null )
							{
								rowPayment["token_tokenSource"        ] = profile.payment.token.tokenSource        ;
								rowPayment["token_tokenNumber"        ] = profile.payment.token.tokenNumber        ;
								rowPayment["token_expirationDate"     ] = profile.payment.token.expirationDate     ;
							}
						}
					}
				}
				
				if ( resultTransactionList.profile.shipToList != null )
				{
					DataTable dtShippingAddresses = ds.Tables["SHIPPING_ADDRESSES"];
					foreach ( customerAddressExType ship in resultTransactionList.profile.shipToList )
					{
						DataRow rowShipping = dtShippingAddresses.NewRow();
						dtShippingAddresses.Rows.Add(rowShipping);
						rowShipping["customerProfileId"] = resultTransactionList.profile.customerProfileId ;
						rowShipping["customerAddressId"] = ship.customerAddressId;
						rowShipping["firstName"        ] = ship.firstName        ;
						rowShipping["lastName"         ] = ship.lastName         ;
						rowShipping["address"          ] = ship.address          ;
						rowShipping["city"             ] = ship.city             ;
						rowShipping["state"            ] = ship.state            ;
						rowShipping["zip"              ] = ship.zip              ;
						rowShipping["country"          ] = ship.country          ;
						rowShipping["phoneNumber"      ] = ship.phoneNumber      ;
						rowShipping["faxNumber"        ] = ship.faxNumber        ;
						rowShipping["email"            ] = ship.email            ;
					}
				}
			}
		}

		public DataSet CustomerProfile(string sCustomerProfileId)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			
			// http://developer.authorize.net/api/reference/index.html#transaction-reporting

			Dictionary<string, string> dictParams = new Dictionary<string, string>();
			string sUserName       = Sql.ToString (Application["CONFIG.AuthorizeNet.UserName"      ]);
			string sTransactionKey = Sql.ToString (Application["CONFIG.AuthorizeNet.TransactionKey"]);
			bool   bTestMode       = Sql.ToBoolean(Application["CONFIG.AuthorizeNet.TestMode"      ]);
			sTransactionKey = Security.DecryptPassword(sTransactionKey, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			string sAuthorizeNetEndpoint = (bTestMode ? "https://apitest.authorize.net/xml/v1/request.api" : "https://api.authorize.net/xml/v1/request.api");

			DataSet ds = CreateCustomerProfileDataSet();
			using ( HttpClient client = new HttpClient() )
			{
				getCustomerProfileRequest transactionList = new getCustomerProfileRequest
					{ merchantAuthentication = new merchantAuthenticationType
						{ name           = sUserName
						, transactionKey = sTransactionKey
						}
					, customerProfileId = sCustomerProfileId
					};
				object request = new { getCustomerProfileRequest = transactionList };
				string param = Newtonsoft.Json.JsonConvert.SerializeObject(request, Formatting.Indented, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore } );
				HttpContent content = new StringContent(param, Encoding.UTF8, "application/json");
				HttpResponseMessage response = client.PostAsync(sAuthorizeNetEndpoint, content).Result;
				if ( response.IsSuccessStatusCode )
				{
					string sResult = response.Content.ReadAsStringAsync().Result;
					getCustomerProfileResponse resultTransactionList = JsonConvert.DeserializeObject<getCustomerProfileResponse>(sResult);
					StandardThrowError(resultTransactionList, sResult);
					if ( resultTransactionList.profile != null )
					{
						SetCustomerProfile(ds, resultTransactionList);
					}
				}
				else
				{
					throw(new Exception(response.Content.ReadAsStringAsync().Result));
				}
			}
			return ds;
		}

		public DataSet CustomerProfiles()
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			
			// http://developer.authorize.net/api/reference/index.html#transaction-reporting

			Dictionary<string, string> dictParams = new Dictionary<string, string>();
			string sUserName       = Sql.ToString (Application["CONFIG.AuthorizeNet.UserName"      ]);
			string sTransactionKey = Sql.ToString (Application["CONFIG.AuthorizeNet.TransactionKey"]);
			bool   bTestMode       = Sql.ToBoolean(Application["CONFIG.AuthorizeNet.TestMode"      ]);
			sTransactionKey = Security.DecryptPassword(sTransactionKey, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			string sAuthorizeNetEndpoint = (bTestMode ? "https://apitest.authorize.net/xml/v1/request.api" : "https://api.authorize.net/xml/v1/request.api");

			DataSet ds = CreateCustomerProfileDataSet();
			using ( HttpClient client = new HttpClient() )
			{
				getCustomerProfileIdsRequest profileList = new getCustomerProfileIdsRequest
					{ merchantAuthentication = new merchantAuthenticationType
						{ name           = sUserName
						, transactionKey = sTransactionKey
						}
					};
				object request = new { getCustomerProfileIdsRequest = profileList };
				string param = Newtonsoft.Json.JsonConvert.SerializeObject(request, Formatting.Indented, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore } );
				HttpContent content = new StringContent(param, Encoding.UTF8, "application/json");
				HttpResponseMessage response = client.PostAsync(sAuthorizeNetEndpoint, content).Result;
				if ( response.IsSuccessStatusCode )
				{
					string sResult = response.Content.ReadAsStringAsync().Result;
					getCustomerProfileIdsResponse resultProfileList = JsonConvert.DeserializeObject<getCustomerProfileIdsResponse>(sResult);
					StandardThrowError(resultProfileList, sResult);
					if ( resultProfileList.ids != null )
					{
						foreach ( string sId in resultProfileList.ids )
						{
							getCustomerProfileRequest transactionList = new getCustomerProfileRequest
								{ merchantAuthentication = new merchantAuthenticationType
									{ name           = sUserName
									, transactionKey = sTransactionKey
									}
								, customerProfileId = sId
								};
							request = new { getCustomerProfileRequest = transactionList };
							param = Newtonsoft.Json.JsonConvert.SerializeObject(request, Formatting.Indented, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore } );
							content = new StringContent(param, Encoding.UTF8, "application/json");
							response = client.PostAsync(sAuthorizeNetEndpoint, content).Result;
							if ( response.IsSuccessStatusCode )
							{
								sResult = response.Content.ReadAsStringAsync().Result;
								getCustomerProfileResponse resultTransactionList = JsonConvert.DeserializeObject<getCustomerProfileResponse>(sResult);
								StandardThrowError(resultTransactionList, sResult);
								if ( resultTransactionList.profile != null )
								{
									SetCustomerProfile(ds, resultTransactionList);
								}
							}
							else
							{
								throw(new Exception(response.Content.ReadAsStringAsync().Result));
							}
						}
					}
				}
				else
				{
					throw(new Exception(response.Content.ReadAsStringAsync().Result));
				}
			}
			return ds;
		}
	}
}

