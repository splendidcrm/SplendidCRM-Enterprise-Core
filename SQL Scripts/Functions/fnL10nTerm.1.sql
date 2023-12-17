if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnL10nTerm' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnL10nTerm;
GO



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
 *********************************************************************************************************************/
-- 09/03/2009 Paul.  Convert terms to a base term. 
-- 11/22/2021 Paul.  Include Assigned Set. 
Create Function dbo.fnL10nTerm(@LANG nvarchar(10), @MODULE_NAME nvarchar(20), @NAME nvarchar(50))
returns nvarchar(2000)
as
  begin
	declare @DISPLAY_NAME nvarchar(2000);
	if    @NAME = 'LBL_ID'              
	   or @NAME = 'LBL_DELETED'         
	   or @NAME = 'LBL_CREATED_BY'      
	   or @NAME = 'LBL_CREATED_BY_ID'   
	   or @NAME = 'LBL_DATE_ENTERED'    
	   or @NAME = 'LBL_MODIFIED_USER_ID'
	   or @NAME = 'LBL_DATE_MODIFIED'   
	   or @NAME = 'LBL_MODIFIED_BY'     
	   or @NAME = 'LBL_ASSIGNED_USER_ID'
	   or @NAME = 'LBL_ASSIGNED_TO'     
	   or @NAME = 'LBL_ASSIGNED_SET_ID'  
	   or @NAME = 'LBL_ASSIGNED_SET_NAME'
	   or @NAME = 'LBL_TEAM_ID'         
	   or @NAME = 'LBL_TEAM_NAME'       
	   or @NAME = 'LBL_TEAM_SET_ID'     
	   or @NAME = 'LBL_TEAM_SET_NAME'   
	   or @NAME = 'LBL_ID_C'            
	   or @NAME = 'LBL_LIST_ID'              
	   or @NAME = 'LBL_LIST_DELETED'         
	   or @NAME = 'LBL_LIST_CREATED_BY'      
	   or @NAME = 'LBL_LIST_CREATED_BY_ID'   
	   or @NAME = 'LBL_LIST_DATE_ENTERED'    
	   or @NAME = 'LBL_LIST_MODIFIED_USER_ID'
	   or @NAME = 'LBL_LIST_DATE_MODIFIED'   
	   or @NAME = 'LBL_LIST_MODIFIED_BY'     
	   or @NAME = 'LBL_LIST_ASSIGNED_USER_ID'
	   or @NAME = 'LBL_LIST_ASSIGNED_TO'     
	   or @NAME = 'LBL_LIST_ASSIGNED_SET_ID' 
	   or @NAME = 'LBL_LIST_ASSIGNED_SET_NAME'
	   or @NAME = 'LBL_LIST_TEAM_ID'         
	   or @NAME = 'LBL_LIST_TEAM_NAME'       
	   or @NAME = 'LBL_LIST_TEAM_SET_ID'     
	   or @NAME = 'LBL_LIST_TEAM_SET_NAME'   
	   or @NAME = 'LBL_LIST_ID_C'            
	begin -- then
		set @MODULE_NAME = null;
	end -- if;

	if @MODULE_NAME is null  begin -- then
		select @DISPLAY_NAME = DISPLAY_NAME
		  from dbo.TERMINOLOGY
		 where LANG        = @LANG
		   and NAME        = @NAME
		   and MODULE_NAME is null;
	end else begin
		select @DISPLAY_NAME = DISPLAY_NAME
		  from dbo.TERMINOLOGY
		 where LANG        = @LANG
		   and NAME        = @NAME
		   and MODULE_NAME = @MODULE_NAME;
	end -- if;
	return @DISPLAY_NAME;
  end
GO

Grant Execute on dbo.fnL10nTerm to public
GO

