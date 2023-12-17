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

namespace Spring.Social.PhoneBurner
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
		protected Spring.Social.PhoneBurner.Api.IPhoneBurner phoneBurner;
		public string   PhoneBurnerTableName       ;
		public string   PhoneBurnerTableSort       ;
		public string   CRMModuleName          ;
		public string   CRMTableName           ;
		public string   CRMTableSort           ;
		public bool     CRMAssignedUser        ;

		public string   RawContent             ;
		public Guid     LOCAL_ID               ;
		public string   id                     ;
		public bool     Deleted                ;
		public DateTime createdate             ;
		public DateTime date_modified          ;
		public string   name                   ;

		// 02/02/2015 Paul.  TaxRates are read only. 
		public bool     IsReadOnly             ;

		public Spring.Social.PhoneBurner.Api.IPhoneBurner PhoneBurner
		{
			get { return this.phoneBurner; }
		}

		public string ID
		{
			get { return this.id; }
			set { this.id = value; }
		}

		public string Name
		{
			get { return this.name; }
		}

		public DateTime TimeModified
		{
			get { return this.date_modified; }
		}
		#endregion

		public HObject(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.PhoneBurner.Api.IPhoneBurner phoneBurner, string sPhoneBurnerTableName, string sPhoneBurnerTableSort, string sCRMModuleName, string sCRMTableName, string sCRMTableSort, bool bCRMAssignedUser)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.SyncError           = SyncError          ;

			this.phoneBurner          = phoneBurner          ;
			this.PhoneBurnerTableName = sPhoneBurnerTableName;
			this.PhoneBurnerTableSort = sPhoneBurnerTableSort;
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
			this.createdate       = DateTime.MinValue;
			this.date_modified    = DateTime.MinValue;
			this.name             = String.Empty     ;
		}

		public virtual bool SetFromCRM(string sId, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			// 02/01/2014 Paul.  Reset in Sync() not in SetFromCRM. 
			//this.Reset();
			this.id = sId;
			if ( Sql.IsEmptyString(this.ID) )
			{
				this.name    = Sql.ToString(row["NAME"]);
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

		public virtual void SetFromPhoneBurner(string sId)
		{
			this.Reset();
			this.id = sId;
		}

		public virtual void Update()
		{
			throw(new Exception("Not implemented."));
		}

		public virtual string Insert()
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

		public virtual IList<Spring.Social.PhoneBurner.Api.HBase> SelectModified(DateTime dtStartModifiedDate)
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

		protected bool InitUpdateProcedure(IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID)
		{
			bool bChanged = false;
			// 03/25/2010 Paul.  We start with the existing record values so that we can apply ACL Field Security rules. 
			if ( row != null && row.Table != null )
			{
				foreach(IDbDataParameter par in spUpdate.Parameters)
				{
					// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
					// 03/28/2010 Paul.  We must assign a value to all parameters. 
					string sParameterName = Sql.ExtractDbName(spUpdate, par.ParameterName).ToUpper();
					if ( row.Table.Columns.Contains(sParameterName) )
						par.Value = row[sParameterName];
					else
						par.Value = DBNull.Value;
				}
			}
			else
			{
				bChanged = true;
				foreach(IDbDataParameter par in spUpdate.Parameters)
				{
					// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
					string sParameterName = Sql.ExtractDbName(spUpdate, par.ParameterName).ToUpper();
					if ( sParameterName == "TEAM_ID" )
						par.Value = gTEAM_ID;
					else if ( sParameterName == "ASSIGNED_USER_ID" )
						par.Value = gUSER_ID;
					// 02/20/2013 Paul.  We need to set the MODIFIED_USER_ID. 
					else if ( sParameterName == "MODIFIED_USER_ID" )
						par.Value = gUSER_ID;
					else
						par.Value = DBNull.Value;
				}
			}
			return bChanged;
		}

		// 02/03/2015 Paul.  It would be helpful to track changes. 
		public virtual bool BuildUpdateProcedure(ExchangeSession Session, IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
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
							case "NAME"            :  oValue = Sql.ToDBString(this.name);  break;
							case "MODIFIED_USER_ID":  oValue = gUSER_ID                 ;  break;
						}
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						// 02/17/2015 Paul.  Modified User ID does not count as a changed field. 
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
						{
							if ( !bChanged )
							{
								bChanged = ParameterChanged(par, oValue, sbChanges);
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

		public virtual void ProcedureUpdated(Guid gID, string sREMOTE_KEY, IDbTransaction trn, Guid gUSER_ID)
		{
		}

		public bool Import(ExchangeSession Session, IDbConnection con, Guid gUSER_ID, string sDIRECTION, StringBuilder sbErrors)
		{
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.PhoneBurner.VerboseStatus"     ]);
			string sCONFLICT_RESOLUTION = Sql.ToString (Application["CONFIG.PhoneBurner.ConflictResolution"]);
			Guid   gTEAM_ID             = Sql.ToGuid   (Session["TEAM_ID"]);
			
			IDbCommand spUpdate = SqlProcs.Factory(con, "sp" + this.CRMTableName + "_Update");

			bool     bImported    = false;
			string   sREMOTE_KEY  = this.ID;
			string   sName        = Sql.ToString(this.name);
			DateTime dtREMOTE_DATE_MODIFIED     = this.TimeModified;
			DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();

			String sSQL = String.Empty;
			sSQL = "select SYNC_ID                                       " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_DATE_MODIFIED_UTC                  " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_DATE_MODIFIED_UTC                 " + ControlChars.CrLf
			     + "     , ID                                            " + ControlChars.CrLf
			     + "     , DATE_MODIFIED_UTC                             " + ControlChars.CrLf
			     + "  from vw" + this.CRMTableName + "_SYNC              " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'PhoneBurner'            " + ControlChars.CrLf
			     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
			     + "   and SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf;
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
				Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					string sSYNC_ACTION   = String.Empty;
					Guid   gSYNC_LOCAL_ID = Guid.Empty;
					using ( DataTable dt = new DataTable() )
					{
						da.Fill(dt);
						if ( dt.Rows.Count > 0 )
						{
							DataRow row = dt.Rows[0];
							this.LOCAL_ID                            = Sql.ToGuid    (row["ID"                           ]);
							gSYNC_LOCAL_ID                           = Sql.ToGuid    (row["SYNC_LOCAL_ID"                ]);
							DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
							DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
							DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
							// 03/28/2010 Paul.  If the ID is NULL and the LOCAL_ID is NOT NULL, then the local item must have been deleted. 
							if ( (Sql.IsEmptyGuid(this.LOCAL_ID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID)) )
							{
								sSYNC_ACTION = "local deleted";
							}
							// 03/26/2011 Paul.  The PhoneBurner remote date can vary by 1 millisecond, so check for local change first. 
							else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(10) && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
							{
								if ( sCONFLICT_RESOLUTION == "remote" )
								{
									// 03/24/2010 Paul.  Remote is the winner of conflicts. 
									sSYNC_ACTION = "remote changed";
								}
								else if ( sCONFLICT_RESOLUTION == "local" )
								{
									// 03/24/2010 Paul.  Local is the winner of conflicts. 
									sSYNC_ACTION = "local changed";
								}
								// 03/26/2011 Paul.  The PhoneBurner remote date can vary by 1 millisecond, so check for local change first. 
								else if ( dtDATE_MODIFIED_UTC.AddHours(1) > dtREMOTE_DATE_MODIFIED_UTC )
								{
									// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
									sSYNC_ACTION = "local changed";
								}
								else if ( dtREMOTE_DATE_MODIFIED_UTC.AddHours(1) > dtDATE_MODIFIED_UTC )
								{
									// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
									sSYNC_ACTION = "remote changed";
								}
								else
								{
									sSYNC_ACTION = "prompt change";
								}
								if ( this.Deleted )
								{
									sSYNC_ACTION = "remote deleted";
								}
								
							}
							// 03/26/2011 Paul.  The PhoneBurner remote date can vary by 1 millisecond, so check for local change first. 
							else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(10) )
							{
								// 03/24/2010 Paul.  Remote Record has changed, but Local has not. 
								sSYNC_ACTION = "remote changed";
							}
							else if ( dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
							{
								// 03/24/2010 Paul.  Local Record has changed, but Remote has not. 
								sSYNC_ACTION = "local changed";
							}
						}
						else if ( this.Deleted )
						{
							sSYNC_ACTION = "remote deleted";
						}
						else
						{
							sSYNC_ACTION = "remote new";
							
							// 03/25/2010 Paul.  If we find a account, then treat the CRM record as the master and send latest version over to PhoneBurner. 
							// 05/30/2012 Paul.  There can only be one record mapped to PhoneBurner, so we don't need to join to the remote key. 
							cmd.Parameters.Clear();
							// 01/27/2015 Paul.  View name changed so as to support Oracle. 
							sSQL = "select vw" + this.CRMTableName + ".ID             " + ControlChars.CrLf
							     + "  from            " + Sql.MetadataName(cmd, "vw" + this.CRMTableName + "_PhoneBurner") + "  vw" + this.CRMTableName   + ControlChars.CrLf
							     + "  left outer join vw" + this.CRMTableName + "_SYNC" + ControlChars.CrLf
							     + "               on vw" + this.CRMTableName + "_SYNC.SYNC_SERVICE_NAME     = N'PhoneBurner'   " + ControlChars.CrLf
							     + "              and vw" + this.CRMTableName + "_SYNC.SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
							//     + "              and vw" + this.CRMTableName + "_SYNC.SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf
							     + "              and vw" + this.CRMTableName + "_SYNC.SYNC_LOCAL_ID         = vw" + this.CRMTableName + ".ID" + ControlChars.CrLf;
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
							//Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
							ExchangeSecurity.Filter(Session, cmd, gUSER_ID, this.CRMModuleName, "view");
							this.FilterCRM(cmd);
							cmd.CommandText += "   and vw" + this.CRMTableName + "_SYNC.ID is null" + ControlChars.CrLf;
							this.LOCAL_ID = Sql.ToGuid(cmd.ExecuteScalar());
							if ( !Sql.IsEmptyGuid(this.LOCAL_ID) )
							{
								// 02/02/2015 Paul.  TaxRates is read only.  Can't apply changes locally, so treat remote as changed so that sync record will be updated. 
								if ( this.IsReadOnly )
									sSYNC_ACTION = "remote changed";
								else if ( sCONFLICT_RESOLUTION == "remote" )
									sSYNC_ACTION = "remote changed";
								else if ( sCONFLICT_RESOLUTION == "local" )
									sSYNC_ACTION = "local changed";
								else
									sSYNC_ACTION = "local new";
							}
						}
					}
					using ( DataTable dt = new DataTable() )
					{
						DataRow row = null;
						Guid gASSIGNED_USER_ID = Guid.Empty;
						if ( sSYNC_ACTION == "remote new" || sSYNC_ACTION == "remote changed" || sSYNC_ACTION == "local changed" || sSYNC_ACTION == "local new" )
						{
							if ( !Sql.IsEmptyGuid(this.LOCAL_ID) )
							{
								cmd.Parameters.Clear();
								sSQL = "select *         " + ControlChars.CrLf
								     + "  from vw" + this.CRMTableName + ControlChars.CrLf
								     + " where ID = @ID  " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", this.LOCAL_ID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
								{
									row = dt.Rows[0];
									if ( this.CRMAssignedUser )
										gASSIGNED_USER_ID = Sql.ToGuid(row["ASSIGNED_USER_ID"]);
								}
							}
						}
						if ( sSYNC_ACTION == "remote new" || sSYNC_ACTION == "remote changed" )
						{
							// 05/18/2012 Paul.  Allow control of sync direction. 
							if (sDIRECTION == "bi-directional" || sDIRECTION == "to crm only" )
							{
								bool bChanged = false;
								StringBuilder sbChanges = new StringBuilder();
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										if ( bVERBOSE_STATUS )
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), this.PhoneBurnerTableName + ".Import: Retrieving " + this.PhoneBurnerTableName + " " + sName + ".");
									
										spUpdate.Transaction = trn;
										// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
										// 01/28/2012 Paul.  The transaction is necessary so that an account can be created. 
										bChanged |= this.BuildUpdateProcedure(Session, spUpdate, row, gUSER_ID, gTEAM_ID, gASSIGNED_USER_ID, trn, sbChanges);
										if ( bChanged )
										{
											spUpdate.ExecuteNonQuery();
											IDbDataParameter parID = Sql.FindParameter(spUpdate, "@ID");
											this.LOCAL_ID = Sql.ToGuid(parID.Value);
										}
										if ( bChanged )
										{
											// 02/19/2015 Paul. Delay ProcedureUpdated until after LineItems are updated. 
											this.ProcedureUpdated(this.LOCAL_ID, sREMOTE_KEY, trn, gUSER_ID);
										}
										
										IDbCommand spSyncUpdate = SqlProcs.Factory(con, "sp" + this.CRMTableName + "_SYNC_Update");
										spSyncUpdate.Transaction = trn;
										Sql.SetParameter(spSyncUpdate, "@MODIFIED_USER_ID"        , gUSER_ID                  );
										Sql.SetParameter(spSyncUpdate, "@ASSIGNED_USER_ID"        , gUSER_ID                  );
										Sql.SetParameter(spSyncUpdate, "@LOCAL_ID"                , this.LOCAL_ID             );
										Sql.SetParameter(spSyncUpdate, "@REMOTE_KEY"              , sREMOTE_KEY               );
										Sql.SetParameter(spSyncUpdate, "@REMOTE_DATE_MODIFIED"    , dtREMOTE_DATE_MODIFIED    );
										Sql.SetParameter(spSyncUpdate, "@REMOTE_DATE_MODIFIED_UTC", dtREMOTE_DATE_MODIFIED_UTC);
										Sql.SetParameter(spSyncUpdate, "@SERVICE_NAME"            , "PhoneBurner"                 );
										Sql.SetParameter(spSyncUpdate, "@RAW_CONTENT"             , this.RawContent           );
										spSyncUpdate.ExecuteNonQuery();
										trn.Commit();
										bImported = true;
									}
									catch(Exception ex)
									{
										trn.Rollback();
										// 03/23/2015 Paul.  row might be NULL. 
										string sError = "Error saving " + Sql.ToString(this.Name) + "." + ControlChars.CrLf;
										sError += sbChanges.ToString();
										sError += Utils.ExpandException(ex) + ControlChars.CrLf;
										SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									}
								}
								if ( bChanged && bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), this.PhoneBurnerTableName + ".Import: Received " + this.PhoneBurnerTableName + " " + sName + ". " + sbChanges.ToString());
							}
						}
						else if ( (sSYNC_ACTION == "local changed" || sSYNC_ACTION == "local new") && !Sql.IsEmptyGuid(this.LOCAL_ID) )
						{
							// 03/25/2010 Paul.  If we find a account, then treat the CRM record as the master and send latest version over to PhoneBurner. 
							if ( dt.Rows.Count > 0 )
							{
								row = dt.Rows[0];
#if !DEBUG
								if ( SplendidInit.bEnableACLFieldSecurity )
								{
									bool bApplyACL = false;
									foreach ( DataColumn col in dt.Columns )
									{
										Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, this.CRMModuleName, col.ColumnName, gASSIGNED_USER_ID);
										if ( !acl.IsReadable() )
										{
											row[col.ColumnName] = DBNull.Value;
											bApplyACL = true;
										}
									}
									if ( bApplyACL )
										dt.AcceptChanges();
								}
#endif
								StringBuilder sbChanges = new StringBuilder();
								try
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), this.PhoneBurnerTableName + ".Import: Syncing " + this.PhoneBurnerTableName + " " + Sql.ToString(row["NAME"]) + ".");
									bool bChanged = false;
									// 05/18/2012 Paul.  Allow control of sync direction. 
									if (sDIRECTION == "bi-directional" || sDIRECTION == "from crm only" )
									{
										bChanged = this.SetFromCRM(sREMOTE_KEY, row, sbChanges);
										if ( bChanged )
											this.Update();
									}
									// 03/25/2010 Paul.  Update the modified date after the save. 
									// 03/26/2011 Paul.  Updated is in local time. 
									dtREMOTE_DATE_MODIFIED     = this.TimeModified;
									dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED_UTC.ToUniversalTime();
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											// 02/19/2015 Paul. Delay ProcedureUpdated until after LineItems are updated. 
											this.ProcedureUpdated(this.LOCAL_ID, sREMOTE_KEY, trn, gUSER_ID);
											
											// 03/26/2010 Paul.  Make sure to set the Sync flag. 
											// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
											IDbCommand spSyncUpdate = SqlProcs.Factory(con, "sp" + this.CRMTableName + "_SYNC_Update");
											spSyncUpdate.Transaction = trn;
											Sql.SetParameter(spSyncUpdate, "@MODIFIED_USER_ID"        , gUSER_ID                  );
											Sql.SetParameter(spSyncUpdate, "@ASSIGNED_USER_ID"        , gUSER_ID                  );
											Sql.SetParameter(spSyncUpdate, "@LOCAL_ID"                , this.LOCAL_ID             );
											Sql.SetParameter(spSyncUpdate, "@REMOTE_KEY"              , sREMOTE_KEY               );
											Sql.SetParameter(spSyncUpdate, "@REMOTE_DATE_MODIFIED"    , dtREMOTE_DATE_MODIFIED    );
											Sql.SetParameter(spSyncUpdate, "@REMOTE_DATE_MODIFIED_UTC", dtREMOTE_DATE_MODIFIED_UTC);
											Sql.SetParameter(spSyncUpdate, "@SERVICE_NAME"            , "PhoneBurner"                 );
											Sql.SetParameter(spSyncUpdate, "@RAW_CONTENT"             , this.RawContent           );
											spSyncUpdate.ExecuteNonQuery();
											trn.Commit();
										}
										catch(Exception ex)
										{
											trn.Rollback();
											// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
											string sError = "Error saving " + Sql.ToString  (row["NAME"]) + "." + ControlChars.CrLf;
											sError += sbChanges.ToString();
											sError += Utils.ExpandException(ex) + ControlChars.CrLf;
											SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
											//SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
											sbErrors.AppendLine(sError);
										}
									}
								}
								catch(Exception ex)
								{
									// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
									string sError = "Error saving " + Sql.ToString  (row["NAME"]) + "." + ControlChars.CrLf;
									sError += sbChanges.ToString();
									sError += Utils.ExpandException(ex) + ControlChars.CrLf;
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									//SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									sbErrors.AppendLine(sError);
								}
							}
						}
						else if ( sSYNC_ACTION == "local deleted" )
						{
							try
							{
								// 05/18/2012 Paul.  Allow control of sync direction. 
								if (sDIRECTION == "bi-directional" || sDIRECTION == "from crm only" )
								{
									this.Delete();
								}
							}
							catch(Exception ex)
							{
								string sError = "Error deleting PhoneBurner " + this.PhoneBurnerTableName + " " + sName + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
							if ( bVERBOSE_STATUS )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), this.PhoneBurnerTableName + ".Import: Deleting " + sName + ".");
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									IDbCommand spSyncDelete = SqlProcs.Factory(con, "sp" + this.CRMTableName + "_SYNC_Delete");
									spSyncDelete.Transaction = trn;
									Sql.SetParameter(spSyncDelete, "@MODIFIED_USER_ID", gUSER_ID          );
									Sql.SetParameter(spSyncDelete, "@ASSIGNED_USER_ID", gUSER_ID          );
									Sql.SetParameter(spSyncDelete, "@LOCAL_ID"        , gSYNC_LOCAL_ID    );
									Sql.SetParameter(spSyncDelete, "@REMOTE_KEY"      , sREMOTE_KEY       );
									Sql.SetParameter(spSyncDelete, "@SERVICE_NAME"    , "PhoneBurner"         );
									spSyncDelete.ExecuteNonQuery();
									trn.Commit();
								}
								catch(Exception ex)
								{
									trn.Rollback();
									string sError = "Error deleting " + sName + "." + ControlChars.CrLf;
									sError += Utils.ExpandException(ex) + ControlChars.CrLf;
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									sbErrors.AppendLine(sError);
								}
							}
						}
						else if ( sSYNC_ACTION == "remote deleted" && !Sql.IsEmptyGuid(this.LOCAL_ID) )
						{
							// 08/05/2014 Paul.  Deletes should follow the same direction rules. 
							if (sDIRECTION == "bi-directional" || sDIRECTION == "to crm only" )
							{
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), this.PhoneBurnerTableName + ".Import: Deleting " + this.CRMTableName + " " + sName + ".");
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										IDbCommand spSyncDelete = SqlProcs.Factory(con, "sp" + this.CRMTableName + "_SYNC_Delete");
										spSyncDelete.Transaction = trn;
										Sql.SetParameter(spSyncDelete, "@MODIFIED_USER_ID", gUSER_ID          );
										Sql.SetParameter(spSyncDelete, "@ASSIGNED_USER_ID", gUSER_ID          );
										Sql.SetParameter(spSyncDelete, "@LOCAL_ID"        , this.LOCAL_ID     );
										Sql.SetParameter(spSyncDelete, "@REMOTE_KEY"      , sREMOTE_KEY       );
										Sql.SetParameter(spSyncDelete, "@SERVICE_NAME"    , "PhoneBurner"         );
										spSyncDelete.ExecuteNonQuery();
									
										IDbCommand spDelete = SqlProcs.Factory(con, "sp" + this.CRMTableName + "_Delete");
										spDelete.Transaction = trn;
										Sql.SetParameter(spDelete, "@ID"              , this.LOCAL_ID );
										Sql.SetParameter(spDelete, "@MODIFIED_USER_ID", gUSER_ID      );
										spDelete.ExecuteNonQuery();
										trn.Commit();
									}
									catch(Exception ex)
									{
										trn.Rollback();
										string sError = "Error unlinking " + sName + "." + ControlChars.CrLf;
										sError += Utils.ExpandException(ex) + ControlChars.CrLf;
										SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										sbErrors.AppendLine(sError);
									}
								}
							}
						}
					}
				}
			}
			return bImported;
		}
	}
}
