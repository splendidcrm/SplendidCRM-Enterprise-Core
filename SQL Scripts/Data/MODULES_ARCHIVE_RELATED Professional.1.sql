

print 'MODULES_ARCHIVE_RELATED defaults';
GO

set nocount on;
GO


if not exists(select * from MODULES_ARCHIVE_RELATED where MODULE_NAME = 'Accounts' and RELATED_NAME = 'Orders') begin -- then
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Accounts', 'Contracts'    ,  8;
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Accounts', 'Quotes'       ,  9;
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Accounts', 'Orders'       , 10;
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Accounts', 'Invoices'     , 11;
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Accounts', 'Payments'     , 12;
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Accounts', 'CreditCards'  , 13;
end -- if;
GO

if not exists(select * from MODULES_ARCHIVE_RELATED where MODULE_NAME = 'Contacts' and RELATED_NAME = 'Orders') begin -- then
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Contacts', 'Quotes'       ,  7;
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Contacts', 'Orders'       ,  8;
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Contacts', 'Invoices'     ,  9;
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Contacts', 'CreditCards'  , 10;
end -- if;
GO

if not exists(select * from MODULES_ARCHIVE_RELATED where MODULE_NAME = 'Opportunities' and RELATED_NAME = 'Contracts') begin -- then
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Opportunities', 'Contracts'    ,  2;
end -- if;
GO

if not exists(select * from MODULES_ARCHIVE_RELATED where MODULE_NAME = 'Quotes') begin -- then
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Quotes'  , 'Activities'   ,  0;
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Quotes'  , 'Cases'        ,  1;
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Quotes'  , 'Project'      ,  2;
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Quotes'  , 'Contracts'    ,  3;
end -- if;
GO

if not exists(select * from MODULES_ARCHIVE_RELATED where MODULE_NAME = 'Orders') begin -- then
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Orders'  , 'Activities'   ,  0;
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Orders'  , 'Cases'        ,  1;
end -- if;
GO

if not exists(select * from MODULES_ARCHIVE_RELATED where MODULE_NAME = 'Invoices') begin -- then
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Invoices', 'Activities'   ,  0;
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Invoices', 'Cases'        ,  1;
end -- if;
GO

if not exists(select * from MODULES_ARCHIVE_RELATED where MODULE_NAME = 'Contracts') begin -- then
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Contracts', 'Activities'   ,  0;
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Contracts', 'Documents'    ,  1;
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

call dbo.spMODULES_ARCHIVE_RELATED_Defaults()
/

call dbo.spSqlDropProcedure('spMODULES_ARCHIVE_RELATED_Defaults')
/

-- #endif IBM_DB2 */

