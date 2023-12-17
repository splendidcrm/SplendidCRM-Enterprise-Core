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

export default interface IOrdersLineItemsEditorState
{
	bEnableTaxLineItems?  : boolean;
	bEnableTaxShipping?   : boolean;
	bShowTax?             : boolean;
	bEnableSalesTax?      : boolean;
	bDisableExchangeRate? : boolean;
	oNumberFormat?        : any;

	CURRENCY_ID?          : string;
	// 11/12/2022 Paul.  We can't dynamically convert to a number as it will prevent editing. 
	EXCHANGE_RATE?        : string;
	TAXRATE_ID?           : string;
	SHIPPER_ID?           : string;

	CURRENCY_ID_LIST?     : any[];
	TAXRATE_ID_LIST?      : any[];
	SHIPPER_ID_LIST?      : any[];

	SUBTOTAL?             : number;
	DISCOUNT?             : number;
	// 11/12/2022 Paul.  We can't dynamically convert to a number as it will prevent editing. 
	SHIPPING?             : string;
	TAX?                  : number;
	TOTAL?                : number;
}

