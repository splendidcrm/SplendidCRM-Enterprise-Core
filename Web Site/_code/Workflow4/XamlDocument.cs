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
using System.Xml.Schema;
using System.Text;
using System.Diagnostics;

namespace SplendidCRM
{
	public class XamlDocument : XmlDocument
	{
		private XmlUtil              XmlUtil            ;

		// https://msdn.microsoft.com/en-us/library/system.activities.nativeactivity(v=vs.100).aspx#inheritanceContinued
		private static string sDefaultNamespace = "http://schemas.microsoft.com/netfx/2009/xaml/activities";
		private static string sMcNamespace      = "http://schemas.openxmlformats.org/markup-compatibility/2006";
		private static string sSadNamespace     = "http://schemas.microsoft.com/netfx/2009/xaml/activities/design";
		private static string sSap2010Namespace = "http://schemas.microsoft.com/netfx/2010/xaml/activities/presentation";
		private static string sXNamespace       = "http://schemas.microsoft.com/winfx/2006/xaml";
		private static string sSNamespace       = "clr-namespace:System;assembly=mscorlib";
		private static string sSad1Namespace    = "clr-namespace:System.Activities.Debugger;assembly=System.Activities";
		private static string sScgNamespace     = "clr-namespace:System.Collections.Generic;assembly=mscorlib";
		private static string sScoNamespace     = "clr-namespace:System.Collections.ObjectModel;assembly=mscorlib";
		private static string sMcaNamespace     = "clr-namespace:Microsoft.CSharp.Activities;assembly=System.Activities";
		private static string sMvaNamespace     = "clr-namespace:Microsoft.VisualBasic.Activities;assembly=System.Activities";
		private static string sCrmNamespace     = "clr-namespace:SplendidCRM;assembly=SplendidCRM";

		public string DefaultNamespace { get { return sDefaultNamespace; } }
		public string McNamespace      { get { return sMcNamespace     ; } }
		public string SadNamespace     { get { return sSadNamespace    ; } }
		public string ScoNamespace     { get { return sScoNamespace    ; } }
		public string Sap2010Namespace { get { return sSap2010Namespace; } }
		public string XNamespace       { get { return sXNamespace      ; } }
		public string SNamespace       { get { return sSNamespace      ; } }
		public string Sad1Namespace    { get { return sSad1Namespace   ; } }
		public string ScgNamespace     { get { return sScgNamespace    ; } }
		public string McaNamespace     { get { return sMcaNamespace    ; } }
		public string MvaNamespace     { get { return sMvaNamespace    ; } }
		public string CrmNamespace     { get { return sCrmNamespace    ; } }

		private XmlNamespaceManager nsmgr;
		private StringBuilder sbValidationErrors;

		public XmlNamespaceManager NamespaceManager
		{
			get { return nsmgr; }
		}

		private void ValidationHandler(object sender, ValidationEventArgs args)
		{
			sbValidationErrors.AppendLine(args.Message);
			XmlSchemaValidationException vx = args.Exception as XmlSchemaValidationException;
			// 02/07/2010 Paul.  Defensive programming, also check for valid SourceObject. 
			if ( vx != null && vx.SourceObject != null )
			{
				if ( vx.SourceObject is XmlElement )
				{
					XmlElement xSourceObject = vx.SourceObject as XmlElement;
					sbValidationErrors.AppendLine("Source object for the exception is " + xSourceObject.Name + ". ");
					sbValidationErrors.AppendLine(xSourceObject.OuterXml);
				}
				else if ( vx.SourceObject is XmlAttribute )
				{
					XmlAttribute xSourceObject = vx.SourceObject as XmlAttribute;
					sbValidationErrors.AppendLine("Source object for the exception is " + xSourceObject.Name + ". ");
					sbValidationErrors.AppendLine(xSourceObject.OuterXml);
					if ( xSourceObject.ParentNode != null )
						sbValidationErrors.AppendLine(xSourceObject.ParentNode.OuterXml);
				}
			}
#if DEBUG
			Debug.WriteLine(sbValidationErrors);
#endif
		}

		public void Validate()
		{
			/*
			if ( sDefaultNamespace == "http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition" )
			{
				if ( Utils.CachedFileExists(Context, "~/Reports/RDL 2016 ReportDefinition.xsd") )
				{
					string sRDLSchemaXSD = Context.Server.MapPath("~/Reports/RDL 2016 ReportDefinition.xsd");
					XmlTextReader rdrRDLSchema = new XmlTextReader(sRDLSchemaXSD);
					XmlSchema schRDL = XmlSchema.Read(rdrRDLSchema, new ValidationEventHandler(ValidationHandler));
					this.Schemas.Add(schRDL);
					this.Validate(new ValidationEventHandler(ValidationHandler));
					this.Schemas.Remove(schRDL);
				}
			}
			if ( sbValidationErrors.Length > 0 )
			{
				throw(new Exception("RDL Schema validation failed: " + sbValidationErrors.ToString()));
			}
			*/
		}

		public XamlDocument(XmlUtil XmlUtil) : base()
		{
			this.XmlUtil             = XmlUtil            ;

			sbValidationErrors = new StringBuilder();
			nsmgr = new XmlNamespaceManager(this.NameTable);
			nsmgr.AddNamespace(""         , this.DefaultNamespace);
			nsmgr.AddNamespace("defaultns", this.DefaultNamespace);
			nsmgr.AddNamespace("mc"       , this.McNamespace     );
			nsmgr.AddNamespace("sad"      , this.SadNamespace    );
			nsmgr.AddNamespace("sap2010"  , this.Sap2010Namespace);
			nsmgr.AddNamespace("x"        , this.XNamespace      );
			nsmgr.AddNamespace("s"        , this.SNamespace      );
			nsmgr.AddNamespace("sad1"     , this.Sad1Namespace   );
			nsmgr.AddNamespace("scg"      , this.ScgNamespace    );
			nsmgr.AddNamespace("sco"      , this.ScoNamespace    );
			nsmgr.AddNamespace("mca"      , this.McaNamespace    );
			nsmgr.AddNamespace("mva"      , this.MvaNamespace    );
			nsmgr.AddNamespace("crm"      , this.CrmNamespace    );
			//this.AppendChild(this.CreateXmlDeclaration("1.0", "UTF-8", null));
		}

