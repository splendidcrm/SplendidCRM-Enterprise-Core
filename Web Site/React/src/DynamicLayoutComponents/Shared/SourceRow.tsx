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
import IDragItemState                                             from '../../types/IDragItemState'  ;
// 3. Scripts. 
import { uuidFast }                                               from '../../scripts/utility'       ;
// 4. Components and Views. 

const style: React.CSSProperties =
{
	border         : '1px dashed grey',
	backgroundColor: '#eeeeee',
	padding        : '2px',
	margin         : '2px',
	borderRadius   : '2px',
	width          : '200px',
};

interface ISourceRowProps
{
	TITLE: string;
	removeRow: (index: number) => void;
	isDragging?: boolean;
}

// 12/31/2023 Paul.  react-dnd v15 requires use of hooks. 
const SourceRow: FC<ISourceRowProps> = memo(function SourceRow(props: ISourceRowProps)
{
	const { TITLE, removeRow } = props;
	//console.log((new Date()).toISOString() + ' ' + 'SourceRow' + '.props', props);
	const [collect, connectDragSource, dragPreview] = useDrag
	(
		() => ({
			type: 'ROW',
			item: (monitor: DragSourceMonitor) =>
			{
				//console.log((new Date()).toISOString() + ' ' + 'SourceRow' + '.item/begin', props, monitor);
				return {
					id: uuidFast(),
					index: -1
				};
			},
			collect: (monitor: DragSourceMonitor) => (
			{
				isDragging: monitor.isDragging()
			}),
			end: (item: IDragItemState, monitor: DragSourceMonitor) =>
			{
				//console.log((new Date()).toISOString() + ' ' + 'SourceRow' + '.end', item, props);
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
		[removeRow],
	);
	//console.log((new Date()).toISOString() + ' ' + 'SourceRow' + ' collected', collect);
	return (
			<div ref={ (node) => connectDragSource(node) }
				className='grab DynamicLayoutComponents-Shared-SourceRow'
				style={ { ...style } }>
				{ TITLE }
			</div>
	);
});

export default SourceRow;
