

print 'EDITVIEWS_FIELDS Search SubPanel Professional';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.SearchSubpanel'
--GO

set nocount on;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.SearchSubpanel' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contracts.SearchSubpanel';
	exec dbo.spEDITVIEWS_InsertOnly             'Contracts.SearchSubpanel'   , 'Contracts', 'vwCONTRACTS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Contracts.SearchSubpanel'   ,  0, 'Contracts.LBL_NAME'                     , 'NAME'                       , 0, null, 255, 25, 'Contracts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Contracts.SearchSubpanel'   ,  1, 'Contracts.LBL_STATUS'                   , 'STATUS'                     , 0, null, 'contract_status_dom', null, 6;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.SearchSubpanel' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.SearchSubpanel';
	exec dbo.spEDITVIEWS_InsertOnly             'Invoices.SearchSubpanel'    , 'Invoices', 'vwINVOICES_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Invoices.SearchSubpanel'    ,  0, 'Invoices.LBL_NAME'                      , 'NAME'                       , 0, null,  50, 25, 'Invoices', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Invoices.SearchSubpanel'    ,  1, 'Invoices.LBL_INVOICE_STAGE'             , 'INVOICE_STAGE'              , 0, null, 'invoice_stage_dom'  , null, 6;
end -- if;
GO

-- 02/13/2011 Paul.  The Order Stage should not be required.  Also, lets show 6 text rows. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.SearchSubpanel' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.SearchSubpanel';
	exec dbo.spEDITVIEWS_InsertOnly             'Orders.SearchSubpanel'      , 'Orders', 'vwORDERS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Orders.SearchSubpanel'      ,  0, 'Orders.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Orders', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Orders.SearchSubpanel'      ,  1, 'Orders.LBL_ORDER_STAGE'                 , 'ORDER_STAGE'                , 0, null, 'order_stage_dom'    , null, 6;
end else begin
	-- 02/13/2011 Paul.  The Order Stage should not be required.  Also, lets show 6 text rows. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.SearchSubpanel' and DATA_FIELD = 'ORDER_STAGE' and FIELD_TYPE = 'ListBox' and FORMAT_ROWS is null and DELETED = 0) begin -- then
		print 'EDITVIEWS_FIELDS Orders.SearchSubpanel: Order Stage should not be required. ';
		update EDITVIEWS_FIELDS
		   set FORMAT_ROWS       = 6
		     , FORMAT_TAB_INDEX  = null
		     , DATA_REQUIRED     = 0
		     , UI_REQUIRED       = 0
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Orders.SearchSubpanel'
		   and DATA_FIELD        = 'ORDER_STAGE'
		   and FIELD_TYPE        = 'ListBox'
		   and UI_REQUIRED       = 1
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.SearchSubpanel' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.SearchSubpanel';
	exec dbo.spEDITVIEWS_InsertOnly             'Quotes.SearchSubpanel'      , 'Quotes', 'vwQUOTES_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Quotes.SearchSubpanel'      ,  0, 'Quotes.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Quotes', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Quotes.SearchSubpanel'      ,  1, 'Quotes.LBL_QUOTE_STAGE'                 , 'QUOTE_STAGE'                , 0, null, 'quote_stage_dom'     , null, 6;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.SearchSubpanel' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Products.SearchSubpanel';
	exec dbo.spEDITVIEWS_InsertOnly             'Products.SearchSubpanel'    , 'Products', 'vwPRODUCTS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Products.SearchSubpanel'    ,  0, 'Products.LBL_NAME'                      , 'NAME'                       , 0, null, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'Products.SearchSubpanel'    ,  1, null;
end -- if;
GO

-- 06/21/2011 Paul.  Add relationship between KBDocuments and Cases. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.SearchSubpanel' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS KBDocuments.SearchSubpanel';
	exec dbo.spEDITVIEWS_InsertOnly             'KBDocuments.SearchSubpanel' , 'KBDocuments', 'vwKBDOCUMENTS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'KBDocuments.SearchSubpanel' ,  0, 'KBDocuments.LBL_NAME'                  , 'NAME'                       , 0, null, 255, 25, 'KBDocuments', null;
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

call dbo.spEDITVIEWS_FIELDS_SearchSubPanelProfessional()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_SearchSubPanelProfessional')
/

-- #endif IBM_DB2 */

