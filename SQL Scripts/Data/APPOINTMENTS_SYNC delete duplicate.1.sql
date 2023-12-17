set nocount on;
if exists(select LOCAL_ID from APPOINTMENTS_SYNC where DELETED = 0 group by LOCAL_ID having count(*) > 1) begin -- then
	print 'APPOINTMENTS_SYNC: Duplicates exist';
	begin tran;
	declare @LOCAL_ID        uniqueidentifier;
	declare @PRIMARY_SYNC_ID uniqueidentifier;
	
	declare SYNC_CURSOR cursor for
	select LOCAL_ID
	  from APPOINTMENTS_SYNC
	 group by LOCAL_ID
	having count(*) > 1;
	
	open SYNC_CURSOR;
	fetch next from SYNC_CURSOR into @LOCAL_ID;
	while @@FETCH_STATUS = 0 begin -- do
		print '	LOCAL_ID = ' +cast(@LOCAL_ID as char(36));
		select top 1 @PRIMARY_SYNC_ID = ID
		  from APPOINTMENTS_SYNC
		 where LOCAL_ID = @LOCAL_ID
		 order by DATE_ENTERED;
	
		print 'APPOINTMENTS_SYNC: Deleting duplicate SYNC_ID = ' + cast(@PRIMARY_SYNC_ID as char(36));
		update APPOINTMENTS_SYNC
		   set DELETED           = 1
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where LOCAL_ID          = @LOCAL_ID
		   and ID                <> @PRIMARY_SYNC_ID;
	
		-- select * from APPOINTMENTS_SYNC where LOCAL_ID = @LOCAL_ID order by DATE_ENTERED;
		fetch next from SYNC_CURSOR into @LOCAL_ID;
	end -- while;
	close SYNC_CURSOR;
	deallocate SYNC_CURSOR;
	commit tran;
end -- if;
GO

