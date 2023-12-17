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
using System.Collections.Generic;
using System.Activities;
using System.ComponentModel;
using System.Diagnostics;

namespace SplendidCRM
{
	public class WF4LoadModuleActivity : CodeActivity
	{
		public InArgument<string>     MODULE_NAME  { get; set; }
		public InArgument<string>     OPERATION    { get; set; }
		public InArgument<string>     FIELD_PREFIX { get; set; }
		public InArgument<Guid  >     ID           { get; set; }
		public InArgument<string>     FIELD_LIST   { get; set; }

		protected override void Execute(CodeActivityContext context)
		{
			SplendidApplicationService app = context.GetExtension<SplendidApplicationService>();
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			SplendidError        SplendidError   = app.SplendidError  ;
			try
			{
				string sMODULE_NAME  = context.GetValue<string>(MODULE_NAME );
				string sOPERATION    = context.GetValue<string>(OPERATION   );
				string sFIELD_PREFIX = context.GetValue<string>(FIELD_PREFIX);
				Guid   gID           = context.GetValue<Guid  >(ID          );
				string sFIELD_LIST   = context.GetValue<string>(FIELD_LIST  );
				List<string> lstFIELD_LIST = new List<string>();
				if ( !Sql.IsEmptyString(sFIELD_LIST) )
				{
					sFIELD_LIST = sFIELD_LIST.ToUpper();
					lstFIELD_LIST = new List<string>(sFIELD_LIST.Split(','));
				}
			
				WorkflowDataContext dc = context.DataContext;
				PropertyDescriptorCollection properties = dc.GetProperties();
				//Dictionary<string, PropertyDescriptor> properties = new Dictionary<string, PropertyDescriptor>();
				//foreach ( PropertyDescriptor property in dc.GetProperties() )
				//{
				//	properties.Add(property.Name, property);
				//}

				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL = String.Empty;
					string sTABLE_NAME = Sql.ToString(app.Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select *                 " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME   + ControlChars.CrLf
					     + " where ID       = @ID    " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@ID", gID);
						using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
						{
							if ( rdr.Read() )
							{
								for ( int i = 0; i < rdr.FieldCount; i++ )
								{
									string sFieldName = rdr.GetName(i);
									try
									{
										PropertyDescriptor property = properties[sFIELD_PREFIX + sFieldName];
										if ( property != null )
										{
											// 09/03/2016 Paul.  An empty field list means to load all fields. 
											if ( lstFIELD_LIST.Count == 0 || lstFIELD_LIST.Contains(sFieldName.ToUpper()) )
											{
												if ( rdr.IsDBNull(i) )
												{
													Type type = property.PropertyType;
													if      ( type == typeof(System.String  ) ) property.SetValue(dc, String.Empty     );
													else if ( type == typeof(System.Guid    ) ) property.SetValue(dc, Guid.Empty       );
													else if ( type == typeof(System.DateTime) ) property.SetValue(dc, DateTime.MinValue);
													else if ( type == typeof(System.Decimal ) ) property.SetValue(dc, Decimal.Zero     );
													else if ( type == typeof(System.Boolean ) ) property.SetValue(dc, false            );
													else if ( type == typeof(System.Int16   ) ) property.SetValue(dc, 0                );
													else if ( type == typeof(System.Int32   ) ) property.SetValue(dc, 0                );
													else if ( type == typeof(System.Int64   ) ) property.SetValue(dc, 0                );
													else if ( type == typeof(System.Single  ) ) property.SetValue(dc, 0.0f             );
													else if ( type == typeof(System.Double  ) ) property.SetValue(dc, 0.0d             );
													else if ( type == typeof(byte[]         ) ) property.SetValue(dc, new byte[0]{}    );
												}
												else
												{
													object oValue = rdr.GetValue(i);
													property.SetValue(dc, oValue);
												}
											}
										}
									}
									catch(Exception ex)
									{
										Debug.WriteLine(sFieldName + ": " + ex.Message);
									}
								}
							}
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				throw(new Exception("WF4LoadModuleActivity.Execute failed: " + ex.Message, ex));
			}
		}
	}

}
