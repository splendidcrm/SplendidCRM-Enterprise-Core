

-- 11/15/2009 Paul.  We need to fix invoices with no INVOICE_NUM. 
-- 12/04/2009 Paul.  Move fix invoces to the data folder as spNUMBER_SEQUENCES_Formatted may not exist until now. 
-- These were created for a short period when spINVOICES_ConvertOrder did not properly set the invoice number. 
if exists(select * from INVOICES where DELETED = 0 and INVOICE_NUM is null) begin -- then
	print 'Fixing Invoices with an empty INVOICE_NUM';
	declare @ID          uniqueidentifier;
	declare @INVOICE_NUM nvarchar(30);
	declare INVOICE_NUM_CURSOR cursor for
	select ID
	  from INVOICES
	 where DELETED = 0
	   and INVOICE_NUM is null
	 order by DATE_ENTERED;

	open INVOICE_NUM_CURSOR;
	fetch next from INVOICE_NUM_CURSOR into @ID;
	while @@FETCH_STATUS = 0 begin -- while
		exec spNUMBER_SEQUENCES_Formatted 'INVOICES.INVOICE_NUM', 1, @INVOICE_NUM out;
		print @INVOICE_NUM;
		update INVOICES
		   set INVOICE_NUM = @INVOICE_NUM
		 where ID = @ID;
		fetch next from INVOICE_NUM_CURSOR into @ID;
	end -- while;
	close INVOICE_NUM_CURSOR;
	deallocate INVOICE_NUM_CURSOR;
end -- if;
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

call dbo.spINVOICES_Defaults()
/

call dbo.spSqlDropProcedure('spINVOICES_Defaults')
/

-- #endif IBM_DB2 */

