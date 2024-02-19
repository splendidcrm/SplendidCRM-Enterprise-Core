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

import React, { memo, FC, useState }                              from 'react';
import { useDrag, useDrop, DragSourceMonitor, DropTargetMonitor } from 'react-dnd';
// 2. Store and Types. 
import IDragItemState                                             from '../../types/IDragItemState'  ;
// 3. Scripts. 
// 4. Components and Views. 

interface IDraggableCellProps
{
	width             : string;
	colIndex          : number;
	rowIndex          : number;
	didDrop?          : boolean;
	rowTotal?         : number;
	connectDropTarget?: Function;  // ConnectDropTarget;
	moveDraggableItem : (id: string, hoverColIndex: number, hoverRowIndex: number, didDrop: boolean) => void;
	addSourceItem     : (id: string, hoverColIndex: number, hoverRowIndex: number) => void;
	children          : React.ReactNode;
}

interface IDraggableCellState
{
	isOver            : boolean;
	isDragging?       : boolean;
}

// 12/31/2023 Paul.  react-dnd v15 requires use of hooks. 
const DraggableCell: FC<IDraggableCellProps> = memo(function DraggableCell(props: IDraggableCellProps)
{
	const { width, rowTotal, colIndex, rowIndex, moveDraggableItem, addSourceItem, children } = props;
	const [dropCollect, connectDropTarget] = useDrop
	(
		() => ({
			accept: ['ITEM'],
			collect: (monitor: DropTargetMonitor) => (
			{
				isOver : monitor.isOver(),
				didDrop: monitor.didDrop(),
			}),
			hover(item: IDragItemState, monitor: DropTargetMonitor)
			{
				//console.log((new Date()).toISOString() + ' ' + 'DraggableCell' + '.hover', props, monitor);
				const id            : string = item.id        ;
				const dragFieldIndex: number = item.fieldIndex;
				const dragColIndex  : number = item.colIndex  ;
				const dragRowIndex  : number = item.rowIndex  ;
				const hoverColIndex : number = colIndex;
				const hoverRowIndex : number = rowIndex;
				//console.log((new Date()).toISOString() + ' ' + 'DraggableCell' + '.hover', props, monitor, component);

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
					// 03/08/2020 Paul.  When moving items around, we do not need to move existing item. 
					//console.log((new Date()).toISOString() + ' ' + 'DraggableCell' + '.hover', props, monitor);
					moveDraggableItem(id, hoverColIndex, hoverRowIndex, false);
				}
				else
				{
					//console.log((new Date()).toISOString() + ' ' + 'DraggableCell' + '.hover', props, monitor);
					const id: string = item.id;
					addSourceItem(id, hoverColIndex, hoverRowIndex);
				}

				// Time to actually perform the action

				// Note: we're mutating the monitor item here!
				// Generally it's better to avoid mutations,
				// but it's good here for the sake of performance
				// to avoid expensive index searches.
				item.colIndex = hoverColIndex;
				item.rowIndex = hoverRowIndex;
			},
			canDrop(item: IDragItemState, monitor: DropTargetMonitor)
			{
				//console.log((new Date()).toISOString() + ' ' + 'DraggableCell' + '.canDrop ' + typeof(item), item);
				return true;
			},
		}),
		[colIndex, rowIndex, moveDraggableItem, addSourceItem],
	);
	//console.log((new Date()).toISOString() + ' ' + 'DraggableCell' + ' collected', collect, dropCollect);

	return (
			<td ref={ (node) => connectDropTarget(node) }
				style={{ width, border: '1px dashed grey' }}>
				{ children }
			</td>
	);
});

export default DraggableCell;
