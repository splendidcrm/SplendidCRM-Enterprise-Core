

declare @MODULE_NAME        nvarchar(25);
declare @RELATIVE_PATH      nvarchar(50);
declare @RELATIVE_PATH_LIKE nvarchar(60);
-- 05/02/2006 Paul.  DB2 was having a problem with {0} used in the if clause. 
declare @URL_FORMAT_MAILT0  nvarchar(100);
declare @URL_FORMAT_LINK    nvarchar(100);
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
set @URL_FORMAT_MAILT0 = N'mailto:{0}';
set @URL_FORMAT_LINK   = N'{0}';
print 'GRIDVIEWS_COLUMNS module';

-- 04/28/2006 Paul.  The Documents module requires a special correction. 
if exists(select *
           from GRIDVIEWS_COLUMNS
          where DATA_FORMAT = N'HyperLink'
            and GRID_NAME   = N'Documents.ListView'
            and URL_FORMAT  = N'view.aspx?id={0}'
            and DELETED     = 0
            and URL_MODULE is null
         ) begin -- then
	update GRIDVIEWS_COLUMNS
	   set URL_MODULE       = N'Documents'
	     , URL_FORMAT       = N'~/Documents/view.aspx?id={0}'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where DATA_FORMAT      = N'HyperLink'
	   and GRID_NAME        = N'Documents.ListView'
	   and URL_FORMAT       = N'view.aspx?id={0}'
	   and DELETED          = 0
	   and URL_MODULE is null;
end -- if;

-- 04/28/2006 Paul.  The Parents links require special handling. 
if exists(select *
           from GRIDVIEWS_COLUMNS
          where DATA_FORMAT   = N'HyperLink'
            and URL_FORMAT like N'~/Parents/%'
            and DELETED       = 0
            and URL_MODULE is null
         ) begin -- then
	update GRIDVIEWS_COLUMNS
	   set URL_MODULE       = N'Parents'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where DATA_FORMAT      = N'HyperLink'
	   and URL_FORMAT    like N'~/Parents/%'
	   and DELETED          = 0
	   and URL_MODULE is null;
end -- if;

if exists(select *
            from vwGRIDVIEWS_COLUMNS
           where DATA_FORMAT = N'HyperLink'
             and URL_FORMAT like N'~%'
             and URL_MODULE is null
         ) begin -- then
	open module_cursor;
	fetch next from module_cursor into @MODULE_NAME, @RELATIVE_PATH;
	while @@FETCH_STATUS = 0 begin -- do
		set @RELATIVE_PATH_LIKE = @RELATIVE_PATH + N'%';
		-- 01/01/2008 Paul.  Make sure not to update any modules that don't need updating. 
		-- 01/01/2008 Paul.  Campaigns.TrackLog is a special case that does not use ASSIGNED_USER_ID. 
		if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME <> N'Campaigns.TrackLog' and DATA_FORMAT = N'HyperLink' and URL_FORMAT like @RELATIVE_PATH_LIKE and URL_MODULE is null) begin -- then 
			print N'Update HyperLink URL_MODULE for ' + @MODULE_NAME;
			update GRIDVIEWS_COLUMNS
			   set URL_MODULE       = @MODULE_NAME
			     , DATE_MODIFIED    = getdate()
			     , MODIFIED_USER_ID = null
			 where GRID_NAME <> N'Campaigns.TrackLog'
			   and DATA_FORMAT   = N'HyperLink'
			   and URL_FORMAT like @RELATIVE_PATH_LIKE
			   and URL_MODULE is null;
		end -- if;
		fetch next from module_cursor into @MODULE_NAME, @RELATIVE_PATH;
	end -- while;
	close module_cursor;
end -- if;
deallocate module_cursor;