		public XmlElement CreateRootActivity()
		{
			XmlElement xActivity = this.CreateElement("Activity", this.DefaultNamespace);
			this.AppendChild(xActivity);
			this.SetSingleNodeAttribute(xActivity, "Ignorable", "sad sap2010", "mc");
			this.SetSingleNodeAttribute(xActivity, "ExpressionActivityEditor.ExpressionActivityEditor", "C#", "sap2010");
			xActivity.SetAttribute("xmlns"          , this.DefaultNamespace);
			xActivity.SetAttribute("xmlns:mc"       , this.McNamespace     );
			xActivity.SetAttribute("xmlns:sad"      , this.SadNamespace    );
			xActivity.SetAttribute("xmlns:sap2010"  , this.Sap2010Namespace);
			xActivity.SetAttribute("xmlns:x"        , this.XNamespace      );
			xActivity.SetAttribute("xmlns:s"        , this.SNamespace      );
			xActivity.SetAttribute("xmlns:sad1"     , this.Sad1Namespace   );
			xActivity.SetAttribute("xmlns:scg"      , this.ScgNamespace    );
			xActivity.SetAttribute("xmlns:sco"      , this.ScoNamespace    );
			xActivity.SetAttribute("xmlns:mca"      , this.McaNamespace    );
			xActivity.SetAttribute("xmlns:mva"      , this.MvaNamespace    );
			xActivity.SetAttribute("xmlns:crm"      , this.CrmNamespace    );

			// https://blogs.msdn.microsoft.com/tilovell/2012/05/24/wf4-5-using-csharpvaluet-and-csharpreferencet-in-net-4-5-compiling-expressionsand-changes-in-visual-studio-generated-xaml/
			/*
			sap2010:ExpressionActivityEditor.ExpressionActivityEditor=C#
			<TextExpression.NamespacesForImplementation>
				<sco:Collection x:TypeArguments=�x:String�>
					<x:String>System</x:String>
					<x:String>System.Collections.Generic</x:String>
					<x:String>System.Data</x:String>
					<x:String>System.Linq</x:String>
					<x:String>System.Text</x:String>
				</sco:Collection>
			</TextExpression.NamespacesForImplementation>
			<TextExpression.ReferencesForImplementation>
				<sco:Collection x:TypeArguments=�AssemblyReference�>
					<AssemblyReference>Microsoft.CSharp</AssemblyReference>
					<AssemblyReference>System</AssemblyReference>
					<AssemblyReference>System.Activities</AssemblyReference>
					<AssemblyReference>System.Core</AssemblyReference>
					<AssemblyReference>System.Data</AssemblyReference>
					<AssemblyReference>System.Runtime.Serialization</AssemblyReference>
					<AssemblyReference>System.ServiceModel</AssemblyReference>
					<AssemblyReference>System.ServiceModel.Activities</AssemblyReference>
					<AssemblyReference>System.Xaml</AssemblyReference>
					<AssemblyReference>System.Xml</AssemblyReference>
					<AssemblyReference>System.Xml.Linq</AssemblyReference>
					<AssemblyReference>mscorlib</AssemblyReference>
					<AssemblyReference>SplendidCRM</AssemblyReference>
				</sco:Collection>
			</TextExpression.ReferencesForImplementation>
			*/
			XmlElement xTextExpressionNamespaces = this.CreateTextExpressionNamespaces(xActivity);
			this.CreateCollection(xTextExpressionNamespaces, "System"                        );
			this.CreateCollection(xTextExpressionNamespaces, "System.Data"                   );
			this.CreateCollection(xTextExpressionNamespaces, "System.Linq"                   );
			this.CreateCollection(xTextExpressionNamespaces, "System.Text"                   );
			this.CreateCollection(xTextExpressionNamespaces, "System.Collections.Generic"    );
			this.CreateCollection(xTextExpressionNamespaces, "System.Collections.Specialized");
			this.CreateCollection(xTextExpressionNamespaces, "SplendidCRM"                   );

			XmlElement xTextExpressionReferences = this.CreateTextExpressionReferences(xActivity);
			this.CreateAssemblyReference(xTextExpressionReferences, "System"                        );
			this.CreateAssemblyReference(xTextExpressionReferences, "System.Core"                   );
			this.CreateAssemblyReference(xTextExpressionReferences, "System.Data"                   );
			this.CreateAssemblyReference(xTextExpressionReferences, "System.Xml"                    );
			this.CreateAssemblyReference(xTextExpressionReferences, "System.Xml.Linq"               );
			this.CreateAssemblyReference(xTextExpressionReferences, "System.Runtime.Serialization"  );
			this.CreateAssemblyReference(xTextExpressionReferences, "System.ServiceModel"           );
			this.CreateAssemblyReference(xTextExpressionReferences, "System.ServiceModel.Activities");
			this.CreateAssemblyReference(xTextExpressionReferences, "System.Xaml"                   );
			this.CreateAssemblyReference(xTextExpressionReferences, "System.Activities"             );
			this.CreateAssemblyReference(xTextExpressionReferences, "Microsoft.CSharp"              );
			this.CreateAssemblyReference(xTextExpressionReferences, "mscorlib"                      );
			this.CreateAssemblyReference(xTextExpressionReferences, "SplendidCRM"                   );
			return xActivity;
		}

/*
		public void LoadXaml(string sXaml)
		{
			base.LoadXml(sXaml);
			sbValidationErrors = new StringBuilder();
			nsmgr = new XmlNamespaceManager(this.NameTable);
			nsmgr.AddNamespace(""         , this.DefaultNamespace);
			nsmgr.AddNamespace("defaultns", this.DefaultNamespace);
			nsmgr.AddNamespace("mc"       , this.McNamespace     );
			nsmgr.AddNamespace("sad"      , this.SadNamespace    );
			nsmgr.AddNamespace("sap2010"  , this.Sap2010Namespace);
			nsmgr.AddNamespace("x"        , this.XNamespace      );
			nsmgr.AddNamespace("s"        , this.SNamespace      );
			nsmgr.AddNamespace("sad1"     , this.Sad1Namespace   );
			nsmgr.AddNamespace("scg"      , this.ScgNamespace    );
			nsmgr.AddNamespace("sco"      , this.ScoNamespace    );
			nsmgr.AddNamespace("mca"      , this.McaNamespace    );
			nsmgr.AddNamespace("mva"      , this.MvaNamespace    );
			nsmgr.AddNamespace("crm"      , this.CrmNamespace    );

			bool bValidate = false;
#if DEBUG
			//bValidate = true;
#endif
			if ( bValidate )
			{
				Validate(HttpContext.Current);
			}
		}
*/

