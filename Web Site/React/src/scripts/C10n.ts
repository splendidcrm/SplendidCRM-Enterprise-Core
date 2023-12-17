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
import Credentials                                     from '../scripts/Credentials'     ;

// 10/16/2021 Paul.  Add support for user currency. 
export default class C10n
{
		public static ToCurrency(f: number): number
		{
			// 05/10/2006 Paul.  Short-circuit the math if USD. 
			// This is more to prevent bugs than to speed calculations. 
			if ( Credentials.bUSER_CurrencyUSDollars || Credentials.dUSER_CurrencyCONVERSION_RATE <= 0 )
				return f;
			return f * Credentials.dUSER_CurrencyCONVERSION_RATE;
		}

		public static FromCurrency(f: number): number
		{
			// 05/10/2006 Paul.  Short-circuit the math if USD. 
			// This is more to prevent bugs than to speed calculations. 
			if ( Credentials.bUSER_CurrencyUSDollars || Credentials.dUSER_CurrencyCONVERSION_RATE <= 0 )
				return f;
			return f / Credentials.dUSER_CurrencyCONVERSION_RATE;
		}
}

