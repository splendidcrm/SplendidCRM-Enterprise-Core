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
// 2. Store and Types. 
// 3. Scripts. 
import Sql                                          from '../../../scripts/Sql'            ;
import { CreateSplendidRequest, GetSplendidResult } from '../../../scripts/SplendidRequest';
// 4. Components and Views. 

interface IRecompileProgressBarProps
{
}

interface IRecompileProgressBarState
{
	nProgress  : number;
	nTotal     : number;
	sStatusText: string;
}

export default class RecompileProgressBar extends React.Component<IRecompileProgressBarProps, IRecompileProgressBarState>
{
	constructor(props: IRecompileProgressBarProps)
	{
		super(props);
		this.state =
		{
			nProgress  : 0,
			nTotal     : 0,
			sStatusText: null,
		};
	}

	async componentDidMount()
	{
		this.UpdateStatus();
	}

	private UpdateStatus()
	{
		try
		{
			CreateSplendidRequest('Administration/Rest.svc/GetRecompileStatus', 'GET').then((res) =>
			{
				GetSplendidResult(res).then((json) =>
				{
					//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.UpdateStatus', json);
			
					let nTotal     : number = 0;
					let nProgress  : number = 0;
					let sStatusText: string = '';
					let oStatus    : any    = json.d;
					if ( oStatus != null )
					{
						nTotal       = Sql.ToInteger(oStatus.TotalPasses) * Sql.ToInteger(oStatus.TotalViews);
						nProgress    = Sql.ToInteger(oStatus.CurrentPass) * Sql.ToInteger(oStatus.TotalViews) + Sql.ToInteger(oStatus.CurrentView);
						sStatusText  = oStatus.StartDate + ', Pass ' + oStatus.CurrentPass + ' of ' + oStatus.TotalPasses + ', ' + oStatus.RemainingSeconds + ' seconds remaining, ' + oStatus.CurrentViewName + '. ';
						setTimeout(() =>
						{
							this.UpdateStatus();
						}, 1000);
					}
					this.setState(
					{
						nProgress  ,
						nTotal     ,
						sStatusText,
					});
				})
				.catch((error) =>
				{
					console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
				});
			})
			.catch((error) =>
			{
				console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
			});
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
		}
	}

	public render()
	{
		const { nProgress, nTotal, sStatusText } = this.state;
		if ( nTotal > 0 )
		{
			let sProgress: string = '';
			let n = Math.round(100 * nProgress / nTotal);
			if ( n >= 100 )
				n = 99;
			sProgress = n.toString() + '%';
			return (
<div id='divProgressPanel'>
	<div id='divSplendidUI_ProgressBarFrame' style={ {margin: '4px', padding: '2px', border: '1px solid rgb(204, 204, 204)', backgroundColor: 'rgb(255, 255, 255)'} }>
		<div id='divSplendidUI_ProgressStatusText'>
			{ sStatusText }
		</div>
		<table id='tblSplendidUI_ProgressBar' cellSpacing={ 0 } style={ {width: sProgress, backgroundColor: 'rgb(0, 0, 0)'} }>
			<tbody className='SplendidProgressBar'>
				<tr>
					<td align='center' style={ {padding: '2px', color: 'rgb(255, 255, 255)', fontSize: '12px', fontStyle: 'normal', fontWeight: 'normal', textDecoration: 'none'} }>
						<div id='divSplendidUI_ProgressBarText'>
							{ sProgress }
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
			);
		}
		else
		{
			return null;
		}
	}
}

