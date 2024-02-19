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
// 2. Store and Types. 
import DYNAMIC_BUTTON          from '../types/DYNAMIC_BUTTON'     ;
// 3. Scripts. 
// 4. Components and Views. 
import DynamicButtons          from '../components/DynamicButtons';

export interface IHeaderButtonsProps extends RouteComponentProps<any>
{
	MODULE_NAME     : string;
	MODULE_TITLE?   : string;
	SUB_TITLE?      : any;  // 12/13/2019 Paul.  Sub Title might be a data privacy pill. 
	ID?             : string;
	LINK_NAME?      : string;
	showRequired?   : boolean;
	enableFavorites?: boolean;
	enableHelp?     : boolean;
	helpName?       : string;
	error           : any;
	// Button properties
	ButtonStyle     : string;
	FrameStyle?     : any;
	ContentStyle?   : any;
	VIEW_NAME       : string;
	row             : object;
	Page_Command    : (sCommandName, sCommandArguments) => void;
	onLayoutLoaded? : () => void;
	// 07/02/2020 Paul.  Provide a way to override the default ButtonLink behavior. 
	onButtonLink?   : (lay: DYNAMIC_BUTTON) => void;
	showButtons     : boolean;
	showProcess?    : boolean;
	hideTitle?      : boolean;
}

interface IHeaderButtonsState
{
	helpText        : string
	archiveView     : boolean;
	streamEnabled   : boolean;
	headerError     : any;
	localKey        : string;
	helpOpen        : boolean;
}

export abstract class HeaderButtons extends React.Component<IHeaderButtonsProps, IHeaderButtonsState>
{
	// 01/08/2020 Paul.  Separate reference to link buttons. 
	protected dynamicButtons     = React.createRef<DynamicButtons>();
	protected dynamicLinkButtons = React.createRef<DynamicButtons>();

	// 10/30/2020 Paul.  We need a busy indicator for long-running tasks such as Archive. 
	public Busy = (): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.Busy();
		}
		if ( this.dynamicLinkButtons.current != null )
		{
			this.dynamicLinkButtons.current.DisableAll();
		}
	}

	public NotBusy = (): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.NotBusy();
		}
		if ( this.dynamicLinkButtons.current != null )
		{
			this.dynamicLinkButtons.current.EnableAll();
		}
	}

	// 01/08/2020 Paul.  No need for the following to be abstract as they are identical across all derived header classes. 
	public DisableAll = (): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.DisableAll();
		}
		if ( this.dynamicLinkButtons.current != null )
		{
			this.dynamicLinkButtons.current.DisableAll();
		}
	}

	public EnableAll = (): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.EnableAll();
		}
		if ( this.dynamicLinkButtons.current != null )
		{
			this.dynamicLinkButtons.current.EnableAll();
		}
	}

	public HideAll = (): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.HideAll();
		}
		if ( this.dynamicLinkButtons.current != null )
		{
			this.dynamicLinkButtons.current.HideAll();
		}
	}

	public ShowAll = (): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.ShowAll();
		}
		if ( this.dynamicLinkButtons.current != null )
		{
			this.dynamicLinkButtons.current.ShowAll();
		}
	}

	public EnableButton = (COMMAND_NAME: string, enabled: boolean): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.EnableButton(COMMAND_NAME, enabled);
		}
		if ( this.dynamicLinkButtons.current != null )
		{
			this.dynamicLinkButtons.current.EnableButton(COMMAND_NAME, enabled);
		}
	}

	public ShowButton = (COMMAND_NAME: string, visible: boolean): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.ShowButton(COMMAND_NAME, visible);
		}
		if ( this.dynamicLinkButtons.current != null )
		{
			this.dynamicLinkButtons.current.ShowButton(COMMAND_NAME, visible);
		}
	}

	public ShowHyperLink = (URL: string, visible: boolean): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.ShowHyperLink(URL, visible);
		}
		if ( this.dynamicLinkButtons.current != null )
		{
			this.dynamicLinkButtons.current.ShowHyperLink(URL, visible);
		}
	}

	// 04/05/2021 Paul.  DataPrivacy module needs to set the button class. 
	public SetControlClass = (COMMAND_NAME: string, CONTROL_CSSCLASS: string): void =>
	{
		if ( this.dynamicButtons.current != null )
		{
			this.dynamicButtons.current.SetControlClass(COMMAND_NAME, CONTROL_CSSCLASS);
		}
		if ( this.dynamicLinkButtons.current != null )
		{
			this.dynamicLinkButtons.current.SetControlClass(COMMAND_NAME, CONTROL_CSSCLASS);
		}
	}

}

