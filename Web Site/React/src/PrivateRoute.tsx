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
import React, { useState, useEffect }         from 'react'                            ;
import { Outlet, useParams, useLocation, useNavigate, useOutletContext } from  'react-router-dom'       ;
import {  SplendidHistory }                   from './Router5'                        ;
import { FontAwesomeIcon }                    from '@fortawesome/react-fontawesome'   ;
// 2. Store and Types. 
// 3. Scripts. 
import { AuthenticatedMethod, LoginRedirect } from './scripts/Login'                  ;
import { StartsWith }                         from './scripts/utility'                ;
// 4. Components and Views. 
import MainContent                            from './ThemeComponents/MainContent'    ;

// https://codedamn.com/news/reactjs/handle-async-functions-with-ease
function PrivateRouteFC()
{
  const [redirecting, setRedirecting] = useState(false);
  const [loading    , setLoading    ] = useState(true);
  const [error      , setError      ] = useState(null);

	const params   = useParams();
	const location = useLocation();
	const navigate = useNavigate();
	const history: SplendidHistory = new SplendidHistory(navigate);
	//console.log((new Date()).toISOString() + ' PrivateRouteFC params'  , params);
	//console.log((new Date()).toISOString() + ' PrivateRouteFC location', location);
	//console.log((new Date()).toISOString() + ' PrivateRouteFC navigate', navigate);

	useEffect(() =>
	{
		async function CheckAuthentication()
		{
			try
			{
				const props: any = { location, history };
				let status = await AuthenticatedMethod(props, 'PrivateRouteFC');
				setLoading(false);
				if ( status == 0 && !StartsWith(props.location.pathname, '/Reload') )
				{
					setRedirecting(true);
					LoginRedirect(props.history, 'PrivateRouteFC');
				}
			}
			catch(error)
			{
				setError(error);
				console.error((new Date()).toISOString() + ' PrivateRouteFC', error);
			}
		}
		CheckAuthentication();
	}, []);

	if ( loading )
	{
		return (
			<div id='divPrivateRoute' style={ {fontSize: '20px', fontWeight: 'bold', padding: '20px'} }>
				<div style={ {textAlign: 'center'} }>
					<FontAwesomeIcon icon="spinner" spin={ true } title="PrivateRouteFC: loading" size="5x" />
				</div>
			</div>
		);
	}
	else if ( redirecting )
	{
		return (
			<div id='divPrivateRoute' style={ {fontSize: '20px', fontWeight: 'bold', padding: '20px'} }>
				<div style={ {textAlign: 'center'} }>
					<FontAwesomeIcon icon="spinner" spin={ true } title="PrivateRouteFC: redirecting" size="5x" />
				</div>
			</div>
		);
	}
	else if ( error )
	{
		return (
			<div id='divPrivateRoute' style={ {fontSize: '20px', fontWeight: 'bold', padding: '20px'} }>
				PrivateRouteFC error: { JSON.stringify(error) }
			</div>
		);
	}
	else
	{
		return (<MainContent>
			<Outlet />
		</MainContent>);
	}
};

export default PrivateRouteFC;