-- 05/02/2006 Paul.  If the link is in the first column, then it is a primary link. 
-- The assigned user id is always ASSIGNED_USER_ID. 
-- 01/01/2008 Paul.  We have a new way to determine if a module supports ASSIGNED_USER_ID. 
-- 01/18/2008 Paul.  Oracle needs a statement terminator. 
-- 03/28/2013 Paul.  ProductTemplates.ListView does not have a ASSIGNED_USER_ID. 
-- 08/27/2022 Paul.  BusinessProcessesLog.ListView does not have a ASSIGNED_USER_ID. 
if exists(select *
           from GRIDVIEWS_COLUMNS
          where DATA_FORMAT = N'HyperLink'
            and URL_FORMAT <> @URL_FORMAT_MAILT0
            and URL_FORMAT <> @URL_FORMAT_LINK
            and URL_FIELD  <> N'ID'
            and URL_ASSIGNED_FIELD is null
            and COLUMN_INDEX <= 1
            and GRID_NAME  not in ('ProductTemplates.ListView', 'BusinessProcessesLog.ListView')
            and URL_MODULE in (select MODULE_NAME from vwMODULES_AppVars where IS_ASSIGNED = 1)
         ) begin -- then
	print N'The assigned user id is always ASSIGNED_USER_ID.';
	update GRIDVIEWS_COLUMNS
	   set URL_ASSIGNED_FIELD = N'ASSIGNED_USER_ID'
	     , DATE_MODIFIED      = getdate()
	     , MODIFIED_USER_ID   = null
         where DATA_FORMAT = N'HyperLink'
           and URL_FORMAT <> @URL_FORMAT_MAILT0
           and URL_FORMAT <> @URL_FORMAT_LINK
           and URL_FIELD  <> N'ID'
           and URL_ASSIGNED_FIELD is null
           and COLUMN_INDEX <= 1
	   and GRID_NAME  not in ('ProductTemplates.ListView', 'BusinessProcessesLog.ListView')
           and URL_MODULE in (select MODULE_NAME from vwMODULES_AppVars where IS_ASSIGNED = 1);
end -- if;

-- 05/02/2006 Paul.  Links to primary IDs should use the NAME field. This is a convention. 
-- 01/01/2008 Paul.  We have a new way to determine if a module supports ASSIGNED_USER_ID. 
-- 01/18/2008 Paul.  Oracle needs a statement terminator. 
-- 03/28/2013 Paul.  ProductTemplates.ListView does not have a ASSIGNED_USER_ID. 
-- 08/27/2022 Paul.  BusinessProcessesLog.ListView does not have a ASSIGNED_USER_ID. 
if exists(select *
           from GRIDVIEWS_COLUMNS
          where DATA_FORMAT = N'HyperLink'
            and URL_FORMAT <> @URL_FORMAT_MAILT0
            and URL_FORMAT <> @URL_FORMAT_LINK
            and URL_FIELD  = N'ID'
            and URL_ASSIGNED_FIELD is null
            and COLUMN_INDEX <= 1
            and GRID_NAME  not in ('ProductTemplates.ListView', 'BusinessProcessesLog.ListView')
            and URL_MODULE in (select MODULE_NAME from vwMODULES_AppVars where IS_ASSIGNED = 1)
         ) begin -- then
	print N'Links to primary IDs should use the NAME field.';
	update GRIDVIEWS_COLUMNS
	   set URL_ASSIGNED_FIELD = N'ASSIGNED_USER_ID'
	     , DATA_FIELD         = N'NAME'
	     , DATE_MODIFIED      = getdate()
	     , MODIFIED_USER_ID   = null
         where DATA_FORMAT = N'HyperLink'
           and URL_FORMAT <> @URL_FORMAT_MAILT0
           and URL_FORMAT <> @URL_FORMAT_LINK
           and URL_FIELD  = N'ID'
           and URL_ASSIGNED_FIELD is null
           and COLUMN_INDEX <= 1
	   and GRID_NAME  not in ('ProductTemplates.ListView', 'BusinessProcessesLog.ListView')
           and URL_MODULE in (select MODULE_NAME from vwMODULES_AppVars where IS_ASSIGNED = 1);
end -- if;

-- 04/05/2013 Paul.  Exclude INVOICE_NUM, ORDER_NUM and QUOTE_NUM.  We still want to correct ASSIGNED_USER_ID, so use a second step. 
if exists(select *
           from GRIDVIEWS_COLUMNS
          where DATA_FORMAT        = N'HyperLink'
	    and SORT_EXPRESSION    = N'INVOICE_NUM'
	    and DATA_FIELD         = N'NAME'
            and URL_FIELD          = N'ID'
	    and URL_ASSIGNED_FIELD = N'ASSIGNED_USER_ID'
         ) begin -- then
	print N'Fix INVOICE_NUM.';
	update GRIDVIEWS_COLUMNS
	   set DATA_FIELD         = N'INVOICE_NUM'
	     , DATE_MODIFIED      = getdate()
	     , DATE_MODIFIED_UTC  = getutcdate()
	     , MODIFIED_USER_ID   = null
	 where DATA_FORMAT        = N'HyperLink'
	   and SORT_EXPRESSION    = N'INVOICE_NUM'
	   and DATA_FIELD         = N'NAME'
	   and URL_FIELD          = N'ID'
	   and URL_ASSIGNED_FIELD = N'ASSIGNED_USER_ID';
end -- if;

