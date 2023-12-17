if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spINVOICES_UpdateAmountDue' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spINVOICES_UpdateAmountDue;
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
-- 04/23/2008 Paul.  Anytime a payment is applied to the invoice, we need to update the amount due. 
-- 04/23/2008 Paul.  fnPAYMENTS_IsValid contains logic to determine if a credit card transaction is valid. 
-- fnPAYMENTS_IsValid is used inside vwPAYMENTS_INVOICES to correct the Allocated value.
-- 09/07/2008 Paul.  Change the order of the variables to simplify migration to Oracle. 
-- 10/01/2008 Paul.  Only change the invoice to Paid if was previously Due.  Otherwise, leave unchanged. 
-- 09/17/2009 Paul.  Don't change to Paid if the Total US Dollar is zero. 
-- 12/21/2017 Paul.  Allow Under Review to convert to Paid. 
-- 01/30/2019 Paul.  Trigger audit record so workflow will have access to custom fields. 
Create Procedure dbo.spINVOICES_UpdateAmountDue
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on

	declare @AMOUNT_PAID_USDOLLAR money;
	declare @AMOUNT_PAID          money;
	if exists(select * from vwINVOICES where ID = @ID) begin -- then
		select @AMOUNT_PAID          = sum(ALLOCATED         )
		     , @AMOUNT_PAID_USDOLLAR = sum(ALLOCATED_USDOLLAR)
		  from vwPAYMENTS_INVOICES
		 where INVOICE_ID            = @ID;
		-- 10/01/2008 Paul.  Only change the invoice to Paid if was previously Due.  Otherwise, leave unchanged. 
		update INVOICES
		   set MODIFIED_USER_ID    = @MODIFIED_USER_ID
		     , DATE_MODIFIED       =  getdate()        
		     , DATE_MODIFIED_UTC   =  getutcdate()     
		     , AMOUNT_DUE          =  TOTAL          - isnull(@AMOUNT_PAID         , 0.0)
		     , AMOUNT_DUE_USDOLLAR =  TOTAL_USDOLLAR - isnull(@AMOUNT_PAID_USDOLLAR, 0.0)
		     , INVOICE_STAGE       = (case when INVOICE_STAGE in (N'Due', N'Under Review') and TOTAL_USDOLLAR > 0 and TOTAL_USDOLLAR - isnull(@AMOUNT_PAID_USDOLLAR, 0.0) <= 0.0 then N'Paid' else INVOICE_STAGE end)
		 where ID                  = @ID;

		-- 01/30/2019 Paul.  Trigger audit record so workflow will have access to custom fields. 
		update INVOICES_CSTM
		   set ID_C                = ID_C
		 where ID_C                = @ID;
	end -- if;
  end
GO
 
Grant Execute on dbo.spINVOICES_UpdateAmountDue to public;
GO
 
 
