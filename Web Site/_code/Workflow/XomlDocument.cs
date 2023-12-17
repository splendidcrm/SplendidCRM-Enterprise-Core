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
using System.Collections;
using System.Xml;

namespace SplendidCRM
{
	public class XomlDocument : XmlDocument
	{
		private XmlUtil              XmlUtil            ;

		public static string sDefaultNamespace  = "http://schemas.microsoft.com/winfx/2006/xaml/workflow";
		public static string sWinfxNamespace    = "http://schemas.microsoft.com/winfx/2006/xaml";
		public static string sSplendidNamespace = "clr-namespace:SplendidCRM;Assembly=SplendidCRM";

		private XmlNamespaceManager nsmgr;

		public XmlNode SelectNode(string sNode)
		{
			return XmlUtil.SelectNode(this, sNode, nsmgr);
		}

		public XmlNode SelectNode(XmlNode parent, string sNode)
		{
			return XmlUtil.SelectNode(parent, sNode, nsmgr);
		}

		public string SelectNodeValue(string sNode)
		{
			string sValue = String.Empty;
			XmlNode xValue = XmlUtil.SelectNode(this, sNode, nsmgr);
			if ( xValue != null )
				sValue = xValue.InnerText;
			return sValue;
		}

		public string SelectNodeAttribute(string sNode, string sAttribute)
		{
			string sValue = String.Empty;
			XmlNode xNode = null;
			if ( sNode == String.Empty )
				xNode = this.DocumentElement;
			else
				xNode = XmlUtil.SelectNode(this, sNode, nsmgr);
			if ( xNode != null )
			{
				if ( xNode.Attributes != null )
				{
					XmlNode xValue = xNode.Attributes.GetNamedItem(sAttribute);
					if ( xValue != null )
						sValue = xValue.Value;
				}
			}
			return sValue;
		}

		public string SelectNodeValue(XmlNode parent, string sNode)
		{
			return XmlUtil.SelectSingleNode(parent, sNode, nsmgr);
		}

		public XmlNodeList SelectNodesNS(string sXPath)
		{
			string[] arrXPath = sXPath.Split('/');
			for ( int i = 0; i < arrXPath.Length; i++ )
			{
				// 06/20/2006 Paul.  The default namespace cannot be selected, so create an alias and reference the alias. 
				if ( arrXPath[i].IndexOf(':') < 0 )
					arrXPath[i] = "defaultns:" + arrXPath[i];
			}
			sXPath = String.Join("/", arrXPath);
			return this.DocumentElement.SelectNodes(sXPath, nsmgr);
		}

		public XmlNodeList SelectNodesNS(XmlNode parent, string sXPath)
		{
			string[] arrXPath = sXPath.Split('/');
			for ( int i = 0; i < arrXPath.Length; i++ )
			{
				// 06/20/2006 Paul.  The default namespace cannot be selected, so create an alias and reference the alias. 
				if ( arrXPath[i].IndexOf(':') < 0 )
					arrXPath[i] = "defaultns:" + arrXPath[i];
			}
			sXPath = String.Join("/", arrXPath);
			return parent.SelectNodes(sXPath, nsmgr);
		}

		public void SetSingleNode(string sNode, string sValue)
		{
			XmlUtil.SetSingleNode(this, sNode, sValue, nsmgr, sSplendidNamespace);
		}

		public void SetSingleNode(XmlNode parent, string sNode, string sValue)
		{
			XmlUtil.SetSingleNode(this, parent, sNode, sValue, nsmgr, sSplendidNamespace);
		}

		public void SetSingleNodeAttribute(string sNode, string sAttribute, string sValue)
		{
			XmlUtil.SetSingleNodeAttribute(this, sNode, sAttribute, sValue, nsmgr, sSplendidNamespace);
		}

		public void SetSingleNodeAttribute(XmlNode parent, string sAttribute, string sValue)
		{
			XmlUtil.SetSingleNodeAttribute(this, parent, sAttribute, sValue, nsmgr, sSplendidNamespace);
		}

		public void SetNameAttribute(XmlNode parent, string sValue)
		{
			XmlAttribute xName = this.CreateAttribute("x", "Name", sDefaultNamespace);
			xName.Value = sValue;
			parent.Attributes.Append(xName);
		}

