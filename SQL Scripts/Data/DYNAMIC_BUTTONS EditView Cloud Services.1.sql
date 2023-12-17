

print 'DYNAMIC_BUTTONS EditView Cloud Services';

set nocount on;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Contacts.EditView.iCloud'    , 'Contacts';
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Contacts.EditView.Exchange'  , 'Contacts';
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Contacts.EditView.GoogleApps', 'Contacts';
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Meetings.EditView.iCloud'    , 'Meetings';
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Meetings.EditView.Exchange'  , 'Meetings';
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Meetings.EditView.GoogleApps', 'Meetings';
GO

-- 09/05/2015 Paul.  Google APIs now use OAuth 2.0 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Google.EditView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Google.EditView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Google.EditView'   , 0, null, 'edit', null, null, 'Save'  , null, '.LBL_SAVE_BUTTON_LABEL'  , '.LBL_SAVE_BUTTON_TITLE'  , '.LBL_SAVE_BUTTON_KEY'     , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Google.EditView'   , 1, null, null  , null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL', '.LBL_CANCEL_BUTTON_TITLE', '.LBL_CANCEL_BUTTON_KEY'   , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Google.EditView'   , 2, null, null  , null, null, 'Test'  , null, '.LBL_TEST_BUTTON_LABEL'  , '.LBL_TEST_BUTTON_TITLE'  , null, 'return Authorize();', null;
end else begin
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Google.EditView' and CONTROL_TYPE = 'ButtonLink' and  COMMAND_NAME = 'Cancel' and DELETED = 0) begin -- then
		print 'Google.EditView: Cancel should be a Button.';
		update DYNAMIC_BUTTONS
		   set CONTROL_TYPE     = 'Button'
		     , URL_FORMAT       = null
		     , TEXT_FIELD       = null
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Google.EditView'
		   and CONTROL_TYPE     = 'ButtonLink'
		   and COMMAND_NAME     = 'Cancel'
		   and DELETED          = 0;
	end -- if;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Google.EditView'   , 2, null, null  , null, null, 'Test'  , null, '.LBL_TEST_BUTTON_LABEL'  , '.LBL_TEST_BUTTON_TITLE'  , null, 'return Authorize();', null;
end -- if;
GO

-- 04/09/2019 Paul.  Add Google.ConfigView for the React app. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Google.ConfigView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Google.ConfigView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Google.ConfigView' , 0, null, 'edit', null, null, 'Save'  , null, '.LBL_SAVE_BUTTON_LABEL'  , '.LBL_SAVE_BUTTON_TITLE'  , '.LBL_SAVE_BUTTON_KEY'     , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Google.ConfigView' , 1, null, null  , null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL', '.LBL_CANCEL_BUTTON_TITLE', '.LBL_CANCEL_BUTTON_KEY'   , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Google.ConfigView' , 2, null, null  , null, null, 'Test'  , null, '.LBL_TEST_BUTTON_LABEL'  , '.LBL_TEST_BUTTON_TITLE'  , null, 'return Authorize();', null;
end -- if;
GO


-- 04/23/2015 Paul.  Add HubSpot. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'HubSpot.ConfigView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'HubSpot.ConfigView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'HubSpot.ConfigView', 0, null, 'edit', null, null, 'Save'        , null, '.LBL_SAVE_BUTTON_LABEL'               , '.LBL_SAVE_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'HubSpot.ConfigView', 1, null, null  , null, null, 'Cancel'      , null, '.LBL_CANCEL_BUTTON_LABEL'             , '.LBL_CANCEL_BUTTON_TITLE'             , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'HubSpot.ConfigView', 2, null, null  , null, null, 'Test'        , null, '.LBL_TEST_BUTTON_LABEL'               , '.LBL_TEST_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'HubSpot.ConfigView', 3, null, null  , null, null, 'Authorize'   , null, 'HubSpot.LBL_AUTHORIZE_BUTTON_LABEL'   , 'HubSpot.LBL_AUTHORIZE_BUTTON_LABEL'   , null, 'return Authorize();', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'HubSpot.ConfigView', 4, null, null  , null, null, 'RefreshToken', null, 'HubSpot.LBL_REFRESH_TOKEN_LABEL'      , 'HubSpot.LBL_REFRESH_TOKEN_LABEL'      , null, null, null;
end -- if;
GO

-- 05/01/2015 Paul.  Add iContact. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'iContact.ConfigView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'iContact.ConfigView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'iContact.ConfigView', 0, null, 'edit', null, null, 'Save'        , null, '.LBL_SAVE_BUTTON_LABEL'               , '.LBL_SAVE_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'iContact.ConfigView', 1, null, null  , null, null, 'Cancel'      , null, '.LBL_CANCEL_BUTTON_LABEL'             , '.LBL_CANCEL_BUTTON_TITLE'             , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'iContact.ConfigView', 2, null, null  , null, null, 'Test'        , null, '.LBL_TEST_BUTTON_LABEL'               , '.LBL_TEST_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'iContact.ConfigView', 3, null, null  , null, null, 'GetAccount'  , null, 'iContact.LBL_GET_ACCOUNT_BUTTON_LABEL', 'iContact.LBL_GET_ACCOUNT_BUTTON_LABEL', null, null, null;
end -- if;
GO

