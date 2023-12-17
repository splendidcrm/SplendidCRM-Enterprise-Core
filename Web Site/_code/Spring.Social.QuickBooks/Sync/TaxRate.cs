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
	public class TaxRate : QObject
	{
		#region Properties
		public bool    Active        ;
		public Decimal Rate          ;
		public string  Description   ;
		public string  Agency        ;
		#endregion

		public TaxRate(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.QuickBooks.Api.IQuickBooks quickBooks)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, "TaxRates", "Name", "TaxRates", "TAX_RATES", "NAME", false, false, false)
		{
			// 02/02/2015 Paul.  TaxRates are read only. 
			this.IsReadOnly = true;
		}

		public override void Reset()
		{
			base.Reset();
			this.Active        = true;
			this.Rate          = 0;
			this.Description   = String.Empty;
			this.Agency        = String.Empty;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			this.ID       = sID;
			this.LOCAL_ID = Sql.ToGuid(row["ID"]);
			if ( Sql.IsEmptyString(this.ID) )
			{
				this.Name          = Sql.MaxLength(Sql.ToString (row["NAME"                 ]), 100);
				this.Active        =              (Sql.ToString (row["STATUS"               ]) == "Active");
				this.Rate          =               Sql.ToDecimal(row["VALUE"                ]);
				this.Description   = Sql.MaxLength(Sql.ToString (row["DESCRIPTION"          ]), 100);
				this.Agency        =               Sql.ToString (row["QUICKBOOKS_TAX_VENDOR"]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.Name         , Sql.MaxLength(Sql.ToString (row["NAME"                 ]), 100), "NAME"                 , sbChanges) ) { this.Name          = Sql.MaxLength(Sql.ToString (row["NAME"                 ]), 100);  bChanged = true; }
				if ( Compare(this.Active       ,              (Sql.ToString (row["STATUS"]) == "Active")        , "STATUS"               , sbChanges) ) { this.Active        =               Sql.ToString (row["STATUS"]) == "Active"         ;  bChanged = true; }
				if ( Compare(this.Rate         ,               Sql.ToDecimal(row["VALUE"                ])      , "VALUE"                , sbChanges) ) { this.Rate          =               Sql.ToDecimal(row["VALUE"                ])      ;  bChanged = true; }
				if ( Compare(this.Description  , Sql.MaxLength(Sql.ToString (row["DESCRIPTION"          ]), 100), "DESCRIPTION"          , sbChanges) ) { this.Description   = Sql.MaxLength(Sql.ToString (row["DESCRIPTION"          ]), 100);  bChanged = true; }
				if ( Compare(this.Agency       ,                             row["QUICKBOOKS_TAX_VENDOR"]       , "QUICKBOOKS_TAX_VENDOR", sbChanges) ) { this.Agency        =               Sql.ToString (row["QUICKBOOKS_TAX_VENDOR"])      ;  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromQuickBooks(string sId)
		{
			this.Reset();
			Spring.Social.QuickBooks.Api.TaxRate obj = this.quickBooks.TaxRateOperations.GetById(sId);
			this.RawContent   = obj.RawContent       ;
			this.ID           = obj.Id               ;
			this.TimeCreated  = obj.TimeCreated      ;
			this.TimeModified = obj.TimeModified     ;
			this.Name         = obj.Name             ;
			this.Description  = obj.Description      ;
			this.Active       = obj.ActiveValue      ;
			this.Rate         = obj.RateValue        ;
			this.Agency       = obj.AgencyRefValue   ;
		}

		public override void Update()
		{
			Spring.Social.QuickBooks.Api.TaxRate obj = this.quickBooks.TaxRateOperations.GetById(this.ID);
			obj.Id               = this.ID           ;
			obj.Name             = this.Name         ;
			obj.Description      = this.Description  ;
			obj.Active           = this.Active       ;
			obj.RateValue        = this.Rate         ;
			obj.AgencyRef        = new Spring.Social.QuickBooks.Api.ReferenceType(this.Agency);
			
			obj = this.quickBooks.TaxRateOperations.Update(obj);
			this.RawContent   = obj.RawContent;
			this.ID           = obj.Id;
			this.TimeModified = obj.MetaData.LastUpdatedTime;
		}

		public override string Insert()
		{
			this.ID = String.Empty;
			
			Spring.Social.QuickBooks.Api.TaxRate obj = new Spring.Social.QuickBooks.Api.TaxRate();
			obj.Id               = this.ID           ;
			obj.Name             = this.Name         ;
			obj.Description      = this.Description  ;
			obj.Active           = this.Active       ;
			obj.RateValue        = this.Rate         ;
			obj.AgencyRef        = new Spring.Social.QuickBooks.Api.ReferenceType(this.Agency);
			
			obj = this.quickBooks.TaxRateOperations.Insert(obj);
			this.RawContent   = obj.RawContent;
			this.ID           = obj.Id;
			this.TimeModified = obj.MetaData.LastUpdatedTime;
			return this.ID;
		}

		public override void Delete()
		{
			// 07/12/2014 Paul.  Records are not deleted, they are marked as inactive. 
			this.Active = false;
			Update();
		}

		public override void Get(string sID)
		{
			IList<Spring.Social.QuickBooks.Api.TaxRate> lst = this.quickBooks.TaxRateOperations.GetAll("Id = '" + sID + "'", String.Empty);
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
			IList<Spring.Social.QuickBooks.Api.QBase> lst = this.quickBooks.TaxRateOperations.GetModified(dtStartModifiedDate);
			return lst;
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
				if ( acl.IsWriteable() )
				{
					try
					{
						// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
						object oValue = null;
						switch ( sColumnName )
						{
							case "NAME"                 :  oValue = Sql.ToDBString (this.Name                            );  break;
							case "STATUS"               :  oValue = Sql.ToDBString (this.Active   ? "Active" : "Inactive");  break;
							case "VALUE"                :  oValue = Sql.ToDBDecimal(this.Rate                            );  break;
							case "QUICKBOOKS_TAX_VENDOR":  oValue = Sql.ToDBString (this.Agency                          );  break;
							case "DESCRIPTION"          :  oValue = Sql.ToDBString (this.Description                     );  break;
							case "MODIFIED_USER_ID"     :  oValue = gUSER_ID                                              ;  break;
						}
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						// 02/17/2015 Paul.  Modified User ID does not count as a changed field. 
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "NAME"                 :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "DESCRIPTION"          :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "QUICKBOOKS_TAX_VENDOR":  bChanged = ParameterChanged(par, oValue,   31, sbChanges);  break;
									default                     :  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
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
