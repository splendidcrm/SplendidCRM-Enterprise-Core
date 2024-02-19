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
import { RouteComponentProps } from '../Router5';

export interface ISubPanelHeaderButtonsProps extends RouteComponentProps<any>
{
	MODULE_NAME      : string;
	MODULE_TITLE?    : string;
	SUB_TITLE?       : string;
	ID?              : string;
	LINK_NAME?       : string;
	CONTROL_VIEW_NAME: string;
	error            : any;
	// Button properties
	ButtonStyle      : string;
	FrameStyle?      : any;
	ContentStyle?    : any;
	VIEW_NAME        : string;
	row              : object;
	Page_Command     : (sCommandName, sCommandArguments) => void;
	onLayoutLoaded?  : () => void;
	showButtons      : boolean;
	onToggle         : (open: boolean) => void;
	// 04/10/2021 Paul.  Create framework to allow pre-compile of all modules. 
	isPrecompile?       : boolean;
}

interface ISubPanelHeaderButtonsState
{
	helpText        : string
	archiveView     : boolean;
	streamEnabled   : boolean;
	headerError     : any;
	localKey        : string;
	open            : boolean;
}

export abstract class SubPanelHeaderButtons extends React.Component<ISubPanelHeaderButtonsProps, ISubPanelHeaderButtonsState>
{
	// 10/30/2020 Paul.  We need a busy indicator for long-running tasks such as Archive. 
	public abstract Busy         (): void;
	public abstract NotBusy      (): void;
	public abstract DisableAll   (): void;
	public abstract EnableAll    (): void;
	public abstract HideAll      (): void;
	public abstract ShowAll      (): void;
	public abstract EnableButton (COMMAND_NAME: string, enabled: boolean): void;
	public abstract ShowButton   (COMMAND_NAME: string, visible: boolean): void;
	public abstract ShowHyperLink(URL         : string, visible: boolean): void;
}

