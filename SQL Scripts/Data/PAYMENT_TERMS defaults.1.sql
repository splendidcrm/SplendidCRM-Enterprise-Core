

print 'PAYMENT_TERMS defaults';
GO

set nocount on;
GO

if not exists(select * from PAYMENT_TERMS where DELETED = 0) begin -- then
	-- 04/08/2015 Paul.  Use same ID to simplify support for Oracle. 
	insert into PAYMENT_TERMS
		( ID
		, NAME
		, STATUS
		, LIST_ORDER
		)
	select ID
	     , NAME
	     , N'Active'
	     , LIST_ORDER
	  from TERMINOLOGY
	 where DELETED = 0
	   and LIST_NAME = 'payment_terms_dom'
	   and LANG      = 'en-US'
	 order by LIST_ORDER;
end -- if;

if not exists(select * from PAYMENT_TERMS where DELETED = 0) begin -- then
	exec dbo.spPAYMENT_TERMS_InsertOnly null, 'COD'           , 1;
	exec dbo.spPAYMENT_TERMS_InsertOnly null, 'Due on Receipt', 2;
	exec dbo.spPAYMENT_TERMS_InsertOnly null, 'Net 7 Days'    , 3;
	exec dbo.spPAYMENT_TERMS_InsertOnly null, 'Net 15 Days'   , 4;
	exec dbo.spPAYMENT_TERMS_InsertOnly null, 'Net 30 Days'   , 5;
	exec dbo.spPAYMENT_TERMS_InsertOnly null, 'Net 45 Days'   , 6;
	exec dbo.spPAYMENT_TERMS_InsertOnly null, 'Net 60 Days'   , 7;
	exec dbo.spPAYMENT_TERMS_InsertOnly null, '1% 10 Net 30'  , 8;
	exec dbo.spPAYMENT_TERMS_InsertOnly null, '2% 10 Net 30'  , 9;
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

call dbo.spPAYMENT_TERMS_Defaults()
/

call dbo.spSqlDropProcedure('spPAYMENT_TERMS_Defaults')
/

-- #endif IBM_DB2 */

