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
using System.Diagnostics;
using SplendidCRM;

namespace Spring.Social.QuickBooks
{
	public class Customer : QObject
	{
		#region Properties
		public bool   Active             ;
		public string ParentId           ;
		public string ParentName         ;
		public string Salutation         ;
		public string GivenName          ;
		public string MiddleName         ;
		public string FamilyName         ;
		public string PrimaryPhone       ;
		public string Fax                ;
		public string AlternatePhone     ;
		public string PrimaryEmailAddr   ;
		public string Notes              ;
		public string BillingStreet      ;
		public string BillingCity        ;
		public string BillingState       ;
		public string BillingPostalCode  ;
		public string BillingCountry     ;
		public string ShippingStreet     ;
		public string ShippingCity       ;
		public string ShippingState      ;
		public string ShippingPostalCode ;
		public string ShippingCountry    ;
		#endregion
		protected DataView vwParents;

		public Customer(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.QuickBooks.Api.IQuickBooks quickBooks, DataTable dtParents, bool bShortStateName, bool bShortCountryName)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, "Customers", "Name", "Accounts", "ACCOUNTS", "NAME", true, bShortStateName, bShortCountryName)
		{
			if ( dtParents != null )
				this.vwParents = new DataView(dtParents);
		}

		public override void Reset()
		{
			base.Reset();
			this.Active             = true;
			this.ParentId           = String.Empty;
			this.ParentName         = String.Empty;
			this.Salutation         = String.Empty;
			this.GivenName          = String.Empty;
			this.MiddleName         = String.Empty;
			this.FamilyName         = String.Empty;
			this.PrimaryPhone       = String.Empty;
			this.Fax                = String.Empty;
			this.AlternatePhone     = String.Empty;
			this.PrimaryEmailAddr   = String.Empty;
			this.Notes              = String.Empty;
			this.BillingStreet      = String.Empty;
			this.BillingCity        = String.Empty;
			this.BillingState       = String.Empty;
			this.BillingPostalCode  = String.Empty;
			this.BillingCountry     = String.Empty;
			this.ShippingStreet     = String.Empty;
			this.ShippingCity       = String.Empty;
			this.ShippingState      = String.Empty;
			this.ShippingPostalCode = String.Empty;
			this.ShippingCountry    = String.Empty;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			if ( this.vwParents != null )
			{
				this.vwParents.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["PARENT_ID"]) + "'";
				if ( this.vwParents.Count > 0 )
					this.ParentId = Sql.ToString(this.vwParents[0]["SYNC_REMOTE_KEY"]);
			}
			
