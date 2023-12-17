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
using System.Text;
using System.Collections.Generic;
using System.Collections.Specialized;
using Spring.Json;

namespace Spring.Social.Watson.Api
{
	[Serializable]
	public class Contact : HBase
	{
		public class MergeField
		{
			public String     NAME    { get; set; }
			public String     VALUE   { get; set; }

			public MergeField(String NAME, String VALUE)
			{
				this.NAME  = NAME ;
				this.VALUE = VALUE;
			}
		}

		public String           LIST_ID                  { get; set; }
		public String           EMAIL                    { get; set; }
		public int?             EmailType                { get; set; }
		public int?             CreatedFrom              { get; set; }
		public DateTime?        OptedInDate              { get; set; }
		public DateTime?        OptedOutDate             { get; set; }
		public DateTime?        ResumeSendDate           { get; set; }
		public String           CRMLeadSource            { get; set; }
		public List<MergeField> MERGE_FIELDS             { get; set; }

		public Contact()
		{
			this.MERGE_FIELDS = new List<MergeField>();
		}

		public void SetMergeField(string NAME, string VALUE)
		{
			if ( this.MERGE_FIELDS == null )
				this.MERGE_FIELDS = new List<Spring.Social.Watson.Api.Contact.MergeField>();
			bool bFound = false;
			foreach ( Spring.Social.Watson.Api.Contact.MergeField field in this.MERGE_FIELDS )
			{
				if ( field.NAME == NAME )
				{
					field.VALUE = VALUE;
					bFound = true;
				}
			}
			if ( !bFound )
			{
				Spring.Social.Watson.Api.Contact.MergeField field = new MergeField(NAME, VALUE);
				this.MERGE_FIELDS.Add(field);
			}
		}

		public string GetMergeField(string NAME)
		{
			string VALUE = String.Empty;
			if ( this.MERGE_FIELDS != null )
			{
				foreach ( Spring.Social.Watson.Api.Contact.MergeField field in this.MERGE_FIELDS )
				{
					if ( field.NAME == NAME )
					{
						VALUE = field.VALUE;
						break;
					}
				}
			}
			return VALUE;
		}

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("ID"             , Type.GetType("System.String"  ));
			dt.Columns.Add("LIST_ID"        , Type.GetType("System.String"  ));
			dt.Columns.Add("RECIPIENT_ID"   , Type.GetType("System.String"  ));
			dt.Columns.Add("LAST_MODIFIED"  , Type.GetType("System.DateTime"));
			dt.Columns.Add("CRM_LEAD_SOURCE", Type.GetType("System.String"  ));
			dt.Columns.Add("OPTED_IN_DATE"  , Type.GetType("System.DateTime"));
			dt.Columns.Add("OPTED_OUT_DATE" , Type.GetType("System.DateTime"));
			return dt;
		}

		public void SetRow(DataRow row, Dictionary<string, string> dictMergeTags)
		{
			foreach ( Spring.Social.Watson.Api.Contact.MergeField field in this.MERGE_FIELDS )
			{
				string sNAME = field.NAME;
				if ( dictMergeTags.ContainsKey(sNAME) )
				{
					sNAME = dictMergeTags[field.NAME];
				}
				if ( !row.Table.Columns.Contains(sNAME) )
				{
					row.Table.Columns.Add(sNAME, Type.GetType("System.String"));
				}
			}
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.ID            != null   ) row["ID"             ] = Sql.ToDBString  (this.ID           );
			if ( this.LIST_ID       != null   ) row["LIST_ID"        ] = Sql.ToDBString  (this.LIST_ID      );
			if ( this.ID            != null   ) row["RECIPIENT_ID"   ] = Sql.ToDBString  (this.ID           );
			if ( this.LAST_MODIFIED .HasValue ) row["LAST_MODIFIED"  ] = Sql.ToDBDateTime(this.LAST_MODIFIED);
			if ( this.CRMLeadSource != null   ) row["CRM_LEAD_SOURCE"] = Sql.ToDBString  (this.CRMLeadSource);
			if ( this.OptedInDate   .HasValue ) row["OPTED_IN_DATE"  ] = Sql.ToDBDateTime(this.OptedInDate  );
			if ( this.OptedOutDate  .HasValue ) row["OPTED_OUT_DATE" ] = Sql.ToDBDateTime(this.OptedOutDate );
			foreach ( Spring.Social.Watson.Api.Contact.MergeField field in this.MERGE_FIELDS )
			{
				string sNAME = field.NAME;
				if ( dictMergeTags.ContainsKey(sNAME) )
				{
					sNAME = dictMergeTags[field.NAME];
				}
				if ( field.VALUE != null )
				{
					row[sNAME] = Sql.ToDBString(field.VALUE);
				}
			}
		}

		public static Dictionary<string, string> CreateMergeDictionary(string sMERGE_FIELDS)
		{
			Dictionary<string, string> dictMergeTags = new Dictionary<string,string>();
			string[] arrMERGE_FIELDS = sMERGE_FIELDS.Replace(" ", String.Empty).Split(',');
			for ( int i = 0; i < arrMERGE_FIELDS.Length; i++ )
			{
				string[] arrFieldTag = arrMERGE_FIELDS[i].Split(':');
				string sFIELD = arrFieldTag[0];
				string sTAG   = arrFieldTag[0];
				if ( arrFieldTag.Length > 1 )
					sTAG = arrFieldTag[1];
				if ( !dictMergeTags.ContainsKey(sTAG) )
				{
					dictMergeTags.Add(sTAG, sFIELD);
				}
			}
			return dictMergeTags;
		}

		public static DataRow ConvertToRow(Contact obj, string sMERGE_FIELDS)
		{
			DataTable dt = Contact.CreateTable();
			DataRow row = dt.NewRow();
			Dictionary<string, string> dictMergeTags = CreateMergeDictionary(sMERGE_FIELDS);
			obj.SetRow(row, dictMergeTags);
			return row;
		}

		public static DataTable ConvertToTable(IList<Contact> contacts, string sMERGE_FIELDS)
		{
			DataTable dt = Contact.CreateTable();
			if ( contacts != null )
			{
				Dictionary<string, string> dictMergeTags = CreateMergeDictionary(sMERGE_FIELDS);
				foreach ( Contact contact in contacts )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					contact.SetRow(row, dictMergeTags);
				}
			}
			return dt;
		}
	}

	[Serializable]
	public class ContactInsert
	{
		public String           RawContent    { get; set; }
		public String           ID            { get; set; }
	}
}
