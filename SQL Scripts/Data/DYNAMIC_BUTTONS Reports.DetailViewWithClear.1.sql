if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Reports.DetailViewWithClear' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Reports.DetailViewWithClear';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.DetailViewWithClear'       , 0, 'Reports'         , 'view', null              , null, 'Attachment'              , null, 'Reports.LBL_ATTACHMENT_BUTTON_LABEL'         , 'Reports.LBL_ATTACHMENT_BUTTON_TITLE'         , null                                        , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.DetailViewWithClear'       , 1, 'Reports'         , 'view', null              , null, 'Submit'                  , null, '.LBL_SUBMIT_BUTTON_LABEL'                    , '.LBL_SUBMIT_BUTTON_TITLE'                    , null                                        , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.DetailViewWithClear'       , 2, 'Reports'         , 'view', null              , null, 'Clear'                   , null, '.LBL_CLEAR_BUTTON_LABEL'                     , '.LBL_CLEAR_BUTTON_TITLE'                     , null                                        , null, null;
end -- if;
GO

