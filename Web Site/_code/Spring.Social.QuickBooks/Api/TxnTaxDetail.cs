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

namespace Spring.Social.QuickBooks.Api
{
	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/020_key_concepts/0700_other_topics#TxnTaxDetail
	[Serializable]
	public class TxnTaxDetail
	{
		public ReferenceType DefaultTaxCodeRef { get; set; }
		public ReferenceType TxnTaxCodeRef     { get; set; }
		public Decimal?      TotalTax          { get; set; }
		public IList<Line>   TaxLine           { get; set; }

		public string TxnTaxCodeTaxRate
		{
			get
			{
				string sTaxCodeTaxRate = String.Empty;
				string sTaxRateId = String.Empty;
				if ( this.TaxLine != null && this.TaxLine.Count > 0 )
				{
					for ( int i = 0; i < this.TaxLine.Count; i++ )
					{
						if ( this.TaxLine[i].DetailType.HasValue && this.TaxLine[i].DetailType.Value == LineDetailTypeEnum.TaxLineDetail && this.TaxLine[i].Item is TaxLineDetail )
						{
							TaxLineDetail taxLine = this.TaxLine[i].Item as TaxLineDetail;
							if ( taxLine.TaxRateRef != null )
								sTaxRateId = taxLine.TaxRateRef.Value;
							break;
						}
					}
				}
				if ( TxnTaxCodeRef != null )
					sTaxCodeTaxRate = Sql.ToString(TxnTaxCodeRef.Value);
				if ( !Sql.IsEmptyString(sTaxRateId) )
					sTaxCodeTaxRate += "," + sTaxRateId;
				return sTaxCodeTaxRate;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
				{
					string[] arrTaxCodeTaxRate = value.Split(',');
					this.TxnTaxCodeRef = new ReferenceType(arrTaxCodeTaxRate[0]);
					string sTaxRateId = String.Empty;
					if ( arrTaxCodeTaxRate.Length > 1 )
						sTaxRateId = arrTaxCodeTaxRate[1];
					
					if ( !Sql.IsEmptyString(sTaxRateId) )
					{
						if ( this.TaxLine == null )
							this.TaxLine = new List<Line>();
						if ( this.TaxLine.Count == 0 )
							this.TaxLine.Add(new Line());
						this.TaxLine[0].Amount     = TotalTax;
						this.TaxLine[0].DetailType = LineDetailTypeEnum.TaxLineDetail;
						this.TaxLine[0].Item       = new TaxLineDetail();
						(this.TaxLine[0].Item as TaxLineDetail).TaxRateRef = new ReferenceType(sTaxRateId);
					}
					else
					{
						this.TaxLine = null;
					}
				}
				else
				{
					this.TaxLine = null;
				}
			}
		}

		public TxnTaxDetail()
		{
		}

		public TxnTaxDetail(Decimal dTotalTax)
		{
			this.TotalTax = dTotalTax;
		}
	}
}