		#region SelectNode
		public string OutputFormatted()
		{
			//return this.OuterXml;
			using ( StringWriter stm = new StringWriter() )
			{
				using ( XmlTextWriter writer = new XmlTextWriter(stm) )
				{
					writer.Formatting = Formatting.Indented;
					writer.Indentation = 1;
					writer.IndentChar  = '\t';
					this.Save(writer);
				}
				return stm.ToString();
			}
		}

		public XmlNode SelectNode(string sNode)
		{
			return XmlUtil.SelectNode(this, sNode, nsmgr);
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

		public string SelectNodeAttribute(XmlNode parent, string sAttribute)
		{
			string sValue = String.Empty;
			if ( parent != null )
			{
				if ( parent.Attributes != null )
				{
					XmlNode xValue = parent.Attributes.GetNamedItem(sAttribute);
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
			XmlUtil.SetSingleNode(this, sNode, sValue, nsmgr, sDefaultNamespace);
		}

		// 11/20/2011 Paul.  Charting needs a way to skip updating if value exists. 
		public void SetSingleNode_InsertOnly(string sNode, string sValue)
		{
			XmlUtil.SetSingleNode_InsertOnly(this, sNode, sValue, nsmgr, sDefaultNamespace);
		}

		public void SetSingleNode(XmlNode parent, string sNode, string sValue)
		{
			XmlUtil.SetSingleNode(this, parent, sNode, sValue, nsmgr, sDefaultNamespace);
		}

		public void SetSingleNodeAttribute(string sNode, string sAttribute, string sValue)
		{
			XmlUtil.SetSingleNodeAttribute(this, sNode, sAttribute, sValue, nsmgr, sDefaultNamespace);
		}

		public void SetSingleNodeAttribute(XmlNode parent, string sAttribute, string sValue)
		{
			XmlUtil.SetSingleNodeAttribute(this, parent, sAttribute, sValue, nsmgr, sDefaultNamespace);
		}

		public void SetSingleNodeAttribute(XmlNode parent, string sAttribute, string sValue, string sNamespace)
		{
			XmlAttribute xName = this.CreateAttribute(sNamespace, sAttribute, sDefaultNamespace);
			xName.Value = sValue;
			parent.Attributes.Append(xName);
		}
		#endregion

		#region CreateAttributeValue
		public void CreateAttributeValue(XmlNode parent, string name, string value)
		{
			XmlAttribute xAttribute = this.CreateAttribute(name);
			xAttribute.Value = value;
			parent.Attributes.Append(xAttribute);
		}

		public void CreateAttributeValueReference(XmlNode parent, string name, string sReference)
		{
			XmlAttribute xAttribute = this.CreateAttribute(name);
			xAttribute.Value = "[" + sReference + "]";
			parent.Attributes.Append(xAttribute);
		}

		public void CreateAttributeValue(XmlNode parent, string qualifiedName, string value, string namespaceURI)
		{
			XmlAttribute xAttribute = this.CreateAttribute(qualifiedName, namespaceURI);
			xAttribute.Value = value;
			parent.Attributes.Append(xAttribute);
		}

		public void CreateAttributeValue(XmlNode parent, string prefix, string localName, string value, string namespaceURI)
		{
			XmlAttribute xAttribute = this.CreateAttribute(prefix, localName, namespaceURI);
			xAttribute.Value = value;
			parent.Attributes.Append(xAttribute);
		}
		#endregion

		public XmlElement CreateTextExpressionNamespaces(XmlNode parent)
		{
			XmlElement xTextExpressionNamespaces = this.CreateElement("TextExpression.NamespacesForImplementation", this.DefaultNamespace);
			parent.AppendChild(xTextExpressionNamespaces);
			
			XmlElement xNamespacesCollection = this.CreateElement("sco", "Collection", this.ScoNamespace);
			xTextExpressionNamespaces.AppendChild(xNamespacesCollection);
			
			this.CreateAttributeValue(xNamespacesCollection, "x", "TypeArguments", "x:String", this.XNamespace);
			return xNamespacesCollection;
		}

		public XmlNode CreateCollection(XmlNode parent, string sName)
		{
			XmlElement xCollection = this.CreateElement("x", "String", this.XNamespace);
			parent.AppendChild(xCollection);
			xCollection.InnerText = sName;
			return xCollection;
		}

		public XmlElement CreateTextExpressionReferences(XmlNode parent)
		{
			XmlElement xTextExpressionReferences = this.CreateElement("TextExpression.ReferencesForImplementation", this.DefaultNamespace);
			parent.AppendChild(xTextExpressionReferences);
			
			XmlElement xReferencesCollection = this.CreateElement("sco", "Collection", this.ScoNamespace);
			xTextExpressionReferences.AppendChild(xReferencesCollection);
			
			this.CreateAttributeValue(xReferencesCollection, "x", "TypeArguments", "AssemblyReference", this.XNamespace);
			return xReferencesCollection;
		}

		public XmlNode CreateAssemblyReference(XmlNode parent, string sName)
		{
			XmlElement xAssemblyReference = this.CreateElement("AssemblyReference", this.DefaultNamespace);
			parent.AppendChild(xAssemblyReference);
			xAssemblyReference.InnerText = sName;
			return xAssemblyReference;
		}

		public XmlElement CreateMembers(XmlNode parent)
		{
			XmlElement xMembers = this.CreateElement("x", "Members", this.XNamespace);
			parent.AppendChild(xMembers);
			return xMembers;
		}

		public XmlNode CreateProperty(XmlNode parent, string sName, string sType)
		{
			XmlElement xProperty = this.CreateElement("x", "Property", this.XNamespace);
			parent.AppendChild(xProperty);
			
			this.CreateAttributeValue(xProperty, "Name", sName);
			this.CreateAttributeValue(xProperty, "Type", sType);
			return xProperty;
		}

		public XmlElement CreateParallel(XmlNode parent)
		{
			XmlElement xParallel = this.CreateElement("Parallel", this.DefaultNamespace);
			parent.AppendChild(xParallel);
			return xParallel;
		}

		public XmlElement CreateSequence(XmlNode parent, string sBpmnParentID)
		{
			// https://msdn.microsoft.com/en-us/library/system.activities.statements.sequence(v=vs.100).aspx
			XmlElement xSequence = this.CreateElement("Sequence", this.DefaultNamespace);
			parent.AppendChild(xSequence);
			
			// 07/17/2016 Paul.  Can't set Id. 
			this.CreateAttributeValue(xSequence, "x", "Key", sBpmnParentID, this.XNamespace);
			return xSequence;
		}

		public XmlElement CreateSequenceVariables(XmlNode parent)
		{
			XmlElement xSequenceVariables = this.CreateElement("Sequence.Variables", this.DefaultNamespace);
			parent.AppendChild(xSequenceVariables);
			return xSequenceVariables;
		}

		public XmlElement CreateFlowchart(XmlNode parent, string sBpmnParentID)
		{
			// https://msdn.microsoft.com/en-us/library/system.activities.statements.sequence(v=vs.100).aspx
			XmlElement xSequence = this.CreateElement("Flowchart", this.DefaultNamespace);
			parent.AppendChild(xSequence);
			
			// 07/17/2016 Paul.  Can't set Id. 
			this.CreateAttributeValue(xSequence, "x", "Key", sBpmnParentID, this.XNamespace);
			return xSequence;
		}

		public XmlElement CreateFlowchartVariables(XmlNode parent)
		{
			XmlElement xFlowchartVariables = this.CreateElement("Flowchart.Variables", this.DefaultNamespace);
			parent.AppendChild(xFlowchartVariables);
			return xFlowchartVariables;
		}

		public XmlElement CreateFlowchartStartNode(XmlNode parent, string sReference)
		{
			XmlElement xStartNode = this.CreateElement("Flowchart.StartNode", this.DefaultNamespace);
			parent.AppendChild(xStartNode);
			
			this.CreateReference(xStartNode, sReference);
			return xStartNode;
		}

		public XmlElement CreateReference(XmlNode parent, string sReference)
		{
			XmlElement xReference = this.CreateElement("x", "Reference", this.XNamespace);
			xReference.InnerText = sReference;
			parent.AppendChild(xReference);
			return xReference;
		}

		public XmlElement CreateCSharpReference(XmlNode parent, string sType, string sRefName)
		{
			XmlElement xCSharpReference = this.CreateElement("mca", "CSharpReference", this.McaNamespace);
			parent.AppendChild(xCSharpReference);
			this.CreateAttributeValue(xCSharpReference, "x", "TypeArguments", sType, this.XNamespace);
			xCSharpReference.InnerText = sRefName;
			return xCSharpReference;
		}

		public XmlElement CreateCSharpValue(XmlNode parent, string sType, string sValue)
		{
			XmlElement xCSharpReference = this.CreateElement("mca", "CSharpValue", this.McaNamespace);
			parent.AppendChild(xCSharpReference);
			this.CreateAttributeValue(xCSharpReference, "x", "TypeArguments", sType, this.XNamespace);
			xCSharpReference.InnerText = sValue;
			return xCSharpReference;
		}

		public XmlElement CreateFlowStep(XmlNode parent, string sName)
		{
			XmlElement xFlowStep = this.CreateElement("FlowStep", this.DefaultNamespace);
			parent.AppendChild(xFlowStep);
			
			if ( !Sql.IsEmptyString(sName) )
			{
				this.CreateAttributeValue(xFlowStep, "x", "Name", sName, this.XNamespace);
			}
			return xFlowStep;
		}

		public XmlElement CreateFlowStep(XmlNode parent, string sName, string sKey)
		{
			XmlElement xFlowStep = this.CreateElement("FlowStep", this.DefaultNamespace);
			parent.AppendChild(xFlowStep);
			
			this.CreateAttributeValue(xFlowStep, "x", "Key" , sKey , this.XNamespace);
			this.CreateAttributeValue(xFlowStep, "x", "Name", sName, this.XNamespace);
			return xFlowStep;
		}

		public XmlElement CreateFlowStepNext(XmlNode parent, string sReference)
		{
			XmlElement xFlowStep = this.CreateElement("FlowStep.Next", this.DefaultNamespace);
			parent.AppendChild(xFlowStep);
			
			this.CreateReference(xFlowStep, sReference);
			return xFlowStep;
		}

		public XmlElement CreateFlowStepDefault(XmlNode parent, string sReference)
		{
			XmlElement xFlowStep = this.CreateElement("FlowSwitch.Default", this.DefaultNamespace);
			parent.AppendChild(xFlowStep);
			
			this.CreateReference(xFlowStep, sReference);
			return xFlowStep;
		}

		public XmlElement CreateFlowDecision(XmlNode parent, string sCondition)
		{
			XmlElement xFlowDecision = this.CreateElement("FlowDecision", this.DefaultNamespace);
			parent.AppendChild(xFlowDecision);
			
			this.CreateAttributeValue(xFlowDecision, "Condition", sCondition);
			return xFlowDecision;
		}

		public XmlElement CreateFlowDecision(XmlNode parent, bool bTrueFalse)
		{
			XmlElement xFlowDecision = this.CreateElement("FlowDecision." + (bTrueFalse ? "True" : "False"), this.DefaultNamespace);
			parent.AppendChild(xFlowDecision);
			
			return xFlowDecision;
		}

		public XmlElement CreatePick(XmlNode parent)
		{
			XmlElement xPick = this.CreateElement("Pick", this.DefaultNamespace);
			parent.AppendChild(xPick);
			return xPick;
		}

		public XmlElement CreatePickBranch(XmlNode parent, string sDisplayName)
		{
			XmlElement xPickBranch = this.CreateElement("PickBranch", this.DefaultNamespace);
			parent.AppendChild(xPickBranch);
			
			if ( !Sql.IsEmptyString(sDisplayName) )
			{
				this.CreateAttributeValue(xPickBranch, "DisplayName", sDisplayName, this.DefaultNamespace);
			}
			return xPickBranch;
		}

		public XmlElement CreatePickBranchTrigger(XmlNode parent)
		{
			XmlElement xPickBranchTrigger = this.CreateElement("PickBranch.Trigger", this.DefaultNamespace);
			parent.AppendChild(xPickBranchTrigger);
			return xPickBranchTrigger;
		}

		public XmlElement CreatePickBranchVariables(XmlNode parent)
		{
			XmlElement xPickBranchVariables = this.CreateElement("PickBranch.Variables", this.DefaultNamespace);
			parent.AppendChild(xPickBranchVariables);
			return xPickBranchVariables;
		}

		public XmlElement CreateFlowSwitch(XmlNode parent, string sName)
		{
			XmlElement xFlowSwitch = this.CreateElement("FlowSwitch", this.DefaultNamespace);
			parent.AppendChild(xFlowSwitch);
			this.CreateAttributeValue(xFlowSwitch, "x", "TypeArguments", "x:String", this.XNamespace);
			this.CreateAttributeValue(xFlowSwitch, "x", "Name"         , sName     , this.XNamespace);
			return xFlowSwitch;
		}

		public XmlElement CreateFlowDecision(XmlNode parent, string sName, string sSequenceFlowID, string sCondition, string sTrueReference)
		{
			XmlElement xFlowDecision = this.CreateElement("FlowDecision", this.DefaultNamespace);
			parent.AppendChild(xFlowDecision);
			this.CreateAttributeValue(xFlowDecision, "x", "Name", sName, this.XNamespace);
			
				XmlElement xFlowDecisionCondition = this.CreateElement("FlowDecision.Condition", this.DefaultNamespace);
				xFlowDecision.AppendChild(xFlowDecisionCondition);
					
					this.CreateCSharpValue(xFlowDecisionCondition, "x:Boolean", sCondition);
				
				XmlElement xFlowDecisionTrue = this.CreateElement("FlowDecision.True", this.DefaultNamespace);
				xFlowDecision.AppendChild(xFlowDecisionTrue);
#if true
			this.CreateReference(xFlowDecisionTrue, sTrueReference);
#else
			XmlElement xFlowStep = this.CreateFlowStep(xFlowDecisionTrue, sSequenceFlowID);
			this.CreateNopActivity(xFlowStep);
			this.CreateFlowStepNext(xFlowStep, sTrueReference);
#endif
			
			XmlElement xFlowDecisionFalse = this.CreateElement("FlowDecision.False", this.DefaultNamespace);
			xFlowDecision.AppendChild(xFlowDecisionFalse);
			return xFlowDecisionFalse;
		}

		public XmlElement CreateVariable(XmlNode parent, string sName, string sType, string sDefault)
		{
			// 12/09/2017 Paul.  Default namespace must be specified, otherwise variable will not be found. 
			XmlElement xVariable = parent.SelectSingleNode("defaultns:Variable[@Name='" + sName + "']", this.NamespaceManager) as XmlElement;
			if ( xVariable == null )
			{
				xVariable = this.CreateElement("Variable", this.DefaultNamespace);
				parent.AppendChild(xVariable);
				this.CreateAttributeValue(xVariable, "Name", sName);
				this.CreateAttributeValue(xVariable, "x", "TypeArguments", sType, this.XNamespace);
			
				// 09/06/2016 Paul.  Use equals to indicate an expression. 
				if ( sDefault.StartsWith("=") )
				{
					XmlElement xVariableDefault = this.CreateElement("Variable.Default", this.DefaultNamespace);
					xVariable.AppendChild(xVariableDefault);
					this.CreateAttributeValue(xVariableDefault, "x", "TypeArguments", sType, this.XNamespace);
						
						this.CreateCSharpValue(xVariableDefault, sType, sDefault.Substring(1));
				}
				else if ( !Sql.IsEmptyString(sDefault) )
				{
					this.CreateAttributeValue(xVariable, "Default", sDefault);
				}
			}
			return xVariable;
		}

		public XmlElement CreateAssignActivity(XmlNode parent, string sType, string sRefName, string sValue)
		{
			XmlElement xAssign = this.CreateElement("Assign", this.DefaultNamespace);
			parent.AppendChild(xAssign);
			
				XmlElement xAssignTo = this.CreateElement("Assign.To", this.DefaultNamespace);
				xAssign.AppendChild(xAssignTo);
				
					XmlElement xOutArgument = this.CreateElement("OutArgument", this.DefaultNamespace);
					xAssignTo.AppendChild(xOutArgument);
					this.CreateAttributeValue(xOutArgument, "x", "TypeArguments", sType, this.XNamespace);
					//xOutArgument.InnerText = sRefName;
					
						this.CreateCSharpReference(xOutArgument, sType, sRefName);
				
				XmlElement xAssignValue = this.CreateElement("Assign.Value", this.DefaultNamespace);
				xAssign.AppendChild(xAssignValue);
				
					XmlElement xInArgument = this.CreateElement("InArgument", this.DefaultNamespace);
					xAssignValue.AppendChild(xInArgument);
					this.CreateAttributeValue(xInArgument, "x", "TypeArguments", sType, this.XNamespace);
					
					if ( sValue.StartsWith("=") )
					{
						this.CreateCSharpValue(xInArgument, sType, sValue.Substring(1));
					}
					else
					{
						xInArgument.InnerText = sValue;
					}
			return xAssign;
		}

		public XmlElement CreateSwitchActivity(XmlNode parent, string sType, string sAssignName, string sSwitchKeyName, string sDefaultValue)
		{
			XmlElement xSwitch = this.CreateElement("Switch", this.DefaultNamespace);
			parent.AppendChild(xSwitch);
			this.CreateAttributeValue(xSwitch, "x", "TypeArguments", sType, this.XNamespace);
			
				if ( !Sql.IsEmptyString(sDefaultValue) )
				{
					XmlElement xSwitchDefault = this.CreateElement("Switch.Default", this.DefaultNamespace);
					xSwitch.AppendChild(xSwitchDefault);
					this.CreateAssignActivity(xSwitchDefault, sType, sAssignName, sDefaultValue);
				}
				
				XmlElement xSwitchSwitch = this.CreateElement("Switch.Expression", this.DefaultNamespace);
				xSwitch.AppendChild(xSwitchSwitch);
				
					XmlElement xInArgument = this.CreateElement("InArgument", this.DefaultNamespace);
					xSwitchSwitch.AppendChild(xInArgument);
					this.CreateAttributeValue(xInArgument, "x", "TypeArguments", sType, this.XNamespace);
					
					if ( sSwitchKeyName.StartsWith("=") )
					{
						this.CreateCSharpValue(xInArgument, sType, sSwitchKeyName.Substring(1));
					}
					else
					{
						xInArgument.InnerText = sSwitchKeyName;
					}
			return xSwitch;
		}

		public XmlElement CreateSwitchAssignActivity(XmlNode parent, string sType, string sAssignName, string sSwitchKeyValue, string sExpression)
		{
			XmlElement xAssign = this.CreateElement("Assign", this.DefaultNamespace);
			parent.AppendChild(xAssign);
			this.CreateAttributeValue(xAssign, "x", "Key", sSwitchKeyValue, this.XNamespace);
			
				XmlElement xAssignTo = this.CreateElement("Assign.To", this.DefaultNamespace);
				xAssign.AppendChild(xAssignTo);
				
					XmlElement xOutArgument = this.CreateElement("OutArgument", this.DefaultNamespace);
					xAssignTo.AppendChild(xOutArgument);
					this.CreateAttributeValue(xOutArgument, "x", "TypeArguments", sType, this.XNamespace);
					//xOutArgument.InnerText = sAssignName;
					
						this.CreateCSharpReference(xOutArgument, sType, sAssignName);
				
				XmlElement xAssignValue = this.CreateElement("Assign.Value", this.DefaultNamespace);
				xAssign.AppendChild(xAssignValue);
				
					XmlElement xInArgument = this.CreateElement("InArgument", this.DefaultNamespace);
					xAssignValue.AppendChild(xInArgument);
					this.CreateAttributeValue(xInArgument, "x", "TypeArguments", sType, this.XNamespace);
					
					if ( sExpression.StartsWith("=") )
					{
						this.CreateCSharpValue(xInArgument, sType, sExpression.Substring(1));
					}
					else
					{
						xInArgument.InnerText = sExpression;
					}
			return xAssign;
		}

		public XmlElement CreateDumpPropertiesActivity(XmlNode parent)
		{
			XmlElement xDumpProperties = this.CreateElement("crm", "WF4DumpPropertiesActivity", this.CrmNamespace);
			parent.AppendChild(xDumpProperties);
			return xDumpProperties;
		}

		public XmlElement CreateNopActivity(XmlNode parent)
		{
			XmlElement xNopActivity = this.CreateElement("crm", "WF4NopActivity", this.CrmNamespace);
			parent.AppendChild(xNopActivity);
			return xNopActivity;
		}

		public XmlElement CreateEndActivity(XmlNode parent)
		{
			XmlElement xEndActivity = this.CreateElement("crm", "WF4EndActivity", this.CrmNamespace);
			parent.AppendChild(xEndActivity);
			return xEndActivity;
		}

		public XmlElement CreateEndEventGatewayActivity(XmlNode parent, string sEVENT_NAMES)
		{
			XmlElement xEndActivity = this.CreateElement("crm", "WF4EndEventGatewayActivity", this.CrmNamespace);
			parent.AppendChild(xEndActivity);

			this.CreateAttributeValue(xEndActivity, "EVENT_NAMES" , sEVENT_NAMES );
			return xEndActivity;
		}

		public XmlElement CreateLoadModuleActivity(XmlNode parent, string sMODULE_NAME, string sOPERATION, string sFIELD_PREFIX, string sSOURCE_ID, string sFIELD_LIST)
		{
			XmlElement xLoadModule = this.CreateElement("crm", "WF4LoadModuleActivity", this.CrmNamespace);
			parent.AppendChild(xLoadModule);
			
			this.CreateAttributeValue(xLoadModule, "MODULE_NAME" , sMODULE_NAME );
			this.CreateAttributeValue(xLoadModule, "OPERATION"   , sOPERATION   );
			this.CreateAttributeValue(xLoadModule, "FIELD_PREFIX", sFIELD_PREFIX);
			this.CreateAttributeValue(xLoadModule, "ID"          , sSOURCE_ID   );
			this.CreateAttributeValue(xLoadModule, "FIELD_LIST"  , sFIELD_LIST  );
			return xLoadModule;
		}

		public XmlElement CreateSaveModuleActivity(XmlNode parent, string sMODULE_NAME, string sOPERATION, string sFIELD_PREFIX, string sSOURCE_ID)
		{
			XmlElement xLoadModule = this.CreateElement("crm", "WF4SaveModuleActivity", this.CrmNamespace);
			parent.AppendChild(xLoadModule);
			
			this.CreateAttributeValue(xLoadModule, "MODULE_NAME" , sMODULE_NAME );
			this.CreateAttributeValue(xLoadModule, "OPERATION"   , sOPERATION   );
			this.CreateAttributeValue(xLoadModule, "FIELD_PREFIX", sFIELD_PREFIX);
			this.CreateAttributeValue(xLoadModule, "ID"          , sSOURCE_ID   );
			return xLoadModule;
		}

		public XmlElement CreateRecipientActivity(XmlNode parent, string sBpmnParentID, string sSEND_TYPE, string sRECIPIENT_TYPE, Guid gRECIPIENT_ID, string sRECIPIENT_NAME, string sRECIPIENT_TABLE, string sRECIPIENT_FIELD)
		{
			XmlElement xRecipient = this.CreateElement("crm", "WF4AddRecipientActivity", this.CrmNamespace);
			parent.AppendChild(xRecipient);
			
			string sFIELD_PREFIX = sBpmnParentID + "_";
			
			this.CreateAttributeValue(xRecipient, "SEND_TYPE"          , sSEND_TYPE                  );
			this.CreateAttributeValue(xRecipient, "RECIPIENT_TYPE"     , sRECIPIENT_TYPE             );
			this.CreateAttributeValue(xRecipient, "RECIPIENT_ID"       , gRECIPIENT_ID.ToString()    );
			this.CreateAttributeValue(xRecipient, "RECIPIENT_NAME"     , sRECIPIENT_NAME             );
			this.CreateAttributeValue(xRecipient, "RECIPIENT_TABLE"    , sRECIPIENT_TABLE            );
			this.CreateAttributeValue(xRecipient, "RECIPIENT_FIELD"    , sRECIPIENT_FIELD            );
			this.CreateAttributeValueReference(xRecipient, "RECIPIENTS", sFIELD_PREFIX + "RECIPIENTS");
			return xRecipient;
		}

		public XmlElement CreateReportActivity(XmlNode parent, string sBpmnParentID, Guid gREPORT_ID, string sREPORT_NAME, string sRENDER_FORMAT, Guid gSCHEDULED_USER_ID, string sREPORT_PARAMETERS_VARIABLE)
		{
			XmlElement xReport = this.CreateElement("crm", "WF4AttachReportActivity", this.CrmNamespace);
			parent.AppendChild(xReport);
			
			string sFIELD_PREFIX = sBpmnParentID + "_";
			
			this.CreateAttributeValue(xReport, "REPORT_ID"    , gREPORT_ID.ToString());
			this.CreateAttributeValue(xReport, "REPORT_NAME"  , sREPORT_NAME         );
			this.CreateAttributeValue(xReport, "RENDER_FORMAT", sRENDER_FORMAT       );
			
			if ( !Sql.IsEmptyGuid(gSCHEDULED_USER_ID) )
			{
				this.CreateAttributeValue(xReport, "SCHEDULED_USER_ID", gSCHEDULED_USER_ID.ToString());
			}
			this.CreateAttributeValueReference(xReport, "PARAMETERS", sFIELD_PREFIX + sREPORT_PARAMETERS_VARIABLE);
			// 11/19/2023 Paul.  Missing REPORTS assignment. 
			this.CreateAttributeValueReference(xReport, "REPORTS"   , sFIELD_PREFIX + "REPORTS"           );
			return xReport;
		}

		public XmlElement CreateReportParameterActivity(XmlNode parent, string sBpmnParentID, string sNAME, string sVALUE, string sREPORT_PARAMETERS_VARIABLE)
		{
			XmlElement xReportParameter = this.CreateElement("crm", "WFAddReportParameterActivity", this.CrmNamespace);
			parent.AppendChild(xReportParameter);
			
			string sFIELD_PREFIX = sBpmnParentID + "_";
			
			this.CreateAttributeValue(xReportParameter, "NAME"      , sNAME );
			this.CreateAttributeValue(xReportParameter, "VALUE"     , sVALUE);
			this.CreateAttributeValueReference(xReportParameter, "PARAMETERS", sFIELD_PREFIX + sREPORT_PARAMETERS_VARIABLE);
			return xReportParameter;
		}

		public XmlElement CreateAlertActivity(XmlNode parent, string sBpmnParentID)
		{
			XmlElement xAlertActivity = this.CreateElement("crm", "WF4AlertActivity", this.CrmNamespace);
			parent.AppendChild(xAlertActivity);
			
			string sFIELD_PREFIX = sBpmnParentID + "_";
			this.CreateAttributeValueReference(xAlertActivity, "PARENT_TYPE"       , "BASE_MODULE");
			this.CreateAttributeValueReference(xAlertActivity, "PARENT_ID"         , "ID"         );
			
			// 07/28/2016 Paul.  BUSINESS_PROCESS_ID and AUDIT_ID are a workflow globals, so skip the part where we manually assign in XAML. 
			//this.CreateAttributeValueReference(xAlertActivity, "BUSINESS_PROCESS_ID", "BUSINESS_PROCESS_ID");
			//this.CreateAttributeValueReference(xAlertActivity, "AUDIT_ID"           , "AUDIT_ID"           );
			this.CreateAttributeValueReference(xAlertActivity, "ALERT_TYPE"        , sFIELD_PREFIX + "ALERT_TYPE"        );
			this.CreateAttributeValueReference(xAlertActivity, "SOURCE_TYPE"       , sFIELD_PREFIX + "SOURCE_TYPE"       );
			this.CreateAttributeValueReference(xAlertActivity, "ALERT_SUBJECT"     , sFIELD_PREFIX + "ALERT_SUBJECT"     );
			this.CreateAttributeValueReference(xAlertActivity, "ALERT_TEXT"        , sFIELD_PREFIX + "ALERT_TEXT"        );
			this.CreateAttributeValueReference(xAlertActivity, "CUSTOM_TEMPLATE_ID", sFIELD_PREFIX + "CUSTOM_TEMPLATE_ID");
			this.CreateAttributeValueReference(xAlertActivity, "ASSIGNED_USER_ID"  , sFIELD_PREFIX + "ASSIGNED_USER_ID"  );
			this.CreateAttributeValueReference(xAlertActivity, "TEAM_ID"           , sFIELD_PREFIX + "TEAM_ID"           );
			this.CreateAttributeValueReference(xAlertActivity, "TEAM_SET_LIST"     , sFIELD_PREFIX + "TEAM_SET_LIST"     );
			this.CreateAttributeValueReference(xAlertActivity, "RECIPIENTS"        , sFIELD_PREFIX + "RECIPIENTS"        );
			this.CreateAttributeValueReference(xAlertActivity, "REPORTS"           , sFIELD_PREFIX + "REPORTS"           );
			return xAlertActivity;
		}

		public XmlElement CreateDelayActivity(XmlNode parent, string sDURATION)
		{
			XmlElement xDelayActivity = this.CreateElement("Delay", this.DefaultNamespace);
			parent.AppendChild(xDelayActivity);
			xDelayActivity.InnerText = sDURATION;
			return xDelayActivity;
		}

		public XmlElement CreateApprovalActivity(XmlNode parent, string sBpmnParentID, string sAPPROVAL_VARIABLE_NAME)
		{
			XmlElement xApprovalActivity = this.CreateElement("crm", "WF4ApprovalActivity", this.CrmNamespace);
			parent.AppendChild(xApprovalActivity);
			
			string sFIELD_PREFIX = sBpmnParentID + "_";
			// 07/28/2016 Paul.  BUSINESS_PROCESS_ID, AUDIT_ID and PROCESS_USER_ID are a workflow globals, so skip the part where we manually assign in XAML. 
			//this.CreateAttributeValueReference(xEscalationActivity, "BUSINESS_PROCESS_ID", "BUSINESS_PROCESS_ID");
			//this.CreateAttributeValueReference(xEscalationActivity, "AUDIT_ID"           , "AUDIT_ID"           );
			//this.CreateAttributeValueReference(xEscalationActivity, "PROCESS_USER_ID"    , "PROCESS_USER_ID"    );
			this.CreateAttributeValue         (xApprovalActivity, "BOOKMARK_NAME"          , sBpmnParentID                            );
			this.CreateAttributeValueReference(xApprovalActivity, "PARENT_TYPE"            , "BASE_MODULE"                            );
			this.CreateAttributeValueReference(xApprovalActivity, "PARENT_ID"              , "ID"                                     );
			this.CreateAttributeValueReference(xApprovalActivity, "ACTIVITY_NAME"          , sFIELD_PREFIX + "ACTIVITY_NAME"          );
			this.CreateAttributeValueReference(xApprovalActivity, "USER_TASK_TYPE"         , sFIELD_PREFIX + "USER_TASK_TYPE"         );
			this.CreateAttributeValueReference(xApprovalActivity, "CHANGE_ASSIGNED_USER"   , sFIELD_PREFIX + "CHANGE_ASSIGNED_USER"   );
			this.CreateAttributeValueReference(xApprovalActivity, "CHANGE_ASSIGNED_TEAM_ID", sFIELD_PREFIX + "CHANGE_ASSIGNED_TEAM_ID");
			this.CreateAttributeValueReference(xApprovalActivity, "CHANGE_PROCESS_USER"    , sFIELD_PREFIX + "CHANGE_PROCESS_USER"    );
			this.CreateAttributeValueReference(xApprovalActivity, "CHANGE_PROCESS_TEAM_ID" , sFIELD_PREFIX + "CHANGE_PROCESS_TEAM_ID" );
			this.CreateAttributeValueReference(xApprovalActivity, "USER_ASSIGNMENT_METHOD" , sFIELD_PREFIX + "USER_ASSIGNMENT_METHOD" );
			this.CreateAttributeValueReference(xApprovalActivity, "STATIC_ASSIGNED_USER_ID", sFIELD_PREFIX + "STATIC_ASSIGNED_USER_ID");
			this.CreateAttributeValueReference(xApprovalActivity, "DYNAMIC_PROCESS_TEAM_ID", sFIELD_PREFIX + "DYNAMIC_PROCESS_TEAM_ID");
			this.CreateAttributeValueReference(xApprovalActivity, "DYNAMIC_PROCESS_ROLE_ID", sFIELD_PREFIX + "DYNAMIC_PROCESS_ROLE_ID");
			this.CreateAttributeValueReference(xApprovalActivity, "READ_ONLY_FIELDS"       , sFIELD_PREFIX + "READ_ONLY_FIELDS"       );
			this.CreateAttributeValueReference(xApprovalActivity, "REQUIRED_FIELDS"        , sFIELD_PREFIX + "REQUIRED_FIELDS"        );
			this.CreateAttributeValueReference(xApprovalActivity, "DURATION_UNITS"         , sFIELD_PREFIX + "DURATION_UNITS"         );
			this.CreateAttributeValueReference(xApprovalActivity, "DURATION_VALUE"         , sFIELD_PREFIX + "DURATION_VALUE"         );
			this.CreateAttributeValueReference(xApprovalActivity, "APPROVAL_RESPONSE"      , sAPPROVAL_VARIABLE_NAME                  );
			return xApprovalActivity;
		}

		public XmlElement CreateAssignModuleActivity(XmlNode parent, string sMODULE_NAME, string sOPERATION, string sSOURCE_ID, string sUSER_ASSIGNMENT_METHOD, string sSTATIC_ASSIGNED_USER_ID, string sSTATIC_ASSIGNED_TEAM_ID, string sDYNAMIC_PROCESS_TEAM_ID, string sDYNAMIC_PROCESS_ROLE_ID)
		{
			XmlElement xLoadModule = this.CreateElement("crm", "WF4AssignModuleActivity", this.CrmNamespace);
			parent.AppendChild(xLoadModule);
			
			this.CreateAttributeValue(xLoadModule, "MODULE_NAME"            , sMODULE_NAME            );
			this.CreateAttributeValue(xLoadModule, "OPERATION"              , sOPERATION              );
			this.CreateAttributeValue(xLoadModule, "ID"                     , sSOURCE_ID              );
			this.CreateAttributeValue(xLoadModule, "USER_ASSIGNMENT_METHOD" , sUSER_ASSIGNMENT_METHOD );
			this.CreateAttributeValue(xLoadModule, "STATIC_ASSIGNED_USER_ID", sSTATIC_ASSIGNED_USER_ID);
			this.CreateAttributeValue(xLoadModule, "STATIC_ASSIGNED_TEAM_ID", sSTATIC_ASSIGNED_TEAM_ID);
			this.CreateAttributeValue(xLoadModule, "DYNAMIC_PROCESS_TEAM_ID", sDYNAMIC_PROCESS_TEAM_ID);
			this.CreateAttributeValue(xLoadModule, "DYNAMIC_PROCESS_ROLE_ID", sDYNAMIC_PROCESS_ROLE_ID);
			return xLoadModule;
		}

	}
}
