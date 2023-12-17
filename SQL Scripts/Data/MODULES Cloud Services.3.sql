

print 'MODULES Cloud Services';
GO

set nocount on;
GO

-- 04/27/2015 Paul.  Add HubSpot module. 
exec dbo.spMODULES_InsertOnly null, 'HubSpot'               , '.moduleList.HubSpot'                  , '~/Administration/HubSpot/'          , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;
-- 05/01/2015 Paul.  Add iContact module. 
exec dbo.spMODULES_InsertOnly null, 'iContact'              , '.moduleList.iContact'                 , '~/Administration/iContact/'         , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;
-- 05/03/2015 Paul.  Add ConstantContact module. 
exec dbo.spMODULES_InsertOnly null, 'ConstantContact'       , '.moduleList.ConstantContact'          , '~/Administration/ConstantContact/'  , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;
-- 05/06/2015 Paul.  Add GetResponse module. 
exec dbo.spMODULES_InsertOnly null, 'GetResponse'           , '.moduleList.GetResponse'              , '~/Administration/GetResponse/'      , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;
-- 05/15/2015 Paul.  Add Marketo module. 
exec dbo.spMODULES_InsertOnly null, 'Marketo'               , '.moduleList.Marketo'                  , '~/Administration/Marketo/'          , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;

-- 11/12/2019 Paul.  Add modules to support React Client. 
exec dbo.spMODULES_InsertOnly null, 'Salesforce'            , '.moduleList.Salesforce'               , '~/Administration/Salesforce/'       , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'Twitter'               , '.moduleList.Twitter'                  , '~/Administration/Twitter/'          , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'LinkedIn'              , '.moduleList.LinkedIn'                 , '~/Administration/LinkedIn/'         , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;
-- 03/10/2021 Paul.  Add modules to support React Client. 
exec dbo.spMODULES_InsertOnly null, 'Google'                , '.moduleList.Google'                   , '~/Administration/Google/'           , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;
-- 12/26/2022 Paul.  Add support for Microsoft Teams. 
exec dbo.spMODULES_InsertOnly null, 'MicrosoftTeams'        , '.moduleList.MicrosoftTeams'           , '~/Administration/MicrosoftTeams/'   , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;



-- 08/24/2008 Paul.  Reorder the modules. 
exec dbo.spMODULES_Reorder null;
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

call dbo.spMODULES_Cloud_Services()
/

call dbo.spSqlDropProcedure('spMODULES_Cloud_Services')
/

-- #endif IBM_DB2 */

