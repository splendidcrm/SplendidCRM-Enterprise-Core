

print 'PAYMENT_TYPES defaults';
GO

set nocount on;
GO

if not exists(select * from PAYMENT_TYPES where DELETED = 0) begin -- then
	-- 04/08/2015 Paul.  Use same ID to simplify support for Oracle. 
	insert into PAYMENT_TYPES
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
	   and LIST_NAME = 'payment_type_dom'
	   and LANG      = 'en-US'
	 order by LIST_ORDER;
end -- if;

if not exists(select * from PAYMENT_TYPES where DELETED = 0) begin -- then
	exec dbo.spPAYMENT_TYPES_InsertOnly null, 'Cash'       , 1;
	exec dbo.spPAYMENT_TYPES_InsertOnly null, 'Check'      , 2;
	exec dbo.spPAYMENT_TYPES_InsertOnly null, 'Credit Card', 3;
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

call dbo.spPAYMENT_TYPES_Defaults()
/

call dbo.spSqlDropProcedure('spPAYMENT_TYPES_Defaults')
/

-- #endif IBM_DB2 */

