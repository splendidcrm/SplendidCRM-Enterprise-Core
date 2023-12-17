if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTERMINOLOGY_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTERMINOLOGY_InsertOnly;
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
-- 07/24/2006 Paul.  Increase the MODULE_NAME to 25 to match the size in the MODULES table.
-- 08/27/2008 Paul.  PostgreSQL does not allow modifying input parameters.  Use a local temp variable. 
-- 02/02/2009 Paul.  Need to treat empty strings as NULL to be consistent.
-- 04/16/2010 Paul.  The Exists function does not include DELETED items.  
-- We want to allow users to delete items and not have them inserted back during an upgrade. 
-- 03/06/2012 Paul.  Increase size of the NAME field so that it can include a date formula. 
Create Procedure dbo.spTERMINOLOGY_InsertOnly
	( @NAME              nvarchar(150)
	, @LANG              nvarchar(10)
	, @MODULE_NAME       nvarchar(25)
	, @LIST_NAME         nvarchar(50)
	, @LIST_ORDER        int
	, @DISPLAY_NAME      nvarchar(max)
	)
as
  begin
	set nocount on
	
	declare @ID              uniqueidentifier;
	declare @TEMP_LIST_ORDER int;
	declare @TEMP_NAME       nvarchar(150);
	declare @TermExist       bit;
	set @TEMP_LIST_ORDER = @LIST_ORDER;
	-- 11/21/2005 Paul.  LIST_ORDER is not used if LIST_NAME is null. 
	if @LIST_NAME is null begin -- then
		set @TEMP_LIST_ORDER = null;
	end -- if;
	-- 01/12/2006 Paul.  0 is not valid for list order. 
	if @TEMP_LIST_ORDER = 0 begin -- then
		set @TEMP_LIST_ORDER = null;
	end -- if;
	-- 02/02/2009 Paul.  Need to treat empty strings as NULL to be consistent.
	set @TEMP_NAME = @NAME;
	if @TEMP_NAME = N'' begin -- then
		set @TEMP_NAME = null;
	end -- if;

	-- 04/16/2010 Paul.  The Exists function does not include DELETED items.  
	-- We want to allow users to delete items and not have them inserted back during an upgrade. 
	-- set @TermExist = dbo.fnTERMINOLOGY_Exists(@TEMP_NAME, @LANG, @MODULE_NAME, @LIST_NAME, @TEMP_LIST_ORDER);
	set @TermExist = 0;
	if exists(select *
	            from TERMINOLOGY
	           where (NAME        = @NAME        or (NAME        is null and @NAME        is null))
	             and (LANG        = @LANG        or (LANG        is null and @LANG        is null))
	             and (MODULE_NAME = @MODULE_NAME or (MODULE_NAME is null and @MODULE_NAME is null))
	             and (LIST_NAME   = @LIST_NAME   or (LIST_NAME   is null and @LIST_NAME   is null))
	         ) begin -- then
		set @TermExist = 1;
	end -- if;
	if @TermExist = 0 begin -- then
		set @ID = newid();
		insert into TERMINOLOGY
			( ID               
			, DATE_ENTERED     
			, DATE_MODIFIED    
			, NAME             
			, LANG             
			, MODULE_NAME      
			, LIST_NAME        
			, LIST_ORDER       
			, DISPLAY_NAME     
			)
		values
			( @ID               
			,  getdate()        
			,  getdate()        
			, @TEMP_NAME        
			, @LANG             
			, @MODULE_NAME      
			, @LIST_NAME        
			, @TEMP_LIST_ORDER       
			, @DISPLAY_NAME     
			);
	end -- if;
  end
GO

Grant Execute on dbo.spTERMINOLOGY_InsertOnly to public;
GO

