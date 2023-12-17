if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnERASED_FIELDS_Data' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnERASED_FIELDS_Data;
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
Create Function dbo.fnERASED_FIELDS_Data(@BEAN_ID uniqueidentifier)
returns nvarchar(max)
as
  begin
	declare @DATA nvarchar(max);
	select @DATA = DATA
	  from ERASED_FIELDS
	 where BEAN_ID = @BEAN_ID
	   and DELETED = 0;
	return @DATA;
  end
GO

Grant Execute on dbo.fnERASED_FIELDS_Data to public
GO

