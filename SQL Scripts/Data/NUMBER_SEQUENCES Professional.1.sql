

print 'NUMBER_SEQUENCES Professional';
GO

set nocount on;
GO

-- 08/20/2010 Paul.  Might as well use NULL for alpha prefix and suffix. 
exec dbo.spNUMBER_SEQUENCES_InsertOnly null, N'QUOTES.QUOTE_NUM'          , null, null, 1, 0, 0;
exec dbo.spNUMBER_SEQUENCES_InsertOnly null, N'ORDERS.ORDER_NUM'          , null, null, 1, 0, 0;
exec dbo.spNUMBER_SEQUENCES_InsertOnly null, N'INVOICES.INVOICE_NUM'      , null, null, 1, 0, 0;
exec dbo.spNUMBER_SEQUENCES_InsertOnly null, N'PAYMENTS.PAYMENT_NUM'      , null, null, 1, 0, 0;
GO


set nocount off;
GO

/* -- #if Oracle
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			StoO_selcnt := 0;
		WHEN OTHERS THEN
			RAISE;
	END;
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spNUMBER_SEQUENCES_Professional()
/

call dbo.spSqlDropProcedure('spNUMBER_SEQUENCES_Professional')
/

-- #endif IBM_DB2 */