-- 04/05/2013 Paul.  Exclude INVOICE_NUM, ORDER_NUM and QUOTE_NUM.  We still want to correct ASSIGNED_USER_ID, so use a second step. 
if exists(select *
           from GRIDVIEWS_COLUMNS
          where DATA_FORMAT        = N'HyperLink'
	    and SORT_EXPRESSION    = N'ORDER_NUM'
	    and DATA_FIELD         = N'NAME'
            and URL_FIELD          = N'ID'
	    and URL_ASSIGNED_FIELD = N'ASSIGNED_USER_ID'
         ) begin -- then
	print N'Fix INVOICE_NUM.';
	update GRIDVIEWS_COLUMNS
	   set DATA_FIELD         = N'ORDER_NUM'
	     , DATE_MODIFIED      = getdate()
	     , DATE_MODIFIED_UTC  = getutcdate()
	     , MODIFIED_USER_ID   = null
	 where DATA_FORMAT        = N'HyperLink'
	   and SORT_EXPRESSION    = N'ORDER_NUM'
	   and DATA_FIELD         = N'NAME'
	   and URL_FIELD          = N'ID'
	   and URL_ASSIGNED_FIELD = N'ASSIGNED_USER_ID';
end -- if;

-- 04/05/2013 Paul.  Exclude INVOICE_NUM, ORDER_NUM and QUOTE_NUM.  We still want to correct ASSIGNED_USER_ID, so use a second step. 
if exists(select *
           from GRIDVIEWS_COLUMNS
          where DATA_FORMAT        = N'HyperLink'
	    and SORT_EXPRESSION    = N'QUOTE_NUM'
	    and DATA_FIELD         = N'NAME'
            and URL_FIELD          = N'ID'
	    and URL_ASSIGNED_FIELD = N'ASSIGNED_USER_ID'
         ) begin -- then
	print N'Fix INVOICE_NUM.';
	update GRIDVIEWS_COLUMNS
	   set DATA_FIELD         = N'QUOTE_NUM'
	     , DATE_MODIFIED      = getdate()
	     , DATE_MODIFIED_UTC  = getutcdate()
	     , MODIFIED_USER_ID   = null
	 where DATA_FORMAT        = N'HyperLink'
	   and SORT_EXPRESSION    = N'QUOTE_NUM'
	   and DATA_FIELD         = N'NAME'
	   and URL_FIELD          = N'ID'
	   and URL_ASSIGNED_FIELD = N'ASSIGNED_USER_ID';
end -- if;

-- 05/02/2006 Paul.  If the link is not in the first column, then it is a relationship link. 
-- 07/17/2006 Paul.  Truncate the URL_ASSIGNED_FIELD otherwise DB2 will complain. Then fixup the special fields. 
-- 01/01/2008 Paul.  We have a new way to determine if a module supports ASSIGNED_USER_ID. 
-- 01/01/2008 Paul.  Campaigns.TrackLog is a special case that does not use ASSIGNED_USER_ID. 
-- 01/18/2008 Paul.  Oracle needs a statement terminator. 
-- 07/14/2013 Paul.  Fix problem with long name RVEY_QUESTION_ASSIGNED_USER_ID. 
-- 03/05/2022 Paul.  Fix problem with long name DUCT_TEMPLATE_ASSIGNED_USER_ID. 
if exists(select *
           from GRIDVIEWS_COLUMNS
          where DATA_FORMAT = N'HyperLink'
            and URL_FORMAT <> @URL_FORMAT_MAILT0
            and URL_FORMAT <> @URL_FORMAT_LINK
            and URL_FIELD <> N'ID'
            and URL_ASSIGNED_FIELD is null
            and COLUMN_INDEX > 1
            and GRID_NAME <> N'Campaigns.TrackLog'
            and URL_MODULE in (select MODULE_NAME from vwMODULES_AppVars where IS_ASSIGNED = 1)
            and right(replace(URL_FIELD, N'_ID', N'_') + N'ASSIGNED_USER_ID', 30) <> 'DUCT_TEMPLATE_ASSIGNED_USER_ID'
         ) begin -- then
	print N'If the link is not in the first column, then it is a relationship link.';
	update GRIDVIEWS_COLUMNS
	   set URL_ASSIGNED_FIELD = replace(right(replace(URL_FIELD, N'_ID', N'_') + N'ASSIGNED_USER_ID', 30), 'RVEY_QUESTION_ASSIGNED_USER_ID', 'QUESTION_ASSIGNED_USER_ID')
	     , DATE_MODIFIED      = getdate()
	     , MODIFIED_USER_ID   = null
         where DATA_FORMAT = N'HyperLink'
           and URL_FORMAT <> @URL_FORMAT_MAILT0
           and URL_FORMAT <> @URL_FORMAT_LINK
           and URL_FIELD  <> N'ID'
           and URL_ASSIGNED_FIELD is null
           and COLUMN_INDEX > 1
           and GRID_NAME <> N'Campaigns.TrackLog'
           and URL_MODULE in (select MODULE_NAME from vwMODULES_AppVars where IS_ASSIGNED = 1)
           and right(replace(URL_FIELD, N'_ID', N'_') + N'ASSIGNED_USER_ID', 30) <> 'DUCT_TEMPLATE_ASSIGNED_USER_ID';