		public void SetAttribute(XmlNode parent, string sName, string sValue)
		{
			XmlAttribute xAttribute = this.CreateAttribute(sName);
			xAttribute.Value = sValue;
			parent.Attributes.Append(xAttribute);
		}

		public XmlNode CreateActivity(XmlNode parent, string sActivityName)
		{
			parent.AppendChild(this.CreateWhitespace("\t"));
			XmlNode xActivity = this.CreateElement("crm", sActivityName, sSplendidNamespace);
			parent.AppendChild(xActivity);
			parent.AppendChild(this.CreateWhitespace("\n"));
			return xActivity;
		}

		// 05/04/2009 Paul.  We need to parse the RVALUE and append activity bindings.  The workflow engine will not do this for us. 
		private ArrayList ParseActivityTokens(string sRVALUE)
		{
			if ( String.IsNullOrEmpty(sRVALUE) )
				return null;
			
			ArrayList lst = new ArrayList();
			int nStart = 0;
			while ( nStart < sRVALUE.Length )
			{
				int nEnd = sRVALUE.IndexOf("{ActivityBind ", nStart);
				if ( nEnd >= 0 )
				{
					if ( nEnd > nStart )
					{
						// 05/04/2009 Paul.  If there are characters before the activity bind, then extract and add those. 
						lst.Add(sRVALUE.Substring(nStart, nEnd - nStart));
						nStart = nEnd;
					}
					nEnd = sRVALUE.IndexOf("}", nStart);
					if ( nEnd >= 0 )
					{
						// 05/04/2009 Paul.  Include the end token. 
						nEnd++;
						lst.Add(sRVALUE.Substring(nStart, nEnd - nStart));
					}
					else
					{
						// 05/04/2009 Paul.  If the end token was not found, then jump to the end of the string. 
						nEnd = sRVALUE.Length;
						lst.Add(sRVALUE.Substring(nStart, nEnd - nStart));
					}
				}
				else
				{
					// 05/04/2009 Paul.  If the activity bind token was not found, then jump to the end of the string. 
					nEnd = sRVALUE.Length;
					lst.Add(sRVALUE.Substring(nStart, nEnd - nStart));
				}
				nStart = nEnd;
			}
			return lst;
		}

