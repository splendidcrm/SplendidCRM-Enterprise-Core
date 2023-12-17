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

namespace Spring.Social.Office365.Api
{
	[Serializable]
	public class Contact : OutlookItem
	{
		#region Properties
		public String              AssistantName    { get; set; }
		public DateTimeOffset?     Birthday         { get; set; }
		public PhysicalAddress     BusinessAddress  { get; set; }
		public String              BusinessHomePage { get; set; }
		public IList<String>       BusinessPhones   { get; set; }
		public IList<String>       Children         { get; set; }
		public String              CompanyName      { get; set; }
		public String              Department       { get; set; }
		public String              DisplayName      { get; set; }
		public IList<EmailAddress> EmailAddresses   { get; set; }
		public String              FileAs           { get; set; }
		public String              Generation       { get; set; }
		public String              GivenName        { get; set; }
		public PhysicalAddress     HomeAddress      { get; set; }
		public IList<String>       HomePhones       { get; set; }
		public IList<String>       ImAddresses      { get; set; }
		public String              Initials         { get; set; }
		public String              JobTitle         { get; set; }
		public String              Manager          { get; set; }
		public String              MiddleName       { get; set; }
		public String              MobilePhone      { get; set; }
		public String              NickName         { get; set; }
		public String              OfficeLocation   { get; set; }
		public PhysicalAddress     OtherAddress     { get; set; }
		public String              ParentFolderId   { get; set; }
		public String              PersonalNotes    { get; set; }
		public String              Profession       { get; set; }
		public String              SpouseName       { get; set; }
		public String              Surname          { get; set; }
		public String              Title            { get; set; }
		public String              YomiCompanyName  { get; set; }
		public String              YomiGivenName    { get; set; }
		public String              YomiSurname      { get; set; }
		public ProfilePhoto        Photo            { get; set; }
		//public IContactExtensionsCollectionPage Extensions { get; set; }
		//public IContactMultiValueExtendedPropertiesCollectionPage MultiValueExtendedProperties { get; set; }
		//public IContactSingleValueExtendedPropertiesCollectionPage SingleValueExtendedProperties { get; set; }
		#endregion

		public Contact()
		{
			this.ODataType = "microsoft.graph.contact";
		}

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                      , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			row["id"  ] = this.Id;
		}

		public static DataRow ConvertToRow(Contact obj)
		{
			DataTable dt = Contact.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Contact> contacts)
		{
			DataTable dt = Contact.CreateTable();
			if ( contacts != null )
			{
				foreach ( Contact contact in contacts )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					contact.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class ContactPagination
	{
		public IList<Contact> contacts       { get; set; }
		public int            count          { get; set; }
		public String         nextLink       { get; set; }
		public String         deltaLink      { get; set; }
	}
}
