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
using System.Collections.Generic;
using System.Collections.Specialized;
using Spring.Json;

namespace Spring.Social.QuickBooks.Api
{
	[Serializable]
	public class TaxRateDetail : QBase
	{
		#region Properties
		public ReferenceType             TaxRateRef                    { get; set; }
		public TaxTypeEnum?              TaxTypeApplicable             { get; set; }  // 31 chars. 
		public int?                      TaxOrder                      { get; set; }

		public string TaxRateRefValue
		{
			get
			{
				return this.TaxRateRef == null ? String.Empty : this.TaxRateRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.TaxRateRef = new ReferenceType(value);
				else
					this.TaxRateRef = null;
			}
		}

		public int TaxOrderValue
		{
			get
			{
				return this.TaxOrder.HasValue ? this.TaxOrder.Value : 0;
			}
			set
			{
				this.TaxOrder = value;
			}
		}

		public string TaxTypeApplicableValue
		{
			get
			{
				return (this.TaxTypeApplicable == null || !this.TaxTypeApplicable.HasValue) ? String.Empty : this.TaxTypeApplicable.Value.ToString();
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.TaxTypeApplicable = Spring.Social.QuickBooks.Api.Impl.Json._EnumDeserializer.DeserializeTaxType(new Spring.Json.JsonValue(value));
				else
					this.TaxTypeApplicable = null;
			}
		}

		#endregion
	}
}
