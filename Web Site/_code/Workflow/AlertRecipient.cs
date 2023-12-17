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

namespace SplendidCRM
{
	[Serializable]
	public class AlertRecipient
	{
		// 11/19/2008 Paul.  When sending an email, we need the record or user ID. 
		protected Guid   gRecipientID  ;
		protected string sRecipientType;
		protected string sDisplayName  ;
		protected string sAddress      ;
		protected string sSendType     ;

		public Guid RecipientID
		{
			get { return gRecipientID; }
			set { gRecipientID = value; }
		}

		public string RecipientType
		{
			get { return sRecipientType; }
			set { sRecipientType = value; }
		}

		public string DisplayName
		{
			get { return sDisplayName; }
			set { sDisplayName = value; }
		}

		public string Address
		{
			get { return sAddress; }
			set { sAddress = value; }
		}

		public string SendType
		{
			get { return sSendType; }
			set { sSendType = value; }
		}

		public AlertRecipient(Guid gRecipientID, string sRecipientType, string sDisplayName, string sAddress, string sSendType)
		{
			this.gRecipientID   = gRecipientID  ;
			this.sRecipientType = sRecipientType;
			this.sDisplayName   = sDisplayName  ;
			this.sAddress       = sAddress      ;
			this.sSendType      = sSendType     ;
		}
	}

}
