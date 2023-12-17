

-- 05/02/2015 Paul.  Remove Global as default team for special users. 
-- 05/01/2016 Paul.  A service user does not need to be active in order for it to function properly. 
-- 09/03/2017 Paul.  Add nulls for, PICTURE and MAIL_ fields. 
if not exists(select * from USERS where ID = '00000000-0000-0000-0000-000000000009') begin -- then
	print 'USERS getresponse';
/* -- #if IBM_DB2
	exec dbo.spUSERS_Update in_USER_ID , '00000000-0000-0000-0000-000000000009', 'getresponse', null, 'GetResponse', null, 0, 0, null, null, null, null, null, null, null, null, null, null, 'Inactive', null, null, null, null, null, null, 0, null, null, null, null, null, 0, null, 0, null, null, 0, 0, 0, null, null, null, 0, 0, null, null, null, null, null, null, null, null;
-- #endif IBM_DB2 */
/* -- #if Oracle
	exec dbo.spUSERS_Update in_USER_ID , '00000000-0000-0000-0000-000000000009', 'getresponse', null, 'GetResponse', null, 0, 0, null, null, null, null, null, null, null, null, null, null, 'Inactive', null, null, null, null, null, null, 0, null, null, null, null, null, 0, null, 0, null, null, 0, 0, 0, null, null, null, 0, 0, null, null, null, null, null, null, null, null;
-- #endif Oracle */
-- #if SQL_Server /*
	exec dbo.spUSERS_Update         '00000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000009', 'getresponse', null, 'GetResponse', null, 0, 0, null, null, null, null, null, null, null, null, null, null, 'Inactive', null, null, null, null, null, null, 0, null, null, null, null, null, 0, null, 0, null, null, 0, 0, 0, null, null, null, 0, 0, null, null, null, null, null, null, null, null;
-- #endif SQL_Server */
	exec dbo.spUSERS_PasswordUpdate '00000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000009', '838bd1a68578bfde4c7d43fe02cb4ed9';
end -- if;
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

call dbo.spUSERS_getresponse()
/

call dbo.spSqlDropProcedure('spUSERS_getresponse')
/

-- #endif IBM_DB2 */


