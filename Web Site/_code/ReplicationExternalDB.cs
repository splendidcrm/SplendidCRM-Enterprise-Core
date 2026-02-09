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
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Diagnostics;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using DocumentFormat.OpenXml.InkML;
using Microsoft.AspNetCore.Http;

namespace SplendidCRM
{
	public class ReplicationBackground
	{
		public ReplicationExternalDB ReplicationExternalDB    ;
		public string                sTABLE_NAME              ;

		public ReplicationBackground(ReplicationExternalDB ReplicationExternalDB, string sTABLE_NAME)
		{
			this.ReplicationExternalDB     = ReplicationExternalDB    ;
			this.sTABLE_NAME = sTABLE_NAME;
		}
			
		public void Start()
		{
			ReplicationExternalDB.RunReplication(sTABLE_NAME);
		}
	}

	/// <summary>
	/// Summary description for ReplicationExternalDB.
	/// </summary>
	public class ReplicationExternalDB
	{
		public static bool     bInsideReplication = false;

		private DbReplicationFactories  DbReplicationFactories  = new DbReplicationFactories();
		private DbProviderFactories  DbProviderFactories = new DbProviderFactories();
		private HttpApplicationState Application         = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private ArchiveExternalDB    ArchiveExternalDB  ;
		private SyncError            SyncError          ;
		private static Dictionary<string, IDbCommand> dictCache          = new Dictionary<string, IDbCommand>();
		private static List<string>                   lstProcessing      = new List<string>();

		public ReplicationExternalDB(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, ArchiveExternalDB ArchiveExternalDB, SyncError SyncError)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.ArchiveExternalDB   = ArchiveExternalDB  ;
			this.SyncError           = SyncError          ;
		}

		private string GetIdField(string sTABLE_NAME)
		{
			string sID_FIELD   = "ID";
			if ( sTABLE_NAME.EndsWith("_STREAM") )
			{
				sID_FIELD   = "STREAM_ID";
			}
			else if ( sTABLE_NAME.EndsWith("_CSTM") || sTABLE_NAME.EndsWith("_CSTM_ARCHIVE") )
			{
				sID_FIELD   = "ID_C";
			}
			else if ( sTABLE_NAME.EndsWith("_AUDIT") || sTABLE_NAME.EndsWith("_AUDIT_ARCHIVE") )
			{
				sID_FIELD   = "AUDIT_ID";
			}
			return sID_FIELD;
		}

		private string GetDateField(string sTABLE_NAME)
		{
			string sDATE_FIELD = "DATE_MODIFIED";
			if ( sTABLE_NAME.EndsWith("_STREAM") )
			{
				sDATE_FIELD = "STREAM_DATE";
			}
			else if ( sTABLE_NAME.EndsWith("_AUDIT") || sTABLE_NAME.EndsWith("_AUDIT_ARCHIVE") )
			{
				sDATE_FIELD = "AUDIT_DATE";
			}
			else if ( sTABLE_NAME.StartsWith("WF4_") )
			{
				sDATE_FIELD = "DATE_ENTERED";
			}
			else if ( sTABLE_NAME.StartsWith("WWF_") )
			{
				sDATE_FIELD = "DATE_ENTERED";
			}
			return sDATE_FIELD;
		}

