if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnTEAM_HIERARCHY_ChildrenXml' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnTEAM_HIERARCHY_ChildrenXml;
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
-- 08/12/2017 Paul.  Fix replacement to &amp;. 
Create Function dbo.fnTEAM_HIERARCHY_ChildrenXml(@PARENT_ID uniqueidentifier)
returns xml
with returns null on null input 
begin return 
	(select ID                          as '@ID'
	      , replace(NAME, '&', '&amp;') as '@NAME'
	      , PARENT_ID                   as '@PARENT_ID'
	      , (case when PARENT_ID = @PARENT_ID then dbo.fnTEAM_HIERARCHY_ChildrenXml(ID) end)
	   from TEAMS
	  where PARENT_ID = @PARENT_ID
	    and DELETED   = 0
	  order by '@NAME'
	    for xml path('TEAM'), type
	)
end
GO

Grant Execute on dbo.fnTEAM_HIERARCHY_ChildrenXml to public;
GO

