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

namespace Spring.Social.GetResponse
{
	public class HObject
	{
		protected SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		protected HttpApplicationState Application        = new HttpApplicationState();
		protected HttpSessionState     Session            ;
		protected Security             Security           ;
		protected Sql                  Sql                ;
		protected SqlProcs             SqlProcs           ;
		protected ExchangeSecurity     ExchangeSecurity   ;
		protected SyncError            SyncError          ;

		#region Properties
		protected Spring.Social.GetResponse.Api.IGetResponse getResponse;
		public string   GetResponseTableName;
		public string   GetResponseTableSort;
		public string   CRMModuleName           ;
		public string   CRMTableName            ;
		public string   CRMTableSort            ;
		public bool     CRMAssignedUser         ;

		public string   RawContent              ;
		public Guid     LOCAL_ID                ;
		public string   id                      ;
		public bool     Deleted                 ;
		public DateTime createdOn               ;
		public DateTime changedOn               ;
		public string   name                    ;

		// 02/02/2015 Paul.  TaxRates are read only. 
		public bool     IsReadOnly             ;

		public Spring.Social.GetResponse.Api.IGetResponse GetResponse
		{
			get { return this.getResponse; }
		}

		public string ID
		{
			get { return Sql.ToString(this.id); }
			set { this.id = value; }
		}

		public string Name
		{
			get { return this.name; }
		}

		public DateTime TimeModified
		{
			get { return this.changedOn; }
		}
		#endregion

		public HObject(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.GetResponse.Api.IGetResponse getResponse, string sGetResponseTableName, string sGetResponseTableSort, string sCRMModuleName, string sCRMTableName, string sCRMTableSort, bool bCRMAssignedUser)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.SyncError           = SyncError          ;

			this.getResponse          = getResponse          ;
			this.GetResponseTableName = sGetResponseTableName;
			this.GetResponseTableSort = sGetResponseTableSort;
			this.CRMModuleName        = sCRMModuleName       ;
			this.CRMTableName         = sCRMTableName        ;
			this.CRMTableSort         = sCRMTableSort        ;
			this.CRMAssignedUser      = bCRMAssignedUser     ;
			this.IsReadOnly           = false                ;
		}

		public virtual void Reset()
		{
			this.RawContent       = String.Empty     ;
			this.LOCAL_ID         = Guid.Empty       ;
			this.id               = String.Empty     ;
			this.Deleted          = false            ;
			this.createdOn        = DateTime.MinValue;
			this.changedOn        = DateTime.MinValue;
			this.name             = String.Empty     ;
		}

