if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROCESSES_OPTOUT_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROCESSES_OPTOUT_InsertOnly;
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
Create Procedure dbo.spPROCESSES_OPTOUT_InsertOnly
	( @ID                            uniqueidentifier output
	, @MODIFIED_USER_ID              uniqueidentifier
	, @BUSINESS_PROCESS_INSTANCE_ID  uniqueidentifier
	, @PARENT_ID                     uniqueidentifier
	, @REASON                        nvarchar(max)
	)
as
  begin
	set nocount on
	
	declare @PARENT_TYPE nvarchar(50);
	select @PARENT_TYPE = PARENT_TYPE
	  from vwPARENTS_EMAIL_ADDRESS
	 where PARENT_ID = @PARENT_ID;

	if not exists(select * from PROCESSES_OPTOUT where BUSINESS_PROCESS_INSTANCE_ID = @BUSINESS_PROCESS_INSTANCE_ID and PARENT_ID = @PARENT_ID) begin -- then
		set @ID = newid();
		insert into PROCESSES_OPTOUT
			( ID                           
			, CREATED_BY                   
			, DATE_ENTERED                 
			, MODIFIED_USER_ID             
			, DATE_MODIFIED                
			, DATE_MODIFIED_UTC            
			, BUSINESS_PROCESS_INSTANCE_ID 
			, PARENT_ID                    
			, PARENT_TYPE                  
			, REASON                       
			)
		values 	( @ID                           
			, @MODIFIED_USER_ID             
			,  getdate()                    
			, @MODIFIED_USER_ID             
			,  getdate()                    
			,  getutcdate()                 
			, @BUSINESS_PROCESS_INSTANCE_ID 
			, @PARENT_ID                    
			, @PARENT_TYPE                  
			, @REASON                       
			);

		exec dbo. spPROCESSES_HISTORY_InsertOnly null, @ID, @BUSINESS_PROCESS_INSTANCE_ID, N'OptOut', null, null, null, null;
	end -- if;
  end
GO

Grant Execute on dbo.spPROCESSES_OPTOUT_InsertOnly to public;
GO

