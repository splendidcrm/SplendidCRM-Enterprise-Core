

-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:35 AM.
print 'TERMINOLOGY Administration en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AMAZON_FPS'                                , N'en-US', N'Administration', null, null, N'Flexible Payments Service';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AMAZON_FPS_DESC'                           , N'en-US', N'Administration', null, null, N'Allows the movement of money between any two entities, humans or computers.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AMAZON_S3'                                 , N'en-US', N'Administration', null, null, N'Simple Storage Services';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AMAZON_S3_DESC'                            , N'en-US', N'Administration', null, null, N'Upload and delete files and buckets.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AMAZON_WEB_SERVICES_TITLE'                 , N'en-US', N'Administration', null, null, N'Amazon Web Services';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_WORKFLOW'                           , N'en-US', N'Administration', null, null, N'Manage Workflow';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_WORKFLOW_TITLE'                     , N'en-US', N'Administration', null, null, N'Manage Workflow';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYPAL'                                    , N'en-US', N'Administration', null, null, N'Paypal';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYPAL_DESC'                               , N'en-US', N'Administration', null, null, N'Allows the import of transactions from the PayPal service.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYPAL_TRANSACTIONS_TITLE'                 , N'en-US', N'Administration', null, null, N'Paypal Transactions';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WORKFLOW_EVENT_LOG'                        , N'en-US', N'Administration', null, null, N'Workflow Event Log';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WORKFLOW_EVENT_LOG_TITLE'                  , N'en-US', N'Administration', null, null, N'Workflow Event Log';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WORKFLOW_TITLE'                            , N'en-US', N'Administration', null, null, N'Workflow';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'Administration'                                , N'en-US', null, N'moduleList'                        ,  35, N'Administration';
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

call dbo.spTERMINOLOGY_Administration_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Administration_en_us')
/
-- #endif IBM_DB2 */
