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

// https://infinum.com/the-capsized-eight/how-to-use-react-hooks-in-class-components
function useScreenSize(): any
{
	const [width , setWidth ] = React.useState(window.innerWidth );
	const [height, setHeight] = React.useState(window.innerHeight);

	React.useEffect(() =>
	{
		const handler = (event: any) =>
		{
			setWidth (event.target.innerWidth );
			setHeight(event.target.innerHeight);
		};
		window.addEventListener('resize', handler);
		return () =>
		{
			window.removeEventListener('resize', handler);
		};
	}, []);

	return {width, height};
}

const withScreenSizeHook = (Component: any) =>
{
	return (props: any) =>
	{
		const screenSize = useScreenSize();
		return <Component screenSize={ screenSize } {...props} />;
	};
};

export default withScreenSizeHook;
