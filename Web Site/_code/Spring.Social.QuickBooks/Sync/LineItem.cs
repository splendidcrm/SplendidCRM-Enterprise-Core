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

namespace Spring.Social.QuickBooks
{
	public class LineItem : QObject
	{
		#region Properties
		public string   CRMParentFieldName    ;
		public Guid     PARENT_ID             ;
		public Guid     PRODUCT_TEMPLATE_ID   ;
		public string   QuickBooksParentField ;
		public string   ReferenceNumber       ;
		public string   ParentId              ;
		public string   ItemLineNum           ;
		public string   ItemRefId             ;
		public string   ItemName              ;
		public string   ItemPartNumber        ;
		public string   ItemTaxCode           ;
		public string   ItemType              ;  //  Either empty or Comment. 
		public string   ItemDescription       ;
		public Decimal  ItemQuantity          ;
		public Decimal  ItemRate              ;
		public Decimal  ItemAmount            ;
		#endregion
		private DataView vwItems    ;

		public LineItem(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.QuickBooks.Api.IQuickBooks quickBooks, DataTable dtItems, Guid gSYNC_LOCAL_ID, string sSYNC_REMOTE_KEY, string sQuickBooksParentField, string sQuickBooksTableName, string sCRMModuleName, string sCRMTableName, string sCRMTableSort, string sCRMParentFieldName, bool bCRMAssignedUser)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, sQuickBooksTableName, "ItemLineID", sCRMModuleName, sCRMTableName, sCRMTableSort, bCRMAssignedUser, false, false)
		{
			this.QuickBooksParentField = sQuickBooksParentField;
			this.vwItems   = new DataView(dtItems  );
			this.PARENT_ID = gSYNC_LOCAL_ID  ;
			this.ParentId  = sSYNC_REMOTE_KEY;
			this.CRMParentFieldName = sCRMParentFieldName;
		}

		public override void Reset()
		{
			base.Reset();
			this.PARENT_ID           = Guid.Empty  ;
			this.PRODUCT_TEMPLATE_ID = Guid.Empty  ;
			this.ReferenceNumber     = String.Empty;
			this.ParentId            = String.Empty;
			this.ItemLineNum         = String.Empty;
			this.ItemRefId           = String.Empty;
			this.ItemName            = String.Empty;
			this.ItemPartNumber      = String.Empty;
			this.ItemTaxCode         = String.Empty;
			this.ItemType            = String.Empty;
			this.ItemDescription     = String.Empty;
			this.ItemQuantity        = 0;
			this.ItemRate            = 0;
			this.ItemAmount          = 0;  // This is Quantity * Rate. 
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			string sItemTaxCode = String.Empty;
			if ( !Sql.IsEmptyString(row["TAX_CLASS"]) )
				sItemTaxCode = Sql.ToString(row["TAX_CLASS"]) == "Taxable" ? "TAX" : "NON";
			string sItemRefId = String.Empty;
			if ( !Sql.IsEmptyGuid(row["PRODUCT_TEMPLATE_ID"]) )
			{
				vwItems.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["PRODUCT_TEMPLATE_ID"]) + "'";
				if ( vwItems.Count > 0 )
					sItemRefId = Sql.ToString(vwItems[0]["SYNC_REMOTE_KEY"]);
			}
			
