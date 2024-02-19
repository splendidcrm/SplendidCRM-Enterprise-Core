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
import React, { memo, FC }                                        from 'react';
import { useDrag, useDrop, DragSourceMonitor, DropTargetMonitor } from 'react-dnd';
// 2. Store and Types. 
import IDragItemState                                             from '../types/IDragItemState'  ;
// 3. Scripts. 
// 4. Components and Views. 

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
	length            : number;
	moveDraggableRow  : (dragIndex: number, hoverIndex: number) => void;
	moveDraggableItem : (dragColIndex: number, dragRowIndex: number, hoverCOlIndex: number, hoverRowIndex: number) => void;
	addSourceItem     : (id: string, hoverColIndex: number, hoverRowIndex: number) => void;
	addSourceRow      : (id: string, hoverIndex: number) => void;
	removeRow         : (index: number) => void;
	children          : React.ReactNode;
}

// 12/31/2023 Paul.  react-dnd v15 requires use of hooks. 
const DraggableRow: FC<IDraggableRowProps> = memo(function DraggableRow(props: IDraggableRowProps)
{
	//console.log((new Date()).toISOString() + ' ' + 'DraggableRow' + '.props', props);
	const { id, index, length, children, moveDraggableRow, moveDraggableItem, addSourceItem, addSourceRow, removeRow } = props;
	const [collect, connectDragSource, dragPreview] = useDrag
	(
		() => ({
			type: 'ROW',
			item: (monitor: DragSourceMonitor) =>
			{
				//console.log((new Date()).toISOString() + ' ' + 'DraggableRow' + '.item/begin', props, monitor);
				return { id, index };
			},
			collect: (monitor: DragSourceMonitor) => (
			{
				isDragging: monitor.isDragging()
			}),
			end: (item: IDragItemState, monitor: DragSourceMonitor) =>
			{
				//console.log((new Date()).toISOString() + ' ' + 'DraggableRow' + '.end', item, props);
				if ( !monitor.didDrop() )
				{
					removeRow(item.index);
				}
			},
			canDrag: (monitor: DragSourceMonitor) =>
			{
				return true;
			},
		}),
		[id, index, moveDraggableRow, removeRow],
	);
	const [dropCollect, connectDropTarget] = useDrop
	(
		() => ({
			accept: ['ROW', 'ITEM'],
			collect: (monitor: DropTargetMonitor) => (
			{
				isOver: monitor.isOver()
			}),
			hover(item: IDragItemState, monitor: DropTargetMonitor)
			{
				//console.log((new Date()).toISOString() + ' ' + 'DraggableRow' + '.hover', props, monitor);
				if ( monitor.getItemType() == 'ROW' )
				{
					const dragIndex = item.index;
					const hoverIndex = index;

					// Don't replace rows with themselves
					if ( dragIndex === hoverIndex )
					{
						return;
					}
					if ( dragIndex != -1 )
					{
						moveDraggableRow(dragIndex, hoverIndex);
					}
					else
					{
						const id = item.id;
						addSourceRow(id, hoverIndex);
					}
					// Time to actually perform the action
					// Note: we're mutating the monitor row here!
					// Generally it's better to avoid mutations,
					// but it's good here for the sake of performance
					// to avoid expensive index searches.
					item.id    = id;
					item.index = hoverIndex;
				}
				else
				{
					if ( length != 0 )
					{
						return;
					}
					const dragColIndex  : number = item.colIndex  ;
					const dragRowIndex  : number = item.rowIndex  ;
					const hoverColIndex : number = 0;
					const hoverRowIndex : number = index;
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
						moveDraggableItem(dragColIndex, dragRowIndex, hoverColIndex, hoverRowIndex);
					}
					else
					{
						//console.log((new Date()).toISOString() + ' ' + 'DraggableRow' + '.hover', props, monitor);
						const id = item.id;
						addSourceItem(id, hoverColIndex, hoverRowIndex);
					}

					// Time to actually perform the action

					// Note: we're mutating the monitor item here!
					// Generally it's better to avoid mutations,
					// but it's good here for the sake of performance
					// to avoid expensive index searches.
					//monitor.getItem().id = props.id;
					item.colIndex = hoverColIndex;
					item.rowIndex = hoverRowIndex;
				}
			},
			canDrop(item: IDragItemState, monitor: DropTargetMonitor)
			{
				//console.log((new Date()).toISOString() + ' ' + 'DraggableRow' + '.canDrop ' + typeof(item), item);
				return true;
			},
		}),
		[id, index, length, moveDraggableRow, moveDraggableItem, addSourceItem, addSourceRow],
	);
	//console.log((new Date()).toISOString() + ' ' + 'DraggableRow' + ' collected', collect, dropCollect);

	const opacity = collect.isDragging ? 0 : 1;
	return (
			<div ref={ (node) => connectDragSource(connectDropTarget(node)) }
				style={ { ...style, opacity } }>
				{ children }
			</div>
	);
});

export default DraggableRow;
