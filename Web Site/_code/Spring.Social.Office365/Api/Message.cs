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
	public class Message : OutlookItem
	{
		#region Properties
		public IList<Recipient>              BccRecipients               { get; set; }
		public ItemBody                      Body                        { get; set; }
		public String                        BodyPreview                 { get; set; }
		public IList<Recipient>              CcRecipients                { get; set; }
		public String                        ConversationId              { get; set; }
		public String                        ConversationIndex           { get; set; } // base64
		public FollowupFlag                  Flag                        { get; set; }
		public Recipient                     From                        { get; set; }
		public bool?                         HasAttachments              { get; set; }
		public String                        Importance                  { get; set; }
		public String                        InferenceClassification     { get; set; }
		public IList<InternetMessageHeader>  InternetMessageHeaders      { get; set; }
		public String                        InternetMessageId           { get; set; }
		public bool?                         IsDeliveryReceiptRequested  { get; set; }
		public bool?                         IsDraft                     { get; set; }
		public bool?                         IsRead                      { get; set; }
		public bool?                         IsReadReceiptRequested      { get; set; }
		public String                        ParentFolderId              { get; set; }
		public DateTimeOffset?               ReceivedDateTime            { get; set; }
		public IList<Recipient>              ReplyTo                     { get; set; }
		public Recipient                     Sender                      { get; set; }
		public DateTimeOffset?               SentDateTime                { get; set; }
		public String                        Subject                     { get; set; }
		public IList<Recipient>              ToRecipients                { get; set; }
		public ItemBody                      UniqueBody                  { get; set; }
		public String                        WebLink                     { get; set; }
		public IList<Attachment>             Attachments                 { get; set; }
		public IList<SingleValueLegacyExtendedProperty> SingleValueExtendedProperties { get; set; }
		//public IMessageExtensionsCollectionPage  Extensions
		//public IMessageMultiValueExtendedPropertiesCollectionPage  MultiValueExtendedProperties { get; set; }
		
		public DateTime DateTimeReceived
		{
			get
			{
				if ( ReceivedDateTime.HasValue )
				{
					return ReceivedDateTime.Value.DateTime;
				}
				return DateTime.MinValue;
			}
		}
		
		public DateTime DateTimeSent
		{
			get
			{
				if ( SentDateTime.HasValue )
				{
					return SentDateTime.Value.DateTime;
				}
				return DateTime.MinValue;
			}
		}

		public string DisplayTo
		{
			get
			{
				StringBuilder sb = new StringBuilder();
				if ( this.ToRecipients != null && this.ToRecipients.Count > 0 )
				{
					foreach ( Recipient recipient in this.ToRecipients )
					{
						if ( recipient.EmailAddress != null )
						{
							if ( sb.Length > 0 )
								sb.Append("; ");
							sb.Append(recipient.ToString());
						}
					}
				}
				return sb.ToString();
			}
		}

		public string DisplayCc
		{
			get
			{
				StringBuilder sb = new StringBuilder();
				if ( this.CcRecipients != null && this.CcRecipients.Count > 0 )
				{
					foreach ( Recipient recipient in this.CcRecipients )
					{
						if ( recipient.EmailAddress != null )
						{
							if ( sb.Length > 0 )
								sb.Append("; ");
							sb.Append(recipient.ToString());
						}
					}
				}
				return sb.ToString();
			}
		}

		public bool IsFromMe(string sEXCHANGE_EMAIL)
		{
			bool bMe = false;
			if ( this.Sender != null && this.Sender.EmailAddress != null )
			{
				bMe = String.Compare(this.Sender.EmailAddress.Address, sEXCHANGE_EMAIL, true) == 0;
			}
			return bMe;
		}

		public int Size
		{
			get
			{
				int nSize = 0;
				if ( this.Body != null && !Sql.IsEmptyString(this.Body.Content) )
					nSize = this.Body.Content.Length;
				return nSize;
			}
		}

		#endregion

		public Message()
		{
			this.ODataType = "microsoft.graph.message";
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

		public static DataRow ConvertToRow(Message obj)
		{
			DataTable dt = Message.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Message> messages)
		{
			DataTable dt = Message.CreateTable();
			if ( messages != null )
			{
				foreach ( Message message in messages )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					message.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class MessagePagination
	{
		public IList<Message> messages       { get; set; }
		public int            count          { get; set; }
		public String         nextLink       { get; set; }
		public String         deltaLink      { get; set; }
	}

	public class SendMessage
	{
		public Message message { get; set; }

		public SendMessage(Message message)
		{
			this.message = message;
		}
	}
}
