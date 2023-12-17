if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_TAB_ShowMobile' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_TAB_ShowMobile;
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
-- 04/21/2009 Paul.  Correct any ordering problems. 
-- 09/13/2010 Paul.  If the data is bad, then the there may be more than one record with the tab order 
-- so make sure to only return one record. 
Create Procedure dbo.spMODULES_TAB_ShowMobile
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @SWAP_ID    uniqueidentifier;
	declare @TAB_ORDER  int;
	if exists(select * from MODULES where ID = @ID and DELETED = 0) begin -- then
		-- 11/17/2007 Paul.  First enable the module, then adjust the tab order if necessary. 
		-- BEGIN Oracle Exception
			update MODULES
			   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
			     , DATE_MODIFIED     =  getdate()        
			     , DATE_MODIFIED_UTC =  getutcdate()     
			     , MOBILE_ENABLED    = 1
			 where ID                = @ID
			   and DELETED           = 0;
		-- END Oracle Exception

		if exists(select * from MODULES where ID = @ID and TAB_ORDER = 0 and DELETED = 0) begin -- then
			-- 09/13/2010 Paul.  If the data is bad, then the there may be more than one record with the tab order 
			-- so make sure to only return one record. 
			-- BEGIN Oracle Exception
				select top 1 @SWAP_ID   = ID
				  from MODULES
				 where TAB_ORDER  = 1
				   and DELETED    = 0
				 order by TAB_ORDER;
			-- END Oracle Exception
			-- 01/04/2005 Paul.  If there is a module at 1, shift all modules so that this one can be 1. 
			if dbo.fnIsEmptyGuid(@SWAP_ID) = 0 begin -- then
				-- 04/02/2006 Paul.  Catch the Oracle NO_DATA_FOUND exception. 
				-- BEGIN Oracle Exception
					update MODULES
					   set TAB_ORDER = TAB_ORDER + 1
					 where TAB_ORDER > 0
					   and DELETED = 0;
				-- END Oracle Exception
			end -- if;
			
			-- 01/04/2006 Paul.  Modules made visible start at tab 1. 
			-- BEGIN Oracle Exception
				update MODULES
				   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
				     , DATE_MODIFIED     =  getdate()        
				     , DATE_MODIFIED_UTC =  getutcdate()     
				     , TAB_ORDER         = 1
				 where ID                = @ID
				   and DELETED           = 0;
			-- END Oracle Exception
		end -- if;

		-- 04/21/2009 Paul.  Correct any ordering problems. 
		exec dbo.spMODULES_TAB_ORDER_Reorder @MODIFIED_USER_ID;
	end -- if;
  end
GO

Grant Execute on dbo.spMODULES_TAB_ShowMobile to public;
GO

