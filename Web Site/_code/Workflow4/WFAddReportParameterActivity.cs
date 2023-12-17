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
using System.Runtime.Serialization;
using System.Activities;
using System.Diagnostics;

namespace SplendidCRM
{
	[DataContract(Name="WF4ReportParameter")]
	public class WF4ReportParameter
	{
		[DataMember(IsRequired=false, Name="NAME" , Order=0)] public string NAME  { get; set; }
		[DataMember(IsRequired=false, Name="VALUE"         )] public string VALUE { get; set; }

		public WF4ReportParameter()
		{
			this.NAME  = String.Empty;
			this.VALUE = String.Empty;
		}

		public override string ToString()
		{
			return "WF4ReportParameter: " + NAME + " " + VALUE;
		}
	}

	public class WFAddReportParameterActivity : CodeActivity
	{
		public InArgument<string>                             NAME       { get; set; }
		// 12/09/2017 Paul.  Need to allow Guid to String conversion. 
		// 11/11/2023 Paul.  Cannot use object. 
		// The private implementation of activity '1: DynamicActivity' has the following validation error: Literal only supports value types and the immutable type System.String. The type System.Object cannot be used as a literal.
		public InArgument<string>                             VALUE      { get; set; }
		// 12/09/2017 Paul.  Cannot be InOutArgument. 
		public InArgument<ICollection<WF4ReportParameter>>    PARAMETERS { get; set; }

		protected override void Execute(CodeActivityContext context)
		{
			SplendidApplicationService app = context.GetExtension<SplendidApplicationService>();
			SplendidError        SplendidError  = app.SplendidError;

			try
			{
				WF4ReportParameter result = new WF4ReportParameter();
				result.NAME  = context.GetValue<string>(NAME );
				// 12/09/2017 Paul.  Need to allow Guid to String conversion. 
				// 11/19/2023 Paul.  Can't convert to string before calling GetValue.  Must be InArgument or InOutArgument. 
				// XAML needs to wrap guid values in Sql.ToString(), such as [Sql.ToString(ID)]. 
				result.VALUE = context.GetValue<string>(VALUE);
				context.GetValue<ICollection<WF4ReportParameter>>(PARAMETERS).Add(result);
				
				Debug.WriteLine(result.ToString());
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				throw(new Exception("WFAddReportParameterActivity.Execute failed: " + ex.Message, ex));
			}
		}
	}

}
