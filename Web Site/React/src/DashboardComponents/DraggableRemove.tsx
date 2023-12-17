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

import React from 'react';
import { FontAwesomeIcon }                       from '@fortawesome/react-fontawesome';
import { DropTarget, DropTargetConnector, DropTargetMonitor, ConnectDropTarget } from 'react-dnd';

interface IDraggableRemoveProps
{
	isOver?           : boolean
	connectDropTarget?: ConnectDropTarget;
	remove            : (item, type) => void;
}

const boxTarget =
{
	drop(props: IDraggableRemoveProps, monitor: DropTargetMonitor)
	{
		//console.log((new Date()).toISOString() + ' ' + 'DraggableRemove' + '.drop', props);
		props.remove(monitor.getItem(), monitor.getItemType());
	}
};

function collect(connect: DropTargetConnector, monitor: DropTargetMonitor)
{
	//console.log((new Date()).toISOString() + ' ' + 'DraggableRemove' + '.collect', connect, monitor);
	return {
		connectDropTarget: connect.dropTarget(),
		isOver           : monitor.isOver(),
	};
}

class DraggableRemove extends React.Component<IDraggableRemoveProps>
{
	public render()
	{
		const { isOver, connectDropTarget } = this.props
		return (
			connectDropTarget &&
			connectDropTarget(
				<div
					style={{ padding: '1em 0', display: 'inline-block' }}>
					<FontAwesomeIcon icon='trash-alt' size='4x' />
				</div>
			)
		);
	}
}

export default DropTarget(['ITEM', 'ROW'], boxTarget, collect)(DraggableRemove);
