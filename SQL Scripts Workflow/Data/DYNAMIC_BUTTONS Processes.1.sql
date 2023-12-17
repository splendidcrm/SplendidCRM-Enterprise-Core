

print 'DYNAMIC_BUTTONS DetailView Processes';

set nocount on;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Processes.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Processes.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsEdit       'Processes.DetailView'      , 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Processes.DetailView'      , 1, null, null, null, null, 'Processes.ShowHistory'       , 'PENDING_PROCESS_ID', 'Processes.LBL_HISTORY'             , 'Processes.LBL_HISTORY'             , null, 'ProcessHistoryPopup(); return false;' , null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Processes.DetailView'      , 2, null, null, null, null, 'Processes.ShowNotes'         , 'PENDING_PROCESS_ID', 'Processes.LBL_NOTES'               , 'Processes.LBL_NOTES'               , null, 'ProcessNotesPopup(); return false;' , null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Processes.DetailView'      , 3, null, null, null, null, 'Processes.SelectAssignedUser', 'PENDING_PROCESS_ID', 'Processes.LBL_CHANGE_ASSIGNED_USER', 'Processes.LBL_CHANGE_ASSIGNED_USER', null, 'SelectAssignedUserPopup(); return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Processes.DetailView'      , 4, null, null, null, null, 'Processes.SelectProcessUser' , 'PENDING_PROCESS_ID', 'Processes.LBL_CHANGE_PROCESS_USER' , 'Processes.LBL_CHANGE_PROCESS_USER' , null, 'SelectProcessUserPopup(); return false;' , null;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Processes.DetailView.Route';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Processes.DetailView.Route' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsEdit       'Processes.DetailView.Route', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Processes.DetailView.Route', 1, null, null, null, null, 'Processes.ShowHistory'       , 'PENDING_PROCESS_ID', 'Processes.LBL_HISTORY'             , 'Processes.LBL_HISTORY'             , null, 'ProcessHistoryPopup(); return false;' , null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Processes.DetailView.Route', 2, null, null, null, null, 'Processes.ShowNotes'         , 'PENDING_PROCESS_ID', 'Processes.LBL_NOTES'               , 'Processes.LBL_NOTES'               , null, 'ProcessNotesPopup(); return false;' , null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Processes.DetailView.Route', 3, null, null, null, null, 'Processes.SelectAssignedUser', 'PENDING_PROCESS_ID', 'Processes.LBL_CHANGE_ASSIGNED_USER', 'Processes.LBL_CHANGE_ASSIGNED_USER', null, 'SelectAssignedUserPopup(); return false;', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Processes.DetailView.Route', 4, null, null, null, null, 'Processes.SelectProcessUser' , 'PENDING_PROCESS_ID', 'Processes.LBL_CHANGE_PROCESS_USER' , 'Processes.LBL_CHANGE_PROCESS_USER' , null, 'SelectProcessUserPopup(); return false;' , null;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Processes.DetailView.Claim';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Processes.DetailView.Claim' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Processes.DetailView.Claim', 0, null, 0;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Processes.DetailView.Claim', 1, null, null, null, null, 'Processes.ShowHistory'       , 'PENDING_PROCESS_ID', 'Processes.LBL_HISTORY'             , 'Processes.LBL_HISTORY'             , null, 'ProcessHistoryPopup(); return false;' , null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Processes.DetailView.Claim', 2, null, null, null, null, 'Processes.ShowNotes'         , 'PENDING_PROCESS_ID', 'Processes.LBL_NOTES'               , 'Processes.LBL_NOTES'               , null, 'ProcessNotesPopup(); return false;' , null;
end -- if;
GO


-- Accept/Reject
	-- Edit
	-- History
	-- Status
	-- Add Notes
	-- SelectAssignedUser
	-- SelectProcessUser

-- Route
	-- Edit
	-- History
	-- Status
	-- Add Notes
	-- SelectAssignedUser
	-- SelectProcessUser

-- Claim
	-- Cancel
	-- History
	-- Status


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

call dbo.spDYNAMIC_BUTTONS_DetailView_Processes()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_DetailView_Processes')
/

-- #endif IBM_DB2 */

