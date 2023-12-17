

print 'DYNAMIC_BUTTONS MassUpdate RulesWizard Professional';
GO

set nocount on;
GO

-- 08/16/2017 Paul.  Update button target access rights so RulesWizard can be disabled by a role. 

-- 11/10/2010 Paul.  Professional modules. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contracts.MassUpdate' and COMMAND_NAME = 'RulesWizard' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contracts MassUpdate RulesWizard';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Contracts.MassUpdate'     , -1, 'Contracts'     , 'edit', 'RulesWizard', 'edit', 'RulesWizard', '../RulesWizard/edit.aspx?Module=Contracts'    , null, 'RulesWizard.LBL_RULES_WIZARD_BUTTON_LABEL', 'RulesWizard.LBL_RULES_WIZARD_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.MassUpdate' and COMMAND_NAME = 'RulesWizard' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Invoices MassUpdate RulesWizard';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Invoices.MassUpdate'      , -1, 'Invoices'      , 'edit', 'RulesWizard', 'edit', 'RulesWizard', '../RulesWizard/edit.aspx?Module=Invoices'     , null, 'RulesWizard.LBL_RULES_WIZARD_BUTTON_LABEL', 'RulesWizard.LBL_RULES_WIZARD_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.MassUpdate' and COMMAND_NAME = 'RulesWizard' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Orders MassUpdate RulesWizard';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.MassUpdate'        , -1, 'Orders'        , 'edit', 'RulesWizard', 'edit', 'RulesWizard', '../RulesWizard/edit.aspx?Module=Orders'       , null, 'RulesWizard.LBL_RULES_WIZARD_BUTTON_LABEL', 'RulesWizard.LBL_RULES_WIZARD_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Payments.MassUpdate' and COMMAND_NAME = 'RulesWizard' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Payments MassUpdate RulesWizard';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Payments.MassUpdate'      , -1, 'Payments'      , 'edit', 'RulesWizard', 'edit', 'RulesWizard', '../RulesWizard/edit.aspx?Module=Payments'     , null, 'RulesWizard.LBL_RULES_WIZARD_BUTTON_LABEL', 'RulesWizard.LBL_RULES_WIZARD_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Products.MassUpdate' and COMMAND_NAME = 'RulesWizard' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Products MassUpdate RulesWizard';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Products.MassUpdate'      , -1, 'Products'      , 'edit', 'RulesWizard', 'edit', 'RulesWizard', '../RulesWizard/edit.aspx?Module=Products'     , null, 'RulesWizard.LBL_RULES_WIZARD_BUTTON_LABEL', 'RulesWizard.LBL_RULES_WIZARD_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.MassUpdate' and COMMAND_NAME = 'RulesWizard' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Quotes MassUpdate RulesWizard';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.MassUpdate'        , -1, 'Quotes'        , 'edit', 'RulesWizard', 'edit', 'RulesWizard', '../RulesWizard/edit.aspx?Module=Quotes'       , null, 'RulesWizard.LBL_RULES_WIZARD_BUTTON_LABEL', 'RulesWizard.LBL_RULES_WIZARD_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

-- 10/24/2014 Paul.  Add RulesWizard support to SurveyResults. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyResults.MassUpdate' and COMMAND_NAME = 'RulesWizard' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS SurveyResults MassUpdate RulesWizard';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'SurveyResults.MassUpdate' , -1, 'SurveyResults' , 'edit', 'RulesWizard', 'edit', 'RulesWizard', '../RulesWizard/edit.aspx?Module=SurveyResults', null, 'RulesWizard.LBL_RULES_WIZARD_BUTTON_LABEL', 'RulesWizard.LBL_RULES_WIZARD_BUTTON_TITLE', null, null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_RulesWizard()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_RulesWizard')
/

-- #endif IBM_DB2 */

