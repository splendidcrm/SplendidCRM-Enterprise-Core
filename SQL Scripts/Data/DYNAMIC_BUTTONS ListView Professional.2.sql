

print 'DYNAMIC_BUTTONS ListView Professional';
-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.ListView'
--GO

set nocount on;
GO


if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Charts.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Charts.ListView', 0, 'Charts', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contracts.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Contracts.ListView', 0, 'Contracts', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Invoices.ListView', 0, 'Invoices', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'KBDocuments.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'KBDocuments.ListView', 0, 'KBDocuments', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'KBTags.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'KBTags.ListView', 0, 'KBTags', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.ListView', 0, 'Orders', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Payments.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Payments.ListView', 0, 'Payments', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.ListView', 0, 'Quotes', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ReportDesigner.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'ReportDesigner.ListView', 0, 'ReportDesigner', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ReportRules.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'ReportRules.ListView', 0, 'ReportRules', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Reports.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Reports.ListView', 0, 'Reports', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyQuestions.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'SurveyQuestions.ListView', 0, 'SurveyQuestions', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Surveys.ListView', 0, 'Surveys', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'TwitterTracks.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'TwitterTracks.ListView', 0, 'TwitterTracks', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ContractTypes.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'ContractTypes.ListView', 0, 'ContractTypes', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Discounts.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Discounts.ListView', 0, 'Discounts', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Manufacturers.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Manufacturers.ListView', 0, 'Manufacturers', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'PaymentGateway.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'PaymentGateway.ListView', 0, 'PaymentGateway', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'PaymentTerms.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'PaymentTerms.ListView', 0, 'PaymentTerms', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'PaymentTypes.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'PaymentTypes.ListView', 0, 'PaymentTypes', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Product_Categories.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Product_Categories.ListView', 0, 'Product_Categories', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductCategories.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'ProductCategories.ListView', 0, 'ProductCategories', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductTemplates.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'ProductTemplates.ListView', 0, 'ProductTemplates', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductTypes.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'ProductTypes.ListView', 0, 'ProductTypes', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Regions.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Regions.ListView', 0, 'Regions', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Shippers.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Shippers.ListView', 0, 'Shippers', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyThemes.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'SurveyThemes.ListView', 0, 'SurveyThemes', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'TaxRates.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'TaxRates.ListView', 0, 'TaxRates', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'TeamNotices.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'TeamNotices.ListView', 0, 'TeamNotices', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Teams.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Teams.ListView', 0, 'Teams', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

-- 02/17/2018 Paul.  ModulesArchiveRules module to Professional. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ModulesArchiveRules.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'ModulesArchiveRules.ListView', 0, 'ModulesArchiveRules', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_ProfessionalListView()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_ProfessionalListView')
/

-- #endif IBM_DB2 */

