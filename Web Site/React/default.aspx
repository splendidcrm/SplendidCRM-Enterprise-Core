<%@ Page language="c#" EnableTheming="true" AutoEventWireup="true" Inherits="SplendidCRM.SplendidPage" %>
<%@ Import Namespace="System.Diagnostics" %>
<script runat="server">
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

override protected bool AuthenticationRequired()
{
	return false;
}

private void Page_PreInit(object sender, EventArgs e)
{
	// 06/18/2015 Paul.  Setting the theme to an empty string should stop the insertion of styles from the Themes folder. 
	// 09/02/2019 Paul.  Going to try themes on React Client. 
	//this.Theme = "";
}

private void Page_Load(object sender, System.EventArgs e)
{
	Response.ExpiresAbsolute = new DateTime(1980, 1, 1, 0, 0, 0, 0);
	if ( !IsPostBack )
	{
		try
		{
			//System.Web.UI.ScriptManager mgrAjax = System.Web.UI.ScriptManager.GetCurrent(this.Page);
			//ChatManager.RegisterScripts(Context, mgrAjax);
		}
		catch(Exception ex)
		{
			SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
		}
	}
}
</script>

<!DOCTYPE HTML>
<html id="htmlRoot" runat="server">

<head runat="server">
	<meta charset="UTF-8" />
	<link rel="shortcut icon" href="<%# Application["imageURL"] %>SplendidCRM_Icon.ico" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<base href="<%# Application["rootURL"] %>React/" />
	<title><%# L10n.Term(".LBL_BROWSER_TITLE") %></title>
</head>

<body>
	<!-- 09/08/2021 Paul.  Change to vh instead of height to allow to grow. -->
	<!-- 09/14/2021 Paul.  Remove height.  It is causing copyright to appear in the middle of a detail view. -->
	<div id="root"></div>
	<script type="text/javascript" src="dist/js/SteviaCRM.js?<%= (bDebug ? (DateTime.Now.ToFileTime().ToString()) : Sql.ToString(Application["SplendidVersion"])) %>"></script>

	<div id="divFooterCopyright" align="center" style="margin-top: 4px" class="copyRight">
		Copyright &copy; 2005-2022 <a id="lnkSplendidCRM" href="http://www.splendidcrm.com" target="_blank" class="copyRightLink">SplendidCRM Software, Inc.</a> All Rights Reserved.<br />
	</div>
</body>
</html>