		public XmlNode CreateSetValueActivity(XmlNode parent, string sActivityName, string sDATA_FIELD, string sRVALUE, string sOPERATOR)
		{
			// 05/04/2009 Paul.  We need to parse the RVALUE and append activity bindings.  The workflow engine will not do this for us. 
			ArrayList lst = null;
			// 07/13/2010 Paul.  equalsURL is a special operator that means that we need to escape activity bindings. 
			if ( sOPERATOR.StartsWith("equals") && sRVALUE.IndexOf("{ActivityBind ") >= 0 )
			{
				lst = ParseActivityTokens(sRVALUE);
			}
			XmlNode xSetValue = null;
			if ( lst == null || lst.Count == 1 )
			{
				parent.AppendChild(this.CreateWhitespace("\t"));
				xSetValue = this.CreateActivity(parent, "SetValueActivity");
				XmlAttribute xLvalue   = this.CreateAttribute("LVALUE"  );
				XmlAttribute xRvalue   = this.CreateAttribute("RVALUE"  );
				XmlAttribute xOperator = this.CreateAttribute("OPERATOR");
				// 08/14/2008 Paul.  Use camel case to make the names easier to read. 
				SetNameAttribute(xSetValue, sActivityName + "_" + CamelCase(sDATA_FIELD));

				xLvalue  .Value = "{ActivityBind " + sActivityName + ",Path=" + sDATA_FIELD + "}";
				xRvalue  .Value = sRVALUE;
				// 07/13/2010 Paul.  We need to turn-off the URL escape if the RValue is not a binding. 
				if ( sOPERATOR == "equalsURL" )
				{
					if ( sRVALUE.StartsWith("{ActivityBind ") )
						xOperator.Value = sOPERATOR;
					else
						xOperator.Value = "equals";
				}
				else
				{
					xOperator.Value = sOPERATOR;
				}
				xSetValue.Attributes.Append(xLvalue  );
				xSetValue.Attributes.Append(xRvalue  );
				xSetValue.Attributes.Append(xOperator);
			}
			else
			{
				for ( int i = 0; i < lst.Count; i++ )
				{
					parent.AppendChild(this.CreateWhitespace("\t"));
					xSetValue = this.CreateActivity(parent, "SetValueActivity");
					XmlAttribute xLvalue   = this.CreateAttribute("LVALUE"  );
					XmlAttribute xRvalue   = this.CreateAttribute("RVALUE"  );
					XmlAttribute xOperator = this.CreateAttribute("OPERATOR");
					// 08/14/2008 Paul.  Use camel case to make the names easier to read. 
					SetNameAttribute(xSetValue, sActivityName + "_" + CamelCase(sDATA_FIELD) + "_append" + i.ToString());

					xLvalue  .Value = "{ActivityBind " + sActivityName + ",Path=" + sDATA_FIELD + "}";
					xRvalue  .Value = Sql.ToString(lst[i]);
					// 07/13/2010 Paul.  We need to turn-off the URL escape if the RValue is not a binding. 
					// We only escape binding parameters as the user is expected to use & and = in the parameter string to build the proper URL. 
					if ( sOPERATOR == "equalsURL" )
					{
						if ( xRvalue.Value.StartsWith("{ActivityBind ") )
							xOperator.Value = (i == 0) ? "equalsURL" : "appendURL";
						else
							xOperator.Value = (i == 0) ? "equals" : "append";
					}
					else
					{
						xOperator.Value = (i == 0) ? "equals" : "append";
					}
					xSetValue.Attributes.Append(xLvalue  );
					xSetValue.Attributes.Append(xRvalue  );
					xSetValue.Attributes.Append(xOperator);
				}
			}
			return xSetValue;
		}

		public XmlNode CreateSetRuleActivity(XmlNode parent, string sActivityName, string sDATA_FIELD, string sRVALUE)
		{
			XmlNode xSetValue = null;
			parent.AppendChild(this.CreateWhitespace("\t"));
			xSetValue = this.CreateActivity(parent, "SetRuleActivity");
			XmlAttribute xLvalue = this.CreateAttribute("LVALUE"         );
			XmlAttribute xParent = this.CreateAttribute("PARENT_ACTIVITY");
			XmlAttribute xRule   = this.CreateAttribute("RULE"           );
			SetNameAttribute(xSetValue, sActivityName + "_" + CamelCase(sDATA_FIELD));

			xLvalue.Value = "{ActivityBind " + sActivityName + ",Path=" + sDATA_FIELD + "}";
			xParent.Value = sActivityName;
			xRule  .Value = sRVALUE      ;
			xSetValue.Attributes.Append(xLvalue);
			xSetValue.Attributes.Append(xParent);
			xSetValue.Attributes.Append(xRule  );
			return xSetValue;
		}

