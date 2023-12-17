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
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Activities;
using System.Diagnostics;

namespace SplendidCRM
{
	[DataContract(Name="WF4Recipient")]
	public class WF4Recipient
	{
		[DataMember(IsRequired=false, Name="SEND_TYPE"      , Order=0)] public string SEND_TYPE        { get; set; }
		[DataMember(IsRequired=false, Name="RECIPIENT_ID"            )] public Guid   RECIPIENT_ID     { get; set; }
		[DataMember(IsRequired=false, Name="RECIPIENT_NAME"          )] public string RECIPIENT_NAME   { get; set; }
		[DataMember(IsRequired=false, Name="RECIPIENT_TYPE"          )] public string RECIPIENT_TYPE   { get; set; }
		[DataMember(IsRequired=false, Name="RECIPIENT_TABLE"         )] public string RECIPIENT_TABLE  { get; set; }
		[DataMember(IsRequired=false, Name="RECIPIENT_FIELD"         )] public string RECIPIENT_FIELD  { get; set; }

		public WF4Recipient()
		{
			this.RECIPIENT_ID    = Guid.Empty;
			this.RECIPIENT_NAME  = String.Empty;
			this.RECIPIENT_TYPE  = String.Empty;
			this.SEND_TYPE       = String.Empty;
			this.RECIPIENT_TABLE = String.Empty;
			this.RECIPIENT_FIELD = String.Empty;
		}

		public override string ToString()
		{
			return "WF4Recipient: " + RECIPIENT_ID.ToString() + " " + RECIPIENT_NAME + " " + RECIPIENT_TYPE + " " + SEND_TYPE;
		}
	}

	public class WF4AddRecipientActivity : CodeActivity
	{
		public InArgument<Guid  >                    RECIPIENT_ID     { get; set; }
		public InArgument<string>                    RECIPIENT_NAME   { get; set; }
		public InArgument<string>                    RECIPIENT_TYPE   { get; set; }
		public InArgument<string>                    SEND_TYPE        { get; set; }
		public InArgument<string>                    RECIPIENT_TABLE  { get; set; }
		public InArgument<string>                    RECIPIENT_FIELD  { get; set; }
		// 07/17/2016 Paul.  Cannot be InOutArgument. 
		public InArgument<ICollection<WF4Recipient>> RECIPIENTS       { get; set; }

		protected override void Execute(CodeActivityContext context)
		{
			SplendidApplicationService app = context.GetExtension<SplendidApplicationService>();
			SplendidError        SplendidError  = app.SplendidError;

			try
			{
				WF4Recipient result = new WF4Recipient();
				result.RECIPIENT_ID    = context.GetValue<Guid  >(RECIPIENT_ID   );
				result.RECIPIENT_NAME  = context.GetValue<string>(RECIPIENT_NAME );
				result.RECIPIENT_TYPE  = context.GetValue<string>(RECIPIENT_TYPE );
				result.SEND_TYPE       = context.GetValue<string>(SEND_TYPE      );
				result.RECIPIENT_TABLE = context.GetValue<string>(RECIPIENT_TABLE);
				result.RECIPIENT_FIELD = context.GetValue<string>(RECIPIENT_FIELD);
				context.GetValue<ICollection<WF4Recipient>>(RECIPIENTS).Add(result);
			
				Debug.WriteLine(result.ToString());
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				throw(new Exception("WF4AddRecipientActivity.Execute failed: " + ex.Message, ex));
			}
		}
	}

}
