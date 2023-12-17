if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTHREADS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTHREADS_Update;
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
-- 02/29/2008 Paul.  Add support for custom table. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
Create Procedure dbo.spTHREADS_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @FORUM_ID          uniqueidentifier
	, @PARENT_ID         uniqueidentifier
	, @TITLE             nvarchar(255)
	, @IS_STICKY         bit
	, @DESCRIPTION_HTML  nvarchar(max)
	)
as
  begin
	set nocount on

	declare @MODULE            nvarchar( 25);
	declare @PARENT_TYPE       nvarchar( 25);
	declare @PARENT_NAME       nvarchar(150);
	declare @TEMP_FORUM_ID     uniqueidentifier;

	set @TEMP_FORUM_ID = @FORUM_ID;
	if not exists(select * from THREADS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into THREADS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, FORUM_ID         
			, TITLE            
			, IS_STICKY        
			, POSTCOUNT        
			, VIEW_COUNT       
			, DESCRIPTION_HTML 
			)
		values 	( @ID               
			, @MODIFIED_USER_ID       
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @TEMP_FORUM_ID         
			, @TITLE            
			, @IS_STICKY        
			, 0                
			, 0                
			, @DESCRIPTION_HTML 
			);

		if @PARENT_ID is not null begin -- then
			exec dbo.spPARENT_Get @PARENT_ID out, @MODULE out, @PARENT_TYPE out, @PARENT_NAME out;

			if @MODULE = N'Accounts' begin -- then
				exec dbo.spACCOUNTS_THREADS_Update @MODIFIED_USER_ID, @PARENT_ID, @ID;
			end else if @MODULE = N'Bugs' begin -- then
				exec dbo.spBUGS_THREADS_Update @MODIFIED_USER_ID, @PARENT_ID, @ID;
			end else if @MODULE = N'Cases' begin -- then
				exec dbo.spCASES_THREADS_Update @MODIFIED_USER_ID, @PARENT_ID, @ID;
			end else if @MODULE = N'Leads' begin -- then
				exec dbo.spLEADS_THREADS_Update @MODIFIED_USER_ID, @PARENT_ID, @ID;
			end else if @MODULE = N'Opportunities' begin -- then
				exec dbo.spOPPORTUNITIES_THREADS_Update @MODIFIED_USER_ID, @PARENT_ID, @ID;
			end else if @MODULE = N'Projects' begin -- then
				exec dbo.spPROJECT_THREADS_Update @MODIFIED_USER_ID, @PARENT_ID, @ID;
			end -- if;
		end -- if;

	end else begin
		update THREADS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , TITLE             = @TITLE            
		     , IS_STICKY         = @IS_STICKY        
		     , DESCRIPTION_HTML  = @DESCRIPTION_HTML 
		 where ID                = @ID               ;

		select @TEMP_FORUM_ID = FORUM_ID
		  from THREADS
		 where ID        = @ID;
	end -- if;

	if not exists(select * from THREADS_CSTM where ID_C = @ID) begin -- then
		insert into THREADS_CSTM ( ID_C ) values ( @ID );
	end -- if;

	if dbo.fnIsEmptyGuid(@TEMP_FORUM_ID) = 0 begin -- then
		exec dbo.spFORUMS_UpdateThreadCount @TEMP_FORUM_ID, @MODIFIED_USER_ID;
	end -- if;
  end
GO

Grant Execute on dbo.spTHREADS_Update to public;
GO