		// 06/20/2014 Paul.  Allow text columns to be added to the list of recipients. 
		public XmlNode CreateAddRecipientActivity(XmlNode parent, string sAlertName, string sRECIPIENT_NAME, string sRECIPIENT_ID, string sRECIPIENT_TYPE, string sSEND_TYPE, string sRECIPIENT_TABLE, string sRECIPIENT_FIELD)
		{
			parent.AppendChild(this.CreateWhitespace("\t"));
			XmlNode      xAddRecipient  = this.CreateActivity(parent, "AddRecipientActivity");
			XmlAttribute xAlertName     = this.CreateAttribute("ALERT_NAME"    );
			XmlAttribute xRecipientName = this.CreateAttribute("RECIPIENT_NAME");
			XmlAttribute xRecipientID   = this.CreateAttribute("RECIPIENT_ID"  );
			XmlAttribute xRecipientType = this.CreateAttribute("RECIPIENT_TYPE");
			XmlAttribute xSendType      = this.CreateAttribute("SEND_TYPE"     );
			// 06/20/2014 Paul.  Allow text columns to be added to the list of recipients.  Need a unique name for this field. 
			if ( Sql.IsEmptyString(sRECIPIENT_FIELD) )
				SetNameAttribute(xAddRecipient, sAlertName + "_" + sRECIPIENT_TYPE + "_" + sRECIPIENT_ID.Replace('-', '_'));
			else
				SetNameAttribute(xAddRecipient, sAlertName + "_" + sRECIPIENT_TYPE + "_" + sRECIPIENT_FIELD.Replace('-', '_'));

			xAlertName    .Value = sAlertName     ;
			xRecipientName.Value = sRECIPIENT_NAME;
			xRecipientID  .Value = sRECIPIENT_ID  ;
			xRecipientType.Value = sRECIPIENT_TYPE;
			xSendType     .Value = sSEND_TYPE     ;
			xAddRecipient.Attributes.Append(xAlertName    );
			xAddRecipient.Attributes.Append(xRecipientName);
			xAddRecipient.Attributes.Append(xRecipientID  );
			xAddRecipient.Attributes.Append(xRecipientType);
			xAddRecipient.Attributes.Append(xSendType     );

			// 06/20/2014 Paul.  Allow text columns to be added to the list of recipients. 
			XmlAttribute xRecipientTable = this.CreateAttribute("RECIPIENT_TABLE");
			XmlAttribute xRecipientField = this.CreateAttribute("RECIPIENT_FIELD");
			xRecipientTable.Value = sRECIPIENT_TABLE;
			xRecipientField.Value = sRECIPIENT_FIELD;
			xAddRecipient.Attributes.Append(xRecipientTable);
			xAddRecipient.Attributes.Append(xRecipientField);
			return xAddRecipient;
		}

		// 06/20/2014 Paul.  Allow text columns to be added to the list of recipients. 
		public XmlNode CreateAddRecipientActivity(XmlNode parent, string sAlertName, string sActivityName, string sRECIPIENT_NAME, string sRECIPIENT_ID, string sRECIPIENT_TYPE, string sSEND_TYPE, string sRECIPIENT_TABLE, string sRECIPIENT_FIELD)
		{
			parent.AppendChild(this.CreateWhitespace("\t"));
			XmlNode      xAddRecipient  = this.CreateActivity(parent, "AddRecipientActivity");
			XmlAttribute xAlertName     = this.CreateAttribute("ALERT_NAME"    );
			XmlAttribute xRecipientName = this.CreateAttribute("RECIPIENT_NAME");
			XmlAttribute xRecipientID   = this.CreateAttribute("RECIPIENT_ID"  );
			XmlAttribute xRecipientType = this.CreateAttribute("RECIPIENT_TYPE");
			XmlAttribute xSendType      = this.CreateAttribute("SEND_TYPE"     );
			// 06/20/2014 Paul.  Allow text columns to be added to the list of recipients.  Need a unique name for this field. 
			if ( Sql.IsEmptyString(sRECIPIENT_FIELD) )
				SetNameAttribute(xAddRecipient, sAlertName + "_" + sActivityName + "_" + CamelCase(sRECIPIENT_ID));
			else
				SetNameAttribute(xAddRecipient, sAlertName + "_" + sActivityName + "_" + CamelCase(sRECIPIENT_FIELD));

			xAlertName    .Value = sAlertName     ;
			xRecipientName.Value = sRECIPIENT_NAME;
			xRecipientID  .Value = "{ActivityBind " + sActivityName + ",Path=" + sRECIPIENT_ID + "}";
			xRecipientType.Value = sRECIPIENT_TYPE;
			xSendType     .Value = sSEND_TYPE     ;
			xAddRecipient.Attributes.Append(xAlertName    );
			xAddRecipient.Attributes.Append(xRecipientName);
			xAddRecipient.Attributes.Append(xRecipientID  );
			xAddRecipient.Attributes.Append(xRecipientType);
			xAddRecipient.Attributes.Append(xSendType     );

			// 06/20/2014 Paul.  Allow text columns to be added to the list of recipients. 
			XmlAttribute xRecipientTable = this.CreateAttribute("RECIPIENT_TABLE");
			XmlAttribute xRecipientField = this.CreateAttribute("RECIPIENT_FIELD");
			xRecipientTable.Value = sRECIPIENT_TABLE;
			xRecipientField.Value = sRECIPIENT_FIELD;
			xAddRecipient.Attributes.Append(xRecipientTable);
			xAddRecipient.Attributes.Append(xRecipientField);
			return xAddRecipient;
		}

