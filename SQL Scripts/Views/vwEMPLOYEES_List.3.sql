if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMPLOYEES_List')
	Drop View dbo.vwEMPLOYEES_List;
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
-- 01/20/2006 Paul.  Return all fields so that the grid can display custom fields.
-- Since vwUSERS does not include the description, returning all fields should not impact performance.
-- 05/02/2006 Paul.  DB2 is particular about how * is used.  
-- 10/27/2007 Paul.  vwUSERS now returns the full name as NAME as it was needed for email templates. 
Create View dbo.vwEMPLOYEES_List
as
select vwEMPLOYEES.*
  from vwEMPLOYEES

GO

Grant Select on dbo.vwEMPLOYEES_List to public;
GO

 
