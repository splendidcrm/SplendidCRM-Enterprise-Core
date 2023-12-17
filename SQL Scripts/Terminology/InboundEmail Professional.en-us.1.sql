

print 'TERMINOLOGY InboundEmail Professional en-us';
GO

set nocount on;
GO

-- 01/26/2017 Paul.  Add support for Office 365 OAuth. 
-- 01/31/2017 Paul.  Add support for Exchange using Username/Password. 
-- select * from TERMINOLOGY where LIST_NAME = 'dom_email_server_type';
exec dbo.spTERMINOLOGY_InsertOnly N'Office365'                                     , N'en-US', null, N'dom_email_server_type'             ,   3, N'Office 365';
exec dbo.spTERMINOLOGY_InsertOnly N'GoogleApps'                                    , N'en-US', null, N'dom_email_server_type'             ,   4, N'Gmail';
exec dbo.spTERMINOLOGY_InsertOnly N'Exchange-Password'                             , N'en-US', null, N'dom_email_server_type'             ,   5, N'Exchange';
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

call dbo.spTERMINOLOGY_InboundEmail_Pro_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_InboundEmail_Pro_en_us')
/
-- #endif IBM_DB2 */