		public virtual bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			// 02/01/2014 Paul.  Reset in Sync() not in SetFromCRM. 
			//this.Reset();
			this.id = sID;
			if ( Sql.IsEmptyString(this.ID) )
			{
				this.name = Sql.ToString(row["NAME"]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.name, row["NAME"], "NAME", sbChanges) ) { this.name = Sql.ToString(row["NAME"]);  bChanged = true; }
			}
			return bChanged;
		}

		protected bool Compare(string sLValue, object oRValue, string sFieldName, StringBuilder sbChanges)
		{
			bool bChanged = false;
			string sRValue = Sql.ToString(oRValue);
			if ( Sql.ToString(sLValue).Trim() != sRValue.Trim() )
			{
				sbChanges.AppendLine(sFieldName + " changed from '" + sLValue + "' to '" + sRValue + "'.");
				bChanged = true;
			}
			return bChanged;
		}

		protected bool Compare(bool bLValue, object oRValue, string sFieldName, StringBuilder sbChanges)
		{
			bool bChanged = false;
			bool bRValue = Sql.ToBoolean(oRValue);
			if ( bLValue != bRValue )
			{
				sbChanges.AppendLine(sFieldName + " changed from '" + bLValue.ToString() + "' to '" + bRValue.ToString() + "'.");
				bChanged = true;
			}
			return bChanged;
		}

		protected bool Compare(DateTime dtLValue, object oRValue, string sFieldName, StringBuilder sbChanges)
		{
			bool bChanged = false;
			DateTime dtRValue = Sql.ToDateTime(oRValue);
			if ( dtLValue != dtRValue )
			{
				sbChanges.AppendLine(sFieldName + " changed from '" + dtLValue.ToString() + "' to '" + dtRValue.ToString() + "'.");
				bChanged = true;
			}
			return bChanged;
		}

		protected bool Compare(double dLValue, object oRValue, string sFieldName, StringBuilder sbChanges)
		{
			bool bChanged = false;
			double dRValue = Sql.ToDouble(oRValue);
			if ( dLValue != dRValue )
			{
				sbChanges.AppendLine(sFieldName + " changed from '" + dLValue.ToString() + "' to '" + dRValue.ToString() + "'.");
				bChanged = true;
			}
			return bChanged;
		}

		protected bool Compare(Decimal dLValue, object oRValue, string sFieldName, StringBuilder sbChanges)
		{
			bool bChanged = false;
			Decimal dRValue = Sql.ToDecimal(oRValue);
			if ( dLValue != dRValue )
			{
				sbChanges.AppendLine(sFieldName + " changed from '" + dLValue.ToString() + "' to '" + dRValue.ToString() + "'.");
				bChanged = true;
			}
			return bChanged;
		}

		protected bool Compare(int dLValue, object oRValue, string sFieldName, StringBuilder sbChanges)
		{
			bool bChanged = false;
			int dRValue = Sql.ToInteger(oRValue);
			if ( dLValue != dRValue )
			{
				sbChanges.AppendLine(sFieldName + " changed from '" + dLValue.ToString() + "' to '" + dRValue.ToString() + "'.");
				bChanged = true;
			}
			return bChanged;
		}

		public virtual void SetFromGetResponse(string sID)
		{
			this.Reset();
			this.id = sID;
		}

		public virtual void SetFromGetResponse(Spring.Social.GetResponse.Api.Contact obj)
		{
			this.Reset();
			this.RawContent            = obj.RawContent           ;
			this.id                    = obj.id                   ;
		}

		public virtual void Update()
		{
			throw(new Exception("Not implemented."));
		}

		public virtual string Insert(string sDefaultCampaignID)
		{
			throw(new Exception("Not implemented."));
		}

		public virtual void Delete()
		{
			throw(new Exception("Not implemented."));
		}

		public virtual void Getlastmodifieddate()
		{
			throw(new Exception("Not implemented."));
		}

		public virtual void Get(string sID)
		{
			throw(new Exception("Not implemented."));
		}

		public virtual void FilterCRM(IDbCommand cmd)
		{
			Sql.AppendParameter(cmd, Sql.ToString(this.name), "NAME");
		}

		public virtual IList<Spring.Social.GetResponse.Api.Contact> SelectModified(DateTime dtStartModifiedDate)
		{
			throw(new Exception("Not implemented."));
		}

		// 02/03/2015 Paul.  It would be helpful to track changes. 
		protected bool ParameterChanged(IDbDataParameter par, object oValue, int nSize, StringBuilder sbChanges)
		{
			bool bChanged = false;
			string sValue = Sql.ToString(oValue);
			if ( sValue.Length > nSize )
				sValue = sValue.Substring(0, nSize);
			// 03/04/2015 Paul.  Trim so that address field is not considered changed if contains trailing line feed. 
			if ( Sql.ToString(par.Value).Trim() != sValue.Trim() )
				bChanged = true;
			if ( bChanged )
			{
				sbChanges.AppendLine(par.ParameterName + " changed from '" + Sql.ToString  (par.Value) + "' to '" + Sql.ToString  (oValue) + "'.");
			}
			return bChanged;
		}

		// 02/03/2015 Paul.  It would be helpful to track changes. 
		protected bool ParameterChanged(IDbDataParameter par, object oValue, StringBuilder sbChanges)
		{
			bool bChanged = false;
			switch ( par.DbType )
			{
				case DbType.Guid    :  if ( Sql.ToGuid    (par.Value) != Sql.ToGuid    (oValue) ) bChanged = true;  break;
				case DbType.Int16   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
				case DbType.Int32   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
				case DbType.Int64   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
				case DbType.Double  :  if ( Sql.ToDouble  (par.Value) != Sql.ToDouble  (oValue) ) bChanged = true;  break;
				case DbType.Decimal :  if ( Sql.ToDecimal (par.Value) != Sql.ToDecimal (oValue) ) bChanged = true;  break;
				case DbType.Boolean :  if ( Sql.ToBoolean (par.Value) != Sql.ToBoolean (oValue) ) bChanged = true;  break;
				case DbType.DateTime:  if ( Sql.ToDateTime(par.Value) != Sql.ToDateTime(oValue) ) bChanged = true;  break;
				// 02/19/2015 Paul.  Trim strings before comparing. This is primarily to remove trailing CRLF on the Street field. 
				default             :  if ( Sql.ToString  (par.Value).Trim() != Sql.ToString  (oValue).Trim() ) bChanged = true;  break;
			}
			if ( bChanged )
			{
				sbChanges.AppendLine(par.ParameterName + " changed from '" + Sql.ToString  (par.Value) + "' to '" + Sql.ToString  (oValue) + "'.");
			}
			return bChanged;
		}

		// 05/06/2015 Paul.  GetResponse does not seem to allow stand-alone contacts.  
	}
}
