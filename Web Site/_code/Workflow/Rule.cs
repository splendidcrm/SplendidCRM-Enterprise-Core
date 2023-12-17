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
using System.Collections.Generic;

namespace SplendidCRM
{
	public class Rule
	{
		public string                   Name                 { get; set; }
		public string                   Description          { get; set; }
		public int                      Priority             { get; set; }
		public RuleReevaluationBehavior ReevaluationBehavior { get; set; }
		public bool                     Active               { get; set; }
		public RuleExpressionCondition  Condition            { get; set; }
		public IList<RuleAction>        ThenActions          { get; set; }
		public IList<RuleAction>        ElseActions          { get; set; }

		public Rule(string name, RuleExpressionCondition condition, List<RuleAction> thenActions, List<RuleAction> elseActions)
		{
			this.Name                 = name          ;
			this.Description          = string.Empty  ;
			this.Priority             = 0             ;
			this.ReevaluationBehavior = RuleReevaluationBehavior.Always;
			this.Active               = true          ;
			this.Condition            = condition     ;
			this.ThenActions          = thenActions   ;
			this.ElseActions          = elseActions   ;
		}

		public void Validate(RuleValidation validation)
		{
			// check the condition
			if ( this.Condition == null )
				validation.Errors.Add(new ValidationError("Messages.MissingRuleCondition"));
			else
				this.Condition.Validate(validation);
 
			// check the optional then actions
			if ( this.ThenActions != null)
				ValidateRuleActions(this.ThenActions, validation);
 
			// check the optional else actions
			if (this.ElseActions != null)
				ValidateRuleActions(this.ElseActions, validation);
		}
 
		private static void ValidateRuleActions(ICollection<RuleAction> ruleActions, RuleValidation validator)
		{
			foreach (RuleAction action in ruleActions)
			{
				action.Validate(validator);
			}
		}
 	}
}
