

print 'TERMINOLOGY OfficeAddin en-us';
GO

set nocount on;
GO

-- select * from TERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'OfficeAddin'                                       , N'en-US', null, N'moduleList', 158, N'SplendidCRM Office Addin';
-- 03/21/2016 Paul.  OfficeAddin needs a way to launch externally. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VIEW_BUTTON_LABEL'                             , N'en-US', null, null, null, N'View';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ARCHIVE_EMAIL_BUTTON_LABEL'                    , N'en-US', null, null, null, N'Archive Email to SplendidCRM';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VIEW_IN_SPLENDIDCRM'                           , N'en-US', null, null, null, N'View in SplendidCRM';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADD_RECIPIENT'                                 , N'en-US', null, null, null, N'Add Recipient';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ATTACH_PDF'                                    , N'en-US', null, null, null, N'Attach as PDF';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MORE_RECORDS'                                  , N'en-US', null, null, null, N'More . . .';
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

call dbo.spTERMINOLOGY_OfficeAddin_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_OfficeAddin_en_us')
/
-- #endif IBM_DB2 */
