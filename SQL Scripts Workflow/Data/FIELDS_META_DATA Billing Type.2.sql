

set nocount on;
GO


-- 01/04/2009 Paul.  We should be specifying the Module Name and not the Table Name. 
-- This was not a big issue for this custom field as the line-item custom fields are not managed automatically. 
-- 11/30/2008 Paul.  Service level name changed from Basic to Community. 
if exists(select * from FIELDS_META_DATA where CUSTOM_MODULE = N'ORDERS_LINE_ITEMS' and DELETED = 0) begin -- then
	print 'FIELDS_META_DATA: Fix Custom Module for OrdersLineItems.Billing Type';
	update FIELDS_META_DATA
	   set CUSTOM_MODULE    = N'OrdersLineItems'
	     , DATE_ENTERED     = getdate()
	     , MODIFIED_USER_ID = null
	 where CUSTOM_MODULE    = N'ORDERS_LINE_ITEMS'
	   and DELETED          = 0;
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

call dbo.spFIELDS_META_DATA_BillingType()
/

call dbo.spSqlDropProcedure('spFIELDS_META_DATA_BillingType')
/

-- #endif IBM_DB2 */

