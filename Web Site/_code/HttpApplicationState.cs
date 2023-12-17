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
using Microsoft.Extensions.Configuration;

namespace SplendidCRM
{
	public class HttpApplicationState
	{
		private static Dictionary<string, object> Application = null;

		public HttpApplicationState()
		{
			if ( Application == null )
			{
				Application = new Dictionary<string, object>();
			}
		}
		public HttpApplicationState(IConfiguration Configuration)
		{
			if ( Application == null )
			{
				Application = new Dictionary<string, object>();
				// 06/17/2022 Paul.  Protect against parallel access. 
				// Operations that change non-concurrent collections must have exclusive access. A concurrent update was performed on this collection and corrupted its state. The collection's state is no longer correct.
				lock ( Application )
				{
					this["CONFIG.session_timeout"                      ] = Configuration["session_timeout"                      ];

					this["CONFIG.Azure.SingleSignOn.Enabled"           ] = Configuration["Azure.SingleSignOn:Enabled"           ];
					this["CONFIG.Azure.SingleSignOn.AadTenantDomain"   ] = Configuration["Azure.SingleSignOn:AadTenantDomain"   ];
					this["CONFIG.Azure.SingleSignOn.ValidIssuer"       ] = Configuration["Azure.SingleSignOn:ValidIssuer"       ];
					this["CONFIG.Azure.SingleSignOn.AadTenantId"       ] = Configuration["Azure.SingleSignOn:AadTenantId"       ];
					this["CONFIG.Azure.SingleSignOn.AadClientId"       ] = Configuration["Azure.SingleSignOn:AadClientId"       ];
					this["CONFIG.Azure.SingleSignOn.AadSecretId"       ] = Configuration["Azure.SingleSignOn:AadSecretId"       ];
					this["CONFIG.Azure.SingleSignOn.MobileClientId"    ] = Configuration["Azure.SingleSignOn:MobileClientId"    ];
					this["CONFIG.Azure.SingleSignOn.MobileRedirectUrl" ] = Configuration["Azure.SingleSignOn:MobileRedirectUrl" ];
					this["CONFIG.Azure.SingleSignOn.Realm"             ] = Configuration["Azure.SingleSignOn:Realm"             ];
					this["CONFIG.Azure.SingleSignOn.FederationMetadata"] = Configuration["Azure.SingleSignOn:FederationMetadata"];

					this["CONFIG.ADFS.SingleSignOn.Enabled"            ] = Configuration["ADFS.SingleSignOn:Enabled"            ];
					this["CONFIG.ADFS.SingleSignOn.Authority"          ] = Configuration["ADFS.SingleSignOn:Authority"          ];
					this["CONFIG.ADFS.SingleSignOn.ClientId"           ] = Configuration["ADFS.SingleSignOn:ClientId"           ];
					this["CONFIG.ADFS.SingleSignOn.MobileClientId"     ] = Configuration["ADFS.SingleSignOn:MobileClientId"     ];
					this["CONFIG.ADFS.SingleSignOn.MobileRedirectUrl"  ] = Configuration["ADFS.SingleSignOn:MobileRedirectUrl"  ];
					this["CONFIG.ADFS.SingleSignOn.Realm"              ] = Configuration["ADFS.SingleSignOn:Realm"              ];
					this["CONFIG.ADFS.SingleSignOn.Thumbprint"         ] = Configuration["ADFS.SingleSignOn:Thumbprint"         ];
				}
			}
		}

		public object this[string key]
		{
			get
			{
				if ( Application.ContainsKey(key) )
					return Application[key];
				return null;
			}
			set
			{
				lock ( Application )
				{
					Application[key] = value;
				}
			}
		}

		public int Count
		{
			get
			{
				return Application.Count;
			}
		}

		public Dictionary<string, object>.KeyCollection Keys
		{
			get
			{
				return Application.Keys;
			}
		}

		public void Remove(string key)
		{
			lock ( Application )
			{
				Application.Remove(key);
			}
		}
	}
}
