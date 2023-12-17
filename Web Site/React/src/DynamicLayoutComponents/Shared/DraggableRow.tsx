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
	border         : '1px dashed grey',
	paddingTop     : '0.5em',
	paddingBottom  : '0.5em',
	paddingLeft    : '1em',
	paddingRight   : '1em',
	marginBottom   : '.5rem',
	backgroundColor: 'lightgrey',
	cursor         : 'move',
	display        : 'flex',
	minHeight      : '64px',
};

interface IDraggableRowProps
{
	id                : any;
	index             : number;
	isDragging?       : boolean;
	connectDragSource?: Function; // ConnectDragSource;
	connectDropTarget?: Function; // ConnectDropTarget;
	length            : number;
	moveDraggableRow  : (dragIndex: number, hoverIndex: number) => void;
	moveDraggableItem : (id: string, hoverColIndex: number, hoverRowIndex: number, didDrop: boolean) => void;
	addSourceItem     : (id: string, hoverColIndex: number, hoverRowIndex: number) => void;
	addSourceRow      : (id: string, hoverIndex: number) => void;
	removeRow         : (index: number) => void;
}

interface IDraggableRowState
{
	isOver            : boolean;
	isDragging        : boolean;
}

const source =
{
	beginDrag(props: IDraggableRowProps)
	{
		//console.log((new Date()).toISOString() + ' ' + 'DraggableRow' + '.beginDrag', props);
		return {
			id   : props.id,
			index: props.index,
		};
	},
	endDrag(props: IDraggableRowProps, monitor: DragSourceMonitor)
	{
		//console.log((new Date()).toISOString() + ' ' + 'DraggableRow' + '.endDrag', props, monitor);
		if ( !monitor.didDrop() )
		{
			props.removeRow(monitor.getItem().index);
		}
	}
};

function collect(connect: DragSourceConnector, monitor: DragSourceMonitor)
{
	//console.log((new Date()).toISOString() + ' ' + 'DraggableRow' + '.collect', connect, monitor);
	return {
		connectDragSource: connect.dragSource(),
		isDragging       : monitor.isDragging(),
	};
}

const rowTarget =
{
	hover(props: IDraggableRowProps, monitor: DropTargetMonitor, component: DraggableRow)
	{
		//console.log((new Date()).toISOString() + ' ' + 'DraggableRow' + '.hover', props, monitor);
		if ( monitor.getItemType() == 'ROW' )
		{
			const dragIndex = monitor.getItem().index;
			const hoverIndex = props.index;

			// Don't replace rows with themselves
			if ( dragIndex === hoverIndex )
			{
				return;
			}
			if ( dragIndex != -1 )
			{
				props.moveDraggableRow(dragIndex, hoverIndex);
			}
			else
			{
				const id = monitor.getItem().id;
				props.addSourceRow(id, hoverIndex);
			}
			// Time to actually perform the action
			// Note: we're mutating the monitor row here!
			// Generally it's better to avoid mutations,
			// but it's good here for the sake of performance
			// to avoid expensive index searches.
			monitor.getItem().id = props.id;
			monitor.getItem().index = hoverIndex;
		}
		else
		{
			if ( props.length != 0 )
			{
				return;
			}
			const id            : string = monitor.getItem().id        ;
			const dragFieldIndex: number = monitor.getItem().fieldIndex;
			const dragColIndex  : number = monitor.getItem().colIndex  ;
			const dragRowIndex  : number = monitor.getItem().rowIndex  ;
			const hoverColIndex : number = 0;
			const hoverRowIndex : number = props.index;
			// Don't replace items with themselves
			if ( dragColIndex === hoverColIndex && dragRowIndex === hoverRowIndex )
			{
				return;
			}
			if ( dragColIndex != -1 && dragRowIndex != -1 )
			{
				if ( Math.abs(dragRowIndex - hoverRowIndex) > 1 )
				{
					return;
				}
				//console.log((new Date()).toISOString() + ' ' + 'DraggableRow' + '.hover', props, monitor);
				props.moveDraggableItem(id, hoverColIndex, hoverRowIndex, false);
			}
			else
			{
				//console.log((new Date()).toISOString() + ' ' + 'DraggableRow' + '.hover', props, monitor);
				const id = monitor.getItem().id;
				props.addSourceItem(id, hoverColIndex, hoverRowIndex);
			}
			// Time to actually perform the action
			// Note: we're mutating the monitor item here!
			// Generally it's better to avoid mutations,
			// but it's good here for the sake of performance
			// to avoid expensive index searches.
			//monitor.getItem().id = props.id;
			monitor.getItem().colIndex   = hoverColIndex  ;
			monitor.getItem().rowIndex   = hoverRowIndex  ;
		}
	}
};

function dropCollect(connect: DropTargetConnector)
{
	//console.log((new Date()).toISOString() + ' ' + 'DraggableRow' + '.dropCollect', connect);
	return {
		connectDropTarget: connect.dropTarget()
	};
}

class DraggableRow extends React.Component<IDraggableRowProps, IDraggableRowState>
{
	constructor(props: IDraggableRowProps)
	{
		super(props);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor', props);
		this.state =
		{
			isOver    : false,
			isDragging: false,
		};
	}

	public render()
	{
		const { index, length, children } = this.props;
		const { isOver, isDragging } = this.state;
		const opacity = isDragging ? 0 : 1;
		return (
			this.props.connectDragSource &&
			this.props.connectDropTarget &&
			this.props.connectDragSource(
				this.props.connectDropTarget(
					<tr
						style={ { ...style, opacity } }>
						{ children }
					</tr>
				)
			)
		);
	}
}

export default DropTarget(['ROW', 'ITEM'], rowTarget, dropCollect)(DragSource('ROW', source, collect)(DraggableRow));
