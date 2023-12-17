
-- 11/18/2020 Paul.  Index is needed when getting list of CRM records to sync. 
if not exists (select * from sys.indexes where name = 'IDX_PROSPECT_LISTS_PROS_SYNC_LOCAL_ID') begin -- then
	-- drop index PROSPECT_LISTS_PROSPECTS_SYNC.IDX_PROSPECT_LISTS_PROS_SYNC_LOCAL_ID;
	print 'create index IDX_WORKFLOW_RUN_AUDIT_ID';
	create index IDX_PROSPECT_LISTS_PROS_SYNC_LOCAL_ID on dbo.PROSPECT_LISTS_PROSPECTS_SYNC (ASSIGNED_USER_ID, DELETED, SERVICE_NAME, LOCAL_ID, REMOTE_KEY)
end -- if;
GO

