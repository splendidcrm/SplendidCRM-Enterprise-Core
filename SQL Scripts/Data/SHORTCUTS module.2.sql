

declare @MODULE_NAME        nvarchar(25);
declare @RELATIVE_PATH      nvarchar(50);
declare @RELATIVE_PATH_LIKE nvarchar(60);
/* -- #if IBM_DB2
declare in_FETCH_STATUS int;
-- #endif IBM_DB2 */

declare module_cursor cursor for
select MODULE_NAME
     , RELATIVE_PATH
  from MODULES
 order by MODULE_NAME;

/* -- #if IBM_DB2
declare continue handler for not found
	set in_FETCH_STATUS = 1;
set in_FETCH_STATUS = 0;
-- #endif IBM_DB2 */

if exists(select *
            from vwSHORTCUTS
           where SHORTCUT_ACLTYPE is null
             and RELATIVE_PATH like '%/edit.aspx%'
         ) begin -- then
	update SHORTCUTS
	   set SHORTCUT_ACLTYPE = 'edit'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where RELATIVE_PATH like '%/edit.aspx%'
	   and SHORTCUT_ACLTYPE is null;
end -- if;

if exists(select *
            from vwSHORTCUTS
           where SHORTCUT_ACLTYPE is null
             and (   RELATIVE_PATH like '%/default.aspx%'
                  or RELATIVE_PATH like '%/ByUser.aspx%'
                  or RELATIVE_PATH    = '~/Emails/Drafts.aspx'
                  or RELATIVE_PATH    = '~/Feeds/MyFeeds.aspx'
                 )
         ) begin -- then
	update SHORTCUTS
	   set SHORTCUT_ACLTYPE = 'list'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where SHORTCUT_ACLTYPE is null
	   and (   RELATIVE_PATH like '%/default.aspx%'
	        or RELATIVE_PATH like '%/ByUser.aspx%'
	        or RELATIVE_PATH    = '~/Emails/Drafts.aspx'
	        or RELATIVE_PATH    = '~/Feeds/MyFeeds.aspx'
	       );
end -- if;

if exists(select *
            from vwSHORTCUTS
           where SHORTCUT_MODULE is null
         ) begin -- then
	open module_cursor;
	fetch next from module_cursor into @MODULE_NAME, @RELATIVE_PATH;
	while @@FETCH_STATUS = 0 begin -- do
		print @MODULE_NAME
		set @RELATIVE_PATH_LIKE = @RELATIVE_PATH + N'%';
		update SHORTCUTS
		   set SHORTCUT_MODULE  = @MODULE_NAME
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where RELATIVE_PATH like @RELATIVE_PATH_LIKE
		   and SHORTCUT_MODULE is null;
		fetch next from module_cursor into @MODULE_NAME, @RELATIVE_PATH;
	end -- while;
	close module_cursor;
end -- if;
deallocate module_cursor;

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

call dbo.spSHORTCUTS_ShortcutModule()
/

call dbo.spSqlDropProcedure('spSHORTCUTS_ShortcutModule')
/

-- #endif IBM_DB2 */

