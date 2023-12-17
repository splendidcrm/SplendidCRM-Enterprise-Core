/*
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Enterprise Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 */

// 1. React and fabric. 
import * as React from 'react';
// 2. Store and Types. 
// 3. Scripts. 
// 4. Components and Views. 
// 5. Dashlets
import MyAccounts                 from './MyAccounts'                ;
import MyActivities               from './MyActivities'              ;
import MyBugs                     from './MyBugs'                    ;
import MyCalendar                 from './MyCalendar'                ;
import MyCalls                    from './MyCalls'                   ;
import MyCases                    from './MyCases'                   ;
import MyContacts                 from './MyContacts'                ;
import MyEmails                   from './MyEmails'                  ;
import MyLeads                    from './MyLeads'                   ;
import MyMeetings                 from './MyMeetings'                ;
import MyOpportunities            from './MyOpportunities'           ;
import MyProjects                 from './MyProjects'                ;
import MyProjectTasks             from './MyProjectTasks'            ;
import MyProspects                from './MyProspects'               ;
import MyTasks                    from './MyTasks'                   ;
import MyInvoices                 from './MyInvoices'                ;
import MyOrders                   from './MyOrders'                  ;
import MyQuotes                   from './MyQuotes'                  ;

import MyFavoriteAccounts         from './MyFavoriteAccounts'        ;
import MyFavoriteBugs             from './MyFavoriteBugs'            ;
import MyFavoriteCases            from './MyFavoriteCases'           ;
import MyFavoriteContacts         from './MyFavoriteContacts'        ;
import MyFavoriteEmails           from './MyFavoriteEmails'          ;
import MyFavoriteLeads            from './MyFavoriteLeads'           ;
import MyFavoriteOpportunities    from './MyFavoriteOpportunities'   ;
import MyFavoriteProjects         from './MyFavoriteProjects'        ;
import MyFavoriteProjectTasks     from './MyFavoriteProjectTasks'    ;
import MyFavoriteProspects        from './MyFavoriteProspects'       ;
import MyFavoriteInvoices         from './MyFavoriteInvoices'        ;
import MyFavoriteOrders           from './MyFavoriteOrders'          ;
import MyFavoriteQuotes           from './MyFavoriteQuotes'          ;
import MyFavoriteTasks            from './MyFavoriteTasks'           ;

import MyTeamAccounts             from './MyTeamAccounts'            ;
import MyTeamActivities           from './MyTeamActivities'          ;
import MyTeamBugs                 from './MyTeamBugs'                ;
import MyTeamCalls                from './MyTeamCalls'               ;
import MyTeamCases                from './MyTeamCases'               ;
import MyTeamContacts             from './MyTeamContacts'            ;
import MyTeamEmails               from './MyTeamEmails'              ;
import MyTeamLeads                from './MyTeamLeads'               ;
import MyTeamMeetings             from './MyTeamMeetings'            ;
import MyTeamOpportunities        from './MyTeamOpportunities'       ;
import MyTeamPipelineBySalesStage from './MyTeamPipelineBySalesStage';
import MyTeamProjects             from './MyTeamProjects'            ;
import MyTeamProjectTasks         from './MyTeamProjectTasks'        ;
import MyTeamProspects            from './MyTeamProspects'           ;
import MyTeamInvoices             from './MyTeamInvoices'            ;
import MyTeamOrders               from './MyTeamOrders'              ;
import MyTeamQuotes               from './MyTeamQuotes'              ;
import MyTeamTasks                from './MyTeamTasks'               ;

import PipelineByMonthByOutcome   from './PipelineByMonthByOutcome'  ;
import OppByLeadSourceByOutcome   from './OppByLeadSourceByOutcome'  ;
import OppByLeadSource            from './OppByLeadSource'           ;
import PipelineBySalesStage       from './PipelineBySalesStage'      ;
import MyPipelineBySalesStage     from './MyPipelineBySalesStage'    ;
import ReportViewerFrame          from './ReportViewerFrame'         ;
import ChartViewerFrame           from './ChartViewerFrame'          ;

import MyProcesses                from './MyProcesses'               ;

