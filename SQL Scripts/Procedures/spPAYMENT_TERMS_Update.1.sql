if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPAYMENT_TERMS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPAYMENT_TERMS_Update;
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
Create Procedure dbo.spPAYMENT_TERMS_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(50)
	, @STATUS            nvarchar(25)
	, @LIST_ORDER        int
	)
as
  begin
	set nocount on
	
	-- 05/30/2012 Paul.  PAYMENT_TERMS from QuickBooks may not have a position. 
	if @LIST_ORDER is null begin -- then
		-- BEGIN Oracle Exception
			select @LIST_ORDER = isnull(max(LIST_ORDER) + 1, 0)
			  from vwPAYMENT_TERMS;
		-- END Oracle Exception
	end -- if;
	
	if not exists(select * from PAYMENT_TERMS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into PAYMENT_TERMS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, NAME             
			, STATUS           
			, LIST_ORDER       
			)
		values 	( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @NAME             
			, @STATUS           
			, @LIST_ORDER       
			);
	end else begin
		update PAYMENT_TERMS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , NAME              = @NAME             
		     , STATUS            = @STATUS           
		     , LIST_ORDER        = @LIST_ORDER       
		 where ID                = @ID               ;
	end -- if;
  end
GO
 
Grant Execute on dbo.spPAYMENT_TERMS_Update to public;
GO
 