		private IDbCommand BuildReplicationStatement(string sTABLE_NAME)
		{
			IDbCommand cmdPrimaryInsert = null;
			if ( dictCache.ContainsKey(sTABLE_NAME) )
			{
				cmdPrimaryInsert = dictCache[sTABLE_NAME];
				return cmdPrimaryInsert;
			}
			string sID_FIELD   = GetIdField(sTABLE_NAME);

			DbProviderFactory dbfReplication = DbReplicationFactories.GetFactory();
			cmdPrimaryInsert = dbfReplication.CreateCommand();
			cmdPrimaryInsert.CommandType = CommandType.Text;
#if !DEBUG
			dictCache[sTABLE_NAME] = cmdPrimaryInsert;
#endif

			int nPRIMARY_EXISTS = 0;
			List<string> lstPrimaryFields = new List<string>();
			StringBuilder sb = new StringBuilder();
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				string sSQL;
				con.Open();
				using ( DataTable dtPrimary = new DataTable() )
				{
					sSQL = "select count(*)                 " + ControlChars.CrLf
					     + "  from INFORMATION_SCHEMA.TABLES" + ControlChars.CrLf
					     + " where TABLE_NAME = @TABLE_NAME " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						cmd.CommandTimeout = 0;
						Sql.AddParameter(cmd, "@TABLE_NAME", sTABLE_NAME);
						nPRIMARY_EXISTS += Sql.ToInteger(cmd.ExecuteScalar());
					}
					// 01/01/2026 Paul.  Cannot insert or update timestamp field. 
					sSQL = "select COLUMN_NAME               " + ControlChars.CrLf
					     + "     , DATA_TYPE                 " + ControlChars.CrLf
					     + "     , CHARACTER_MAXIMUM_LENGTH  " + ControlChars.CrLf
					     + "     , NUMERIC_PRECISION         " + ControlChars.CrLf
					     + "     , NUMERIC_SCALE             " + ControlChars.CrLf
					     + "  from INFORMATION_SCHEMA.COLUMNS" + ControlChars.CrLf
					     + " where TABLE_NAME = @TABLE_NAME  " + ControlChars.CrLf
					     + "   and DATA_TYPE <> 'timestamp'  " + ControlChars.CrLf
					     + " order by ORDINAL_POSITION       " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						cmd.CommandTimeout = 0;
						Sql.AddParameter(cmd, "@TABLE_NAME", sTABLE_NAME);
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							da.Fill(dtPrimary);
						}
					}
					using ( IDbConnection conReplication = dbfReplication.CreateConnection() )
					{
						conReplication.Open();
						using ( DataTable dtPrimaryArchive = new DataTable() )
						{
							sSQL = "select count(*)                 " + ControlChars.CrLf
							     + "  from INFORMATION_SCHEMA.TABLES" + ControlChars.CrLf
							     + " where TABLE_NAME = @TABLE_NAME " + ControlChars.CrLf;
							using ( IDbCommand cmd = conReplication.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								cmd.CommandTimeout = 0;
								Sql.AddParameter(cmd, "@TABLE_NAME", sTABLE_NAME);
								nPRIMARY_EXISTS += Sql.ToInteger(cmd.ExecuteScalar());
							}
							// 01/01/2026 Paul.  Cannot insert or update timestamp field. 
							sSQL = "select COLUMN_NAME               " + ControlChars.CrLf
							     + "     , DATA_TYPE                 " + ControlChars.CrLf
							     + "     , CHARACTER_MAXIMUM_LENGTH  " + ControlChars.CrLf
							     + "     , NUMERIC_PRECISION         " + ControlChars.CrLf
							     + "     , NUMERIC_SCALE             " + ControlChars.CrLf
							     + "  from INFORMATION_SCHEMA.COLUMNS" + ControlChars.CrLf
							     + " where TABLE_NAME = @TABLE_NAME  " + ControlChars.CrLf
							     + "   and DATA_TYPE <> 'timestamp'  " + ControlChars.CrLf
							     + " order by ORDINAL_POSITION       " + ControlChars.CrLf;
							using ( IDbCommand cmd = conReplication.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								cmd.CommandTimeout = 0;
								Sql.AddParameter(cmd, "@TABLE_NAME", sTABLE_NAME);
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									da.Fill(dtPrimaryArchive);
									DataView vwArchive = new DataView(dtPrimaryArchive);
									foreach ( DataRow row in dtPrimary.Rows )
									{
										string sCOLUMN_NAME = Sql.ToString(row["COLUMN_NAME"]);
										vwArchive.RowFilter = "COLUMN_NAME = '" + sCOLUMN_NAME + "'";
										if ( vwArchive.Count > 0 )
										{
											lstPrimaryFields.Add(sCOLUMN_NAME);
										}
									}
								}
							}
						}
						if ( nPRIMARY_EXISTS == 2 )
						{
							StringBuilder sbPrimaryInsert = new StringBuilder();
							StringBuilder sbPrimaryUpdate = new StringBuilder();
							sbPrimaryInsert.AppendLine("\tinsert into " + sTABLE_NAME);
							sbPrimaryUpdate.AppendLine("\tupdate " + sTABLE_NAME);
							int nFieldIndex = 0;
							foreach ( DataRow row in dtPrimary.Rows )
							{
								string sCOLUMN_NAME = Sql.ToString(row["COLUMN_NAME"]);
								if ( lstPrimaryFields.Contains(sCOLUMN_NAME) )
								{
									sbPrimaryInsert.Append("\t\t");
									sbPrimaryInsert.Append(nFieldIndex == 0 ? "(" : ",");
									sbPrimaryInsert.AppendLine(" " + sCOLUMN_NAME);

									sbPrimaryUpdate.Append("\t");
									sbPrimaryUpdate.Append(nFieldIndex == 0 ? "   set " : "     , ");
									sbPrimaryUpdate.AppendLine(sCOLUMN_NAME + " = " + "@" + sCOLUMN_NAME);
									nFieldIndex++;
								}
							}
							sbPrimaryInsert.AppendLine("\t)");
							sbPrimaryInsert.AppendLine("values");
							nFieldIndex = 0;
							foreach ( DataRow row in dtPrimary.Rows )
							{
								string sCOLUMN_NAME              = Sql.ToString (row["COLUMN_NAME"             ]);
								string sDATA_TYPE                = Sql.ToString (row["DATA_TYPE"               ]);
								int    nCHARACTER_MAXIMUM_LENGTH = Sql.ToInteger(row["CHARACTER_MAXIMUM_LENGTH"]);
								if ( lstPrimaryFields.Contains(sCOLUMN_NAME) )
								{
									sbPrimaryInsert.Append("\t");
									sbPrimaryInsert.Append(nFieldIndex == 0 ? "(" : ",");
									sbPrimaryInsert.AppendLine(" @" + sCOLUMN_NAME);
									if ( nCHARACTER_MAXIMUM_LENGTH == -1 )
										nCHARACTER_MAXIMUM_LENGTH = 104857600;
									Sql.CreateParameter(cmdPrimaryInsert, "@" + sCOLUMN_NAME, ArchiveExternalDB.CsDataType(sDATA_TYPE), nCHARACTER_MAXIMUM_LENGTH);
									nFieldIndex++;
								}
							}
							sbPrimaryInsert.AppendLine("\t);");

							sbPrimaryUpdate.Append("\t");
							sbPrimaryUpdate.AppendLine(" where " + sID_FIELD + " = @" + sID_FIELD + ";");

							cmdPrimaryInsert.CommandText = "if not exists(select * from " + sTABLE_NAME + " where " + sID_FIELD + " = @" + sID_FIELD + ") begin -- then" + ControlChars.CrLf;
							cmdPrimaryInsert.CommandText += sbPrimaryInsert.ToString();
							cmdPrimaryInsert.CommandText += "end else begin" + ControlChars.CrLf;
							cmdPrimaryInsert.CommandText += sbPrimaryUpdate.ToString();
							cmdPrimaryInsert.CommandText += "end -- if;" + ControlChars.CrLf;
							sb.Append(cmdPrimaryInsert.CommandText);
						}
					}
				}
			}
			return cmdPrimaryInsert;
		}

		private string ReplicationCopyData(Guid gID, string sTABLE_NAME, IDbCommand cmdPrimaryInsert)
		{
			string sDumpSQL = String.Empty;
			foreach ( IDbDataParameter par in cmdPrimaryInsert.Parameters )
			{
				par.Value = DBNull.Value;
			}
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			try
			{
				string sID_FIELD   = GetIdField(sTABLE_NAME);
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					sSQL = "select *             " + ControlChars.CrLf
					     + "  from " + sTABLE_NAME + ControlChars.CrLf
					     + " where " + sID_FIELD + " = @ID" + ControlChars.CrLf;
					if ( sTABLE_NAME.EndsWith("_CSTM") || sTABLE_NAME.EndsWith("_CSTM_ARCHIVE") )
					{
						sSQL = "select *             " + ControlChars.CrLf
						     + "  from " + sTABLE_NAME + ControlChars.CrLf
						     + " where ID_C = @ID    " + ControlChars.CrLf;
					}
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						cmd.CommandTimeout = 0;
						Sql.AddParameter(cmd, "@ID", gID);
						using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
						{
							if ( rdr.Read() )
							{
								for ( int i = 0; i < rdr.FieldCount; i++ )
								{
									string sFieldName = rdr.GetName(i);
									object oValue     = rdr.GetValue(i);
									IDbDataParameter par = Sql.FindParameter(cmdPrimaryInsert, sFieldName);
									if ( par != null )
										Sql.SetParameter(par, oValue);
								}
								sDumpSQL = Sql.ExpandParameters(cmdPrimaryInsert);
							}
						}
					}
				}
			}
			catch(Exception ex)
			{
				string sRawCommand = ControlChars.CrLf + sDumpSQL;
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex) + sRawCommand);
				throw;
			}

			DbProviderFactory dbfReplication = DbReplicationFactories.GetFactory();
			using ( IDbConnection conReplication = dbfReplication.CreateConnection() )
			{
				conReplication.Open();
				using ( IDbTransaction trn = conReplication.BeginTransaction() )
				{
					try
					{
						cmdPrimaryInsert.Connection = conReplication;
						cmdPrimaryInsert.Transaction = trn;
						cmdPrimaryInsert.ExecuteNonQuery();
						trn.Commit();
					}
					catch(Exception ex)
					{
						trn.Rollback();
						string sRawCommand = ControlChars.CrLf + sDumpSQL;
						SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex) + sRawCommand);
						throw;
					}
				}
			}
			return sDumpSQL;
		}

		public void UpdateStats(string sTABLE_NAME)
		{
			int      nLOCAL_COUNT           = 0;
			DateTime dtLOCAL_LAST_MODIFIED  = DateTime.MinValue;
			int      nREMOTE_COUNT          = 0;
			DateTime dtREMOTE_LAST_MODIFIED = DateTime.MinValue;
			int      nPENDING_COUNT         = 0;
			string   sDATE_FIELD            = GetDateField(sTABLE_NAME);
			string   sPRIMARY_TABLE         = sTABLE_NAME;
			if ( sTABLE_NAME.EndsWith("_CSTM") || sTABLE_NAME.EndsWith("_CSTM_ARCHIVE") )
			{
				sPRIMARY_TABLE = sTABLE_NAME.Substring(0, sTABLE_NAME.Length - 5);
			}
			SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "UpdateStats: " + sTABLE_NAME);

			StringBuilder sb = new StringBuilder();
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					string sSQL;
					sSQL = "select count(*)                 as COUNT        " + ControlChars.CrLf
					     + "     , max(" + sDATE_FIELD + ") as DATE_MODIFIED" + ControlChars.CrLf
					     + "  from " + sPRIMARY_TABLE;
					if ( sTABLE_NAME.EndsWith("_CSTM") || sTABLE_NAME.EndsWith("_CSTM_ARCHIVE") )
					{
						sSQL = "select count(*)                 as COUNT        " + ControlChars.CrLf
						     + "     , max(" + sDATE_FIELD + ") as DATE_MODIFIED" + ControlChars.CrLf
							     + "  from            " + sTABLE_NAME    + ControlChars.CrLf
							     + "  left outer join " + sPRIMARY_TABLE + ControlChars.CrLf
							     + "               on ID = ID_C"         + ControlChars.CrLf;
					}
					cmd.CommandText = sSQL;
					try
					{
						using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
						{
							if ( rdr.Read() )
							{
								nLOCAL_COUNT          = Sql.ToInteger (rdr["COUNT"        ]);
								dtLOCAL_LAST_MODIFIED = Sql.ToDateTime(rdr["DATE_MODIFIED"]);
							}
						}
					}
					catch(Exception ex)
					{
						sb.AppendLine("Local " + sTABLE_NAME + ": " + ex.Message);
					}
				}
			}
			DbProviderFactory dbfReplication = DbReplicationFactories.GetFactory();
			if ( !Sql.IsEmptyString(Application["ReplicationConnectionString"]) )
			{
				using ( IDbConnection conReplication = dbfReplication.CreateConnection() )
				{
					conReplication.Open();
					using ( IDbCommand cmd = conReplication.CreateCommand() )
					{
						string sSQL;
						sSQL = "select count(*)                 as COUNT        " + ControlChars.CrLf
						     + "     , max(" + sDATE_FIELD + ") as DATE_MODIFIED" + ControlChars.CrLf
						     + " from " + sPRIMARY_TABLE;
						if ( sTABLE_NAME.EndsWith("_CSTM") || sTABLE_NAME.EndsWith("_CSTM_ARCHIVE") )
						{
							sSQL = "select count(*)                 as COUNT        " + ControlChars.CrLf
							     + "     , max(" + sDATE_FIELD + ") as DATE_MODIFIED" + ControlChars.CrLf
							     + "  from            " + sTABLE_NAME    + ControlChars.CrLf
							     + "  left outer join " + sPRIMARY_TABLE + ControlChars.CrLf
							     + "               on ID = ID_C"         + ControlChars.CrLf;
						}
						cmd.CommandText = sSQL;
						try
						{
							using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
							{
								if ( rdr.Read() )
								{
									nREMOTE_COUNT          = Sql.ToInteger (rdr["COUNT"        ]);
									dtREMOTE_LAST_MODIFIED = Sql.ToDateTime(rdr["DATE_MODIFIED"]);
								}
							}
						}
						catch(Exception ex)
						{
							sb.AppendLine("Remote " + sTABLE_NAME + ": " + ex.Message);
						}
					}
				}
			}

			Guid gID = Guid.Empty;
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				nPENDING_COUNT = nLOCAL_COUNT;
				if ( dtREMOTE_LAST_MODIFIED != DateTime.MinValue )
				{
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						try
						{
							string sSQL;
							sSQL = "select count(*)"          + ControlChars.CrLf
							     + "  from " + sPRIMARY_TABLE + ControlChars.CrLf
							     + " where " + sDATE_FIELD + " > @DATE_MODIFIED";
							if ( sTABLE_NAME.EndsWith("_CSTM") || sTABLE_NAME.EndsWith("_CSTM_ARCHIVE") )
							{
								sSQL = "select count(*)"      + ControlChars.CrLf
								     + " from " + sTABLE_NAME + ControlChars.CrLf
								     + " where ID_C in (select ID"               + ControlChars.CrLf
								     + "                 from " + sPRIMARY_TABLE + ControlChars.CrLf
								     + "                where DATE_MODIFIED > @DATE_MODIFIED"+ ControlChars.CrLf
								     + "               )";
							}
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@DATE_MODIFIED", dtREMOTE_LAST_MODIFIED);
							nPENDING_COUNT = Sql.ToInteger(cmd.ExecuteScalar());
						}
						catch(Exception ex)
						{
							sb.AppendLine("Pending " + sTABLE_NAME + ": " + ex.Message);
						}
					}
				}
			}
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				using ( IDbTransaction trn = con.BeginTransaction() )
				{
					SqlProcs.spREPLICATION_TABLES_Update(ref gID, sTABLE_NAME, nLOCAL_COUNT, dtLOCAL_LAST_MODIFIED, nREMOTE_COUNT, dtREMOTE_LAST_MODIFIED, trn);

					string sSTATUS     = String.Empty;
					string sLAST_ERROR = sb.ToString();
					if ( nLOCAL_COUNT == nREMOTE_COUNT )
					{
						sSTATUS     = "Complete";
						sLAST_ERROR = ControlChars.CrLf;
					}
					SqlProcs.spREPLICATION_TABLES_UpdateStatus(sTABLE_NAME, sSTATUS, nPENDING_COUNT, sLAST_ERROR, trn);
					trn.Commit();
				}
			}
			if ( sb.Length > 0 )
			{
				throw(new Exception(sb.ToString()));
			}
		}

		public void RunReplication(string sTABLE_NAME)
		{
			if ( !lstProcessing.Contains(sTABLE_NAME) )
			{
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "RunReplication: " + sTABLE_NAME);
				try
				{
					bool bExists = false;
					DbProviderFactory dbfReplication = DbReplicationFactories.GetFactory();
					using ( IDbConnection conReplication = dbfReplication.CreateConnection() )
					{
						conReplication.Open();
						using ( IDbCommand cmd = conReplication.CreateCommand() )
						{
							IDbDataParameter paramTABLE_NAME = Sql.AddAnsiParam(cmd, "@TABLE_NAME", sTABLE_NAME  ,  80);
							cmd.CommandText = "select count(*) from INFORMATION_SCHEMA.TABLES where TABLE_NAME = @TABLE_NAME";
							cmd.CommandType = CommandType.Text;
							bExists = Sql.ToBoolean(cmd.ExecuteScalar());
							cmd.Parameters.Clear();

							string sSQL = String.Empty;
							// 02/07/2026 Paul.  The ideal is to disable triggers so that they simply can be re-enabled later vs re-created. 
							if ( bExists && (Sql.IsSQLServer(conReplication) ||  Sql.IsPostgreSQL(conReplication)) )
							{
								cmd.CommandText = "alter table " + sTABLE_NAME + " disable trigger all";
								cmd.ExecuteNonQuery();
							}
							else
							{
								cmd.CommandType = CommandType.StoredProcedure;
								cmd.CommandText = "spSqlDropAllAuditTriggers";
								cmd.ExecuteNonQuery();

								cmd.CommandText = "spSqlDropAllStreamTriggers";
								cmd.ExecuteNonQuery();
							}

							sSQL = "select TABLE_CONSTRAINTS.TABLE_NAME" + ControlChars.CrLf
							     + "     , TABLE_CONSTRAINTS.CONSTRAINT_NAME" + ControlChars.CrLf
							     + "  from      INFORMATION_SCHEMA.TABLE_CONSTRAINTS         TABLE_CONSTRAINTS" + ControlChars.CrLf
							     + " inner join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE   CONSTRAINT_COLUMN_USAGE" + ControlChars.CrLf
							     + "         on CONSTRAINT_COLUMN_USAGE.CONSTRAINT_NAME    = TABLE_CONSTRAINTS.CONSTRAINT_NAME" + ControlChars.CrLf
							     + " inner join INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS   REFERENTIAL_CONSTRAINTS" + ControlChars.CrLf
							     + "         on REFERENTIAL_CONSTRAINTS.CONSTRAINT_NAME    = TABLE_CONSTRAINTS.CONSTRAINT_NAME" + ControlChars.CrLf
							     + " inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS         PRIMARY_KEYS" + ControlChars.CrLf
							     + "         on PRIMARY_KEYS.CONSTRAINT_NAME               = REFERENTIAL_CONSTRAINTS.UNIQUE_CONSTRAINT_NAME" + ControlChars.CrLf
							     + "        and PRIMARY_KEYS.CONSTRAINT_TYPE               = 'PRIMARY KEY'" + ControlChars.CrLf
							     + " inner join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE   PRIMARY_COLUMN_USAGE" + ControlChars.CrLf
							     + "         on PRIMARY_COLUMN_USAGE.CONSTRAINT_NAME       = PRIMARY_KEYS.CONSTRAINT_NAME" + ControlChars.CrLf
							     + " where TABLE_CONSTRAINTS.CONSTRAINT_TYPE = 'FOREIGN KEY'" + ControlChars.CrLf
							     + " order by 1" + ControlChars.CrLf;
							cmd.CommandText = sSQL;
							cmd.Parameters.Clear();
							using ( DataTable dt = new DataTable() )
							{
								using ( DbDataAdapter da = dbfReplication.CreateDataAdapter() )
								{
									((IDbDataAdapter) da).SelectCommand = cmd;
									da.Fill(dt);
								}
								foreach ( DataRow row in dt.Rows )
								{
									cmd.CommandText = "alter table " + Sql.ToString(row["TABLE_NAME"]) + " drop constraint " + Sql.ToString(row["CONSTRAINT_NAME"]);
									cmd.ExecuteNonQuery();
								}
							}
						}
					}
					if ( !bExists )
					{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							using ( IDbTransaction trn = con.BeginTransaction() )
							{
								SqlProcs.spREPLICATION_TABLES_UpdateStatus(sTABLE_NAME, "Failed", 0, "Table does not exist", trn);
								trn.Commit();
							}
						}
						return;
					}

					bool bFailed = false;
					UpdateStats(sTABLE_NAME);

					lstProcessing.Add(sTABLE_NAME);
					string sID_FIELD   = GetIdField  (sTABLE_NAME);
					string sDATE_FIELD = GetDateField(sTABLE_NAME);
					IDbCommand cmdPrimaryInsert = BuildReplicationStatement(sTABLE_NAME);
					using ( DataTable dt = new DataTable() )
					{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							DateTime dtREMOTE_LAST_MODIFIED = DateTime.MinValue;
							int      nPENDING_COUNT         = 0;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								string sSQL;
								sSQL = "select *                       " + ControlChars.CrLf
								     + "  from vwREPLICATION_TABLES    " + ControlChars.CrLf
								     + " where TABLE_NAME = @TABLE_NAME" + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@TABLE_NAME", sTABLE_NAME);
								using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
								{
									if ( rdr.Read() )
									{
										dtREMOTE_LAST_MODIFIED = Sql.ToDateTime(rdr["REMOTE_LAST_MODIFIED"]);
										nPENDING_COUNT         = Sql.ToInteger (rdr["PENDING_COUNT"       ]);
									}
								}
							}
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								string sSQL;
								sSQL = "select " + sID_FIELD      + ControlChars.CrLf
								     + "  from " + sTABLE_NAME    + ControlChars.CrLf
								     + " where @" + sDATE_FIELD   + " is null" + ControlChars.CrLf
								     + "    or  " + sDATE_FIELD   + " > @" + sDATE_FIELD + ControlChars.CrLf
								     + " order by " + sDATE_FIELD + ControlChars.CrLf;
								if ( sTABLE_NAME.EndsWith("_CSTM") || sTABLE_NAME.EndsWith("_CSTM_ARCHIVE") )
								{
									string sPRIMARY_TABLE = sTABLE_NAME.Substring(0, sTABLE_NAME.Length - 5);
									sSQL = "select ID_C"                    + ControlChars.CrLf
									     + "  from       " + sPRIMARY_TABLE + ControlChars.CrLf
									     + "  inner join " + sTABLE_NAME    + ControlChars.CrLf
									     + "          on ID_C = ID"         + ControlChars.CrLf
									     + " where @" + sDATE_FIELD         + " is null" + ControlChars.CrLf
									     + "    or  " + sDATE_FIELD         + " > @" + sDATE_FIELD + ControlChars.CrLf
									     + " order by " + sDATE_FIELD       + ControlChars.CrLf;
								}
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@" + sDATE_FIELD, dtREMOTE_LAST_MODIFIED);
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									da.Fill(dt);
								}
							}
							foreach ( DataRow row in dt.Rows )
							{
								Guid gID = Sql.ToGuid(row[sID_FIELD]);
								try
								{
									ReplicationCopyData(gID, sTABLE_NAME, cmdPrimaryInsert);
									nPENDING_COUNT--;
									using ( IDbTransaction trn = con.BeginTransaction() )
									{
										SqlProcs.spREPLICATION_TABLES_UpdateStatus(sTABLE_NAME, "Processing", nPENDING_COUNT, ControlChars.CrLf, trn);
										trn.Commit();
									}
								}
								catch(Exception ex)
								{
									using ( IDbTransaction trn = con.BeginTransaction() )
									{
										SqlProcs.spREPLICATION_TABLES_UpdateStatus(sTABLE_NAME, "Failed", nPENDING_COUNT, ex.Message + ControlChars.CrLf + "For ID: " + gID.ToString(), trn);
										trn.Commit();
									}
									break;
								}
							}
						}
					}
					if ( !bFailed )
					{
						UpdateStats(sTABLE_NAME);
					}
				}
				catch(Exception ex)
				{
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
					throw;
				}
				finally
				{
					lstProcessing.Remove(sTABLE_NAME);
				}
			}
		}

	}
}

