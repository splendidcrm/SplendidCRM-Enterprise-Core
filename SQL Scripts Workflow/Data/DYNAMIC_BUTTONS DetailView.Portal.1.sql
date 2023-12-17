

print 'DYNAMIC_BUTTONS DetailView.Portal';
-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.DetailView.Portal';
--GO

set nocount on;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = '.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS .DetailView.Portal';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit      '.DetailView.Portal'                     , 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    '.DetailView.Portal'                     , 3, null, 0;
end -- if;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView.Portal', 'Bugs.DetailView.Portal'     , 'Bugs'            ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView.Portal', 'Cases.DetailView.Portal'    , 'Cases'           ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView.Portal', 'Contacts.DetailView.Portal' , 'Contacts'        ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView.Portal', 'Notes.DetailView.Portal'    , 'Notes'           ;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'KBDocuments.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS KBDocuments.DetailView.Portal';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'KBDocuments.DetailView.Portal', 0, 'KBDocuments', N'view', null, null, N'View', N'view.aspx?ID={0}', N'ID', N'.LBL_DETAILS_BUTTON_LABEL', N'.LBL_DETAILS_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'KBDocuments.DetailView.Portal', 1, null, 0;
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

call dbo.spDYNAMIC_BUTTONS_DetailViewPortal()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_DetailViewPortal')
/

-- #endif IBM_DB2 */

