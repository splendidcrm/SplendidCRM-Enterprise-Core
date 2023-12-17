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
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Scripting;
using Microsoft.CodeAnalysis.Scripting;

namespace SplendidCRM
{
	public class RuleSet
	{
		public string               Name        { get; set; }
		public string               Description { get; set; }
		public RuleChainingBehavior Behavior    { get; set; }
		public List<Rule>           Rules       { get; set; }

		public RuleSet(string name)
		{
			this.Behavior = RuleChainingBehavior.Full;
			this.Rules = new List<Rule>();
		}

		public bool Validate(RuleValidation validation)
		{
			if ( validation == null )
				throw new ArgumentNullException("validation");
 
			foreach ( Rule r in this.Rules )
			{
				r.Validate(validation);
			}
 
			if ( validation.Errors == null || validation.Errors.Count == 0 )
				return true;
 
			return false;
		}

		public void Execute(RuleExecution exec)
		{
			try
			{
				foreach ( Rule r in this.Rules )
				{
					bool bCondition = r.Condition.Evaluate(exec);
					if ( bCondition )
					{
						foreach ( RuleAction action in r.ThenActions )
						{
							action.Execute(exec);
						}
					}
					else
					{
						foreach ( RuleAction action in r.ElseActions )
						{
							action.Execute(exec);
						}
					}
				}
			}
			catch(Exception ex)
			{
				if ( exec.ThisObject is SqlObj )
				{
					(exec.ThisObject as SqlObj).ErrorMessage = ex.Message;
				}
				ValidationError error = new ValidationError(ex.Message);
				exec.Validation.Errors.Add(error);
			}
		}
	}
}
