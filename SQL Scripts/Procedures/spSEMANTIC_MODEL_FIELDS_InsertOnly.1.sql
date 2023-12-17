if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSEMANTIC_MODEL_FIELDS_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly;
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
Create Procedure dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly
	( @ID                       uniqueidentifier output
	, @MODIFIED_USER_ID         uniqueidentifier
	, @TABLE_NAME               nvarchar(64)
	, @NAME                     nvarchar(64)
	, @COLUMN_INDEX             int
	, @DATA_TYPE                nvarchar(25)
	, @FORMAT                   nvarchar(10)
	, @WIDTH                    int
	, @NULLABLE                 bit
	, @IS_AGGREGATE             bit
	, @SORT_DESCENDING          bit
	, @IDENTIFYING_ATTRIBUTE    bit
	, @DETAIL_ATTRIBUTE         bit
	, @AGGREGATE_ATTRIBUTE      bit
	, @VALUE_SELECTION          nvarchar(25)
	, @CONTEXTUAL_NAME          nvarchar(25)
	, @DISCOURAGE_GROUPING      bit
	, @AGGREGATE_FUNCTION_NAME  nvarchar(25)
	, @DEFAULT_AGGREGATE        bit
	, @VARIATION_PARENT_ID      uniqueidentifier
	)
as
  begin
	set nocount on

	-- 12/12/2009 Paul.  Always ignore the @ID on input. 
	set @ID = null;	
	-- BEGIN Oracle Exception
		select @ID = ID
		  from SEMANTIC_MODEL_FIELDS
		 where TABLE_NAME = @TABLE_NAME
		   and NAME       = @NAME
		   and DELETED    = 0;
	-- END Oracle Exception
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		-- print N'SEMANTIC_MODEL_FIELDS ' + @TABLE_NAME + N'.' + @NAME;
		set @ID = newid();
		insert into SEMANTIC_MODEL_FIELDS
			( ID                      
			, CREATED_BY              
			, DATE_ENTERED            
			, MODIFIED_USER_ID        
			, DATE_MODIFIED           
			, DATE_MODIFIED_UTC       
			, TABLE_NAME              
			, NAME                    
			, COLUMN_INDEX            
			, DATA_TYPE               
			, FORMAT                  
			, WIDTH                   
			, NULLABLE                
			, IS_AGGREGATE            
			, SORT_DESCENDING         
			, IDENTIFYING_ATTRIBUTE   
			, DETAIL_ATTRIBUTE        
			, AGGREGATE_ATTRIBUTE     
			, VALUE_SELECTION         
			, CONTEXTUAL_NAME         
			, DISCOURAGE_GROUPING     
			, AGGREGATE_FUNCTION_NAME 
			, DEFAULT_AGGREGATE       
			, VARIATION_PARENT_ID     
			)
		values 	( @ID                      
			, @MODIFIED_USER_ID              
			,  getdate()               
			, @MODIFIED_USER_ID        
			,  getdate()               
			,  getutcdate()            
			, @TABLE_NAME              
			, @NAME                    
			, @COLUMN_INDEX            
			, @DATA_TYPE               
			, @FORMAT                  
			, @WIDTH                   
			, @NULLABLE                
			, @IS_AGGREGATE            
			, @SORT_DESCENDING         
			, @IDENTIFYING_ATTRIBUTE   
			, @DETAIL_ATTRIBUTE        
			, @AGGREGATE_ATTRIBUTE     
			, @VALUE_SELECTION         
			, @CONTEXTUAL_NAME         
			, @DISCOURAGE_GROUPING     
			, @AGGREGATE_FUNCTION_NAME 
			, @DEFAULT_AGGREGATE       
			, @VARIATION_PARENT_ID     
			);
	end -- if;
  end
GO

Grant Execute on dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly to public;
GO

