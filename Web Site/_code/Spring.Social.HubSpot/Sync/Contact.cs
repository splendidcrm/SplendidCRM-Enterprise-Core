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
	public class Contact : HObject
	{
		#region Properties
		public string    firstname          ;
		public string    lastname           ;
		public string    salutation         ;
		public string    email              ;
		public string    phone              ;
		public string    mobilephone        ;
		public string    fax                ;
		public string    address            ;
		public string    city               ;
		public string    state              ;
		public string    zip                ;
		public string    country            ;
		public string    jobtitle           ;
		public string    message            ;
		public string    twitterhandle      ;
		public string    company            ;
		public long      associatedcompanyid;
		public bool      hs_email_optout    ;  // EMAIL_OPT_OUT
		public long      hs_email_bounce    ;  // INVALID_EMAIL
		#endregion
		protected DataView vwCompanies;

		public Contact(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.HubSpot.Api.IHubSpot hubSpot, DataTable dtCompanies) : base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, hubSpot, "Contacts", "Name", "Contacts", "CONTACTS", "NAME", true)
		{
			if ( dtCompanies != null )
				this.vwCompanies = new DataView(dtCompanies);
		}

		public override void Reset()
		{
			base.Reset();
			this.salutation          = String.Empty;
			this.firstname           = String.Empty;
			this.lastname            = String.Empty;
			this.phone               = String.Empty;
			this.fax                 = String.Empty;
			this.mobilephone         = String.Empty;
			this.email               = String.Empty;
			this.message             = String.Empty;
			this.address             = String.Empty;
			this.city                = String.Empty;
			this.state               = String.Empty;
			this.zip                 = String.Empty;
			this.country             = String.Empty;
			this.jobtitle            = String.Empty;
			this.twitterhandle       = String.Empty;
			this.company             = String.Empty;
			this.associatedcompanyid = 0;
			this.hs_email_optout     = false;
			this.hs_email_bounce     = 0    ;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			if ( this.vwCompanies != null )
			{
				this.vwCompanies.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["ACCOUNT_ID"]) + "'";
				if ( this.vwCompanies.Count > 0 )
					this.associatedcompanyid = Sql.ToInteger(this.vwCompanies[0]["SYNC_REMOTE_KEY"]);
			}
			
			this.id       = Sql.ToInteger(sID);
			this.LOCAL_ID = Sql.ToGuid  (row["ID"  ]);
			this.name     = Sql.ToString(row["NAME"]);
			if ( Sql.IsEmptyString(sID) )
			{
				this.salutation         = Sql.ToString(row["SALUTATION"                 ]);
				this.firstname          = Sql.ToString(row["FIRST_NAME"                 ]);
				this.lastname           = Sql.ToString(row["LAST_NAME"                  ]);
				this.message            = Sql.ToString(row["DESCRIPTION"                ]);
				this.email              = Sql.ToString(row["EMAIL1"                     ]);
				this.mobilephone        = Sql.ToString(row["PHONE_MOBILE"               ]);
				this.fax                = Sql.ToString(row["PHONE_FAX"                  ]);
				this.phone              = Sql.ToString(row["PHONE_WORK"                 ]);
				this.address            = Sql.ToString(row["PRIMARY_ADDRESS_STREET"     ]);
				this.city               = Sql.ToString(row["PRIMARY_ADDRESS_CITY"       ]);
				this.state              = Sql.ToString(row["PRIMARY_ADDRESS_STATE"      ]);
				this.zip                = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE" ]);
				this.country            = Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"    ]);
				this.jobtitle           = Sql.ToString(row["TITLE"                      ]);
				this.twitterhandle      = Sql.ToString(row["TWITTER_SCREEN_NAME"        ]);
				this.company            = Sql.ToString(row["ACCOUNT_NAME"               ]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.salutation        , row["SALUTATION"                 ], "SALUTATION"                 , sbChanges) ) { this.salutation         = Sql.ToString(row["SALUTATION"                 ]);  bChanged = true; }
				if ( Compare(this.firstname         , row["FIRST_NAME"                 ], "FIRST_NAME"                 , sbChanges) ) { this.firstname          = Sql.ToString(row["FIRST_NAME"                 ]);  bChanged = true; }
				if ( Compare(this.lastname          , row["LAST_NAME"                  ], "LAST_NAME"                  , sbChanges) ) { this.lastname           = Sql.ToString(row["LAST_NAME"                  ]);  bChanged = true; }
				if ( Compare(this.message           , row["DESCRIPTION"                ], "DESCRIPTION"                , sbChanges) ) { this.message            = Sql.ToString(row["DESCRIPTION"                ]);  bChanged = true; }
				if ( Compare(this.email             , row["EMAIL1"                     ], "EMAIL1"                     , sbChanges) ) { this.email              = Sql.ToString(row["EMAIL1"                     ]);  bChanged = true; }
				if ( Compare(this.mobilephone       , row["PHONE_MOBILE"               ], "PHONE_MOBILE"               , sbChanges) ) { this.mobilephone        = Sql.ToString(row["PHONE_MOBILE"               ]);  bChanged = true; }
				if ( Compare(this.fax               , row["PHONE_FAX"                  ], "PHONE_FAX"                  , sbChanges) ) { this.fax                = Sql.ToString(row["PHONE_FAX"                  ]);  bChanged = true; }
				if ( Compare(this.phone             , row["PHONE_WORK"                 ], "PHONE_WORK"                 , sbChanges) ) { this.phone              = Sql.ToString(row["PHONE_WORK"                 ]);  bChanged = true; }
				if ( Compare(this.address           , row["PRIMARY_ADDRESS_STREET"     ], "PRIMARY_ADDRESS_STREET"     , sbChanges) ) { this.address            = Sql.ToString(row["PRIMARY_ADDRESS_STREET"     ]);  bChanged = true; }
				if ( Compare(this.city              , row["PRIMARY_ADDRESS_CITY"       ], "PRIMARY_ADDRESS_CITY"       , sbChanges) ) { this.city               = Sql.ToString(row["PRIMARY_ADDRESS_CITY"       ]);  bChanged = true; }
				if ( Compare(this.state             , row["PRIMARY_ADDRESS_STATE"      ], "PRIMARY_ADDRESS_STATE"      , sbChanges) ) { this.state              = Sql.ToString(row["PRIMARY_ADDRESS_STATE"      ]);  bChanged = true; }
				if ( Compare(this.zip               , row["PRIMARY_ADDRESS_POSTALCODE" ], "PRIMARY_ADDRESS_POSTALCODE" , sbChanges) ) { this.zip                = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE" ]);  bChanged = true; }
				if ( Compare(this.country           , row["PRIMARY_ADDRESS_COUNTRY"    ], "PRIMARY_ADDRESS_COUNTRY"    , sbChanges) ) { this.country            = Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"    ]);  bChanged = true; }
				if ( Compare(this.jobtitle          , row["TITLE"                      ], "TITLE"                      , sbChanges) ) { this.jobtitle           = Sql.ToString(row["TITLE"                      ]);  bChanged = true; }
				if ( Compare(this.twitterhandle     , row["TWITTER_SCREEN_NAME"        ], "TWITTER_SCREEN_NAME"        , sbChanges) ) { this.twitterhandle      = Sql.ToString(row["TWITTER_SCREEN_NAME"        ]);  bChanged = true; }
				if ( Compare(this.company           , row["ACCOUNT_NAME"               ], "ACCOUNT_NAME"               , sbChanges) ) { this.company            = Sql.ToString(row["ACCOUNT_NAME"               ]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromHubSpot(long nId)
		{
			Spring.Social.HubSpot.Api.Contact obj = this.HubSpot.ContactOperations.GetById(nId);
			SetFromHubSpot(obj);
		}

		public void SetFromHubSpot(Spring.Social.HubSpot.Api.Contact obj)
		{
			this.Reset();
			this.RawContent          = obj.RawContent               ;
			this.id                  = obj.id.Value                 ;
			this.name                = (obj.firstname + " " + obj.lastname).Trim();
			this.createdate          = obj.createdate.Value         ;
			this.lastmodifieddate    = obj.lastmodifieddate.Value   ;
			this.salutation          = obj.salutation               ;
			this.firstname           = obj.firstname                ;
			this.lastname            = obj.lastname                 ;
			this.associatedcompanyid = (obj.associatedcompanyid.HasValue ? obj.associatedcompanyid.Value : 0);
			this.message             = obj.message                  ;
			this.email               = obj.email                    ;
			this.mobilephone         = obj.mobilephone              ;
			this.fax                 = obj.fax                      ;
			this.phone               = obj.phone                    ;
			this.address             = obj.address                  ;
			this.city                = obj.city                     ;
			this.state               = obj.state                    ;
			this.zip                 = obj.zip                      ;
			this.country             = obj.country                  ;
			this.jobtitle            = obj.jobtitle                 ;
			this.twitterhandle       = obj.twitterhandle            ;
			this.company             = obj.company                  ;
			this.hs_email_optout     = (obj.hs_email_optout.HasValue ? obj.hs_email_optout.Value : false);
			this.hs_email_bounce     = (obj.hs_email_bounce.HasValue ? obj.hs_email_bounce.Value : 0    );
		}

		public override void Update()
		{
			Spring.Social.HubSpot.Api.Contact obj = this.HubSpot.ContactOperations.GetById(this.id);
			obj.id                    = this.id                 ;
			obj.salutation            = this.salutation         ;
			obj.firstname             = this.firstname          ;
			obj.lastname              = this.lastname           ;
			obj.lastname              = this.lastname           ;
			obj.associatedcompanyid   = this.associatedcompanyid;
			obj.message               = this.message            ;
			obj.email                 = this.email              ;
			obj.mobilephone           = this.mobilephone        ;
			obj.fax                   = this.fax                ;
			obj.phone                 = this.phone              ;
			obj.address               = this.address            ;
			obj.city                  = this.city               ;
			obj.state                 = this.state              ;
			obj.zip                   = this.zip                ;
			obj.country               = this.country            ;
			obj.jobtitle              = this.jobtitle           ;
			obj.twitterhandle         = this.twitterhandle      ;
			obj.company               = this.company            ;
			
			this.HubSpot.ContactOperations.Update(obj);
			obj = this.HubSpot.ContactOperations.GetById(this.id);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id.Value              ;
			this.lastmodifieddate = obj.lastmodifieddate.Value;
		}

		public override string Insert()
		{
			this.id = 0;
			
			Spring.Social.HubSpot.Api.Contact obj = new Spring.Social.HubSpot.Api.Contact();
			obj.salutation            = this.salutation         ;
			obj.firstname             = this.firstname          ;
			obj.lastname              = this.lastname           ;
			obj.lastname              = this.lastname           ;
			obj.associatedcompanyid   = this.associatedcompanyid;
			obj.message               = this.message            ;
			obj.email                 = this.email              ;
			obj.mobilephone           = this.mobilephone        ;
			obj.fax                   = this.fax                ;
			obj.phone                 = this.phone              ;
			obj.address               = this.address            ;
			obj.city                  = this.city               ;
			obj.state                 = this.state              ;
			obj.zip                   = this.zip                ;
			obj.country               = this.country            ;
			obj.jobtitle              = this.jobtitle           ;
			obj.twitterhandle         = this.twitterhandle      ;
			obj.company               = this.company            ;

			obj = this.HubSpot.ContactOperations.Insert(obj);
			// 04/28/2015 Paul.  Insert does not return the last modified date. Get the record again. 
			obj = this.HubSpot.ContactOperations.GetById(obj.id.Value);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id.Value              ;
			this.lastmodifieddate = obj.lastmodifieddate.Value;
			return Sql.ToString(this.id);
		}

		public override void Delete()
		{
			this.HubSpot.ContactOperations.Delete(this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.HubSpot.Api.Contact obj = this.HubSpot.ContactOperations.GetById(Sql.ToInteger(sID));
			if ( obj.id.HasValue )
			{
				this.SetFromHubSpot(obj);
			}
			else
			{
				this.Deleted = true;
			}
		}

		public override IList<Spring.Social.HubSpot.Api.HBase> SelectModified(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.HubSpot.Api.HBase> lst = this.HubSpot.ContactOperations.GetModified(dtStartModifiedDate);
			return lst;
		}

		public override void FilterCRM(IDbCommand cmd)
		{
			// 05/19/2015 Paul.  The email is treated as a primary key. 
			Sql.AppendParameter(cmd, Sql.ToString(this.email), "EMAIL1");
		}

		public override bool BuildUpdateProcedure(ExchangeSession Session, IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			bool bChanged = this.InitUpdateProcedure(spUpdate, row, gUSER_ID, gTEAM_ID);
			
			Guid gACCOUNT_ID = Guid.Empty;
			if ( this.vwCompanies != null )
			{
				// 09/28/2020 Paul.  associatedcompanyid is not being returned any more.  Use company name. 
				if ( this.associatedcompanyid > 0 )
				{
					this.vwCompanies.RowFilter = "SYNC_REMOTE_KEY = '" + this.associatedcompanyid.ToString() + "'";
					if ( this.vwCompanies.Count > 0 )
						gACCOUNT_ID = Sql.ToGuid(this.vwCompanies[0]["SYNC_LOCAL_ID"]);
				}
				else if ( !Sql.IsEmptyString(this.company) )
				{
					this.vwCompanies.RowFilter = "NAME = '" + this.company + "'";
					if ( this.vwCompanies.Count > 0 )
						gACCOUNT_ID = Sql.ToGuid(this.vwCompanies[0]["SYNC_LOCAL_ID"]);
				}
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
							case "ACCOUNT_ID"                 :  oValue = Sql.ToDBGuid   (     gACCOUNT_ID            );  break;
							case "SALUTATION"                 :  oValue = Sql.ToDBString (this.salutation             );  break;
							case "FIRST_NAME"                 :  oValue = Sql.ToDBString (this.firstname              );  break;
							case "LAST_NAME"                  :  oValue = Sql.ToDBString (this.lastname               );  break;
							case "DESCRIPTION"                :  oValue = Sql.ToDBString (this.message                );  break;
							case "EMAIL1"                     :  oValue = Sql.ToDBString (this.email                  );  break;
							case "PHONE_MOBILE"               :  oValue = Sql.ToDBString (this.mobilephone            );  break;
							case "PHONE_FAX"                  :  oValue = Sql.ToDBString (this.fax                    );  break;
							case "PHONE_WORK"                 :  oValue = Sql.ToDBString (this.phone                  );  break;
							case "PRIMARY_ADDRESS_STREET"     :  oValue = Sql.ToDBString (this.address                );  break;
							case "PRIMARY_ADDRESS_CITY"       :  oValue = Sql.ToDBString (this.city                   );  break;
							case "PRIMARY_ADDRESS_STATE"      :  oValue = Sql.ToDBString (this.state                  );  break;
							case "PRIMARY_ADDRESS_POSTALCODE" :  oValue = Sql.ToDBString (this.zip                    );  break;
							case "PRIMARY_ADDRESS_COUNTRY"    :  oValue = Sql.ToDBString (this.country                );  break;
							case "TITLE"                      :  oValue = Sql.ToDBString (this.jobtitle               );  break;
							case "TWITTER_SCREEN_NAME"        :  oValue = Sql.ToDBString (this.twitterhandle          );  break;
							case "EMAIL_OPT_OUT"              :  oValue = Sql.ToDBBoolean(this.hs_email_optout        );  break;
							case "INVALID_EMAIL"              :  oValue = Sql.ToDBBoolean(this.hs_email_bounce > 0    );  break;
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
									case "FIRST_NAME"                 :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "LAST_NAME"                  :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "DESCRIPTION"                :  bChanged = ParameterChanged(par, oValue, 4000, sbChanges);  break;
									case "EMAIL1"                     :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "ASSISTANT"                  :  bChanged = ParameterChanged(par, oValue,   75, sbChanges);  break;
									case "PHONE_MOBILE"               :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PHONE_FAX"                  :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PHONE_WORK"                 :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PRIMARY_ADDRESS_STREET"     :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "PRIMARY_ADDRESS_CITY"       :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "PRIMARY_ADDRESS_STATE"      :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "PRIMARY_ADDRESS_POSTALCODE" :  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									case "PRIMARY_ADDRESS_COUNTRY"    :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "TITLE"                      :  bChanged = ParameterChanged(par, oValue,   50, sbChanges);  break;
									case "TWITTER_SCREEN_NAME"        :  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
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
