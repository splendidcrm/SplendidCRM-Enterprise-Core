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
	public class CompletedAsyncResult : AsyncResult
	{
		public CompletedAsyncResult(AsyncCallback callback, object state) : base(callback, state)
		{
			Complete(true);
		}

		public static void End(IAsyncResult result)
		{
			AsyncResult.End<CompletedAsyncResult>(result);
		}
	}

	public class CompletedAsyncResult<T> : AsyncResult
	{
		T data;

		public CompletedAsyncResult(T data, AsyncCallback callback, object state) : base(callback, state)
		{
			this.data = data;
			Complete(true);
		}

		public static T End(IAsyncResult result)
		{
			CompletedAsyncResult<T> completedResult = AsyncResult.End<CompletedAsyncResult<T>>(result);
			return completedResult.data;
		}
	}
}
