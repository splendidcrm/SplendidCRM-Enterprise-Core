

print 'DYNAMIC_BUTTONS EditView SaveDuplicate Professional';

set nocount on;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contracts.EditView' and COMMAND_NAME = 'SaveDuplicate' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveDuplicate 'Contracts.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Reports.EditView' and COMMAND_NAME = 'SaveDuplicate' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveDuplicate 'Reports.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Charts.EditView' and COMMAND_NAME = 'SaveDuplicate' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveDuplicate 'Charts.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'KBDocuments.EditView' and COMMAND_NAME = 'SaveDuplicate' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveDuplicate 'KBDocuments.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.EditView' and COMMAND_NAME = 'SaveDuplicate' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveDuplicate 'Invoices.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.EditView' and COMMAND_NAME = 'SaveDuplicate' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveDuplicate 'Orders.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.EditView' and COMMAND_NAME = 'SaveDuplicate' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveDuplicate 'Quotes.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductTemplates.EditView' and COMMAND_NAME = 'SaveDuplicate' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveDuplicate 'ProductTemplates.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.EditView' and COMMAND_NAME = 'SaveDuplicate' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveDuplicate 'Surveys.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyQuestions.EditView' and COMMAND_NAME = 'SaveDuplicate' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveDuplicate 'SurveyQuestions.EditView', -1, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'TwitterTracks.EditView' and COMMAND_NAME = 'SaveDuplicate' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsSaveDuplicate 'TwitterTracks.EditView', -1, null;
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

