if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnPROSPECT_LISTS_ConstantContact' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnPROSPECT_LISTS_ConstantContact;
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
Create Function dbo.fnPROSPECT_LISTS_ConstantContact(@RELATED_ID uniqueidentifier, @RELATED_TYPE nvarchar(25))
returns varchar(max)
as
  begin
	declare @SYNC_LIST_IDS varchar(max);
	set @SYNC_LIST_IDS = N'';
	
	select @SYNC_LIST_IDS = @SYNC_LIST_IDS + (case when len(@SYNC_LIST_IDS) > 0 then  ',' else  '' end) + PROSPECT_LISTS_SYNC.REMOTE_KEY
	  from      PROSPECT_LISTS_PROSPECTS
	 inner join PROSPECT_LISTS
	         on PROSPECT_LISTS.ID            = PROSPECT_LISTS_PROSPECTS.PROSPECT_LIST_ID
	        and PROSPECT_LISTS.LIST_TYPE     = N'ConstantContact'
	        and PROSPECT_LISTS.DELETED       = 0
	 inner join PROSPECT_LISTS_SYNC
	         on PROSPECT_LISTS_SYNC.LOCAL_ID = PROSPECT_LISTS.ID
	        and PROSPECT_LISTS_SYNC.DELETED  = 0
	 where PROSPECT_LISTS_PROSPECTS.RELATED_ID   = @RELATED_ID
	   and PROSPECT_LISTS_PROSPECTS.RELATED_TYPE = @RELATED_TYPE
	   and PROSPECT_LISTS_PROSPECTS.DELETED      = 0;
	return @SYNC_LIST_IDS;
  end
GO

Grant Execute on dbo.fnPROSPECT_LISTS_ConstantContact to public
GO

