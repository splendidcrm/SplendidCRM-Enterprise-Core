if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_TRACKING_PROFILES_InsertDefault' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_TRACKING_PROFILES_InsertDefault;
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
Create Procedure dbo.spWWF_TRACKING_PROFILES_InsertDefault
	( @ID                             uniqueidentifier output
	, @MODIFIED_USER_ID               uniqueidentifier
	, @TYPE_FULL_NAME                 nvarchar(128)
	, @ASSEMBLY_FULL_NAME             nvarchar(256)
	)
as
  begin
	set nocount on

	declare @TYPE_ID uniqueidentifier;

	set @TYPE_FULL_NAME     = nullif(ltrim(rtrim(@TYPE_FULL_NAME    )), N'');
	set @ASSEMBLY_FULL_NAME = nullif(ltrim(rtrim(@ASSEMBLY_FULL_NAME)), N'');
	exec dbo.spWWF_TYPES_InsertOnly @TYPE_ID out, @MODIFIED_USER_ID, @TYPE_FULL_NAME, @ASSEMBLY_FULL_NAME, 0;

	if dbo.fnIsEmptyGuid(@TYPE_ID) = 1 begin -- then
		raiserror(N'spWWF_TRACKING_PROFILES_InsertDefault failed calling procedure spWWF_TYPES_InsertOnly', 16, 1);
		return;
	end -- if;

	-- NULL is inserted so that we don't hold multiple copies of the same profile and needlessly chew up disk space
	-- Basically this record is just a pointer to the version of the default profile to use
	set @ID = newid();
	insert into WWF_TRACKING_PROFILES
		( ID                            
		, CREATED_BY                    
		, DATE_ENTERED                  
		, VERSION                       
		, WORKFLOW_TYPE_ID                 
		, TRACKING_PROFILE_XML          
		)
	select top 1
		  @ID
		, @MODIFIED_USER_ID
		, getdate()
		, VERSION
		, @TYPE_ID
		, null
	  from WWF_TRACKING_PROFILE_DEF
	 where DELETED = 0
	 order by DATE_ENTERED desc;
  end
GO
 
Grant Execute on dbo.spWWF_TRACKING_PROFILES_InsertDefault to public;
GO

