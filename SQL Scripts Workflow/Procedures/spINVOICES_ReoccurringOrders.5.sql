if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spINVOICES_ReoccurringOrders' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spINVOICES_ReoccurringOrders;
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
-- 12/17/2008 Paul.  Make sure to exclude the date the order was created. 
-- 12/15/2009 Paul.  Decrease the default bill date to -1. 
-- 12/19/2018 Paul.  Provide a way to process for a single company. 
-- 12/19/2018 Paul.  Provide a way to override the default invoice stage. 
Create Procedure dbo.spINVOICES_ReoccurringOrders
	( @BILL_DATE           datetime
	, @SPECIFIC_ACCOUNT_ID uniqueidentifier = null
	, @INVOICE_STAGE       nvarchar(25) = null
	)
as
  begin
	set nocount on

	if @BILL_DATE is null begin -- then
		set @BILL_DATE = cast(convert(varchar(8),getdate()-1,1) as datetime);
	end -- if;
	set @BILL_DATE = cast(floor(cast(@BILL_DATE as float)) as datetime);
	print @BILL_DATE;
	print '-----------------------------------------------------------------------------';
	
	declare @QUEUE_ID          uniqueidentifier;
	declare @ACCOUNT_ID        uniqueidentifier;
	declare @ACCOUNT_NAME      nvarchar(100);
	declare @ORDER_ID          uniqueidentifier;
	declare @ORDER_NAME        nvarchar(100);
	declare @INVOICE_ID        uniqueidentifier;
	declare @BILLING_FREQUENCY nvarchar(25);
	declare @DATE_ORDER_DUE    datetime;
	declare @BeginDate         datetime;
	declare @EndDateMonthly    datetime;
	declare @EndDate           datetime;
	declare @BeginUsageDate    datetime;
	declare @EndUsageDate      datetime;
	declare @FREQUENCY_MULTIPLIER int;
	declare @REPEAT_COMMENT    nvarchar(100);
	declare @LINE_ITEM_ID      uniqueidentifier;
	declare @POSITION          int;

	declare @BILLING_INVOICE_FROM_NAME   nvarchar(255);
	declare @BILLING_INVOICE_FROM_EMAIL  nvarchar(255);
	declare @BILLING_INVOICE_TEMPLATE_ID uniqueidentifier;
	set @BILLING_INVOICE_FROM_NAME   = dbo.fnCONFIG_String(N'Billing Invoice From Name'  );
	set @BILLING_INVOICE_FROM_EMAIL  = dbo.fnCONFIG_String(N'Billing Invoice From Email' );
	set @BILLING_INVOICE_TEMPLATE_ID = cast(dbo.fnCONFIG_String(N'Billing Invoice Template ID') as uniqueidentifier);

