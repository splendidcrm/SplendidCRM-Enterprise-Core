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
using System.Xml.Linq;

namespace SplendidCRM
{
	public static class WorkflowServiceNamespace
	{
		const string baseNamespace = "urn:schemas-microsoft-com:System.ServiceModel.Activities/4.0/properties";
		       static readonly XNamespace workflowServiceNamespace = XNamespace.Get(baseNamespace);
		public static readonly XNamespace endpointsNamespace       = XNamespace.Get(baseNamespace + "/endpoints");
		public static readonly XName      ControlEndpoint          = workflowServiceNamespace.GetName("ControlEndpoint"         );
		public static readonly XName      MessageVersionForReplies = workflowServiceNamespace.GetName("MessageVersionForReplies");
		public static readonly XName      RequestReplyCorrelation  = workflowServiceNamespace.GetName("RequestReplyCorrelation" );
		public static readonly XName      SuspendReason            = workflowServiceNamespace.GetName("SuspendReason"           );
		public static readonly XName      SiteName                 = workflowServiceNamespace.GetName("SiteName"                );
		public static readonly XName      SuspendException         = workflowServiceNamespace.GetName("SuspendException"        );
		public static readonly XName      RelativeApplicationPath  = workflowServiceNamespace.GetName("RelativeApplicationPath" );
		public static readonly XName      RelativeServicePath      = workflowServiceNamespace.GetName("RelativeServicePath"     );
		public static readonly XName      CreationContext          = workflowServiceNamespace.GetName("CreationContext"         );
		public static readonly XName      Service                  = workflowServiceNamespace.GetName("Service"                 );
	}

	public static class WorkflowNamespace
	{
		const string baseNamespace = "urn:schemas-microsoft-com:System.Activities/4.0/properties";
		       static readonly XNamespace workflowNamespace = XNamespace.Get(baseNamespace);
		public static readonly XName      WorkflowHostType  = workflowNamespace.GetName("WorkflowHostType");
		public static readonly XName      Status            = workflowNamespace.GetName("Status"          );
		public static readonly XName      Bookmarks         = workflowNamespace.GetName("Bookmarks"       );
		public static readonly XName      LastUpdate        = workflowNamespace.GetName("LastUpdate"      );
		public static readonly XName      Exception         = workflowNamespace.GetName("Exception"       );
		public static readonly XName      Workflow          = workflowNamespace.GetName("Workflow"        );
		public static readonly XName      KeyProvider       = workflowNamespace.GetName("KeyProvider"     );
	}

	public static class Workflow45Namespace
	{
		const string baseNamespace = "urn:schemas-microsoft-com:System.Activities/4.5/properties";
		       static readonly XNamespace workflow45Namespace      = XNamespace.Get(baseNamespace);
		public static readonly XName      DefinitionIdentity       = workflow45Namespace.GetName("DefinitionIdentity"      );
		public static readonly XName      DefinitionIdentities     = workflow45Namespace.GetName("DefinitionIdentities"    );
		public static readonly XName      DefinitionIdentityFilter = workflow45Namespace.GetName("DefinitionIdentityFilter");
		public static readonly XName      WorkflowApplication      = workflow45Namespace.GetName("WorkflowApplication"     );
		// 06/21/2016 Paul.  SplendidCRM specific entry. 
		public static readonly XName      DefinitionXAML           = workflow45Namespace.GetName("DefinitionXAML"          );
		public static readonly XName      BusinessProcessID        = workflow45Namespace.GetName("BusinessProcessID"       );
	}

	public static class SqlWorkflowInstanceStoreConstants
	{
		       static readonly XNamespace workflowNamespace                   = XNamespace.Get("urn:schemas-microsoft-com:System.Activities/4.0/properties");
		public static readonly XName      LastUpdatePropertyName              = workflowNamespace.GetName("LastUpdate"         );
		public static readonly XName      PendingTimerExpirationPropertyName  = workflowNamespace.GetName("TimerExpirationTime");
		public static readonly XName      BinaryBlockingBookmarksPropertyName = workflowNamespace.GetName("Bookmarks"          );
		public static readonly XName      StatusPropertyName                  = workflowNamespace.GetName("Status"             );
		public const string ExecutingStatusPropertyValue = "Executing";
		public const int    DefaultStringBuilderCapacity = 512;
	}
}
