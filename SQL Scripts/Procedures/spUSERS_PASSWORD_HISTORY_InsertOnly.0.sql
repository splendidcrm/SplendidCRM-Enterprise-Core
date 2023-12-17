if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spUSERS_PASSWORD_HISTORY_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spUSERS_PASSWORD_HISTORY_InsertOnly;
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
Create Procedure dbo.spUSERS_PASSWORD_HISTORY_InsertOnly
	( @MODIFIED_USER_ID  uniqueidentifier
	, @USER_ID           uniqueidentifier
	, @USER_HASH         nvarchar(32)
	)
as
  begin
	set nocount on
	
	declare @HistoryMax   int;
	declare @HistoryCount int;
	declare @OLDEST_ID    uniqueidentifier;

	insert into USERS_PASSWORD_HISTORY
		( ID               
		, CREATED_BY       
		, DATE_ENTERED     
		, MODIFIED_USER_ID 
		, DATE_MODIFIED    
		, USER_ID          
		, USER_HASH        
		)
	values
		(  newid()          
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @USER_ID          
		, @USER_HASH        
		);

	set @HistoryMax = dbo.fnCONFIG_Int(N'Password.HistoryMaximum');
	if @HistoryMax is null or @HistoryMax < 0 begin -- then
		set @HistoryMax = 0;
	end -- if;

-- #if SQL_Server /*
	select @HistoryCount = count(*)
	  from USERS_PASSWORD_HISTORY
	 where USER_ID     = @USER_ID;

	while @HistoryCount > @HistoryMax begin -- do
		select top 1 @OLDEST_ID = ID
		  from USERS_PASSWORD_HISTORY
		 where USER_ID     = @USER_ID
		 order by DATE_ENTERED;
		
		delete from USERS_PASSWORD_HISTORY
		  where ID = @OLDEST_ID;
		
		select @HistoryCount = count(*)
		  from USERS_PASSWORD_HISTORY
		 where USER_ID     = @USER_ID;
	end -- while;
-- #endif SQL_Server */




  end
GO
 
Grant Execute on dbo.spUSERS_PASSWORD_HISTORY_InsertOnly to public;
GO
 
 
