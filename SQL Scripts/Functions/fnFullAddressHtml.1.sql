if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnFullAddressHtml' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnFullAddressHtml;
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
-- 02/14/2014 Kevin.  Convert CRLF to <br /> so that street will display as multiple lines. 
-- 04/25/2016 Paul.  Convert 2-letter country code using contries_dom. 
Create Function dbo.fnFullAddressHtml
	( @ADDRESS_STREET     nvarchar(150)
	, @ADDRESS_CITY       nvarchar(100)
	, @ADDRESS_STATE      nvarchar(100)
	, @ADDRESS_POSTALCODE nvarchar(20)
	, @ADDRESS_COUNTRY    nvarchar(100)
	)
returns nvarchar(500)
as
  begin
	declare @FULL_ADDRESS nvarchar(500);
	if len(@ADDRESS_COUNTRY) = 2 begin -- then
		set @ADDRESS_COUNTRY = dbo.fnTERMINOLOGY_Lookup(@ADDRESS_COUNTRY, N'en-US', null, N'countries_dom');
	end -- if;
	set @FULL_ADDRESS = isnull(replace(@ADDRESS_STREET, char(13) + char(10), N'<br />'), N'') + N'<br>' 
	                  + isnull(@ADDRESS_CITY      , N'') + N' ' 
	                  + isnull(@ADDRESS_STATE     , N'') + N' &nbsp;&nbsp;' 
	                  + isnull(@ADDRESS_POSTALCODE, N'') + N'<br>' 
	                  + isnull(@ADDRESS_COUNTRY   , N'') + N' ';
	return @FULL_ADDRESS;
  end
GO

Grant Execute on dbo.fnFullAddressHtml to public
GO

