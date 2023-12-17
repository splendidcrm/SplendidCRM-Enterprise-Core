

print 'MODULES_ARCHIVE_RELATED DataPrivacy';
GO

set nocount on;
GO


if not exists(select * from MODULES_ARCHIVE_RELATED where MODULE_NAME = 'Accounts' and RELATED_NAME = 'DataPrivacy') begin -- then
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Accounts' , 'DataPrivacy',  8;
end -- if;
GO

if not exists(select * from MODULES_ARCHIVE_RELATED where MODULE_NAME = 'Contacts' and RELATED_NAME = 'DataPrivacy') begin -- then
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Contacts' , 'DataPrivacy',  7;
end -- if;
GO

if not exists(select * from MODULES_ARCHIVE_RELATED where MODULE_NAME = 'Leads' and RELATED_NAME = 'DataPrivacy') begin -- then
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Leads'    , 'DataPrivacy',  3;
end -- if;
GO

if not exists(select * from MODULES_ARCHIVE_RELATED where MODULE_NAME = 'Prospects' and RELATED_NAME = 'DataPrivacy') begin -- then
	exec dbo.spMODULES_ARCHIVE_RELATED_InsertOnly 'Prospects', 'DataPrivacy',  1;
end -- if;
GO

-- 06/26/2018 Paul.  Build the views to the archive tables. Use NULL for the archive database for DataPrivacy. It will join to archive views. 
exec dbo.spSqlBuildNonArchiveRelatedView 'DataPrivacy', null;
GO

declare @ARCHIVE_DATABASE     nvarchar(50);
set @ARCHIVE_DATABASE = dbo.fnCONFIG_String('Archive.Database');
exec dbo.spSqlBuildArchiveRelatedView 'Accounts' , @ARCHIVE_DATABASE;
exec dbo.spSqlBuildArchiveRelatedView 'Contacts' , @ARCHIVE_DATABASE;
exec dbo.spSqlBuildArchiveRelatedView 'Leads'    , @ARCHIVE_DATABASE;
exec dbo.spSqlBuildArchiveRelatedView 'Prospects', @ARCHIVE_DATABASE;

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

call dbo.spMODULES_ARCHIVE_RELATED_DataPrivacy()
/

call dbo.spSqlDropProcedure('spMODULES_ARCHIVE_RELATED_DataPrivacy')
/

-- #endif IBM_DB2 */

