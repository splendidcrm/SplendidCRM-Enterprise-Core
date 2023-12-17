

print 'MODULES MachineLearningModels';
GO

set nocount on;
GO

-- 08/08/2021 Paul.  Add MachineLearningModels module. 
exec dbo.spMODULES_InsertOnly null, 'MachineLearningModels'             , '.moduleList.MachineLearningModels'                , '~/Administration/MachineLearningModels/'        , 1, 0,  0, 0, 0, 0, 0, 1, 'MACHINE_LEARNING_MODELS', 0, 0, 0, 0, 0, 1;
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

call dbo.spMODULES_MachineLearningModels()
/

call dbo.spSqlDropProcedure('spMODULES_MachineLearningModels')
/

-- #endif IBM_DB2 */

