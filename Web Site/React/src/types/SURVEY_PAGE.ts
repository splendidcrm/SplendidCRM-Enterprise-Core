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
import SURVEY_PAGE_QUESTION from './SURVEY_PAGE_QUESTION';

export default interface SURVEY_PAGE
{ ID                            : string  // uniqueidentifier
, NAME                          : string  // nvarchar
, PAGE_NUMBER                   : number  // int
, QUESTION_RANDOMIZATION        : string  // nvarchar
, DESCRIPTION                   : string  // nvarchar
, SURVEY_ID                     : string  // uniqueidentifier
, RANDOMIZE_COUNT               : number  // int
, RANDOMIZE_APPLIED             : boolean  // 07/16/2018 Paul.  computed
, RENUMBER_QUESTIONS            : boolean  // 07/16/2018 Paul.  computed
, QUESTION_OFFSET               : number  // 07/16/2018 Paul.  computed
, MOBILE_ID                     : string  // 07/16/2018 Paul.  computed
, SURVEY_QUESTIONS              : SURVEY_PAGE_QUESTION[]
}

