

-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:42 AM.
print 'TERMINOLOGY Regions en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COUNTRIES'                                 , N'en-US', N'Regions', null, null, N'Countries';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COUNTRY'                                   , N'en-US', N'Regions', null, null, N'Country:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'Regions', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_COUNTRY'                              , N'en-US', N'Regions', null, null, N'Country';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'Regions', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'Regions', null, null, N'Regions List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'Regions', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'Regions', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEARCH_FORM_TITLE'                         , N'en-US', N'Regions', null, null, N'Search';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_LIST_REGIONS'                              , N'en-US', N'Regions', null, null, N'List Regions';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_REGION'                                , N'en-US', N'Regions', null, null, N'Create Region';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'Regions', null, null, N'Reg';
-- 01/01/2017 Paul.  Add standard module name term. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'Regions', null, null, N'Regions';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'Regions'                                       , N'en-US', null, N'moduleList'                        ,  87, N'Regions';
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

call dbo.spTERMINOLOGY_Regions_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Regions_en_us')
/
-- #endif IBM_DB2 */
