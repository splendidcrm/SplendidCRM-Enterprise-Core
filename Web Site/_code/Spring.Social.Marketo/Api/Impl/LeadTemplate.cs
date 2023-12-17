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
using System.Net;
using System.Text;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Diagnostics;

using Spring.Json;
using Spring.Http;
using Spring.Rest.Client;

namespace Spring.Social.Marketo.Api.Impl
{
	class LeadTemplate : ILeadOperations
	{
		protected RestTemplate restTemplate;
		protected int          maxResults  ;

		public LeadTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
			this.maxResults   = 1000        ;
		}

		private static string Space(int nCount)
		{
			return new string(' ', nCount);
		}

		public virtual IList<LeadField> GetFields()
		{
			// http://developers.marketo.com/documentation/rest/describe/
			string sURL = "v1/leads/describe.json";
			IList<LeadField> all = this.restTemplate.GetForObject<IList<LeadField>>(sURL);
#if DEBUG
			StringBuilder sbFields     = new StringBuilder();
			StringBuilder sbColumns    = new StringBuilder();
			StringBuilder sbSetRow     = new StringBuilder();
			StringBuilder sbTerms      = new StringBuilder();
			StringBuilder sbDetailView = new StringBuilder();
			sbFields    .AppendLine();
			sbColumns   .AppendLine();
			sbSetRow    .AppendLine();
			sbTerms     .AppendLine();
			sbDetailView.AppendLine();
			int nMaxFieldLength = 20;
			foreach ( LeadField fld in all )
			{
				nMaxFieldLength = Math.Max(nMaxFieldLength, fld.restName.Length);
			}
			foreach ( LeadField fld in all )
			{
				if ( fld.restReadOnly.HasValue && !fld.restReadOnly.Value && fld.restName != "id" )
				{
					switch ( fld.dataType )
					{
						case "text"     :  sbFields.AppendLine("		public String    "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						case "string"   :  sbFields.AppendLine("		public String    "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }  // " + (fld.length.HasValue ? fld.length.Value.ToString() : String.Empty));  break;
						case "phone"    :  sbFields.AppendLine("		public String    "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }  // " + (fld.length.HasValue ? fld.length.Value.ToString() : String.Empty));  break;
						case "email"    :  sbFields.AppendLine("		public String    "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }  // " + (fld.length.HasValue ? fld.length.Value.ToString() : String.Empty));  break;
						case "url"      :  sbFields.AppendLine("		public String    "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }  // " + (fld.length.HasValue ? fld.length.Value.ToString() : String.Empty));  break;
						case "boolean"  :  sbFields.AppendLine("		public bool?     "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						case "integer"  :  sbFields.AppendLine("		public int?      "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						case "float"    :  sbFields.AppendLine("		public float?    "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						case "date"     :  sbFields.AppendLine("		public DateTime? "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						case "datetime" :  sbFields.AppendLine("		public DateTime? "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						case "currency" :  sbFields.AppendLine("		public Decimal?  "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						case "reference":  sbFields.AppendLine("		public int?      "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						default         :  sbFields.AppendLine("		public [" + fld.dataType + "] " + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }  // " + (fld.length.HasValue ? fld.length.Value.ToString() : String.Empty));  break;
					}
					switch ( fld.dataType )
					{
						case "text"     :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.String\"  ));");  break;
						case "string"   :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.String\"  ));");  break;
						case "phone"    :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.String\"  ));");  break;
						case "email"    :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.String\"  ));");  break;
						case "url"      :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.String\"  ));");  break;
						case "boolean"  :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.Boolean\" ));");  break;
						case "integer"  :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.Int64\"   ));");  break;
						case "float"    :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.Double\"  ));");  break;
						case "date"     :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.DateTime\"));");  break;
						case "datetime" :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.DateTime\"));");  break;
						case "currency" :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.Decimal\" ));");  break;
						case "reference":  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.Int64\"   ));");  break;
					}
					switch ( fld.dataType )
					{
						case "text"     :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " != null   ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBString  (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "      );");  break;
						case "string"   :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " != null   ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBString  (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "      );");  break;
						case "phone"    :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " != null   ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBString  (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "      );");  break;
						case "email"    :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " != null   ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBString  (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "      );");  break;
						case "url"      :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " != null   ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBString  (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "      );");  break;
						case "boolean"  :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " .HasValue ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBBoolean (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + ".Value);");  break;
						case "integer"  :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " .HasValue ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBInteger (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + ".Value);");  break;
						case "float"    :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " .HasValue ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBFloat   (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + ".Value);");  break;
						case "date"     :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " .HasValue ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBDateTime(this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + ".Value);");  break;
						case "datetime" :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " .HasValue ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBDateTime(this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + ".Value);");  break;
						case "currency" :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " .HasValue ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBDecimal (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + ".Value);");  break;
						case "reference":  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " .HasValue ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBInteger (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + ".Value);");  break;
					}
				}
			}
			sbFields .AppendLine("		// Read-only fields");
			sbColumns.AppendLine("		// Read-only fields");
			sbSetRow .AppendLine("		// Read-only fields");
			foreach ( LeadField fld in all )
			{
				if ( fld.restReadOnly.HasValue && fld.restReadOnly.Value && fld.restName != "createdAt" && fld.restName != "updatedAt" )
				{
					switch ( fld.dataType )
					{
						case "text"     :  sbFields.AppendLine("		public String    "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						case "string"   :  sbFields.AppendLine("		public String    "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }  // " + (fld.length.HasValue ? fld.length.Value.ToString() : String.Empty));  break;
						case "phone"    :  sbFields.AppendLine("		public String    "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }  // " + (fld.length.HasValue ? fld.length.Value.ToString() : String.Empty));  break;
						case "email"    :  sbFields.AppendLine("		public String    "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }  // " + (fld.length.HasValue ? fld.length.Value.ToString() : String.Empty));  break;
						case "url"      :  sbFields.AppendLine("		public String    "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }  // " + (fld.length.HasValue ? fld.length.Value.ToString() : String.Empty));  break;
						case "boolean"  :  sbFields.AppendLine("		public bool?     "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						case "integer"  :  sbFields.AppendLine("		public int?      "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						case "float"    :  sbFields.AppendLine("		public float?    "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						case "date"     :  sbFields.AppendLine("		public DateTime? "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						case "datetime" :  sbFields.AppendLine("		public DateTime? "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						case "currency" :  sbFields.AppendLine("		public Decimal?  "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						case "reference":  sbFields.AppendLine("		public int?      "              + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }");  break;
						default         :  sbFields.AppendLine("		public [" + fld.dataType + "] " + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "  { get; set; }  // " + (fld.length.HasValue ? fld.length.Value.ToString() : String.Empty));  break;
					}
					switch ( fld.dataType )
					{
						case "text"     :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.String\"  ));");  break;
						case "string"   :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.String\"  ));");  break;
						case "phone"    :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.String\"  ));");  break;
						case "email"    :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.String\"  ));");  break;
						case "url"      :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.String\"  ));");  break;
						case "boolean"  :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.Boolean\" ));");  break;
						case "integer"  :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.Int64\"   ));");  break;
						// 05/02/2023 Paul.  There is no System.float.  Use System.Single or System.Double. 
						case "float"    :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.Single\"  ));");  break;
						case "date"     :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.DateTime\"));");  break;
						case "datetime" :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.DateTime\"));");  break;
						case "currency" :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.Decimal\" ));");  break;
						case "reference":  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"System.Int64\"   ));");  break;
						default         :  sbColumns.AppendLine("			dt.Columns.Add(\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + ", Type.GetType(\"" + fld.dataType + "\"));");  break;
					}
					switch ( fld.dataType )
					{
						case "text"     :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " != null   ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBString  (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "      );");  break;
						case "string"   :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " != null   ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBString  (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "      );");  break;
						case "phone"    :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " != null   ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBString  (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "      );");  break;
						case "email"    :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " != null   ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBString  (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "      );");  break;
						case "url"      :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " != null   ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBString  (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + "      );");  break;
						case "boolean"  :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " .HasValue ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBBoolean (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + ".Value);");  break;
						case "integer"  :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " .HasValue ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBInteger (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + ".Value);");  break;
						case "float"    :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " .HasValue ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBFloat   (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + ".Value);");  break;
						case "date"     :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " .HasValue ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBDateTime(this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + ".Value);");  break;
						case "datetime" :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " .HasValue ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBDateTime(this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + ".Value);");  break;
						case "currency" :  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " .HasValue ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBDecimal (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + ".Value);");  break;
						case "reference":  sbSetRow.AppendLine("			if ( this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + " .HasValue ) row[\"" + fld.restName + "\"" + Space(nMaxFieldLength - fld.restName.Length) + "] = Sql.ToDBInteger (this." + fld.restName + Space(nMaxFieldLength - fld.restName.Length) + ".Value);");  break;
					}
				}
			}
			int i = 0;
			foreach ( LeadField fld in all )
			{
				sbTerms     .AppendLine("exec dbo.spTERMINOLOGY_InsertOnly N\'LBL_" + fld.restName.ToUpper() + "\'" + Space(nMaxFieldLength - fld.restName.Length) + "               , N\'en-US\', N\'Marketo\', null, null, N\'" + fld.displayName + ":\';");
				sbDetailView.AppendLine("exec dbo.spDETAILVIEWS_FIELDS_InsBound      \'Leads.DetailView.Marketo\',  " + (i < 10 ? " " : "") + i.ToString() + ", \'Marketo.LBL_" + fld.restName.ToUpper() + "\'" + Space(nMaxFieldLength - fld.restName.Length) + ", \'" + fld.restName + "\'" + Space(nMaxFieldLength - fld.restName.Length) + ", \'{0}\', null;");
				i++;
			}
			Debug.Write(sbFields    .ToString());
			Debug.Write(sbColumns   .ToString());
			Debug.Write(sbSetRow    .ToString());
			Debug.Write(sbTerms     .ToString());
			Debug.Write(sbDetailView.ToString());
