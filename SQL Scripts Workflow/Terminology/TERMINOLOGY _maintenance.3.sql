

-- 02/02/2009 Paul.  Fix payment gateway numbering. 
if exists(select *
            from TERMINOLOGY
           where NAME             = 'Amazon'
             and LIST_NAME        = 'payment_gateway_dom'
             and LIST_ORDER is null
             and DELETED          = 0) begin -- then
	update TERMINOLOGY
	   set LIST_ORDER       = 55
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'Amazon'
	   and LIST_NAME        = 'payment_gateway_dom'
	   and LIST_ORDER is null
	   and DELETED          = 0;
end -- if;
GO

if exists(select *
            from TERMINOLOGY
           where (NAME = '' or NAME is null)
             and LIST_NAME        = 'jigsaw_country_dom'
             and LIST_ORDER is null
             and DELETED          = 0) begin -- then
	update TERMINOLOGY
	   set LIST_ORDER       = 0
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where (NAME = '' or NAME is null)
	   and LIST_NAME        = 'jigsaw_country_dom'
	   and LIST_ORDER is null
	   and DELETED          = 0;
end -- if;
GO

if exists(select *
            from TERMINOLOGY
           where NAME             = '0'
             and LIST_NAME        like 'jigsaw%'
             and LIST_ORDER is null
             and DELETED          = 0) begin -- then
	update TERMINOLOGY
	   set LIST_ORDER       = 0
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = '0'
	   and LIST_NAME        like 'jigsaw%'
	   and LIST_ORDER is null
	   and DELETED          = 0;
end -- if;
GO

if exists(select *
            from TERMINOLOGY
           where (NAME = '' or NAME is null)
             and LIST_NAME        like 'jigsaw_state%'
             and LIST_ORDER is null
             and DELETED          = 0) begin -- then
	update TERMINOLOGY
	   set LIST_ORDER       = 0
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where (NAME = '' or NAME is null)
	   and LIST_NAME        like 'jigsaw_state%'
	   and LIST_ORDER is null
	   and DELETED          = 0;
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

call dbo.spTERMINOLOGY_maintenance()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_maintenance')
/

-- #endif IBM_DB2 */

