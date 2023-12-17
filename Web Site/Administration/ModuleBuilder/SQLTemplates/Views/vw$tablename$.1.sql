if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vw$tablename$')
	Drop View dbo.vw$tablename$;
GO


Create View dbo.vw$tablename$
as
select $tablename$.ID
$createviewfields$
     , $tablename$.DATE_ENTERED
     , $tablename$.DATE_MODIFIED
     , $tablename$.DATE_MODIFIED_UTC
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , $tablename$.CREATED_BY      as CREATED_BY_ID
     , $tablename$.MODIFIED_USER_ID
     , LAST_ACTIVITY.LAST_ACTIVITY_DATE
     , TAG_SETS.TAG_SET_NAME
     , vwPROCESSES_Pending.ID      as PENDING_PROCESS_ID
     , $tablename$_CSTM.*
  from            $tablename$
$createviewjoins$
  left outer join LAST_ACTIVITY
               on LAST_ACTIVITY.ACTIVITY_ID = $tablename$.ID
  left outer join TAG_SETS
               on TAG_SETS.BEAN_ID          = $tablename$.ID
              and TAG_SETS.DELETED          = 0
  left outer join USERS                       USERS_CREATED_BY
               on USERS_CREATED_BY.ID       = $tablename$.CREATED_BY
  left outer join USERS                       USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID      = $tablename$.MODIFIED_USER_ID
  left outer join $tablename$_CSTM
               on $tablename$_CSTM.ID_C     = $tablename$.ID
  left outer join vwPROCESSES_Pending
               on vwPROCESSES_Pending.PARENT_ID = $tablename$.ID
 where $tablename$.DELETED = 0

GO

Grant Select on dbo.vw$tablename$ to public;
GO