export default function DashletFactory(sDASHLET_NAME: string)
{
	let dashlet = null;
	switch ( sDASHLET_NAME )
	{
		case 'MyAccounts'                :  dashlet = MyAccounts                ;  break;
		case 'MyActivities'              :  dashlet = MyActivities              ;  break;
		case 'MyBugs'                    :  dashlet = MyBugs                    ;  break;
		case 'MyCalendar'                :  dashlet = MyCalendar                ;  break;
		case 'MyCalls'                   :  dashlet = MyCalls                   ;  break;
		case 'MyCases'                   :  dashlet = MyCases                   ;  break;
		case 'MyContacts'                :  dashlet = MyContacts                ;  break;
		case 'MyEmails'                  :  dashlet = MyEmails                  ;  break;
		case 'MyLeads'                   :  dashlet = MyLeads                   ;  break;
		case 'MyMeetings'                :  dashlet = MyMeetings                ;  break;
		case 'MyOpportunities'           :  dashlet = MyOpportunities           ;  break;
		case 'MyProjects'                :  dashlet = MyProjects                ;  break;
		case 'MyProjectTasks'            :  dashlet = MyProjectTasks            ;  break;
		case 'MyProspects'               :  dashlet = MyProspects               ;  break;
		case 'MyTasks'                   :  dashlet = MyTasks                   ;  break;
		case 'MyInvoices'                :  dashlet = MyInvoices                ;  break;
		case 'MyOrders'                  :  dashlet = MyOrders                  ;  break;
		case 'MyQuotes'                  :  dashlet = MyQuotes                  ;  break;
		
		case 'MyFavoriteAccounts'        :  dashlet = MyFavoriteAccounts        ;  break;
		case 'MyFavoriteBugs'            :  dashlet = MyFavoriteBugs            ;  break;
		case 'MyFavoriteCases'           :  dashlet = MyFavoriteCases           ;  break;
		case 'MyFavoriteContacts'        :  dashlet = MyFavoriteContacts        ;  break;
		case 'MyFavoriteEmails'          :  dashlet = MyFavoriteEmails          ;  break;
		case 'MyFavoriteLeads'           :  dashlet = MyFavoriteLeads           ;  break;
		case 'MyFavoriteOpportunities'   :  dashlet = MyFavoriteOpportunities   ;  break;
		case 'MyFavoriteProjects'        :  dashlet = MyFavoriteProjects        ;  break;
		case 'MyFavoriteProjectTasks'    :  dashlet = MyFavoriteProjectTasks    ;  break;
		case 'MyFavoriteProspects'       :  dashlet = MyFavoriteProspects       ;  break;
		case 'MyFavoriteInvoices'        :  dashlet = MyFavoriteInvoices        ;  break;
		case 'MyFavoriteOrders'          :  dashlet = MyFavoriteOrders          ;  break;
		case 'MyFavoriteQuotes'          :  dashlet = MyFavoriteQuotes          ;  break;
		case 'MyFavoriteTasks'           :  dashlet = MyFavoriteTasks           ;  break;
		
		case 'MyTeamAccounts'            :  dashlet = MyTeamAccounts            ;  break;
		case 'MyTeamActivities'          :  dashlet = MyTeamActivities          ;  break;
		case 'MyTeamBugs'                :  dashlet = MyTeamBugs                ;  break;
		case 'MyTeamCalls'               :  dashlet = MyTeamCalls               ;  break;
		case 'MyTeamCases'               :  dashlet = MyTeamCases               ;  break;
		case 'MyTeamContacts'            :  dashlet = MyTeamContacts            ;  break;
		case 'MyTeamEmails'              :  dashlet = MyTeamEmails              ;  break;
		case 'MyTeamLeads'               :  dashlet = MyTeamLeads               ;  break;
		case 'MyTeamMeetings'            :  dashlet = MyTeamMeetings            ;  break;
		case 'MyTeamOpportunities'       :  dashlet = MyTeamOpportunities       ;  break;
		case 'MyTeamPipelineBySalesStage':  dashlet = MyTeamPipelineBySalesStage;  break;
		case 'MyTeamProjects'            :  dashlet = MyTeamProjects            ;  break;
		case 'MyTeamProjectTasks'        :  dashlet = MyTeamProjectTasks        ;  break;
		case 'MyTeamProspects'           :  dashlet = MyTeamProspects           ;  break;
		case 'MyTeamInvoices'            :  dashlet = MyTeamInvoices            ;  break;
		case 'MyTeamOrders'              :  dashlet = MyTeamOrders              ;  break;
		case 'MyTeamQuotes'              :  dashlet = MyTeamQuotes              ;  break;
		case 'MyTeamTasks'               :  dashlet = MyTeamTasks               ;  break;
		
		case 'PipelineByMonthByOutcome'  :  dashlet = PipelineByMonthByOutcome  ;  break;
		case 'OppByLeadSourceByOutcome'  :  dashlet = OppByLeadSourceByOutcome  ;  break;
		case 'OppByLeadSource'           :  dashlet = OppByLeadSource           ;  break;
		case 'PipelineBySalesStage'      :  dashlet = PipelineBySalesStage      ;  break;
		case 'MyPipelineBySalesStage'    :  dashlet = MyPipelineBySalesStage    ;  break;
		case 'ReportViewerFrame'         :  dashlet = ReportViewerFrame         ;  break;
		case 'ChartViewerFrame'          :  dashlet = ChartViewerFrame          ;  break;

		case 'MyProcesses'               :  dashlet = MyProcesses               ;  break;
	}
	if ( dashlet )
	{
		//console.log('DashletFactory found ' + sDASHLET_NAME);
	}
	return dashlet;
}
