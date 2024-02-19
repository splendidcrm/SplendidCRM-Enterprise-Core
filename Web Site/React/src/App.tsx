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
import * as React from 'react';
import { library }                         from '@fortawesome/fontawesome-svg-core';
import { faSync, faCog, faSpinner, faAsterisk, faFile, faSave, faEdit, faTimes, faChevronDown, faChevronUp, faChevronLeft, faChevronRight, faAngleRight, faAngleLeft, faAngleDoubleRight, faAngleDoubleLeft, faSearch, faPlus, faMinus, faMinusCircle, faQuestion, faSortDown, faAngleDoubleUp, faAngleDoubleDown, faStar, faArrowAltCircleRight, faArrowCircleRight, faCaretDown, faArrowDown, faArrowRight, faInfo, faTrashAlt, faWindowClose, faSort, faExternalLinkAlt, faCheckSquare, faCheck, faFolder, faCaretSquareUp, faCaretSquareDown, faAngleUp, faAngleDown, faArrowUp } from '@fortawesome/free-solid-svg-icons';
import { faStar as faStarRegular, faArrowAltCircleRight as faArrowAltCircleRightRegular, faEye as faEyeRegular, faFile as faFileRegular, faFolder as faFolderRegular } from '@fortawesome/free-regular-svg-icons';
import { faCopy, faPaste, faUndo, faRedo, faAlignLeft, faAlignRight, faAlignCenter, faAlignJustify, faList, faHouse, faUser, faLessThan, faGreaterThan, faFilter, faXmark, faFileExport } from '@fortawesome/free-solid-svg-icons';
import { observer, inject }                from 'mobx-react'                       ;
import { DndProvider }                     from 'react-dnd'                        ;
import { TouchBackend }                    from 'react-dnd-touch-backend'          ;
import { HTML5Backend }                    from 'react-dnd-html5-backend'          ;
// 2. Store and Types. 
// 3. Scripts. 
import { isTouchDevice }                   from './scripts/utility'                ;
import SignalRStore                        from './SignalR/SignalRStore'           ;
import SignalRCoreStore                    from './SignalR/SignalRCoreStore'       ;
// 4. Components and Views. 

const isMobile   = isTouchDevice();
// https://react-dnd.github.io/react-dnd/docs/tutorial
const DnDBackend = isMobile ? TouchBackend : HTML5Backend;

interface IAppProps
{
	// 01/15/2024 Paul.  children is not longer automatically included. 
	children?: React.ReactNode;
}

interface IAppState
{
}

// https://github.com/react-dnd/react-dnd/issues/1424
//@DragDropContext(HTML5Backend)
@observer
export default class App extends React.Component<IAppProps, IAppState>
{
	constructor(props: IAppProps)
	{
		super(props);
		//console.log(this.constructor.name + '.constructor', props);
		library.add(faSync, faCog, faSpinner, faAsterisk, faFile, faSave, faEdit, faTimes, faChevronDown, faChevronUp, faChevronLeft, faChevronRight, faAngleRight, faAngleLeft, faAngleDoubleRight, faAngleDoubleLeft, faSearch, faPlus, faMinus, faMinusCircle, faQuestion, faSortDown, faAngleDoubleUp, faAngleDoubleDown, faStar, faArrowAltCircleRight, faArrowCircleRight, faCaretDown, faArrowDown, faArrowRight, faInfo, faWindowClose, faSort, faExternalLinkAlt, faCheckSquare, faCheck, faFolder, faCaretSquareUp, faCaretSquareDown, faAngleUp, faAngleDown, faArrowUp);
		library.add(faStarRegular, faArrowAltCircleRightRegular, faEyeRegular, faTrashAlt, faFileRegular, faFolderRegular);
		library.add(faCopy, faPaste, faUndo, faRedo, faAlignLeft, faAlignRight, faAlignCenter, faAlignJustify, faList, faHouse, faUser, faLessThan, faGreaterThan, faFilter, faXmark, faFileExport);
		
		this.state = 
		{
		};
	}

	async componentDidMount()
	{
		//console.log(this.constructor.name + '.componentDidMount', window.history);
		SignalRStore.SetHistory(window.history);
		// 06/19/2023 Paul.  Separate implementation for SignalR on ASP.NET Core. 
		SignalRCoreStore.SetHistory(window.history);
	}

	public render()
	{
		const { children } = this.props;
		//console.log((new Date()).toISOString() + ' ' + 'App.render', children);
		// 01/27/2024 Paul.  Move top menu code to PrivateRoute as it must be under Route. 
		return (
			<DndProvider backend = {DnDBackend as any}>
				{ children }
			</DndProvider>
		);
	}
}

