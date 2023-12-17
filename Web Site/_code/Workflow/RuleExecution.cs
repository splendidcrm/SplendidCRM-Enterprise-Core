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
using Microsoft.CodeAnalysis.Scripting;

namespace SplendidCRM
{
	public class RuleExecution
	{
		public class SplendidControlThisGlobals
		{
			public SplendidControlThis THIS;
		}

		public class SplendidWizardThisGlobals
		{
			public SplendidWizardThis THIS;
		}

		public class SplendidImportThisGlobals
		{
			public SplendidImportThis THIS;
		}

		public class SplendidReportThisGlobals
		{
			public SplendidReportThis THIS;
		}

		public bool                     Halted                   { get; set; }
		public object                   ThisObject               { get; set; }
		public RuleValidation           Validation               { get; set; }
		public ActivityExecutionContext ActivityExecutionContext { get; set; }
		public RuleLiteralResult        ThisLiteralResult        { get; set; }
		public ScriptOptions            ScriptOptions            { get; set; }
		public object                   Globals                  { get; set; }

		public RuleExecution(RuleValidation validation, object swThis)
		{
			this.Validation = validation;
			this.ThisObject = swThis    ;
			this.ScriptOptions = ScriptOptions.Default.AddReferences("SplendidCRM");
			this.ScriptOptions.AddImports("System");

			if      ( this.ThisObject is SplendidControlThis ) this.Globals = new SplendidControlThisGlobals { THIS = (SplendidControlThis) this.ThisObject };
			else if ( this.ThisObject is SplendidWizardThis  ) this.Globals = new SplendidWizardThisGlobals  { THIS = (SplendidWizardThis ) this.ThisObject };
			else if ( this.ThisObject is SplendidImportThis  ) this.Globals = new SplendidImportThisGlobals  { THIS = (SplendidImportThis ) this.ThisObject };
			else if ( this.ThisObject is SplendidReportThis  ) this.Globals = new SplendidReportThisGlobals  { THIS = (SplendidReportThis ) this.ThisObject };
		}
	}
}
