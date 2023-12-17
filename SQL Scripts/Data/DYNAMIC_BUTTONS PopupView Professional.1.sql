

print 'DYNAMIC_BUTTONS Popup Professional';
-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.PopupView'
--GO

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = '.PopupView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS .PopupView';
	exec dbo.spDYNAMIC_BUTTONS_InsPopupClear  '.PopupView', 0, null, 'list';
	exec dbo.spDYNAMIC_BUTTONS_InsPopupCancel '.PopupView', 1, null, 'list';
end -- if;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'Contracts.PopupView'        , 'Contracts'        ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'CreditCards.PopupView'      , 'CreditCards'      ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'Invoices.PopupView'         , 'Invoices'         ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'Orders.PopupView'           , 'Orders'           ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'Payments.PopupView'         , 'Payments'         ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'Products.PopupView'         , 'Products'         ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'ProductCatalog.PopupView'   , 'ProductCatalog'   ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'ProductCategories.PopupView', 'ProductCategories';
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'ProductTypes.PopupView'     , 'ProductTypes'     ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'Quotes.PopupView'           , 'Quotes'           ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'Threads.PopupView'          , 'Threads'          ;
GO

-- 12/29/2015 Paul.  Allow searching of Survey ResultsView. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'SurveyResults.RespondantsPopupView', 'SurveyResults';


-- Administration
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'ProductTemplates.PopupView' , 'ProductTemplates' ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'Teams.PopupView'            , 'Teams'            ;
GO


-- 08/05/2010 Paul.  Change MultiSelect to use default buttons. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupMultiSelect', 'Teams.PopupMultiSelect'           , 'Teams'           ;
-- 07/10/2010 Paul.  Add multi-select support for the Products popup. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupMultiSelect', 'ProductTemplates.PopupMultiSelect', 'ProductTemplates';
-- 07/10/2010 Paul.  Add support for options. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupMultiSelect', 'ProductCatalog.PopupMultiSelect'  , 'ProductCatalog'  ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupMultiSelect', 'Invoices.PopupMultiSelect'        , 'Invoices'        ;
-- 07/20/2010 Paul.  Regions. 
-- 09/16/2010 Paul.  Move Regions to Professional file. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupMultiSelect', 'Regions.PopupMultiSelect'         , 'Regions'         ;
-- 01/01/2017 Paul.  Change popup so that we can use the standard definition of PopupMultiSelect for Region selection. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupMultiSelect', 'Regions.PopupCountries'           , 'Regions'         ;
-- 09/16/2010 Paul.  Move Regions to Professional file. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupMultiSelect', 'SurveyQuestions.PopupMultiSelect' , 'SurveyQuestions' ;

-- 04/12/2016 Paul.  Add ZipCodes. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView'       , 'Teams.PopupZipCodeView'           , 'Teams'           ;
-- 04/12/2016 Paul.  Add Search by ZipCode to Teams Popup. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Teams.PopupView' and CONTROL_TEXT = 'ZipCodes.LBL_SEARCH_BY_ZIPCODE' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Teams.PopupView', 2, 'Teams', 'list', null, null, 'window.location.href = "PopupZipCode.aspx";', null, 'ZipCodes.LBL_SEARCH_BY_ZIPCODE', 'ZipCodes.LBL_SEARCH_BY_ZIPCODE', null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_PopupProfessional()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_PopupProfessional')
/

-- #endif IBM_DB2 */

