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
using System.IO;
using System.Xml;
using System.Web;
using System.Globalization;
using System.Workflow.Runtime;
using System.Workflow.ComponentModel;
//using System.Workflow.ComponentModel.Serialization;
using System.Reflection;

namespace SplendidCRM
{
	/// <summary>
	/// Summary description for XomlUtils.
	/// </summary>
	public class XomlUtils
	{
		// http://www.codeplex.com/WFTools
		public static bool IsXomlWorkflow(Activity rootActivity)
		{
			//HACK
			// retrieve the 'WorkflowXamlMarkupProperty' dependency property
			// from the activity using reflection, must be a better way of doing this?!
			// this method of doing things is stolen from System.Workflow using
			// reflector...
			BindingFlags bindingFlags = BindingFlags.NonPublic | BindingFlags.Static | BindingFlags.Public;
			FieldInfo fieldInfo = typeof (Activity).GetField("WorkflowXamlMarkupProperty", bindingFlags);
			// 02/07/2010 Paul.  Defensive programming, check fieldInfo for null. 
			if ( fieldInfo != null )
			{
				DependencyProperty dependencyProperty = (DependencyProperty)fieldInfo.GetValue(null);
				string workflowXaml = rootActivity.GetValue(dependencyProperty) as string;
				if ( !string.IsNullOrEmpty(workflowXaml) )
					return true;
			}
			return false;
		}

		public static string GetXomlDocument(Activity activity)
		{
			string sXOML = String.Empty;
			using ( StringWriter stm = new StringWriter(CultureInfo.InvariantCulture) )
			{
				XmlWriterSettings xset = new XmlWriterSettings();
				xset.Indent             = true;
				xset.IndentChars        = ControlChars.Tab.ToString();
				xset.OmitXmlDeclaration = true;
				xset.CloseOutput        = true;
				using ( XmlWriter xmlWriter = XmlWriter.Create(stm, xset) )
				{
					(new WorkflowMarkupSerializer()).Serialize(xmlWriter, activity);
					sXOML = stm.ToString();
				}
			}
			return sXOML;
		}

		// 07/15/2010 Paul.  Use new function to format Xoml. 
		public static string XomlEncode(string sXOML)
		{
			string sDump = HttpUtility.HtmlEncode(sXOML);
			sDump = sDump.Replace("\n", "<br />\n");
			sDump = sDump.Replace("\t", "&nbsp;&nbsp;&nbsp;");
			sDump = "<div class=\"SourceCode\" style=\"width: 100%; border: 1px solid black; \">" + sDump + "</div>";
			return sDump;
		}
	}
}
