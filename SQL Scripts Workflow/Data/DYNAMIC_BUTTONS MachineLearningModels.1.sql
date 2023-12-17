

print 'DYNAMIC_BUTTONS MachineLearningModels';
GO

set nocount on;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView'  , 'MachineLearningModels.EditView'  , 'MachineLearningModels';
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'MachineLearningModels.DetailView'
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'MachineLearningModels.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS MachineLearningModels.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit      'MachineLearningModels.DetailView', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDuplicate 'MachineLearningModels.DetailView', 1, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'MachineLearningModels.DetailView', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    'MachineLearningModels.DetailView', 3, null, 1;  -- DetailView Cancel is only visible on mobile. 
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'MachineLearningModels.DetailView', 4, null, null, 'MachineLearningModels', 'edit', 'MachineLearningModels.Train'   , null, 'MachineLearningModels.LBL_TRAIN_BUTTON'   , 'MachineLearningModels.LBL_TRAIN_BUTTON'   , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'MachineLearningModels.DetailView', 5, null, null, 'MachineLearningModels', 'edit', 'MachineLearningModels.Evaluate', null, 'MachineLearningModels.LBL_EVALUATE_BUTTON', 'MachineLearningModels.LBL_EVALUATE_BUTTON', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'MachineLearningModels.DetailView', 6, null, null, 'MachineLearningModels', 'edit', 'MachineLearningModels.Predict' , null, 'MachineLearningModels.LBL_PREDICT_BUTTON' , 'MachineLearningModels.LBL_PREDICT_BUTTON' , null, 'BaseModuleRecordPopup(); return false;', null;
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

call dbo.spDYNAMIC_BUTTONS_MachineLearningModels()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_MachineLearningModels')
/

-- #endif IBM_DB2 */

