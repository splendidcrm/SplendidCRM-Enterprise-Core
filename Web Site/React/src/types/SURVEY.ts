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
// 2. Store and Types. 
import SURVEY_PAGE from './SURVEY_PAGE';

export default interface SURVEY
{ ID                            : string  // uniqueidentifier
, DATE_MODIFIED_UTC             : Date
, NAME                          : string  // nvarchar
, STATUS                        : string  // nvarchar
// 10/01/2018 Paul.  Include SURVEY_TARGET_MODULE. 
, SURVEY_TARGET_MODULE          : string  // nvarchar
, SURVEY_STYLE                  : string  // nvarchar
, PAGE_RANDOMIZATION            : string  // nvarchar
, DESCRIPTION                   : string  // nvarchar
, SURVEY_THEME_ID               : string  // uniqueidentifier
, RANDOMIZE_COUNT               : number  // int
, RANDOMIZE_APPLIED             : boolean // 07/16/2018 Paul.  computed
, RENUMBER_PAGES                : boolean // 07/16/2018 Paul.  computed
, SURVEY_PAGES                  : SURVEY_PAGE[]
, LOOP_SURVEY                   : boolean // bit
, TIMEOUT                       : number  // seconds
, RESULTS_COUNT                 : number  // return with cached list. 
, SURVEY_THEME                  : any     // the entire theme is included with the survey. 
}

