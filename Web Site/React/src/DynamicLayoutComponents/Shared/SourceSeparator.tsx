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
import { uuidFast }                           from '../../scripts/utility'            ;

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
	connectDragSource?  : Function; // ConnectDragSource;
	moveDraggableItem   : (id: string, hoverColIndex: number, hoverRowIndex: number, didDrop: boolean) => void;
	remove              : (item, type) => void;
}

const source =
{
	beginDrag(props: ISourceSeparatorProps)
	{
		//console.log((new Date()).toISOString() + ' ' + 'SourceSeparator' + '.beginDrag', props);
		let obj: any     = {};
		obj.id           = uuidFast() ;
		obj.index        = -1         ;
		obj.ID           = null       ;
		obj.FIELD_TYPE   = 'Separator';
		obj.DATA_LABEL   = null       ;
		obj.DATA_FIELD   = null       ;
		obj.DATA_FORMAT  = null       ;
		obj.URL_FIELD    = null       ;
		obj.URL_FORMAT   = null       ;
		obj.URL_TARGET   = null       ;
		obj.MODULE_TYPE  = null       ;
		obj.LIST_NAME    = null       ;
		obj.COLSPAN      = null       ;
		obj.TOOL_TIP     = null       ;
		obj.PARENT_FIELD = null       ;
		return props.createItemFromSource(obj);
	},
	endDrag(props: ISourceSeparatorProps, monitor: DragSourceMonitor)
	{
		//console.log((new Date()).toISOString() + ' ' + 'SourceSeparator' + '.endDrag', props, monitor.getItem());
		if ( monitor.didDrop() )
		{
			const id           : string = monitor.getItem().id        ;
			const hoverColIndex: number = monitor.getItem().colIndex  ;
			const hoverRowIndex: number = monitor.getItem().rowIndex  ;
			props.moveDraggableItem(id, hoverColIndex, hoverRowIndex, true);
		}
		else
		{
			// 03/14/2020 Paul.  We need to remove the ghost item created above. 
			props.remove(monitor.getItem(), 'ITEM');
		}
	}
};

function collect(connect: DragSourceConnector, monitor: DragSourceMonitor)
{
	//console.log((new Date()).toISOString() + ' ' + 'SourceSeparator' + '.collect', connect, monitor);
	return {
		connectDragSource: connect.dragSource()
	};
}

class SourceSeparator extends React.Component<ISourceSeparatorProps>
{
	constructor(props: ISourceSeparatorProps)
	{
		super(props);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor', props);
	}

	public render()
	{
		const{ TITLE } = this.props;
		return (
			this.props.connectDragSource &&
			this.props.connectDragSource(
				<div style={ { ...style } } className='grab'>
					{ TITLE }
				</div>
			)
		);
	}
}

export default DragSource('ITEM', source, collect)(SourceSeparator);
