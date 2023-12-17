

print 'SHORTCUTS MachineLearningModels';
-- delete SHORTCUTS
GO

set nocount on;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'MachineLearningModels';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'MachineLearningModels' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'MachineLearningModels', 'MachineLearningModels.LNK_NEW_MACHINE_LEARNING_MODEL'   , '~/Administration/MachineLearningModels/edit.aspx'        , 'MachineLearningModels.gif'        , 1,  1, 'MachineLearningModels'     , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'MachineLearningModels', 'MachineLearningModels.LNK_MACHINE_LEARNING_MODEL_LIST'  , '~/Administration/MachineLearningModels/default.aspx'     , 'MachineLearningModels.gif'        , 1,  2, 'MachineLearningModels'     , 'list';
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

call dbo.spSHORTCUTS_MachineLearningModels()
/

call dbo.spSqlDropProcedure('spSHORTCUTS_MachineLearningModels')
/

-- #endif IBM_DB2 */

