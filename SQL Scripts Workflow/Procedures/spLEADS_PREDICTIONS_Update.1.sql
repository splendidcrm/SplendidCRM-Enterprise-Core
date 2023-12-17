if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spLEADS_PREDICTIONS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spLEADS_PREDICTIONS_Update;
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
Create Procedure dbo.spLEADS_PREDICTIONS_Update
	( @MODIFIED_USER_ID          uniqueidentifier
	, @LEAD_ID                   uniqueidentifier
	, @MACHINE_LEARNING_MODEL_ID uniqueidentifier
	, @PROBABILITY               float
	, @SCORE                     float
	, @PREDICTED_LABEL           bit
	)
as
  begin
	set nocount on

	declare @ID           uniqueidentifier;
	declare @OLD_MODEL_ID uniqueidentifier;
	declare @PREDICTION   nvarchar(50);
	-- BEGIN Oracle Exception
		select @ID            = ID
		     , @OLD_MODEL_ID  = MACHINE_LEARNING_MODEL_ID
		  from LEADS_PREDICTIONS
		 where LEAD_ID        = @LEAD_ID
		   and DELETED        = 0;
	-- END Oracle Exception
	
	-- 08/12/2021 Paul.  There can only be one value per record, so delete the old.
	if @OLD_MODEL_ID <> @MACHINE_LEARNING_MODEL_ID begin -- then
		update LEADS_PREDICTIONS
		   set DELETED           = 1
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where ID                = @ID;
		set @ID = null;
	end -- if;

	if          @PROBABILITY > 0.8 begin -- then
		set @PREDICTION = 'Very High';
	end else if @PROBABILITY > 0.6 begin -- then
		set @PREDICTION = 'High';
	end else if @PROBABILITY > 0.4 begin -- then
		set @PREDICTION = 'Normal';
	end else if @PROBABILITY > 0.2 begin -- then
		set @PREDICTION = 'Low';
	end else if @PROBABILITY > 0.0 begin -- then
		set @PREDICTION = 'Very Low';
	end -- if;
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into LEADS_PREDICTIONS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, LEAD_ID          
			, MACHINE_LEARNING_MODEL_ID
			, PROBABILITY      
			, SCORE            
			, PREDICTED_LABEL  
			, PREDICTION       
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @LEAD_ID          
			, @MACHINE_LEARNING_MODEL_ID
			, @PROBABILITY      
			, @SCORE            
			, @PREDICTED_LABEL  
			, @PREDICTION       
			);
	end else begin
		update LEADS_PREDICTIONS
		   set PROBABILITY       = @PROBABILITY
		     , SCORE             = @SCORE
		     , PREDICTED_LABEL   = @PREDICTED_LABEL
		     , PREDICTION        = @PREDICTION
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where ID                = @ID;
	end -- if;
  end
GO

Grant Execute on dbo.spLEADS_PREDICTIONS_Update to public;
GO