-- #if SQL_Server /*
	declare orders_cursor cursor for
	select ACCOUNTS_BILLING.ID
	     , ACCOUNTS_BILLING.NAME
	     , ORDERS.ID
	     , ORDERS.NAME
	     , BILLING_FREQUENCY_C
	     , (case BILLING_FREQUENCY_C
	        when 'Monthly'    then 1
	        when 'Bi-Monthly' then 2
	        when 'Quarterly'  then 3
	        when 'Bi-Yearly'  then 6
	        when 'Yearly'     then 12
	        else 1
		end) as FREQUENCY_MULTIPLIER
	     , ORDERS.DATE_ORDER_DUE
	     , dbo.fnBillingFrequency_BeginDate(BILLING_FREQUENCY_C, ORDERS.DATE_ORDER_DUE, @BILL_DATE) as BeginDate
	     , dbo.fnBillingFrequency_EndDate  (BILLING_FREQUENCY_C, ORDERS.DATE_ORDER_DUE, @BILL_DATE) as EndDate
	  from            ORDERS
	       inner join ORDERS_CSTM
	               on ORDERS_CSTM.ID_C                      = ORDERS.ID
	       inner join ORDERS_ACCOUNTS                         ORDERS_ACCOUNTS_BILLING
	               on ORDERS_ACCOUNTS_BILLING.ORDER_ID      = ORDERS.ID
	              and ORDERS_ACCOUNTS_BILLING.ACCOUNT_ROLE  = N'Bill To'
	              and ORDERS_ACCOUNTS_BILLING.DELETED       = 0
	       inner join ACCOUNTS                                ACCOUNTS_BILLING
	               on ACCOUNTS_BILLING.ID                   = ORDERS_ACCOUNTS_BILLING.ACCOUNT_ID
	              and ACCOUNTS_BILLING.DELETED              = 0
	       inner join ACCOUNTS_CSTM
	               on ACCOUNTS_CSTM.ID_C                    = ACCOUNTS_BILLING.ID
	  left outer join INVOICES
	               on INVOICES.ORDER_ID                     = ORDERS.ID
			-- 09/17/2008 Paul.  We should also truncate the due date. 
			-- 09/17/2008 Paul.  The previous date calculations were based on previous period.  
			-- We are going to pre-pay, so the due date is at the beginning of the period. 
	              and cast(floor(cast(INVOICES.DUE_DATE as float)) as datetime) = dbo.fnBillingFrequency_BeginDate(BILLING_FREQUENCY_C, ORDERS.DATE_ORDER_DUE, @BILL_DATE)
	              and INVOICES.DELETED                      = 0
	 where ORDERS.DELETED     = 0
	   and ORDERS.ORDER_STAGE ='Ordered'
	   and ORDERS_CSTM.BILLING_FREQUENCY_C is not null
	   and ORDERS.ID in (select ORDER_ID from vwORDERS_LINE_ITEMS where BILLING_TYPE_C = 'Repeat')
	   and INVOICES.ID is null
	   -- 12/19/2018 Paul.  Provide a way to process for a single company. 
	   and (ACCOUNTS_BILLING.ID = @SPECIFIC_ACCOUNT_ID or @SPECIFIC_ACCOUNT_ID is null)
	   -- 09/17/2008 Paul.  We have to make sure that the customer is not billed for services before the order was created. 
	   -- 12/17/2008 Paul.  Make sure to exclude the date the order was created. 
	   and dbo.fnBillingFrequency_BeginDate(BILLING_FREQUENCY_C, ORDERS.DATE_ORDER_DUE, @BILL_DATE) > cast(floor(cast(ORDERS.DATE_ORDER_DUE as float)) as datetime)
	   and dbo.fnBillingFrequency_BeginDate(BILLING_FREQUENCY_C, ORDERS.DATE_ORDER_DUE, @BILL_DATE) between dateadd(dd, -30, @BILL_DATE) and @BILL_DATE
	 order by EndDate, ACCOUNTS_BILLING.NAME;
