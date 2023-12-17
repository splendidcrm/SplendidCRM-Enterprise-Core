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
using System.Runtime.Serialization;
using System.Security.Permissions;

namespace Spring.Social.ConstantContact.Api
{
#if !SILVERLIGHT
	[Serializable]
#endif
	public class ConstantContactApiException : SocialException
	{
		private ConstantContactApiError error;

		public ConstantContactApiError Error
		{
			get { return this.error; }
		}

		public ConstantContactApiException(string message, ConstantContactApiError error)
			: base(message)
		{
			this.error = error;
		}

		public ConstantContactApiException(string message, Exception innerException)
			: base(message, innerException)
		{
			this.error = ConstantContactApiError.Unknown;
		}

#if !SILVERLIGHT
		protected ConstantContactApiException(SerializationInfo info, StreamingContext context)
			: base(info, context)
		{
			if (info != null)
			{
				this.error = (ConstantContactApiError)info.GetValue("Error", typeof(ConstantContactApiError));
			}
		}

		// 07/03/2023 Paul.  Obsolete in Core 5. 
#pragma warning disable SYSLIB0003
		[SecurityPermission(SecurityAction.Demand, SerializationFormatter = true)]
#pragma warning restore SYSLIB0003
		public override void GetObjectData(SerializationInfo info, StreamingContext context)
		{
			base.GetObjectData(info, context);
			if (info != null)
			{
				info.AddValue("Error", this.error);
			}
		}
#endif
	}
}
