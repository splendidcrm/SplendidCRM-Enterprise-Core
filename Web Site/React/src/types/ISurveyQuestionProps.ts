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
import SURVEY_PAGE_QUESTION  from '../types/SURVEY_PAGE_QUESTION';

export default interface ISurveyQuestionProps
{
	row                 : SURVEY_PAGE_QUESTION;
	displayMode         : string;
	rowQUESTION_RESULTS?: any;
	onChanged?          : (DATA_FIELD: string, DATA_VALUE: any, DISPLAY_FIELD?: string, DISPLAY_VALUE?: any) => void;
	onSubmit?           : () => void;
	onUpdate?           : (PARENT_FIELD: string, DATA_VALUE: any, item?: any) => void;
	createDependency?   : (DATA_FIELD: string, PARENT_FIELD: string, PROPERTY_NAME?: string) => void;
	onFocusNextQuestion?: (ID: string) => void;
	isPageFocused?      : () => boolean;
}

