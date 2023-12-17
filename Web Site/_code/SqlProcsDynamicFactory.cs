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
using System.Web;
using System.Data;
using System.Data.Common;

namespace SplendidCRM
{
	public partial class SqlProcs
	{
		// 11/26/2021 Paul.  In order to support dynamically created modules in the React client, we need to load the procedures dynamically. 
		public IDbCommand DynamicFactory(IDbConnection con, string sProcedureName)
		{
			// 11/26/2021 Paul.  Store the data table of rows instead of the command so that connection does not stay referenced. 
			DataTable dt = Application["SqlProcs." + sProcedureName] as DataTable;
			if ( dt == null )
			{
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				// 11/26/2021 Paul.  We can't use the same connection as provided as it may already be inside a transaction. 
				using ( IDbConnection con2 = dbf.CreateConnection() )
				{
					con2.Open();
					using ( IDbCommand cmd = con2.CreateCommand() )
					{
						string sSQL;
						sSQL = "select count(*)       " + ControlChars.CrLf
						     + "  from vwSqlProcedures" + ControlChars.CrLf
						     + " where name = @NAME   " + ControlChars.CrLf;
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@NAME", Sql.MetadataName(cmd, Sql.ToString(sProcedureName)));
						int nExists = Sql.ToInteger(cmd.ExecuteScalar());
						if ( nExists == 0 )
						{
							throw(new Exception("Unknown stored procedure " + sProcedureName));
						}
					}
					using ( IDbCommand cmd = con2.CreateCommand() )
					{
						string sSQL;
						sSQL = "select *                       " + ControlChars.CrLf
						     + "  from vwSqlColumns            " + ControlChars.CrLf
						     + " where ObjectName = @OBJECTNAME" + ControlChars.CrLf
						     + "   and ObjectType = 'P'        " + ControlChars.CrLf
						     + " order by colid                " + ControlChars.CrLf;
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@OBJECTNAME", Sql.MetadataName(cmd, Sql.ToString(sProcedureName)));
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							dt = new DataTable();
							da.Fill(dt);
							Application["SqlProcs." + sProcedureName] = dt;
						}
					}
				}
			}
			
			IDbCommand cmdDynamicProcedure = null;
			cmdDynamicProcedure = con.CreateCommand();
			cmdDynamicProcedure.CommandType = CommandType.StoredProcedure;
			cmdDynamicProcedure.CommandText = Sql.MetadataName(con, Sql.ToString(sProcedureName));
			for ( int j = 0 ; j < dt.Rows.Count; j++ )
			{
				DataRow row = dt.Rows[j];
				string sName      = Sql.ToString (row["ColumnName"]);
				string sCsType    = Sql.ToString (row["CsType"    ]);
				int    nLength    = Sql.ToInteger(row["length"    ]);
				bool   bIsOutput  = Sql.ToBoolean(row["isoutparam"]);
				string sBareName  = sName.Replace("@", "");
				IDbDataParameter par = Sql.CreateParameter(cmdDynamicProcedure, sName, sCsType, nLength);
				if ( bIsOutput )
					par.Direction = ParameterDirection.InputOutput;
			}
			return cmdDynamicProcedure;
		}
	}
}

