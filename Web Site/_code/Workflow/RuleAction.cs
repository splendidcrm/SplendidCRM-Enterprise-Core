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
	public class RuleAction
	{
		public string code { get; set; }

		public RuleAction(string code)
		{
			this.code = code;
		}

		public bool Validate(RuleValidation validator)
		{
			// 08/12/2023 Paul.  Rosyln expects a semi-colon terminator. 
			if ( !code.Trim().EndsWith(";") )
				code += ";";
			if ( !String.IsNullOrEmpty(code) )
			{
				SyntaxTree tree = CSharpSyntaxTree.ParseText(code);
				IEnumerable<Diagnostic> diags = tree.GetDiagnostics();
				foreach (Diagnostic diag in diags)
				{
					if ( diag.Severity == DiagnosticSeverity.Error )
					{
						ValidationError error = new ValidationError(diag.GetMessage());
						validator.Errors.Add(error);
					}
				}
			}
			return validator.Errors.Count == 0;
		}

		public void Execute(RuleExecution exec)
		{
			if ( !Sql.IsEmptyString(code) )
			{
				string sActionCode = code.Replace("this.", "THIS.").Replace("this[", "THIS[");
				ScriptState<object> scriptState = CSharpScript.RunAsync(sActionCode, exec.ScriptOptions, exec.Globals).Result;
				//scriptState.ContinueWithAsync(code).Result;
			}
		}
	}
}
