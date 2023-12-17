if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_ARCHIVE_LOG_InsertList' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_ARCHIVE_LOG_InsertList;
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
Create Procedure dbo.spMODULES_ARCHIVE_LOG_InsertList
	( @MODIFIED_USER_ID  uniqueidentifier
	, @TABLE_NAME        nvarchar(50)
	, @ARCHIVE_ACTION    nvarchar(25)
	, @ID_LIST           varchar(max)
	, @ARCHIVE_RULE_ID   uniqueidentifier
	)
as
  begin

	declare @CurrentPosR          int;
	declare @NextPosR             int;
	declare @MODULE_NAME          nvarchar(25);
	declare @ARCHIVE_TOKEN        varchar(255);
	declare @ARCHIVE_RECORD_ID    uniqueidentifier;

	select @MODULE_NAME = MODULE_NAME
	  from MODULES
	 where TABLE_NAME = @TABLE_NAME;

	exec dbo.spSqlGetTransactionToken @ARCHIVE_TOKEN out;

	set @CurrentPosR = 1;
	while @CurrentPosR <= len(@ID_LIST) begin -- do
		set @NextPosR = charindex(',', @ID_LIST,  @CurrentPosR);
		if @NextPosR = 0 or @NextPosR is null begin -- then
			set @NextPosR = len(@ID_LIST) + 1;
		end -- if;
		set @ARCHIVE_RECORD_ID = cast(rtrim(ltrim(substring(@ID_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
		set @CurrentPosR = @NextPosR+1;

		insert into MODULES_ARCHIVE_LOG
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, MODULE_NAME      
			, TABLE_NAME       
			, ARCHIVE_ACTION   
			, ARCHIVE_TOKEN    
			, ARCHIVE_RULE_ID  
			, ARCHIVE_RECORD_ID
			)
		values 
			(  newid()          
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODULE_NAME      
			, @TABLE_NAME       
			, @ARCHIVE_ACTION   
			, @ARCHIVE_TOKEN    
			, @ARCHIVE_RULE_ID  
			, @ARCHIVE_RECORD_ID
			);
	end -- while;

  end
GO

Grant Execute on dbo.spMODULES_ARCHIVE_LOG_InsertList to public;
GO

