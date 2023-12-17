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

import * as React from 'react';
import { DragSource, DropTarget, ConnectDropTarget, ConnectDragSource, DropTargetMonitor, DropTargetConnector, DragSourceConnector, DragSourceMonitor } from 'react-dnd';
import { uuidFast }                           from '../scripts/utility'            ;

const style: React.CSSProperties =
{
	border         : '1px dashed grey',
	padding        : '0.5rem 1rem',
	backgroundColor: 'white',
	margin         : '0 .25em',
};

interface ISourceBlankProps
{
	TITLE               : string;
	createItemFromSource: (item: any) => any;
	connectDragSource?  : ConnectDragSource;
}

const source =
{
	beginDrag(props: ISourceBlankProps)
	{
		//console.log((new Date()).toISOString() + ' ' + 'SourceBlank' + '.beginDrag', props);
		return props.createItemFromSource(
		{
			id               : uuidFast(),
			index            : -1,
			NAME             : '(blank)',
			CATEGORY         : null,
			MODULE_NAME      : null,
			TITLE            : '(blank)',
			SETTINGS_EDITVIEW: null,
			IS_ADMIN         : false,
			APP_ENABLED      : true,
			SCRIPT_URL       : null,
			DEFAULT_SETTINGS : null,
		});
	},
	endDrag(props: ISourceBlankProps, monitor: DragSourceMonitor)
	{
		//console.log((new Date()).toISOString() + ' ' + 'SourceBlank' + '.endDrag', props, monitor);
	}
};

function collect(connect: DragSourceConnector, monitor: DragSourceMonitor)
{
	//console.log((new Date()).toISOString() + ' ' + 'SourceBlank' + '.collect', connect, monitor);
	return {
		connectDragSource: connect.dragSource()
	};
}

class SourceBlank extends React.Component<ISourceBlankProps>
{
	constructor(props: ISourceBlankProps)
	{
		super(props);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor', props);
	}

	public render()
	{
		const{ TITLE, connectDragSource } = this.props;
		return (
			connectDragSource &&
			connectDragSource(
				<div style={ { ...style } } className="grab">
					{ TITLE }
				</div>
			)
		);
	}
}

export default DragSource('ITEM', source, collect)(SourceBlank);
