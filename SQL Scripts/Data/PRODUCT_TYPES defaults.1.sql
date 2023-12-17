

print 'PRODUCT_TYPES defaults';
GO

set nocount on;
GO

exec dbo.spPRODUCT_TYPES_InsertOnly null, 'Service'          , '',  1;
exec dbo.spPRODUCT_TYPES_InsertOnly null, 'Inventory'        , '',  2;
exec dbo.spPRODUCT_TYPES_InsertOnly null, 'NonInventory'     , '',  3;
exec dbo.spPRODUCT_TYPES_InsertOnly null, 'OtherCharge'      , '',  4;
exec dbo.spPRODUCT_TYPES_InsertOnly null, 'InventoryAssembly', '',  5;
exec dbo.spPRODUCT_TYPES_InsertOnly null, 'Payment'          , '',  6;
exec dbo.spPRODUCT_TYPES_InsertOnly null, 'Discount'         , '',  7;
exec dbo.spPRODUCT_TYPES_InsertOnly null, 'SubTotal'         , '',  8;
exec dbo.spPRODUCT_TYPES_InsertOnly null, 'SalesTax'         , '',  9;
exec dbo.spPRODUCT_TYPES_InsertOnly null, 'SalesTaxGroup'    , '', 10;
exec dbo.spPRODUCT_TYPES_InsertOnly null, 'Group'            , '', 11;
exec dbo.spPRODUCT_TYPES_InsertOnly null, 'FixedAsset'       , '', 12;
exec dbo.spPRODUCT_TYPES_InsertOnly null, 'Unknown'          , '', 13;
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

call dbo.spPRODUCT_TYPES_Defaults()
/

call dbo.spSqlDropProcedure('spPRODUCT_TYPES_Defaults')
/

-- #endif IBM_DB2 */

