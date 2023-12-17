if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDETAILVIEWS_RELATIONSHIPS_Enable' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDETAILVIEWS_RELATIONSHIPS_Enable;
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
Create Procedure dbo.spDETAILVIEWS_RELATIONSHIPS_Enable
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @SWAP_ID            uniqueidentifier;
	declare @DETAIL_NAME        nvarchar(50);
	declare @RELATIONSHIP_ORDER int;
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where ID = @ID and DELETED = 0) begin -- then
		-- BEGIN Oracle Exception
			select @DETAIL_NAME        = DETAIL_NAME
			     , @RELATIONSHIP_ORDER = RELATIONSHIP_ORDER
			  from DETAILVIEWS_RELATIONSHIPS
			 where ID          = @ID
			   and DELETED     = 0;
		-- END Oracle Exception

		-- BEGIN Oracle Exception
			select @SWAP_ID           = ID
			  from DETAILVIEWS_RELATIONSHIPS
			 where DETAIL_NAME        = @DETAIL_NAME
			   and RELATIONSHIP_ORDER = 0
			   and DELETED            = 0;
		-- END Oracle Exception
		-- 01/04/2005 Paul.  If there is a module at 0, shift all DETAILVIEWS_RELATIONSHIPS so that this one can be 1. 
		if dbo.fnIsEmptyGuid(@SWAP_ID) = 0 begin -- then
			-- 04/02/2006 Paul.  Catch the Oracle NO_DATA_FOUND exception. 
			-- BEGIN Oracle Exception
				update DETAILVIEWS_RELATIONSHIPS
				   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
				 where DETAIL_NAME        = @DETAIL_NAME
				   and RELATIONSHIP_ORDER >= 0
				   and DELETED = 0;
			-- END Oracle Exception
		end -- if;
		
		-- 01/04/2006 Paul.  DETAILVIEWS_RELATIONSHIPS made visible start at tab 0. 
		-- BEGIN Oracle Exception
			update DETAILVIEWS_RELATIONSHIPS
			   set MODIFIED_USER_ID     = @MODIFIED_USER_ID 
			     , DATE_MODIFIED        =  getdate()        
			     , DATE_MODIFIED_UTC    =  getutcdate()     
			     , RELATIONSHIP_ORDER   = 0
			     , RELATIONSHIP_ENABLED = 1
			 where ID                   = @ID
			   and DELETED              = 0;
		-- END Oracle Exception
	end -- if;
  end
GO

Grant Execute on dbo.spDETAILVIEWS_RELATIONSHIPS_Enable to public;
GO

