

print 'DETAILVIEWS_RELATIONSHIPS Avaya';
GO

set nocount on;
GO

-- 12/03/2013 Paul.  Add AvayaView. 
--if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Administration.ListView' and CONTROL_NAME = 'AvayaView' and DELETED = 0) begin -- then
--	print 'DETAILVIEWS_RELATIONSHIPS Administration.ListView';
--	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Administration.ListView'   , 'Administration'   , 'AvayaView'       ,  -1, 'Avaya.LBL_AVAYA_TITLE'            , null, null, null, null;
--end -- if;

-- 04/25/2020 Paul.  Avaya was moved to VoIPView. 
if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Administration.ListView' and CONTROL_NAME = 'AvayaView' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set DELETED           = 1
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	 where DETAIL_NAME       = 'Administration.ListView'
	   and CONTROL_NAME      = 'AvayaView'
	   and DELETED           = 0;
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_Avaya()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_Avaya')
/

-- #endif IBM_DB2 */

