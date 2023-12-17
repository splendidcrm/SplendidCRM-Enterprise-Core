if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMACHINE_LEARNING_MODELS_Content' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMACHINE_LEARNING_MODELS_Content;
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
Create Procedure dbo.spMACHINE_LEARNING_MODELS_Content
	( @ID                   uniqueidentifier
	, @MODIFIED_USER_ID     uniqueidentifier
	, @LAST_TRAINING_COUNT  int
	, @LAST_TRAINING_STATUS nvarchar(max)
	, @CONTENT              varbinary(max)
	)
as
  begin
	set nocount on
	
	update MACHINE_LEARNING_MODELS
	   set MODIFIED_USER_ID     = @MODIFIED_USER_ID    
	     , DATE_MODIFIED        =  getdate()           
	     , DATE_MODIFIED_UTC    =  getutcdate()        
	     , LAST_TRAINING_DATE   =  getdate()
	     , LAST_TRAINING_COUNT  = @LAST_TRAINING_COUNT
	     , LAST_TRAINING_STATUS = @LAST_TRAINING_STATUS
	     , CONTENT              = @CONTENT
	     , EVALUATION_DATA      = null                 
	     , EVALUATION_STATUS    = null                 
	 where ID                   = @ID;
  end
GO

Grant Execute on dbo.spMACHINE_LEARNING_MODELS_Content to public;
GO