-- 05/01/2015 Paul.  Add ConstantContact. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'ConstantContact.ConfigView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ConstantContact.ConfigView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'ConstantContact.ConfigView', 0, null, 'edit', null, null, 'Save'        , null, '.LBL_SAVE_BUTTON_LABEL'                    , '.LBL_SAVE_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'ConstantContact.ConfigView', 1, null, null  , null, null, 'Cancel'      , null, '.LBL_CANCEL_BUTTON_LABEL'                  , '.LBL_CANCEL_BUTTON_TITLE'             , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'ConstantContact.ConfigView', 2, null, null  , null, null, 'Test'        , null, '.LBL_TEST_BUTTON_LABEL'                    , '.LBL_TEST_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'ConstantContact.ConfigView', 3, null, null  , null, null, 'Authorize'   , null, 'ConstantContact.LBL_AUTHORIZE_BUTTON_LABEL', 'ConstantContact.LBL_AUTHORIZE_BUTTON_LABEL'   , null, 'return Authorize();', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'ConstantContact.ConfigView', 4, null, null  , null, null, 'RefreshToken', null, 'ConstantContact.LBL_REFRESH_TOKEN_LABEL'   , 'ConstantContact.LBL_REFRESH_TOKEN_LABEL'      , null, null, null;
end else begin
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'ConstantContact.ConfigView', 4, null, null  , null, null, 'RefreshToken', null, 'ConstantContact.LBL_REFRESH_TOKEN_LABEL'   , 'ConstantContact.LBL_REFRESH_TOKEN_LABEL'      , null, null, null;
end -- if;
GO

-- 05/06/2015 Paul.  Add GetResponse. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'GetResponse.ConfigView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'GetResponse.ConfigView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'GetResponse.ConfigView', 0, null, 'edit', null, null, 'Save'        , null, '.LBL_SAVE_BUTTON_LABEL'                    , '.LBL_SAVE_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'GetResponse.ConfigView', 1, null, null  , null, null, 'Cancel'      , null, '.LBL_CANCEL_BUTTON_LABEL'                  , '.LBL_CANCEL_BUTTON_TITLE'             , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'GetResponse.ConfigView', 2, null, null  , null, null, 'Test'        , null, '.LBL_TEST_BUTTON_LABEL'                    , '.LBL_TEST_BUTTON_TITLE'               , null, null, null;
end -- if;
GO

-- 05/15/2015 Paul.  Add Marketo. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Marketo.ConfigView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Marketo.ConfigView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Marketo.ConfigView', 0, null, 'edit', null, null, 'Save'        , null, '.LBL_SAVE_BUTTON_LABEL'               , '.LBL_SAVE_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Marketo.ConfigView', 1, null, null  , null, null, 'Cancel'      , null, '.LBL_CANCEL_BUTTON_LABEL'             , '.LBL_CANCEL_BUTTON_TITLE'             , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Marketo.ConfigView', 2, null, null  , null, null, 'Test'        , null, '.LBL_TEST_BUTTON_LABEL'               , '.LBL_TEST_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Marketo.ConfigView', 3, null, null  , null, null, 'Authorize'   , null, 'Marketo.LBL_AUTHORIZE_BUTTON_LABEL'   , 'HubSpot.LBL_AUTHORIZE_BUTTON_LABEL'   , null, null, null;
end -- if;
GO

-- 11/16/2016 Paul.  Add SalesFusion with REST API. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'SalesFusion.ConfigView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SalesFusion.ConfigView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'SalesFusion.ConfigView', 0, null, 'edit', null, null, 'Save'        , null, '.LBL_SAVE_BUTTON_LABEL'                    , '.LBL_SAVE_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'SalesFusion.ConfigView', 1, null, null  , null, null, 'Cancel'      , null, '.LBL_CANCEL_BUTTON_LABEL'                  , '.LBL_CANCEL_BUTTON_TITLE'             , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'SalesFusion.ConfigView', 2, null, null  , null, null, 'Test'        , null, '.LBL_TEST_BUTTON_LABEL'                    , '.LBL_TEST_BUTTON_TITLE'               , null, null, null;
end -- if;
GO

-- 12/26/2022 Paul.  Add MicrosoftTeams. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'MicrosoftTeams.ConfigView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'MicrosoftTeams.ConfigView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'MicrosoftTeams.ConfigView', 0, null, 'edit', null, null, 'Save'        , null, '.LBL_SAVE_BUTTON_LABEL'                   , '.LBL_SAVE_BUTTON_TITLE'                   , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'MicrosoftTeams.ConfigView', 1, null, null  , null, null, 'Cancel'      , null, '.LBL_CANCEL_BUTTON_LABEL'                 , '.LBL_CANCEL_BUTTON_TITLE'                 , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'MicrosoftTeams.ConfigView', 2, null, null  , null, null, 'Test'        , null, '.LBL_TEST_BUTTON_LABEL'                   , '.LBL_TEST_BUTTON_TITLE'                   , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'MicrosoftTeams.ConfigView', 3, null, null  , null, null, 'Authorize'   , null, 'MicrosoftTeams.LBL_AUTHORIZE_BUTTON_LABEL', 'MicrosoftTeams.LBL_AUTHORIZE_BUTTON_LABEL', null, 'return Authorize();', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'MicrosoftTeams.ConfigView', 4, null, null  , null, null, 'RefreshToken', null, 'MicrosoftTeams.LBL_REFRESH_TOKEN_LABEL'   , 'MicrosoftTeams.LBL_REFRESH_TOKEN_LABEL'   , null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_EditView_Cloud()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_EditView_Cloud')
/

-- #endif IBM_DB2 */

