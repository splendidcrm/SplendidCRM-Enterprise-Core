if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spIMPORT_MAPS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spIMPORT_MAPS_Update;
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
-- 10/08/2006 Paul.  NAME, SOURCE and MODULE are now nvarchar fields. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 09/17/2013 Paul.  Add Business Rules to import. 
Create Procedure dbo.spIMPORT_MAPS_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @ASSIGNED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(150)
	, @SOURCE            nvarchar(25)
	, @MODULE            nvarchar(25)
	, @HAS_HEADER        bit
	, @IS_PUBLISHED      bit
	, @CONTENT           nvarchar(max)
	, @RULES_XML         nvarchar(max) = null
	)
as
  begin
	set nocount on
	
	if not exists(select * from IMPORT_MAPS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into IMPORT_MAPS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, ASSIGNED_USER_ID 
			, NAME             
			, SOURCE           
			, MODULE           
			, HAS_HEADER       
			, IS_PUBLISHED     
			, CONTENT          
			, RULES_XML        
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @ASSIGNED_USER_ID 
			, @NAME             
			, @SOURCE           
			, @MODULE           
			, @HAS_HEADER       
			, @IS_PUBLISHED     
			, @CONTENT          
			, @RULES_XML        
			);
	end else begin
		update IMPORT_MAPS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , ASSIGNED_USER_ID  = @ASSIGNED_USER_ID 
		     , NAME              = @NAME             
		     , SOURCE            = @SOURCE           
		     , MODULE            = @MODULE           
		     , HAS_HEADER        = @HAS_HEADER       
		     , IS_PUBLISHED      = @IS_PUBLISHED     
		     , CONTENT           = @CONTENT          
		     , RULES_XML         = @RULES_XML        
		 where ID                = @ID               ;
	end -- if;
  end
GO

Grant Execute on dbo.spIMPORT_MAPS_Update to public;
GO

