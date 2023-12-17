

print 'MODULES_GROUPS Professional';
GO

set nocount on;
GO

-- 02/24/2010 Paul.  We need to specify an order to the modules for the tab menu. 

-- LBL_TABGROUP_SALES
exec dbo.spMODULES_GROUPS_InsertOnly 'Sales'        , 'Quotes'          ,  5, 1;
exec dbo.spMODULES_GROUPS_InsertOnly 'Sales'        , 'Orders'          ,  6, 1;
exec dbo.spMODULES_GROUPS_InsertOnly 'Sales'        , 'Invoices'        ,  7, 1;
exec dbo.spMODULES_GROUPS_InsertOnly 'Sales'        , 'Products'        ,  8, 0;
exec dbo.spMODULES_GROUPS_InsertOnly 'Sales'        , 'Contracts'       ,  9, 1;
exec dbo.spMODULES_GROUPS_InsertOnly 'Sales'        , 'CreditCards'     , 10, 0;
exec dbo.spMODULES_GROUPS_InsertOnly 'Sales'        , 'Payments'        , 11, 0;

-- LBL_TABGROUP_SUPPORT
exec dbo.spMODULES_GROUPS_InsertOnly 'Support'      , 'KBDocuments'     ,  6, 1;

-- LBL_TABGROUP_COLLABORATION
exec dbo.spMODULES_GROUPS_InsertOnly 'Collaboration', 'Forums'          ,  4, 1;
exec dbo.spMODULES_GROUPS_InsertOnly 'Collaboration', 'Posts'           ,  5, 1;

-- LBL_TABGROUP_REPORTS
exec dbo.spMODULES_GROUPS_InsertOnly 'Reports'      , 'Reports'         ,  1, 1;
-- 02/09/2012 Paul.  Charts belong to the Reports group. 
exec dbo.spMODULES_GROUPS_InsertOnly 'Reports'      , 'Charts'          ,  3, 1;
-- 11/17/2015 Paul.  Add Report Designer to Sugar tabs. 
exec dbo.spMODULES_GROUPS_InsertOnly 'Reports'      , 'ReportDesigner'  ,  4, 1;

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

call dbo.spMODULES_GROUPS_Professional()
/

call dbo.spSqlDropProcedure('spMODULES_GROUPS_Professional')
/

-- #endif IBM_DB2 */

