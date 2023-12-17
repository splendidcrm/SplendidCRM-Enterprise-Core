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
using System.Reflection;

namespace System.Workflow.ComponentModel
{
	public enum DependencyPropertyOptions : byte
	{
		Default = 1,
		ReadOnly = 2,
		Optional = 4,
		Metadata = 8,
		NonSerialized = 16,
		DelegateProperty = 32
	}

	public delegate object GetValueOverride(DependencyObject d);
	public delegate void SetValueOverride(DependencyObject d, object value);

	public class PropertyMetadata
	{
		public object DefaultValue
		{
			get;
			set;
		}
		public GetValueOverride GetValueOverride
		{
			get;
			set;
		}
		public bool IsMetaProperty
		{
			get;
		}
		public bool IsNonSerialized
		{
			get;
		}
		public bool IsReadOnly
		{
			get;
		}
		protected bool IsSealed
		{
			get;
		}
		public DependencyPropertyOptions Options
		{
			get;
			set;
		}
		public SetValueOverride SetValueOverride
		{
			get;
			set;
		}
	}
}
