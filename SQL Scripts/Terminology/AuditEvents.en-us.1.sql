

-- Terminology generated from database [SplendidCRM6_50] on 11/18/2010 11:37:52 PM.
print 'TERMINOLOGY AuditEvents en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUDIT_PARENT_ID'                           , N'en-US', N'AuditEvents', null, null, N'Audit Parent ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUDIT_TABLE'                               , N'en-US', N'AuditEvents', null, null, N'Audit Table:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_AUDIT_ACTION'                         , N'en-US', N'AuditEvents', null, null, N'Audit Action';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_AUDIT_ID'                             , N'en-US', N'AuditEvents', null, null, N'Audit ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_AUDIT_PARENT_ID'                      , N'en-US', N'AuditEvents', null, null, N'Audit Parent ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_AUDIT_TABLE'                          , N'en-US', N'AuditEvents', null, null, N'Audit Table';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_AUDIT_TOKEN'                          , N'en-US', N'AuditEvents', null, null, N'Audit Token';
-- 02/03/2021 Paul.  The React client requires the title. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'AuditEvents', null, null, N'Audit Events';

/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */

exec dbo.spTERMINOLOGY_InsertOnly N'-1'                                            , N'en-US', null, N'audit_action_dom'                  ,   1, N'Delete';
exec dbo.spTERMINOLOGY_InsertOnly N'0'                                             , N'en-US', null, N'audit_action_dom'                  ,   2, N'Insert';
exec dbo.spTERMINOLOGY_InsertOnly N'1'                                             , N'en-US', null, N'audit_action_dom'                  ,   3, N'Update';
GO


set nocount off;
GO

/* -- #if Oracle
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spTERMINOLOGY_AuditEvents_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_AuditEvents_en_us')
/
-- #endif IBM_DB2 */