			this.ID                  = sID;
			this.LOCAL_ID            = Sql.ToGuid(row["ID"                   ]);
			this.PARENT_ID           = Sql.ToGuid(row[this.CRMParentFieldName]);
			this.PRODUCT_TEMPLATE_ID = Sql.ToGuid(row["PRODUCT_TEMPLATE_ID"  ]);
			if ( Sql.IsEmptyString(this.ID) )
			{
				this.ItemRefId       = Sql.ToString (    sItemRefId          );
				this.ItemName        = Sql.ToString (row["NAME"             ]);
				this.ItemPartNumber  = Sql.ToString (row["MFT_PART_NUM"     ]);
				this.ItemTaxCode     = Sql.ToString (    sItemTaxCode        );
				this.ItemQuantity    = Sql.ToDecimal(row["QUANTITY"         ]);
				this.ItemRate        = Sql.ToDecimal(row["UNIT_USDOLLAR"    ]);
				this.ItemAmount      = Sql.ToDecimal(row["EXTENDED_USDOLLAR"]);
				this.ItemType        = Sql.ToString (row["LINE_ITEM_TYPE"   ]);
				this.ItemDescription = Sql.ToString (row["DESCRIPTION"      ]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.ItemRefId      ,     sItemRefId          , "PRODUCT_TEMPLATE_ID", sbChanges) ) { this.ItemRefId       = Sql.ToString (    sItemRefId          );  bChanged = true; }
				if ( Compare(this.ItemName       , row["NAME"             ], "NAME"               , sbChanges) ) { this.ItemName        = Sql.ToString (row["NAME"             ]);  bChanged = true; }
				if ( Compare(this.ItemPartNumber , row["MFT_PART_NUM"     ], "MFT_PART_NUM"       , sbChanges) ) { this.ItemPartNumber  = Sql.ToString (row["MFT_PART_NUM"     ]);  bChanged = true; }
				if ( Compare(this.ItemTaxCode    ,     sItemTaxCode        , "TAX_CLASS"          , sbChanges) ) { this.ItemTaxCode     = Sql.ToString (    sItemTaxCode        );  bChanged = true; }
				if ( Compare(this.ItemQuantity   , row["QUANTITY"         ], "QUANTITY"           , sbChanges) ) { this.ItemQuantity    = Sql.ToDecimal(row["QUANTITY"         ]);  bChanged = true; }
				if ( Compare(this.ItemRate       , row["UNIT_USDOLLAR"    ], "UNIT_USDOLLAR"      , sbChanges) ) { this.ItemRate        = Sql.ToDecimal(row["UNIT_USDOLLAR"    ]);  bChanged = true; }
				if ( Compare(this.ItemAmount     , row["EXTENDED_USDOLLAR"], "EXTENDED_USDOLLAR"  , sbChanges) ) { this.ItemAmount      = Sql.ToDecimal(row["EXTENDED_USDOLLAR"]);  bChanged = true; }
				if ( Compare(this.ItemType       , row["LINE_ITEM_TYPE"   ], "LINE_ITEM_TYPE"     , sbChanges) ) { this.ItemType        = Sql.ToString (row["LINE_ITEM_TYPE"   ]);  bChanged = true; }
				if ( Compare(this.ItemDescription, row["DESCRIPTION"      ], "DESCRIPTION"        , sbChanges) ) { this.ItemDescription = Sql.ToString (row["DESCRIPTION"      ]);  bChanged = true; }
			}
			return bChanged;
		}

		public bool CompareToCRM(DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			string sItemTaxCode = String.Empty;
			if ( !Sql.IsEmptyString(row["TAX_CLASS"]) )
				sItemTaxCode = Sql.ToString(row["TAX_CLASS"]) == "Taxable" ? "TAX" : "NON";
			string sItemRefId = String.Empty;
			if ( !Sql.IsEmptyGuid(row["PRODUCT_TEMPLATE_ID"]) )
			{
				vwItems.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["PRODUCT_TEMPLATE_ID"]) + "'";
				if ( vwItems.Count > 0 )
					sItemRefId = Sql.ToString(vwItems[0]["SYNC_REMOTE_KEY"]);
			}
			
			// 03/10/2015 Paul.  Description field is only used for comments. 
			if ( this.ItemType == "Comment" )
			{
				if ( Compare(this.ItemType       , row["LINE_ITEM_TYPE"   ], "LINE_ITEM_TYPE"     , sbChanges) ) bChanged = true;
				if ( Compare(this.ItemDescription, row["DESCRIPTION"      ], "DESCRIPTION"        , sbChanges) ) bChanged = true;
			}
			else
			{
				if ( Compare(this.ItemRefId      ,     sItemRefId          , "PRODUCT_TEMPLATE_ID", sbChanges) ) bChanged = true;
				if ( Compare(this.ItemName       , row["NAME"             ], "NAME"               , sbChanges) ) bChanged = true;
				if ( Compare(this.ItemPartNumber , row["MFT_PART_NUM"     ], "MFT_PART_NUM"       , sbChanges) ) bChanged = true;
				if ( Compare(this.ItemTaxCode    ,     sItemTaxCode        , "TAX_CLASS"          , sbChanges) ) bChanged = true;
				if ( Compare(this.ItemQuantity   , row["QUANTITY"         ], "QUANTITY"           , sbChanges) ) bChanged = true;
				if ( Compare(this.ItemRate       , row["UNIT_USDOLLAR"    ], "UNIT_USDOLLAR"      , sbChanges) ) bChanged = true;
				if ( Compare(this.ItemAmount     , row["EXTENDED_USDOLLAR"], "EXTENDED_USDOLLAR"  , sbChanges) ) bChanged = true;
				if ( Compare(this.ItemType       , row["LINE_ITEM_TYPE"   ], "LINE_ITEM_TYPE"     , sbChanges) ) bChanged = true;
				//if ( Compare(this.ItemDescription, row["DESCRIPTION"      ], "DESCRIPTION"        , sbChanges) ) bChanged = true;
			}
			return bChanged;
		}

		public void SetFromQuickBooks(DataRow row)
		{
			throw(new Exception("Not implemented."));
		}

		public override void FilterCRM(IDbCommand cmd)
		{
			Sql.AppendParameter(cmd, PARENT_ID                  , this.CRMTableName.Replace("S_LINE_ITEMS", "") + "_ID");
			Sql.AppendParameter(cmd, Sql.ToString(this.ItemName), "MFT_PART_NUM");
		}

		// 02/03/2015 Paul.  It would be helpful to track changes. 
		public override bool BuildUpdateProcedure(ExchangeSession Session, IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			bool bChanged = this.InitUpdateProcedure(spUpdate, row, gUSER_ID, gTEAM_ID);
			
			string sTAX_CLASS = String.Empty;
			// 03/07/2015 Paul.  A comment line should not have the TAX_CLASS set. 
			if ( !Sql.IsEmptyString(this.ItemTaxCode) )
				sTAX_CLASS = Sql.ToString(this.ItemTaxCode).ToUpper() == "TAX" ? "Taxable" : "Non-Taxable";
			if ( Sql.IsEmptyGuid(this.PRODUCT_TEMPLATE_ID) )
			{
				vwItems.RowFilter = "SYNC_REMOTE_KEY = '" + this.ItemRefId + "'";
				if ( vwItems.Count > 0 )
					this.PRODUCT_TEMPLATE_ID = Sql.ToGuid(vwItems[0]["SYNC_LOCAL_ID"]);
			}
			if ( Sql.IsEmptyGuid(PARENT_ID) )
				throw(new Exception("BuildUpdateProcedure.PARENT_ID cannot be empty."));
			
			foreach(IDbDataParameter par in spUpdate.Parameters)
			{
				Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
				// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
				string sColumnName = Sql.ExtractDbName(spUpdate, par.ParameterName).ToUpper();
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
							case "PRODUCT_TEMPLATE_ID":  oValue = Sql.ToDBGuid   (this.PRODUCT_TEMPLATE_ID );  break;
							case "NAME"               :  oValue = Sql.ToDBString (this.ItemName            );  break;
							case "MFT_PART_NUM"       :  oValue = Sql.ToDBString (this.ItemPartNumber      );  break;
							case "QUANTITY"           :  oValue = Sql.ToDBDecimal(this.ItemQuantity        );  break;
							case "TAX_CLASS"          :  oValue = Sql.ToDBString (     sTAX_CLASS          );  break;
							case "POSITION"           :  oValue = Sql.ToDBInteger(this.ItemLineNum         );  break;
							// 03/04/2015 Paul.  Don't set COST_PRICE or LIST_PRICE to ItemRate. 
							//case "COST_PRICE"         :  oValue = Sql.ToDBDecimal(this.ItemRate            );  break;
							//case "COST_USDOLLAR"      :  oValue = Sql.ToDBDecimal(this.ItemRate            );  break;
							//case "LIST_PRICE"         :  oValue = Sql.ToDBDecimal(this.ItemRate            );  break;
							//case "LIST_USDOLLAR"      :  oValue = Sql.ToDBDecimal(this.ItemRate            );  break;
							case "UNIT_PRICE"         :  oValue = Sql.ToDBDecimal(this.ItemRate            );  break;
							case "UNIT_USDOLLAR"      :  oValue = Sql.ToDBDecimal(this.ItemRate            );  break;
							case "EXTENDED_PRICE"     :  oValue = Sql.ToDBDecimal(this.ItemAmount          );  break;
							case "EXTENDED_USDOLLAR"  :  oValue = Sql.ToDBDecimal(this.ItemAmount          );  break;
							case "MODIFIED_USER_ID"   :  oValue = gUSER_ID                                  ;  break;
							case "LINE_ITEM_TYPE"     :  oValue = Sql.ToDBString (this.ItemType            );  break;
							case "DESCRIPTION"        :
								// 03/06/2015 Paul.  Only set the description if this is a comment line. 
								if ( this.ItemType == "Comment" )
									oValue = Sql.ToDBString (this.ItemDescription);
								break;
								
						}
						if ( sColumnName == this.CRMParentFieldName )
						{
							oValue = Sql.ToDBGuid(PARENT_ID);
							par.Value = oValue;
						}
						
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						// 02/17/2015 Paul.  Modified User ID does not count as a changed field. 
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" && sColumnName != this.CRMParentFieldName )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "MFT_PART_NUM"  :  bChanged = ParameterChanged(par, oValue,   31, sbChanges);  break;
									case "NAME"          :  bChanged = ParameterChanged(par, oValue, 4095, sbChanges);  break;
									case "DESCRIPTION"   :  bChanged = ParameterChanged(par, oValue, 4095, sbChanges);  break;
									case "LINE_ITEM_TYPE":  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									default              :  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
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
			return bChanged;
		}
	}
}
