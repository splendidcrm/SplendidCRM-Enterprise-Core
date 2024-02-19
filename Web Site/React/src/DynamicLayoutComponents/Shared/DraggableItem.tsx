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
import React, { memo, FC, useState }                              from 'react';
import { FontAwesomeIcon }                                        from '@fortawesome/react-fontawesome';
import { useDrag, useDrop, DragSourceMonitor, DropTargetMonitor } from 'react-dnd';
// 2. Store and Types. 
import IDragItemState                                             from '../../types/IDragItemState'  ;
// 3. Scripts. 
import Sql                                                        from '../../scripts/Sql'           ;
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
	transition     : 'flex-basis 0.2s ease, order 0.2s ease',
	display        : 'flex',
	alignItems     : 'center',
	justifyContent : 'space-between',
};

interface IDraggableItemProps
{
	id                : string;
	item              : any;
	onEditClick       : (id: string) => void;
	fieldIndex        : number;
	colIndex          : number;
	rowIndex          : number;
	isDragging?       : boolean;
	didDrop?          : boolean;
	rowTotal?         : number;
	setDragging       : (id: string) => void;
	draggingId        : string;
	connectDragSource?: Function; // ConnectDragSource;
	moveDraggableItem : (id: string, hoverColIndex: number, hoverRowIndex: number, didDrop: boolean) => void;
	remove            : (item, type) => void;
}

// 12/31/2023 Paul.  react-dnd v15 requires use of hooks. 
const DraggableItem: FC<IDraggableItemProps> = memo(function DraggableItem(props: IDraggableItemProps)
{
	const { item, id, draggingId, rowTotal, fieldIndex, colIndex, rowIndex, onEditClick, moveDraggableItem, remove, setDragging } = props;
	//console.log((new Date()).toISOString() + ' ' + 'DraggableItem' + '.props', props);
	const [collect, connectDragSource, dragPreview] = useDrag
	(
		() => ({
			type: 'ITEM',
			item: (monitor: DragSourceMonitor) =>
			{
				//console.log((new Date()).toISOString() + ' ' + 'DraggableItem' + '.item/begin', props, monitor);
				return {
					id,
					fieldIndex,
					colIndex,
					rowIndex,
					origId: id
				};
			},
			collect: (monitor: DragSourceMonitor) => (
			{
				isDragging: monitor.isDragging(),
				didDrop   : monitor.didDrop()
			}),
			end: (item: IDragItemState, monitor: DragSourceMonitor) =>
			{
				//console.log((new Date()).toISOString() + ' ' + 'DraggableItem' + '.end', item, props);
				if ( monitor.didDrop() )
				{
					// 12/31/2023 Paul.  Upgrade DnD. 
					const id            : string = item.id        ;
					const hoverColIndex : number = item.colIndex  ;
					const hoverRowIndex : number = item.rowIndex  ;
					moveDraggableItem(id, hoverColIndex, hoverRowIndex, true);
				}
				else
				{
					remove(item, monitor.getItemType());
				}
				setDragging('');
			},
			canDrag: (monitor: DragSourceMonitor) =>
			{
				return true;
			},
		}),
		[id, fieldIndex, colIndex, rowIndex, moveDraggableItem, remove, setDragging],
	);
	//console.log((new Date()).toISOString() + ' ' + 'DraggableItem' + ' collected', collect);
	const [dragging, setLocalDragging] = useState(false);
	if ( dragging != collect.isDragging )
	{
		//console.log((new Date()).toISOString() + ' ' + 'DraggableItem' + ' dragging changed', collect.isDragging);
		if ( collect.isDragging )
		{
			props.setDragging(props.id);
		}
		if ( collect.didDrop )
		{
			props.setDragging('');
		}
		setLocalDragging(collect.isDragging);
	}

	const opacity = id == draggingId ? 0 : 1;
	let DATA_FIELD: string = null;
	if ( item )
	{
		if ( item.FIELD_TYPE == 'Header' )
		{
			DATA_FIELD = L10n.Term('DynamicLayout.LBL_HEADER_TYPE');
		}
		else if ( item.FIELD_TYPE == 'Blank' )
		{
			DATA_FIELD = L10n.Term('DynamicLayout.LBL_BLANK_TYPE');
		}
		else if ( item.FIELD_TYPE == 'Separator' )
		{
			DATA_FIELD = L10n.Term('DynamicLayout.LBL_SEPARATOR_TYPE');
		}
		else if ( item.FIELD_TYPE == 'Hidden' )
		{
			DATA_FIELD = L10n.Term('DynamicLayout.LBL_HIDDEN_TYPE');
		}
		else
		{
			DATA_FIELD = item.DATA_FIELD;
		}
	}
	return (
			<div ref={ (node) => connectDragSource(node) }
				className='grab'
				style={{ ...style, opacity, flexBasis: `${100 / rowTotal}%` }}
				id={ 'ctlDynamicLayout_' + id }
			>
				{ item
				? DATA_FIELD
				: null
				}
				<br />
				{ item && !Sql.IsEmptyString(item.DATA_LABEL)
				? L10n.Term(item.DATA_LABEL)
				: null
				}
				{ item && (item.FIELD_TYPE != 'Blank' && item.FIELD_TYPE != 'Separator')
				? <span style={ {cursor: 'pointer'} } onClick={ () => onEditClick(id) }>
					<FontAwesomeIcon icon="edit" size="lg" />
				</span>
				: null
				}
			</div>
	);
});

export default DraggableItem;
