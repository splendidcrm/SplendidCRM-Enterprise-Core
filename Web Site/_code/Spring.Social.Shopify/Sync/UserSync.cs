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
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Web;
using System.Diagnostics;
using SplendidCRM;

namespace Spring.Social.Shopify
{
	public class UserSync
	{
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private SplendidError        SplendidError      ;
		private ExchangeSecurity     ExchangeSecurity   ;
		private SyncError            SyncError          ;
		private ShopifySync          ShopifySync        ;
		public Guid        USER_ID;
		public bool        SyncAll;

		public UserSync(HttpSessionState Session, Security Security, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError, ShopifySync ShopifySync, Guid gUSER_ID, bool bSyncAll)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.SplendidError       = SplendidError      ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.SyncError           = SyncError          ;
			this.ShopifySync         = ShopifySync        ;

			this.USER_ID = gUSER_ID;
			this.SyncAll = bSyncAll;
		}
			
		public void Start()
		{
			DateTime dtStart = DateTime.Now;
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Shopify.VerboseStatus"]);
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "UserSync:  Begin at " + dtStart.ToString());
			StringBuilder sbErrors = new StringBuilder();
				
			ShopifySync.Sync(this, sbErrors);
			DateTime dtEnd = DateTime.Now;
			TimeSpan ts = dtEnd - dtStart;
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "UserSync:  End at " + dtEnd.ToString() + ". Elapse time " + ts.Minutes.ToString() + " minutes " + ts.Seconds.ToString() + " seconds.");
		}
	}
}
