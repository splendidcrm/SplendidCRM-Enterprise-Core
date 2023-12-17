if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnStoreTimeOnly' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnStoreTimeOnly;
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
-- 06/01/2007 Paul.  Using convert to get the time is causing a problem on international installations. 
-- The date is internally stored as two 4-byte integers.  Convert to decimal and subtract the date portion. 
-- http://www.sql-server-helper.com/functions/get-date-only.aspx
-- Use decimal(15,8) for better accuracy. 
-- select cast(floor(cast(cast('06/01/2007 11:59:59.998 pm' as datetime) as decimal(15,8))) as datetime)
-- 09/06/2010 Paul.  Help with migration with EffiProz. 
Create Function dbo.fnStoreTimeOnly(@VALUE datetime)
returns datetime
as
  begin
	set @VALUE = cast(cast(@VALUE as decimal(15,8)) - floor(cast(@VALUE as decimal(15,8))) as datetime);
	return @VALUE;
  end
GO

Grant Execute on dbo.fnStoreTimeOnly to public;
GO

