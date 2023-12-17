

print 'SCHEDULERS Workflow';
GO

set nocount on;
GO

-- 01/28/2009 Paul.  Fix the interval.  A double colon was missing between day and hour. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Check Reoccurring Orders at 9pm'            , N'function::pollReoccurringOrders'                     , null, null, N'0::21::*::*::*'  , null, null, N'Inactive', 0;
exec dbo.spSCHEDULERS_InsertOnly null, N'Check Pending Invoices at 10pm'             , N'function::pollPendingInvoices'                       , null, null, N'0::22::*::*::*'  , null, null, N'Inactive', 0;
GO

if exists(select * from SCHEDULERS where JOB_INTERVAL = N'0:21::*::*::*' and DELETED = 0) begin -- then
	print 'Fix Reoccurring Orders job interval.';
	update SCHEDULERS
	   set JOB_INTERVAL = N'0::21::*::*::*'
	 where JOB_INTERVAL = N'0:21::*::*::*'
	   and DELETED      = 0;
end -- if;

if exists(select * from SCHEDULERS where JOB_INTERVAL = N'0:22::*::*::*' and DELETED = 0) begin -- then
	print 'Fix Pending Invoices job interval.';
	update SCHEDULERS
	   set JOB_INTERVAL = N'0::22::*::*::*'
	 where JOB_INTERVAL = N'0:22::*::*::*'
	   and DELETED      = 0;
end -- if;
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

call dbo.spSCHEDULERS_Workflow()
/

call dbo.spSqlDropProcedure('spSCHEDULERS_Workflow')
/

-- #endif IBM_DB2 */

