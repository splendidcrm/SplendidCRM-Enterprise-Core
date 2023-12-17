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

namespace Spring.Social.SalesFusion.Api
{
	// https://pub.salesfusion360.com/api/users/
	[Serializable]
	public class User : HBase
	{
		#region Properties
		public int?       user_id                       { get { return id; }  set { id = value; } }
		public String     user                          { get; set; }
		public int?       status                        { get; set; }
		public String     user_name                     { get; set; }  // 50
		public String     portal_password               { get; set; }  // 20
		public String     salutation                    { get; set; }  // 50
		public String     first_name                    { get; set; }  // 50
		public String     last_name                     { get; set; }  // 50
		public String     job_title                     { get; set; }  // 100
		public String     email                         { get; set; }  // 100
		public String     phone                         { get; set; }  // 50
		public String     phone_extension               { get; set; }  // 10
		public String     mobile                        { get; set; }  // 20
		public String     address1                      { get; set; }  // 50
		public String     address2                      { get; set; }  // 50
		public String     city                          { get; set; }  // 50
		public String     state                         { get; set; }  // 100
		public String     zip                           { get; set; }  // 16
		public String     country                       { get; set; }  // 50
		public String     face_book                     { get; set; }  // 100
		public String     linked_in                     { get; set; }  // 200
		public String     company_website               { get; set; }  // 150
		public String     twitter                       { get; set; }  // 200
		public String     profile_picture               { get; set; }  // 200
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                           , Type.GetType("System.Int32"   ));
			dt.Columns.Add("crm_id"                       , Type.GetType("System.String"  ));

			dt.Columns.Add("user_id"                      , Type.GetType("System.Int32"   ));
			dt.Columns.Add("user"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("status"                       , Type.GetType("System.Int32"   ));
			dt.Columns.Add("user_name"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("portal_password"              , Type.GetType("System.String"  ));
			dt.Columns.Add("salutation"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("first_name"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("last_name"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("job_title"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("email"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("phone"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("phone_extension"              , Type.GetType("System.String"  ));
			dt.Columns.Add("mobile"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("address1"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("address2"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("city"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("state"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("zip"                          , Type.GetType("System.String"  ));
			dt.Columns.Add("country"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("face_book"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("linked_in"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("company_website"              , Type.GetType("System.String"  ));
			dt.Columns.Add("twitter"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("profile_picture"              , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id                           .HasValue ) row["id"                           ] = Sql.ToDBInteger (this.id                           .Value);
			if ( this.crm_id                       != null   ) row["crm_id"                       ] = Sql.ToDBString  (this.crm_id                             );

			if ( this.user_id                      .HasValue ) row["user_id"                      ] = Sql.ToDBInteger (this.user_id                      .Value);
			if ( this.user                         != null   ) row["user"                         ] = Sql.ToDBString  (this.user                               );
			if ( this.status                       .HasValue ) row["status"                       ] = Sql.ToDBInteger (this.status                       .Value);
			if ( this.user_name                    != null   ) row["user_name"                    ] = Sql.ToDBString  (this.user_name                          );
			if ( this.portal_password              != null   ) row["portal_password"              ] = Sql.ToDBString  (this.portal_password                    );
			if ( this.salutation                   != null   ) row["salutation"                   ] = Sql.ToDBString  (this.salutation                         );
			if ( this.first_name                   != null   ) row["first_name"                   ] = Sql.ToDBString  (this.first_name                         );
			if ( this.last_name                    != null   ) row["last_name"                    ] = Sql.ToDBString  (this.last_name                          );
			if ( this.job_title                    != null   ) row["job_title"                    ] = Sql.ToDBString  (this.job_title                          );
			if ( this.email                        != null   ) row["email"                        ] = Sql.ToDBString  (this.email                              );
			if ( this.phone                        != null   ) row["phone"                        ] = Sql.ToDBString  (this.phone                              );
			if ( this.phone_extension              != null   ) row["phone_extension"              ] = Sql.ToDBString  (this.phone_extension                    );
			if ( this.mobile                       != null   ) row["mobile"                       ] = Sql.ToDBString  (this.mobile                             );
			if ( this.address1                     != null   ) row["address1"                     ] = Sql.ToDBString  (this.address1                           );
			if ( this.address2                     != null   ) row["address2"                     ] = Sql.ToDBString  (this.address2                           );
			if ( this.city                         != null   ) row["city"                         ] = Sql.ToDBString  (this.city                               );
			if ( this.state                        != null   ) row["state"                        ] = Sql.ToDBString  (this.state                              );
			if ( this.zip                          != null   ) row["zip"                          ] = Sql.ToDBString  (this.zip                                );
			if ( this.country                      != null   ) row["country"                      ] = Sql.ToDBString  (this.country                            );
			if ( this.face_book                    != null   ) row["face_book"                    ] = Sql.ToDBString  (this.face_book                          );
			if ( this.linked_in                    != null   ) row["linked_in"                    ] = Sql.ToDBString  (this.linked_in                          );
			if ( this.company_website              != null   ) row["company_website"              ] = Sql.ToDBString  (this.company_website                    );
			if ( this.twitter                      != null   ) row["twitter"                      ] = Sql.ToDBString  (this.twitter                            );
			if ( this.profile_picture              != null   ) row["profile_picture"              ] = Sql.ToDBString  (this.profile_picture                    );
		}

		public static DataRow ConvertToRow(User obj)
		{
			DataTable dt = User.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<User> users)
		{
			DataTable dt = User.CreateTable();
			if ( users != null )
			{
				foreach ( User user in users )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					user.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class UserPagination : HPagination
	{
		public IList<User>    results     { get; set; }
	}
}
