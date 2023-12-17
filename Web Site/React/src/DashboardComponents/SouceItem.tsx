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

const style: React.CSSProperties =
{
	border         : '1px solid grey',
	padding        : '0.5rem 1rem',
	backgroundColor: 'white',
	margin         : '.125em .25em',
	borderRadius   : '.25em',
};

interface ISouceItemProps
{
	item                : any;
	isAppInUse          : boolean;
	createItemFromSource: (item: any) => any;
	moveDraggableItem   : (dragColIndex: number, dragRowIndex: number, hoverCOlIndex: number, hoverRowIndex: number) => void;
	remove              : (item, type) => void;
	connectDragSource?  : ConnectDragSource;
}

const source =
{
	beginDrag(props: ISouceItemProps)
	{
		//console.log((new Date()).toISOString() + ' ' + 'SouceItem' + '.beginDrag', props);
		return props.createItemFromSource(props.item);
	},
	endDrag(props: ISouceItemProps, monitor: DragSourceMonitor)
	{
		//console.log((new Date()).toISOString() + ' ' + 'SouceItem' + '.endDrag', props, monitor.getItem());
		if ( monitor.didDrop() )
		{
			//const id           : string = monitor.getItem().id        ;
			//const hoverColIndex: number = monitor.getItem().colIndex  ;
			//const hoverRowIndex: number = monitor.getItem().rowIndex  ;
			//props.moveDraggableItem(id, hoverColIndex, hoverRowIndex);
		}
		else
		{
			// 03/14/2020 Paul.  We need to remove the ghost item created above. 
			props.remove( monitor.getItem(), 'ITEM');
		}
	}
};

function collect(connect: DragSourceConnector, monitor: DragSourceMonitor)
{
	//console.log((new Date()).toISOString() + ' ' + 'SouceItem' + '.collect', connect, monitor);
	return {
		connectDragSource: connect.dragSource()
	};
}

class SouceItem extends React.Component<ISouceItemProps>
{
	constructor(props: ISouceItemProps)
	{
		super(props);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor', props);
	}

	public render()
	{
		const{ item, isAppInUse, connectDragSource } = this.props;
		return (
			connectDragSource &&
			connectDragSource(
				<div
					className='grab'
					style={ { ...style, display: (isAppInUse ? 'none' : null) } }>
					{ item.NAME }
					<br />
					<small>{ item.MODULE_NAME }</small>
				</div>
			)
		);
	}
}

export default DragSource('ITEM', source, collect)(SouceItem);
