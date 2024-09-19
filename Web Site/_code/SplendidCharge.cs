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
using System.Data;
using System.Data.Common;
using System.Web;
using System.Net;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Reflection;
using System.Diagnostics;
using SplendidCRM.SplendidCharge.NSoftware;

namespace SplendidCRM.SplendidCharge
{
	public class CC
	{
		private DbProviderFactories  DbProviderFactories = new DbProviderFactories();
		private HttpApplicationState Application         = new HttpApplicationState();
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;

		public CC(Security Security, Sql Sql, SqlProcs SqlProcs)
		{
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
		}

		public /*static*/ string Charge(Guid gID, Guid gCURRENCY_ID, Guid gACCOUNT_ID, Guid gCREDIT_CARD_ID, string sClientIP, string sOrderID, string sDESCRIPTION, Decimal dAMOUNT)
		{
			string sPaymentGateway          = Sql.ToString (Application["CONFIG.PaymentGateway"         ]);
			string sPaymentGateway_Login    = Sql.ToString (Application["CONFIG.PaymentGateway_Login"   ]);
			string sPaymentGateway_Password = Sql.ToString (Application["CONFIG.PaymentGateway_Password"]);
			bool   bPaymentGateway_TestMode = Sql.ToBoolean(Application["CONFIG.PaymentGateway_TestMode"]);
			return Charge(gID, gCURRENCY_ID, gACCOUNT_ID, gCREDIT_CARD_ID, sClientIP, sOrderID, sDESCRIPTION, "Sale", dAMOUNT, String.Empty, sPaymentGateway, sPaymentGateway_Login, sPaymentGateway_Password, bPaymentGateway_TestMode);
		}

		public /*static*/ string Charge(Guid gID, Guid gCURRENCY_ID, Guid gACCOUNT_ID, Guid gCREDIT_CARD_ID, string sClientIP, string sOrderID, string sDESCRIPTION, string sTransactionType, Decimal dAMOUNT, string sTransactionID, string sPaymentGateway, string sPaymentGateway_Login, string sPaymentGateway_Password, bool bPaymentGateway_TestMode)
		{
			string sLibrary = Sql.ToString(Application["CONFIG.PaymentGateway.Library"]);
			if( sLibrary == "dotnetCharge" || Sql.IsEmptyString(sLibrary) )
			{
				DotNetCharge.CC DotNetCharge = new DotNetCharge.CC(Security, Sql, SqlProcs);
				return DotNetCharge.Charge(gID, gCURRENCY_ID, gACCOUNT_ID, gCREDIT_CARD_ID, sClientIP, sOrderID, sDESCRIPTION, sTransactionType, dAMOUNT, sTransactionID, sPaymentGateway, sPaymentGateway_Login, sPaymentGateway_Password, bPaymentGateway_TestMode);
			}
			else if ( sLibrary == "nsoftware.InPayWeb" )
			{
				// 12/16/2015 Paul.  Echeck will not be used now that we have customerProfiles working. 
				//string sCARD_TYPE = String.Empty;
				//DbProviderFactory dbf = DbProviderFactories.GetFactory();
				//using ( IDbConnection con = dbf.CreateConnection() )
				//{
				//	con.Open();
				//	string sSQL ;
				//	sSQL = "select CARD_TYPE          " + ControlChars.CrLf
				//	     + "  from vwCREDIT_CARDS_Edit" + ControlChars.CrLf
				//	     + " where ID = @ID           " + ControlChars.CrLf;
				//	using ( IDbCommand cmd = con.CreateCommand() )
				//	{
				//		cmd.CommandText = sSQL;
				//		Sql.AddParameter(cmd, "@ID", gCREDIT_CARD_ID);
				//		sCARD_TYPE = Sql.ToString(cmd.ExecuteScalar());
				//	}
				//}
				//if ( sCARD_TYPE.StartsWith("Bank Draft") )
				//	return SplendidCRM.SplendidCharge.NSoftware.Echeck.eCheck(gID, gCURRENCY_ID, gACCOUNT_ID, gCREDIT_CARD_ID, sClientIP, sOrderID, sDESCRIPTION, sTransactionType, dAMOUNT, sTransactionID, sPaymentGateway, sPaymentGateway_Login, sPaymentGateway_Password, bPaymentGateway_TestMode);
				//else
				Icharge Icharge = new Icharge(Security, Sql, SqlProcs);
					return Icharge.Charge(gID, gCURRENCY_ID, gACCOUNT_ID, gCREDIT_CARD_ID, sClientIP, sOrderID, sDESCRIPTION, sTransactionType, dAMOUNT, sTransactionID, sPaymentGateway, sPaymentGateway_Login, sPaymentGateway_Password, bPaymentGateway_TestMode);
			}
			throw(new Exception("Payment Gateway Library not supported: " + sLibrary));
		}

		public /*static*/ void StoreCreditCard(ref string sCARD_TOKEN, string sNAME, string sCARD_TYPE, string sCARD_NUMBER, string sSECURITY_CODE, string sBANK_NAME, string sBANK_ROUTING_NUMBER, int nEXPIRATION_MONTH, int nEXPIRATION_YEAR, string sADDRESS_STREET, string sADDRESS_CITY, string sADDRESS_STATE, string sADDRESS_POSTALCODE, string sADDRESS_COUNTRY, string sEMAIL, string sPHONE)
		{
			string sLibrary = Sql.ToString(Application["CONFIG.PaymentGateway.Library"]);
			if( sLibrary == "dotnetCharge" || Sql.IsEmptyString(sLibrary) )
			{
				// 12/15/2015 Paul.  DotNetCharge has not been coded to support card tokens. 
				Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
				Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
				sCARD_TOKEN = Security.EncryptPassword(sCARD_NUMBER, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			}
			else if ( sLibrary == "nsoftware.InPayWeb" )
			{
				string sPaymentGateway          = Sql.ToString (Application["CONFIG.PaymentGateway"         ]);
				string sPaymentGateway_Login    = Sql.ToString (Application["CONFIG.PaymentGateway_Login"   ]);
				string sPaymentGateway_Password = Sql.ToString (Application["CONFIG.PaymentGateway_Password"]);
				bool   bPaymentGateway_TestMode = Sql.ToBoolean(Application["CONFIG.PaymentGateway_TestMode"]);
				Recurringbilling Recurringbilling = new Recurringbilling(Security, Sql, SqlProcs);
				Recurringbilling.StoreCreditCard(ref sCARD_TOKEN, sNAME, sCARD_TYPE, sCARD_NUMBER, sSECURITY_CODE, sBANK_NAME, sBANK_ROUTING_NUMBER, nEXPIRATION_MONTH, nEXPIRATION_YEAR, sADDRESS_STREET, sADDRESS_CITY, sADDRESS_STATE, sADDRESS_POSTALCODE, sADDRESS_COUNTRY, sEMAIL, sPHONE, sPaymentGateway, sPaymentGateway_Login, sPaymentGateway_Password, bPaymentGateway_TestMode);
			}
			else
			{
				throw(new Exception("Payment Gateway Library not supported: " + sLibrary));
			}
		}
	}
}

namespace SplendidCRM.SplendidCharge.NSoftware
{
	#region Enums
	public enum IchargeGateways
	{
		gwNoGateway = 0,
		gwAuthorizeNet = 1,
		gwEprocessing = 2,
		gwIntellipay = 3,
		gwITransact = 4,
		gwNetBilling = 5,
		gwPayFlowPro = 6,
		gwUSAePay = 7,
		gwPlugNPay = 8,
		gwPlanetPayment = 9,
		gwMPCS = 10,
		gwRTWare = 11,
		gwECX = 12,
		gwBankOfAmerica = 13,
		gwInnovative = 14,
		gwMerchantAnywhere = 15,
		gwSkipjack = 16,
		gwIntuitPaymentSolutions = 17,
		gw3DSI = 18,
		gwTrustCommerce = 19,
		gwPSIGate = 20,
		gwPayFuse = 21,
		gwPayFlowLink = 22,
		gwOrbital = 23,
		gwLinkPoint = 24,
		gwMoneris = 25,
		gwUSight = 26,
		gwFastTransact = 27,
		gwNetworkMerchants = 28,
		gwOgone = 29,
		gwPRIGate = 30,
		gwMerchantPartners = 31,
		gwCyberCash = 32,
		gwFirstData = 33,
		gwYourPay = 34,
		gwACHPayments = 35,
		gwPaymentsGateway = 36,
		gwCyberSource = 37,
		gwEway = 38,
		gwGoEMerchant = 39,
		gwTransFirst = 40,
		gwChase = 41,
		gwNexCommerce = 42,
		gwWorldPay = 43,
		gwTransactionCentral = 44,
		gwSterling = 45,
		gwPayJunction = 46,
		gwSECPay = 47,
		gwPaymentExpress = 48,
		gwMyVirtualMerchant = 49,
		gwSagePayments = 50,
		gwSecurePay = 51,
		gwMonerisUSA = 52,
		gwBeanstream = 53,
		gwVerifi = 54,
		gwSagePay = 55,
		gwMerchantESolutions = 56,
		gwPayLeap = 57,
		gwPayPoint = 58,
		gwWorldPayXML = 59,
		gwProPay = 60,
		gwQBMS = 61,
		gwHeartland = 62,
		gwLitle = 63,
		gwBrainTree = 64,
		gwJetPay = 65,
		gwHSBC = 66,
		gwBluePay = 67,
		gwAdyen = 68,
		gwBarclay = 69,
		gwPayTrace = 70,
		gwYKC = 71,
		gwCyberbit = 72,
		gwGoToBilling = 73,
		gwTransNationalBankcard = 74,
		gwNetbanx = 75,
		gwMIT = 76,
		gwDataCash = 77,
		gwACHFederal = 78,
		gwGlobalIris = 79,
		gwFirstDataE4 = 80,
		gwFirstAtlantic = 81,
		gwBluefin = 82,
		gwPayscape = 83,
		gwPayDirect = 84,
		gwAuthorizeNetCIM = 85,
		gw5thDimension = 86,
		gwWorldPayLink = 87,
		gwPaymentWorkSuite = 88,
		gwPSIGateXML = 89,
		gwFirstDataPayPoint = 90,
		gwExPay = 91,
		gwPayvision = 92,
		gwConverge = 93,
		gwPayeezy = 94,
	}

	public enum TCardTypes
	{
		ctUnknown = 0,
		ctVisa = 1,
		ctMasterCard = 2,
		ctAMEX = 3,
		ctDiscover = 4,
		ctDiners = 5,
		ctJCB = 6,
		ctVisaElectron = 7,
		ctMaestro = 8,
		ctLaser = 10,
	}

	public enum CCCVVPresences
	{
		cvpNotProvided = 0,
		cvpProvided = 1,
		cvpIllegible = 2,
		cvpNotOnCard = 3,
	}

	public enum EcheckGateways
	{
		gwNoGateway = 0,
		gwAuthorizeNet = 1,
		gwEprocessing = 2,
		gwIntellipay = 3,
		gwITransact = 4,
		gwNetBilling = 5,
		gwPayFlowPro = 6,
		gwUSAePay = 7,
		gwPlugNPay = 8,
		gwPlanetPayment = 9,
		gwMPCS = 10,
		gwRTWare = 11,
		gwECX = 12,
		gwBankOfAmerica = 13,
		gwInnovative = 14,
		gwMerchantAnywhere = 15,
		gwSkipjack = 16,
		gwIntuitPaymentSolutions = 17,
		gw3DSI = 18,
		gwTrustCommerce = 19,
		gwPSIGate = 20,
		gwPayFuse = 21,
		gwPayFlowLink = 22,
		gwOrbital = 23,
		gwLinkPoint = 24,
		gwMoneris = 25,
		gwUSight = 26,
		gwFastTransact = 27,
		gwNetworkMerchants = 28,
		gwOgone = 29,
		gwPRIGate = 30,
		gwMerchantPartners = 31,
		gwCyberCash = 32,
		gwFirstData = 33,
		gwYourPay = 34,
		gwACHPayments = 35,
		gwPaymentsGateway = 36,
		gwCyberSource = 37,
		gwEway = 38,
		gwGoEMerchant = 39,
		gwTransFirst = 40,
		gwChase = 41,
		gwNexCommerce = 42,
		gwWorldPay = 43,
		gwTransactionCentral = 44,
		gwSterling = 45,
		gwPayJunction = 46,
		gwSECPay = 47,
		gwPaymentExpress = 48,
		gwMyVirtualMerchant = 49,
		gwSagePayments = 50,
		gwSecurePay = 51,
		gwMonerisUSA = 52,
		gwBeanstream = 53,
		gwVerifi = 54,
		gwSagePay = 55,
		gwMerchantESolutions = 56,
		gwPayLeap = 57,
		gwPayPoint = 58,
		gwWorldPayXML = 59,
		gwProPay = 60,
		gwQBMS = 61,
		gwHeartland = 62,
		gwLitle = 63,
		gwBrainTree = 64,
		gwJetPay = 65,
		gwHSBC = 66,
		gwBluePay = 67,
		gwAdyen = 68,
		gwBarclay = 69,
		gwPayTrace = 70,
		gwYKC = 71,
		gwCyberbit = 72,
		gwGoToBilling = 73,
		gwTransNationalBankcard = 74,
		gwNetbanx = 75,
		gwMIT = 76,
		gwDataCash = 77,
		gwACHFederal = 78,
		gwGlobalIris = 79,
		gwFirstDataE4 = 80,
		gwFirstAtlantic = 81,
		gwBluefin = 82,
		gwPayscape = 83,
		gwPayDirect = 84,
		gwAuthorizeNetCIM = 85,
		gw5thDimension = 86,
		gwWorldPayLink = 87,
		gwPaymentWorkSuite = 88,
		gwPSIGateXML = 89,
		gwFirstDataPayPoint = 90,
		gwExPay = 91,
		gwPayvision = 92,
		gwConverge = 93,
		gwPayeezy = 94,
	}

	public enum EcheckPaymentTypes
	{
		ptWEB = 0,
		ptPPD = 1,
		ptTEL = 2,
		ptCCD = 3,
		ptARC = 4,
		ptBOC = 5,
		ptPOP = 6,
		ptRCK = 7,
	}

	public enum AccountClass
	{
		acPersonal = 0,
		acBusiness = 1,
	}

	public enum AccountTypes
	{
		atChecking = 0,
		atSavings = 1,
	}

	public enum RecurringbillingECheckPaymentTypes
	{
		ptWEB = 0,
		ptPPD = 1,
		ptTEL = 2,
		ptCCD = 3,
		ptARC = 4,
		ptBOC = 5,
		ptPOP = 6,
		ptRCK = 7,
	}

	public enum RecurringbillingGateways
	{
		gwNoGateway = 0,
		gwAuthorizeNet = 1,
		gwEprocessing = 2,
		gwITransact = 4,
		gwPayFlowPro = 6,
		gwUSAePay = 7,
		gwPlugNPay = 8,
		gwPlanetPayment = 9,
		gwMerchantAnywhere = 15,
		gwSkipjack = 16,
		gwOrbital = 23,
		gwLinkPoint = 24,
		gwMoneris = 25,
		gwNetworkMerchants = 28,
		gwPRIGate = 30,
		gwMerchantPartners = 31,
		gwFirstData = 33,
		gwYourPay = 34,
		gwACHPayments = 35,
		gwPaymentsGateway = 36,
		gwCyberSource = 37,
		gwEway = 38,
		gwChase = 41,
		gwNexCommerce = 42,
		gwTransactionCentral = 44,
		gwMyVirtualMerchant = 49,
		gwMonerisUSA = 52,
		gwBeanstream = 53,
		gwVerifi = 54,
		gwQBMS = 61,
		gwLitle = 63,
		gwPayTrace = 70,
		gwGoToBilling = 73,
		gwTransNationalBankcard = 74,
		gwPayscape = 83,
		gwAuthorizeNetCIM = 85,
		gwWorldPayLink = 87,
		gwPaymentWorkSuite = 88,
		gwFirstDataPayPoint = 90,
		gwConverge = 93,
	}

	public enum EntryDataSources
	{
		edsTrack1 = 0,
		edsTrack2 = 1,
		edsManualEntryTrack1Capable = 2,
		edsManualEntryTrack2Capable = 3,
		edsManualEntryNoCardReader = 4,
		edsTrack1Contactless = 5,
		edsTrack2Contactless = 6,
		edsManualEntryContactlessCapable = 7,
		edsIVR = 8,
		edsKiosk = 9,
	}
	#endregion

	#region Dynamic Objects
	// 12/12/2015 Paul.  Use late loading so that we do not have to link to the N Software DLL. 
	public class LateLoadObject
	{
		protected Assembly    m_asm;
		protected System.Type m_typ;
		protected object      m_obj;

		#region _SetValue
		protected void _SetValue(string name, string value)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				info.SetValue(m_obj, value, null);
			}
		}

		protected void _SetValue(string name, string value, ref string refValue)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				info.SetValue(m_obj, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, int value, ref int refValue)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				info.SetValue(m_obj, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, long value, ref long refValue)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				info.SetValue(m_obj, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, double value, ref double refValue)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				info.SetValue(m_obj, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, bool value, ref bool refValue)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				info.SetValue(m_obj, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, DateTime value, ref DateTime refValue)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				info.SetValue(m_obj, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, object value, ref object refValue)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				info.SetValue(m_obj, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, IchargeGateways value, ref IchargeGateways refValue)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.IchargeGateways");
				PropertyInfo info = m_typ.GetProperty(name);
				object eValue = Enum.Parse(typEnum, Enum.GetName(typeof(IchargeGateways), value));
				info.SetValue(m_obj, eValue, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, TCardTypes value, ref TCardTypes refValue)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.TCardTypes");
				PropertyInfo info = m_typ.GetProperty(name);
				object eValue = Enum.Parse(typEnum, Enum.GetName(typeof(TCardTypes), value));
				info.SetValue(m_obj, eValue, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, CCCVVPresences value, ref CCCVVPresences refValue)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.CCCVVPresences");
				PropertyInfo info = m_typ.GetProperty(name);
				object eValue = Enum.Parse(typEnum, Enum.GetName(typeof(CCCVVPresences), value));
				info.SetValue(m_obj, eValue, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, EcheckGateways value, ref EcheckGateways refValue)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.EcheckGateways");
				PropertyInfo info = m_typ.GetProperty(name);
				object eValue = Enum.Parse(typEnum, Enum.GetName(typeof(EcheckGateways), value));
				info.SetValue(m_obj, eValue, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, EcheckPaymentTypes value, ref EcheckPaymentTypes refValue)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.EcheckPaymentTypes");
				PropertyInfo info = m_typ.GetProperty(name);
				object eValue = Enum.Parse(typEnum, Enum.GetName(typeof(EcheckPaymentTypes), value));
				info.SetValue(m_obj, eValue, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, AccountClass value, ref AccountClass refValue)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.AccountClass");
				PropertyInfo info = m_typ.GetProperty(name);
				object eValue = Enum.Parse(typEnum, Enum.GetName(typeof(AccountClass), value));
				info.SetValue(m_obj, eValue, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, AccountTypes value, ref AccountTypes refValue)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.AccountTypes");
				PropertyInfo info = m_typ.GetProperty(name);
				object eValue = Enum.Parse(typEnum, Enum.GetName(typeof(AccountTypes), value));
				info.SetValue(m_obj, eValue, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, RecurringbillingECheckPaymentTypes value, ref RecurringbillingECheckPaymentTypes refValue)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.RecurringbillingECheckPaymentTypes");
				PropertyInfo info = m_typ.GetProperty(name);
				object eValue = Enum.Parse(typEnum, Enum.GetName(typeof(RecurringbillingECheckPaymentTypes), value));
				info.SetValue(m_obj, eValue, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, RecurringbillingGateways value, ref RecurringbillingGateways refValue)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.RecurringbillingGateways");
				PropertyInfo info = m_typ.GetProperty(name);
				object eValue = Enum.Parse(typEnum, Enum.GetName(typeof(RecurringbillingGateways), value));
				info.SetValue(m_obj, eValue, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, EntryDataSources value, ref EntryDataSources refValue)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.EntryDataSources");
				PropertyInfo info = m_typ.GetProperty(name);
				object eValue = Enum.Parse(typEnum, Enum.GetName(typeof(EntryDataSources), value));
				info.SetValue(m_obj, eValue, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, CCCard value, ref CCCard refValue)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				info.SetValue(m_obj, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, EPCustomer value, ref EPCustomer refValue)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				info.SetValue(m_obj, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, EPBank value, ref EPBank refValue)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				info.SetValue(m_obj, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, EPPaymentSchedule value, ref EPPaymentSchedule refValue)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				info.SetValue(m_obj, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		protected void _SetValue(string name, EPShipInfo value, ref EPShipInfo refValue)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				info.SetValue(m_obj, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		#endregion

		#region GetValue
		protected string _GetValue(string name, string value)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				return info.GetValue(m_obj, null) as string;
			}
			return value;
		}

