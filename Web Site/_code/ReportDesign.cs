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
using System.Xml;
using System.Xml.Serialization;

namespace SplendidCRM
{
	public class ReportDesign
	{
		public class ReportTable
		{
			public string ModuleName ;
			public string TableName  ;
		}
		public class ReportField
		{
			public string TableName    ;
			public string ColumnName   ;
			public string FieldName    ;
			public string AggregateType;
			public string DisplayName  ;
			public string DisplayWidth ;
			public string SortDirection;
		}
		public class ReportJoinField
		{
			public string LeftTableName  ;
			public string LeftColumnName ;
			public string OperatorType   ;
			public string RightTableName ;
			public string RightColumnName;
			
			public string LeftFieldName
			{
				get { return LeftTableName + "." + LeftColumnName; }
			}
			
			public string RightFieldName
			{
				get { return RightTableName + "." + RightColumnName; }
			}
		}
		public class ReportRelationship
		{
			public string            LeftTableName ;
			public string            JoinType      ;
			public string            RightTableName;
			public ReportJoinField[] JoinFields    ;
		}
		[XmlInclude(typeof(System.String[]))]
		public class ReportFilter
		{
			public string  TableName ;
			public string  ColumnName;
			public string  Operator  ;
			public object  Value     ;
			public Boolean Parameter ;
		}

		public Boolean               GroupAndAggregate;
		public ReportTable[]         Tables           ;
		public ReportField[]         SelectedFields   ;
		public ReportRelationship[]  Relationships    ;
		public ReportFilter[]        AppliedFilters   ;
	}
}
