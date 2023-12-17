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
using System.Runtime.Serialization;
using System.Activities;

namespace SplendidCRM
{
	// https://msdn.microsoft.com/en-us/library/hh314054(v=vs.110).aspx
	[DataContract(Name="SplendidWorkflowIdentity")]
	public class SplendidWorkflowIdentity : WorkflowIdentity
	{
		[DataMember(IsRequired=false, Name="XAML"  )] public string XAML   { get; set; }
		[DataMember(IsRequired=false, Name="CRM_ID")] public Guid   CRM_ID { get; set; }

		public SplendidWorkflowIdentity(System.Version version, string sXAML, Guid gCRM_ID)
		{
			// 07/21/2016 Paul.  If we use the DLL version, then we will get an error when loading persisted workflows. 
			// The WorkflowIdentity ('SplendidCRM v10.4.6046.42623; Version=10.4.6046.42623') of the loaded instance does not match the WorkflowIdentity ('SplendidCRM v10.4.6046.43071; Version=10.4.6046.43071') 
			// of the provided workflow definition. The instance can be loaded using a different definition, or updated using Dynamic Update.
			version = new System.Version(11, 0, 0, 0);
			this.Name    = "SplendidCRM v" + version.ToString();
			this.Version = version;
			this.XAML    = sXAML  ;
			this.CRM_ID  = gCRM_ID;
		}
	}
}