end -- if;

-- 07/17/2006 Paul.  A few fields are too long for the standard naming convention. 
if exists(select *
           from GRIDVIEWS_COLUMNS
          where URL_ASSIGNED_FIELD = right(N'BILLING_ACCOUNT_ASSIGNED_USER_ID', 30)
         ) begin -- then
	update GRIDVIEWS_COLUMNS
	   set URL_ASSIGNED_FIELD = N'BILLING_ACCOUNT_ASSIGNED_ID'
	     , DATE_MODIFIED      = getdate()
	     , MODIFIED_USER_ID   = null
          where URL_ASSIGNED_FIELD = right(N'BILLING_ACCOUNT_ASSIGNED_USER_ID', 30);
end -- if;

if exists(select *
           from GRIDVIEWS_COLUMNS
          where URL_ASSIGNED_FIELD = right(N'SHIPPING_ACCOUNT_ASSIGNED_USER_ID', 30)
         ) begin -- then
	update GRIDVIEWS_COLUMNS
	   set URL_ASSIGNED_FIELD = N'SHIPPING_ACCOUNT_ASSIGNED_ID'
	     , DATE_MODIFIED      = getdate()
	     , MODIFIED_USER_ID   = null
          where URL_ASSIGNED_FIELD = right(N'SHIPPING_ACCOUNT_ASSIGNED_USER_ID', 30);
end -- if;

-- 05/02/2006 Paul.  The remaining all ListViews that don't fit the above conditions. 
-- 01/01/2008 Paul.  We have a new way to determine if a module supports ASSIGNED_USER_ID. 
-- 01/18/2008 Paul.  Oracle needs a statement terminator. 
-- 03/28/2013 Paul.  ProductTemplates.ListView does not have a ASSIGNED_USER_ID. 
if exists(select *
           from GRIDVIEWS_COLUMNS
          where DATA_FORMAT = N'HyperLink'
            and URL_FORMAT <> @URL_FORMAT_MAILT0
            and URL_FORMAT <> @URL_FORMAT_LINK
            and DATA_FIELD = N'NAME'
            and URL_FIELD  = N'ID'
            and URL_ASSIGNED_FIELD is null
            and URL_MODULE in (select MODULE_NAME from vwMODULES_AppVars where IS_ASSIGNED = 1)
         ) begin -- then
	print N'The remaining all ListViews that don''t fit the above conditions.';
	update GRIDVIEWS_COLUMNS
	   set URL_ASSIGNED_FIELD = N'ASSIGNED_USER_ID'
	     , DATE_MODIFIED      = getdate()
	     , MODIFIED_USER_ID   = null
         where DATA_FORMAT = N'HyperLink'
           and URL_FORMAT <> @URL_FORMAT_MAILT0
           and URL_FORMAT <> @URL_FORMAT_LINK
           and DATA_FIELD = N'NAME'
           and URL_FIELD  = N'ID'
           and URL_ASSIGNED_FIELD is null
	   and GRID_NAME    <> 'ProductTemplates.ListView'
           and URL_MODULE in (select MODULE_NAME from vwMODULES_AppVars where IS_ASSIGNED = 1);
end -- if;

-- 01/01/2008 Paul.  Modules without ASSIGNED_USER_ID should not attempt to filter on it.
-- 01/18/2008 Paul.  Oracle needs a statement terminator. 
if exists(select *
           from GRIDVIEWS_COLUMNS
          where DATA_FORMAT        = N'HyperLink'
            and URL_ASSIGNED_FIELD = N'ASSIGNED_USER_ID'
            and URL_MODULE in (select MODULE_NAME from vwMODULES_AppVars where IS_ASSIGNED = 0)
         ) begin -- then
	print N'Modules without ASSIGNED_USER_ID should not attempt to filter on it.';
	update GRIDVIEWS_COLUMNS
	   set URL_ASSIGNED_FIELD = null
	     , DATE_MODIFIED      = getdate()
	     , MODIFIED_USER_ID   = null
         where DATA_FORMAT        = N'HyperLink'
           and URL_ASSIGNED_FIELD = N'ASSIGNED_USER_ID'
           and URL_MODULE in (select MODULE_NAME from vwMODULES_AppVars where IS_ASSIGNED = 0);
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

call dbo.spGRIDVIEWS_COLUMNS_UrlModule()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_UrlModule')
/

-- #endif IBM_DB2 */

