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
import React from 'react';
import { Outlet, useLocation }                from  'react-router-dom'                ;
// 2. Store and Types. 
// 3. Scripts. 
// 4. Components and Views. 
import MainContent                            from './ThemeComponents/MainContent'    ;

// https://codedamn.com/news/reactjs/handle-async-functions-with-ease
function PublicRouteFC()
{
	const location = useLocation();
	console.log((new Date()).toISOString() + ' PublicRouteFC location', location);

	return (<MainContent>
		<Outlet />
	</MainContent>);
};

export default PublicRouteFC;
