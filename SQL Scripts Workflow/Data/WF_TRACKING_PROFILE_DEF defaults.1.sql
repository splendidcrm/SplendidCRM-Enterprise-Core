

set nocount on;
GO

exec dbo.spWWF_TRACKING_PROFILE_DEF_InsertOnly null, N'1.0.0', N'<?xml version="1.0" encoding="utf-16" standalone="yes"?>
<TrackingProfile xmlns="http://schemas.microsoft.com/winfx/2006/workflow/trackingprofile" version="1.0.0">
    <TrackPoints>
        <ActivityTrackPoint>
            <MatchingLocations>
                <ActivityTrackingLocation>
                    <Activity>
                        <Type>System.Workflow.ComponentModel.Activity, System.Workflow.ComponentModel, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35</Type>
                        <MatchDerivedTypes>true</MatchDerivedTypes>
                    </Activity>
                    <ExecutionStatusEvents>
                        <ExecutionStatus>Initialized</ExecutionStatus>
                        <ExecutionStatus>Executing</ExecutionStatus>
                        <ExecutionStatus>Compensating</ExecutionStatus>
                        <ExecutionStatus>Canceling</ExecutionStatus>
                        <ExecutionStatus>Closed</ExecutionStatus>
                        <ExecutionStatus>Faulting</ExecutionStatus>
                    </ExecutionStatusEvents>
                </ActivityTrackingLocation>
            </MatchingLocations>
        </ActivityTrackPoint>
		<WorkflowTrackPoint>
			<MatchingLocation>
				<WorkflowTrackingLocation>
					<TrackingWorkflowEvents>
						<TrackingWorkflowEvent>Created</TrackingWorkflowEvent>						
						<TrackingWorkflowEvent>Completed</TrackingWorkflowEvent>
						<TrackingWorkflowEvent>Idle</TrackingWorkflowEvent>
						<TrackingWorkflowEvent>Suspended</TrackingWorkflowEvent>
						<TrackingWorkflowEvent>Resumed</TrackingWorkflowEvent>
						<TrackingWorkflowEvent>Persisted</TrackingWorkflowEvent>
						<TrackingWorkflowEvent>Unloaded</TrackingWorkflowEvent>
						<TrackingWorkflowEvent>Loaded</TrackingWorkflowEvent>
						<TrackingWorkflowEvent>Exception</TrackingWorkflowEvent>
						<TrackingWorkflowEvent>Terminated</TrackingWorkflowEvent>
						<TrackingWorkflowEvent>Aborted</TrackingWorkflowEvent>
						<TrackingWorkflowEvent>Changed</TrackingWorkflowEvent>
						<TrackingWorkflowEvent>Started</TrackingWorkflowEvent>
					</TrackingWorkflowEvents>
				</WorkflowTrackingLocation>
			</MatchingLocation>
		</WorkflowTrackPoint>
        <UserTrackPoint>
            <MatchingLocations>
                <UserTrackingLocation>
                    <Activity>
                        <Type>System.Workflow.ComponentModel.Activity, System.Workflow.ComponentModel, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35</Type>
                        <MatchDerivedTypes>true</MatchDerivedTypes>
                    </Activity>
                    <Argument>
                        <Type>System.Object, mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35</Type>
                        <MatchDerivedTypes>true</MatchDerivedTypes>
                    </Argument>
                </UserTrackingLocation>
            </MatchingLocations>
        </UserTrackPoint>
    </TrackPoints>
</TrackingProfile>';
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

call dbo.spWWF_TRACKING_PROFILE_DEF_Defaults()
/

call dbo.spSqlDropProcedure('spWWF_TRACKING_PROFILE_DEF_Defaults')
/

-- #endif IBM_DB2 */

