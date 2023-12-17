if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spREGIONS_COUNTRIES_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spREGIONS_COUNTRIES_InsertOnly;
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
Create Procedure dbo.spREGIONS_COUNTRIES_InsertOnly
	( @MODIFIED_USER_ID  uniqueidentifier
	, @COUNTRY           nvarchar(50)
	, @REGION_NAME       nvarchar(150)
	)
as
  begin
	set nocount on
	
	declare @ID        uniqueidentifier;
	declare @REGION_ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @REGION_ID = ID
		  from REGIONS
		 where NAME    = @REGION_NAME
		   and DELETED = 0;
	-- END Oracle Exception
	if @REGION_ID is not null begin -- then
		if not exists(select * from REGIONS_COUNTRIES where REGION_ID = @REGION_ID and COUNTRY = @COUNTRY) begin -- then
			set @ID = newid();
			insert into REGIONS_COUNTRIES
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, REGION_ID        
				, COUNTRY          
				)
			values 	( @ID               
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @REGION_ID        
				, @COUNTRY          
				);
		end -- if;
	end -- if;
  end
GO
 
Grant Execute on dbo.spREGIONS_COUNTRIES_InsertOnly to public;
GO
 
