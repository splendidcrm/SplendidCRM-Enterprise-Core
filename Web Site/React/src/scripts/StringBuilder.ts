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

const ControlChars = { CrLf: '\r\n', Cr: '\r', Lf: '\n', Tab: '\t' };

export default class StringBuilder
{
	private value : string;
	public  length: number;

	constructor()
	{
		this.value  = '';
		this.length = this.value.length;
	}

	public Append(s: string)
	{
		this.value  = this.value + s;
		this.length = this.value.length;
	}

	public AppendLine(s?: string)
	{
		if ( s === undefined )
		{
			this.value  = this.value + ControlChars;
			this.length = this.value.length;
		}
		else
		{
			this.value  = this.value + s;
			this.length = this.value.length;
		}
	}

	public toString()
	{
		return this.value;
	}
}

