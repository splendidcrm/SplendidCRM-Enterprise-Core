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

namespace Spring.Social.ConstantContact
{
	public class Lead : Contact
	{
		public Lead(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.ConstantContact.Api.IConstantContact constantContact)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, constantContact, "Contacts", "Name", "Leads", "LEADS", "NAME", true)
		{
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = base.SetFromCRM(sID, row, sbChanges);
			if ( Sql.IsEmptyString(sID) )
			{
				//this.status                = Sql.ToString(row["STATUS"                    ]);
				this.source                = Sql.ToString(row["LEAD_SOURCE"               ]);
				this.source_details        = Sql.ToString(row["LEAD_SOURCE_DESCRIPTION"   ]);
			}
			else
			{
				// 05/04/2015 Paul.  We do not want to update the CRM status with the ConstantContact status. 
				//if ( Compare(this.status               , row["STATUS"                    ], "STATUS"                    , sbChanges) ) { this.status                = Sql.ToString(row["STATUS"                    ]);  bChanged = true; }
				if ( Compare(this.source               , row["LEAD_SOURCE"               ], "LEAD_SOURCE"               , sbChanges) ) { this.source                = Sql.ToString(row["LEAD_SOURCE"               ]);  bChanged = true; }
				if ( Compare(this.source_details       , row["LEAD_SOURCE_DESCRIPTION"   ], "LEAD_SOURCE_DESCRIPTION"   , sbChanges) ) { this.source_details        = Sql.ToString(row["LEAD_SOURCE_DESCRIPTION"   ]);  bChanged = true; }
			}
			return bChanged;
		}

		public override bool BuildUpdateProcedure(ExchangeSession Session, IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			bool bChanged = base.BuildUpdateProcedure(Session, spUpdate, row, gUSER_ID, gTEAM_ID, gASSIGNED_USER_ID, trn, sbChanges);
			
			foreach(IDbDataParameter par in spUpdate.Parameters)
			{
				Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
				string sColumnName = Sql.ExtractDbName(spUpdate, par.ParameterName).ToUpper();
				// 05/04/2015 Paul.  Speed-up by only processing the specific columns. 
				if ( sColumnName == "LEAD_SOURCE" || sColumnName == "LEAD_SOURCE_DESCRIPTION" )
				{
					if ( SplendidInit.bEnableACLFieldSecurity )
					{
						acl = ExchangeSecurity.GetUserFieldSecurity(Session, this.CRMModuleName, sColumnName, gASSIGNED_USER_ID);
					}
					if ( acl.IsWriteable() )
					{
						try
						{
							// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
							object oValue = null;
							switch ( sColumnName )
							{
								// 05/04/2015 Paul.  We do not want to update the CRM status with the ConstantContact status. 
								//case "STATUS"                     :  oValue = Sql.ToDBString (this.status               );  break;
								case "LEAD_SOURCE"                :  oValue = Sql.ToDBString (this.source               );  break;
								case "LEAD_SOURCE_DESCRIPTION"    :  oValue = Sql.ToDBString (this.source_details       );  break;
							}
							// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
							// 02/17/2015 Paul.  Modified User ID does not count as a changed field. 
							if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
							{
								if ( !bChanged )
								{
									switch ( sColumnName )
									{
										//case "STATUS"                     :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
										case "LEAD_SOURCE"                :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
										case "LEAD_SOURCE_DESCRIPTION"    :  bChanged = ParameterChanged(par, oValue, 4000, sbChanges);  break;
									}
								}
								par.Value = oValue;
							}
						}
						catch
						{
							// 03/27/2010 Paul.  Some fields are not available.  Lets just ignore them. 
						}
					}
				}
			}
			return bChanged;
		}
	}
}