		public XmlNode CreateCodeActivity(XmlNode parent, string sActivityName, string sMethodName)
		{
			parent.AppendChild(this.CreateWhitespace("\n\t\t"));
			XmlNode xCodeActivity = this.CreateElement("CodeActivity", sDefaultNamespace);
			parent.AppendChild(xCodeActivity);
			parent.AppendChild(this.CreateWhitespace("\n\t"));

			string sExecuteCode = "{ActivityBind " + sActivityName + ",Path=" + sMethodName + "}";
			SetNameAttribute(xCodeActivity, sActivityName + "_" + sMethodName);
			
			XmlAttribute xExecuteCode = this.CreateAttribute("ExecuteCode");
			xExecuteCode.Value = sExecuteCode;
			xCodeActivity.Attributes.Append(xExecuteCode);
			return xCodeActivity;
		}

		// 07/13/2010 Paul.  We need to be able to add multiple code activities. 
		public XmlNode CreateCodeActivity(XmlNode parent, string sActivityName, string sMethodName, int nIndex)
		{
			parent.AppendChild(this.CreateWhitespace("\n\t\t"));
			XmlNode xCodeActivity = this.CreateElement("CodeActivity", sDefaultNamespace);
			parent.AppendChild(xCodeActivity);
			parent.AppendChild(this.CreateWhitespace("\n\t"));

			string sExecuteCode = "{ActivityBind " + sActivityName + ",Path=" + sMethodName + "}";
			SetNameAttribute(xCodeActivity, sActivityName + "_" + sMethodName + "_" + nIndex.ToString());
			
			XmlAttribute xExecuteCode = this.CreateAttribute("ExecuteCode");
			xExecuteCode.Value = sExecuteCode;
			xCodeActivity.Attributes.Append(xExecuteCode);
			return xCodeActivity;
		}

		public XmlNode CreateParallelActivity(XmlNode parent, string sName)
		{
			parent.AppendChild(this.CreateWhitespace("\n"));
			XmlNode xParallelActivity = this.CreateElement("ParallelActivity", sDefaultNamespace);
			parent.AppendChild(xParallelActivity);
			parent.AppendChild(this.CreateWhitespace("\n"));
			xParallelActivity.AppendChild(this.CreateWhitespace("\n\t"));
			SetNameAttribute(xParallelActivity, sName);
			return xParallelActivity;
		}

		public XmlNode CreateSequenceActivity(XmlNode parent, string sName)
		{
			parent.AppendChild(this.CreateWhitespace("\n"));
			XmlNode xSequenceActivity = this.CreateElement("SequenceActivity", sDefaultNamespace);
			parent.AppendChild(xSequenceActivity);
			parent.AppendChild(this.CreateWhitespace("\n"));
			xSequenceActivity.AppendChild(this.CreateWhitespace("\n\t"));
			SetNameAttribute(xSequenceActivity, sName);
			return xSequenceActivity;
		}
/*
		public XmlNode CreateCodeActivity(XmlNode parent, string sExecuteCode)
		{
			parent.AppendChild(this.CreateWhitespace("\n\t\t"));
			XmlNode xCodeActivity = this.CreateElement("CodeActivity", sDefaultNamespace);
			parent.AppendChild(xCodeActivity);
			parent.AppendChild(this.CreateWhitespace("\n\t"));

			// 08/13/2008 Paul.  Unnamed code activities seem to have a problem.  Build the name from the code. 
			if ( sExecuteCode.StartsWith("{ActivityBind ") )
			{
				string sName = sExecuteCode.Substring(1, sExecuteCode.Length-2);
				sName = sName.Replace("ActivityBind ", "");
				sName = sName.Replace(",Path="       , "_");
				SetNameAttribute(xCodeActivity, sName);
			}
			
			XmlAttribute xExecuteCode = this.CreateAttribute("ExecuteCode");
			xExecuteCode.Value = sExecuteCode;
			xCodeActivity.Attributes.Append(xExecuteCode);
			return xCodeActivity;
		}
*/

