

set nocount on;
GO

/*
select distinct
'if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = ''' + DETAILVIEWS_RELATIONSHIPS.TABLE_NAME + ''' and SORT_FIELD = ''' + DETAILVIEWS_RELATIONSHIPS.SORT_FIELD + ''' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = ''' + (case when DETAILVIEWS_RELATIONSHIPS.TABLE_NAME like '%_ACTIVITIES_HISTORY' then 'DATE_MODIFIED' 
                                               when DETAILVIEWS_RELATIONSHIPS.TABLE_NAME like '%_ACTIVITIES_OPEN'    then 'DATE_DUE' 
                                               when DETAILVIEWS_RELATIONSHIPS.TABLE_NAME like '%_ACTIVITIES'         then 'DATE_MODIFIED' 
                                               else '' 
                                          end) + '''
	     , SORT_DIRECTION    = ''desc''
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = ''' + DETAILVIEWS_RELATIONSHIPS.TABLE_NAME + '''
	   and SORT_FIELD        = ''' + DETAILVIEWS_RELATIONSHIPS.SORT_FIELD + '''
	   and DELETED           = 0;
end -- if;

'
  from            DETAILVIEWS_RELATIONSHIPS
  left outer join vwSqlColumns
               on vwSqlColumns.ObjectName = DETAILVIEWS_RELATIONSHIPS.TABLE_NAME
              and vwSqlColumns.ColumnName = DETAILVIEWS_RELATIONSHIPS.SORT_FIELD
 where DETAILVIEWS_RELATIONSHIPS.DELETED = 0
   and DETAILVIEWS_RELATIONSHIPS.SORT_FIELD is not null
   and vwSqlColumns.ObjectName is null
 order by 1;
*/


if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwACCOUNTS_ACTIVITIES' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwACCOUNTS_ACTIVITIES'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwACCOUNTS_ACTIVITIES_HISTORY' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwACCOUNTS_ACTIVITIES_HISTORY'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwACCOUNTS_ACTIVITIES_OPEN' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_DUE'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwACCOUNTS_ACTIVITIES_OPEN'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwACCOUNTS_BALANCE' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'BALANCE_DATE'
	     , SORT_DIRECTION    = 'asc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwACCOUNTS_BALANCE'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwBUGS_ACTIVITIES' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwBUGS_ACTIVITIES'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwBUGS_ACTIVITIES_HISTORY' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwBUGS_ACTIVITIES_HISTORY'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwBUGS_ACTIVITIES_OPEN' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_DUE'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwBUGS_ACTIVITIES_OPEN'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCASES_ACTIVITIES' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCASES_ACTIVITIES'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCASES_ACTIVITIES_HISTORY' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCASES_ACTIVITIES_HISTORY'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCASES_ACTIVITIES_OPEN' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_DUE'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCASES_ACTIVITIES_OPEN'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCONTACTS_ACTIVITIES' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCONTACTS_ACTIVITIES'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCONTACTS_ACTIVITIES_HISTORY' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCONTACTS_ACTIVITIES_HISTORY'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCONTACTS_ACTIVITIES_OPEN' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_DUE'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCONTACTS_ACTIVITIES_OPEN'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCONTRACTS_ACTIVITIES' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCONTRACTS_ACTIVITIES'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCONTRACTS_ACTIVITIES_HISTORY' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCONTRACTS_ACTIVITIES_HISTORY'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCONTRACTS_ACTIVITIES_OPEN' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_DUE'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCONTRACTS_ACTIVITIES_OPEN'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwINVOICES_ACTIVITIES' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwINVOICES_ACTIVITIES'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwINVOICES_ACTIVITIES_HISTORY' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwINVOICES_ACTIVITIES_HISTORY'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwINVOICES_ACTIVITIES_OPEN' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_DUE'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwINVOICES_ACTIVITIES_OPEN'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwLEADS_ACTIVITIES' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwLEADS_ACTIVITIES'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwLEADS_ACTIVITIES_HISTORY' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwLEADS_ACTIVITIES_HISTORY'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwLEADS_ACTIVITIES_OPEN' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_DUE'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwLEADS_ACTIVITIES_OPEN'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwOPPORTUNITIES_ACTIVITIES' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwOPPORTUNITIES_ACTIVITIES'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwOPPORTUNITIES_ACTIVITIES_HISTORY' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwOPPORTUNITIES_ACTIVITIES_HISTORY'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwOPPORTUNITIES_ACTIVITIES_OPEN' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_DUE'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwOPPORTUNITIES_ACTIVITIES_OPEN'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwORDERS_ACTIVITIES' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwORDERS_ACTIVITIES'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwORDERS_ACTIVITIES_HISTORY' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwORDERS_ACTIVITIES_HISTORY'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwORDERS_ACTIVITIES_OPEN' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_DUE'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwORDERS_ACTIVITIES_OPEN'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECT_TASKS_ACTIVITIES' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECT_TASKS_ACTIVITIES'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECT_TASKS_ACTIVITIES_HISTORY' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECT_TASKS_ACTIVITIES_HISTORY'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECT_TASKS_ACTIVITIES_OPEN' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_DUE'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECT_TASKS_ACTIVITIES_OPEN'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECTS_ACTIVITIES' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECTS_ACTIVITIES'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECTS_ACTIVITIES_HISTORY' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECTS_ACTIVITIES_HISTORY'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECTS_ACTIVITIES_OPEN' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_DUE'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECTS_ACTIVITIES_OPEN'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROSPECTS_ACTIVITIES' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROSPECTS_ACTIVITIES'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROSPECTS_ACTIVITIES_HISTORY' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROSPECTS_ACTIVITIES_HISTORY'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROSPECTS_ACTIVITIES_OPEN' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_DUE'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROSPECTS_ACTIVITIES_OPEN'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwQUOTES_ACTIVITIES' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwQUOTES_ACTIVITIES'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwQUOTES_ACTIVITIES_HISTORY' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_MODIFIED'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwQUOTES_ACTIVITIES_HISTORY'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwQUOTES_ACTIVITIES_OPEN' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'DATE_DUE'
	     , SORT_DIRECTION    = 'desc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwQUOTES_ACTIVITIES_OPEN'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwREGIONS_COUNTRIES' and SORT_FIELD = 'DATE_ENTERED' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set SORT_FIELD        = 'COUNTRY'
	     , SORT_DIRECTION    = 'asc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwREGIONS_COUNTRIES'
	   and SORT_FIELD        = 'DATE_ENTERED'
	   and DELETED           = 0;
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_SortFix()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_SortFix')
/

-- #endif IBM_DB2 */

