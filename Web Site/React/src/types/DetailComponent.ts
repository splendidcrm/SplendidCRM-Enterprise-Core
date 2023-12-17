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
import { RouteComponentProps } from 'react-router-dom';

export interface IDetailViewProps extends RouteComponentProps<any>
{
	MODULE_NAME  : string;
	ID           : string;
	LAYOUT_NAME? : string;
	// 04/10/2021 Paul.  Create framework to allow pre-compile of all modules. 
	isPrecompile?       : boolean;
	onComponentComplete?: (MODULE_NAME, RELATED_MODULE, LAYOUT_NAME, vwMain) => void;
}

export interface IDetailComponentProps
{
	baseId        : string;
	row           : any;
	layout        : any;
	ERASED_FIELDS : string[];
	Page_Command? : Function;
	fieldDidMount?: (DATA_FIELD: string, component: any) => void;
	// 11/02/2019 Paul.  Hidden property is used to dynamically hide and show layout fields. 
	bIsHidden?    : boolean;
}

export interface IDetailComponentState
{
	ID          : string;
	FIELD_INDEX : number;
	DATA_FIELD? : string;
	DATA_VALUE? : string;
	DATA_FORMAT?: string;
	CSS_CLASS?  : string;
}

export abstract class DetailComponent<P extends IDetailComponentProps, S> extends React.Component<P, S>
{
	public abstract updateDependancy(PARENT_FIELD: string, DATA_VALUE: any, PROPERTY_NAME?: string, item?: any): void;
}

