

print 'DASHBOARDS Professional';
GO

set nocount on;
GO


-- Default Team Dashboard. 
exec dbo.spDASHBOARDS_InsertOnly '1B41CB3A-2B37-493A-AF58-9B80123F92B1', null, '17BB7135-2B95-42DC-85DE-842CAFF927A0', 'Team Dashboard', 'Home';

if not exists(select * from DASHBOARDS_PANELS where DASHBOARD_ID = '1B41CB3A-2B37-493A-AF58-9B80123F92B1') begin -- then
	exec dbo.spDASHBOARDS_PANELS_InsertOnly '1B41CB3A-2B37-493A-AF58-9B80123F92B1', 'My Team Accounts'                  , 0, 0,  6;
	exec dbo.spDASHBOARDS_PANELS_InsertOnly '1B41CB3A-2B37-493A-AF58-9B80123F92B1', 'My Team Contacts'                  , 1, 0,  6;
	exec dbo.spDASHBOARDS_PANELS_InsertOnly '1B41CB3A-2B37-493A-AF58-9B80123F92B1', 'My Team Leads'                     , 2, 1,  6;
	exec dbo.spDASHBOARDS_PANELS_InsertOnly '1B41CB3A-2B37-493A-AF58-9B80123F92B1', 'My Team Opportunities'             , 3, 1,  6;
	exec dbo.spDASHBOARDS_PANELS_InsertOnly '1B41CB3A-2B37-493A-AF58-9B80123F92B1', 'My Team Cases'                     , 4, 2,  6;
	exec dbo.spDASHBOARDS_PANELS_InsertOnly '1B41CB3A-2B37-493A-AF58-9B80123F92B1', 'My Team Bugs'                      , 5, 2,  6;
	exec dbo.spDASHBOARDS_PANELS_InsertOnly '1B41CB3A-2B37-493A-AF58-9B80123F92B1', 'My Team Quotes'                    , 6, 3,  6;
	exec dbo.spDASHBOARDS_PANELS_InsertOnly '1B41CB3A-2B37-493A-AF58-9B80123F92B1', 'My Team Orders'                    , 7, 3,  6;
	exec dbo.spDASHBOARDS_PANELS_InsertOnly '1B41CB3A-2B37-493A-AF58-9B80123F92B1', 'My Team Pipeline By Sales Stage'   , 8, 4, 12;
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

call dbo.spDASHBOARDS_Professional()
/

call dbo.spSqlDropProcedure('spDASHBOARDS_Professional')
/

-- #endif IBM_DB2 */

