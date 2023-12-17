

print 'TERMINOLOGY TwitterTracks en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'TwitterTracks' or NAME = 'TwitterTracks' or LIST_NAME in ('twitter_track_type_dom', 'twitter_track_status_dom');
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'TwitterTracks', null, null, N'Track:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LOCATION'                                  , N'en-US', N'TwitterTracks', null, null, N'Location:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TWITTER_USER_ID'                           , N'en-US', N'TwitterTracks', null, null, N'Twitter User ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TWITTER_SCREEN_NAME'                       , N'en-US', N'TwitterTracks', null, null, N'Twitter Screen Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'TwitterTracks', null, null, N'Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TYPE'                                      , N'en-US', N'TwitterTracks', null, null, N'Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'TwitterTracks', null, null, N'Description:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'TwitterTracks', null, null, N'Track';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LOCATION'                             , N'en-US', N'TwitterTracks', null, null, N'Location';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TWITTER_USER_ID'                      , N'en-US', N'TwitterTracks', null, null, N'User ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TWITTER_SCREEN_NAME'                  , N'en-US', N'TwitterTracks', null, null, N'Screen Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                               , N'en-US', N'TwitterTracks', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TYPE'                                 , N'en-US', N'TwitterTracks', null, null, N'Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'TwitterTracks', null, null, N'Description';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEW_FORM_TITLE'                            , N'en-US', N'TwitterTracks', null, null, N'Twitter Tracks';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_TWITTER_TRACK'                         , N'en-US', N'TwitterTracks', null, null, N'Create Twitter Track';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_TWITTER_TRACKS_LIST'                       , N'en-US', N'TwitterTracks', null, null, N'Twitter Tracks';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'TwitterTracks', null, null, N'Twitter Tracks';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'TwitterTracks', null, null, N'TwT';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MY_TWITTER_TRACKS'                    , N'en-US', N'TwitterTracks', null, null, N'My Twitter Tracks';
-- 07/31/2017 Paul.  Add My Team dashlets. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MY_TEAM_TWITTER_TRACKS'               , N'en-US', N'TwitterTracks', null, null, N'My Team Twitter Tracks';
-- 07/31/2017 Paul.  Add My Favorite dashlets. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MY_FAVORITE_TWITTER_TRACKS'           , N'en-US', N'TwitterTracks', null, null, N'My Favorite Twitter Tracks';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'TwitterTracks', null, null, N'Twitter Tracks';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_INVALID_TRACK'                             , N'en-US', N'TwitterTracks', null, null, N'Invalid track format.';

GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'TwitterTracks'                                 , N'en-US', null, N'moduleList'                        , 122, N'Twitter Tracks';
exec dbo.spTERMINOLOGY_InsertOnly N'TwitterTracks'                                 , N'en-US', null, N'moduleListSingular'                , 122, N'Twitter Track';

exec dbo.spTERMINOLOGY_InsertOnly N'Archive Original'                              , N'en-US', null, N'twitter_track_type_dom'            ,   1, N'Archive Original';
exec dbo.spTERMINOLOGY_InsertOnly N'Archive All'                                   , N'en-US', null, N'twitter_track_type_dom'            ,   2, N'Archive All';
-- 10/27/2013 Paul.  We cannot distinguish between monitor all and monitor original on the client, so only support monitor all. 
exec dbo.spTERMINOLOGY_InsertOnly N'Monitor'                                       , N'en-US', null, N'twitter_track_type_dom'            ,   3, N'Monitor';

exec dbo.spTERMINOLOGY_InsertOnly N'Active'                                        , N'en-US', null, N'twitter_track_status_dom'          ,   1, N'Active';
exec dbo.spTERMINOLOGY_InsertOnly N'Inactive'                                      , N'en-US', null, N'twitter_track_status_dom'          ,   2, N'Inactive';

GO


set nocount off;
GO

/* -- #if Oracle
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spTERMINOLOGY_TwitterTracks_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_TwitterTracks_en_us')
/
-- #endif IBM_DB2 */
