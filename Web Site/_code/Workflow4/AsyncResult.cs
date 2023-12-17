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
using System.Reflection;
using System.Runtime.InteropServices;
using System.Threading;

namespace SplendidCRM
{
	public abstract class AsyncResult : IAsyncResult
	{
		private static AsyncCallback asyncCompletionWrapperCallback;
		
		private AsyncCallback    callback               ;
		private bool             bCompletedSynchronously;
		private bool             bEndCalled             ;
		private Exception        exException            ;
		private bool             bIsComplete            ;
		private ManualResetEvent manualResetEvent       ;
		private AsyncCompletion  nextAsyncCompletion    ;
		private object           oAsyncState            ;
		private object           oThisLock              ;

		protected delegate bool AsyncCompletion(IAsyncResult result);

		protected AsyncResult(AsyncCallback callback, object oAsyncState)
		{
			this.callback    = callback;
			this.oAsyncState = oAsyncState;
			this.oThisLock   = new object();
		}

		public object AsyncState
		{
			get { return oAsyncState; }
		}

		public WaitHandle AsyncWaitHandle
		{
			get
			{
				if ( manualResetEvent != null )
				{
					return manualResetEvent;
				}

				lock ( this.ThisLock )
				{
					if ( manualResetEvent == null )
					{
						manualResetEvent = new ManualResetEvent(bIsComplete);
					}
				}

				return manualResetEvent;
			}
		}

		public bool CompletedSynchronously
		{
			get { return this.bCompletedSynchronously; }
		}

		public bool HasCallback
		{
			get { return this.callback != null; }
		}

		public bool IsCompleted
		{
			get { return this.bIsComplete; }
		}

		object ThisLock
		{
			get { return this.oThisLock; }
		}

		protected void Complete(bool bCompletedSynchronously)
		{
			if ( this.bIsComplete )
			{
				throw new InvalidProgramException();
			}

			this.bCompletedSynchronously = bCompletedSynchronously;
			if ( this.bCompletedSynchronously )
			{
				this.bIsComplete = true;
			}
			else
			{
				lock ( this.ThisLock )
				{
					this.bIsComplete = true;
					if ( this.manualResetEvent != null )
					{
						this.manualResetEvent.Set();
					}
				}
			}

			if ( callback != null )
			{
				try
				{
					callback(this);
				}
				catch (Exception e)
				{
					throw new InvalidProgramException("Async callback threw an Exception", e);
				}
			}
		}

		protected void Complete(bool bCompletedSynchronously, Exception ex)
		{
			this.exException = ex;
			Complete(bCompletedSynchronously);
		}

		static void AsyncCompletionWrapperCallback(IAsyncResult result)
		{
			if ( result.CompletedSynchronously )
			{
				return;
			}

			AsyncResult     thisPtr  = (AsyncResult)result.AsyncState;
			AsyncCompletion callback = thisPtr.GetNextCompletion();

			bool      bCompleteSelf       = false;
			Exception completionException = null;
			try
			{
				bCompleteSelf = callback(result);
			}
			catch ( Exception e )
			{
				if ( IsFatal(e) )
				{
					throw;
				}
				bCompleteSelf       = true;
				completionException = e;
			}

			if ( bCompleteSelf )
			{
				thisPtr.Complete(false, completionException);
			}
		}

		public static bool IsFatal(Exception exception)
		{
			while ( exception != null )
			{
				if ( (exception is OutOfMemoryException && !(exception is InsufficientMemoryException) )
				   || exception is ThreadAbortException 
				   || exception is AccessViolationException 
				   || exception is SEHException)
				{
					return true;
				}
				if ( exception is TypeInitializationException || exception is TargetInvocationException  )
				{
					exception = exception.InnerException;
				}
				else
				{
					break;
				}
			}
			return false;
		}

		protected AsyncCallback PrepareAsyncCompletion(AsyncCompletion callback)
		{
			this.nextAsyncCompletion = callback;
			if ( AsyncResult.asyncCompletionWrapperCallback == null )
			{
				AsyncResult.asyncCompletionWrapperCallback = new AsyncCallback(AsyncCompletionWrapperCallback);
			}
			return AsyncResult.asyncCompletionWrapperCallback;
		}

		AsyncCompletion GetNextCompletion()
		{
			AsyncCompletion result = this.nextAsyncCompletion;
			this.nextAsyncCompletion = null;
			return result;
		}

		protected static TAsyncResult End<TAsyncResult>(IAsyncResult result) where TAsyncResult : AsyncResult
		{
			if ( result == null )
			{
				throw new ArgumentNullException("result");
			}

			TAsyncResult asyncResult = result as TAsyncResult;
			if ( asyncResult == null )
			{
				throw new ArgumentException("Invalid AsyncResult", "result");
			}

			if ( asyncResult.bEndCalled )
			{
				throw new InvalidOperationException("AsyncResult already ended");
			}

			asyncResult.bEndCalled = true;
			if ( !asyncResult.IsCompleted )
			{
				asyncResult.AsyncWaitHandle.WaitOne();
			}

			if ( asyncResult.manualResetEvent != null )
			{
				asyncResult.manualResetEvent.Close();
			}

			if ( asyncResult.exException != null )
			{
				throw asyncResult.exException;
			}
			return asyncResult;
		}
	}
}