-- #endif SQL_Server */
	
	open orders_cursor;
	fetch next from orders_cursor into @ACCOUNT_ID, @ACCOUNT_NAME, @ORDER_ID, @ORDER_NAME, @BILLING_FREQUENCY, @FREQUENCY_MULTIPLIER, @DATE_ORDER_DUE, @BeginDate, @EndDate;
	while @@FETCH_STATUS = 0 begin -- do
		print convert(char(10), @BeginDate, 101) + ' to ' + convert(char(10), @EndDate, 101) + ' ' + convert(char(10), @BILLING_FREQUENCY) + ' ' + @ACCOUNT_NAME + ' - ' + @ORDER_NAME;

		set @EndDateMonthly = @EndDate;
		set @REPEAT_COMMENT = null;
		set @INVOICE_ID     = null;
		if @FREQUENCY_MULTIPLIER > 1 begin -- then
			set @EndDateMonthly = dateadd(month, 1, @BeginDate);
			set @REPEAT_COMMENT = ' - from ' + convert(varchar(20), @BeginDate, 101) + ' to ' + convert(varchar(20), @EndDateMonthly, 101);
			print @REPEAT_COMMENT;
		end -- if;
		exec dbo.spINVOICES_ConvertOrder @INVOICE_ID out, null, @ORDER_ID, @REPEAT_COMMENT;
		print 'INVOICE_ID:' + cast(@INVOICE_ID as char(36));

		-- 06/23/2008 Paul.  The new DUE_DATE must be the EndDate of the select statement. 
		-- This is very important as it is the end date of their billing frequency and this exact date 
		-- is used to determine if we have already invoiced the customer. 
		-- 09/17/2008 Paul.  The previous date calculations were based on previous period.  
		-- We are going to pre-pay, so the due date is at the beginning of the period. 
		-- 12/19/2018 Paul.  Provide a way to override the default invoice stage. 
		update INVOICES
		   set DUE_DATE      = @BeginDate
		     , INVOICE_STAGE = isnull(@INVOICE_STAGE, INVOICE_STAGE)
		 where ID            = @INVOICE_ID;

		-- 07/04/2008 Paul.  One set of repeat items is added by ConvertOrder, now we need to add the rest.
		-- We add the frequency here so that UpdateUsage will not see the multiplied rows. 
		-- 07/29/2008 Paul.  The POSITION needs to be managed externally so that it can be incremented for each row and each month. 
		-- 07/29/2008 Paul.  Since we have already inserted some line items above from spINVOICES_ConvertOrder, make sure to pick-up where we left off. 
		-- 06/07/2018 Paul.  Add one to position. 
		select @POSITION = count(*) + 1
		  from INVOICES_LINE_ITEMS
		 where INVOICE_ID = @INVOICE_ID;
		while @FREQUENCY_MULTIPLIER is not null and @FREQUENCY_MULTIPLIER > 1 begin -- do
			-- 09/17/2008 Paul.  Now that we are pre-pay, the multiplyer moves forward in time. 
			set @BeginDate      = dateadd(month, 1, @BeginDate);
			set @EndDateMonthly = dateadd(month, 1, @EndDateMonthly);
			set @LINE_ITEM_ID   = null;
			set @REPEAT_COMMENT = ' - from ' + convert(varchar(20), @BeginDate, 101) + ' to ' + convert(varchar(20), @EndDateMonthly, 101);
			print @REPEAT_COMMENT;
			exec dbo.spINVOICES_LINE_ITEMS_ConvertOrder @LINE_ITEM_ID out, null, @ORDER_ID, @INVOICE_ID, 0, @REPEAT_COMMENT, @POSITION out;
			set @FREQUENCY_MULTIPLIER = @FREQUENCY_MULTIPLIER - 1;
		end -- while;
		-- 08/07/2008 Paul.  Update totals and amount after adding re-occurring items. 
		exec dbo.spINVOICES_UpdateTotals    @INVOICE_ID, null;
		exec dbo.spINVOICES_UpdateAmountDue @INVOICE_ID, null;

		if @BILLING_INVOICE_TEMPLATE_ID is not null and @BILLING_INVOICE_FROM_EMAIL is not null begin -- then
			set @QUEUE_ID = null;
			exec dbo.spEMAILS_QueueEmailTemplate @QUEUE_ID out, null, @BILLING_INVOICE_FROM_EMAIL, @BILLING_INVOICE_FROM_NAME, N'Invoices', @INVOICE_ID, @BILLING_INVOICE_TEMPLATE_ID;
		end -- if;

		print '';
		fetch next from orders_cursor into @ACCOUNT_ID, @ACCOUNT_NAME, @ORDER_ID, @ORDER_NAME, @BILLING_FREQUENCY, @FREQUENCY_MULTIPLIER, @DATE_ORDER_DUE, @BeginDate, @EndDate;
/* -- #if Oracle
		IF orders_cursor%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close orders_cursor;
	deallocate orders_cursor;
  end
GO

Grant Execute on dbo.spINVOICES_ReoccurringOrders to public;
GO


