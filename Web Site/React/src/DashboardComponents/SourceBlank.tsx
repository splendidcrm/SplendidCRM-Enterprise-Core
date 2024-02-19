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
import { uuidFast }                                               from '../scripts/utility'       ;
// 4. Components and Views. 

const style: React.CSSProperties =
{
	border         : '1px dashed grey',
	padding        : '0.5rem 1rem',
	backgroundColor: 'white',
	margin         : '0 .25em',
};

interface ISourceBlankProps
{
	TITLE               : string;
	createItemFromSource: (item: any) => any;
}

// 12/31/2023 Paul.  react-dnd v15 requires use of hooks. 
const SourceBlank: FC<ISourceBlankProps> = memo(function SourceBlank(props: ISourceBlankProps)
{
	const{ TITLE, createItemFromSource } = props;
	//console.log((new Date()).toISOString() + ' ' + 'SourceBlank' + '.props', props);
	const [collect, connectDragSource, dragPreview] = useDrag
	(
		() => ({
			type: 'ITEM',
			item: (monitor: DragSourceMonitor) =>
			{
				//console.log((new Date()).toISOString() + ' ' + 'SouceBlank' + '.item/begin', props, monitor);
				return createItemFromSource(
					{
						id               : uuidFast(),
						index            : -1,
						NAME             : '(blank)',
						CATEGORY         : null,
						MODULE_NAME      : null,
						TITLE            : '(blank)',
						SETTINGS_EDITVIEW: null,
						IS_ADMIN         : false,
						APP_ENABLED      : true,
						SCRIPT_URL       : null,
						DEFAULT_SETTINGS : null,
				});
			},
			collect: (monitor: DragSourceMonitor) => (
			{
				isDragging: monitor.isDragging()
			}),
			end: (item: IDragItemState, monitor: DragSourceMonitor) =>
			{
				//console.log((new Date()).toISOString() + ' ' + 'SouceBlank' + '.end', item, props);
			},
			canDrag: (monitor: DragSourceMonitor) =>
			{
				return true;
			},
		}),
		[createItemFromSource],
	);
	//console.log((new Date()).toISOString() + ' ' + 'SourceBlank' + ' collected', collect, dropCollect);
	return (
			<div ref={ (node) => connectDragSource(node) }
				className="grab DashboardComponents-SourceBlank"
				style={ { ...style } }>
				{ TITLE }
			</div>
	);
});

export default SourceBlank;
