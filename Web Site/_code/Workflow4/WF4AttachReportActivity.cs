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
using System.Text;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Activities;
using System.Diagnostics;

namespace SplendidCRM
{
	[DataContract(Name="WF4Report")]
	public class WF4Report
	{
		[DataMember(IsRequired=false, Name="REPORT_ID"    , Order=0)] public Guid                     REPORT_ID          { get; set; }
		[DataMember(IsRequired=false, Name="REPORT_NAME"           )] public string                   REPORT_NAME        { get; set; }
		[DataMember(IsRequired=false, Name="RENDER_FORMAT"         )] public string                   RENDER_FORMAT      { get; set; }
		[DataMember(IsRequired=false, Name="SCHEDULED_USER_ID"     )] public Guid                     SCHEDULED_USER_ID  { get; set; }
		[DataMember(IsRequired=false, Name="PARAMETERS"            )] public List<WF4ReportParameter> PARAMETERS         { get; set; }

		public WF4Report()
		{
			this.REPORT_ID         = Guid.Empty;
			this.REPORT_NAME       = String.Empty;
			this.RENDER_FORMAT     = String.Empty;
			this.SCHEDULED_USER_ID = Guid.Empty;
			this.PARAMETERS        = new List<WF4ReportParameter>();
		}

		public override string ToString()
		{
			StringBuilder sbPARAMETERS = new StringBuilder();
			if ( PARAMETERS != null )
			{
				foreach ( WF4ReportParameter parameter in PARAMETERS )
				{
					if ( sbPARAMETERS.Length > 0 )
						sbPARAMETERS.Append(",");
					sbPARAMETERS.Append(parameter.NAME + " = " + parameter.VALUE);
				}
			}
			return "WF4Report: " + REPORT_ID.ToString() + " " + REPORT_NAME + " " + RENDER_FORMAT + " " + sbPARAMETERS.ToString();
		}
	}

	public class WF4AttachReportActivity : CodeActivity
	{
		public InArgument<Guid  >                 REPORT_ID           { get; set; }
		public InArgument<string>                 REPORT_NAME         { get; set; }
		public InArgument<string>                 RENDER_FORMAT       { get; set; }
		public InArgument<Guid  >                 SCHEDULED_USER_ID   { get; set; }
		// 07/17/2016 Paul.  Cannot be InOutArgument. 
		public InArgument<ICollection<WF4Report>> REPORTS             { get; set; }
		// 12/09/2017 Paul.  Needed to add parameters. 
		public InArgument<ICollection<WF4ReportParameter>> PARAMETERS { get; set; }

		protected override void Execute(CodeActivityContext context)
		{
			SplendidApplicationService app = context.GetExtension<SplendidApplicationService>();
			SplendidError        SplendidError  = app.SplendidError;

			try
			{
				WF4Report result = new WF4Report();
				result.REPORT_ID         = context.GetValue<Guid  >(REPORT_ID        );
				result.REPORT_NAME       = context.GetValue<string>(REPORT_NAME      );
				result.RENDER_FORMAT     = context.GetValue<string>(RENDER_FORMAT    );
				// 12/09/2017 Paul.  SCHEDULED_USER_ID was missing. 
				result.SCHEDULED_USER_ID = context.GetValue<Guid  >(SCHEDULED_USER_ID);
				// 12/09/2017 Paul.  Needed to add parameters. 
				foreach ( WF4ReportParameter param in context.GetValue<ICollection<WF4ReportParameter>>(PARAMETERS) )
				{
					result.PARAMETERS.Add(param);
				}
				context.GetValue<ICollection<WF4Report>>(REPORTS).Add(result);
			
				Debug.WriteLine(result.ToString());
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				throw(new Exception("WF4AttachReportActivity.Execute failed: " + ex.Message, ex));
			}
		}
	}

}
