if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTIMEZONES')
	Drop View dbo.vwTIMEZONES;
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
-- 01/02/2012 Paul.  Add iCal TZID. 
-- 03/26/2013 Paul.  iCloud uses linked_timezone values from http://tzinfo.rubyforge.org/doc/. 
Create View dbo.vwTIMEZONES
as
select ID                   
     , NAME                 
     , STANDARD_NAME        
     , STANDARD_ABBREVIATION
     , DAYLIGHT_NAME        
     , DAYLIGHT_ABBREVIATION
     , BIAS                 
     , STANDARD_BIAS        
     , DAYLIGHT_BIAS        
     , STANDARD_YEAR        
     , STANDARD_MONTH       
     , STANDARD_WEEK        
     , STANDARD_DAYOFWEEK   
     , STANDARD_HOUR        
     , STANDARD_MINUTE      
     , DAYLIGHT_YEAR        
     , DAYLIGHT_MONTH       
     , DAYLIGHT_WEEK        
     , DAYLIGHT_DAYOFWEEK   
     , DAYLIGHT_HOUR        
     , DAYLIGHT_MINUTE      
     , TZID
     , LINKED_TIMEZONE
  from TIMEZONES
 where DELETED = 0

GO

Grant Select on dbo.vwTIMEZONES to public;
GO

