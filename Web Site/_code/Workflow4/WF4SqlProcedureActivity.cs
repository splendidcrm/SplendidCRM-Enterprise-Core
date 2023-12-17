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
using System.Data;
using System.Data.Common;
using System.Collections.Generic;
using System.Activities;
using System.ComponentModel;
using System.Diagnostics;

namespace SplendidCRM
{
	public class WF4SqlProcedureActivity : CodeActivity
	{
		public InArgument<string>     PROCEDURE_NAME       { get; set; }
		public InArgument<string>     FIELD_PREFIX         { get; set; }

		protected override void Execute(CodeActivityContext context)
		{
			SplendidApplicationService app = context.GetExtension<SplendidApplicationService>();
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			Sql                  Sql             = app.Sql            ;
			SqlProcs             SqlProcs        = app.SqlProcs       ;
			SplendidError        SplendidError   = app.SplendidError  ;

			try
			{
				Guid   gWORKFLOW_ID         = Guid.Empty;
				Guid   gBUSINESS_PROCESS_ID = Guid.Empty;
				Guid   gAUDIT_ID            = Guid.Empty;
				Guid   gPROCESS_USER_ID     = Guid.Empty;
				string sPROCEDURE_NAME      = context.GetValue<string>(PROCEDURE_NAME);
				string sFIELD_PREFIX        = context.GetValue<string>(FIELD_PREFIX  );
			
				WorkflowDataContext dc = context.DataContext;
				Dictionary<string, PropertyDescriptor> dict = new Dictionary<string,PropertyDescriptor>();
				PropertyDescriptorCollection properties = dc.GetProperties();
				foreach ( PropertyDescriptor property in dc.GetProperties() )
				{
					// 11/07/2023 Paul.  WF3 to WF4 will have WORKFLOW_ID instead of BUSINESS_PROCESS_ID. 
					if ( property.Name == "WORKFLOW_ID" )
					{
						gWORKFLOW_ID = Sql.ToGuid(property.GetValue(dc));
					}
					else if ( property.Name == "BUSINESS_PROCESS_ID" )
					{
						gBUSINESS_PROCESS_ID = Sql.ToGuid(property.GetValue(dc));
					}
					else if ( property.Name == "AUDIT_ID" )
					{
						gAUDIT_ID = Sql.ToGuid(property.GetValue(dc));
					}
					else if ( property.Name == "PROCESS_USER_ID" )
					{
						gPROCESS_USER_ID = Sql.ToGuid(property.GetValue(dc));
					}
					// 07/28/2016 Paul.  The prefix for this module will help us ensure that we just reference Sequence variables. 
					// 11/08/2023 Paul.  The prefix is required, otherwise we will be pulling from the data members for the whole record.  We only want sequence variables. 
					else if ( !Sql.IsEmptyString(sFIELD_PREFIX) && property.Name.StartsWith(sFIELD_PREFIX) )
					{
						string sColumnName = property.Name.Replace(sFIELD_PREFIX, String.Empty);
						if ( !dict.ContainsKey(sColumnName) )
							dict.Add(sColumnName, property);
					}
				}
			
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					using ( DataTable dtMetadata = new DataTable() )
					{
						string sSQL = String.Empty;
						string sTABLE_NAME = String.Empty;
						// 08/17/2016 Paul.  First attempt to get the related table name. 
						int nEndSeparator = sPROCEDURE_NAME.LastIndexOf('_');
						if ( nEndSeparator > 0 )
						{
							sTABLE_NAME = sPROCEDURE_NAME.Substring(0, nEndSeparator);
							if ( sTABLE_NAME.StartsWith("sp") || sTABLE_NAME.StartsWith("SP") )
								sTABLE_NAME = sTABLE_NAME.Substring(2);
							sSQL = "select TABLE_NAME              " + ControlChars.CrLf
								 + "  from vwSqlTables             " + ControlChars.CrLf
								 + " where TABLE_NAME = @TABLE_NAME" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@TABLE_NAME", sTABLE_NAME);
								sTABLE_NAME = Sql.ToString(cmd.ExecuteScalar());
							}
						}
						sSQL = "select *                       " + ControlChars.CrLf
						     + "  from vwSqlColumns            " + ControlChars.CrLf
						     + " where ObjectName = @OBJECTNAME" + ControlChars.CrLf
						     + "   and ObjectType = 'P'        " + ControlChars.CrLf
						     + " order by colid                " + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@OBJECTNAME", Sql.MetadataName(cmd, sPROCEDURE_NAME));
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								( (IDbDataAdapter) da ).SelectCommand = cmd;
								da.Fill( dtMetadata );
							}
						}
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandType = CommandType.StoredProcedure;
							cmd.CommandText = sPROCEDURE_NAME;
							foreach ( DataRow rowMetadata in dtMetadata.Rows )
							{
								string sName      = Sql.ToString (rowMetadata["ColumnName"]);
								string sSqlDbType = Sql.ToString (rowMetadata["SqlDbType" ]);
								string sCsPrefix  = Sql.ToString (rowMetadata["CsPrefix"  ]);
								string sCsType    = Sql.ToString (rowMetadata["CsType"    ]);
								int    nLength    = Sql.ToInteger(rowMetadata["length"    ]);
								int    nMaxLength = Sql.ToInteger(rowMetadata["max_length"]);
								bool   bIsOutput  = Sql.ToBoolean(rowMetadata["isoutparam"]);
								string sBareName  = sName.Replace("@", "").ToUpper();
								object value = null;
								if ( dict.ContainsKey(sBareName) )
								{
									PropertyDescriptor property = dict[sBareName];
									value = property.GetValue(dc);
								}
								// 11/10/2023 Paul.  WF3 to WF4 requires AUDIT_ID. 
								else if ( sBareName == "AUDIT_ID" )
									value = gAUDIT_ID;
								else if ( sBareName == "MODIFIED_USER_ID" )
									value = gPROCESS_USER_ID;
								// 08/15/2016 Paul.  We do not know what tables will be updated, so we must pass the instance to the procedure and let it insert the log record. 
								else if ( sBareName == "PROCESS_USER_ID" )
									value = gPROCESS_USER_ID;
								// 11/11/2023 Paul.  WF3 to WF4 will have WORKFLOW_ID instead of BUSINESS_PROCESS_ID. 
								else if ( sBareName == "WORKFLOW_ID" )
									value = gWORKFLOW_ID;
								else if ( sBareName == "BUSINESS_PROCESS_ID" )
									value = gBUSINESS_PROCESS_ID;
								else if ( sBareName == "BUSINESS_PROCESS_INSTANCE_ID" )
									value = context.WorkflowInstanceId;
								IDbDataParameter par = null;
								switch ( sSqlDbType )
								{
									case "SqlDbType.UniqueIdentifier":  par = Sql.AddParameter(cmd, sBareName, Sql.ToGuid     (value));  break;  // Guid
									case "SqlDbType.Bit"             :  par = Sql.AddParameter(cmd, sBareName, Sql.ToBoolean  (value));  break;  // bool
									case "SqlDbType.TinyInt"         :  par = Sql.AddParameter(cmd, sBareName, Sql.ToShort    (value));  break;  // short
									case "SqlDbType.Int"             :  par = Sql.AddParameter(cmd, sBareName, Sql.ToInteger  (value));  break;  // Int32
									case "SqlDbType.BigInt"          :  par = Sql.AddParameter(cmd, sBareName, Sql.ToLong     (value));  break;  // Int64
									case "SqlDbType.Money"           :  par = Sql.AddParameter(cmd, sBareName, Sql.ToDecimal  (value));  break;  // Decimal
									case "SqlDbType.Real"            :  par = Sql.AddParameter(cmd, sBareName, Sql.ToDouble   (value));  break;  // float
									case "SqlDbType.DateTime"        :  par = Sql.AddParameter(cmd, sBareName, Sql.ToDateTime (value));  break;  // DateTime
									case "SqlDbType.Binary"          :  par = Sql.AddParameter(cmd, sBareName, Sql.ToByteArray(value));  break;  // byte[]
									case "SqlDbType.VarBinary"       :  par = Sql.AddParameter(cmd, sBareName, Sql.ToByteArray(value));  break;  // byte[]
									case "SqlDbType.NVarChar"        :  // string
									case "SqlDbType.VarChar"         :  // ansistring
										// 09/15/2009 Paul.  For varchar(max), don't specify a length. 
										// 06/22/2016 Paul.  An varchar(max) output must specify a size when used as output. 
										if ( nMaxLength == -1 && bIsOutput )
											par = Sql.AddParameter(cmd, sBareName, Sql.ToString   (value), 2147483647);
										else if ( nMaxLength == -1 )
											par = Sql.AddParameter(cmd, sBareName, Sql.ToString   (value));
										else
											par = Sql.AddParameter(cmd, sBareName, Sql.ToString   (value), nLength);
										break;
								}
								if ( par != null && bIsOutput )
									par.Direction = ParameterDirection.InputOutput;
							}
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									// 08/15/2016 Paul.  We do not know what tables will be updated, so we must pass the instance to the procedure and let it insert the log record. 
									if ( !Sql.IsEmptyString(sTABLE_NAME) )
									{
										// 11/07/2023 Paul.  WF3 to WF4 will have WORKFLOW_ID instead of BUSINESS_PROCESS_ID. 
										if ( !Sql.IsEmptyGuid(gWORKFLOW_ID) )
											SqlProcs.spWORKFLOW_TRANS_LOG_InsertOnly(sTABLE_NAME, gWORKFLOW_ID, context.WorkflowInstanceId, trn);
										if ( !Sql.IsEmptyGuid(gBUSINESS_PROCESS_ID) )
											SqlProcs.spWORKFLOW_TRANS_LOG_InsertOnly(sTABLE_NAME, gBUSINESS_PROCESS_ID, context.WorkflowInstanceId, trn);
									}
									cmd.Transaction = trn;
									cmd.ExecuteNonQuery();
									trn.Commit();
									foreach ( IDbDataParameter par in cmd.Parameters )
									{
										if ( par.Direction == ParameterDirection.InputOutput )
										{
											string sBareName  = par.ParameterName.Replace("@", "");
											if ( dict.ContainsKey(sBareName) )
											{
												PropertyDescriptor property = dict[sBareName];
												if      ( par.DbType == DbType.Guid     ) property.SetValue(dc, Sql.ToGuid     (par.Value));
												else if ( par.DbType == DbType.Boolean  ) property.SetValue(dc, Sql.ToBoolean  (par.Value));
												else if ( par.DbType == DbType.Int16    ) property.SetValue(dc, Sql.ToShort    (par.Value));
												else if ( par.DbType == DbType.Int32    ) property.SetValue(dc, Sql.ToInteger  (par.Value));
												else if ( par.DbType == DbType.Int64    ) property.SetValue(dc, Sql.ToLong     (par.Value));
												else if ( par.DbType == DbType.Decimal  ) property.SetValue(dc, Sql.ToDecimal  (par.Value));
												else if ( par.DbType == DbType.Double   ) property.SetValue(dc, Sql.ToDouble   (par.Value));
												else if ( par.DbType == DbType.DateTime ) property.SetValue(dc, Sql.ToDateTime (par.Value));
												else if ( par.DbType == DbType.String   ) property.SetValue(dc, Sql.ToString   (par.Value));
												else if ( par.DbType == DbType.Binary   ) property.SetValue(dc, Sql.ToByteArray(par.Value));
											}
										}
									}
								}
								catch(Exception ex)
								{
									trn.Rollback();
									SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
									throw;
								}
							}
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				throw(new Exception("WF4SqlProcedureActivity.Execute failed: " + ex.Message, ex));
			}
		}
	}
}