#endif
			return all;
		}

		// 05/21/2015 Paul.  Marketo time is always GMT-5:00 (no daylight savings). 
		// https://nation.marketo.com/thread/24083
		private DateTime? ConvertMarketoToLocalTime(DateTime? value)
		{
			DateTime? dt = null;
			if ( value.HasValue )
			{
				// updatedAt: "2015-05-19 19:38:28"
				// PST correct value: 2015-05-19 17:38
				// EST correct value: 2015-05-19 20:38
				dt = DateTime.SpecifyKind(value.Value, DateTimeKind.Utc).AddHours(5);
				dt = dt.Value.ToLocalTime();
			}
			return dt;
		}

		private DateTime ConvertLocalToMarketoTime(DateTime dt)
		{
			if ( dt != DateTime.MinValue )
			{
				dt = dt.ToUniversalTime().AddHours(-5);
			}
			return dt;
		}

		public virtual IList<MBase> GetModified(DateTime startModifiedDate)
		{
			startModifiedDate = ConvertLocalToMarketoTime(startModifiedDate);
			/*
			// http://developers.marketo.com/documentation/rest/get-paging-token/
			if ( startModifiedDate == DateTime.MinValue )
				startModifiedDate = new DateTime(1970, 1, 1);
			string sURL = "v1/activities/pagingtoken.json?sinceDatetime=" + startModifiedDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss");
			LeadPagination pag = this.restTemplate.GetForObject<LeadPagination>(sURL);
			
			// http://developers.marketo.com/documentation/rest/get-lead-changes
			sURL = "v1/activities/leadchanges.json?batchSize=300&fields=id,updatedAt,createdAt,email";
			string sPagedURL = sURL + "&nextPageToken=" + pag.nextPageToken;
			pag = this.restTemplate.GetForObject<LeadPagination>(sPagedURL);
			
			List<MBase> all = new List<MBase>(pag.items);
			while ( pag.moreResult.HasValue && pag.moreResult.Value )
			{
				sPagedURL = sURL + "&nextPageToken=" + pag.nextPageToken;
				pag = this.restTemplate.GetForObject<LeadPagination>(sPagedURL);
				foreach ( Lead lead in pag.items )
				{
					//if ( startModifiedDate == DateTime.MinValue || lead.updatedAt > startModifiedDate )
						all.Add(lead);
				}
			}
			*/
			// 05/19/2015 Paul.  This is very inefficient, but there does not seem to be a way to get 
			// http://developers.marketo.com/documentation/rest/get-multiple-leads-by-filter-type/
			string sURL = "v1/leads.json";
			sURL += "?batchSize=300&fields=id,createdAt,updatedAt&filterType=id&filterValues=";
			int i = 1;
			StringBuilder sbFilterValues = new StringBuilder();
			for ( int j = 0; j < 300; j++ )
			{
				if ( sbFilterValues.Length > 0 )
					sbFilterValues.Append(",");
				sbFilterValues.Append(i.ToString());
				i++;
			}
			string sPagedURL = sURL + sbFilterValues.ToString();
			IList<Lead> pag = this.restTemplate.GetForObject<IList<Lead>>(sURL + sbFilterValues.ToString());
			IList<MBase> all = new List<MBase>();
			foreach ( Lead lead in pag )
			{
				if ( startModifiedDate == DateTime.MinValue || lead.updatedAt > startModifiedDate )
					all.Add(lead);
			}
			while ( pag.Count > 0 )
			{
				sbFilterValues = new StringBuilder();
				for ( int j = 0; j < 300; j++ )
				{
					if ( sbFilterValues.Length > 0 )
						sbFilterValues.Append(",");
					sbFilterValues.Append(i.ToString());
					i++;
				}
				sPagedURL = sURL + sbFilterValues.ToString();
				pag = this.restTemplate.GetForObject<IList<Lead>>(sPagedURL);
				foreach ( Lead lead in pag )
				{
					if ( startModifiedDate == DateTime.MinValue || lead.updatedAt > startModifiedDate )
						all.Add(lead);
				}
			}
			return all;
		}

		public virtual IList<Lead> GetAll()
		{
			// http://developers.marketo.com/documentation/rest/get-multiple-leads-by-filter-type/
			string sURL = "v1/leads.json";
			// http://developers.marketo.com/blog/get-all-leads-from-the-marketo-rest-api/
			// 05/15/2015 Paul.  The documentation says that 300 is the maximum. 
			sURL += "?batchSize=300&filterType=id&filterValues=";
			int i = 1;
			StringBuilder sbFilterValues = new StringBuilder();
			for ( int j = 0; j < 300; j++ )
			{
				if ( sbFilterValues.Length > 0 )
					sbFilterValues.Append(",");
				sbFilterValues.Append(i.ToString());
				i++;
			}
			string sPagedURL = sURL + sbFilterValues.ToString();
			IList<Lead> pag = this.restTemplate.GetForObject<IList<Lead>>(sURL + sbFilterValues.ToString());
			List<Lead> all = new List<Lead>(pag);
			// 05/18/2015 Paul.  Get Multiple Leads by Filter Type will error if resutls > 1000, so we must manually paginate. 
			while ( pag.Count > 0 )
			{
				sbFilterValues = new StringBuilder();
				for ( int j = 0; j < 300; j++ )
				{
					if ( sbFilterValues.Length > 0 )
						sbFilterValues.Append(",");
					sbFilterValues.Append(i.ToString());
					i++;
				}
				sPagedURL = sURL + sbFilterValues.ToString();
				pag = this.restTemplate.GetForObject<IList<Lead>>(sPagedURL);
				foreach ( Lead lead in pag )
				{
					all.Add(lead);
				}
			}
			return all;
		}

		public Lead GetById(int id, string fields)
		{
			if ( Sql.IsEmptyString(fields) )
				fields = "id,createdAt,updatedAt";
			string sURL = "v1/lead/" + id.ToString() + ".json?fields=" + fields;
			IList<Lead> lead = this.restTemplate.GetForObject<IList<Lead>>(sURL);
			if ( lead.Count > 0 )
				return lead[0];
			return null;
		}

		public int Insert(Lead obj)
		{
			string sURL = "v1/leads.json";
			IList<Lead> lead = this.restTemplate.PostForObject<IList<Lead>>(sURL, obj);
			return lead[0].id.Value;
		}

		public int Update(Lead obj)
		{
			if ( !obj.id.HasValue )
				throw(new Exception("id must not be null during update operation."));
			string sURL = "v1/leads.json";
			IList<Lead> lead = this.restTemplate.PostForObject<IList<Lead>>(sURL, obj);
			return lead[0].id.Value;
		}

		public void Delete(int id)
		{
			// http://developers.marketo.com/documentation/rest/delete-lead/
			string sURL = "v1/leads.json?_method=DELETE&id=" + id.ToString();
			this.restTemplate.Delete(sURL);
		}
	}
}