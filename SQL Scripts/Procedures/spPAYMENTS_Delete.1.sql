if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPAYMENTS_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPAYMENTS_Delete;
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
-- 08/26/2010 Paul.  If a payment is deleted, we need to re-calculate the invoice amount and update the stage. 
-- 08/07/2013 Paul.  Add Oracle Exception. 
-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
Create Procedure dbo.spPAYMENTS_Delete
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @INVOICE_ID uniqueidentifier;
	declare @AMOUNT_PAID_USDOLLAR money;
	declare @AMOUNT_PAID          money;
	-- 08/26/2010 Paul.  Don't need to declare @PAYMENT_ID. 
	--declare @PAYMENT_ID uniqueidentifier;

	declare invoice_cursor cursor for
	select distinct INVOICE_ID
	  from vwPAYMENTS_INVOICES
	 where PAYMENT_ID = @ID;

/* -- #if IBM_DB2
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
-- #endif IBM_DB2 */
/* -- #if MySQL
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
-- #endif MySQL */

	open invoice_cursor;
	fetch next from invoice_cursor into @INVOICE_ID;
	while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
		-- 08/26/2010 Paul.  We don't use spINVOICES_UpdateAmountDue because we need to allow the stage to go to Due. 
		-- 08/26/2010 Paul.  Make sure to exclude the payment that is being deleted. 
		select @AMOUNT_PAID          = sum(ALLOCATED         )
		     , @AMOUNT_PAID_USDOLLAR = sum(ALLOCATED_USDOLLAR)
		  from vwPAYMENTS_INVOICES
		 where INVOICE_ID            = @INVOICE_ID
		   and PAYMENT_ID           <> @ID;

		update INVOICES
		   set MODIFIED_USER_ID    = @MODIFIED_USER_ID
		     , DATE_MODIFIED       =  getdate()        
		     , DATE_MODIFIED_UTC   =  getutcdate()     
		     , AMOUNT_DUE          =  TOTAL          - isnull(@AMOUNT_PAID         , 0.0)
		     , AMOUNT_DUE_USDOLLAR =  TOTAL_USDOLLAR - isnull(@AMOUNT_PAID_USDOLLAR, 0.0)
		     , INVOICE_STAGE       = (case when INVOICE_STAGE = N'Due'  and TOTAL_USDOLLAR > 0 and TOTAL_USDOLLAR - isnull(@AMOUNT_PAID_USDOLLAR, 0.0) <= 0.0 then N'Paid' 
		                                   when INVOICE_STAGE = N'Paid' and TOTAL_USDOLLAR > 0 and TOTAL_USDOLLAR - isnull(@AMOUNT_PAID_USDOLLAR, 0.0) >  0.0 then N'Due' 
		                                   else INVOICE_STAGE
		                              end)
		 where ID                  = @INVOICE_ID;

		-- 01/30/2019 Paul.  Trigger audit record so workflow will have access to custom fields. 
		update INVOICES_CSTM
		   set ID_C                 = ID_C
		 where ID_C                 = @INVOICE_ID;
		fetch next from invoice_cursor into @INVOICE_ID;
	end -- while;
	close invoice_cursor;
	deallocate invoice_cursor;

	-- 08/26/2010 Paul.  We can't delete the payment until after we have updated the invoice. 
	-- This is because we need the relationships to determine which invoices to update. 
	-- There really should only be one payment to one invoice, but we have to be defensive in our programming. 
	-- BEGIN Oracle Exception
		update PAYMENTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID               = @ID
		   and DELETED          = 0;

		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update PAYMENTS_CSTM
		   set ID_C             = ID_C
		 where ID_C             = @ID;
	-- END Oracle Exception

	-- 05/28/2007 Paul.  Delete payment relationships.
	-- BEGIN Oracle Exception
		update INVOICES_PAYMENTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where PAYMENT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception

  end
GO
 
Grant Execute on dbo.spPAYMENTS_Delete to public;
GO
 
 
