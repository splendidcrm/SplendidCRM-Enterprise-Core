if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnTAGS_NamesByList' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnTAGS_NamesByList;
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
-- 08/23/2009 Paul.  Decrease set list so that index plus ID will be less than 900 bytes. 
Create Function dbo.fnTAGS_NamesByList(@TAG_SET_LIST varchar(851))
returns nvarchar(200)
as
  begin
	declare @TAG_SET_NAME nvarchar(200);
	declare @NAME          nvarchar(128);
	declare @ID            uniqueidentifier;
	declare @CurrentPosR   int;
	declare @NextPosR      int;
	set @CurrentPosR   = 1;
	set @TAG_SET_NAME  = null;
	while @CurrentPosR <= len(@TAG_SET_LIST) begin -- do
		set @NextPosR = charindex(',', @TAG_SET_LIST,  @CurrentPosR);
		if @NextPosR = 0 or @NextPosR is null begin -- then
			set @NextPosR = len(@TAG_SET_LIST) + 1;
		end -- if;
		set @ID = cast(rtrim(ltrim(substring(@TAG_SET_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
		set @CurrentPosR = @NextPosR+1;

		-- BEGIN Oracle Exception
			select @NAME   = NAME
			  from TAGS
			 where ID      = @ID
			   and DELETED = 0;
		-- END Oracle Exception
		if @NAME is not null begin -- then
			if @TAG_SET_NAME is null begin -- then
				set @TAG_SET_NAME = @NAME;
			end else begin
				set @TAG_SET_NAME = substring(@TAG_SET_NAME + N', ' + @NAME, 1, 200);
			end -- if;
		end -- if;
	end -- while;
	return @TAG_SET_NAME;
  end
GO

Grant Execute on dbo.fnTAGS_NamesByList to public
GO

