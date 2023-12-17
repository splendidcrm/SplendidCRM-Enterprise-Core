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
	public class Subscription : Entity
	{
		#region Properties
		public String              ApplicationId             { get; set; }
		public String              ChangeType                { get; set; }
		public String              ClientState               { get; set; }
		public String              CreatorId                 { get; set; }
		public String              EncryptionCertificate     { get; set; }
		public String              EncryptionCertificateId   { get; set; }
		public DateTimeOffset?     ExpirationDateTime        { get; set; }
		public bool?               IncludeResourceData       { get; set; }
		public String              LatestSupportedTlsVersion { get; set; }
		public String              LifecycleNotificationUrl  { get; set; }
		public String              NotificationUrl           { get; set; }
		// https://docs.microsoft.com/en-us/graph/api/subscription-post-subscriptions?view=graph-rest-1.0&tabs=http
		public String              Resource                  { get; set; }  // me/contacts, me/events, me/mailfolders('inbox')/messages
		#endregion

		public override string ToString()
		{
			StringBuilder sb = new StringBuilder();
			sb.AppendLine("Subscription");
			sb.AppendLine("   subscriptionId: " + this.Id            );
			sb.AppendLine("   changeType    : " + this.ChangeType    );
			sb.AppendLine("   clientState   : " + this.ClientState   );
			sb.AppendLine("   resource      : " + this.Resource      );
			return sb.ToString();
		}

		public Subscription()
		{
			this.ODataType = "microsoft.graph.subscription";
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

		public static DataRow ConvertToRow(Subscription obj)
		{
			DataTable dt = Subscription.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Subscription> subscriptions)
		{
			DataTable dt = Subscription.CreateTable();
			if ( subscriptions != null )
			{
				foreach ( Subscription subscription in subscriptions )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					subscription.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class SubscriptionPagination
	{
		public IList<Subscription>  subscriptions  { get; set; }
		public int                      count          { get; set; }
	}
}
