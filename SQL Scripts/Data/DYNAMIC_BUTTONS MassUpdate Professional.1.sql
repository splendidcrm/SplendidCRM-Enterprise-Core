

print 'DYNAMIC_BUTTONS MassUpdate Professional';

set nocount on;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Invoices MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.MassUpdate'      , 0, 'Invoices'      , 'edit'  , null, null, 'MassUpdate', null, '.LBL_UPDATE'         , '.LBL_UPDATE'         , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.MassUpdate'      , 1, 'Invoices'      , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contracts.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contracts MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contracts.MassUpdate'     , 0, 'Contracts'     , 'edit'  , null, null, 'MassUpdate', null, '.LBL_UPDATE'         , '.LBL_UPDATE'         , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contracts.MassUpdate'     , 1, 'Contracts'     , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'KBDocuments.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS KBDocuments MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'KBDocuments.MassUpdate'   , 0, 'KBDocuments'   , 'edit'  , null, null, 'MassUpdate', null, '.LBL_UPDATE'         , '.LBL_UPDATE'         , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'KBDocuments.MassUpdate'   , 1, 'KBDocuments'   , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Orders MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.MassUpdate'        , 0, 'Orders'        , 'edit'  , null, null, 'MassUpdate', null, '.LBL_UPDATE'         , '.LBL_UPDATE'         , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.MassUpdate'        , 1, 'Orders'        , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Payments.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Payments MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Payments.MassUpdate'      , 0, 'Payments'      , 'edit'  , null, null, 'MassUpdate', null, '.LBL_UPDATE'         , '.LBL_UPDATE'         , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Payments.MassUpdate'      , 1, 'Payments'      , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Products.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Products MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Products.MassUpdate'      , 0, 'Products'      , 'edit'  , null, null, 'MassUpdate', null, '.LBL_UPDATE'         , '.LBL_UPDATE'         , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Products.MassUpdate'      , 1, 'Products'      , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Quotes MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.MassUpdate'        , 0, 'Quotes'        , 'edit'  , null, null, 'MassUpdate', null, '.LBL_UPDATE'         , '.LBL_UPDATE'         , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.MassUpdate'        , 1, 'Quotes'        , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Reports.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Reports MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Reports.MassUpdate'       , 0, 'Reports'       , 'edit'  , null, null, 'MassUpdate', null, '.LBL_UPDATE'         , '.LBL_UPDATE'         , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Reports.MassUpdate'       , 1, 'Reports'       , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductTemplates.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS ProductTemplates MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'ProductTemplates.MassUpdate', 0, 'ProductTemplates', 'edit'  , null, null, 'MassUpdate', null, '.LBL_UPDATE'         , '.LBL_UPDATE'         , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'ProductTemplates.MassUpdate', 1, 'ProductTemplates', 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

-- 12/21/2014 Paul.  Fix module name. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Regions.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Regions MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Regions.MassUpdate'       , 0, 'Regions'       , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end else begin
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Regions.MassUpdate' and MODULE_NAME = 'Reports' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set MODULE_NAME       = 'Regions'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where VIEW_NAME         = 'Regions.MassUpdate'
		   and MODULE_NAME       = 'Reports'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'TeamNotices.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS TeamNotices MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'TeamNotices.MassUpdate'   , 0, 'TeamNotices'   , 'edit'  , null, null, 'MassUpdate', null, '.LBL_UPDATE'         , '.LBL_UPDATE'         , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'TeamNotices.MassUpdate'   , 1, 'TeamNotices'   , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Teams.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Teams MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Teams.MassUpdate'         , 0, 'Teams'         , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO


