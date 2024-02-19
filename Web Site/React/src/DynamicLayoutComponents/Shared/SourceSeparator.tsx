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

interface ISourceSeparatorProps
{
	TITLE               : string;
	createItemFromSource: (item: any) => any;
	moveDraggableItem   : (id: string, hoverColIndex: number, hoverRowIndex: number, didDrop: boolean) => void;
	remove              : (item, type) => void;
}

// 12/31/2023 Paul.  react-dnd v15 requires use of hooks. 
const SourceSeparator: FC<ISourceSeparatorProps> = memo(function SourceSeparator(props: ISourceSeparatorProps)
{
	const{ TITLE, createItemFromSource, moveDraggableItem, remove } = props;
	//console.log((new Date()).toISOString() + ' ' + 'SourceHeader' + '.props', props);
	const [collect, connectDragSource, dragPreview] = useDrag
	(
		() => ({
			type: 'ITEM',
			item: (monitor: DragSourceMonitor) =>
			{
				//console.log((new Date()).toISOString() + ' ' + 'SouceBlank' + '.item/begin', props, monitor);
				return createItemFromSource(
					{
						id          : uuidFast() ,
						index       : -1         ,
						ID          : null       ,
						FIELD_TYPE  : 'Separator',
						DATA_LABEL  : null       ,
						DATA_FIELD  : null       ,
						DATA_FORMAT : null       ,
						URL_FIELD   : null       ,
						URL_FORMAT  : null       ,
						URL_TARGET  : null       ,
						MODULE_TYPE : null       ,
						LIST_NAME   : null       ,
						COLSPAN     : null       ,
						TOOL_TIP    : null       ,
						PARENT_FIELD: null       ,
					});
			},
			collect: (monitor: DragSourceMonitor) => (
			{
				isDragging: monitor.isDragging()
			}),
			end: (item: IDragItemState, monitor: DragSourceMonitor) =>
			{
				//console.log((new Date()).toISOString() + ' ' + 'SouceItem' + '.end', item, props);
				if ( monitor.didDrop() )
				{
					// 12/31/2023 Paul.  Upgrade DnD. 
					const id           : string = item.id        ;
					const hoverColIndex: number = item.colIndex  ;
					const hoverRowIndex: number = item.rowIndex  ;
					moveDraggableItem(id, hoverColIndex, hoverRowIndex, true);
				}
				else
				{
					// 03/14/2020 Paul.  We need to remove the ghost item created above. 
					remove(item, 'ITEM');
				}
			},
			canDrag: (monitor: DragSourceMonitor) =>
			{
				return true;
			},
		}),
		[createItemFromSource, moveDraggableItem, remove],
	);
	//console.log((new Date()).toISOString() + ' ' + 'SourceHeader' + ' collected', collect, dropCollect);
	return (
			<div ref={ (node) => connectDragSource(node) }
				className='grab DynamicLayoutComponents-Shared-SourceSeparator'
				style={ { ...style } }>
				{ TITLE }
			</div>
	);
});

export default SourceSeparator;
