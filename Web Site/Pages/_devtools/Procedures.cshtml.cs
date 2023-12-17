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
using System.Data;
using System.Text;
using System.Collections;
using System.Data.SqlClient;
using System.Diagnostics;

using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Pages._devtools
{
	[Authorize]
	[SplendidSessionAuthorize]
	public class ProceduresModel : PageModel
	{
		private IWebHostEnvironment  hostingEnvironment ;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private Security             Security           ;
		private SplendidError        SplendidError      ;

		public string sSqlProcs { get; set; }

		public ProceduresModel(IWebHostEnvironment hostingEnvironment, Security Security, SplendidError SplendidError)
		{
			this.hostingEnvironment  = hostingEnvironment ;
			this.Security            = Security           ;
			this.SplendidError       = SplendidError      ;
		}

		private string TabSpace(int nNumber)
		{
			return Strings.Space(nNumber).Replace(' ', '\t');
		}

		// 03/06/2010 Paul.  Make the BuildWrapper function public and static so that it can be reused in the ModuleBuilder. 
		public void BuildWrapper(ref StringBuilder sb, string sProcedureName, ref DataRowCollection colRows, bool bCreateCommand, bool bTransaction)
		{
			// 10/07/2009 Paul.  We need to prevent the use of the system transaction function as a stand-alone call.  It makes no sense. 
			if ( String.Compare(sProcedureName, "spSYSTEM_TRANSACTIONS_Create", true) == 0 && !bCreateCommand && !bTransaction )
				return;
			
			int nColumnAlignmentSize = 5;
			int nSpace=0;
			string sPrimaryKey     = String.Empty;
			bool   bPrimaryDefault = false;
			if ( colRows.Count > 0 )
			{
				sPrimaryKey     = Sql.ToString (colRows[0]["ColumnName"]);
				bPrimaryDefault = Sql.ToBoolean(colRows[0]["cdefault"  ]);
			}
			for ( int j = 0 ; j < colRows.Count; j++ )
			{
				DataRow row = colRows[j];
				string sName = Sql.ToString(row["ColumnName"]);
				if ( sName.Length >= nColumnAlignmentSize )
					nColumnAlignmentSize = sName.Length + 1;
			}
			int k = 0;
			int nIndent = 2;
			if ( bCreateCommand )
			{
				sb.AppendLine(TabSpace(nIndent) + "#region cmd" + (sProcedureName.StartsWith("sp") ? sProcedureName.Substring(2) : sProcedureName));
				sb.AppendLine(TabSpace(nIndent) + "/// <summary>");
				sb.AppendLine(TabSpace(nIndent) + "/// " + sProcedureName);
				sb.AppendLine(TabSpace(nIndent) + "/// </summary>");
				sb.Append(TabSpace(nIndent) + "public IDbCommand cmd" + (sProcedureName.StartsWith("sp") ? sProcedureName.Substring(2) : sProcedureName) + "(");
				sb.Append("IDbConnection con");
				k++;
			}
			else
			{
				sb.AppendLine(TabSpace(nIndent) + "#region " + sProcedureName);
				sb.AppendLine(TabSpace(nIndent) + "/// <summary>");
				sb.AppendLine(TabSpace(nIndent) + "/// " + sProcedureName);
				sb.AppendLine(TabSpace(nIndent) + "/// </summary>");
				sb.Append(TabSpace(nIndent) + "public void " + sProcedureName + "(");
				for ( int j = 0; j < colRows.Count; j++ )
				{
					DataRow row = colRows[j];
					string sName     = Sql.ToString (row["ColumnName"]);
					string sCsType   = Sql.ToString (row["CsType"    ]);
					string sCsPrefix = Sql.ToString (row["CsPrefix"  ]);
					bool   bIsOutput = Sql.ToBoolean(row["isoutparam"]);
					string sBareName = sName.Replace("@", "");
					// 06/23/2005 Paul.  Modified User ID is automatic. 
					if ( sBareName == "MODIFIED_USER_ID" )
						continue;
					if ( k > 0 )
						sb.Append(", ");
					if ( bIsOutput )
						sb.Append("ref ");
					// 01/24/2006 Paul.  A severe error occurred on the current command. The results, if any, should be discarded. 
					// MS03-031 security patch causes this error because of stricter datatype processing.  
					// http://www.microsoft.com/technet/security/bulletin/MS03-031.mspx.
					// http://support.microsoft.com/kb/827366/
					sCsType = (sCsType == "ansistring") ? "string" : sCsType;
					sb.Append(sCsType + " " + sCsPrefix + sBareName);
					k++;
				}
				if ( bTransaction )
				{
					if ( colRows.Count > 1 )
						sb.Append(", ");
					else if ( colRows.Count == 1 )
					{
						// 11/19/2006 Paul.  Skip first parameter if MODIFIED_USER_ID. 
						if ( Sql.ToString (colRows[0]["ColumnName"]) != "@MODIFIED_USER_ID" )
							sb.Append(", ");
					}
					sb.Append("IDbTransaction trn");
				}
			}
			sb.AppendLine(")");
			sb.AppendLine(TabSpace(nIndent) + "{");
			nIndent++;
			if ( !bCreateCommand )
			{
				if ( bTransaction )
				{
					sb.AppendLine(TabSpace(nIndent) + "IDbConnection con = trn.Connection;");
				}
				else
				{
					sb.AppendLine(TabSpace(nIndent) + "DbProviderFactory dbf = DbProviderFactories.GetFactory();");
					sb.AppendLine(TabSpace(nIndent) + "using ( IDbConnection con = dbf.CreateConnection() )");
					sb.AppendLine(TabSpace(nIndent) + "{");
					nIndent++;
				}
				// 05/01/2006 Paul.  All commands now use a transaction.  This is because Oracle does not have a transaction hierarchy. 
				// So any COMMIT in a procedure, will commit the entire transaction.
				// We want the web application to be in control of the transaction.
				if ( !bTransaction )
				{
					sb.AppendLine(TabSpace(nIndent) + "con.Open();");
					// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
					// This is because SQL Server 2005 and 2008 are the only platforms that support a global transaction ID with sp_getbindtoken. 
					sb.AppendLine(TabSpace(nIndent) + "using ( IDbTransaction trn = Sql.BeginTransaction(con) )");
					sb.AppendLine(TabSpace(nIndent) + "{");
					nIndent++;
					sb.AppendLine(TabSpace(nIndent) + "try");
					sb.AppendLine(TabSpace(nIndent) + "{");
					nIndent++;
				}
				sb.AppendLine(TabSpace(nIndent) + "using ( IDbCommand cmd = con.CreateCommand() )");
				sb.AppendLine(TabSpace(nIndent) + "{");
				nIndent++;
				// 05/01/2006 Paul.  All commands now use a transaction. 
				sb.AppendLine(TabSpace(nIndent) + "cmd.Transaction = trn;");
				sb.AppendLine(TabSpace(nIndent) + "cmd.CommandType = CommandType.StoredProcedure;");
				// 08/14/2005 Paul.  Truncate procedure names on a case-by-case basis. 
				// Oracle only supports identifiers up to 30 characters. 
				if ( sProcedureName.Length > 30 )
				{
					sb.AppendLine(TabSpace(nIndent) + "if ( Sql.IsOracle(cmd) )");
					sb.AppendLine(TabSpace(nIndent) + "	cmd.CommandText = \"" + sProcedureName.Substring(0, 30) + "\";");
					sb.AppendLine(TabSpace(nIndent) + "else");
					sb.AppendLine(TabSpace(nIndent) + "	cmd.CommandText = \"" + sProcedureName + "\";");
				}
				else
				{
					sb.AppendLine(TabSpace(nIndent) + "cmd.CommandText = \"" + sProcedureName + "\";");
				}
			}
			else
			{
				sb.AppendLine(TabSpace(nIndent) + "IDbCommand cmd = con.CreateCommand();");
				sb.AppendLine(TabSpace(nIndent) + "cmd.CommandType = CommandType.StoredProcedure;");
				// 08/14/2005 Paul.  Truncate procedure names on a case-by-case basis. 
				// Oracle only supports identifiers up to 30 characters. 
				if ( sProcedureName.Length > 30 )
				{
					sb.AppendLine(TabSpace(nIndent) + "if ( Sql.IsOracle(cmd) )");
					sb.AppendLine(TabSpace(nIndent) + "	cmd.CommandText = \"" + sProcedureName.Substring(0, 30) + "\";");
					sb.AppendLine(TabSpace(nIndent) + "else");
					sb.AppendLine(TabSpace(nIndent) + "	cmd.CommandText = \"" + sProcedureName + "\";");
				}
				else
				{
					sb.AppendLine(TabSpace(nIndent) + "cmd.CommandText = \"" + sProcedureName + "\";");
				}
			}
			for ( int j = 0 ; j < colRows.Count; j++ )
			{
				DataRow row = colRows[j];
				string sName      = Sql.ToString (row["ColumnName"]);
				string sSqlDbType = Sql.ToString (row["SqlDbType" ]);
				string sCsPrefix  = Sql.ToString (row["CsPrefix"  ]);
				string sCsType    = Sql.ToString (row["CsType"    ]);
				int    nLength    = Sql.ToInteger(row["length"    ]);
				int    nMaxLength = Sql.ToInteger(row["max_length"]);
				bool   bIsOutput  = Sql.ToBoolean(row["isoutparam"]);
				string sBareName  = sName.Replace("@", "");
				nSpace = nColumnAlignmentSize - sBareName.Length;
				nSpace = Math.Max(2, nSpace);
				int nSpaceSqlType = 26 - sSqlDbType.Length;
				nSpaceSqlType = Math.Max(0, nSpaceSqlType);
				/*
				switch ( sSqlDbType )
				{
					case "SqlDbType.VarBinary":
						sb.AppendLine(TabSpace(nIndent) + "IDbDataParameter par" + sBareName + Strings.Space(nSpace-1) + "= Sql.AddParameter(cmd, \"" + sName + "\"" + Strings.Space(nSpace-2) + ", " + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ");");
						break;
					default:
						sb.AppendLine(TabSpace(nIndent) + "IDbDataParameter par" + sBareName + Strings.Space(nSpace-1) + "= Sql.AddParameter(cmd, \"" + sName + "\"" + Strings.Space(nSpace-2) + ", " + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ");");
						break;
				}
				*/
				int nSpaceCsPrefix = 3 + nColumnAlignmentSize - sBareName.Length - sCsPrefix.Length;
				nSpaceCsPrefix = Math.Max(2, nSpaceCsPrefix);
				if ( !bCreateCommand )
				{
					// 01/24/2006 Paul.  A severe error occurred on the current command. The results, if any, should be discarded. 
					// MS03-031 security patch causes this error because of stricter datatype processing.  
					// http://www.microsoft.com/technet/security/bulletin/MS03-031.mspx.
					// http://support.microsoft.com/kb/827366/
					if ( sBareName == "MODIFIED_USER_ID" )
						sb.AppendLine(TabSpace(nIndent) + "IDbDataParameter par" + sBareName + Strings.Space(nSpace-1) + "= Sql.AddParameter(cmd, \"" + sName + "\"" + Strings.Space(nSpace-2) + ", " + " Security.USER_ID" + Strings.Space(nSpaceCsPrefix-2) + ");");
					else if ( sSqlDbType == "SqlDbType.NVarChar" )
					{
						// 09/15/2009 Paul.  For nvarchar(max), don't specify a length. 
						// 06/22/2016 Paul.  An nvarchar(max) output must specify a size when used as output. 
						if ( nMaxLength == -1 && bIsOutput )
							sb.AppendLine(TabSpace(nIndent) + "IDbDataParameter par" + sBareName + Strings.Space(nSpace-1) + "= Sql.AddParameter(cmd, \"" + sName + "\"" + Strings.Space(nSpace-2) + ", " + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ", 2147483647);");
						else if ( nMaxLength == -1 )
							sb.AppendLine(TabSpace(nIndent) + "IDbDataParameter par" + sBareName + Strings.Space(nSpace-1) + "= Sql.AddParameter(cmd, \"" + sName + "\"" + Strings.Space(nSpace-2) + ", " + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ");");
						else
							sb.AppendLine(TabSpace(nIndent) + "IDbDataParameter par" + sBareName + Strings.Space(nSpace-1) + "= Sql.AddParameter(cmd, \"" + sName + "\"" + Strings.Space(nSpace-2) + ", " + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + "," + Strings.Space(Math.Max(1, 4-nLength.ToString().Length)) + nLength.ToString() +");");
					}
					else if ( sSqlDbType == "SqlDbType.VarChar" )
					{
						// 09/15/2009 Paul.  For varchar(max), don't specify a length. 
						// 06/22/2016 Paul.  An varchar(max) output must specify a size when used as output. 
						if ( nMaxLength == -1 && bIsOutput )
							sb.AppendLine(TabSpace(nIndent) + "IDbDataParameter par" + sBareName + Strings.Space(nSpace-1) + "= Sql.AddAnsiParam(cmd, \"" + sName + "\"" + Strings.Space(nSpace-2) + ", " + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ", 2147483647);");
						else if ( nMaxLength == -1 )
							sb.AppendLine(TabSpace(nIndent) + "IDbDataParameter par" + sBareName + Strings.Space(nSpace-1) + "= Sql.AddAnsiParam(cmd, \"" + sName + "\"" + Strings.Space(nSpace-2) + ", " + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ");");
						else
							sb.AppendLine(TabSpace(nIndent) + "IDbDataParameter par" + sBareName + Strings.Space(nSpace-1) + "= Sql.AddAnsiParam(cmd, \"" + sName + "\"" + Strings.Space(nSpace-2) + ", " + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + "," + Strings.Space(Math.Max(1, 4-nLength.ToString().Length)) + nLength.ToString() +");");
					}
					else
						sb.AppendLine(TabSpace(nIndent) + "IDbDataParameter par" + sBareName + Strings.Space(nSpace-1) + "= Sql.AddParameter(cmd, \"" + sName + "\"" + Strings.Space(nSpace-2) + ", " + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ");");
				}
				else
				{
					sb.AppendLine(TabSpace(nIndent) + "IDbDataParameter par" + sBareName + Strings.Space(nSpace-1) + "= Sql.CreateParameter(cmd, \"" + sName + "\"" + Strings.Space(nSpace-2) + ", \"" + sCsType + "\"," + Strings.Space(Math.Max(1, 4-nLength.ToString().Length)) + nLength.ToString() +");");
				}
			}
			if ( !bCreateCommand )
			{
				for ( int j = 0 ; j < colRows.Count; j++ )
				{
					DataRow row = colRows[j];
					string sName      = Sql.ToString (row["ColumnName"]);
					string sBareName  = sName.Replace("@", "");
					string sCsPrefix  = Sql.ToString (row["CsPrefix"  ]);
					string sCsType    = Sql.ToString (row["CsType"    ]);
					bool   bIsOutput  = Sql.ToBoolean(row["isoutparam"]);
					nSpace   = nColumnAlignmentSize - sBareName.Length;
					nSpace   = Math.Max(2, nSpace);
					int nSpaceCsPrefix = 3 + nColumnAlignmentSize - sBareName.Length - sCsPrefix.Length;
					nSpaceCsPrefix = Math.Max(2, nSpaceCsPrefix);
					if ( bIsOutput )
						sb.AppendLine(TabSpace(nIndent) + "par" + sBareName + ".Direction = ParameterDirection.InputOutput;");
					/*
					switch ( sCsType )
					{
						case "string":
							sb.AppendLine(TabSpace(nIndent) + "par" + sBareName + Strings.Space(nSpace-2) + ".Value     = Sql.ToDBString  (" + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ");");
							break;
						case "DateTime":
							sb.AppendLine(TabSpace(nIndent) + "par" + sBareName + Strings.Space(nSpace-2) + ".Value     = Sql.ToDBDateTime(" + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ");");
							break;
						case "Guid":
							if ( sBareName == "MODIFIED_USER_ID" )
								sb.AppendLine(TabSpace(nIndent) + "par" + sBareName + Strings.Space(nSpace-2) + ".Value     = Security.USER_ID;");
							else
								sb.AppendLine(TabSpace(nIndent) + "par" + sBareName + Strings.Space(nSpace-2) + ".Value     = Sql.ToDBGuid    (" + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ");");
							break;
						case "Int32":
						case "short":
							sb.AppendLine(TabSpace(nIndent) + "par" + sBareName + Strings.Space(nSpace-2) + ".Value     = Sql.ToDBInteger (" + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ");");
							break;
						case "float":
							sb.AppendLine(TabSpace(nIndent) + "par" + sBareName + Strings.Space(nSpace-2) + ".Value     = Sql.ToDBFloat   (" + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ");");
							break;
						case "decimal":
							sb.AppendLine(TabSpace(nIndent) + "par" + sBareName + Strings.Space(nSpace-2) + ".Value     = Sql.ToDBDecimal (" + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ");");
							break;
						case "bool":
							sb.AppendLine(TabSpace(nIndent) + "par" + sBareName + Strings.Space(nSpace-2) + ".Value     = Sql.ToDBBoolean (" + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ");");
							break;
						case "byte[]":
							sb.AppendLine(TabSpace(nIndent) + "par" + sBareName + Strings.Space(nSpace-2) + ".Value     = Sql.ToDBBinary  (" + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ");");
							break;
						default:
							sb.AppendLine(TabSpace(nIndent) + "par" + sBareName + Strings.Space(nSpace-2) + ".Value     = " + sCsPrefix + sBareName + Strings.Space(nSpaceCsPrefix-2) + ";");
							break;
					}
					*/
				}
				// 03/07/2010 Paul.  Move the Trace function to the Sql class. 
				// 02/10/2012 Paul.  WORKFLOW and SYSTEM procedures are plentyful and not useful in the trace. 
				// 10/29/2023 Paul.  We need to see the workflow trace dump. 
				if ( bTransaction && /* !sProcedureName.StartsWith("spWORKFLOW_") && !sProcedureName.StartsWith("spWWF_") && */ !sProcedureName.StartsWith("spSCHEDULERS_") && !sProcedureName.StartsWith("spSYSTEM_") && sProcedureName != "spWORKFLOWS_UpdateLastRun" )
					sb.AppendLine(TabSpace(nIndent) + "Sql.Trace(cmd);");
				sb.AppendLine(TabSpace(nIndent) + "cmd.ExecuteNonQuery();");
				for ( int j = 0 ; j < colRows.Count; j++ )
				{
					DataRow row = colRows[j];
					string sName      = Sql.ToString (row["ColumnName"]);
					string sBareName  = sName.Replace("@", "");
					string sCsType    = Sql.ToString (row["CsType"    ]);
					string sCsPrefix  = Sql.ToString (row["CsPrefix"  ]);
					bool   bIsOutput  = Sql.ToBoolean(row["isoutparam"]);
					if ( bIsOutput )
					{
						nSpace   = nColumnAlignmentSize - sBareName.Length;
						nSpace   = Math.Max(2, nSpace);
						int nSpaceCsPrefix = 3 + nColumnAlignmentSize - sBareName.Length - sCsPrefix.Length;
						nSpaceCsPrefix = Math.Max(2, nSpaceCsPrefix);
						// 04/25/2008 Paul.  ansistring needs to be treated like a string. 
						sCsType = (sCsType == "ansistring") ? "string" : sCsType;
						switch ( sCsType )
						{
							case "string":
								sb.AppendLine(TabSpace(nIndent) + sCsPrefix + sBareName + " = Sql.ToString(par" + sBareName + ".Value);");
								break;
							case "DateTime":
								sb.AppendLine(TabSpace(nIndent) + sCsPrefix + sBareName + " = Sql.ToDateTime(par" + sBareName + ".Value);");
								break;
							case "Guid":
								sb.AppendLine(TabSpace(nIndent) + sCsPrefix + sBareName + " = Sql.ToGuid(par" + sBareName + ".Value);");
								break;
							case "Int32":
							case "short":
								sb.AppendLine(TabSpace(nIndent) + sCsPrefix + sBareName + " = Sql.ToInteger(par" + sBareName + ".Value);");
								break;
							case "float":
								sb.AppendLine(TabSpace(nIndent) + sCsPrefix + sBareName + " = Sql.ToFloat(par" + sBareName + ".Value);");
								break;
							case "decimal":
								sb.AppendLine(TabSpace(nIndent) + sCsPrefix + sBareName + " = Sql.ToDecimal(par" + sBareName + ".Value);");
								break;
							case "bool":
								sb.AppendLine(TabSpace(nIndent) + sCsPrefix + sBareName + " = Sql.ToBoolean(par" + sBareName + ".Value);");
								break;
							case "byte[]":
								sb.AppendLine(TabSpace(nIndent) + sCsPrefix + sBareName + " = Sql.ToBinary(par" + sBareName + ".Value);");
								break;
							default:
								sb.AppendLine(TabSpace(nIndent) + sCsPrefix + sBareName + " = par" + sBareName + ".Value" + ";");
								break;
						}
					}
				}
			}
			else
			{
				// 02/20/2006 Paul.  Need to set the direction. 
				for ( int j = 0 ; j < colRows.Count; j++ )
				{
					DataRow row = colRows[j];
					string sName      = Sql.ToString (row["ColumnName"]);
					string sBareName  = sName.Replace("@", "");
					bool   bIsOutput  = Sql.ToBoolean(row["isoutparam"]);
					if ( bIsOutput )
						sb.AppendLine(TabSpace(nIndent) + "par" + sBareName + ".Direction = ParameterDirection.InputOutput;");
				}
			}

			if ( !bCreateCommand )
			{
				if ( !bTransaction )
				{
					nIndent--;
					sb.AppendLine(TabSpace(nIndent) + "}");

					sb.AppendLine(TabSpace(nIndent) + "trn.Commit();");
					nIndent--;
					sb.AppendLine(TabSpace(nIndent) + "}");
					sb.AppendLine(TabSpace(nIndent) + "catch");
					sb.AppendLine(TabSpace(nIndent) + "{");
					nIndent++;
					sb.AppendLine(TabSpace(nIndent) + "trn.Rollback();");
					// 12/25/2008 Paul.  Re-throw the original exception so as to retain the call stack. 
					// The difference between these two variations is subtle but important. With the first example, the higher level
					// caller isn�t going to get all the information about the original error. The call stack in the exception is replaced
					// with a new call stack that originates at the �throw ex� statement � which is not what we want to record. The
					// second example is the only one that actually re-throws the original exception, preserving the stack trace where
					// the original error occurred.
					//sb.AppendLine(TabSpace(nIndent) + "throw(new Exception(ex.Message, ex.InnerException));");
					sb.AppendLine(TabSpace(nIndent) + "throw;");
					nIndent--;
					sb.AppendLine(TabSpace(nIndent) + "}");
					nIndent--;
					sb.AppendLine(TabSpace(nIndent) + "}");
				}
				nIndent--;
				sb.AppendLine(TabSpace(nIndent) + "}");
			}
			else
			{
				sb.AppendLine(TabSpace(nIndent) + "return cmd;");
			}
			nIndent--;
			sb.AppendLine(TabSpace(nIndent) + "}");
			sb.AppendLine(TabSpace(nIndent) + "#endregion");
			sb.AppendLine();
		}

		public void OnGet()
		{
			// 01/11/2006 Paul.  Only a developer/administrator should see this. 
			if ( !Security.IS_ADMIN || Request.Host.Host != "localhost" )
				return;
			StringBuilder sb = new StringBuilder();
			sb.AppendLine("/**");
			sb.AppendLine(" * Copyright (C) 2005-" + DateTime.Now.Year.ToString() + " SplendidCRM Software, Inc. All Rights Reserved. ");
			sb.AppendLine(" *");
			sb.AppendLine(" * Any use of the contents of this file are subject to the SplendidCRM " + Sql.ToString(Application["CONFIG.service_level"]) + " Source Code License ");
			sb.AppendLine(" * Agreement, or other written agreement between you and SplendidCRM (\"License\"). By installing or ");
			sb.AppendLine(" * using this file, you have unconditionally agreed to the terms and conditions of the License, ");
			sb.AppendLine(" * including but not limited to restrictions on the number of users therein, and you may not use this ");
			sb.AppendLine(" * file except in compliance with the License. ");
			sb.AppendLine(" * ");
			sb.AppendLine(" * SplendidCRM owns all proprietary rights, including all copyrights, patents, trade secrets, and ");
			sb.AppendLine(" * trademarks, in and to the contents of this file.  You will not link to or in any way combine the ");
			sb.AppendLine(" * contents of this file or any derivatives with any Open Source Code in any manner that would require ");
			sb.AppendLine(" * the contents of this file to be made available to any third party. ");
			sb.AppendLine(" * ");
			sb.AppendLine(" * IN NO EVENT SHALL SPLENDIDCRM BE RESPONSIBLE FOR ANY DAMAGES OF ANY KIND, INCLUDING ANY DIRECT, ");
			sb.AppendLine(" * SPECIAL, PUNITIVE, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES.  Other limitations of liability ");
			sb.AppendLine(" * and disclaimers set forth in the License. ");
			sb.AppendLine(" * ");
			sb.AppendLine(" */");
			sb.AppendLine("");
			
			sb.AppendLine("using System;");
			sb.AppendLine("using System.Data;");
			sb.AppendLine("using System.Data.Common;");
			sb.AppendLine("//using Microsoft.VisualBasic;");
			sb.AppendLine("using System.Xml;");
			sb.AppendLine();
			
			// 04/13/2006 Paul.  Use existing connection to generate procedures. 
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( SqlConnection con = dbf.CreateConnection() as SqlConnection )
			{
				string sSQL;
				con.Open();
				sb.AppendLine("namespace SplendidCRM");
				sb.AppendLine("{");
				sb.AppendLine("	/// <summary>");
				sb.AppendLine("	/// SqlProcs generated from database [" + con.Database + "] on " + DateTime.Now.ToString() + ".");
				sb.AppendLine("	/// </summary>");
				sb.AppendLine("	public partial class SqlProcs");
				sb.AppendLine("	{");
				sb.AppendLine("		private DbProviderFactories  DbProviderFactories = new DbProviderFactories();");
				sb.AppendLine("		private HttpApplicationState Application = new HttpApplicationState();");
				sb.AppendLine("		private Security             Security           ;");
				sb.AppendLine("		private Sql                  Sql                ;");
				sb.AppendLine("");
				sb.AppendLine("		public SqlProcs(Security Security, Sql Sql)");
				sb.AppendLine("		{");
				sb.AppendLine("			this.Security            = Security           ;");
				sb.AppendLine("			this.Sql                 = Sql                ;");
				sb.AppendLine("		}");

				sb.AppendLine();

				sb.AppendLine("		private static void Trace(IDbCommand cmd)");
				sb.AppendLine("		{");
				// 09/16/2015 Paul.  Change to Debug as it is automatically not included in a release build. 
				sb.AppendLine("			System.Diagnostics.Debug.WriteLine(\"SqlProcs.Trace:	exec dbo.\" + Sql.ExpandParameters(cmd) + \";\");");
				sb.AppendLine("		}");
				sb.AppendLine();
				ArrayList arrProcedures = new ArrayList();
				// Get a list of all tables that will need simple INSERT/UPDATE/DELETE procedures. 
				sSQL = "select name           " + ControlChars.CrLf
				     + "  from vwSqlProcedures" + ControlChars.CrLf
				     + " order by name        " + ControlChars.CrLf;
				using ( SqlCommand cmd = new SqlCommand(sSQL, con) )
				{
					using ( SqlDataAdapter da = new SqlDataAdapter(cmd) )
					{
						using ( DataTable dt = new DataTable() )
						{
							da.Fill(dt);
							for ( int i = 0 ; i < dt.Rows.Count ; i++ )
							{
								DataRow row = dt.Rows[i];
								arrProcedures.Add(Sql.ToString(row["name"]));
							}
						}
					}
				}
				// Iterate through each table, get all rows, and build INSERT/UPDATE/DELETE procedure
				for ( int i = 0 ; i < arrProcedures.Count ; i++ )
				{
					// 02/29/2008 Niall.  Some SQL Server 2005 installations require matching case for the parameters. 
					// Since we force the parameter to be uppercase, we must also make it uppercase in the command text. 
					sSQL = "select *                       " + ControlChars.CrLf
					     + "  from vwSqlColumns            " + ControlChars.CrLf
					     + " where ObjectName = @OBJECTNAME" + ControlChars.CrLf
					     + "   and ObjectType = 'P'        " + ControlChars.CrLf
					     + " order by colid                " + ControlChars.CrLf;
					using ( SqlCommand cmd = new SqlCommand(sSQL, con) )
					{
						// 09/02/2008 Paul.  Standardize the case of metadata tables to uppercase.  PostgreSQL defaults to lowercase. 
						Sql.AddParameter(cmd, "@OBJECTNAME", Sql.MetadataName(cmd, Sql.ToString(arrProcedures[i])));
						using ( SqlDataAdapter da = new SqlDataAdapter(cmd) )
						{
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								DataRowCollection colRows = dt.Rows;
								BuildWrapper(ref sb, Sql.ToString(arrProcedures[i]), ref colRows, false, false);
								BuildWrapper(ref sb, Sql.ToString(arrProcedures[i]), ref colRows, false, true );
								BuildWrapper(ref sb, Sql.ToString(arrProcedures[i]), ref colRows, true , false);
							}
						}
					}
				}
				int nMaxProcedureLength = 0;
				for ( int i = 0 ; i < arrProcedures.Count ; i++ )
				{
					string sName = Sql.ToString(arrProcedures[i]);
					if ( sName.Length > nMaxProcedureLength )
						nMaxProcedureLength = sName.Length;
				}
				sb.AppendLine("		#region Factory");
				sb.AppendLine("		/// <summary>");
				sb.AppendLine("		/// Factory");
				sb.AppendLine("		/// </summary>");
				sb.AppendLine("		public IDbCommand Factory(IDbConnection con, string sProcedureName)");
				sb.AppendLine("		{");
				sb.AppendLine("			IDbCommand cmd = null;");
				sb.AppendLine("			switch ( sProcedureName.ToUpper() )");
				sb.AppendLine("			{");
				for ( int i = 0 ; i < arrProcedures.Count ; i++ )
				{
					string sName = Sql.ToString(arrProcedures[i]);
					sb.AppendLine("				case \"" + sName.ToUpper() + "\"" + Strings.Space(nMaxProcedureLength - sName.Length) + ":  cmd = cmd" + (sName.StartsWith("sp") ? sName.Substring(2) : sName) + Strings.Space(nMaxProcedureLength - sName.Length) + "(con);  break;");
				}
				sb.AppendLine("				// 11/26/2021 Paul.  In order to support dynamically created modules in the React client, we need to load the procedures dynamically. ");
				sb.AppendLine("				default:  cmd = this.DynamicFactory(con, sProcedureName);  break;");
				sb.AppendLine("			}");
				sb.AppendLine("			// 11/11/2008 Paul.  PostgreSQL has issues treating integers as booleans and booleans as integers. ");
				sb.AppendLine("			if ( Sql.IsPostgreSQL(cmd) )");
				sb.AppendLine("			{");
				sb.AppendLine("				foreach ( IDbDataParameter par in cmd.Parameters )");
				sb.AppendLine("				{");
				sb.AppendLine("					if ( par.DbType == DbType.Boolean )");
				sb.AppendLine("						par.DbType = DbType.Int32;");
				sb.AppendLine("				}");
				sb.AppendLine("			}");
				sb.AppendLine("			return cmd;");
				sb.AppendLine("		}");
				sb.AppendLine("		#endregion");
				sb.AppendLine();
			}
			sb.AppendLine("	}");
			sb.AppendLine("}");
			sSqlProcs = sb.ToString();
			
			try
			{
				// 01/16/2008 Paul.  Procedures.aspx was moved to the _devtools folder, 
				// so we need to make sure to reference SqlProcs in the _code folder. 
				string sSqlProcsPath = "~/_code/SqlProcs.cs".Replace("~", hostingEnvironment.ContentRootPath);
				if ( Path.DirectorySeparatorChar == '\\' )
					sSqlProcsPath = sSqlProcsPath.Replace("/", "\\");
				using(StreamWriter stm = System.IO.File.CreateText(sSqlProcsPath))
				{
					stm.Write(sb.ToString());
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
			}
		}
	}
}
