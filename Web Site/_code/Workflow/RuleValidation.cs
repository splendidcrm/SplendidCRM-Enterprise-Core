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

namespace SplendidCRM
{
	public class RuleValidation
	{
		public Type                                           ThisType            { get; set; }
		public ITypeProvider                                  TypeProvider        { get; set; }
		public List<ValidationError>                          Errors              { get; set; }
		public Dictionary<string, Type>                       TypesUsed           { get; set; }
		public Dictionary<string, Type>                       TypesUsedAuthorized { get; set; }
		//public Stack<CodeExpression>                          ActiveParentNodes   { get; set; }
		//public Dictionary<CodeExpression, RuleExpressionInfo> ExpressionInfoMap   { get; set; }
		//public Dictionary<CodeTypeReference, Type>            TypeRefMap          { get; set; }
		public bool                                           CheckStaticType     { get; set; }
		public IList<AuthorizedType>                          AuthorizedTypes     { get; set; }
 
		public RuleValidation(Type thisType, SplendidRulesTypeProvider typeProvider)
		{
			this.Errors = new List<ValidationError>();
		}

		public bool ValidateConditionExpression(string expression)
		{
			if ( String.IsNullOrEmpty(expression) )
				throw(new ArgumentNullException("expression"));

			// 08/12/2023 Paul.  Rosyln expects a condition. 
			string code = "if (" + expression + ") {}";
			SyntaxTree tree = CSharpSyntaxTree.ParseText(code);
			IEnumerable<Diagnostic> diags = tree.GetDiagnostics();
			foreach (Diagnostic diag in diags)
			{
				if ( diag.Severity == DiagnosticSeverity.Error )
				{
					ValidationError error = new ValidationError(diag.GetMessage());
					this.Errors.Add(error);
				}
			}
			return Errors.Count == 0;
		}
	}
}
