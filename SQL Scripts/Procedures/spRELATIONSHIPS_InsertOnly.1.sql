if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spRELATIONSHIPS_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spRELATIONSHIPS_InsertOnly;
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
-- 04/29/2006 Paul.  @RELATIONSHIP_ROLE_COLUMN_VALUE is too long for Oracle, so reduce globally. 
-- 06/20/2007 Paul.  Use not exists code to simplify conversion to Oracle. 
Create Procedure dbo.spRELATIONSHIPS_InsertOnly
	( @RELATIONSHIP_NAME               nvarchar(150)
	, @LHS_MODULE                      nvarchar(100)
	, @LHS_TABLE                       nvarchar(64)
	, @LHS_KEY                         nvarchar(64)
	, @RHS_MODULE                      nvarchar(100)
	, @RHS_TABLE                       nvarchar(64)
	, @RHS_KEY                         nvarchar(64)
	, @JOIN_TABLE                      nvarchar(64)
	, @JOIN_KEY_LHS                    nvarchar(64)
	, @JOIN_KEY_RHS                    nvarchar(64)
	, @RELATIONSHIP_TYPE               nvarchar(64)
	, @RELATIONSHIP_ROLE_COLUMN        nvarchar(64)
	, @RELATIONSHIP_ROLE_COL_VALUE     nvarchar(50)
	, @REVERSE                         bit
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	if not exists(select * from RELATIONSHIPS where RELATIONSHIP_NAME = @RELATIONSHIP_NAME and DELETED = 0) begin -- then
		set @ID = newid();
		insert into RELATIONSHIPS
			( ID                             
			, CREATED_BY                     
			, DATE_ENTERED                   
			, MODIFIED_USER_ID               
			, DATE_MODIFIED                  
			, RELATIONSHIP_NAME              
			, LHS_MODULE                     
			, LHS_TABLE                      
			, LHS_KEY                        
			, RHS_MODULE                     
			, RHS_TABLE                      
			, RHS_KEY                        
			, JOIN_TABLE                     
			, JOIN_KEY_LHS                   
			, JOIN_KEY_RHS                   
			, RELATIONSHIP_TYPE              
			, RELATIONSHIP_ROLE_COLUMN       
			, RELATIONSHIP_ROLE_COLUMN_VALUE 
			, REVERSE                        
			)
		values 	( @ID                             
			, null                                  
			,  getdate()                      
			, null                            
			,  getdate()                      
			, @RELATIONSHIP_NAME              
			, @LHS_MODULE                     
			, @LHS_TABLE                      
			, @LHS_KEY                        
			, @RHS_MODULE                     
			, @RHS_TABLE                      
			, @RHS_KEY                        
			, @JOIN_TABLE                     
			, @JOIN_KEY_LHS                   
			, @JOIN_KEY_RHS                   
			, @RELATIONSHIP_TYPE              
			, @RELATIONSHIP_ROLE_COLUMN       
			, @RELATIONSHIP_ROLE_COL_VALUE 
			, @REVERSE                        
			);
	end -- if;
  end
GO
 
Grant Execute on dbo.spRELATIONSHIPS_InsertOnly to public;
GO
 