if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Exchange.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Exchange MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Exchange.MassUpdate'      , 0, 'Exchange'      , 'edit'  , null, null, 'MassEnable' , null, 'Exchange.LBL_ENABLE' , 'Exchange.LBL_ENABLE' , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Exchange.MassUpdate'      , 1, 'Exchange'      , 'edit'  , null, null, 'MassDisable', null, 'Exchange.LBL_DISABLE', 'Exchange.LBL_DISABLE', null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SimpleStorage.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS SimpleStorage MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'SimpleStorage.MassUpdate' , 0, 'SimpleStorage' , 'delete', null, null, 'MassDelete' , null, '.LBL_DELETE'                                , '.LBL_DELETE'                                , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'SimpleStorage.MassUpdate' , 1, 'SimpleStorage' , 'edit'  , null, null, 'MassPublic' , null, 'SimpleStorage.LBL_MAKE_PUBLIC_BUTTON_LABEL' , 'SimpleStorage.LBL_MAKE_PUBLIC_BUTTON_TITLE' , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'SimpleStorage.MassUpdate' , 2, 'SimpleStorage' , 'edit'  , null, null, 'MassPrivate', null, 'SimpleStorage.LBL_MAKE_PRIVATE_BUTTON_LABEL', 'SimpleStorage.LBL_MAKE_PRIVATE_BUTTON_TITLE', null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

-- 09/20/2013 Paul.  Move PayPal.MassUpdate from Pro folders to Workflow folders. 

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'RulesWizard.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS RulesWizard MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'RulesWizard.MassUpdate'   , 0, 'RulesWizard'   , 'edit'  , null, null, 'MassUpdate', null, '.LBL_UPDATE'         , '.LBL_UPDATE'         , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'RulesWizard.MassUpdate'   , 1, 'RulesWizard'   , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

-- 11/09/2011 Paul.  Add buttons for Charts. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Charts.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Charts MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Charts.MassUpdate'        , 0, 'Charts'        , 'edit'  , null, null, 'MassUpdate', null, '.LBL_UPDATE'         , '.LBL_UPDATE'         , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Charts.MassUpdate'        , 1, 'Charts'        , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

-- 06/07/2013 Paul.  Add buttons for Surveys. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Surveys MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Surveys.MassUpdate'       , 0, 'Surveys'       , 'edit'  , null, null, 'MassUpdate', null, '.LBL_UPDATE'         , '.LBL_UPDATE'         , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Surveys.MassUpdate'       , 1, 'Surveys'       , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyQuestions.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS SurveyQuestions MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'SurveyQuestions.MassUpdate', 0, 'SurveyQuestions', 'edit'  , null, null, 'MassUpdate', null, '.LBL_UPDATE'         , '.LBL_UPDATE'         , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'SurveyQuestions.MassUpdate', 1, 'SurveyQuestions', 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyResults.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS SurveyResults MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'SurveyResults.MassUpdate'  , 0, 'SurveyResults'  , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

-- 09/10/2013 Paul.  Add buttons for Asterisk. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Asterisk.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Asterisk MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Asterisk.MassUpdate'       , 0, 'Asterisk'       , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

-- 09/20/2013 Paul.  Add support for PayTrace. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'PayTrace.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS PayTrace MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'PayTrace.MassUpdate'       , 0, 'PayTrace'       , 'import', null, null, 'Import' , null, 'PayTrace.LBL_IMPORT_BUTTON_LABEL', 'PayTrace.LBL_IMPORT_BUTTON_LABEL', null, null, null;
end -- if;
GO

-- 10/26/2013 Paul.  Add TwitterTracks module. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'TwitterTracks.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS TwitterTracks MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'TwitterTracks.MassUpdate'  , 0, 'TwitterTracks'  , 'edit'  , null, null, 'MassUpdate', null, '.LBL_UPDATE'         , '.LBL_UPDATE'         , null, 'if ( !ValidateOne() ) return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'TwitterTracks.MassUpdate'  , 1, 'TwitterTracks'  , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
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

call dbo.spDYNAMIC_BUTTONS_MassUpdateProfessional()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_MassUpdateProfessional')
/

-- #endif IBM_DB2 */

