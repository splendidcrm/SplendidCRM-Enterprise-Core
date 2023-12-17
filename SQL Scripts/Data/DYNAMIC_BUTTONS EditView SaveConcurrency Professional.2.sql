

print 'DYNAMIC_BUTTONS EditView SaveConcurrency Professional';

set nocount on;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contracts.EditView' and COMMAND_NAME = 'SaveConcurrency' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveConcurrency 'Contracts.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Reports.EditView' and COMMAND_NAME = 'SaveConcurrency' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveConcurrency 'Reports.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Charts.EditView' and COMMAND_NAME = 'SaveConcurrency' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveConcurrency 'Charts.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'KBDocuments.EditView' and COMMAND_NAME = 'SaveConcurrency' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveConcurrency 'KBDocuments.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.EditView' and COMMAND_NAME = 'SaveConcurrency' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveConcurrency 'Invoices.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.EditView' and COMMAND_NAME = 'SaveConcurrency' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveConcurrency 'Orders.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.EditView' and COMMAND_NAME = 'SaveConcurrency' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveConcurrency 'Quotes.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductTemplates.EditView' and COMMAND_NAME = 'SaveConcurrency' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveConcurrency 'ProductTemplates.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.EditView' and COMMAND_NAME = 'SaveConcurrency' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveConcurrency 'Surveys.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyQuestions.EditView' and COMMAND_NAME = 'SaveConcurrency' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveConcurrency 'SurveyQuestions.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'TwitterTracks.EditView' and COMMAND_NAME = 'SaveConcurrency' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveConcurrency 'TwitterTracks.EditView', -1, null;
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

call dbo.spDYNAMIC_BUTTONS_EditViewSaveDupPro()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_EditViewSaveDupPro')
/

-- #endif IBM_DB2 */

