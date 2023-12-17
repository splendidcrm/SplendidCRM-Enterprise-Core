if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_INSTANCE_STATES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_INSTANCE_STATES_Update;
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
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
Create Procedure dbo.spWWF_INSTANCE_STATES_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @OWNER_ID          uniqueidentifier
	, @STATUS            nvarchar(25)
	, @UNLOCKED          bit
	, @BLOCKED           bit
	, @OWNED_UNTIL       datetime
	, @NEXT_TIMER        datetime
	, @INFO              nvarchar(max)
	, @RESULT            int out
	)
as
  begin
	set nocount on
	
	set @RESULT = 0;
	if @STATUS = N'Completed' or @STATUS = N'Terminated' begin -- then
		if exists(select * from vwWWF_INSTANCE_STATES where ID = @ID and ((OWNER_ID = @OWNER_ID and OWNED_UNTIL >= getdate()) or (OWNER_ID is null and @OWNER_ID is null))) begin -- then
			exec dbo.spWWF_INSTANCE_STATES_Delete @ID, @MODIFIED_USER_ID, @STATUS;
		end else begin
			if exists(select * from vwWWF_INSTANCE_STATES where ID = @ID) begin -- then
				-- 07/29/2008 Paul.  State might be completed before it is ever saved. Ignore that condition. 
				set @RESULT = -2;
			end -- if;
		end -- if;
	end else begin
		if @UNLOCKED is null or @UNLOCKED = 1 begin -- then
			set @OWNER_ID    = null;
			set @OWNED_UNTIL = null;
		end -- if;
		if not exists(select * from WWF_INSTANCE_STATES where ID = @ID) begin -- then
			insert into WWF_INSTANCE_STATES
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, OWNER_ID         
				, STATUS           
				, UNLOCKED         
				, BLOCKED          
				, OWNED_UNTIL      
				, NEXT_TIMER       
				, INFO             
				)
			values 	( @ID               
				, @MODIFIED_USER_ID       
				,  getdate()        
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @OWNER_ID         
				, @STATUS           
				, @UNLOCKED         
				, @BLOCKED          
				, @OWNED_UNTIL      
				, @NEXT_TIMER       
				, @INFO             
				);
		end else begin
			if exists(select * from vwWWF_INSTANCE_STATES where ID = @ID and ((OWNER_ID = @OWNER_ID and OWNED_UNTIL >= getdate()) or (OWNER_ID is null and @OWNER_ID is null))) begin -- then
				update WWF_INSTANCE_STATES
				   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
				     , DATE_MODIFIED     =  getdate()        
				     , DATE_MODIFIED_UTC =  getutcdate()     
				     , OWNER_ID          = @OWNER_ID         
				     , STATUS            = @STATUS           
				     , UNLOCKED          = @UNLOCKED         
				     , BLOCKED           = @BLOCKED          
				     , OWNED_UNTIL       = @OWNED_UNTIL      
				     , NEXT_TIMER        = @NEXT_TIMER       
				     , INFO              = @INFO             
				 where ID                = @ID               ;
			end else begin
				set @RESULT = -2;
			end -- if;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spWWF_INSTANCE_STATES_Update to public;
GO

