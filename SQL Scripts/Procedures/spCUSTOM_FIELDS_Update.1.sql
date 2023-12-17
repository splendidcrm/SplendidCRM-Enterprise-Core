if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCUSTOM_FIELDS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCUSTOM_FIELDS_Update;
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
Create Procedure dbo.spCUSTOM_FIELDS_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @SET_NUM           int
	, @FIELD0            nvarchar(255)
	, @FIELD1            nvarchar(255)
	, @FIELD2            nvarchar(255)
	, @FIELD3            nvarchar(255)
	, @FIELD4            nvarchar(255)
	, @FIELD5            nvarchar(255)
	, @FIELD6            nvarchar(255)
	, @FIELD7            nvarchar(255)
	, @FIELD8            nvarchar(255)
	, @FIELD9            nvarchar(255)
	)
as
  begin
	set nocount on
	
	if not exists(select * from CUSTOM_FIELDS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into CUSTOM_FIELDS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, SET_NUM          
			, FIELD0           
			, FIELD1           
			, FIELD2           
			, FIELD3           
			, FIELD4           
			, FIELD5           
			, FIELD6           
			, FIELD7           
			, FIELD8           
			, FIELD9           
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @SET_NUM          
			, @FIELD0           
			, @FIELD1           
			, @FIELD2           
			, @FIELD3           
			, @FIELD4           
			, @FIELD5           
			, @FIELD6           
			, @FIELD7           
			, @FIELD8           
			, @FIELD9           
			);
	end else begin
		update CUSTOM_FIELDS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , SET_NUM           = @SET_NUM          
		     , FIELD0            = @FIELD0           
		     , FIELD1            = @FIELD1           
		     , FIELD2            = @FIELD2           
		     , FIELD3            = @FIELD3           
		     , FIELD4            = @FIELD4           
		     , FIELD5            = @FIELD5           
		     , FIELD6            = @FIELD6           
		     , FIELD7            = @FIELD7           
		     , FIELD8            = @FIELD8           
		     , FIELD9            = @FIELD9           
		 where ID                = @ID               ;
	end -- if;
  end
GO

Grant Execute on dbo.spCUSTOM_FIELDS_Update to public;
GO

