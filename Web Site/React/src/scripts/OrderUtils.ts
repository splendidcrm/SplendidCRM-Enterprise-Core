/*
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Enterprise Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 */

// 1. React and fabric. 
// 2. Store and Types. 
// 3. Scripts. 
import Sql    from './Sql';

// 02/21/2021 Paul.  DiscountPrice() will return dDISCOUNT_PRICE unmodified if formula is blank or fixed. 
export function DiscountPrice(sPRICING_FORMULA: string, fPRICING_FACTOR: number, dCOST_PRICE: number, dLIST_PRICE: number, dDISCOUNT_PRICE: number)
{
	if ( fPRICING_FACTOR > 0 )
	{
		switch ( sPRICING_FORMULA )
		{
			case "Fixed"             :
				break;
			case "ProfitMargin"      :
				dDISCOUNT_PRICE = dCOST_PRICE * 100 / (100 - fPRICING_FACTOR);
				break;
			case "PercentageMarkup"  :
				dDISCOUNT_PRICE = dCOST_PRICE * (1 + (fPRICING_FACTOR /100));
				break;
			case "PercentageDiscount":
				dDISCOUNT_PRICE = (dLIST_PRICE * (1 - (fPRICING_FACTOR /100))*100)/100;
				break;
			case "FixedDiscount":
				dDISCOUNT_PRICE = dLIST_PRICE - fPRICING_FACTOR;
				break;
			case "IsList"            :
				dDISCOUNT_PRICE = dLIST_PRICE;
				break;
		}
	}
	return dDISCOUNT_PRICE;
}

export function DiscountValue(sPRICING_FORMULA, fPRICING_FACTOR, dLIST_PRICE)
{
	let dDISCOUNT_VALUE = 0.0;
	if ( fPRICING_FACTOR > 0 )
	{
		switch ( sPRICING_FORMULA )
		{
			case 'PercentageDiscount':
				dDISCOUNT_VALUE = (dLIST_PRICE * (Sql.ToDecimal(fPRICING_FACTOR) /100)*100)/100;
				break;
			case 'FixedDiscount'     :
				dDISCOUNT_VALUE = Sql.ToDecimal(fPRICING_FACTOR);
				break;
		}
	}
	return dDISCOUNT_VALUE;
}

