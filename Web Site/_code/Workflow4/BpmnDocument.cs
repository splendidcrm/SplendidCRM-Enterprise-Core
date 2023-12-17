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
	public class BpmnDocument : XmlDocument
	{
		private XmlUtil              XmlUtil            ;

		//<bpmn2:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn2="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xsi:schemaLocation="http://www.omg.org/spec/BPMN/20100524/MODEL BPMN20.xsd" id="sample-diagram" targetNamespace="http://bpmn.io/schema/bpmn">
		private static string sDefaultNamespace = "http://bpmn.io/schema/bpmn"                 ;
		private static string sCamundaNamespace = "http://camunda.org/schema/1.0/bpmn"         ;  // camunda
		private static string sXsiNamespace     = "http://www.w3.org/2001/XMLSchema-instance"  ;  // xsi
		private static string sBpmn2Namespace   = "http://www.omg.org/spec/BPMN/20100524/MODEL";  // bpmn2
		private static string sBpmnDiNamespace  = "http://www.omg.org/spec/BPMN/20100524/DI"   ;  // bpmndi
		private static string sDcNamespace      = "http://www.omg.org/spec/DD/20100524/DC"     ;  // dc
		private static string sDiNamespace      = "http://www.omg.org/spec/DD/20100524/DI"     ;  // di
		private static string sCrmNamespace     = "http://splendidcrm"                         ;  // crm

		public string DefaultNamespace { get { return sDefaultNamespace; } }
		public string CamundaNamespace { get { return sCamundaNamespace; } }
		public string XsiNamespace     { get { return sXsiNamespace    ; } }
		public string Bpmn2Namespace   { get { return sBpmn2Namespace  ; } }
		public string BpmnDiNamespace  { get { return sBpmnDiNamespace ; } }
		public string DcNamespace      { get { return sDcNamespace     ; } }
		public string DiNamespace      { get { return sDiNamespace     ; } }
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

		public BpmnDocument(XmlUtil XmlUtil) : base()
		{
			this.XmlUtil             = XmlUtil            ;

			sbValidationErrors = new StringBuilder();
		}

		public void LoadBpmn(string bpmn)
		{
			base.LoadXml(bpmn);
			nsmgr = new XmlNamespaceManager(this.NameTable);
			nsmgr.AddNamespace(""         , sDefaultNamespace);
			nsmgr.AddNamespace("defaultns", sDefaultNamespace);
			nsmgr.AddNamespace("camunda"  , sCamundaNamespace);
			nsmgr.AddNamespace("xsi"      , sXsiNamespace    );
			nsmgr.AddNamespace("bpmn2"    , sBpmn2Namespace  );
			nsmgr.AddNamespace("bpmndi"   , sBpmnDiNamespace );
			nsmgr.AddNamespace("dc"       , sDcNamespace     );
			nsmgr.AddNamespace("di"       , sDiNamespace     );
			nsmgr.AddNamespace("crm"      , sCrmNamespace    );

			bool bValidate = false;
#if DEBUG
			//bValidate = true;
#endif
			if ( bValidate )
			{
				Validate();
			}
		}

		public void LoadBpmn(Stream inStream)
		{
			base.Load(inStream);
			nsmgr = new XmlNamespaceManager(this.NameTable);
			nsmgr.AddNamespace(""         , sDefaultNamespace);
			nsmgr.AddNamespace("defaultns", sDefaultNamespace);
			nsmgr.AddNamespace("camunda"  , sCamundaNamespace);
			nsmgr.AddNamespace("xsi"      , sXsiNamespace    );
			nsmgr.AddNamespace("bpmn2"    , sBpmn2Namespace  );
			nsmgr.AddNamespace("bpmndi"   , sBpmnDiNamespace );
			nsmgr.AddNamespace("dc"       , sDcNamespace     );
			nsmgr.AddNamespace("di"       , sDiNamespace     );
			nsmgr.AddNamespace("crm"      , sCrmNamespace    );

			bool bValidate = false;
#if DEBUG
			//bValidate = true;
#endif
			if ( bValidate )
			{
				Validate();
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

		public XmlNode SelectNextStep(XmlNode parent)
		{
			XmlNode xNextStep = null;
			XmlNode xOutgoing = parent.SelectSingleNode("bpmn2:outgoing", this.NamespaceManager);
			if ( xOutgoing != null )
			{
				string sSequenceFlowID = xOutgoing.InnerText;
				XmlNode xSequenceFlow = this.DocumentElement.SelectSingleNode("//bpmn2:sequenceFlow[@id='" + sSequenceFlowID + "']", this.NamespaceManager);
				if ( xSequenceFlow != null )
				{
					string sTargetRefID = SelectNodeAttribute(xSequenceFlow, "targetRef");
					xNextStep = this.DocumentElement.SelectSingleNode("//*[@id='" + sTargetRefID + "']", this.NamespaceManager);
				}
			}
			return xNextStep;
		}

		public XmlNode FindTargetElement(string sID)
		{
			XmlNode xTargetNode = null;
			XmlNodeList nlIncomingElement = this.DocumentElement.SelectNodes("//bpmn2:incoming[text()='" + sID + "']", nsmgr);
			if ( nlIncomingElement != null && nlIncomingElement.Count > 0 )
			{
				XmlNode xIncomingElement = nlIncomingElement[0];
				xTargetNode = xIncomingElement.ParentNode;
			}
			return xTargetNode;
		}

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
		
/*
		public void AppendField(XmlNode parent, string sFieldName, string sFieldType)
		{
			XmlNode xField     = this.CreateElement("Field"      , sDefaultNamespace );
			XmlNode xDataField = this.CreateElement("DataField"  , sDefaultNamespace );
			XmlNode xTypeName  = this.CreateElement("rd:TypeName", sDesignerNamespace);
			parent.AppendChild(xField    );
			xField.AppendChild(xDataField);
			xField.AppendChild(xTypeName );
			xDataField.InnerText = sFieldName;
			xTypeName.InnerText  = sFieldType;
			
			XmlAttribute attr = this.CreateAttribute("Name");
			attr.Value = RdlName(sFieldName);
			xField.Attributes.SetNamedItem(attr);
		}

		public void AppendColumnExpression(XmlNode parent, string sColumnOwner, string sColumnName)
		{
			XmlNode xColumnExpression = this.CreateElement("ColumnExpression", sQueryDefinitionNamespace);
			parent.AppendChild(xColumnExpression);
			this.SetSingleNodeAttribute(xColumnExpression, "ColumnOwner", sColumnOwner);
			this.SetSingleNodeAttribute(xColumnExpression, "ColumnName" , sColumnName );
		}
*/
	}
}