		/*
		try
		{
			// 08/01/2008 Paul.  Not sure why this is not working. We should be able to select all nodes with a matching name. 
			xActivity = this.DocumentElement.SelectSingleNode("[@x:Name=\'" + sActivityName + "\']", nsmgr);
		}
		catch//(Exception ex)
		{
		}
		*/
		public XmlNode SelectActivityName(XmlNode parent, string sActivityName)
		{
			// 10/11/2008 Paul.  Manually search for the activity. 
			if ( parent != null )
			{
				if ( parent.Attributes != null )
				{
					foreach ( XmlAttribute att in parent.Attributes )
					{
						if ( att.Name == "x:Name" && att.Value == sActivityName )
							return parent;
					}
				}
				foreach ( XmlNode node in parent.ChildNodes )
				{
					if ( node.NodeType == XmlNodeType.Element )
					{
						XmlNode xActivity = SelectActivityName(node, sActivityName);
						if ( xActivity != null )
							return xActivity;
					}
				}
			}
			return null;
		}

		public XomlDocument(XmlUtil XmlUtil) : base()
		{
			this.XmlUtil             = XmlUtil            ;
		}


		public XomlDocument(XmlUtil XmlUtil, string sNAME, Guid gWORKFLOW_ID) : base()
		{
			this.XmlUtil             = XmlUtil            ;

			//this.AppendChild(this.CreateXmlDeclaration("1.0", "UTF-8", null));
			this.PreserveWhitespace = true;

			nsmgr = new XmlNamespaceManager(this.NameTable);
			nsmgr.AddNamespace(""         , sDefaultNamespace );
			nsmgr.AddNamespace("x"        , sWinfxNamespace   );
			nsmgr.AddNamespace("crm"      , sSplendidNamespace);
			// 06/20/2006 Paul.  The default namespace cannot be selected, so create an alias and reference the alias. 
			nsmgr.AddNamespace("defaultns", sDefaultNamespace );

			XmlNode root = this.CreateElement("crm", "SplendidSequentialWorkflow", sSplendidNamespace);
			this.AppendChild(root);
			root.AppendChild(this.CreateWhitespace("\n"));
			SetNameAttribute(root, sNAME);
			// 08/09/2008 Paul.  The primary location for the WORKFLOW_ID will be in the SplendidSequentialWorkflow
			XmlUtil.SetSingleNodeAttribute(this, this.DocumentElement, "WORKFLOW_ID", gWORKFLOW_ID.ToString());

			// 08/01/2008 Paul.  Add the RD namespace manually. 
			XmlUtil.SetSingleNodeAttribute(this, this.DocumentElement, "xmlns:crm", sSplendidNamespace);
			XmlUtil.SetSingleNodeAttribute(this, this.DocumentElement, "xmlns:x"  , sWinfxNamespace   );
			XmlUtil.SetSingleNodeAttribute(this, this.DocumentElement, "xmlns"    , sDefaultNamespace );
		}

		public void LoadXoml(string xoml)
		{
			base.LoadXml(xoml);
			nsmgr = new XmlNamespaceManager(this.NameTable);
			nsmgr.AddNamespace(""         , sDefaultNamespace );
			// 08/01/2008 Paul.  The Winfx namespace must be manually added. 
			nsmgr.AddNamespace("x"        , sWinfxNamespace   );
			nsmgr.AddNamespace("crm"      , sSplendidNamespace);
			// 06/20/2006 Paul.  The default namespace cannot be selected, so create an alias and reference the alias. 
			nsmgr.AddNamespace("defaultns", sDefaultNamespace );
		}

		public static string CamelCase(string sName)
		{
			string[] arrName = sName.Split('_');
			for ( int i = 0; i < arrName.Length; i++ )
			{
				if( String.Compare(arrName[i], "ID", true) == 0 )
					arrName[i] = arrName[i].ToUpper();
				else
					arrName[i] = arrName[i].Substring(0, 1).ToUpper() + arrName[i].Substring(1).ToLower();
			}
			sName = String.Join("", arrName);
			return sName;
		}

	}


}
