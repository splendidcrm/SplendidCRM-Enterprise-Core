if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnHtmlXssFilter' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnHtmlXssFilter;
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
-- 01/06/2022 Paul.  We need a way to filter EMAILS.DESCRIPTION_HTML in the database. 
-- Ideally we would use the CONFIG.email_xss set, but that would be too slow, so manually code. 
Create Function dbo.fnHtmlXssFilter(@HTML nvarchar(max))
returns nvarchar(max)
as
  begin
	declare @VALUE nvarchar(max);
	set @VALUE = @HTML;
	if @VALUE is not null begin -- then
		-- 01/06/2022 Paul.  To be efficient, we are going to just disable the start tag and ignore the end tag. 
		set @VALUE = replace(@VALUE, '<html', '<xhtml');
		set @VALUE = replace(@VALUE, '<body', '<xbody');
		set @VALUE = replace(@VALUE, '<base', '<xbase');
		set @VALUE = replace(@VALUE, '<form', '<xform');
		set @VALUE = replace(@VALUE, '<meta', '<xmeta');
		set @VALUE = replace(@VALUE, '<style', '<xstyle');
		set @VALUE = replace(@VALUE, '<embed', '<xembed');
		set @VALUE = replace(@VALUE, '<object', '<xobject');
		set @VALUE = replace(@VALUE, '<script', '<xscript');
		set @VALUE = replace(@VALUE, '<iframe', '<xiframe');
	end -- if;
	return @VALUE;
  end
GO

Grant Execute on dbo.fnHtmlXssFilter to public
GO

