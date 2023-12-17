if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vw$tablename$_$relatedtable$')
	Drop View dbo.vw$tablename$_$relatedtable$;
GO


Create View dbo.vw$tablename$_$relatedtable$
as
select $tablename$.ID               as $tablenamesingular$_ID
     , $tablename$.NAME             as $tablenamesingular$_NAME
$relatedviewassigned$
     , vw$relatedtable$.ID                 as $relatedtablesingular$_ID
     , vw$relatedtable$.NAME               as $relatedtablesingular$_NAME
     , vw$relatedtable$.*
  from           $tablename$
      inner join $tablename$_$relatedtable$
              on $tablename$_$relatedtable$.$tablenamesingular$_ID = $tablename$.ID
             and $tablename$_$relatedtable$.DELETED    = 0
      inner join vw$relatedtable$
              on vw$relatedtable$.ID                = $tablename$_$relatedtable$.$relatedtablesingular$_ID
 where $tablename$.DELETED = 0

GO

Grant Select on dbo.vw$tablename$_$relatedtable$ to public;
GO


