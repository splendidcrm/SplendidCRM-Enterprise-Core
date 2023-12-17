if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnArchiveRelatedModules' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnArchiveRelatedModules;
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
Create Function dbo.fnArchiveRelatedModules(@MODULE_NAME nvarchar(25))
returns @MODULES table (MODULE_NAME nvarchar(50))
as
  begin
	if @MODULE_NAME is not null begin -- then
		insert into @MODULES(MODULE_NAME) values (@MODULE_NAME);
	end -- if;
	if exists(select * from MODULES_ARCHIVE_RELATED where MODULE_NAME = @MODULE_NAME and RELATED_NAME = 'Activities' and DELETED = 0) begin -- then
		insert into @MODULES (MODULE_NAME)
		select RELATED_NAME
		  from vwMODULES_ARCHIVE_RELATED
		 where MODULE_NAME = 'Activities';
	end -- if;

	insert into @MODULES (MODULE_NAME)
	select RELATED_NAME
	  from MODULES_ARCHIVE_RELATED
	 where MODULE_NAME  = @MODULE_NAME
	   and RELATED_NAME <> 'Activities'
	   and DELETED      = 0;
	return;
  end
GO

Grant Select on dbo.fnArchiveRelatedModules to public;
GO

