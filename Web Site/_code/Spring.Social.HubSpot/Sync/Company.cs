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

namespace Spring.Social.HubSpot
{
	public class Company : HObject
	{
		#region Properties
		public string    phone              ;
		public string    address            ;
		public string    address2           ;
		public string    city               ;
		public string    state              ;
		public string    zip                ;
		public string    country            ;
		public string    website            ;
		public string    industry           ;
		public string    type               ;
		public string    description        ;
		public int       numberofemployees  ;
		public Decimal   annualrevenue      ;
		#endregion

		public Company(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.HubSpot.Api.IHubSpot hubSpot) : base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, hubSpot, "Companies", "Name", "Accounts", "ACCOUNTS", "NAME", true)
		{
		}

		public override void Reset()
		{
			base.Reset();
			this.phone             = String.Empty;
			this.address           = String.Empty;
			this.address2          = String.Empty;
			this.city              = String.Empty;
			this.state             = String.Empty;
			this.zip               = String.Empty;
			this.country           = String.Empty;
			this.website           = String.Empty;
			this.industry          = String.Empty;
			this.type              = String.Empty;
			this.description       = String.Empty;
			this.numberofemployees = 0           ;
			this.annualrevenue     = 0           ;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			
			this.id = Sql.ToInteger(sID);
			this.LOCAL_ID = Sql.ToGuid(row["ID"]);
			if ( Sql.IsEmptyString(sID) )
			{
				this.name               = Sql.ToString (row["NAME"                       ]);
				this.description        = Sql.ToString (row["DESCRIPTION"                ]);
				this.phone              = Sql.ToString (row["PHONE_OFFICE"               ]);
				this.address            = Sql.ToString (row["BILLING_ADDRESS_STREET"     ]);
				this.city               = Sql.ToString (row["BILLING_ADDRESS_CITY"       ]);
				this.state              = Sql.ToString (row["BILLING_ADDRESS_STATE"      ]);
				this.zip                = Sql.ToString (row["BILLING_ADDRESS_POSTALCODE" ]);
				this.country            = Sql.ToString (row["BILLING_ADDRESS_COUNTRY"    ]);
				this.website            = Sql.ToString (row["WEBSITE"                    ]);
				this.industry           = Sql.ToString (row["INDUSTRY"                   ]);
				// 11/16/2016 Paul.  Correct ACCOUNT_TYPE. 
				this.type               = Sql.ToString (row["ACCOUNT_TYPE"               ]);
				this.numberofemployees  = Sql.ToInteger(row["EMPLOYEES"                  ]);
				this.annualrevenue      = Sql.ToDecimal(row["ANNUAL_REVENUE"             ]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.name              , row["NAME"                       ], "NAME"                       , sbChanges) ) { this.name               = Sql.ToString (row["NAME"                       ]);  bChanged = true; }
				if ( Compare(this.description       , row["DESCRIPTION"                ], "DESCRIPTION"                , sbChanges) ) { this.description        = Sql.ToString (row["DESCRIPTION"                ]);  bChanged = true; }
				if ( Compare(this.phone             , row["PHONE_OFFICE"               ], "PHONE_OFFICE"               , sbChanges) ) { this.phone              = Sql.ToString (row["PHONE_OFFICE"               ]);  bChanged = true; }
				if ( Compare(this.address           , row["BILLING_ADDRESS_STREET"     ], "BILLING_ADDRESS_STREET"     , sbChanges) ) { this.address            = Sql.ToString (row["BILLING_ADDRESS_STREET"     ]);  bChanged = true; }
				if ( Compare(this.city              , row["BILLING_ADDRESS_CITY"       ], "BILLING_ADDRESS_CITY"       , sbChanges) ) { this.city               = Sql.ToString (row["BILLING_ADDRESS_CITY"       ]);  bChanged = true; }
				if ( Compare(this.state             , row["BILLING_ADDRESS_STATE"      ], "BILLING_ADDRESS_STATE"      , sbChanges) ) { this.state              = Sql.ToString (row["BILLING_ADDRESS_STATE"      ]);  bChanged = true; }
				if ( Compare(this.zip               , row["BILLING_ADDRESS_POSTALCODE" ], "BILLING_ADDRESS_POSTALCODE" , sbChanges) ) { this.zip                = Sql.ToString (row["BILLING_ADDRESS_POSTALCODE" ]);  bChanged = true; }
				if ( Compare(this.country           , row["BILLING_ADDRESS_COUNTRY"    ], "BILLING_ADDRESS_COUNTRY"    , sbChanges) ) { this.country            = Sql.ToString (row["BILLING_ADDRESS_COUNTRY"    ]);  bChanged = true; }
				if ( Compare(this.website           , row["WEBSITE"                    ], "WEBSITE"                    , sbChanges) ) { this.website            = Sql.ToString (row["WEBSITE"                    ]);  bChanged = true; }
				if ( Compare(this.industry          , row["INDUSTRY"                   ], "INDUSTRY"                   , sbChanges) ) { this.industry           = Sql.ToString (row["INDUSTRY"                   ]);  bChanged = true; }
				// 11/16/2016 Paul.  Correct ACCOUNT_TYPE. 
				if ( Compare(this.type              , row["ACCOUNT_TYPE"               ], "ACCOUNT_TYPE"               , sbChanges) ) { this.type               = Sql.ToString (row["ACCOUNT_TYPE"               ]);  bChanged = true; }
				if ( Compare(this.numberofemployees , row["EMPLOYEES"                  ], "EMPLOYEES"                  , sbChanges) ) { this.numberofemployees  = Sql.ToInteger(row["EMPLOYEES"                  ]);  bChanged = true; }
				if ( Compare(this.annualrevenue     , row["ANNUAL_REVENUE"             ], "ANNUAL_REVENUE"             , sbChanges) ) { this.annualrevenue      = Sql.ToDecimal(row["ANNUAL_REVENUE"             ]);  bChanged = true; }
			}
			return bChanged;
		}

		// 09/27/2020 Paul.  HubSpot is now using long instead of integers. 
		public override void SetFromHubSpot(long nId)
		{
			this.Reset();
			Spring.Social.HubSpot.Api.Company obj = this.HubSpot.CompanyOperations.GetById(nId);
			this.RawContent        = obj.RawContent            ;
			this.id                = obj.id.Value              ;
			this.createdate        = obj.createdate.Value      ;
			this.lastmodifieddate  = obj.lastmodifieddate.Value;
			this.name              = obj.name                  ;
			this.description       = obj.description           ;
			this.phone             = obj.phone                 ;
			this.address           = obj.address               ;
			this.city              = obj.city                  ;
			this.state             = obj.state                 ;
			this.zip               = obj.zip                   ;
			this.country           = obj.country               ;
			this.website           = obj.website               ;
			this.industry          = obj.industry              ;
			this.type              = obj.type                  ;
		}

		public override void Update()
		{
			Spring.Social.HubSpot.Api.Company obj = this.HubSpot.CompanyOperations.GetById(this.id);
			obj.id = this.id;
			obj.name                  = this.name              ;
			obj.description           = this.description       ;
			obj.phone                 = this.phone             ;
			obj.address               = this.address           ;
			obj.city                  = this.city              ;
			obj.state                 = this.state             ;
			obj.zip                   = this.zip               ;
			obj.country               = this.country           ;
			obj.website               = this.website           ;
			// 04/30/2015 Paul.  We are not going to send industry/type at this time as sending an invalid value will generate an error. 
			//obj.industry              = this.industry          ;
			//obj.type                  = this.type              ;
			
			this.HubSpot.CompanyOperations.Update(obj);
			obj = this.HubSpot.CompanyOperations.GetById(this.id);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id.Value              ;
			this.lastmodifieddate = obj.lastmodifieddate.Value;
		}

		public override string Insert()
		{
			this.ID = String.Empty;
			
			Spring.Social.HubSpot.Api.Company obj = new Spring.Social.HubSpot.Api.Company();
			obj.id = this.id;
			obj.name                  = this.name              ;
			obj.description           = this.description       ;
			obj.phone                 = this.phone             ;
			obj.address               = this.address           ;
			obj.city                  = this.city              ;
			obj.state                 = this.state             ;
			obj.zip                   = this.zip               ;
			obj.country               = this.country           ;
			obj.website               = this.website           ;
			// 04/30/2015 Paul.  We are not going to send industry/type at this time as sending an invalid value will generate an error. 
			//obj.industry              = this.industry          ;
			//obj.type                  = this.type              ;

			obj = this.HubSpot.CompanyOperations.Insert(obj);
			// 04/28/2015 Paul.  Insert does not return the last modified date. Get the record again. 
			obj = this.HubSpot.CompanyOperations.GetById(obj.id.Value);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id.Value              ;
			this.lastmodifieddate = obj.lastmodifieddate.Value;
			return this.id.ToString();
		}

		public override void Delete()
		{
			this.HubSpot.CompanyOperations.Delete(this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.HubSpot.Api.Company obj = this.HubSpot.CompanyOperations.GetById(Sql.ToInteger(sID));
			if ( obj.id.HasValue )
			{
				this.SetFromHubSpot(obj.id.Value);
			}
			else
			{
				this.Deleted = true;
			}
		}

		public override IList<Spring.Social.HubSpot.Api.HBase> SelectModified(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.HubSpot.Api.HBase> lst = this.HubSpot.CompanyOperations.GetModified(dtStartModifiedDate);
			return lst;
		}

		public override void FilterCRM(IDbCommand cmd)
		{
			// 05/19/2015 Paul.  The email is treated as a primary key. 
			Sql.AppendParameter(cmd, Sql.ToString(this.name), "NAME");
		}

		// 02/03/2015 Paul.  It would be helpful to track changes. 
		public override bool BuildUpdateProcedure(ExchangeSession Session, IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			bool bChanged = this.InitUpdateProcedure(spUpdate, row, gUSER_ID, gTEAM_ID);
			
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
							case "NAME"                       :  oValue = Sql.ToDBString (this.name                   );  break;
							case "DESCRIPTION"                :  oValue = Sql.ToDBString (this.description            );  break;
							case "PHONE_OFFICE"               :  oValue = Sql.ToDBString (this.phone                  );  break;
							case "BILLING_ADDRESS_STREET"     :  oValue = Sql.ToDBString (this.address                );  break;
							case "BILLING_ADDRESS_CITY"       :  oValue = Sql.ToDBString (this.city                   );  break;
							case "BILLING_ADDRESS_STATE"      :  oValue = Sql.ToDBString (this.state                  );  break;
							case "BILLING_ADDRESS_POSTALCODE" :  oValue = Sql.ToDBString (this.zip                    );  break;
							case "BILLING_ADDRESS_COUNTRY"    :  oValue = Sql.ToDBString (this.country                );  break;
							case "WEBSITE"                    :  oValue = Sql.ToDBString (this.website                );  break;
							case "INDUSTRY"                   :  oValue = Sql.ToDBString (this.industry               );  break;
							case "ACCOUNT_TYPE"               :  oValue = Sql.ToDBString (this.type                   );  break;
							case "EMPLOYEES"                  :  oValue = Sql.ToDBInteger(this.numberofemployees      );  break;
							case "ANNUAL_REVENUE"             :  oValue = Sql.ToDBDecimal(this.annualrevenue          );  break;
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
									case "NAME"                       :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "DESCRIPTION"                :  bChanged = ParameterChanged(par, oValue, 4000, sbChanges);  break;
									case "PHONE_OFFICE"               :  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									case "BILLING_ADDRESS_STREET"     :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "BILLING_ADDRESS_CITY"       :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "BILLING_ADDRESS_STATE"      :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "BILLING_ADDRESS_POSTALCODE" :  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									case "BILLING_ADDRESS_COUNTRY"    :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "WEBSITE"                    :  bChanged = ParameterChanged(par, oValue,  255, sbChanges);  break;
									case "INDUSTRY"                   :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "ACCOUNT_TYPE"               :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
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
	}
}
