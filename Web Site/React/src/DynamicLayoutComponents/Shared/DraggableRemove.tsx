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
import { FontAwesomeIcon }                                        from '@fortawesome/react-fontawesome';
import { useDrag, useDrop, DragSourceMonitor, DropTargetMonitor } from 'react-dnd';
// 2. Store and Types. 
import IDragItemState                                             from '../../types/IDragItemState'  ;
// 3. Scripts. 
// 4. Components and Views. 

interface IDraggableRemoveProps
{
	isOver?           : boolean
	connectDropTarget?: Function;  // ConnectDropTarget;
	remove            : (item, type) => void;
}

// 12/31/2023 Paul.  react-dnd v15 requires use of hooks. 
const DraggableRemove: FC<IDraggableRemoveProps> = memo(function DraggableRemove(props: IDraggableRemoveProps)
{
	const { remove } = props;
	//console.log((new Date()).toISOString() + ' ' + 'DraggableRemove' + '.props', props);
	const [dropCollect, connectDropTarget] = useDrop
	(
		() => ({
			accept: ['ITEM', 'ROW'],
			collect: (monitor: DropTargetMonitor) => (
			{
				isOver: monitor.isOver()
			}),
			drop(item: IDragItemState, monitor: DropTargetMonitor)
			{
				//console.log((new Date()).toISOString() + ' ' + 'DraggableRemove' + '.drop', props);
				remove(item, monitor.getItemType());
			},
			canDrop(item: IDragItemState, monitor: DropTargetMonitor)
			{
				//console.log((new Date()).toISOString() + ' ' + 'DraggableRemove' + '.canDrop ' + typeof(item), item);
				return true;
			},
		}),
		[remove],
	);
	//console.log((new Date()).toISOString() + ' ' + 'DraggableRemove' + ' collected', collect, dropCollect);
	return (
			<div ref={ (node) => connectDropTarget(node) }
				style={{ padding: '1em 0', display: 'inline-block' }}>
				<FontAwesomeIcon icon='trash-alt' size='4x' />
			</div>
	);
});

export default DraggableRemove;
