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
	public class PaymentTerm : QObject
	{
		#region Properties
		public bool    Active        ;
		#endregion

		public PaymentTerm(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.QuickBooks.Api.IQuickBooks quickBooks)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, "PaymentTerms", "Name", "PaymentTerms", "PAYMENT_TERMS", "NAME", false, false, false)
		{
			// 02/02/2015 Paul.  Terms are read only (though the documentation implies that it is not). 
			this.IsReadOnly = true;
		}

		public override void Reset()
		{
			base.Reset();
			this.Active        = true;
		}

		private string ToQuickBooksTerms(string sPAYMENT_TERMS)
		{
			string sTerms = sPAYMENT_TERMS;
			switch ( sTerms )
			{
				case "Due on Receipt":  sTerms = "Due on receipt";  break;
				case "Net 7 Days"    :  sTerms = "Net 7"         ;  break;
				case "Net 15 Days"   :  sTerms = "Net 15"        ;  break;
				case "Net 30 Days"   :  sTerms = "Net 30"        ;  break;
				case "Net 45 Days"   :  sTerms = "Net 45"        ;  break;
				case "Net 60 Days"   :  sTerms = "Net 60"        ;  break;
			}
			return sTerms;
		}

		private string ToCRMPaymentTerms(string sTerms)
		{
			string sPAYMENT_TERMS = sTerms;
			switch ( sPAYMENT_TERMS )
			{
				case "Due on receipt":  sPAYMENT_TERMS = "Due on Receipt";  break;
				case "Net 7"         :  sPAYMENT_TERMS = "Net 7 Days"    ;  break;
				case "Net 15"        :  sPAYMENT_TERMS = "Net 15 Days"   ;  break;
				case "Net 30"        :  sPAYMENT_TERMS = "Net 30 Days"   ;  break;
				case "Net 45"        :  sPAYMENT_TERMS = "Net 45 Days"   ;  break;
				case "Net 60"        :  sPAYMENT_TERMS = "Net 60 Days"   ;  break;
			}
			return sPAYMENT_TERMS;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			this.ID       = sID;
			this.LOCAL_ID = Sql.ToGuid(row["ID"]);
			if ( Sql.IsEmptyString(this.ID) )
			{
				this.Name   = Sql.MaxLength(Sql.ToString (row["NAME"  ]), 100);
				this.Active =              (Sql.ToString (row["STATUS"]) == "Active");
				bChanged = true;
			}
			else
			{
				if ( Compare(this.Name  , Sql.MaxLength(Sql.ToString (row["NAME"         ]), 100), "NAME"  , sbChanges) ) { this.Name   = Sql.MaxLength(Sql.ToString (row["NAME"        ]), 100);  bChanged = true; }
				if ( Compare(this.Active,              (Sql.ToString (row["STATUS"]) == "Active"), "STATUS", sbChanges) ) { this.Active =               Sql.ToString (row["STATUS"]) == "Active";  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromQuickBooks(string sId)
		{
			this.Reset();
			Spring.Social.QuickBooks.Api.Term obj = this.quickBooks.TermOperations.GetById(sId);
			this.RawContent   = obj.RawContent       ;
			this.ID           = obj.Id               ;
			this.TimeCreated  = obj.TimeCreated      ;
			this.TimeModified = obj.TimeModified     ;
			this.Name         = this.ToCRMPaymentTerms(obj.Name);
			this.Active       = obj.ActiveValue      ;
		}

		public override void Update()
		{
			Spring.Social.QuickBooks.Api.Term obj = this.quickBooks.TermOperations.GetById(this.ID);
			obj.Id          = this.ID    ;
			obj.Name        = this.ToQuickBooksTerms(this.Name);
			obj.Active      = this.Active;
			
			obj = this.quickBooks.TermOperations.Update(obj);
			this.RawContent   = obj.RawContent;
			this.ID           = obj.Id;
			this.TimeModified = obj.MetaData.LastUpdatedTime;
		}

		public override string Insert()
		{
			this.ID = String.Empty;
			
			Spring.Social.QuickBooks.Api.Term obj = new Spring.Social.QuickBooks.Api.Term();
			obj.Id          = this.ID    ;
			obj.Name        = this.ToQuickBooksTerms(this.Name);
			obj.Active      = this.Active;
			
			obj = this.quickBooks.TermOperations.Insert(obj);
			this.RawContent   = obj.RawContent;
			this.ID           = obj.Id;
			this.TimeModified = obj.MetaData.LastUpdatedTime;
			return this.ID;
		}

		public override void Delete()
		{
			this.quickBooks.TermOperations.Delete(this.ID);
		}

		public override void Get(string sID)
		{
			IList<Spring.Social.QuickBooks.Api.Term> lst = this.quickBooks.TermOperations.GetAll("Id = '" + sID + "'", String.Empty);
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
			IList<Spring.Social.QuickBooks.Api.QBase> lst = this.quickBooks.TermOperations.GetModified(dtStartModifiedDate);
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
									case "NAME"       :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "DESCRIPTION":  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									default           :  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
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
