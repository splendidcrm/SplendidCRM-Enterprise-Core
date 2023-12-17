

-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:35 AM.
print 'TERMINOLOGY ContractTypes en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'ERR_CONTRACT_TYPE_NOT_FOUND'                   , N'en-US', N'ContractTypes', null, null, N'Contract Type Not Found.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'ContractTypes', null, null, N'Contract Type List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LIST_ORDER'                           , N'en-US', N'ContractTypes', null, null, N'List Order';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'ContractTypes', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ORDER'                                , N'en-US', N'ContractTypes', null, null, N'List Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'ContractTypes', null, null, N'Contract Types';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'ContractTypes', null, null, N'CtT';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'ContractTypes', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER'                                     , N'en-US', N'ContractTypes', null, null, N'Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_CONTRACT_TYPE_LIST'                        , N'en-US', N'ContractTypes', null, null, N'Contract Types';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_CONTRACT_TYPE'                         , N'en-US', N'ContractTypes', null, null, N'Create Contract Type';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'ContractTypes'                                 , N'en-US', null, N'moduleList'                        ,  79, N'Contract Types';
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

call dbo.spTERMINOLOGY_ContractTypes_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_ContractTypes_en_us')
/
-- #endif IBM_DB2 */
