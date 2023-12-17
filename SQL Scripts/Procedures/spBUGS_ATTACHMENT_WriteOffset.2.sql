if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spBUGS_ATTACHMENT_WriteOffset' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spBUGS_ATTACHMENT_WriteOffset;
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
-- 09/15/2009 Paul.  Convert data type to varbinary(max) to support Azure. 
Create Procedure dbo.spBUGS_ATTACHMENT_WriteOffset
	( @ID                   uniqueidentifier
	, @FILE_POINTER         binary(16)
	, @MODIFIED_USER_ID     uniqueidentifier
	, @FILE_OFFSET          int
	, @BYTES                varbinary(max)
	)
as
  begin
	set nocount on
	
	exec dbo.spNOTES_ATTACHMENT_WriteOffset @ID, @FILE_POINTER, @MODIFIED_USER_ID, @FILE_OFFSET, @BYTES;
  end
GO
 
Grant Execute on dbo.spBUGS_ATTACHMENT_WriteOffset to public;
GO