			this.ID = sID;
			this.LOCAL_ID = Sql.ToGuid(row["ID"]);
			if ( Sql.IsEmptyString(this.ID) )
			{
				this.Name               = this.CleanName(Sql.ToString(row["NAME"])       );
				this.Notes              = Sql.ToString(row["DESCRIPTION"                ]);
				this.PrimaryEmailAddr   = Sql.ToString(row["EMAIL1"                     ]);
				this.AlternatePhone     = Sql.ToString(row["PHONE_ALTERNATE"            ]);
				this.Fax                = Sql.ToString(row["PHONE_FAX"                  ]);
				this.PrimaryPhone       = Sql.ToString(row["PHONE_OFFICE"               ]);
				this.BillingStreet      = Sql.ToString(row["BILLING_ADDRESS_STREET"     ]);
				this.BillingCity        = Sql.ToString(row["BILLING_ADDRESS_CITY"       ]);
				this.BillingState       = Sql.ToString(row["BILLING_ADDRESS_STATE"      ]);
				this.BillingPostalCode  = Sql.ToString(row["BILLING_ADDRESS_POSTALCODE" ]);
				this.BillingCountry     = Sql.ToString(row["BILLING_ADDRESS_COUNTRY"    ]);
				this.ShippingStreet     = Sql.ToString(row["SHIPPING_ADDRESS_STREET"    ]);
				this.ShippingCity       = Sql.ToString(row["SHIPPING_ADDRESS_CITY"      ]);
				this.ShippingState      = Sql.ToString(row["SHIPPING_ADDRESS_STATE"     ]);
				this.ShippingPostalCode = Sql.ToString(row["SHIPPING_ADDRESS_POSTALCODE"]);
				this.ShippingCountry    = Sql.ToString(row["SHIPPING_ADDRESS_COUNTRY"   ]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.Name              , row["NAME"                       ], "NAME"                       , sbChanges) ) { this.Name               = this.CleanName(Sql.ToString(row["NAME"])       );  bChanged = true; }
				if ( Compare(this.Notes             , row["DESCRIPTION"                ], "DESCRIPTION"                , sbChanges) ) { this.Notes              = Sql.ToString(row["DESCRIPTION"                ]);  bChanged = true; }
				if ( Compare(this.PrimaryEmailAddr  , row["EMAIL1"                     ], "EMAIL1"                     , sbChanges) ) { this.PrimaryEmailAddr   = Sql.ToString(row["EMAIL1"                     ]);  bChanged = true; }
				if ( Compare(this.AlternatePhone    , row["PHONE_ALTERNATE"            ], "PHONE_ALTERNATE"            , sbChanges) ) { this.AlternatePhone     = Sql.ToString(row["PHONE_ALTERNATE"            ]);  bChanged = true; }
				if ( Compare(this.Fax               , row["PHONE_FAX"                  ], "PHONE_FAX"                  , sbChanges) ) { this.Fax                = Sql.ToString(row["PHONE_FAX"                  ]);  bChanged = true; }
				if ( Compare(this.PrimaryPhone      , row["PHONE_OFFICE"               ], "PHONE_OFFICE"               , sbChanges) ) { this.PrimaryPhone       = Sql.ToString(row["PHONE_OFFICE"               ]);  bChanged = true; }
				if ( Compare(this.BillingStreet     , row["BILLING_ADDRESS_STREET"     ], "BillingStreet"              , sbChanges) ) { this.BillingStreet      = Sql.ToString(row["BILLING_ADDRESS_STREET"     ]);  bChanged = true; }
				if ( Compare(this.BillingCity       , row["BILLING_ADDRESS_CITY"       ], "BILLING_ADDRESS_CITY"       , sbChanges) ) { this.BillingCity        = Sql.ToString(row["BILLING_ADDRESS_CITY"       ]);  bChanged = true; }
				if ( Compare(this.BillingState      , row["BILLING_ADDRESS_STATE"      ], "BILLING_ADDRESS_STATE"      , sbChanges) ) { this.BillingState       = Sql.ToString(row["BILLING_ADDRESS_STATE"      ]);  bChanged = true; }
				if ( Compare(this.BillingPostalCode , row["BILLING_ADDRESS_POSTALCODE" ], "BILLING_ADDRESS_POSTALCODE" , sbChanges) ) { this.BillingPostalCode  = Sql.ToString(row["BILLING_ADDRESS_POSTALCODE" ]);  bChanged = true; }
				if ( Compare(this.BillingCountry    , row["BILLING_ADDRESS_COUNTRY"    ], "BILLING_ADDRESS_COUNTRY"    , sbChanges) ) { this.BillingCountry     = Sql.ToString(row["BILLING_ADDRESS_COUNTRY"    ]);  bChanged = true; }
				if ( Compare(this.ShippingStreet    , row["SHIPPING_ADDRESS_STREET"    ], "ShippingStreet"             , sbChanges) ) { this.ShippingStreet     = Sql.ToString(row["SHIPPING_ADDRESS_STREET"    ]);  bChanged = true; }
				if ( Compare(this.ShippingCity      , row["SHIPPING_ADDRESS_CITY"      ], "SHIPPING_ADDRESS_CITY"      , sbChanges) ) { this.ShippingCity       = Sql.ToString(row["SHIPPING_ADDRESS_CITY"      ]);  bChanged = true; }
				if ( Compare(this.ShippingState     , row["SHIPPING_ADDRESS_STATE"     ], "SHIPPING_ADDRESS_STATE"     , sbChanges) ) { this.ShippingState      = Sql.ToString(row["SHIPPING_ADDRESS_STATE"     ]);  bChanged = true; }
				if ( Compare(this.ShippingPostalCode, row["SHIPPING_ADDRESS_POSTALCODE"], "SHIPPING_ADDRESS_POSTALCODE", sbChanges) ) { this.ShippingPostalCode = Sql.ToString(row["SHIPPING_ADDRESS_POSTALCODE"]);  bChanged = true; }
				if ( Compare(this.ShippingCountry   , row["SHIPPING_ADDRESS_COUNTRY"   ], "SHIPPING_ADDRESS_COUNTRY"   , sbChanges) ) { this.ShippingCountry    = Sql.ToString(row["SHIPPING_ADDRESS_COUNTRY"   ]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromQuickBooks(string sId)
		{
			this.Reset();
			Spring.Social.QuickBooks.Api.Customer obj = this.quickBooks.CustomerOperations.GetById(sId);
			this.RawContent        = obj.RawContent           ;
			this.ID                = obj.Id                   ;
			this.TimeCreated       = obj.TimeCreated          ;
			this.TimeModified      = obj.TimeModified         ;
			this.Name              = obj.DisplayName          ;
			this.Active            = obj.ActiveValue          ;
			this.ParentId          = obj.ParentRefValue       ;
			//this.CompanyName       = obj.CompanyName          ;
			//this.Salutation        = obj.Salutation           ;
			this.GivenName         = obj.GivenName            ;
			this.MiddleName        = obj.MiddleName           ;
			this.FamilyName        = obj.FamilyName           ;
			this.Notes             = obj.Notes                ;
			this.PrimaryEmailAddr  = obj.PrimaryEmailAddrValue;
			this.AlternatePhone    = obj.AlternatePhoneValue  ;
			this.Fax               = obj.FaxValue             ;
			this.PrimaryPhone      = obj.PrimaryPhoneValue    ;
			if ( obj.BillAddr != null )
			{
				StringBuilder sbStreet = new StringBuilder();
				if ( !Sql.IsEmptyString(obj.BillAddr.Line1) ) sbStreet.AppendLine(obj.BillAddr.Line1);
				if ( !Sql.IsEmptyString(obj.BillAddr.Line2) ) sbStreet.AppendLine(obj.BillAddr.Line2);
				if ( !Sql.IsEmptyString(obj.BillAddr.Line3) ) sbStreet.AppendLine(obj.BillAddr.Line3);
				if ( !Sql.IsEmptyString(obj.BillAddr.Line4) ) sbStreet.AppendLine(obj.BillAddr.Line4);
				if ( !Sql.IsEmptyString(obj.BillAddr.Line5) ) sbStreet.AppendLine(obj.BillAddr.Line5);
				// 03/11/2015 Paul.  Remove trailing line feed. 
				this.BillingStreet     = Sql.ToString(sbStreet.ToString()).Trim();
				this.BillingCity       = Sql.ToString(obj.BillAddr.City                  );
				this.BillingState      = Sql.ToString(obj.BillAddr.CountrySubDivisionCode);
				this.BillingPostalCode = Sql.ToString(obj.BillAddr.PostalCode            );
				this.BillingCountry    = Sql.ToString(obj.BillAddr.Country               );
				// 03/06/2015 Paul.  We do not need to use GoogleUtils.ConvertAddressV3() on a customer record as the UI has City, State, Zip fields. 
				// Only needed for Invoices, Estimates and CreditMemo. 
			}
			if ( obj.ShipAddr != null )
			{
				StringBuilder sbStreet = new StringBuilder();
				if ( !Sql.IsEmptyString(obj.ShipAddr.Line1) ) sbStreet.AppendLine(obj.ShipAddr.Line1);
				if ( !Sql.IsEmptyString(obj.ShipAddr.Line2) ) sbStreet.AppendLine(obj.ShipAddr.Line2);
				if ( !Sql.IsEmptyString(obj.ShipAddr.Line3) ) sbStreet.AppendLine(obj.ShipAddr.Line3);
				if ( !Sql.IsEmptyString(obj.ShipAddr.Line4) ) sbStreet.AppendLine(obj.ShipAddr.Line4);
				if ( !Sql.IsEmptyString(obj.ShipAddr.Line5) ) sbStreet.AppendLine(obj.ShipAddr.Line5);
				// 03/11/2015 Paul.  Remove trailing line feed. 
				this.ShippingStreet     = Sql.ToString(sbStreet.ToString()).Trim();
				this.ShippingCity       = Sql.ToString(obj.ShipAddr.City                  );
				this.ShippingState      = Sql.ToString(obj.ShipAddr.CountrySubDivisionCode);
				this.ShippingPostalCode = Sql.ToString(obj.ShipAddr.PostalCode            );
				this.ShippingCountry    = Sql.ToString(obj.ShipAddr.Country               );
				// 03/06/2015 Paul.  We do not need to use GoogleUtils.ConvertAddressV3() on a customer record as the UI has City, State, Zip fields. 
				// Only needed for Invoices, Estimates and CreditMemo. 
			}
		}

		// http://stackoverflow.com/questions/27693578/issues-with-special-characters-in-qbo-api-v3-net-sdk
		protected string CleanName(string str)
		{
			str = str.Replace(":", String.Empty);
			return str;
		}

		public override void Update()
		{
			Spring.Social.QuickBooks.Api.Customer obj = this.quickBooks.CustomerOperations.GetById(this.ID);
			obj.Id = this.ID;
			// 03/23/2015 Paul.  We are only going to support B2B on the first release. 
			//if ( !Sql.IsEmptyString(this.FamilyName) )
			//{
			//	obj.CompanyName = String.Empty;
			//	//obj.Salutation  = this.Salutation;
			//	obj.GivenName   = this.GivenName         ;
			//	obj.MiddleName  = this.MiddleName        ;
			//	obj.FamilyName  = this.FamilyName        ;
			//	obj.DisplayName = Sql.Truncate((obj.GivenName + " " + obj.FamilyName).Trim(), 100);
			//}
			//else
			//{
				obj.CompanyName = Sql.Truncate(this.Name, 50);
				obj.DisplayName = obj.CompanyName;
			//	//obj.Salutation  = String.Empty;
			//	obj.GivenName   = String.Empty;
			//	obj.MiddleName  = String.Empty;
			//	obj.FamilyName  = String.Empty;
			//}
			obj.ActiveValue           = this.Active            ;
			obj.ParentRefValue        = this.ParentId          ;
			obj.Notes                 = Sql.Truncate(this.Notes, 4000);
			obj.PrimaryEmailAddrValue = this.PrimaryEmailAddr  ;
			obj.AlternatePhoneValue   = this.AlternatePhone    ;
			obj.FaxValue              = this.Fax               ;
			obj.PrimaryPhoneValue     = this.PrimaryPhone      ;
			obj.SetBillAddr(this.BillingStreet , this.BillingCity , this.BillingState , this.BillingPostalCode , this.BillingCountry );
			obj.SetShipAddr(this.ShippingStreet, this.ShippingCity, this.ShippingState, this.ShippingPostalCode, this.ShippingCountry);
			//obj.BillingNote           = this.BillingNote         ;
			//obj.CreditCardNumber      = this.CreditCardNumber    ;
			//obj.CreditCardName        = this.CreditCardName      ;
			//obj.CreditCardAddress     = this.CreditCardAddress   ;
			//obj.CreditCardPostalCode  = this.CreditCardPostalCode;
			//obj.JobDescription        = this.JobDescription      ;
			
			obj = this.quickBooks.CustomerOperations.Update(obj);
			this.RawContent   = obj.RawContent;
			this.ID           = obj.Id;
			this.TimeModified = obj.MetaData.LastUpdatedTime;
		}

		public override string Insert()
		{
			this.ID = String.Empty;
			
			Spring.Social.QuickBooks.Api.Customer obj = new Spring.Social.QuickBooks.Api.Customer();
			obj.Id = this.ID;
			// 03/23/2015 Paul.  We are only going to support B2B on the first release. 
			//if ( !Sql.IsEmptyString(this.FamilyName) )
			//{
			//	obj.CompanyName = String.Empty;
			//	//obj.Salutation  = this.Salutation;
			//	obj.GivenName   = this.GivenName         ;
			//	obj.MiddleName  = this.MiddleName        ;
			//	obj.FamilyName  = this.FamilyName        ;
			//	obj.DisplayName = (obj.GivenName + " " + obj.FamilyName).Trim();
			//}
			//else
			//{
				obj.CompanyName = Sql.Truncate(this.Name, 100);
				obj.DisplayName = obj.CompanyName;
			//	//obj.Salutation  = this.Salutation;
			//	obj.GivenName   = String.Empty;
			//	obj.MiddleName  = String.Empty;
			//	obj.FamilyName  = String.Empty;
			//}
			obj.ActiveValue           = this.Active            ;
			obj.ParentRefValue        = this.ParentId          ;
			obj.Notes                 = Sql.Truncate(this.Notes, 4000);
			obj.PrimaryEmailAddrValue = this.PrimaryEmailAddr  ;
			obj.AlternatePhoneValue   = this.AlternatePhone    ;
			obj.FaxValue              = this.Fax               ;
			obj.PrimaryPhoneValue     = this.PrimaryPhone      ;
			obj.SetBillAddr(this.BillingStreet , this.BillingCity , this.BillingState , this.BillingPostalCode , this.BillingCountry );
			obj.SetShipAddr(this.ShippingStreet, this.ShippingCity, this.ShippingState, this.ShippingPostalCode, this.ShippingCountry);
			//obj.BillingNote           = this.BillingNote         ;
			//obj.CreditCardNumber      = this.CreditCardNumber    ;
			//obj.CreditCardName        = this.CreditCardName      ;
			//obj.CreditCardAddress     = this.CreditCardAddress   ;
			//obj.CreditCardPostalCode  = this.CreditCardPostalCode;
			//obj.JobDescription        = this.JobDescription      ;

			obj = this.quickBooks.CustomerOperations.Insert(obj);
			this.RawContent   = obj.RawContent;
			this.ID           = obj.Id;
			this.TimeModified = obj.MetaData.LastUpdatedTime;
			return this.ID;
		}

		public override void Delete()
		{
			this.quickBooks.CustomerOperations.Delete(this.ID);
		}

		public override void Get(string sID)
		{
			IList<Spring.Social.QuickBooks.Api.Customer> lst = this.quickBooks.CustomerOperations.GetAll("Id = '" + sID + "'", String.Empty);
			if ( lst.Count > 0 )
			{
				this.SetFromQuickBooks(lst[0].Id);
				if ( !this.Active )
					this.Deleted = true;
			}
			else
			{
				this.Deleted = true;
			}
		}

		public override IList<Spring.Social.QuickBooks.Api.QBase> SelectModified(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.QuickBooks.Api.QBase> lst = this.quickBooks.CustomerOperations.GetModified(dtStartModifiedDate);
			return lst;
		}

		public override void FilterCRM(IDbCommand cmd)
		{
			Sql.AppendParameter(cmd, Sql.ToString(this.Name), "NAME");
			// 02/24/2015 Paul.  Use the Email Address to isolate the customer. 
			if ( !Sql.IsEmptyString(this.PrimaryEmailAddr) )
				Sql.AppendParameter(cmd, Sql.ToString(this.PrimaryEmailAddr), "EMAIL1");
			
			// 05/29/2012 Paul.  Now that we support the ParentId, we need to make sure to filter on this value as children can have identical names. 
			Guid gPARENT_ID = Guid.Empty;
			if ( !Sql.IsEmptyString(this.ParentId) && this.vwParents != null )
			{
				this.vwParents.RowFilter = "SYNC_REMOTE_KEY = '" + this.ParentId + "'";
				if ( this.vwParents.Count > 0 )
					gPARENT_ID = Sql.ToGuid(this.vwParents[0]["SYNC_LOCAL_ID"]);
			}
			if ( Sql.IsEmptyGuid(gPARENT_ID) )
				cmd.CommandText += "   and PARENT_ID is null" + ControlChars.CrLf;
			else
				Sql.AppendParameter(cmd, gPARENT_ID, "PARENT_ID");
		}

		// 02/03/2015 Paul.  It would be helpful to track changes. 
		public override bool BuildUpdateProcedure(ExchangeSession Session, IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			bool bChanged = this.InitUpdateProcedure(spUpdate, row, gUSER_ID, gTEAM_ID);
			
			Guid gPARENT_ID = Guid.Empty;
			if ( !Sql.IsEmptyString(this.ParentId) && this.vwParents != null )
			{
				this.vwParents.RowFilter = "SYNC_REMOTE_KEY = '" + this.ParentId + "'";
				if ( this.vwParents.Count > 0 )
					gPARENT_ID = Sql.ToGuid(this.vwParents[0]["SYNC_LOCAL_ID"]);
			}
			
			foreach(IDbDataParameter par in spUpdate.Parameters)
			{
				Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
				// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
				string sColumnName = Sql.ExtractDbName(spUpdate, par.ParameterName).ToUpper();
				if ( SplendidInit.bEnableACLFieldSecurity )
				{
					acl = ExchangeSecurity.GetUserFieldSecurity(Session, this.CRMModuleName, sColumnName, gASSIGNED_USER_ID);
				}
				if ( acl.IsWriteable() )
				{
					try
					{
						// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
						object oValue = null;
						switch ( sColumnName )
						{
							case "PARENT_ID"                  :  oValue = Sql.ToDBGuid  (     gPARENT_ID             );  break;
							case "NAME"                       :  oValue = Sql.ToDBString(this.Name                   );  break;
							case "DESCRIPTION"                :  oValue = Sql.ToDBString(this.Notes                  );  break;
							case "EMAIL1"                     :  oValue = Sql.ToDBString(this.PrimaryEmailAddr       );  break;
							case "PHONE_ALTERNATE"            :  oValue = Sql.ToDBString(this.AlternatePhone         );  break;
							case "PHONE_FAX"                  :  oValue = Sql.ToDBString(this.Fax                    );  break;
							case "PHONE_OFFICE"               :  oValue = Sql.ToDBString(this.PrimaryPhone           );  break;
							case "BILLING_ADDRESS_STREET"     :  oValue = Sql.ToDBString(this.BillingStreet          );  break;
							case "BILLING_ADDRESS_CITY"       :  oValue = Sql.ToDBString(this.BillingCity            );  break;
							case "BILLING_ADDRESS_STATE"      :  oValue = Sql.ToDBString(this.BillingState           );  break;
							case "BILLING_ADDRESS_POSTALCODE" :  oValue = Sql.ToDBString(this.BillingPostalCode      );  break;
							case "BILLING_ADDRESS_COUNTRY"    :  oValue = Sql.ToDBString(this.BillingCountry         );  break;
							case "SHIPPING_ADDRESS_STREET"    :  oValue = Sql.ToDBString(this.ShippingStreet         );  break;
							case "SHIPPING_ADDRESS_CITY"      :  oValue = Sql.ToDBString(this.ShippingCity           );  break;
							case "SHIPPING_ADDRESS_STATE"     :  oValue = Sql.ToDBString(this.ShippingState          );  break;
							case "SHIPPING_ADDRESS_POSTALCODE":  oValue = Sql.ToDBString(this.ShippingPostalCode     );  break;
							case "SHIPPING_ADDRESS_COUNTRY"   :  oValue = Sql.ToDBString(this.ShippingCountry        );  break;
							case "MODIFIED_USER_ID"           :  oValue = gUSER_ID                                    ;  break;
						}
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						// 02/17/2015 Paul.  Modified User ID does not count as a changed field. 
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "NAME"                       :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "DESCRIPTION"                :  bChanged = ParameterChanged(par, oValue, 4000, sbChanges);  break;
									case "EMAIL1"                     :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "ASSISTANT"                  :  bChanged = ParameterChanged(par, oValue,   40, sbChanges);  break;
									case "PHONE_ALTERNATE"            :  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									case "PHONE_FAX"                  :  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									case "PHONE_OFFICE"               :  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									case "BILLING_ADDRESS_STREET"     :  bChanged = ParameterChanged(par, oValue, 2000, sbChanges);  break;
									case "BILLING_ADDRESS_CITY"       :  bChanged = ParameterChanged(par, oValue,  255, sbChanges);  break;
									case "BILLING_ADDRESS_STATE"      :  bChanged = ParameterChanged(par, oValue,  255, sbChanges);  break;
									case "BILLING_ADDRESS_POSTALCODE" :  bChanged = ParameterChanged(par, oValue,   30, sbChanges);  break;
									case "BILLING_ADDRESS_COUNTRY"    :  bChanged = ParameterChanged(par, oValue,  255, sbChanges);  break;
									case "SHIPPING_ADDRESS_STREET"    :  bChanged = ParameterChanged(par, oValue, 2000, sbChanges);  break;
									case "SHIPPING_ADDRESS_CITY"      :  bChanged = ParameterChanged(par, oValue,  255, sbChanges);  break;
									case "SHIPPING_ADDRESS_STATE"     :  bChanged = ParameterChanged(par, oValue,  255, sbChanges);  break;
									case "SHIPPING_ADDRESS_POSTALCODE":  bChanged = ParameterChanged(par, oValue,   30, sbChanges);  break;
									case "SHIPPING_ADDRESS_COUNTRY"   :  bChanged = ParameterChanged(par, oValue,  255, sbChanges);  break;
									default                           :  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
								}
							}
							par.Value = oValue;
						}
					}
					catch
					{
						// 03/27/2010 Paul.  Some fields are not available.  Lets just ignore them. 
					}
				}
			}
			return bChanged;
		}

		public override void ProcedureUpdated(Guid gID, string sREMOTE_KEY, IDbTransaction trn, Guid gUSER_ID)
		{
			if ( this.vwParents != null )
			{
				this.vwParents.RowFilter = "SYNC_LOCAL_ID = '" + gID.ToString() + "'";
				if ( this.vwParents.Count == 0 )
				{
					DataRow row = this.vwParents.Table.NewRow();
					row["SYNC_LOCAL_ID"  ] = gID        ;
					row["SYNC_REMOTE_KEY"] = sREMOTE_KEY;
					this.vwParents.Table.Rows.Add(row);
				}
			}
		}
	}
}
