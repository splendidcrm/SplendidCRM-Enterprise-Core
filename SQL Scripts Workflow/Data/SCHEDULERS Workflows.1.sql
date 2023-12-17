

print 'SCHEDULERS Workflow';
GO

set nocount on;
GO

exec dbo.spSCHEDULERS_InsertOnly null, N'Check Workflow Persistence'                 , N'function::pollWorkflowPersistence'                     , null, null, N'*::*::*::*::*'   , null, null, N'Active'  , 0;
-- 02/26/2010 Paul.  Clean the WWF tables once a week. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Clean Workflow Events Sunday at 9pm'        , N'function::CleanWorkflowEvents'                         , null, null, N'0::21::*::*::0'  , null, null, N'Active'  , 0;
-- 08/13/2021 Paul.  Update predictions nightly at 10 pm. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Run Machine Learning Predictions'           , N'function::RunMachineLearning'                          , null, null, N'0::22::*::*::*'   , null, null, N'Active'  , 0;
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

