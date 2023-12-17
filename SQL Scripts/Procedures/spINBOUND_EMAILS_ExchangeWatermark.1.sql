if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spINBOUND_EMAILS_ExchangeWatermark' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spINBOUND_EMAILS_ExchangeWatermark;
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
-- 01/28/2017 Paul.  EXCHANGE_WATERMARK for support of Exchange and Office365.
-- 07/19/2023 Paul.  Increase size of EXCHANGE_WATERMARK to 1000.  Badly formed token. 
Create Procedure dbo.spINBOUND_EMAILS_ExchangeWatermark
	( @ID                 uniqueidentifier
	, @MODIFIED_USER_ID   uniqueidentifier
	, @EXCHANGE_WATERMARK varchar(1000)
	)
as
  begin
	set nocount on

	update INBOUND_EMAILS
	   set MODIFIED_USER_ID   = @MODIFIED_USER_ID 
	     , DATE_MODIFIED      = getdate()         
	     , DATE_MODIFIED_UTC  = getutcdate()      
	     , EXCHANGE_WATERMARK = @EXCHANGE_WATERMARK   
	 where ID                 = @ID               
	   and DELETED            = 0;
  end
GO
 
Grant Execute on dbo.spINBOUND_EMAILS_ExchangeWatermark to public;
GO
 
