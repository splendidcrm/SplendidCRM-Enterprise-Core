if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROSPECTS_DATA_PRIVACY_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROSPECTS_DATA_PRIVACY_Update;
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
Create Procedure dbo.spPROSPECTS_DATA_PRIVACY_Update
	( @MODIFIED_USER_ID  uniqueidentifier
	, @PROSPECT_ID       uniqueidentifier
	, @DATA_PRIVACY_ID   uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @COMMAND              nvarchar(max);
	declare @PARAM_DEFINTION      nvarchar(200);
	declare @EMAIL1               nvarchar(100);
	declare @EMAIL2               nvarchar(100);
	declare @EXISTS               bit;
	declare @ARCHIVE_EXISTS       bit;
	declare @RECORD_EXISTS        bit;
	declare @TEST                 bit;
	declare @CRLF                 nchar(2);
	declare @ARCHIVE_DATABASE     nvarchar(50);
	declare @ARCHIVE_DATABASE_DOT nvarchar(50);

	set @TEST = 0;
	set @CRLF = char(13) + char(10);
	set @ARCHIVE_DATABASE = dbo.fnCONFIG_String('Archive.Database');
	if len(@ARCHIVE_DATABASE) > 0 begin -- then
		set @ARCHIVE_DATABASE_DOT = '[' + @ARCHIVE_DATABASE + '].';
	end else begin
		set @ARCHIVE_DATABASE_DOT = '';
	end -- if;
	exec dbo.spSqlTableExists @ARCHIVE_EXISTS out, 'PROSPECTS_ARCHIVE', @ARCHIVE_DATABASE;

	if exists(select * from PROSPECTS where ID = @PROSPECT_ID) begin -- then
		select @EMAIL1 = EMAIL1
		     , @EMAIL2 = EMAIL2
		  from PROSPECTS
		 where ID = @PROSPECT_ID;
	end else if @ARCHIVE_EXISTS = 1 begin -- then
		exec dbo.spSqlTableRecordExists @RECORD_EXISTS out, 'PROSPECTS_ARCHIVE', 'ID', @PROSPECT_ID, @ARCHIVE_DATABASE;
		if @RECORD_EXISTS = 1 begin -- then
			set @COMMAND = '';
			set @COMMAND = @COMMAND + 'select @EMAIL1 = EMAIL1' + @CRLF;
			set @COMMAND = @COMMAND + '     , @EMAIL2 = EMAIL2' + @CRLF;
			set @COMMAND = @COMMAND + '  from ' + @ARCHIVE_DATABASE_DOT + 'dbo.PROSPECTS_ARCHIVE' + @CRLF;
			set @COMMAND = @COMMAND + ' where ID = @ID'         + @CRLF;
			set @PARAM_DEFINTION = N'@EMAIL1 nvarchar(100) output, @EMAIL2 nvarchar(100) output, @ID uniqueidentifier';
			exec sp_executesql @COMMAND, @PARAM_DEFINTION, @EMAIL1 = @EMAIL1 output, @EMAIL2 = @EMAIL2 output, @ID = @PROSPECT_ID;
		end -- if;
	end -- if;

	if not exists(select * from PROSPECTS_DATA_PRIVACY where PROSPECT_ID = @PROSPECT_ID and DATA_PRIVACY_ID = @DATA_PRIVACY_ID and DELETED = 0) begin -- then
		insert into PROSPECTS_DATA_PRIVACY
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, PROSPECT_ID      
			, DATA_PRIVACY_ID  
			)
		values
			( newid()           
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @PROSPECT_ID      
			, @DATA_PRIVACY_ID  
			);
	end -- if;

	-- 07/03/2018 Paul.  Also include any other leads with the same email. 
	insert into PROSPECTS_DATA_PRIVACY
		( ID                
		, CREATED_BY        
		, DATE_ENTERED      
		, MODIFIED_USER_ID  
		, DATE_MODIFIED     
		, PROSPECT_ID       
		, DATA_PRIVACY_ID   
		)                   
	select newid()           
	     , @MODIFIED_USER_ID 
	     ,  getdate()        
	     , @MODIFIED_USER_ID 
	     ,  getdate()        
	     , ID                
	     , @DATA_PRIVACY_ID  
	  from PROSPECTS
	 where (EMAIL1 in (@EMAIL1, @EMAIL2) or EMAIL2 in (@EMAIL1, @EMAIL2))
	   and not exists(select * from PROSPECTS_DATA_PRIVACY where DATA_PRIVACY_ID = @DATA_PRIVACY_ID and PROSPECT_ID = PROSPECTS.ID and PROSPECTS_DATA_PRIVACY.DELETED = 0);

	if @ARCHIVE_EXISTS = 1 begin -- then
		set @COMMAND = '';
		set @COMMAND = @COMMAND + 'insert into PROSPECTS_DATA_PRIVACY' + @CRLF;
		set @COMMAND = @COMMAND + '	( ID                ' + @CRLF;
		set @COMMAND = @COMMAND + '	, CREATED_BY        ' + @CRLF;
		set @COMMAND = @COMMAND + '	, DATE_ENTERED      ' + @CRLF;
		set @COMMAND = @COMMAND + '	, MODIFIED_USER_ID  ' + @CRLF;
		set @COMMAND = @COMMAND + '	, DATE_MODIFIED     ' + @CRLF;
		set @COMMAND = @COMMAND + '	, PROSPECT_ID       ' + @CRLF;
		set @COMMAND = @COMMAND + '	, DATA_PRIVACY_ID   ' + @CRLF;
		set @COMMAND = @COMMAND + '	)                   ' + @CRLF;
		set @COMMAND = @COMMAND + 'select newid()           ' + @CRLF;
		set @COMMAND = @COMMAND + '     , @MODIFIED_USER_ID ' + @CRLF;
		set @COMMAND = @COMMAND + '     ,  getdate()        ' + @CRLF;
		set @COMMAND = @COMMAND + '     , @MODIFIED_USER_ID ' + @CRLF;
		set @COMMAND = @COMMAND + '     ,  getdate()        ' + @CRLF;
		set @COMMAND = @COMMAND + '     , ID                ' + @CRLF;
		set @COMMAND = @COMMAND + '     , @DATA_PRIVACY_ID  ' + @CRLF;
		set @COMMAND = @COMMAND + '  from ' + @ARCHIVE_DATABASE_DOT + 'dbo.PROSPECTS_ARCHIVE' + @CRLF;
		set @COMMAND = @COMMAND + ' where (EMAIL1 in (@EMAIL1, @EMAIL2) or EMAIL2 in (@EMAIL1, @EMAIL2))' + @CRLF;
		set @COMMAND = @COMMAND + '   and not exists(select * from PROSPECTS_DATA_PRIVACY where DATA_PRIVACY_ID = @DATA_PRIVACY_ID and PROSPECT_ID = PROSPECTS_ARCHIVE.ID and PROSPECTS_DATA_PRIVACY.DELETED = 0)' + @CRLF;

		set @PARAM_DEFINTION = N'@DATA_PRIVACY_ID uniqueidentifier, @EMAIL1 nvarchar(100), @EMAIL2 nvarchar(100), @MODIFIED_USER_ID uniqueidentifier';
		exec sp_executesql @COMMAND, @PARAM_DEFINTION, @DATA_PRIVACY_ID = @DATA_PRIVACY_ID, @EMAIL1 = @EMAIL1, @EMAIL2 = @EMAIL2, @MODIFIED_USER_ID = @MODIFIED_USER_ID;
	end -- if;
  end
GO

Grant Execute on dbo.spPROSPECTS_DATA_PRIVACY_Update to public;
GO

