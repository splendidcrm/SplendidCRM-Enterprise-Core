if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEMAIL_IMAGES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEMAIL_IMAGES_Update;
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
Create Procedure dbo.spEMAIL_IMAGES_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @PARENT_ID         uniqueidentifier
	, @FILENAME          nvarchar(255)
	, @FILE_EXT          nvarchar(25)
	, @FILE_MIME_TYPE    nvarchar(100)
	, @CONTENT           varbinary(max)
	)
as
  begin
	set nocount on

	declare @CONTENT_LENGTH int;
	set @CONTENT_LENGTH = datalength(@CONTENT);
	if not exists(select * from EMAIL_IMAGES where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into EMAIL_IMAGES
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, PARENT_ID        
			, FILENAME         
			, FILE_EXT         
			, FILE_MIME_TYPE   
			, CONTENT          
			, CONTENT_LENGTH   
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @PARENT_ID        
			, @FILENAME         
			, @FILE_EXT         
			, @FILE_MIME_TYPE   
			, @CONTENT          
			, @CONTENT_LENGTH   
			);
	end else begin
		update EMAIL_IMAGES
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , PARENT_ID         = @PARENT_ID       
		     , FILENAME          = @FILENAME        
		     , FILE_EXT          = @FILE_EXT        
		     , FILE_MIME_TYPE    = @FILE_MIME_TYPE  
		     , CONTENT           = @CONTENT         
		     , CONTENT_LENGTH    = @CONTENT_LENGTH  
		 where ID                = @ID              ;
	end -- if;	
  end
GO

Grant Execute on dbo.spEMAIL_IMAGES_Update to public;
GO

