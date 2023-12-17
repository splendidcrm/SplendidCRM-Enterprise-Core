

print 'TERMINOLOGY Users Professional en-us';
GO

set nocount on;
GO

-- 01/31/2017 Paul.  Add support for Exchange using Username/Password. 
exec dbo.spTERMINOLOGY_InsertOnly N'Office365'                                     , N'en-US', null, N'user_mail_send_type', 2, N'Office 365';
exec dbo.spTERMINOLOGY_InsertOnly N'GoogleApps'                                    , N'en-US', null, N'user_mail_send_type', 3, N'Gmail';
exec dbo.spTERMINOLOGY_InsertOnly N'Exchange-Password'                             , N'en-US', null, N'user_mail_send_type', 4, N'Exchange';
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

call dbo.spTERMINOLOGY_UsersPro_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_UsersPro_en_us')
/
-- #endif IBM_DB2 */
