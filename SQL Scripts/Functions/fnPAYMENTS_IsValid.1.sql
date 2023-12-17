if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnPAYMENTS_IsValid' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnPAYMENTS_IsValid;
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
-- 09/08/2008 Paul.  The view is not available at function creation time.  Go direct to the table. 
-- 07/26/2009 Paul.  We are noticing a problem with STATUS not being returned by PayPal. 
-- The temporary solution is to check the status or the AVS_CODE. 
Create Function dbo.fnPAYMENTS_IsValid(@PAYMENT_ID uniqueidentifier, @PAYMENT_TYPE nvarchar(25))
returns bit
as
  begin
	declare @IsValid bit;
	set @IsValid = 0;
	if @PAYMENT_TYPE = N'Credit Card' begin -- then
		if exists(select *
	                    from PAYMENTS_TRANSACTIONS
	                   where TRANSACTION_TYPE = N'Sale'
	                     and (STATUS = N'Success' or (STATUS is null and AVS_CODE is not null))
	                     and PAYMENT_ID       = @PAYMENT_ID
	                     and DELETED          = 0
		         ) begin -- then
			if not exists(select *
		                        from PAYMENTS_TRANSACTIONS
		                       where TRANSACTION_TYPE in (N'Refund', N'Voided')
		                         and (STATUS = N'Success' or (STATUS is null and AVS_CODE is not null))
		                         and PAYMENT_ID       = @PAYMENT_ID
		                         and DELETED          = 0
		                     ) begin -- then
				set @IsValid = 1;
			end -- if;
		end -- if;
	end else begin
		set @IsValid = 1;
	end -- if;
	return @IsValid;
  end
GO

Grant Execute on dbo.fnPAYMENTS_IsValid to public
GO