		protected int _GetValue(string name, int value)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				return (int) info.GetValue(m_obj, null);
			}
			return value;
		}

		protected long _GetValue(string name, long value)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				return (long) info.GetValue(m_obj, null);
			}
			return value;
		}

		protected double _GetValue(string name, double value)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				return (double) info.GetValue(m_obj, null);
			}
			return value;
		}

		protected bool _GetValue(string name, bool value)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				return (bool) info.GetValue(m_obj, null);
			}
			return value;
		}

		protected DateTime _GetValue(string name, DateTime value)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				return (DateTime) info.GetValue(m_obj, null);
			}
			return value;
		}

		protected object _GetValue(string name, object value)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				return info.GetValue(m_obj, null);
			}
			return value;
		}

		public IchargeGateways _GetValue(string name, IchargeGateways value)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.IchargeGateways");
				PropertyInfo info = m_typ.GetProperty(name);
				return (IchargeGateways) Enum.Parse(typeof(IchargeGateways), Enum.GetName(typEnum, info.GetValue(m_obj, null)));
			}
			return value;
		}

		public TCardTypes _GetValue(string name, TCardTypes value)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.TCardTypes");
				PropertyInfo info = m_typ.GetProperty(name);
				return (TCardTypes) Enum.Parse(typeof(TCardTypes), Enum.GetName(typEnum, info.GetValue(m_obj, null)));
			}
			return value;
		}

		public CCCVVPresences _GetValue(string name, CCCVVPresences value)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.CCCVVPresences");
				PropertyInfo info = m_typ.GetProperty(name);
				return (CCCVVPresences) Enum.Parse(typeof(CCCVVPresences), Enum.GetName(typEnum, info.GetValue(m_obj, null)));
			}
			return value;
		}

		public EcheckGateways _GetValue(string name, EcheckGateways value)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.EcheckGateways");
				PropertyInfo info = m_typ.GetProperty(name);
				return (EcheckGateways) Enum.Parse(typeof(EcheckGateways), Enum.GetName(typEnum, info.GetValue(m_obj, null)));
			}
			return value;
		}

		public EcheckPaymentTypes _GetValue(string name, EcheckPaymentTypes value)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.EcheckPaymentTypes");
				PropertyInfo info = m_typ.GetProperty(name);
				return (EcheckPaymentTypes) Enum.Parse(typeof(EcheckPaymentTypes), Enum.GetName(typEnum, info.GetValue(m_obj, null)));
			}
			return value;
		}

		public AccountTypes _GetValue(string name, AccountTypes value)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.AccountTypes");
				PropertyInfo info = m_typ.GetProperty(name);
				return (AccountTypes) Enum.Parse(typeof(AccountTypes), Enum.GetName(typEnum, info.GetValue(m_obj, null)));
			}
			return value;
		}

		public AccountClass _GetValue(string name, AccountClass value)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.AccountClass");
				PropertyInfo info = m_typ.GetProperty(name);
				return (AccountClass) Enum.Parse(typeof(AccountClass), Enum.GetName(typEnum, info.GetValue(m_obj, null)));
			}
			return value;
		}

		public RecurringbillingECheckPaymentTypes _GetValue(string name, RecurringbillingECheckPaymentTypes value)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.RecurringbillingECheckPaymentTypes");
				PropertyInfo info = m_typ.GetProperty(name);
				return (RecurringbillingECheckPaymentTypes) Enum.Parse(typeof(RecurringbillingECheckPaymentTypes), Enum.GetName(typEnum, info.GetValue(m_obj, null)));
			}
			return value;
		}

		public RecurringbillingGateways _GetValue(string name, RecurringbillingGateways value)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.RecurringbillingGateways");
				PropertyInfo info = m_typ.GetProperty(name);
				return (RecurringbillingGateways) Enum.Parse(typeof(RecurringbillingGateways), Enum.GetName(typEnum, info.GetValue(m_obj, null)));
			}
			return value;
		}

		public EntryDataSources _GetValue(string name, EntryDataSources value)
		{
			if ( m_obj != null )
			{
				Type typEnum = m_asm.GetType("nsoftware.InPay.EntryDataSources");
				PropertyInfo info = m_typ.GetProperty(name);
				return (EntryDataSources) Enum.Parse(typeof(EntryDataSources), Enum.GetName(typEnum, info.GetValue(m_obj, null)));
			}
			return value;
		}

		protected CCCard _GetValue(string name, CCCard value)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				return info.GetValue(m_obj, null) as CCCard;
			}
			return value;
		}

		protected EPCustomer _GetValue(string name, EPCustomer value)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				return info.GetValue(m_obj, null) as EPCustomer;
			}
			return value;
		}

		protected EPBank _GetValue(string name, EPBank value)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				return info.GetValue(m_obj, null) as EPBank;
			}
			return value;
		}

		protected EPPaymentSchedule _GetValue(string name, EPPaymentSchedule value)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				return info.GetValue(m_obj, null) as EPPaymentSchedule;
			}
			return value;
		}

		protected EPShipInfo _GetValue(string name, EPShipInfo value)
		{
			if ( m_obj != null )
			{
				PropertyInfo info = m_typ.GetProperty(name);
				return info.GetValue(m_obj, null) as EPShipInfo;
			}
			return value;
		}
		#endregion

	}

	public class EPCard : LateLoadObject
	{
		public string         m_Aggregate  ;
		public TCardTypes     m_CardType   ;
		public string         m_CVVData    ;
		public CCCVVPresences m_CVVPresence;
		public int            m_ExpMonth   ;
		public int            m_ExpYear    ;
		public string         m_Number     ;

		public string         Aggregate   { get { return _GetValue("Aggregate"   , m_Aggregate   ); } set { _SetValue("Aggregate"   , value, ref m_Aggregate   ); } }
		public TCardTypes     CardType    { get { return _GetValue("CardType"    , m_CardType    ); } set { _SetValue("CardType"    , value, ref m_CardType    ); } }
		public string         CVVData     { get { return _GetValue("CVVData"     , m_CVVData     ); } set { _SetValue("CVVData"     , value, ref m_CVVData     ); } }
		public CCCVVPresences CVVPresence { get { return _GetValue("CVVPresence" , m_CVVPresence ); } set { _SetValue("CVVPresence" , value, ref m_CVVPresence ); } }
		public int            ExpMonth    { get { return _GetValue("ExpMonth"    , m_ExpMonth    ); } set { _SetValue("ExpMonth"    , value, ref m_ExpMonth    ); } }
		public int            ExpYear     { get { return _GetValue("ExpYear"     , m_ExpYear     ); } set { _SetValue("ExpYear"     , value, ref m_ExpYear     ); } }
		public string         Number      { get { return _GetValue("Number"      , m_Number      ); } set { _SetValue("Number"      , value, ref m_Number      ); } }

		public EPCard(Assembly asm, System.Type typ, object obj)
		{
			m_asm = asm;
			m_typ = typ;
			m_obj = obj;
		}

		public EPCard()
		{
			#pragma warning disable 618
			m_asm = Assembly.LoadWithPartialName("nsoftware.InPayWeb");
			#pragma warning restore 618
			if ( m_asm != null )
			{
				m_typ = m_asm.GetType("nsoftware.InPay.EPCard");
				if ( m_typ != null )
				{
					ConstructorInfo info = m_typ.GetConstructor(new Type[0]);
					m_obj = info.Invoke(null);
				}
			}
			else
			{
				throw(new Exception("Failed to load nsoftware.InPayWeb.dll"));
			}
		}
	}

	public class EPBank : LateLoadObject
	{
		public AccountClass m_AccountClass      ;
		public string       m_AccountHolderName ;
		public string       m_AccountNumber     ;
		public AccountTypes m_AccountType       ;
		public string       m_Name              ;
		public string       m_RoutingNumber     ;

		public AccountClass AccountClass      { get { return _GetValue("AccountClass"     , m_AccountClass     ); } set { _SetValue("AccountClass"     , value, ref m_AccountClass     ); } }
		public string       AccountHolderName { get { return _GetValue("AccountHolderName", m_AccountHolderName); } set { _SetValue("AccountHolderName", value, ref m_AccountHolderName); } }
		public string       AccountNumber     { get { return _GetValue("AccountNumber"    , m_AccountNumber    ); } set { _SetValue("AccountNumber"    , value, ref m_AccountNumber    ); } }
		public AccountTypes AccountType       { get { return _GetValue("AccountType"      , m_AccountType      ); } set { _SetValue("AccountType"      , value, ref m_AccountType      ); } }
		public string       Name              { get { return _GetValue("Name"             , m_Name             ); } set { _SetValue("Name"             , value, ref m_Name             ); } }
		public string       RoutingNumber     { get { return _GetValue("RoutingNumber"    , m_RoutingNumber    ); } set { _SetValue("RoutingNumber"    , value, ref m_RoutingNumber    ); } }

		public EPBank(Assembly asm, System.Type typ, object obj)
		{
			m_asm = asm;
			m_typ = typ;
			m_obj = obj;
		}

		public EPBank()
		{
			#pragma warning disable 618
			m_asm = Assembly.LoadWithPartialName("nsoftware.InPayWeb");
			#pragma warning restore 618
			if ( m_asm != null )
			{
				m_typ = m_asm.GetType("nsoftware.InPay.EPBank");
				if ( m_typ != null )
				{
					ConstructorInfo info = m_typ.GetConstructor(new Type[0]);
					m_obj = info.Invoke(null);
				}
			}
			else
			{
				throw(new Exception("Failed to load nsoftware.InPayWeb.dll"));
			}
		}
	}

	public class EPCustomer : LateLoadObject
	{
		public string m_Address   ;
		public string m_Address2  ;
		public string m_Aggregate ;
		public string m_City      ;
		public string m_Country   ;
		public string m_Email     ;
		public string m_Fax       ;
		public string m_FirstName ;
		public string m_FullName  ;
		public string m_Id        ;
		public string m_LastName  ;
		public string m_Phone     ;
		public string m_State     ;
		public string m_Zip       ;

		public string Address   { get { return _GetValue("Address"   , m_Address   ); } set { _SetValue("Address"   , value, ref m_Address   ); } }
		public string Address2  { get { return _GetValue("Address2"  , m_Address2  ); } set { _SetValue("Address2"  , value, ref m_Address2  ); } }
		public string Aggregate { get { return _GetValue("Aggregate" , m_Aggregate ); } set { _SetValue("Aggregate" , value, ref m_Aggregate ); } }
		public string City      { get { return _GetValue("City"      , m_City      ); } set { _SetValue("City"      , value, ref m_City      ); } }
		public string Country   { get { return _GetValue("Country"   , m_Country   ); } set { _SetValue("Country"   , value, ref m_Country   ); } }
		public string Email     { get { return _GetValue("Email"     , m_Email     ); } set { _SetValue("Email"     , value, ref m_Email     ); } }
		public string Fax       { get { return _GetValue("Fax"       , m_Fax       ); } set { _SetValue("Fax"       , value, ref m_Fax       ); } }
		public string FirstName { get { return _GetValue("FirstName" , m_FirstName ); } set { _SetValue("FirstName" , value, ref m_FirstName ); } }
		public string FullName  { get { return _GetValue("FullName"  , m_FullName  ); } set { _SetValue("FullName"  , value, ref m_FullName  ); } }
		public string Id        { get { return _GetValue("Id"        , m_Id        ); } set { _SetValue("Id"        , value, ref m_Id        ); } }
		public string LastName  { get { return _GetValue("LastName"  , m_LastName  ); } set { _SetValue("LastName"  , value, ref m_LastName  ); } }
		public string Phone     { get { return _GetValue("Phone"     , m_Phone     ); } set { _SetValue("Phone"     , value, ref m_Phone     ); } }
		public string State     { get { return _GetValue("State"     , m_State     ); } set { _SetValue("State"     , value, ref m_State     ); } }
		public string Zip       { get { return _GetValue("Zip"       , m_Zip       ); } set { _SetValue("Zip"       , value, ref m_Zip       ); } }

		public EPCustomer(Assembly asm, System.Type typ, object obj)
		{
			m_asm = asm;
			m_typ = typ;
			m_obj = obj;
		}

		public EPCustomer()
		{
			#pragma warning disable 618
			m_asm = Assembly.LoadWithPartialName("nsoftware.InPayWeb");
			#pragma warning restore 618
			if ( m_asm != null )
			{
				m_typ = m_asm.GetType("nsoftware.InPay.EPCustomer");
				if ( m_typ != null )
				{
					ConstructorInfo info = m_typ.GetConstructor(new Type[0]);
					m_obj = info.Invoke(null);
				}
			}
			else
			{
				throw(new Exception("Failed to load nsoftware.InPayWeb.dll"));
			}
		}
	}

	public class EPResponse : LateLoadObject
	{
		public string m_ApprovalCode   ;
		public bool   m_Approved       ;
		public string m_ApprovedAmount ;
		public string m_AVSResult      ;
		public string m_Code           ;
		public string m_CVVResult      ;
		public string m_Data           ;
		public string m_ErrorCode      ;
		public string m_ErrorText      ;
		public string m_InvoiceNumber  ;
		public string m_ProcessorCode  ;
		public string m_Text           ;
		public string m_TransactionId  ;

		public string ApprovalCode   { get { return _GetValue("ApprovalCode"   , m_ApprovalCode   ); } }
		public bool   Approved       { get { return _GetValue("Approved"       , m_Approved       ); } }
		public string ApprovedAmount { get { return _GetValue("ApprovedAmount" , m_ApprovedAmount ); } }
		public string AVSResult      { get { return _GetValue("AVSResult"      , m_AVSResult      ); } }
		public string Code           { get { return _GetValue("Code"           , m_Code           ); } }
		public string CVVResult      { get { return _GetValue("CVVResult"      , m_CVVResult      ); } }
		public string Data           { get { return _GetValue("Data"           , m_Data           ); } }
		public string ErrorCode      { get { return _GetValue("ErrorCode"      , m_ErrorCode      ); } }
		public string ErrorText      { get { return _GetValue("ErrorText"      , m_ErrorText      ); } }
		public string InvoiceNumber  { get { return _GetValue("InvoiceNumber"  , m_InvoiceNumber  ); } }
		public string ProcessorCode  { get { return _GetValue("ProcessorCode"  , m_ProcessorCode  ); } }
		public string Text           { get { return _GetValue("Text"           , m_Text           ); } }
		public string TransactionId  { get { return _GetValue("TransactionId"  , m_TransactionId  ); } }

		public EPResponse(Assembly asm, System.Type typ, object obj)
		{
			m_asm = asm;
			m_typ = typ;
			m_obj = obj;
		}
	}

	public class EPShipInfo : LateLoadObject
	{
		public string m_Address   ;
		public string m_Address2  ;
		public string m_City      ;
		public string m_Country   ;
		public string m_Email     ;
		public string m_FirstName ;
		public string m_LastName  ;
		public string m_Phone     ;
		public string m_State     ;
		public string m_Zip       ;

		public string Address   { get { return _GetValue("Address"   , m_Address   ); } set { _SetValue("Address"   , value, ref m_Address   ); } }
		public string Address2  { get { return _GetValue("Address2"  , m_Address2  ); } set { _SetValue("Address2"  , value, ref m_Address2  ); } }
		public string City      { get { return _GetValue("City"      , m_City      ); } set { _SetValue("City"      , value, ref m_City      ); } }
		public string Country   { get { return _GetValue("Country"   , m_Country   ); } set { _SetValue("Country"   , value, ref m_Country   ); } }
		public string Email     { get { return _GetValue("Email"     , m_Email     ); } set { _SetValue("Email"     , value, ref m_Email     ); } }
		public string FirstName { get { return _GetValue("FirstName" , m_FirstName ); } set { _SetValue("FirstName" , value, ref m_FirstName ); } }
		public string LastName  { get { return _GetValue("LastName"  , m_LastName  ); } set { _SetValue("LastName"  , value, ref m_LastName  ); } }
		public string Phone     { get { return _GetValue("Phone"     , m_Phone     ); } set { _SetValue("Phone"     , value, ref m_Phone     ); } }
		public string State     { get { return _GetValue("State"     , m_State     ); } set { _SetValue("State"     , value, ref m_State     ); } }
		public string Zip       { get { return _GetValue("Zip"       , m_Zip       ); } set { _SetValue("Zip"       , value, ref m_Zip       ); } }

		public EPShipInfo(Assembly asm, System.Type typ, object obj)
		{
			m_asm = asm;
			m_typ = typ;
			m_obj = obj;
		}
	}

	public class CCCard : LateLoadObject
	{
		public string           m_CVVData        ;
		public CCCVVPresences   m_CVVPresence    ;
		public EntryDataSources m_EntryDataSource;
		public int              m_ExpMonth       ;
		public int              m_ExpYear        ;
		public string           m_MagneticStripe ;
		public string           m_Number         ;

		public string           CVVData         { get { return _GetValue("CVVData"        , m_CVVData        ); } set { _SetValue("CVVData"        , value, ref m_CVVData        ); } }
		public CCCVVPresences   CVVPresence     { get { return _GetValue("CVVPresence"    , m_CVVPresence    ); } set { _SetValue("CVVPresence"    , value, ref m_CVVPresence    ); } }
		public EntryDataSources EntryDataSource { get { return _GetValue("EntryDataSource", m_EntryDataSource); } set { _SetValue("EntryDataSource", value, ref m_EntryDataSource); } }
		public int              ExpMonth        { get { return _GetValue("ExpMonth"       , m_ExpMonth       ); } set { _SetValue("ExpMonth"       , value, ref m_ExpMonth       ); } }
		public int              ExpYear         { get { return _GetValue("ExpYear"        , m_ExpYear        ); } set { _SetValue("ExpYear"        , value, ref m_ExpYear        ); } }
		public string           Number          { get { return _GetValue("Number"         , m_Number         ); } set { _SetValue("Number"         , value, ref m_Number         ); } }

		public CCCard(Assembly asm, System.Type typ, object obj)
		{
			m_asm = asm;
			m_typ = typ;
			m_obj = obj;
		}

		public CCCard()
		{
			#pragma warning disable 618
			m_asm = Assembly.LoadWithPartialName("nsoftware.InPayWeb");
			#pragma warning restore 618
			if ( m_asm != null )
			{
				m_typ = m_asm.GetType("nsoftware.InPay.CCCard");
				if ( m_typ != null )
				{
					ConstructorInfo info = m_typ.GetConstructor(new Type[0]);
					m_obj = info.Invoke(null);
				}
			}
			else
			{
				throw(new Exception("Failed to load nsoftware.InPayWeb.dll"));
			}
		}
	}

	public class EPPaymentSchedule : LateLoadObject
	{
		public string m_EndDate      ;
		public string m_Frequency    ;
		public string m_FrequencyUnit;
		public string m_InitialAmount;
		public string m_RecurAmount  ;
		public string m_StartDate    ;
		public int    m_TotalPayments;
		public int    m_TrialPayments;

		public string EndDate       { get { return _GetValue("EndDate"      , m_EndDate      ); } set { _SetValue("EndDate"      , value, ref m_EndDate      ); } }
		public string Frequency     { get { return _GetValue("Frequency"    , m_Frequency    ); } set { _SetValue("Frequency"    , value, ref m_Frequency    ); } }
		public string FrequencyUnit { get { return _GetValue("FrequencyUnit", m_FrequencyUnit); } set { _SetValue("FrequencyUnit", value, ref m_FrequencyUnit); } }
		public string InitialAmount { get { return _GetValue("InitialAmount", m_InitialAmount); } set { _SetValue("InitialAmount", value, ref m_InitialAmount); } }
		public string RecurAmount   { get { return _GetValue("RecurAmount"  , m_RecurAmount  ); } set { _SetValue("RecurAmount"  , value, ref m_RecurAmount  ); } }
		public string StartDate     { get { return _GetValue("StartDate"    , m_StartDate    ); } set { _SetValue("StartDate"    , value, ref m_StartDate    ); } }
		public int    TotalPayments { get { return _GetValue("TotalPayments", m_TotalPayments); } set { _SetValue("TotalPayments", value, ref m_TotalPayments); } }
		public int    TrialPayments { get { return _GetValue("TrialPayments", m_TrialPayments); } set { _SetValue("TrialPayments", value, ref m_TrialPayments); } }

			public EPPaymentSchedule(Assembly asm, System.Type typ, object obj)
		{
			m_asm = asm;
			m_typ = typ;
			m_obj = obj;
		}
	}

	public class EPRecurringResponse : LateLoadObject
	{
		public string m_ApprovalCode  ;
		public bool   m_Approved      ;
		public string m_AVSResult     ;
		public string m_Code          ;
		public string m_CVVResult     ;
		public string m_Data          ;
		public string m_ErrorCode     ;
		public string m_ErrorText     ;
		public string m_InvoiceNumber ;
		public string m_ProcessorCode ;
		public string m_SubscriptionId;
		public string m_Text          ;
		public string m_TransactionId ;

		public string ApprovalCode   { get { return _GetValue("ApprovalCode"  , m_ApprovalCode  ); } set { _SetValue("ApprovalCode"  , value, ref m_ApprovalCode  ); } }
		public bool   Approved       { get { return _GetValue("Approved"      , m_Approved      ); } set { _SetValue("Approved"      , value, ref m_Approved      ); } }
		public string AVSResult      { get { return _GetValue("AVSResult"     , m_AVSResult     ); } set { _SetValue("AVSResult"     , value, ref m_AVSResult     ); } }
		public string Code           { get { return _GetValue("Code"          , m_Code          ); } set { _SetValue("Code"          , value, ref m_Code          ); } }
		public string CVVResult      { get { return _GetValue("CVVResult"     , m_CVVResult     ); } set { _SetValue("CVVResult"     , value, ref m_CVVResult     ); } }
		public string Data           { get { return _GetValue("Data"          , m_Data          ); } set { _SetValue("Data"          , value, ref m_Data          ); } }
		public string ErrorCode      { get { return _GetValue("ErrorCode"     , m_ErrorCode     ); } set { _SetValue("ErrorCode"     , value, ref m_ErrorCode     ); } }
		public string ErrorText      { get { return _GetValue("ErrorText"     , m_ErrorText     ); } set { _SetValue("ErrorText"     , value, ref m_ErrorText     ); } }
		public string InvoiceNumber  { get { return _GetValue("InvoiceNumber" , m_InvoiceNumber ); } set { _SetValue("InvoiceNumber" , value, ref m_InvoiceNumber ); } }
		public string ProcessorCode  { get { return _GetValue("ProcessorCode" , m_ProcessorCode ); } set { _SetValue("ProcessorCode" , value, ref m_ProcessorCode ); } }
		public string SubscriptionId { get { return _GetValue("SubscriptionId", m_SubscriptionId); } set { _SetValue("SubscriptionId", value, ref m_SubscriptionId); } }
		public string Text           { get { return _GetValue("Text"          , m_Text          ); } set { _SetValue("Text"          , value, ref m_Text          ); } }
		public string TransactionId  { get { return _GetValue("TransactionId" , m_TransactionId ); } set { _SetValue("TransactionId" , value, ref m_TransactionId ); } }

		public EPRecurringResponse(Assembly asm, System.Type typ, object obj)
		{
			m_asm = asm;
			m_typ = typ;
			m_obj = obj;
		}
	}

	public class EPSubscriptionDetails : LateLoadObject
	{
		public int    m_CardExpMonth     ;
		public int    m_CardExpYear      ;
		public string m_CardNumber       ;
		public string m_EndDate          ;
		public string m_Frequency        ;
		public string m_FrequencyUnit    ;
		public string m_LastPaymentDate  ;
		public string m_NextPaymentDate  ;
		public string m_RecurAmount      ;
		public int    m_RemainingPayments;
		public string m_StartDate        ;
		public string m_Status           ;
		public string m_SubscriptionId   ;
		public string m_SubscriptionName ;
		public int    m_TotalPayments    ;

		public int    CardExpMonth      { get { return _GetValue("CardExpMonth"     , m_CardExpMonth     ); } set { _SetValue("CardExpMonth"     , value, ref m_CardExpMonth     ); } }
		public int    CardExpYear       { get { return _GetValue("CardExpYear"      , m_CardExpYear      ); } set { _SetValue("CardExpYear"      , value, ref m_CardExpYear      ); } }
		public string CardNumber        { get { return _GetValue("CardNumber"       , m_CardNumber       ); } set { _SetValue("CardNumber"       , value, ref m_CardNumber       ); } }
		public string EndDate           { get { return _GetValue("EndDate"          , m_EndDate          ); } set { _SetValue("EndDate"          , value, ref m_EndDate          ); } }
		public string Frequency         { get { return _GetValue("Frequency"        , m_Frequency        ); } set { _SetValue("Frequency"        , value, ref m_Frequency        ); } }
		public string FrequencyUnit     { get { return _GetValue("FrequencyUnit"    , m_FrequencyUnit    ); } set { _SetValue("FrequencyUnit"    , value, ref m_FrequencyUnit    ); } }
		public string LastPaymentDate   { get { return _GetValue("LastPaymentDate"  , m_LastPaymentDate  ); } set { _SetValue("LastPaymentDate"  , value, ref m_LastPaymentDate  ); } }
		public string NextPaymentDate   { get { return _GetValue("NextPaymentDate"  , m_NextPaymentDate  ); } set { _SetValue("NextPaymentDate"  , value, ref m_NextPaymentDate  ); } }
		public string RecurAmount       { get { return _GetValue("RecurAmount"      , m_RecurAmount      ); } set { _SetValue("RecurAmount"      , value, ref m_RecurAmount      ); } }
		public int    RemainingPayments { get { return _GetValue("RemainingPayments", m_RemainingPayments); } set { _SetValue("RemainingPayments", value, ref m_RemainingPayments); } }
		public string StartDate         { get { return _GetValue("StartDate"        , m_StartDate        ); } set { _SetValue("StartDate"        , value, ref m_StartDate        ); } }
		public string Status            { get { return _GetValue("Status"           , m_Status           ); } set { _SetValue("Status"           , value, ref m_Status           ); } }
		public string SubscriptionId    { get { return _GetValue("SubscriptionId"   , m_SubscriptionId   ); } set { _SetValue("SubscriptionId"   , value, ref m_SubscriptionId   ); } }
		public string SubscriptionName  { get { return _GetValue("SubscriptionName" , m_SubscriptionName ); } set { _SetValue("SubscriptionName" , value, ref m_SubscriptionName ); } }
		public int    TotalPayments     { get { return _GetValue("TotalPayments"    , m_TotalPayments    ); } set { _SetValue("TotalPayments"    , value, ref m_TotalPayments    ); } }

		public EPSubscriptionDetails(Assembly asm, System.Type typ, object obj)
		{
			m_asm = asm;
			m_typ = typ;
			m_obj = obj;
		}
	}
	#endregion

	public class Recurringbilling : LateLoadObject
	{
		#region Properties
		public string                             m_About              ;
		public CCCard                             m_Card               ;
		public EPCustomer                         m_Customer           ;
		public EPBank                             m_ECheckBank         ;
		public RecurringbillingECheckPaymentTypes m_ECheckPaymentType  ;
		public RecurringbillingGateways           m_Gateway            ;
		public string                             m_GatewayURL         ;
		public string                             m_InvoiceNumber      ;
		public string                             m_MerchantLogin      ;
		public string                             m_MerchantPassword   ;
		public EPPaymentSchedule                  m_PaymentSchedule    ;
		public EPRecurringResponse                m_Response           ;
		public string                             m_RuntimeLicense     ;
		public EPShipInfo                         m_ShippingInfo       ;
		//public Proxy                              m_Proxy              ;
		//public EPSpecialFieldList                 m_SpecialFields      ;
		//public Certificate                        m_SSLAcceptServerCert;
		//public Certificate                        m_SSLCert            ;
		//public Certificate                        m_SSLServerCert      ;
		public string                             m_SubscriptionDesc   ;
		public EPSubscriptionDetails              m_SubscriptionDetails;
		public string                             m_SubscriptionName   ;
		public object                             m_SyncRoot           ;
		public bool                               m_TestMode           ;
		public int                                m_Timeout            ;
		public string                             m_TransactionId      ;

		public string                             About              { get { return _GetValue("About"              , m_About              ); } set { _SetValue("About"              , value, ref m_About              ); } }
		public CCCard                             Card               { get { return m_Card               ; } }
		public EPCustomer                         Customer           { get { return m_Customer           ; } }
		public EPBank                             ECheckBank         { get { return m_ECheckBank         ; } }
		public RecurringbillingECheckPaymentTypes ECheckPaymentType  { get { return _GetValue("ECheckPaymentType"  , m_ECheckPaymentType  ); } set { _SetValue("ECheckPaymentType"  , value, ref m_ECheckPaymentType  ); } }
		public RecurringbillingGateways           Gateway            { get { return _GetValue("Gateway"            , m_Gateway            ); } set { _SetValue("Gateway"            , value, ref m_Gateway            ); } }
		public string                             GatewayURL         { get { return _GetValue("GatewayURL"         , m_GatewayURL         ); } set { _SetValue("GatewayURL"         , value, ref m_GatewayURL         ); } }
		public string                             InvoiceNumber      { get { return _GetValue("InvoiceNumber"      , m_InvoiceNumber      ); } set { _SetValue("InvoiceNumber"      , value, ref m_InvoiceNumber      ); } }
		public string                             MerchantLogin      { get { return _GetValue("MerchantLogin"      , m_MerchantLogin      ); } set { _SetValue("MerchantLogin"      , value, ref m_MerchantLogin      ); } }
		public string                             MerchantPassword   { get { return _GetValue("MerchantPassword"   , m_MerchantPassword   ); } set { _SetValue("MerchantPassword"   , value, ref m_MerchantPassword   ); } }
		public EPPaymentSchedule                  PaymentSchedule    { get { return m_PaymentSchedule    ; } }
		public EPRecurringResponse                Response           { get { return m_Response           ; } }
		public string                             RuntimeLicense     { get { return _GetValue("RuntimeLicense"     , m_RuntimeLicense     ); } set { _SetValue("RuntimeLicense"     , value, ref m_RuntimeLicense     ); } }
		public EPShipInfo                         ShippingInfo       { get { return m_ShippingInfo       ; } }
		//public Proxy                              Proxy              { get { return _GetValue("Proxy"              , m_Proxy              ); } set { _SetValue("Proxy"              , value, ref m_Proxy              ); } }
		//public EPSpecialFieldList                 SpecialFields      { get { return _GetValue("SpecialFields"      , m_SpecialFields      ); } set { _SetValue("SpecialFields"      , value, ref m_SpecialFields      ); } }
		//public Certificate                        SSLAcceptServerCert{ get { return _GetValue("SSLAcceptServerCert", m_SSLAcceptServerCert); } set { _SetValue("SSLAcceptServerCert", value, ref m_SSLAcceptServerCert); } }
		//public Certificate                        SSLCert            { get { return _GetValue("SSLCert"            , m_SSLCert            ); } set { _SetValue("SSLCert"            , value, ref m_SSLCert            ); } }
		//public Certificate                        SSLServerCert      { get { return _GetValue("SSLServerCert"      , m_SSLServerCert      ); } }
		public string                             SubscriptionDesc   { get { return _GetValue("SubscriptionDesc"   , m_SubscriptionDesc   ); } set { _SetValue("SubscriptionDesc"   , value, ref m_SubscriptionDesc   ); } }
		public EPSubscriptionDetails              SubscriptionDetails{ get { return m_SubscriptionDetails; } }
		public string                             SubscriptionName   { get { return _GetValue("SubscriptionName"   , m_SubscriptionName   ); } set { _SetValue("SubscriptionName"   , value, ref m_SubscriptionName   ); } }
		public object                             SyncRoot           { get { return _GetValue("SyncRoot"           , m_SyncRoot           ); } set { _SetValue("SyncRoot"           , value, ref m_SyncRoot           ); } }
		public bool                               TestMode           { get { return _GetValue("TestMode"           , m_TestMode           ); } set { _SetValue("TestMode"           , value, ref m_TestMode           ); } }
		public int                                Timeout            { get { return _GetValue("Timeout"            , m_Timeout            ); } set { _SetValue("Timeout"            , value, ref m_Timeout            ); } }
		public string                             TransactionId      { get { return _GetValue("TransactionId"      , m_TransactionId      ); } set { _SetValue("TransactionId"      , value, ref m_TransactionId      ); } }
		#endregion

		private DbProviderFactories  DbProviderFactories = new DbProviderFactories();
		private HttpApplicationState Application         = new HttpApplicationState();
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;

		public Recurringbilling(Security Security, Sql Sql, SqlProcs SqlProcs)
		{
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;

			#pragma warning disable 618
			m_asm = Assembly.LoadWithPartialName("nsoftware.InPayWeb");
			#pragma warning restore 618
			if ( m_asm != null )
			{
				m_typ = m_asm.GetType("nsoftware.InPay.Recurringbilling");
				if ( m_typ != null )
				{
					ConstructorInfo info = m_typ.GetConstructor(new Type[0]);
					m_obj = info.Invoke(null);
					m_Card                = new CCCard               (m_asm, m_asm.GetType("nsoftware.InPay.CCCard"               ), _GetValue("Card"               , null as object));
					m_Customer            = new EPCustomer           (m_asm, m_asm.GetType("nsoftware.InPay.EPCustomer"           ), _GetValue("Customer"           , null as object));
					m_ECheckBank          = new EPBank               (m_asm, m_asm.GetType("nsoftware.InPay.EPBank"               ), _GetValue("ECheckBank"         , null as object));
					m_PaymentSchedule     = new EPPaymentSchedule    (m_asm, m_asm.GetType("nsoftware.InPay.EPPaymentSchedule"    ), _GetValue("PaymentSchedule"    , null as object));
					m_Response            = new EPRecurringResponse  (m_asm, m_asm.GetType("nsoftware.InPay.EPRecurringResponse"  ), _GetValue("Response"           , null as object));
					m_ShippingInfo        = new EPShipInfo           (m_asm, m_asm.GetType("nsoftware.InPay.EPShipInfo"           ), _GetValue("ShippingInfo"       , null as object));
					m_SubscriptionDetails = new EPSubscriptionDetails(m_asm, m_asm.GetType("nsoftware.InPay.EPSubscriptionDetails"), _GetValue("SubscriptionDetails", null as object));
				}
			}
			else
			{
				throw(new Exception("Failed to load nsoftware.InPayWeb.dll"));
			}
		}

		#region Methods
		public void CreateSubscription()
		{
			if ( m_obj != null )
			{
				MethodInfo info = m_typ.GetMethod("CreateSubscription");
				info.Invoke(m_obj, null);
				m_Response = new EPRecurringResponse  (m_asm, m_asm.GetType("nsoftware.InPay.EPRecurringResponse"), _GetValue("Response", null as object));
			}
		}

		public void UpdateSubscription(string profileId)
		{
			if ( m_obj != null )
			{
				Type[] types = new Type[1];
				types[0] = Type.GetType("System.String");

				MethodInfo info = m_typ.GetMethod("UpdateSubscription", types);
				object[] parameters = new object[1];
				parameters[0] = profileId;
				info.Invoke(m_obj, parameters);
				m_Response = new EPRecurringResponse  (m_asm, m_asm.GetType("nsoftware.InPay.EPRecurringResponse"), _GetValue("Response", null as object));
			}
		}

		public void CancelSubscription(string subscriptionId)
		{
			if ( m_obj != null )
			{
				Type[] types = new Type[1];
				types[0] = Type.GetType("System.String");

				MethodInfo info = m_typ.GetMethod("CancelSubscription", types);
				object[] parameters = new object[1];
				parameters[0] = subscriptionId;
				info.Invoke(m_obj, parameters);
				m_Response = new EPRecurringResponse  (m_asm, m_asm.GetType("nsoftware.InPay.EPRecurringResponse"), _GetValue("Response", null as object));
			}
		}

		public string Config(string configurationString)
		{
			if ( m_obj != null )
			{
				Type[] types = new Type[1];
				types[0] = Type.GetType("System.String");

				MethodInfo info = m_typ.GetMethod("Config", types);
				object[] parameters = new object[1];
				parameters[0] = configurationString;
				return info.Invoke(m_obj, parameters) as string;
			}
			return String.Empty;
		}

		public void AddSpecialField(string name, string val)
		{
			if ( m_obj != null )
			{
				Type[] types = new Type[2];
				types[0] = Type.GetType("System.String");
				types[1] = Type.GetType("System.String");

				MethodInfo info = m_typ.GetMethod("AddSpecialField", types);
				object[] parameters = new object[2];
				parameters[0] = name;
				parameters[1] = val ;
				info.Invoke(m_obj, parameters);
				m_Response = new EPRecurringResponse  (m_asm, m_asm.GetType("nsoftware.InPay.EPRecurringResponse"), _GetValue("Response", null as object));
			}
		}
		#endregion

		// 12/15/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
		public /*static*/ void StoreCreditCard(ref string sCARD_TOKEN, string sNAME, string sCARD_TYPE, string sCARD_NUMBER, string sSECURITY_CODE, string sBANK_NAME, string sBANK_ROUTING_NUMBER, int nEXPIRATION_MONTH, int nEXPIRATION_YEAR, string sADDRESS_STREET, string sADDRESS_CITY, string sADDRESS_STATE, string sADDRESS_POSTALCODE, string sADDRESS_COUNTRY, string sEMAIL, string sPHONE, string sPaymentGateway, string sPaymentGateway_Login, string sPaymentGateway_Password, bool bPaymentGateway_TestMode)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);

			Recurringbilling oRecurring = this;
			oRecurring.MerchantLogin = sPaymentGateway_Login   ;
			if ( !Sql.IsEmptyString(sPaymentGateway_Password) )
				oRecurring.MerchantPassword = Security.DecryptPassword(sPaymentGateway_Password, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			if ( Sql.IsEmptyString(sPaymentGateway) )
				throw(new Exception("PaymentGateway has not been defined."));
			if ( sPaymentGateway == "gwAuthorizeNet" )
				sPaymentGateway = "gwAuthorizeNetCIM";
			oRecurring.Gateway = (RecurringbillingGateways)Enum.Parse(typeof(RecurringbillingGateways), sPaymentGateway);
			if ( oRecurring.Gateway == RecurringbillingGateways.gwAuthorizeNetCIM && bPaymentGateway_TestMode )
			{
				oRecurring.GatewayURL = "https://apitest.authorize.net/xml/v1/request.api";
				// 12/15/2015 Paul.  This gateway does not support TestMode. 
				// oRecurring.TestMode   = bPaymentGateway_TestMode;
			}
			if ( sCARD_TYPE.StartsWith("Bank Draft") )
			{
				//oRecurring.ECheckBank = new EPBank();
				if ( sCARD_TYPE == "Bank Draft - Checking" )
					oRecurring.ECheckBank.AccountType = AccountTypes.atChecking;
				else if ( sCARD_TYPE == "Bank Draft - Savings" )
					oRecurring.ECheckBank.AccountType = AccountTypes.atSavings;
				oRecurring.ECheckBank.AccountHolderName = sNAME               ;
				oRecurring.ECheckBank.AccountNumber     = sCARD_NUMBER        ;
				oRecurring.ECheckBank.Name              = sBANK_NAME          ;
				oRecurring.ECheckBank.RoutingNumber     = sBANK_ROUTING_NUMBER;
			}
			else
			{
				//oRecurring.Card = new CCCard();
				oRecurring.Card.Number          = sCARD_NUMBER     ;
				oRecurring.Card.ExpMonth        = nEXPIRATION_MONTH;
				oRecurring.Card.ExpYear         = nEXPIRATION_YEAR ;
				oRecurring.Card.CVVData         = sSECURITY_CODE   ;
				oRecurring.Card.CVVPresence     = (!Sql.IsEmptyString(sSECURITY_CODE) ? CCCVVPresences.cvpProvided : CCCVVPresences.cvpNotProvided);
				oRecurring.Card.EntryDataSource = EntryDataSources.edsManualEntryNoCardReader;
			}
			//oRecurring.Customer = new EPCustomer();
			oRecurring.Customer.FullName = sNAME;
			string[] arrName = oRecurring.Customer.FullName.Split(' ');
			oRecurring.Customer.LastName = arrName[arrName.Length-1];
			if ( arrName.Length > 1 )
				oRecurring.Customer.FirstName = arrName[0];
			oRecurring.Customer.Address = sADDRESS_STREET    ;
			oRecurring.Customer.City    = sADDRESS_CITY      ;
			oRecurring.Customer.State   = sADDRESS_STATE     ;
			oRecurring.Customer.Zip     = sADDRESS_POSTALCODE;
			oRecurring.Customer.Country = sADDRESS_COUNTRY   ;
			oRecurring.Customer.Email   = sEMAIL             ;
			oRecurring.Customer.Phone   = sPHONE             ;
			oRecurring.Config("AuthNetCIMRequestType=0"); // 0 = Profile, 1 = Payment Profile
			if ( !Sql.IsEmptyString(sCARD_TOKEN) )
			{
				string[] arrCARD_TOKEN = sCARD_TOKEN.Split(',');
				oRecurring.Config("AuthNetCIMPaymentProfileId=" + arrCARD_TOKEN[1]);
				oRecurring.UpdateSubscription(arrCARD_TOKEN[0]);
			}
			else
			{
				oRecurring.SubscriptionDesc = Guid.NewGuid().ToString();
				oRecurring.CreateSubscription();
			}
			
			if ( oRecurring.Response.Approved )
			{
				if ( !Sql.IsEmptyString(sCARD_TOKEN) )
					sCARD_TOKEN = oRecurring.Response.SubscriptionId + "," + oRecurring.Config("AuthNetCIMPaymentProfileId");
			}
			else
			{
				throw(new Exception(oRecurring.Response.Text));
			}
		}
	}

	public class Icharge : LateLoadObject
	{
		#region Properties
		public string             m_About               ;
		public string             m_AuthCode            ;
		public EPCard             m_Card                ;
		public EPCustomer         m_Customer            ;
		public IchargeGateways    m_Gateway             ;
		public string             m_GatewayURL          ;
		public string             m_InvoiceNumber       ;
		public string             m_Level2Aggregate     ;
		public string             m_Level3Aggregate     ;
		public string             m_MerchantLogin       ;
		public string             m_MerchantPassword    ;
		public EPResponse         m_Response            ;
		public string             m_RuntimeLicense      ;
		public EPShipInfo         m_ShippingInfo        ;
		//public Proxy              m_Proxy               ;
		//public EPSpecialFieldList m_SpecialFields       ;
		//public Certificate        m_SSLAcceptServerCert ;
		//public Certificate        m_SSLCert             ;
		//public Certificate        m_SSLServerCert       ;
		public object             m_SyncRoot            ;
		public bool               m_TestMode            ;
		public int                m_Timeout             ;
		public string             m_TransactionAmount   ;
		public string             m_TransactionDesc     ;
		public string             m_TransactionId       ;

		public string             About               { get { return _GetValue("About"              , m_About              ); } set { _SetValue("About"              , value, ref m_About              ); } }
		public string             AuthCode            { get { return _GetValue("AuthCode"           , m_AuthCode           ); } set { _SetValue("AuthCode"           , value, ref m_AuthCode           ); } }
		public EPCard             Card                { get { return m_Card    ; } }
		public EPCustomer         Customer            { get { return m_Customer; } }
		public IchargeGateways    Gateway             { get { return _GetValue("Gateway"            , m_Gateway            ); } set { _SetValue("Gateway"            , value, ref m_Gateway            ); } }
		public string             GatewayURL          { get { return _GetValue("GatewayURL"         , m_GatewayURL         ); } set { _SetValue("GatewayURL"         , value, ref m_GatewayURL         ); } }
		public string             InvoiceNumber       { get { return _GetValue("InvoiceNumber"      , m_InvoiceNumber      ); } set { _SetValue("InvoiceNumber"      , value, ref m_InvoiceNumber      ); } }
		public string             Level2Aggregate     { get { return _GetValue("Level2Aggregate"    , m_Level2Aggregate    ); } set { _SetValue("Level2Aggregate"    , value, ref m_Level2Aggregate    ); } }
		public string             Level3Aggregate     { get { return _GetValue("Level3Aggregate"    , m_Level3Aggregate    ); } set { _SetValue("Level3Aggregate"    , value, ref m_Level3Aggregate    ); } }
		public string             MerchantLogin       { get { return _GetValue("MerchantLogin"      , m_MerchantLogin      ); } set { _SetValue("MerchantLogin"      , value, ref m_MerchantLogin      ); } }
		public string             MerchantPassword    { get { return _GetValue("MerchantPassword"   , m_MerchantPassword   ); } set { _SetValue("MerchantPassword"   , value, ref m_MerchantPassword   ); } }
		public EPResponse         Response            { get { return m_Response    ; } }
		public string             RuntimeLicense      { get { return _GetValue("RuntimeLicense"     , m_RuntimeLicense     ); } set { _SetValue("RuntimeLicense"     , value, ref m_RuntimeLicense     ); } }
		public EPShipInfo         ShippingInfo        { get { return m_ShippingInfo; } }
		//public Proxy              Proxy               { get { return m_Proxy              ; } }
		//public EPSpecialFieldList SpecialFields       { get { return m_SpecialFields      ; } }
		//public Certificate        SSLAcceptServerCert { get { return m_SSLAcceptServerCert; } }
		//public Certificate        SSLCert             { get { return m_SSLCert            ; } }
		//public Certificate        SSLServerCert       { get { return m_SSLServerCert      ; } }
		public object             SyncRoot            { get { return _GetValue("SyncRoot"           , m_SyncRoot           ); } set { _SetValue("SyncRoot"           , value, ref m_SyncRoot           ); } }
		public bool               TestMode            { get { return _GetValue("TestMode"           , m_TestMode           ); } set { _SetValue("TestMode"           , value, ref m_TestMode           ); } }
		public int                Timeout             { get { return _GetValue("Timeout"            , m_Timeout            ); } set { _SetValue("Timeout"            , value, ref m_Timeout            ); } }
		public string             TransactionAmount   { get { return _GetValue("TransactionAmount"  , m_TransactionAmount  ); } set { _SetValue("TransactionAmount"  , value, ref m_TransactionAmount  ); } }
		public string             TransactionDesc     { get { return _GetValue("TransactionDesc"    , m_TransactionDesc    ); } set { _SetValue("TransactionDesc"    , value, ref m_TransactionDesc    ); } }
		public string             TransactionId       { get { return _GetValue("TransactionId"      , m_TransactionId      ); } set { _SetValue("TransactionId"      , value, ref m_TransactionId      ); } }
		#endregion

		private DbProviderFactories  DbProviderFactories = new DbProviderFactories();
		private HttpApplicationState Application         = new HttpApplicationState();
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;

		public Icharge(Security Security, Sql Sql, SqlProcs SqlProcs)
		{
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;

			#pragma warning disable 618
			m_asm = Assembly.LoadWithPartialName("nsoftware.InPayWeb");
			#pragma warning restore 618
			if ( m_asm != null )
			{
				m_typ = m_asm.GetType("nsoftware.InPay.Icharge");
				if ( m_typ != null )
				{
					ConstructorInfo info = m_typ.GetConstructor(new Type[0]);
					m_obj = info.Invoke(null);
					m_Card         = new EPCard    (m_asm, m_asm.GetType("nsoftware.InPay.EPCard"    ), _GetValue("Card"        , null as object));
					m_Customer     = new EPCustomer(m_asm, m_asm.GetType("nsoftware.InPay.EPCustomer"), _GetValue("Customer"    , null as object));
					m_ShippingInfo = new EPShipInfo(m_asm, m_asm.GetType("nsoftware.InPay.EPShipInfo"), _GetValue("ShippingInfo", null as object));
					m_Response     = new EPResponse(m_asm, m_asm.GetType("nsoftware.InPay.EPResponse"), _GetValue("Response"    , null as object));
				}
			}
			else
			{
				throw(new Exception("Failed to load nsoftware.InPayWeb.dll"));
			}
		}

		public string Config(string configurationString)
		{
			if ( m_obj != null )
			{
				Type[] types = new Type[1];
				types[0] = Type.GetType("System.String");

				MethodInfo info = m_typ.GetMethod("Config", types);
				object[] parameters = new object[1];
				parameters[0] = configurationString;
				return info.Invoke(m_obj, parameters) as string;
			}
			return String.Empty;
		}

		public void AddSpecialField(string name, string val)
		{
			if ( m_obj != null )
			{
				Type[] types = new Type[2];
				types[0] = Type.GetType("System.String");
				types[1] = Type.GetType("System.String");

				MethodInfo info = m_typ.GetMethod("AddSpecialField", types);
				object[] parameters = new object[2];
				parameters[0] = name;
				parameters[1] = val ;
				info.Invoke(m_obj, parameters);
				m_Response = new EPResponse  (m_asm, m_asm.GetType("nsoftware.InPay.EPResponse"), _GetValue("Response", null as object));
			}
		}

		public void Refund(string transactionId, string refundAmount)
		{
			if ( m_obj != null )
			{
				Type[] types = new Type[2];
				types[0] = Type.GetType("System.String");
				types[1] = Type.GetType("System.String");

				MethodInfo info = m_typ.GetMethod("Refund", types);
				object[] parameters = new object[2];
				parameters[0] = transactionId;
				parameters[1] = refundAmount;
				info.Invoke(m_obj, parameters);
				m_Response     = new EPResponse(m_asm, m_asm.GetType("nsoftware.InPay.EPResponse"), _GetValue("Response"    , null as object));
			}
		}

		public void Sale()
		{
			if ( m_obj != null )
			{
				MethodInfo info = m_typ.GetMethod("Sale");
				info.Invoke(m_obj, null);
				m_Response     = new EPResponse(m_asm, m_asm.GetType("nsoftware.InPay.EPResponse"), _GetValue("Response"    , null as object));
			}
		}

		public /*static*/ string Charge(Guid gID, Guid gCURRENCY_ID, Guid gACCOUNT_ID, Guid gCREDIT_CARD_ID, string sClientIP, string sOrderID, string sDESCRIPTION, string sTransactionType, Decimal dAMOUNT, string sTransactionID, string sPaymentGateway, string sPaymentGateway_Login, string sPaymentGateway_Password, bool bPaymentGateway_TestMode)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);

			Guid gPAYMENTS_TRANSACTION_ID = Guid.NewGuid();
			// Transaction Details
			//nsoftware.InPay.Icharge oCharge = new nsoftware.InPay.Icharge();
			Icharge oCharge = this;
			oCharge.TransactionId     = gPAYMENTS_TRANSACTION_ID.ToString().Replace("-", "").Substring(0, 20);
			//oCharge.InvoiceNumber     = sOrderID;
			oCharge.TransactionDesc   = sDESCRIPTION;
			oCharge.TransactionAmount = dAMOUNT.ToString();

			// Merchant Account Details
			oCharge.MerchantLogin = sPaymentGateway_Login   ;
			if ( !Sql.IsEmptyString(sPaymentGateway_Password) )
				oCharge.MerchantPassword = Security.DecryptPassword(sPaymentGateway_Password, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			if ( Sql.IsEmptyString(sPaymentGateway) )
				throw(new Exception("PaymentGateway has not been defined."));
			if ( sPaymentGateway == "gwAuthorizeNet" )
				sPaymentGateway = "gwAuthorizeNetCIM";
			oCharge.Gateway = (IchargeGateways)Enum.Parse(typeof(IchargeGateways), sPaymentGateway);
			if ( oCharge.Gateway == IchargeGateways.gwAuthorizeNetCIM && bPaymentGateway_TestMode )
			{
				oCharge.GatewayURL = "https://apitest.authorize.net/xml/v1/request.api";
				// 12/15/2015 Paul.  This gateway does not support TestMode. 
				// oRecurring.TestMode   = bPaymentGateway_TestMode;
			}

			string sSTATUS = "Prevalidation";
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL ;
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
							string sCARD_TOKEN = Sql.ToString(rdr["CARD_NUMBER"]);
							if ( Sql.ToBoolean(rdr["IS_ENCRYPTED"]) )
							{
								sCARD_TOKEN = Security.DecryptPassword(sCARD_TOKEN, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
							}
							string[] arrCARD_TOKEN = sCARD_TOKEN.Split(',');
							oCharge.Config("AuthNetCIMProfileId="        + arrCARD_TOKEN[0]);
							oCharge.Config("AuthNetCIMPaymentProfileId=" + arrCARD_TOKEN[1]);
							/*
							string sCARD_TYPE = Sql.ToString(rdr["CARD_TYPE"]);
							if ( sCARD_TYPE.StartsWith("Bank Draft") )
							{
								//if ( sCARD_TYPE == "Bank Draft - Checking" )
								//	oCharge.Bank.AccountType = AccountTypes.atChecking;
								//else if ( sCARD_TYPE == "Bank Draft - Savings" )
								//	oCharge.Bank.AccountType = AccountTypes.atSavings;
								//oCharge.Bank.AccountHolderName = Sql.ToString(rdr["NAME"]);
								//oCharge.Bank.AccountNumber     = sCARD_NUMBER;
								//oCharge.Bank.Name              = Sql.ToString(rdr["BANK_NAME"          ]);
								//oCharge.Bank.RoutingNumber     = Sql.ToString(rdr["BANK_ROUTING_NUMBER"]);
								throw(new Exception("ACH transactions are not supported using SplendidCRM.SplendidCharge.NSoftware.Charge."));
							}
							else
							{
								DateTime dtEXPIRATION_DATE = Sql.ToDateTime(rdr["EXPIRATION_DATE"]);
								// Card Details
								oCharge.Card.Number      = sCARD_NUMBER;
								oCharge.Card.ExpMonth    = dtEXPIRATION_DATE.Month;
								oCharge.Card.ExpYear     = dtEXPIRATION_DATE.Year;
								oCharge.Card.CVVData     = Sql.ToString(rdr["SECURITY_CODE"]);
								oCharge.Card.CVVPresence = (!Sql.IsEmptyString(oCharge.Card.CVVData) ? CCCVVPresences.cvpProvided : CCCVVPresences.cvpNotProvided);
								switch ( sCARD_TYPE )
								{
									case "Visa"               :  oCharge.Card.CardType = TCardTypes.ctVisa        ;  break;
									case "MasterCard"         :  oCharge.Card.CardType = TCardTypes.ctMasterCard  ;  break;
									case "American Express"   :  oCharge.Card.CardType = TCardTypes.ctAMEX        ;  break;
									case "Discover Card"      :  oCharge.Card.CardType = TCardTypes.ctDiscover    ;  break;
									case "Diner's Club"       :  oCharge.Card.CardType = TCardTypes.ctDiners      ;  break;
									case "Japan Credit Bureau":  oCharge.Card.CardType = TCardTypes.ctJCB         ;  break;
									case "Visa Electron"      :  oCharge.Card.CardType = TCardTypes.ctVisaElectron;  break;
									case "Maestro"            :  oCharge.Card.CardType = TCardTypes.ctMaestro     ;  break;
									case "Laser"              :  oCharge.Card.CardType = TCardTypes.ctLaser       ;  break;
								}
							}

							// Address Details
							oCharge.Customer.FullName = Sql.ToString(rdr["NAME"]);
							string[] arrName = oCharge.Customer.FullName.Split(' ');
							oCharge.Customer.LastName = arrName[arrName.Length-1];
							if ( arrName.Length > 1 )
								oCharge.Customer.FirstName = arrName[0];
							oCharge.Customer.Address = Sql.ToString(rdr["ADDRESS_STREET"    ]);
							oCharge.Customer.City    = Sql.ToString(rdr["ADDRESS_CITY"      ]);
							oCharge.Customer.State   = Sql.ToString(rdr["ADDRESS_STATE"     ]);
							oCharge.Customer.Zip     = Sql.ToString(rdr["ADDRESS_POSTALCODE"]);
							oCharge.Customer.Country = Sql.ToString(rdr["ADDRESS_COUNTRY"   ]);
							*/
						}
					}
				}
				sSQL = "select *         " + ControlChars.CrLf
				     + "  from vwACCOUNTS" + ControlChars.CrLf
				     + " where ID = @ID  " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gACCOUNT_ID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							//oCharge.Customer.Id            = Sql.ToString(rdr["ID"                         ]);
							//oCharge.Customer.Phone         = Sql.ToString(rdr["PHONE_OFFICE"               ]);
							//oCharge.Customer.Email         = Sql.ToString(rdr["EMAIL1"                     ]);
							oCharge.ShippingInfo.Phone     = Sql.ToString(rdr["PHONE_OFFICE"               ]);
							oCharge.ShippingInfo.Email     = Sql.ToString(rdr["EMAIL1"                     ]);
							//oCharge.ShippingInfo.FirstName = oCharge.Customer.FirstName;
							//oCharge.ShippingInfo.LastName  = oCharge.Customer.LastName ;
							oCharge.ShippingInfo.Address   = Sql.ToString(rdr["SHIPPING_ADDRESS_STREET"    ]);
							oCharge.ShippingInfo.City      = Sql.ToString(rdr["SHIPPING_ADDRESS_CITY"      ]);
							oCharge.ShippingInfo.State     = Sql.ToString(rdr["SHIPPING_ADDRESS_STATE"     ]);
							oCharge.ShippingInfo.Zip       = Sql.ToString(rdr["SHIPPING_ADDRESS_POSTALCODE"]);
							oCharge.ShippingInfo.Country   = Sql.ToString(rdr["SHIPPING_ADDRESS_COUNTRY"   ]);
						}
					}
				}
				// 01/08/2011 Paul.  One implementation of SplendidCRM uses the CONTACTS table as the relationship for credit cards.
				// If a match is found, then use the Contact record data. 
				sSQL = "select *         " + ControlChars.CrLf
				     + "  from vwCONTACTS" + ControlChars.CrLf
				     + " where ID = @ID  " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gACCOUNT_ID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							//oCharge.Customer.Id            = Sql.ToString(rdr["ID"                        ]);
							//oCharge.Customer.FirstName     = Sql.ToString(rdr["FIRST_NAME"                ]);
							//oCharge.Customer.LastName      = Sql.ToString(rdr["LAST_NAME"                 ]);
							//oCharge.Customer.Phone         = Sql.ToString(rdr["PHONE_WORK"                ]);
							//oCharge.Customer.Email         = Sql.ToString(rdr["EMAIL1"                    ]);
							oCharge.ShippingInfo.Phone     = Sql.ToString(rdr["PHONE_WORK"                ]);
							oCharge.ShippingInfo.Email     = Sql.ToString(rdr["EMAIL1"                    ]);
							oCharge.ShippingInfo.FirstName = Sql.ToString(rdr["FIRST_NAME"                ]);
							oCharge.ShippingInfo.LastName  = Sql.ToString(rdr["LAST_NAME"                 ]);
							oCharge.ShippingInfo.Address   = Sql.ToString(rdr["PRIMARY_ADDRESS_STREET"    ]);
							oCharge.ShippingInfo.City      = Sql.ToString(rdr["PRIMARY_ADDRESS_CITY"      ]);
							oCharge.ShippingInfo.State     = Sql.ToString(rdr["PRIMARY_ADDRESS_STATE"     ]);
							oCharge.ShippingInfo.Zip       = Sql.ToString(rdr["PRIMARY_ADDRESS_POSTALCODE"]);
							oCharge.ShippingInfo.Country   = Sql.ToString(rdr["PRIMARY_ADDRESS_COUNTRY"   ]);
						}
					}
				}
				// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						// 10/28/2010 Paul.  Include the login in the PAYMENT_GATEWAY for better tracking. 
						SqlProcs.spPAYMENTS_TRANSACTIONS_InsertOnly
							( ref gPAYMENTS_TRANSACTION_ID
							, gID
							, sPaymentGateway + ": " + sPaymentGateway_Login
							, sTransactionType  // Sale or Refund. 
							, dAMOUNT
							, gCURRENCY_ID
							, sOrderID
							, sDESCRIPTION
							, gCREDIT_CARD_ID
							, gACCOUNT_ID
							, sSTATUS
							, trn
							);
						trn.Commit();
					}
					catch(Exception ex)
					{
						trn.Rollback();
						throw(new Exception(ex.Message, ex.InnerException));
					}
				}
				try
				{
					if ( sTransactionType == "Refund" )
						oCharge.Refund(sTransactionID, dAMOUNT.ToString());
					else
						oCharge.Sale();
					Debug.Write(oCharge.Config("RawRequest"));
					
					if( oCharge.Response.Approved )
						sSTATUS = "Success";
					else
						sSTATUS = "Transaction Failed";
				}
				catch ( Exception ex )
				{
					sSTATUS = "InPay Exception";
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spPAYMENTS_TRANSACTIONS_Update
								( gPAYMENTS_TRANSACTION_ID
								, sSTATUS
								, oCharge.Response.TransactionId
								, oCharge.Response.Data
								, oCharge.Response.ApprovalCode
								, oCharge.Response.AVSResult
								, oCharge.Response.ErrorCode
								, ex.Message
								, trn
								);
							trn.Commit();
							// 12/16/2015 Paul.  Prevent over-write of exception message. 
							gPAYMENTS_TRANSACTION_ID = Guid.Empty;
						}
						catch
						{
							trn.Rollback();
						}
					}
				}
				finally
				{
					if ( !Sql.IsEmptyGuid(gPAYMENTS_TRANSACTION_ID) )
					{
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								SqlProcs.spPAYMENTS_TRANSACTIONS_Update
									( gPAYMENTS_TRANSACTION_ID
									, sSTATUS
									, oCharge.Response.TransactionId
									, oCharge.Response.Data
									, oCharge.Response.ApprovalCode
									, oCharge.Response.AVSResult
									, oCharge.Response.ErrorCode
									, oCharge.Response.Text + oCharge.Response.ErrorText
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
			}
			return sSTATUS;
		}
	}

	// 12/16/2015 Paul.  Echeck will not be used now that we have customerProfiles working. 
	public class Echeck : LateLoadObject
	{
		#region Properties
		public string             m_About               ;
		public EPBank             m_Bank                ;
		public string             m_CheckNumber         ;
		public string             m_CompanyName         ;
		public EPCustomer         m_Customer            ;
		public EcheckGateways     m_Gateway             ;
		public string             m_GatewayURL          ;
		public string             m_InvoiceNumber       ;
		public string             m_LicenseDOB          ;
		public string             m_LicenseNumber       ;
		public string             m_LicenseState        ;
		public string             m_MerchantLogin       ;
		public string             m_MerchantPassword    ;
		public EcheckPaymentTypes m_PaymentType         ;
		public EPResponse         m_Response            ;
		public string             m_RuntimeLicense      ;
		//public Proxy              m_Proxy               ;
		//public EPSpecialFieldList m_SpecialFields       ;
		//public Certificate        m_SSLAcceptServerCert ;
		//public Certificate        m_SSLCert             ;
		//public Certificate        m_SSLServerCert       ;
		public object             m_SyncRoot            ;
		public string             m_TaxId               ;
		public bool               m_TestMode            ;
		public int                m_Timeout             ;
		public string             m_TransactionAmount   ;
		public string             m_TransactionDesc     ;
		public string             m_TransactionId       ;

		public string             About               { get { return _GetValue("About"               , m_About               ); } set { _SetValue("About"               , value, ref m_About               ); } }
		public EPBank             Bank                { get { return m_Bank    ; } }
		public string             CheckNumber         { get { return _GetValue("CheckNumber"         , m_CheckNumber         ); } set { _SetValue("CheckNumber"         , value, ref m_CheckNumber         ); } }
		public string             CompanyName         { get { return _GetValue("CompanyName"         , m_CompanyName         ); } set { _SetValue("CompanyName"         , value, ref m_CompanyName         ); } }
		public EPCustomer         Customer            { get { return m_Customer; } }
		public EcheckGateways     Gateway             { get { return _GetValue("Gateway"             , m_Gateway             ); } set { _SetValue("Gateway"             , value, ref m_Gateway             ); } }
		public string             GatewayURL          { get { return _GetValue("GatewayURL"          , m_GatewayURL          ); } set { _SetValue("GatewayURL"          , value, ref m_GatewayURL          ); } }
		public string             InvoiceNumber       { get { return _GetValue("InvoiceNumber"       , m_InvoiceNumber       ); } set { _SetValue("InvoiceNumber"       , value, ref m_InvoiceNumber       ); } }
		public string             LicenseDOB          { get { return _GetValue("LicenseDOB"          , m_LicenseDOB          ); } set { _SetValue("LicenseDOB"          , value, ref m_LicenseDOB          ); } }
		public string             LicenseNumber       { get { return _GetValue("LicenseNumber"       , m_LicenseNumber       ); } set { _SetValue("LicenseNumber"       , value, ref m_LicenseNumber       ); } }
		public string             LicenseState        { get { return _GetValue("LicenseState"        , m_LicenseState        ); } set { _SetValue("LicenseState"        , value, ref m_LicenseState        ); } }
		public string             MerchantLogin       { get { return _GetValue("MerchantLogin"       , m_MerchantLogin       ); } set { _SetValue("MerchantLogin"       , value, ref m_MerchantLogin       ); } }
		public string             MerchantPassword    { get { return _GetValue("MerchantPassword"    , m_MerchantPassword    ); } set { _SetValue("MerchantPassword"    , value, ref m_MerchantPassword    ); } }
		public EcheckPaymentTypes PaymentType         { get { return _GetValue("PaymentType"         , m_PaymentType         ); } set { _SetValue("PaymentType"         , value, ref m_PaymentType         ); } }
		public EPResponse         Response            { get { return m_Response           ; } }
		public string             RuntimeLicense      { get { return _GetValue("RuntimeLicense"      , m_RuntimeLicense      ); } set { _SetValue("RuntimeLicense"      , value, ref m_RuntimeLicense      ); } }
		//public Proxy              Proxy               { get { return m_Proxy              ; } }
		//public EPSpecialFieldList SpecialFields       { get { return m_SpecialFields      ; } }
		//public Certificate        SSLAcceptServerCert { get { return m_SSLAcceptServerCert; } }
		//public Certificate        SSLCert             { get { return m_SSLCert            ; } }
		//public Certificate        SSLServerCert       { get { return m_SSLServerCert      ; } }
		public object             SyncRoot            { get { return _GetValue("SyncRoot"            , m_SyncRoot            ); } set { _SetValue("SyncRoot"            , value, ref m_SyncRoot            ); } }
		public string             TaxId               { get { return _GetValue("TaxId"               , m_TaxId               ); } set { _SetValue("TaxId"               , value, ref m_TaxId               ); } }
		public bool               TestMode            { get { return _GetValue("TestMode"            , m_TestMode            ); } set { _SetValue("TestMode"            , value, ref m_TestMode            ); } }
		public int                Timeout             { get { return _GetValue("Timeout"             , m_Timeout             ); } set { _SetValue("Timeout"             , value, ref m_Timeout             ); } }
		public string             TransactionAmount   { get { return _GetValue("TransactionAmount"   , m_TransactionAmount   ); } set { _SetValue("TransactionAmount"   , value, ref m_TransactionAmount   ); } }
		public string             TransactionDesc     { get { return _GetValue("TransactionDesc"     , m_TransactionDesc     ); } set { _SetValue("TransactionDesc"     , value, ref m_TransactionDesc     ); } }
		public string             TransactionId       { get { return _GetValue("TransactionId"       , m_TransactionId       ); } set { _SetValue("TransactionId"       , value, ref m_TransactionId       ); } }
		#endregion

		private DbProviderFactories  DbProviderFactories = new DbProviderFactories();
		private HttpApplicationState Application         = new HttpApplicationState();
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;

		public Echeck(Security Security, Sql Sql, SqlProcs SqlProcs)
		{
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;

			#pragma warning disable 618
			m_asm = Assembly.LoadWithPartialName("nsoftware.InPayWeb");
			#pragma warning restore 618
			if ( m_asm != null )
			{
				m_typ = m_asm.GetType("nsoftware.InPay.Echeck");
				if ( m_typ != null )
				{
					ConstructorInfo info = m_typ.GetConstructor(new Type[0]);
					m_obj = info.Invoke(null);
					m_Bank         = new EPBank    (m_asm, m_asm.GetType("nsoftware.InPay.EPBank"    ), _GetValue("Bank"        , null as object));
					m_Customer     = new EPCustomer(m_asm, m_asm.GetType("nsoftware.InPay.EPCustomer"), _GetValue("Customer"    , null as object));
					m_Response     = new EPResponse(m_asm, m_asm.GetType("nsoftware.InPay.EPResponse"), _GetValue("Response"    , null as object));
				}
			}
			else
			{
				throw(new Exception("Failed to load nsoftware.InPayWeb.dll"));
			}
		}

		public string Config(string configurationString)
		{
			if ( m_obj != null )
			{
				Type[] types = new Type[1];
				types[0] = Type.GetType("System.String");

				MethodInfo info = m_typ.GetMethod("Config", types);
				object[] parameters = new object[1];
				parameters[0] = configurationString;
				return info.Invoke(m_obj, parameters) as string;
			}
			return String.Empty;
		}

		public void AddSpecialField(string name, string val)
		{
			if ( m_obj != null )
			{
				Type[] types = new Type[2];
				types[0] = Type.GetType("System.String");
				types[1] = Type.GetType("System.String");

				MethodInfo info = m_typ.GetMethod("AddSpecialField", types);
				object[] parameters = new object[2];
				parameters[0] = name;
				parameters[1] = val ;
				info.Invoke(m_obj, parameters);
				m_Response = new EPResponse  (m_asm, m_asm.GetType("nsoftware.InPay.EPResponse"), _GetValue("Response", null as object));
			}
		}

		public void Credit(string transactionId, string refundAmount)
		{
			if ( m_obj != null )
			{
				Type[] types = new Type[2];
				types[0] = Type.GetType("System.String");
				types[1] = Type.GetType("System.String");

				MethodInfo info = m_typ.GetMethod("Credit", types);
				object[] parameters = new object[2];
				parameters[0] = transactionId;
				parameters[1] = refundAmount;
				info.Invoke(m_obj, parameters);
				m_Response     = new EPResponse(m_asm, m_asm.GetType("nsoftware.InPay.EPResponse"), _GetValue("Response"    , null as object));
			}
		}

		public void Authorize()
		{
			if ( m_obj != null )
			{
				MethodInfo info = m_typ.GetMethod("Authorize");
				info.Invoke(m_obj, null);
				m_Response     = new EPResponse(m_asm, m_asm.GetType("nsoftware.InPay.EPResponse"), _GetValue("Response"    , null as object));
			}
		}

		public /*static*/ string eCheck(Guid gID, Guid gCURRENCY_ID, Guid gACCOUNT_ID, Guid gCREDIT_CARD_ID, string sClientIP, string sOrderID, string sDESCRIPTION, string sTransactionType, Decimal dAMOUNT, string sTransactionID, string sPaymentGateway, string sPaymentGateway_Login, string sPaymentGateway_Password, bool bPaymentGateway_TestMode)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);

			// Transaction Details
			//nsoftware.InPay.Icharge oCharge = new nsoftware.InPay.Icharge();
			//nsoftware.InPay.Echeck oCharge = new nsoftware.InPay.Echeck();
			Echeck oCharge = this;
			oCharge.TransactionId     = sOrderID;
			oCharge.InvoiceNumber     = sOrderID;
			oCharge.TransactionDesc   = sDESCRIPTION;
			oCharge.TransactionAmount = dAMOUNT.ToString();
			// 12/12/2015 Paul.  We may want the payment type to be configurable. 
			oCharge.PaymentType       = EcheckPaymentTypes.ptWEB;
			if ( !Sql.IsEmptyString(sTransactionID) || Sql.ToBoolean(Application["CONFIG.CreditCard.HideCustomerID"]) )
				oCharge.Customer.Id = String.Empty;

			// Merchant Account Details
			oCharge.MerchantLogin = sPaymentGateway_Login   ;
			if ( !Sql.IsEmptyString(sPaymentGateway_Password) )
				oCharge.MerchantPassword = Security.DecryptPassword(sPaymentGateway_Password, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			if ( Sql.IsEmptyString(sPaymentGateway) )
				throw(new Exception("PaymentGateway has not been defined."));
			oCharge.Gateway = (EcheckGateways)Enum.Parse(typeof(EcheckGateways), sPaymentGateway);
			if ( oCharge.Gateway == EcheckGateways.gwAuthorizeNet && bPaymentGateway_TestMode )
			{
				oCharge.GatewayURL = "https://test.authorize.net/gateway/transact.dll";
				oCharge.TestMode      = bPaymentGateway_TestMode;
			}
			else
			{
				oCharge.TestMode      = bPaymentGateway_TestMode;
			}

			string sSTATUS = "Prevalidation";
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL ;
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
							string sCARD_NUMBER = Sql.ToString(rdr["CARD_NUMBER"]);
							if ( Sql.ToBoolean(rdr["IS_ENCRYPTED"]) )
							{
								sCARD_NUMBER = Security.DecryptPassword(sCARD_NUMBER, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
							}
							oCharge.Config("AuthNetCIMProfileId=" + sCARD_NUMBER);
							/*
							string sCARD_TYPE = Sql.ToString(rdr["CARD_TYPE"]);
							if ( sCARD_TYPE.StartsWith("Bank Draft") )
							{
								if ( sCARD_TYPE == "Bank Draft - Checking" )
									oCharge.Bank.AccountType = AccountTypes.atChecking;
								else if ( sCARD_TYPE == "Bank Draft - Savings" )
									oCharge.Bank.AccountType = AccountTypes.atSavings;
								oCharge.Bank.AccountHolderName = Sql.ToString(rdr["NAME"]);
								oCharge.Bank.AccountNumber     = sCARD_NUMBER;
								oCharge.Bank.Name              = Sql.ToString(rdr["BANK_NAME"          ]);
								oCharge.Bank.RoutingNumber     = Sql.ToString(rdr["BANK_ROUTING_NUMBER"]);
							}
							else
							{
								//DateTime dtEXPIRATION_DATE = Sql.ToDateTime(rdr["EXPIRATION_DATE"]);
								//// Card Details
								//oCharge.Card.Number      = sCARD_NUMBER;
								//oCharge.Card.ExpMonth    = dtEXPIRATION_DATE.Month;
								//oCharge.Card.ExpYear     = dtEXPIRATION_DATE.Year;
								//oCharge.Card.CVVData     = Sql.ToString(rdr["SECURITY_CODE"]);
								//oCharge.Card.CVVPresence = (!Sql.IsEmptyString(oCharge.Card.CVVData) ? CCCVVPresences.cvpProvided : CCCVVPresences.cvpNotProvided);
								//switch ( sCARD_TYPE )
								//{
								//	case "Visa"               :  oCharge.Card.CardType = TCardTypes.ctVisa        ;  break;
								//	case "MasterCard"         :  oCharge.Card.CardType = TCardTypes.ctMasterCard  ;  break;
								//	case "American Express"   :  oCharge.Card.CardType = TCardTypes.ctAMEX        ;  break;
								//	case "Discover Card"      :  oCharge.Card.CardType = TCardTypes.ctDiscover    ;  break;
								//	case "Diner's Club"       :  oCharge.Card.CardType = TCardTypes.ctDiners      ;  break;
								//	case "Japan Credit Bureau":  oCharge.Card.CardType = TCardTypes.ctJCB         ;  break;
								//	case "Visa Electron"      :  oCharge.Card.CardType = TCardTypes.ctVisaElectron;  break;
								//	case "Maestro"            :  oCharge.Card.CardType = TCardTypes.ctMaestro     ;  break;
								//	case "Laser"              :  oCharge.Card.CardType = TCardTypes.ctLaser       ;  break;
								//}
								throw(new Exception("Credit Chard transactions are not supported using SplendidCRM.SplendidCharge.NSoftware.eCheck."));
							}

							// Address Details
							oCharge.Customer.FullName = Sql.ToString(rdr["NAME"]);
							string[] arrName = oCharge.Customer.FullName.Split(' ');
							oCharge.Customer.LastName = arrName[arrName.Length-1];
							if ( arrName.Length > 1 )
								oCharge.Customer.FirstName = arrName[0];
							oCharge.Customer.Address = Sql.ToString(rdr["ADDRESS_STREET"    ]);
							oCharge.Customer.City    = Sql.ToString(rdr["ADDRESS_CITY"      ]);
							oCharge.Customer.State   = Sql.ToString(rdr["ADDRESS_STATE"     ]);
							oCharge.Customer.Zip     = Sql.ToString(rdr["ADDRESS_POSTALCODE"]);
							oCharge.Customer.Country = Sql.ToString(rdr["ADDRESS_COUNTRY"   ]);
							*/
						}
					}
				}
				sSQL = "select *         " + ControlChars.CrLf
				     + "  from vwACCOUNTS" + ControlChars.CrLf
				     + " where ID = @ID  " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gACCOUNT_ID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							oCharge.Customer.Id            = Sql.ToString(rdr["ID"                         ]);
							oCharge.Customer.Phone         = Sql.ToString(rdr["PHONE_OFFICE"               ]);
							oCharge.Customer.Email         = Sql.ToString(rdr["EMAIL1"                     ]);
						}
					}
				}
				// 01/08/2011 Paul.  One implementation of SplendidCRM uses the CONTACTS table as the relationship for credit cards.
				// If a match is found, then use the Contact record data. 
				sSQL = "select *         " + ControlChars.CrLf
				     + "  from vwCONTACTS" + ControlChars.CrLf
				     + " where ID = @ID  " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gACCOUNT_ID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							oCharge.Customer.Id            = Sql.ToString(rdr["ID"                        ]);
							oCharge.Customer.FirstName     = Sql.ToString(rdr["FIRST_NAME"                ]);
							oCharge.Customer.LastName      = Sql.ToString(rdr["LAST_NAME"                 ]);
							oCharge.Customer.Phone         = Sql.ToString(rdr["PHONE_WORK"                ]);
							oCharge.Customer.Email         = Sql.ToString(rdr["EMAIL1"                    ]);
						}
					}
				}
				Guid gPAYMENTS_TRANSACTION_ID = Guid.Empty;
				// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						// 10/28/2010 Paul.  Include the login in the PAYMENT_GATEWAY for better tracking. 
						SqlProcs.spPAYMENTS_TRANSACTIONS_InsertOnly
							( ref gPAYMENTS_TRANSACTION_ID
							, gID
							, sPaymentGateway + ": " + sPaymentGateway_Login
							, sTransactionType  // Sale or Refund. 
							, dAMOUNT
							, gCURRENCY_ID
							, sOrderID
							, sDESCRIPTION
							, gCREDIT_CARD_ID
							, gACCOUNT_ID
							, sSTATUS
							, trn
							);
						trn.Commit();
					}
					catch(Exception ex)
					{
						trn.Rollback();
						throw(new Exception(ex.Message, ex.InnerException));
					}
				}
				try
				{
					if ( sTransactionType == "Refund" )
						oCharge.Credit(sTransactionID, dAMOUNT.ToString());
					else
						oCharge.Authorize();
					if( oCharge.Response.Approved )
						sSTATUS = "Success";
					else
						sSTATUS = "Transaction Failed";
				}
				catch ( Exception ex )
				{
					sSTATUS = "InPayException";
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spPAYMENTS_TRANSACTIONS_Update
								( gPAYMENTS_TRANSACTION_ID
								, sSTATUS
								, oCharge.Response.TransactionId
								, oCharge.Response.Data
								, oCharge.Response.ApprovalCode
								, oCharge.Response.AVSResult
								, oCharge.Response.ErrorCode
								, ex.Message
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
				finally
				{
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spPAYMENTS_TRANSACTIONS_Update
								( gPAYMENTS_TRANSACTION_ID
								, sSTATUS
								, oCharge.Response.TransactionId
								, oCharge.Response.Data
								, oCharge.Response.ApprovalCode
								, oCharge.Response.AVSResult
								, oCharge.Response.ErrorCode
								, oCharge.Response.ErrorText
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
	}

}

namespace SplendidCRM.SplendidCharge.DotNetCharge
{
	#region Enums
	// 12/09/2010 Paul.  Update with list from dotnetCHARGE 7.0. 
	// 05/08/2013 Paul.  Update with list from dotnetCHARGE 7.3. 
	public enum Processor
	{
		Amazon = 0,
		AuthorizeNet = 1,
		BankOfAmerica = 2,
		Barclays = 3,
		CyberSource = 4,
		Echo = 5,
		Ecx = 6,
		ePoch = 7,
		eProcessing = 8,
		eSecPayments = 9,
		ElavonNative = 10,
		ElavonViaKlix = 11,
		ElavonVirtualMerchant = 12,
		FirstData = 13,
		FirstDataGlobalGateway = 14,
		GlobalPayments = 15,
		GoogleCheckout = 16,
		HSBC = 17,
		Innovative = 18,
		Intellipay = 19,
		ioNgate = 20,
		Itransact = 21,
		ItransactXml = 22,
		LinkPoint = 23,
		Mcps = 24,
		Moneris = 25,
		NaviGate = 26,
		NetBilling = 27,
		Ogone = 28,
		OptimalPayment = 29,
		PayCom = 30,
		PayflowLink = 31,
		PayflowPro = 32,
		PayflowProExpress = 33,
		PaymentechNative = 34,
		PaymentechOrbital = 35,
		PayPal = 36,
		PayPalPro = 37,
		PayPalProExpress = 38,
		PayReady = 39,
		PlanetPayment = 40,
		PlugnPay = 41,
		PSiGate = 42,
		QuickBooks = 43,
		Realex = 44,
		SagePay = 45,
		SecurePay = 46,
		SkipJack = 47,
		TrustCommerce = 48,
		Vital = 49,
		RbsWorldPay = 50,
		Validate = 51,
	}

	public enum CountryCode
	{
		AFG = 4,
		ALB = 8,
		DZA = 12,
		ASM = 16,
		AND = 20,
		AGO = 24,
		ATG = 28,
		AZE = 31,
		ARG = 32,
		AUS = 36,
		AUT = 40,
		BHS = 44,
		BGD = 50,
		ARM = 51,
		BRB = 52,
		BEL = 56,
		BMU = 60,
		BTN = 64,
		BOL = 68,
		BIH = 70,
		BWA = 72,
		BRA = 76,
		BLZ = 84,
		SLB = 90,
		VGB = 92,
		BRN = 96,
		BGR = 100,
		MMR = 104,
		BDI = 108,
		BLR = 112,
		KHM = 116,
		CMR = 120,
		CAN = 124,
		CPV = 132,
		CYM = 136,
		CAF = 140,
		LKA = 144,
		TCD = 148,
		CHL = 152,
		CHN = 156,
		COL = 170,
		COM = 174,
		MYT = 175,
		COG = 178,
		COD = 180,
		COK = 184,
		CRI = 188,
		HRV = 191,
		CUB = 192,
		CYP = 196,
		CZE = 203,
		BEN = 204,
		DNK = 208,
		DMA = 212,
		DOM = 214,
		ECU = 218,
		SLV = 222,
		GNQ = 226,
		ETH = 231,
		ERI = 232,
		EST = 233,
		FRO = 234,
		FLK = 238,
		FJI = 242,
		FIN = 246,
		ALA = 248,
		FRA = 250,
		GUF = 254,
		PYF = 258,
		DJI = 262,
		GAB = 266,
		GEO = 268,
		GMB = 270,
		PSE = 275,
		DEU = 276,
		GHA = 288,
		GIB = 292,
		KIR = 296,
		GRC = 300,
		GRL = 304,
		GRD = 308,
		GLP = 312,
		GUM = 316,
		GTM = 320,
		GIN = 324,
		GUY = 328,
		HTI = 332,
		VAT = 336,
		HND = 340,
		HKG = 344,
		HUN = 348,
		ISL = 352,
		IND = 356,
		IDN = 360,
		IRN = 364,
		IRQ = 368,
		IRL = 372,
		ISR = 376,
		ITA = 380,
		CIV = 384,
		JAM = 388,
		JPN = 392,
		KAZ = 398,
		JOR = 400,
		KEN = 404,
		PRK = 408,
		KOR = 410,
		KWT = 414,
		KGZ = 417,
		LAO = 418,
		LBN = 422,
		LSO = 426,
		LVA = 428,
		LBR = 430,
		LBY = 434,
		LIE = 438,
		LTU = 440,
		LUX = 442,
		MAC = 446,
		MDG = 450,
		MWI = 454,
		MYS = 458,
		MDV = 462,
		MLI = 466,
		MLT = 470,
		MTQ = 474,
		MRT = 478,
		MUS = 480,
		MEX = 484,
		MCO = 492,
		MNG = 496,
		MDA = 498,
		MSR = 500,
		MAR = 504,
		MOZ = 508,
		OMN = 512,
		NAM = 516,
		NRU = 520,
		NPL = 524,
		NLD = 528,
		ANT = 530,
		ABW = 533,
		NCL = 540,
		VUT = 548,
		NZL = 554,
		NIC = 558,
		NER = 562,
		NGA = 566,
		NIU = 570,
		NFK = 574,
		NOR = 578,
		MNP = 580,
		FSM = 583,
		MHL = 584,
		PLW = 585,
		PAK = 586,
		PAN = 591,
		PNG = 598,
		PRY = 600,
		PER = 604,
		PHL = 608,
		PCN = 612,
		POL = 616,
		PRT = 620,
		GNB = 624,
		TLS = 626,
		PRI = 630,
		QAT = 634,
		REU = 638,
		ROU = 642,
		RUS = 643,
		RWA = 646,
		SHN = 654,
		KNA = 659,
		AIA = 660,
		LCA = 662,
		SPM = 666,
		VCT = 670,
		SMR = 674,
		STP = 678,
		SAU = 682,
		SEN = 686,
		SYC = 690,
		SLE = 694,
		SGP = 702,
		SVK = 703,
		VNM = 704,
		SVN = 705,
		SOM = 706,
		ZAF = 710,
		ZWE = 716,
		ESP = 724,
		ESH = 732,
		SDN = 736,
		SUR = 740,
		SJM = 744,
		SWZ = 748,
		SWE = 752,
		CHE = 756,
		SYR = 760,
		TJK = 762,
		THA = 764,
		TGO = 768,
		TKL = 772,
		TON = 776,
		TTO = 780,
		ARE = 784,
		TUN = 788,
		TUR = 792,
		TKM = 795,
		TCA = 796,
		TUV = 798,
		UGA = 800,
		UKR = 804,
		MKD = 807,
		EGY = 818,
		GBR = 826,
		TZA = 834,
		USA = 840,
		VIR = 850,
		BFA = 854,
		URY = 858,
		UZB = 860,
		VEN = 862,
		WLF = 876,
		WSM = 882,
		YEM = 887,
		SCG = 891,
		ZMB = 894,
		EUR = 978,
	}

	public enum PaymentMethod
	{
		CreditCard = 0,
		Echeck = 1,
	}

	public enum TimeZone
	{
		Indiana = 105,
		Arizona = 107,
		HAST = 110,
		AST = 704,
		EST = 705,
		CST = 706,
		MST = 707,
		PST = 708,
		AKST = 709,
	}

	public enum DataProviderType
	{
		MsSql = 0,
		OleDb = 1,
		MsAccess = 2,
		MySql = 3,
		Oracle = 4,
		MsOracle = 5,
		Odbc = 6,
	}

	public enum TransactionType
	{
		Sale = 0,
		Authorize = 1,
		PostAuthorize = 2,
		Return = 3,
		Refund = 4,
		Void = 5,
		Credit = 6,
		Reversal = 7,
		PreAuthorize = 8,
		Force = 9,
		Settle = 10,
		Cancel = 11,
		Abort = 12,
	}

	public enum CardNumberStorage
	{
		Disabled = 0,
		FullEncrypted = 1,
		FullHashOnly = 2,
		Last4Digits = 3,
		FirstLast4Digits = 4
	}

	public class Transaction
	{
		public Transaction()
		{
		}

		public double          Amount                  ;
		public string          AuthCode                ;
		public string          AuthorizationSourceCode ;
		public string          AvsCode                 ;
		public string          CardCode                ;
		public string          CardLevel               ;
		public object          CardNumber              ;
		public DateTime        DateTime                ;
		public int             ExpiryMonth             ;
		public int             ExpiryYear              ;
		public long            ID                      ;
		public string          Identifier              ;
		public string          OrderID                 ;
		public string          ReferenceNumber         ;
		public string          ReturnedACI             ;
		public int             SequenceNumber          ;
		public TransactionType Type                    ;
	}
	#endregion

	public class Batch : CollectionBase
	{
		public Batch() {}

		public string ErrorData         ;
		public string ErrorFieldNumber  ;
		public string ErrorRecordNumber ;
		public string ErrorRecordType   ;
		public string ErrorType         ;
		public string Fields            ;
		public long   ID                ;
		public int    Number            ;
		public int    Status            ;

		public Transaction this[int index] { get { return null; } }
	}

	/// <summary>
	/// Summary description for CC.
	/// </summary>
	public class CC
	{
		#region Properties
		protected string            m_sAcceptedCardTypes        ;
		protected string            m_sAccountID                ;
		protected string            m_sAddress                  ;
		protected string            m_sAddress2                 ;
		protected int               m_nAgentBankNumber          ;
		protected int               m_nAgentChainNumber         ;
		protected bool              m_bAllowDuplicate           ;
		protected bool              m_bAllowPartialAuthorization;
		protected double            m_dAmount                   ;
		protected string            m_sApplication              ;
		protected int               m_nApplySecure3D            ;
		protected string            m_sAuthCode                 ;
		protected int               m_nAuthenticationIndicator  ;
		protected string            m_sAuthenticationValue      ;
		protected string            m_sAuthorizationSourceCode  ;
		protected string            m_sAvsCode                  ;
		protected int               m_nAvsIndicator             ;
		protected string            m_sBankAddress              ;
		protected string            m_sBankCode                 ;
		protected string            m_sBankName                 ;
		protected Batch             m_oBatch                    ;
		protected int               m_nBillingCount             ;
		protected string            m_sCancelUrl                ;
		protected string            m_sCardLevel                ;
		protected string            m_sCardName                 ;
		protected CardNumberStorage m_enumCardNumberStorage     ;
		protected string            m_sCardType                 ;
		protected string            m_sCAVV                     ;
		protected string            m_sCertificate              ;
		protected string            m_sCity                     ;
		protected string            m_sClientIP                 ;
		protected string            m_sCode                     ;
		protected string            m_sCompany                  ;
		protected string            m_sConnectionString         ;
		protected string            m_sCountry                  ;
		protected string            m_sCryptoPassword           ;
		protected object            m_oCurrency                 ;
		protected string            m_sCustomerID               ;
		protected string            m_sData                     ;
		protected string            m_sDebug                    ;
		protected string            m_sDescription              ;
		protected string            m_sDeviceCode               ;
		protected string            m_sEcheckType               ;
		protected string            m_sEmail                    ;
		protected Encoding          m_oEncoding                 ;
		protected string            m_sEncryptionKey            ;
		protected string            m_sErrorCode                ;
		protected string            m_sFax                      ;
		protected string            m_sFirstName                ;
		protected long              m_lID                       ;
		protected string            m_sIndustryCode             ;
		protected DateTime          m_dtIssueDate               ;
		protected string            m_sIssueNumber              ;
		protected string            m_sLanguage                 ;
		protected string            m_sLastName                 ;
		protected string            m_sLogin                    ;
		protected int               m_nMerchantCategoryCode     ;
		protected string            m_sMerchantCity             ;
		protected CountryCode       m_enumMerchantCountry       ;
		protected string            m_sMerchantEmail            ;
		protected string            m_sMerchantName             ;
		protected string            m_sMerchantPhone            ;
		protected string            m_sMerchantState            ;
		protected string            m_sMerchantUrl              ;
		protected string            m_sMerchantZipPostal        ;
		protected int               m_nMonth                    ;
		protected string            m_sNumber                   ;
		protected string            m_sOrderID                  ;
		protected double            m_dOriginalAmount           ;
		protected string            m_sPartner                  ;
		protected string            m_sPassword                 ;
		protected int               m_nPaymentIndicator         ;
		protected PaymentMethod     m_enumPaymentMethod         ;
		protected string            m_sPhone                    ;
		protected int               m_nPort                     ;
		protected bool              m_bPreValidate              ;
		protected WebProxy          m_oProxy                    ;
		protected string            m_sProxyHost                ;
		protected string            m_sProxyPort                ;
		protected bool              m_bRecurringBilling         ;
		protected string            m_sReferenceNumber          ;
		protected string            m_sRequestedACI             ;
		protected string            m_sReturnedACI              ;
		protected int               m_nSequenceNumber           ;
		protected string            m_sServer                   ;
		protected string            m_sSetting                  ;
		protected double            m_dSettleHourInterval       ;
		protected object            m_oSettleInterval           ;
		protected object            m_oShipping                 ;
		protected DateTime          m_dtStartDate               ;
		protected string            m_sStateProvince            ;
		protected int               m_nStoreNumber              ;
		protected object            m_oTax                      ;
		protected string            m_sTaxID                    ;
		protected string            m_sTerminalID               ;
		protected int               m_nTerminalNumber           ;
		protected bool              m_bTestMode                 ;
		protected int               m_nTimeout                  ;
		protected TimeZone          m_enumTimeZone              ;
		protected DateTime          m_dtTransactionDate         ;
		protected string            m_sTransactionID            ;
		protected string            m_sTransactionKey           ;
		protected object            m_oTransactionType          ;
		protected string            m_sUserName                 ;
		protected int               m_nYear                     ;
		protected string            m_sZipPostal                ;

		public string            AcceptedCardTypes        { get { return _GetValue("AcceptedCardTypes"        , m_sAcceptedCardTypes        ); } set { _SetValue("AcceptedCardTypes"        , value, ref m_sAcceptedCardTypes        ); } }
		public string            AccountID                { get { return _GetValue("AccountID"                , m_sAccountID                ); } set { _SetValue("AccountID"                , value, ref m_sAccountID                ); } }
		public string            Address                  { get { return _GetValue("Address"                  , m_sAddress                  ); } set { _SetValue("Address"                  , value, ref m_sAddress                  ); } }
		public string            Address2                 { get { return _GetValue("Address2"                 , m_sAddress2                 ); } set { _SetValue("Address2"                 , value, ref m_sAddress2                 ); } }
		public int               AgentBankNumber          { get { return _GetValue("AgentBankNumber"          , m_nAgentBankNumber          ); } set { _SetValue("AgentBankNumber"          , value, ref m_nAgentBankNumber          ); } }
		public int               AgentChainNumber         { get { return _GetValue("AgentChainNumber"         , m_nAgentChainNumber         ); } set { _SetValue("AgentChainNumber"         , value, ref m_nAgentChainNumber         ); } }
		public bool              AllowDuplicate           { get { return _GetValue("AllowDuplicate"           , m_bAllowDuplicate           ); } set { _SetValue("AllowDuplicate"           , value, ref m_bAllowDuplicate           ); } }
		public bool              AllowPartialAuthorization{ get { return _GetValue("AllowPartialAuthorization", m_bAllowPartialAuthorization); } set { _SetValue("AllowPartialAuthorization", value, ref m_bAllowPartialAuthorization); } }
		public double            Amount                   { get { return _GetValue("Amount"                   , m_dAmount                   ); } set { _SetValue("Amount"                   , value, ref m_dAmount                   ); } }
		// 05/26/2024 Paul.  Change name to ApplicationCC. 
		public string            ApplicationCC            { get { return _GetValue("Application"              , m_sApplication              ); } set { _SetValue("Application"              , value, ref m_sApplication              ); } }
		public int               ApplySecure3D            { get { return _GetValue("ApplySecure3D"            , m_nApplySecure3D            ); } set { _SetValue("ApplySecure3D"            , value, ref m_nApplySecure3D            ); } }
		public string            AuthCode                 { get { return _GetValue("AuthCode"                 , m_sAuthCode                 ); } set { _SetValue("AuthCode"                 , value, ref m_sAuthCode                 ); } }
		public int               AuthenticationIndicator  { get { return _GetValue("AuthenticationIndicator"  , m_nAuthenticationIndicator  ); } set { _SetValue("AuthenticationIndicator"  , value, ref m_nAuthenticationIndicator  ); } }
		public string            AuthenticationValue      { get { return _GetValue("AuthenticationValue"      , m_sAuthenticationValue      ); } set { _SetValue("AuthenticationValue"      , value, ref m_sAuthenticationValue      ); } }
		public string            AuthorizationSourceCode  { get { return _GetValue("AuthorizationSourceCode"  , m_sAuthorizationSourceCode  ); } set { _SetValue("AuthorizationSourceCode"  , value, ref m_sAuthorizationSourceCode  ); } }
		public string            AvsCode                  { get { return _GetValue("AvsCode"                  , m_sAvsCode                  ); } set { _SetValue("AvsCode"                  , value, ref m_sAvsCode                  ); } }
		public int               AvsIndicator             { get { return _GetValue("AvsIndicator"             , m_nAvsIndicator             ); } set { _SetValue("AvsIndicator"             , value, ref m_nAvsIndicator             ); } }
		public string            BankAddress              { get { return _GetValue("BankAddress"              , m_sBankAddress              ); } set { _SetValue("BankAddress"              , value, ref m_sBankAddress              ); } }
		public string            BankCode                 { get { return _GetValue("BankCode"                 , m_sBankCode                 ); } set { _SetValue("BankCode"                 , value, ref m_sBankCode                 ); } }
		public string            BankName                 { get { return _GetValue("BankName"                 , m_sBankName                 ); } set { _SetValue("BankName"                 , value, ref m_sBankName                 ); } }
		//public Batch           Batch                    { get { return _GetValue("Batch"                    , m_oBatch                    ); } set { _SetValue("Batch"                    , value, ref m_oBatch                    ); } }
		public int               BillingCount             { get { return _GetValue("BillingCount"             , m_nBillingCount             ); } set { _SetValue("BillingCount"             , value, ref m_nBillingCount             ); } }
		public string            CancelUrl                { get { return _GetValue("CancelUrl"                , m_sCancelUrl                ); } set { _SetValue("CancelUrl"                , value, ref m_sCancelUrl                ); } }
		public string            CardLevel                { get { return _GetValue("CardLevel"                , m_sCardLevel                ); } set { _SetValue("CardLevel"                , value, ref m_sCardLevel                ); } }
		public string            CardName                 { get { return _GetValue("CardName"                 , m_sCardName                 ); } set { _SetValue("CardName"                 , value, ref m_sCardName                 ); } }
		public CardNumberStorage CardNumberStorage        { get { return _GetValue("CardNumberStorage"        , m_enumCardNumberStorage     ); } set { _SetValue("CardNumberStorage"        , value, ref m_enumCardNumberStorage     ); } }
		public string            CardType                 { get { return _GetValue("CardType"                 , m_sCardType                 ); } set { _SetValue("CardType"                 , value, ref m_sCardType                 ); } }
		public string            CAVV                     { get { return _GetValue("CAVV"                     , m_sCAVV                     ); } set { _SetValue("CAVV"                     , value, ref m_sCAVV                     ); } }
		public string            Certificate              { get { return _GetValue("Certificate"              , m_sCertificate              ); } set { _SetValue("Certificate"              , value, ref m_sCertificate              ); } }
		public string            City                     { get { return _GetValue("City"                     , m_sCity                     ); } set { _SetValue("City"                     , value, ref m_sCity                     ); } }
		public string            ClientIP                 { get { return _GetValue("ClientIP"                 , m_sClientIP                 ); } set { _SetValue("ClientIP"                 , value, ref m_sClientIP                 ); } }
		public string            Code                     { get { return _GetValue("Code"                     , m_sCode                     ); } set { _SetValue("Code"                     , value, ref m_sCode                     ); } }
		public string            Company                  { get { return _GetValue("Company"                  , m_sCompany                  ); } set { _SetValue("Company"                  , value, ref m_sCompany                  ); } }
		public string            ConnectionString         { get { return _GetValue("ConnectionString"         , m_sConnectionString         ); } set { _SetValue("ConnectionString"         , value, ref m_sConnectionString         ); } }
		public string            Country                  { get { return _GetValue("Country"                  , m_sCountry                  ); } set { _SetValue("Country"                  , value, ref m_sCountry                  ); } }
		public string            CryptoPassword           { get { return _GetValue("CryptoPassword"           , m_sCryptoPassword           ); } set { _SetValue("CryptoPassword"           , value, ref m_sCryptoPassword           ); } }
		public object            Currency                 { get { return _GetValue("Currency"                 , m_oCurrency                 ); } set { _SetValue("Currency"                 , value, ref m_oCurrency                 ); } }
		public string            CustomerID               { get { return _GetValue("CustomerID"               , m_sCustomerID               ); } set { _SetValue("CustomerID"               , value, ref m_sCustomerID               ); } }
		public string            Data                     { get { return _GetValue("Data"                     , m_sData                     ); } set { _SetValue("Data"                     , value, ref m_sData                     ); } }
		public string            Debug                    { get { return _GetValue("Debug"                    , m_sDebug                    ); } set { _SetValue("Debug"                    , value, ref m_sDebug                    ); } }
		public string            Description              { get { return _GetValue("Description"              , m_sDescription              ); } set { _SetValue("Description"              , value, ref m_sDescription              ); } }
		public string            DeviceCode               { get { return _GetValue("DeviceCode"               , m_sDeviceCode               ); } set { _SetValue("DeviceCode"               , value, ref m_sDeviceCode               ); } }
		public string            EcheckType               { get { return _GetValue("EcheckType"               , m_sEcheckType               ); } set { _SetValue("EcheckType"               , value, ref m_sEcheckType               ); } }
		public string            Email                    { get { return _GetValue("Email"                    , m_sEmail                    ); } set { _SetValue("Email"                    , value, ref m_sEmail                    ); } }
		public Encoding          Encoding                 { get { return _GetValue("Encoding"                 , m_oEncoding                 ); } set { _SetValue("Encoding"                 , value, ref m_oEncoding                 ); } }
		public string            EncryptionKey            { get { return _GetValue("EncryptionKey"            , m_sEncryptionKey            ); } set { _SetValue("EncryptionKey"            , value, ref m_sEncryptionKey            ); } }
		public string            ErrorCode                { get { return _GetValue("ErrorCode"                , m_sErrorCode                ); } set { _SetValue("ErrorCode"                , value, ref m_sErrorCode                ); } }
		public string            Fax                      { get { return _GetValue("Fax"                      , m_sFax                      ); } set { _SetValue("Fax"                      , value, ref m_sFax                      ); } }
		public string            FirstName                { get { return _GetValue("FirstName"                , m_sFirstName                ); } set { _SetValue("FirstName"                , value, ref m_sFirstName                ); } }
		public long              ID                       { get { return _GetValue("ID"                       , m_lID                       ); } set { _SetValue("ID"                       , value, ref m_lID                       ); } }
		public string            IndustryCode             { get { return _GetValue("IndustryCode"             , m_sIndustryCode             ); } set { _SetValue("IndustryCode"             , value, ref m_sIndustryCode             ); } }
		public DateTime          IssueDate                { get { return _GetValue("IssueDate"                , m_dtIssueDate               ); } set { _SetValue("IssueDate"                , value, ref m_dtIssueDate               ); } }
		public string            IssueNumber              { get { return _GetValue("IssueNumber"              , m_sIssueNumber              ); } set { _SetValue("IssueNumber"              , value, ref m_sIssueNumber              ); } }
		public string            Language                 { get { return _GetValue("Language"                 , m_sLanguage                 ); } set { _SetValue("Language"                 , value, ref m_sLanguage                 ); } }
		public string            LastName                 { get { return _GetValue("LastName"                 , m_sLastName                 ); } set { _SetValue("LastName"                 , value, ref m_sLastName                 ); } }
		public string            Login                    { get { return _GetValue("Login"                    , m_sLogin                    ); } set { _SetValue("Login"                    , value, ref m_sLogin                    ); } }
		public int               MerchantCategoryCode     { get { return _GetValue("MerchantCategoryCode"     , m_nMerchantCategoryCode     ); } set { _SetValue("MerchantCategoryCode"     , value, ref m_nMerchantCategoryCode     ); } }
		public string            MerchantCity             { get { return _GetValue("MerchantCity"             , m_sMerchantCity             ); } set { _SetValue("MerchantCity"             , value, ref m_sMerchantCity             ); } }
		public CountryCode       MerchantCountry          { get { return _GetValue("MerchantCountry"          , m_enumMerchantCountry       ); } set { _SetValue("MerchantCountry"          , value, ref m_enumMerchantCountry       ); } }
		public string            MerchantEmail            { get { return _GetValue("MerchantEmail"            , m_sMerchantEmail            ); } set { _SetValue("MerchantEmail"            , value, ref m_sMerchantEmail            ); } }
		public string            MerchantName             { get { return _GetValue("MerchantName"             , m_sMerchantName             ); } set { _SetValue("MerchantName"             , value, ref m_sMerchantName             ); } }
		public string            MerchantPhone            { get { return _GetValue("MerchantPhone"            , m_sMerchantPhone            ); } set { _SetValue("MerchantPhone"            , value, ref m_sMerchantPhone            ); } }
		public string            MerchantState            { get { return _GetValue("MerchantState"            , m_sMerchantState            ); } set { _SetValue("MerchantState"            , value, ref m_sMerchantState            ); } }
		public string            MerchantUrl              { get { return _GetValue("MerchantUrl"              , m_sMerchantUrl              ); } set { _SetValue("MerchantUrl"              , value, ref m_sMerchantUrl              ); } }
		public string            MerchantZipPostal        { get { return _GetValue("MerchantZipPostal"        , m_sMerchantZipPostal        ); } set { _SetValue("MerchantZipPostal"        , value, ref m_sMerchantZipPostal        ); } }
		public int               Month                    { get { return _GetValue("Month"                    , m_nMonth                    ); } set { _SetValue("Month"                    , value, ref m_nMonth                    ); } }
		public string            Number                   { get { return _GetValue("Number"                   , m_sNumber                   ); } set { _SetValue("Number"                   , value, ref m_sNumber                   ); } }
		public string            OrderID                  { get { return _GetValue("OrderID"                  , m_sOrderID                  ); } set { _SetValue("OrderID"                  , value, ref m_sOrderID                  ); } }
		public double            OriginalAmount           { get { return _GetValue("OriginalAmount"           , m_dOriginalAmount           ); } set { _SetValue("OriginalAmount"           , value, ref m_dOriginalAmount           ); } }
		public string            Partner                  { get { return _GetValue("Partner"                  , m_sPartner                  ); } set { _SetValue("Partner"                  , value, ref m_sPartner                  ); } }
		public string            Password                 { get { return _GetValue("Password"                 , m_sPassword                 ); } set { _SetValue("Password"                 , value, ref m_sPassword                 ); } }
		public int               PaymentIndicator         { get { return _GetValue("PaymentIndicator"         , m_nPaymentIndicator         ); } set { _SetValue("PaymentIndicator"         , value, ref m_nPaymentIndicator         ); } }
		public PaymentMethod     PaymentMethod            { get { return _GetValue("PaymentMethod"            , m_enumPaymentMethod         ); } set { _SetValue("PaymentMethod"            , value, ref m_enumPaymentMethod         ); } }
		public string            Phone                    { get { return _GetValue("Phone"                    , m_sPhone                    ); } set { _SetValue("Phone"                    , value, ref m_sPhone                    ); } }
		public int               Port                     { get { return _GetValue("Port"                     , m_nPort                     ); } set { _SetValue("Port"                     , value, ref m_nPort                     ); } }
		public bool              PreValidate              { get { return _GetValue("PreValidate"              , m_bPreValidate              ); } set { _SetValue("PreValidate"              , value, ref m_bPreValidate              ); } }
		public WebProxy          Proxy                    { get { return _GetValue("Proxy"                    , m_oProxy                    ); } set { _SetValue("Proxy"                    , value, ref m_oProxy                    ); } }
		public string            ProxyHost                { get { return _GetValue("ProxyHost"                , m_sProxyHost                ); } set { _SetValue("ProxyHost"                , value, ref m_sProxyHost                ); } }
		public string            ProxyPort                { get { return _GetValue("ProxyPort"                , m_sProxyPort                ); } set { _SetValue("ProxyPort"                , value, ref m_sProxyPort                ); } }
		public bool              RecurringBilling         { get { return _GetValue("RecurringBilling"         , m_bRecurringBilling         ); } set { _SetValue("RecurringBilling"         , value, ref m_bRecurringBilling         ); } }
		public string            ReferenceNumber          { get { return _GetValue("ReferenceNumber"          , m_sReferenceNumber          ); } set { _SetValue("ReferenceNumber"          , value, ref m_sReferenceNumber          ); } }
		public string            RequestedACI             { get { return _GetValue("RequestedACI"             , m_sRequestedACI             ); } set { _SetValue("RequestedACI"             , value, ref m_sRequestedACI             ); } }
		public string            ReturnedACI              { get { return _GetValue("ReturnedACI"              , m_sReturnedACI              ); } set { _SetValue("ReturnedACI"              , value, ref m_sReturnedACI              ); } }
		public int               SequenceNumber           { get { return _GetValue("SequenceNumber"           , m_nSequenceNumber           ); } set { _SetValue("SequenceNumber"           , value, ref m_nSequenceNumber           ); } }
		public string            Server                   { get { return _GetValue("Server"                   , m_sServer                   ); } set { _SetValue("Server"                   , value, ref m_sServer                   ); } }
		public string            Setting                  { get { return _GetValue("Setting"                  , m_sSetting                  ); } set { _SetValue("Setting"                  , value, ref m_sSetting                  ); } }
		public double            SettleHourInterval       { get { return _GetValue("SettleHourInterval"       , m_dSettleHourInterval       ); } set { _SetValue("SettleHourInterval"       , value, ref m_dSettleHourInterval       ); } }
		public object            SettleInterval           { get { return _GetValue("SettleInterval"           , m_oSettleInterval           ); } set { _SetValue("SettleInterval"           , value, ref m_oSettleInterval           ); } }
		public object            Shipping                 { get { return _GetValue("Shipping"                 , m_oShipping                 ); } set { _SetValue("Shipping"                 , value, ref m_oShipping                 ); } }
		public DateTime          StartDate                { get { return _GetValue("StartDate"                , m_dtStartDate               ); } set { _SetValue("StartDate"                , value, ref m_dtStartDate               ); } }
		public string            StateProvince            { get { return _GetValue("StateProvince"            , m_sStateProvince            ); } set { _SetValue("StateProvince"            , value, ref m_sStateProvince            ); } }
		public int               StoreNumber              { get { return _GetValue("StoreNumber"              , m_nStoreNumber              ); } set { _SetValue("StoreNumber"              , value, ref m_nStoreNumber              ); } }
		public object            Tax                      { get { return _GetValue("Tax"                      , m_oTax                      ); } set { _SetValue("Tax"                      , value, ref m_oTax                      ); } }
		public string            TaxID                    { get { return _GetValue("TaxID"                    , m_sTaxID                    ); } set { _SetValue("TaxID"                    , value, ref m_sTaxID                    ); } }
		public string            TerminalID               { get { return _GetValue("TerminalID"               , m_sTerminalID               ); } set { _SetValue("TerminalID"               , value, ref m_sTerminalID               ); } }
		public int               TerminalNumber           { get { return _GetValue("TerminalNumber"           , m_nTerminalNumber           ); } set { _SetValue("TerminalNumber"           , value, ref m_nTerminalNumber           ); } }
		public bool              TestMode                 { get { return _GetValue("TestMode"                 , m_bTestMode                 ); } set { _SetValue("TestMode"                 , value, ref m_bTestMode                 ); } }
		public int               Timeout                  { get { return _GetValue("Timeout"                  , m_nTimeout                  ); } set { _SetValue("Timeout"                  , value, ref m_nTimeout                  ); } }
		public TimeZone          TimeZone                 { get { return _GetValue("TimeZone"                 , m_enumTimeZone              ); } set { _SetValue("TimeZone"                 , value, ref m_enumTimeZone              ); } }
		public DateTime          TransactionDate          { get { return _GetValue("TransactionDate"          , m_dtTransactionDate         ); } set { _SetValue("TransactionDate"          , value, ref m_dtTransactionDate         ); } }
		public string            TransactionID            { get { return _GetValue("TransactionID"            , m_sTransactionID            ); } set { _SetValue("TransactionID"            , value, ref m_sTransactionID            ); } }
		public string            TransactionKey           { get { return _GetValue("TransactionKey"           , m_sTransactionKey           ); } set { _SetValue("TransactionKey"           , value, ref m_sTransactionKey           ); } }
		public object            TransactionType          { get { return _GetValue("TransactionType"          , m_oTransactionType          ); } set { _SetValue("TransactionType"          , value, ref m_oTransactionType          ); } }
		public string            UserName                 { get { return _GetValue("UserName"                 , m_sUserName                 ); } set { _SetValue("UserName"                 , value, ref m_sUserName                 ); } }
		public int               Year                     { get { return _GetValue("Year"                     , m_nYear                     ); } set { _SetValue("Year"                     , value, ref m_nYear                     ); } }
		public string            ZipPostal                { get { return _GetValue("ZipPostal"                , m_sZipPostal                ); } set { _SetValue("ZipPostal"                , value, ref m_sZipPostal                ); } }

		public string ErrorMessage                 { get { return _GetValue("ErrorMessage", String.Empty); } }
		public string Version                      { get { return _GetValue("Version"     , "1.0"); } }

		public string BankAccountType              { set { _SetValue("BankAccountType"   , value); } }
		//public DataProviderType DataProviderType { set { _SetValue("DataProviderType"  , value); } }
		public string DL                           { set { _SetValue("DL"                , value); } }
		public string DLDOB                        { set { _SetValue("DLDOB"             , value); } }
		public string DLState                      { set { _SetValue("DLState"           , value); } }
		public string OrganizationType             { set { _SetValue("OrganizationType"  , value); } }
		public string Referrer                     { set { _SetValue("Referrer"          , value); } }
		public string TransactionFields            { set { _SetValue("TransactionFields" , value); } }
		public string TransactionOrigin            { set { _SetValue("TransactionOrigin" , value); } }

		protected Assembly    m_asmCHARGE;
		protected System.Type m_typCC    ;
		protected object      m_oCC      ;
		#endregion

		private DbProviderFactories  DbProviderFactories = new DbProviderFactories();
		private HttpApplicationState Application         = new HttpApplicationState();
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;

		public CC(Security Security, Sql Sql, SqlProcs SqlProcs)
		{
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;

			#pragma warning disable 618
			m_asmCHARGE = Assembly.LoadWithPartialName("dotnetCharge");
			#pragma warning restore 618
			if ( m_asmCHARGE != null )
			{
				m_typCC = m_asmCHARGE.GetType("dotnetCHARGE.CC");
				if ( m_typCC != null )
				{
					ConstructorInfo info = m_typCC.GetConstructor(new Type[0]);
					m_oCC = info.Invoke(null);
				}
			}
		}

		#region _SetValue
		private void _SetValue(string name, string value)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				info.SetValue(m_oCC, value, null);
			}
		}

		private void _SetValue(string name, string value, ref string refValue)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				info.SetValue(m_oCC, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		private void _SetValue(string name, int value, ref int refValue)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				info.SetValue(m_oCC, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		private void _SetValue(string name, long value, ref long refValue)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				info.SetValue(m_oCC, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		private void _SetValue(string name, double value, ref double refValue)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				info.SetValue(m_oCC, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		private void _SetValue(string name, bool value, ref bool refValue)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				info.SetValue(m_oCC, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		private void _SetValue(string name, DateTime value, ref DateTime refValue)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				info.SetValue(m_oCC, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		private void _SetValue(string name, object value, ref object refValue)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				info.SetValue(m_oCC, value, null);
			}
			else
			{
				refValue = value;
			}
		}

		private void _SetValue(string name, CountryCode value, ref CountryCode refValue)
		{
			if ( m_oCC != null )
			{
				Type typCountryCode = m_asmCHARGE.GetType("dotnetCHARGE.CountryCode");

				PropertyInfo info = m_typCC.GetProperty(name);
				object eValue = Enum.Parse(typCountryCode, Enum.GetName(typeof(CountryCode), value));
				info.SetValue(m_oCC, eValue, null);
			}
			else
			{
				refValue = value;
			}
		}

		private void _SetValue(string name, PaymentMethod value, ref PaymentMethod refValue)
		{
			if ( m_oCC != null )
			{
				Type typPaymentMethod = m_asmCHARGE.GetType("dotnetCHARGE.PaymentMethod");

				PropertyInfo info = m_typCC.GetProperty(name);
				object eValue = Enum.Parse(typPaymentMethod, Enum.GetName(typeof(PaymentMethod), value));
				info.SetValue(m_oCC, eValue, null);
			}
			else
			{
				refValue = value;
			}
		}

		private void _SetValue(string name, CardNumberStorage value, ref CardNumberStorage refValue)
		{
			if ( m_oCC != null )
			{
				Type typCardNumberStorage = m_asmCHARGE.GetType("dotnetCHARGE.CardNumberStorage");

				PropertyInfo info = m_typCC.GetProperty(name);
				object eValue = Enum.Parse(typCardNumberStorage, Enum.GetName(typeof(CardNumberStorage), value));
				info.SetValue(m_oCC, eValue, null);
			}
			else
			{
				refValue = value;
			}
		}

		private void _SetValue(string name, TimeZone value, ref TimeZone refValue)
		{
			if ( m_oCC != null )
			{
				Type typTimeZone = m_asmCHARGE.GetType("dotnetCHARGE.TimeZone");

				PropertyInfo info = m_typCC.GetProperty(name);
				object eValue = Enum.Parse(typTimeZone, Enum.GetName(typeof(TimeZone), value));
				info.SetValue(m_oCC, eValue, null);
			}
			else
			{
				refValue = value;
			}
		}

		private void _SetValue(string name, Encoding value, ref Encoding refValue)
		{
			if ( m_oCC != null )
			{
				Type typEncoding = typeof(System.Text.Encoding);

				PropertyInfo info = m_typCC.GetProperty(name);
				object eValue = Enum.Parse(typEncoding, Enum.GetName(typeof(Encoding), value));
				info.SetValue(m_oCC, eValue, null);
			}
			else
			{
				refValue = value;
			}
		}

		private void _SetValue(string name, WebProxy value, ref WebProxy refValue)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				info.SetValue(m_oCC, value, null);
			}
			else
			{
				refValue = value;
			}
		}
		#endregion

		#region GetValue
		private string _GetValue(string name, string value)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				return info.GetValue(m_oCC, null) as string;
			}
			return value;
		}

		private int _GetValue(string name, int value)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				return (int) info.GetValue(m_oCC, null);
			}
			return value;
		}

		private long _GetValue(string name, long value)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				return (long) info.GetValue(m_oCC, null);
			}
			return value;
		}

		private double _GetValue(string name, double value)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				return (double) info.GetValue(m_oCC, null);
			}
			return value;
		}

		private bool _GetValue(string name, bool value)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				return (bool) info.GetValue(m_oCC, null);
			}
			return value;
		}

		private DateTime _GetValue(string name, DateTime value)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				return (DateTime) info.GetValue(m_oCC, null);
			}
			return value;
		}

		private object _GetValue(string name, object value)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				return info.GetValue(m_oCC, null);
			}
			return value;
		}

		public CountryCode _GetValue(string name, CountryCode value)
		{
			if ( m_oCC != null )
			{
				Type typCountryCode = m_asmCHARGE.GetType("dotnetCHARGE.CountryCode");

				PropertyInfo info = m_typCC.GetProperty(name);
				return (CountryCode) Enum.Parse(typeof(CountryCode), Enum.GetName(typCountryCode, info.GetValue(m_oCC, null)));
			}
			return value;
		}

		public PaymentMethod _GetValue(string name, PaymentMethod value)
		{
			if ( m_oCC != null )
			{
				Type typPaymentMethod = m_asmCHARGE.GetType("dotnetCHARGE.PaymentMethod");

				PropertyInfo info = m_typCC.GetProperty(name);
				return (PaymentMethod) Enum.Parse(typeof(PaymentMethod), Enum.GetName(typPaymentMethod, info.GetValue(m_oCC, null)));
			}
			return value;
		}

		public CardNumberStorage _GetValue(string name, CardNumberStorage value)
		{
			if ( m_oCC != null )
			{
				Type typCardNumberStorage = m_asmCHARGE.GetType("dotnetCHARGE.CardNumberStorage");

				PropertyInfo info = m_typCC.GetProperty(name);
				return (CardNumberStorage) Enum.Parse(typeof(CardNumberStorage), Enum.GetName(typCardNumberStorage, info.GetValue(m_oCC, null)));
			}
			return value;
		}

		public TimeZone _GetValue(string name, TimeZone value)
		{
			if ( m_oCC != null )
			{
				Type typTimeZone = m_asmCHARGE.GetType("dotnetCHARGE.TimeZone");

				PropertyInfo info = m_typCC.GetProperty(name);
				return (TimeZone) Enum.Parse(typeof(TimeZone), Enum.GetName(typTimeZone, info.GetValue(m_oCC, null)));
			}
			return value;
		}

		public Encoding _GetValue(string name, Encoding value)
		{
			if ( m_oCC != null )
			{
				Type typEncoding = typeof(System.Text.Encoding);

				PropertyInfo info = m_typCC.GetProperty(name);
				return (Encoding) Enum.Parse(typeof(Encoding), Enum.GetName(typEncoding, info.GetValue(m_oCC, null)));
			}
			return value;
		}

		public WebProxy _GetValue(string name, WebProxy value)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				return info.GetValue(m_oCC, null) as WebProxy;
			}
			return value;
		}
		#endregion

		/*
		public Batch _GetValue(string name, Batch value)
		{
			if ( m_oCC != null )
			{
				PropertyInfo info = m_typCC.GetProperty(name);
				return info.GetValue(m_oCC, null) as Batch;
			}
			return value;
		}
		*/

		#region AddParameter
		public void AddParameter(string keyValue)
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[1];
				types[0] = Type.GetType("System.String");

				MethodInfo info = m_typCC.GetMethod("AddParameter", types);
				object[] parameters = new object[1];
				parameters[0] = keyValue;
				info.Invoke(m_oCC, parameters);
			}
		}

		public void AddParameter(string keyName, string valueName)
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[2];
				types[0] = Type.GetType("System.String");
				types[1] = Type.GetType("System.String");

				MethodInfo info = m_typCC.GetMethod("AddParameter", types);
				object[] parameters = new object[2];
				parameters[0] = keyName;
				parameters[1] = valueName;
				info.Invoke(m_oCC, parameters);
			}
		}
		#endregion

		#region Methods
		public int Charge(Processor processor)
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[1];
				types[0] = m_asmCHARGE.GetType("dotnetCHARGE.Processor");

				MethodInfo info = m_typCC.GetMethod("Charge", types);
				object[] parameters = new object[1];
				parameters[0] = Enum.Parse(m_typCC, Enum.GetName(typeof(Processor), processor));
				return (int) info.Invoke(m_oCC, parameters);
			}
			else if ( !m_bTestMode )
			{
				throw(new Exception("dontnetCHARGE could not be loaded."));
			}
			// 03/06/2008 Paul.  In test mode, the charge always succeeds. 
			m_sTransactionID   = Guid.NewGuid().ToString();
			m_sReferenceNumber = DateTime.Now.Ticks.ToString();
			return 1;
		}

		public int Charge(string strProcessor)
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[1];
				types[0] = Type.GetType("System.String");

				MethodInfo info = m_typCC.GetMethod("Charge", types);
				object[] parameters = new object[1];
				parameters[0] = strProcessor;
				return (int) info.Invoke(m_oCC, parameters);
			}
			else if ( !m_bTestMode )
			{
				throw(new Exception("dontnetCHARGE could not be loaded."));
			}
			// 03/06/2008 Paul.  In test mode, the charge always succeeds. 
			m_sTransactionID   = Guid.NewGuid().ToString();
			m_sReferenceNumber = DateTime.Now.Ticks.ToString();
			return 1;
		}

		public string Decrypt(string inputData)
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[1];
				types[0] = Type.GetType("System.String");

				MethodInfo info = m_typCC.GetMethod("Decrypt", types);
				object[] parameters = new object[1];
				parameters[0] = inputData;
				return info.Invoke(m_oCC, parameters) as string;
			}
			return String.Empty;
		}

		public string Decrypt(string inputData, string inputKey)
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[2];
				types[0] = Type.GetType("System.String");
				types[1] = Type.GetType("System.String");

				MethodInfo info = m_typCC.GetMethod("Decrypt", types);
				object[] parameters = new object[2];
				parameters[0] = inputData;
				parameters[1] = inputKey;
				return info.Invoke(m_oCC, parameters) as string;
			}
			return String.Empty;
		}

		public string Encrypt(string inputData)
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[1];
				types[0] = Type.GetType("System.String");

				MethodInfo info = m_typCC.GetMethod("Encrypt", types);
				object[] parameters = new object[1];
				parameters[0] = inputData;
				return info.Invoke(m_oCC, parameters) as string;
			}
			return String.Empty;
		}

		public string Encrypt(string inputData, string inputKey)
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[2];
				types[0] = Type.GetType("System.String");
				types[1] = Type.GetType("System.String");

				MethodInfo info = m_typCC.GetMethod("Encrypt", types);
				object[] parameters = new object[2];
				parameters[0] = inputData;
				parameters[1] = inputKey;
				return info.Invoke(m_oCC, parameters) as string;
			}
			return String.Empty;
		}

		public string GenerateID(int numBytes)
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[1];
				types[0] = Type.GetType("System.Int32");

				MethodInfo info = m_typCC.GetMethod("GenerateID", types);
				object[] parameters = new object[1];
				parameters[0] = numBytes;
				return info.Invoke(m_oCC, parameters) as string;
			}
			return String.Empty;
		}

		public string GenerateOrderID()
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[0];

				MethodInfo info = m_typCC.GetMethod("GenerateOrderID", types);
				object[] parameters = new object[0];
				return info.Invoke(m_oCC, parameters) as string;
			}
			return String.Empty;
		}

		public string GetCardType(Processor processorType)
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[1];
				types[0] = m_asmCHARGE.GetType("dotnetCHARGE.Processor");

				MethodInfo info = m_typCC.GetMethod("GetCardType", types);
				object[] parameters = new object[1];
				parameters[0] = Enum.Parse(m_typCC, Enum.GetName(typeof(Processor), processorType));
				return info.Invoke(m_oCC, parameters) as string;
			}
			return String.Empty;
		}

		public string GetCardType(string creditCardNumber)
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[1];
				types[0] = Type.GetType("System.String");

				MethodInfo info = m_typCC.GetMethod("GetCardType", types);
				object[] parameters = new object[1];
				parameters[0] = creditCardNumber;
				return info.Invoke(m_oCC, parameters) as string;
			}
			return String.Empty;
		}

		public string GetCardType(string creditCardNumber, Processor processorType)
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[2];
				types[0] = Type.GetType("System.String");
				types[1] = m_asmCHARGE.GetType("dotnetCHARGE.Processor");

				MethodInfo info = m_typCC.GetMethod("GetCardType", types);
				object[] parameters = new object[2];
				parameters[0] = creditCardNumber;
				parameters[1] = Enum.Parse(m_typCC, Enum.GetName(typeof(Processor), processorType));
				return info.Invoke(m_oCC, parameters) as string;
			}
			return String.Empty;
		}

		public string GetParameter(string name)
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[1];
				types[0] = Type.GetType("System.String");

				MethodInfo info = m_typCC.GetMethod("GetParameter", types);
				object[] parameters = new object[1];
				parameters[0] = name;
				return info.Invoke(m_oCC, parameters) as string;
			}
			return String.Empty;
		}

		public bool IsOrderIdRequired()
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[0];

				MethodInfo info = m_typCC.GetMethod("IsOrderIdRequired", types);
				object[] parameters = new object[0];
				return (bool) info.Invoke(m_oCC, parameters);
			}
			return false;
		}

		public bool LoadDB(string myAuthCode)
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[1];
				types[0] = Type.GetType("System.String");

				MethodInfo info = m_typCC.GetMethod("LoadDB", types);
				object[] parameters = new object[1];
				parameters[0] = myAuthCode;
				return (bool) info.Invoke(m_oCC, parameters);
			}
			return false;
		}

		public int UpdateEncryptedDataDB(string oldPassword, string newPassword, string confirmNewPassword)
		{
			if ( m_oCC != null )
			{
				Type[] types = new Type[3];
				types[0] = Type.GetType("System.String");
				types[1] = Type.GetType("System.String");
				types[2] = Type.GetType("System.String");

				MethodInfo info = m_typCC.GetMethod("UpdateEncryptedDataDB", types);
				object[] parameters = new object[3];
				parameters[0] = oldPassword;
				parameters[1] = newPassword;
				parameters[2] = confirmNewPassword;
				return (int) info.Invoke(m_oCC, parameters);
			}
			return 0;
		}
		#endregion

		/*
		// 10/19/2010 Paul.  We don't use the simplified Refund method because the refund must go through the same gateway as the original charge. 
		public string Refund(Guid gID, Guid gCURRENCY_ID, Guid gACCOUNT_ID, Guid gCREDIT_CARD_ID, string sClientIP, string sOrderID, string sDESCRIPTION, Decimal dAMOUNT, string sTransactionID)
		{
			string sPaymentGateway          = Sql.ToString (Application["CONFIG.PaymentGateway"         ]);
			string sPaymentGateway_Login    = Sql.ToString (Application["CONFIG.PaymentGateway_Login"   ]);
			string sPaymentGateway_Password = Sql.ToString (Application["CONFIG.PaymentGateway_Password"]);
			bool   bPaymentGateway_TestMode = Sql.ToBoolean(Application["CONFIG.PaymentGateway_TestMode"]);
			return Charge(gID, gCURRENCY_ID, gACCOUNT_ID, gCREDIT_CARD_ID, sClientIP, sOrderID, sDESCRIPTION, "Refund", dAMOUNT, sTransactionID, sPaymentGateway, sPaymentGateway_Login, sPaymentGateway_Password, bPaymentGateway_TestMode);
		}
		*/

		// 06/19/2008 Paul.  We need to return the status so that we can quickly determine if the operation succeeded. 
		public /*static*/ string Charge(Guid gID, Guid gCURRENCY_ID, Guid gACCOUNT_ID, Guid gCREDIT_CARD_ID, string sClientIP, string sOrderID, string sDESCRIPTION, string sTransactionType, Decimal dAMOUNT, string sTransactionID, string sPaymentGateway, string sPaymentGateway_Login, string sPaymentGateway_Password, bool bPaymentGateway_TestMode)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);

			SplendidCRM.SplendidCharge.DotNetCharge.CC oCharge = this;
			// 01/06/2011 Paul.  CyberSource requires a certificates directory. 
			oCharge.Certificate   = Sql.ToString(Application["CONFIG.CreditCard.Certificates"]);
			// Transaction Details
			// 05/26/2024 Paul.  Change name to ApplicationCC. 
			oCharge.ApplicationCC = "SplendidCRM";
			oCharge.ClientIP      = sClientIP;
			// 04/22/2008 Paul.  We always need to create a unique OrderID. Otherwise, an error will be generated when a second 
			// submit is performed, even if that second submit attempts to correct a zip code. 
			// 04/22/2008 Paul.  We cannot always append a timestamp as the Order ID must match the original ID during a refund operation. 
			oCharge.OrderID       = sOrderID;
			oCharge.Description   = sDESCRIPTION;
			oCharge.Amount        = Convert.ToDouble(dAMOUNT);
			// 04/22/2008 Paul.  TransactionID only applies to Refund, Void and PostAuthorize transaction types. 
			oCharge.TransactionID = sTransactionID;
			
			// Merchant Account Details
			oCharge.TestMode = bPaymentGateway_TestMode;
			oCharge.Login    = sPaymentGateway_Login;
			if ( !Sql.IsEmptyString(sPaymentGateway_Password) )
				oCharge.Password = Security.DecryptPassword(sPaymentGateway_Password, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			// 02/21/2008 Paul.  Default transaction type is sale. 
			// 04/22/2008 Paul.  The calling function will provide the correct transaction type. 
			oCharge.TransactionType = sTransactionType;
			if ( Sql.IsEmptyString(sPaymentGateway) )
				throw(new Exception("PaymentGateway has not been defined."));

			string sSTATUS = "Prevalidation";
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL ;
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
							string sCARD_NUMBER = Sql.ToString(rdr["CARD_NUMBER"]);
							if ( Sql.ToBoolean(rdr["IS_ENCRYPTED"]) )
							{
								sCARD_NUMBER = Security.DecryptPassword(sCARD_NUMBER, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
							}
							string sCARD_TYPE = Sql.ToString(rdr["CARD_TYPE"]);
							if ( sCARD_TYPE.StartsWith("Bank Draft") )
							{
								if ( sCARD_TYPE == "Bank Draft - Checking" )
									oCharge.BankAccountType = "Checking";
								else if ( sCARD_TYPE == "Bank Draft - Savings" )
									oCharge.BankAccountType = "Savings";
								oCharge.Number   = sCARD_NUMBER;
								oCharge.BankName = Sql.ToString(rdr["BANK_NAME"          ]);
								oCharge.BankCode = Sql.ToString(rdr["BANK_ROUTING_NUMBER"]);
							}
							else
							{
								DateTime dtEXPIRATION_DATE = Sql.ToDateTime(rdr["EXPIRATION_DATE"]);
								// Card Details
								// 01/08/2011 Paul.  CyberSource complains if the card type is specified
								// ics_rmsg: The field is invalid: card_type
								// auth_rmsg: The field is invalid: card_type
								if ( sPaymentGateway != "CyberSource" )
									oCharge.CardType = sCARD_TYPE;
								oCharge.Number   = sCARD_NUMBER;
								oCharge.Month    = dtEXPIRATION_DATE.Month;
								oCharge.Year     = dtEXPIRATION_DATE.Year;
								oCharge.Code     = Sql.ToString(rdr["SECURITY_CODE"]);
							}

							// Address Details
							oCharge.CardName      = Sql.ToString(rdr["NAME"              ]);
							// 01/08/2011 Paul.  CyberSource requires first and last name. For now, lets just split the name field. 
							// 01/08/2011 Paul.  CyberSource also requires an email, but that can be provided in the Account or Contact record. 
							if ( sPaymentGateway == "CyberSource" )
							{
								string[] arrName = oCharge.CardName.Split(' ');
								oCharge.LastName = arrName[arrName.Length-1];
								if ( arrName.Length > 1 )
									oCharge.FirstName = arrName[0];
							}
							oCharge.Address       = Sql.ToString(rdr["ADDRESS_STREET"    ]);
							oCharge.City          = Sql.ToString(rdr["ADDRESS_CITY"      ]);
							oCharge.StateProvince = Sql.ToString(rdr["ADDRESS_STATE"     ]);
							oCharge.ZipPostal     = Sql.ToString(rdr["ADDRESS_POSTALCODE"]);
							oCharge.Country       = Sql.ToString(rdr["ADDRESS_COUNTRY"   ]);
							// 12/15/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
							oCharge.Email         = Sql.ToString(rdr["EMAIL"             ]);
							oCharge.Phone         = Sql.ToString(rdr["PHONE"             ]);
						}
					}
				}
				sSQL = "select *         " + ControlChars.CrLf
				     + "  from vwACCOUNTS" + ControlChars.CrLf
				     + " where ID = @ID  " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gACCOUNT_ID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							// 12/12/2015 Paul.  The Customer ID may be the Contact ID. 
							oCharge.CustomerID    = Sql.ToString(rdr["ID"                ]);
							oCharge.Company       = Sql.ToString(rdr["NAME"              ]);
							if ( Sql.IsEmptyString(oCharge.Phone) )
								oCharge.Phone         = Sql.ToString(rdr["PHONE_OFFICE"      ]);
							if ( Sql.IsEmptyString(oCharge.Email) )
								oCharge.Email         = Sql.ToString(rdr["EMAIL1"            ]);
						}
					}
				}
				// 01/08/2011 Paul.  One implementation of SplendidCRM uses the CONTACTS table as the relationship for credit cards.
				// If a match is found, then use the Contact record data. 
				sSQL = "select *         " + ControlChars.CrLf
				     + "  from vwCONTACTS" + ControlChars.CrLf
				     + " where ID = @ID  " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gACCOUNT_ID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							oCharge.FirstName     = Sql.ToString(rdr["FIRST_NAME"        ]);
							oCharge.LastName      = Sql.ToString(rdr["LAST_NAME"         ]);
							oCharge.Company       = Sql.ToString(rdr["ACCOUNT_NAME"      ]);
							if ( Sql.IsEmptyString(oCharge.Phone) )
								oCharge.Phone         = Sql.ToString(rdr["PHONE_WORK"        ]);
							if ( Sql.IsEmptyString(oCharge.Email) )
								oCharge.Email         = Sql.ToString(rdr["EMAIL1"            ]);
							// 12/12/2015 Paul.  The Customer ID may be the Contact ID. 
							oCharge.CustomerID    = Sql.ToString(rdr["ID"                ]);
						}
					}
				}
				// 04/22/2008 Paul.  For a Refund, we are getting an error if the CustomerID is provided. 
				// invalid amount parameter:84239632-5f03-4b86-bd9f-5e1f3cd6a3c9
				// 01/11/2011 Paul.  CyberSource does not like the CustomerID, even for a Sale. 
				if ( !Sql.IsEmptyString(sTransactionID) || Sql.ToBoolean(Application["CONFIG.CreditCard.HideCustomerID"]) )
					oCharge.CustomerID = String.Empty;
				
				Guid gPAYMENTS_TRANSACTION_ID = Guid.Empty;
				// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						// 10/28/2010 Paul.  Include the login in the PAYMENT_GATEWAY for better tracking. 
						SqlProcs.spPAYMENTS_TRANSACTIONS_InsertOnly
							( ref gPAYMENTS_TRANSACTION_ID
							, gID
							, sPaymentGateway + ": " + sPaymentGateway_Login
							, sTransactionType  // Sale or Refund. 
							, dAMOUNT
							, gCURRENCY_ID
							, sOrderID
							, sDESCRIPTION
							, gCREDIT_CARD_ID
							, gACCOUNT_ID
							, sSTATUS
							, trn
							);
						trn.Commit();
					}
					catch(Exception ex)
					{
						trn.Rollback();
						throw(new Exception(ex.Message, ex.InnerException));
					}
				}
				try
				{
					int iResult = oCharge.Charge(sPaymentGateway);
					switch ( iResult )
					{
						case 1 :  sSTATUS = "Success"            ;  break;
						case 2 :  sSTATUS = "Prevalidation error";  break;
						case 3 :  sSTATUS = "Gateway error"      ;  break;
						default:  sSTATUS = "Unknown status " + iResult.ToString();  break;
					}
				}
				finally
				{
					// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spPAYMENTS_TRANSACTIONS_Update
								( gPAYMENTS_TRANSACTION_ID
								, sSTATUS
								, oCharge.TransactionID
								, oCharge.ReferenceNumber
								, oCharge.AuthCode
								, oCharge.AvsCode
								, oCharge.ErrorCode
								, oCharge.ErrorMessage
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
	}
}
