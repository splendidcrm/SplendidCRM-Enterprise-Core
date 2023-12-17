if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spKBDOCUMENT_ATTACHMENT_ReadOffset' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spKBDOCUMENT_ATTACHMENT_ReadOffset;
GO
 
if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spKBDOCUMENTS_ATTACHMENTS_ReadOffset' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spKBDOCUMENTS_ATTACHMENTS_ReadOffset;
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
-- 10/26/2009 Paul.  Knowledge Base attachments will be stored in the Note Attachments table. 
Create Procedure dbo.spKBDOCUMENTS_ATTACHMENTS_ReadOffset
	( @ID                   uniqueidentifier
	, @FILE_OFFSET          int
	, @READ_SIZE            int
	, @BYTES                varbinary(max) output
	)
as
  begin
	set nocount on
	
	exec dbo.spNOTES_ATTACHMENT_ReadOffset @ID, @FILE_OFFSET, @READ_SIZE, @BYTES out;
  end
GO
 
Grant Execute on dbo.spKBDOCUMENTS_ATTACHMENTS_ReadOffset to public;
GO


