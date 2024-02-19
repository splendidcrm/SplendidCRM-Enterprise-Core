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
import L10n                                                       from '../../scripts/L10n'          ;

const style: React.CSSProperties =
{
	border         : '1px solid grey',
	backgroundColor: '#eeeeee',
	padding        : '2px',
	margin         : '2px',
	borderRadius   : '2px',
	width          : '200px',
	overflowX      : 'hidden',
};

interface ISouceItemProps
{
	ModuleName          : string;
	item                : any;
	isFieldInUse        : boolean;
	createItemFromSource: (item: any) => any;
	moveDraggableItem   : (id: string, hoverColIndex: number, hoverRowIndex: number, didDrop: boolean) => void;
	remove              : (item, type) => void;
}

// 12/31/2023 Paul.  react-dnd v15 requires use of hooks. 
const SouceItem: FC<ISouceItemProps> = memo(function SouceItem(props: ISouceItemProps)
{
	const{ ModuleName, item, isFieldInUse, createItemFromSource, moveDraggableItem, remove } = props;
	//console.log((new Date()).toISOString() + ' ' + 'SouceItem' + '.props', props);
	const [collect, connectDragSource, dragPreview] = useDrag
	(
		() => ({
			type: 'ITEM',
			item: (monitor: DragSourceMonitor) =>
			{
				//console.log((new Date()).toISOString() + ' ' + 'SouceItem' + '.item/begin', item, props, monitor);
				return createItemFromSource(Object.assign(props.item, { id: item.DATA_FIELD} ));
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
		[item, createItemFromSource, moveDraggableItem, remove],
	);
	//console.log((new Date()).toISOString() + ' ' + 'SouceItem' + ' collected', collect, dropCollect);
	// 03/14/2020 Paul.  When field is in use, we must hide it instead of not creating it as failure to create would prevent endDrag from firing. 
	return (
			<div ref={ (node) => connectDragSource(node) }
				className='grab DynamicLayoutComponents-Shared-SourceItem'
				style={ { ...style, display: (isFieldInUse ? 'none' : null) } }
				>
				{ item.ColumnName }
				<br />
				{ L10n.TableColumnName(ModuleName, item.ColumnName) }
			</div>
	);
});

export default SouceItem;
