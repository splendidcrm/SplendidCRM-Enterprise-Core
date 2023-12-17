if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_DEFINITIONS_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_DEFINITIONS_Insert;
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
-- 06/30/2008 Paul.  Similar to InsertWorkflowInstance. 
-- 06/30/2008 Paul.  The name ends in Insert because a record is always inserted. 
-- 06/30/2008 Paul.  The @D is the @WORKFLOW_INSTANCE_INTERNAL_ID. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
Create Procedure dbo.spWWF_DEFINITIONS_Insert
	( @ID                             uniqueidentifier output
	, @MODIFIED_USER_ID               uniqueidentifier
	, @DEFINITION_EXISTS              bit output
	, @TYPE_FULL_NAME                 nvarchar(128)
	, @ASSEMBLY_FULL_NAME             nvarchar(256)
	, @IS_INSTANCE_TYPE               bit
	, @WORKFLOW_DEFINITION            nvarchar(max)
	)
as
  begin
	set nocount on

	declare @WORKFLOW_TYPE_ID uniqueidentifier;

	set @ID                 = null;
	set @TYPE_FULL_NAME     = nullif(ltrim(rtrim(@TYPE_FULL_NAME    )), N'');
	set @ASSEMBLY_FULL_NAME = nullif(ltrim(rtrim(@ASSEMBLY_FULL_NAME)), N'');
	exec dbo.spWWF_TYPES_InsertOnly @WORKFLOW_TYPE_ID out, @MODIFIED_USER_ID, @TYPE_FULL_NAME, @ASSEMBLY_FULL_NAME, @IS_INSTANCE_TYPE;

	if dbo.fnIsEmptyGuid(@WORKFLOW_TYPE_ID) = 1 begin -- then
		raiserror(N'spWWF_DEFINITIONS_Insert failed calling procedure spWWF_TYPES_InsertOnly', 16, 1);
		return;
	end -- if;

	-- BEGIN Oracle Exception
		select @ID              = ID
		  from WWF_DEFINITIONS
		 where WORKFLOW_TYPE_ID = @WORKFLOW_TYPE_ID;
	-- END Oracle Exception

	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into WWF_DEFINITIONS
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, WORKFLOW_TYPE_ID   
			, WORKFLOW_DEFINITION
			)
		values
		 	( @ID                 
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @WORKFLOW_TYPE_ID   
			, @WORKFLOW_DEFINITION
			);
		set @DEFINITION_EXISTS = 0;
	end else begin
		set @DEFINITION_EXISTS = 1;
	end -- if;
	-- 06/30/2008 Paul.  The primary key of WWF_DEFINITIONS is never used, but the @WORKFLOW_TYPE_ID is. 
	set @ID = @WORKFLOW_TYPE_ID;
  end
GO
 
Grant Execute on dbo.spWWF_DEFINITIONS_Insert to public;
GO

