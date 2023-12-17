import L10n from '../../../../scripts/L10n';
var assign = require( 'lodash/object/assign' );

/**********************************************************************************************************************
 * SplendidCRM is a Customer Relationship Management program created by SplendidCRM Software, Inc. 
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Enterprise Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 * SplendidCRM owns all proprietary rights, including all copyrights, patents, trade secrets, and 
 * trademarks, in and to the contents of this file.  You will not link to or in any way combine the 
 * contents of this file or any derivatives with any Open Source Code in any manner that would require 
 * the contents of this file to be made available to any third party. 
 * 
 * IN NO EVENT SHALL SPLENDIDCRM BE RESPONSIBLE FOR ANY DAMAGES OF ANY KIND, INCLUDING ANY DIRECT, 
 * SPECIAL, PUNITIVE, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES.  Other limitations of liability 
 * and disclaimers set forth in the License. 
 * 
 *********************************************************************************************************************/
function PaletteProvider( palette, create, elementFactory, spaceTool, lassoTool, handTool, globalConnect, translate )
{
	this._palette = palette;
	this._create = create;
	this._elementFactory = elementFactory;
	this._spaceTool = spaceTool;
	this._lassoTool = lassoTool;
	this._handTool = handTool;
	this._globalConnect = globalConnect;
	this._translate = translate;

	palette.registerProvider( this );
}

export default PaletteProvider;

PaletteProvider.$inject = 
[
	'palette',
	'create',
	'elementFactory',
	'spaceTool',
	'lassoTool',
	'handTool',
	'globalConnect',
	'translate'
];


PaletteProvider.prototype.getPaletteEntries = function ( element )
{
	var actions = {};
	var create = this._create;
	var elementFactory = this._elementFactory;
	var spaceTool = this._spaceTool;
	var lassoTool = this._lassoTool;
	var handTool = this._handTool;
	var globalConnect = this._globalConnect;
	var translate = this._translate;

	function createAction( type, group, className, title, options? )
	{
		function createListener( event )
		{
			var shape = elementFactory.createShape( assign( { type: type }, options ) );
			if ( options )
			{
				shape.businessObject.di.isExpanded = options.isExpanded;
			}
			create.start( event, shape );
		}

		var shortType = type.replace( /^bpmn\:/, '' );
		var action =
		{
			group: group,
			className: className,
			title: title || translate( 'Create {type}', { type: shortType } ),
			action:
			{
				dragstart: createListener,
				click: createListener
			}
		};
		return action;
	}

	function createParticipant( event, collapsed )
	{
		create.start( event, elementFactory.createParticipantShape( collapsed ) );
	}
	
	assign( actions, 
	{
		'hand-tool': 
		{
			group: 'tools',
			className: 'bpmn-icon-hand-tool',
			title: translate( 'Activate the hand tool' ),
			action:
			{
				click: function ( event )
				{
					handTool.activateHand( event );
				}
			}
		},
		'lasso-tool': 
		{
			group: 'tools',
			className: 'bpmn-icon-lasso-tool',
			title: translate( 'Activate the lasso tool' ),
			action:
			{
				click: function ( event )
				{
					lassoTool.activateSelection( event );
				}
			}
		},
		'space-tool': 
		{
			group: 'tools',
			className: 'bpmn-icon-space-tool',
			title: translate( 'Activate the create/remove space tool' ),
			action:
			{
				click: function ( event )
				{
					spaceTool.activateSelection( event );
				}
			}
		},
		'global-connect-tool': 
		{
			group: 'tools',
			className: 'bpmn-icon-connection-multi',
			title: translate( 'Activate the global connect tool' ),
			action:
			{
				click: function ( event )
				{
					globalConnect.toggle( event );
				}
			}
		},
		'tool-separator': 
		{
			group: 'tools',
			separator: true
		},
		// C:\Web.net\SplendidCRM6\Administration\BusinessProcesses\node_modules\bpmn-js\lib\features\context-pad\ContextPadProvider.js
		'create.start-event'                  : createAction('bpmn:StartEvent'            , 'event'      , 'bpmn-icon-start-event-none'                   , L10n.Term('BusinessProcesses.LBL_BPMN_PALETTE_START_EVENT'             )  ),
		'create.start-timer-event'            : createAction('bpmn:StartEvent'            , 'event'      , 'bpmn-icon-start-event-timer'                  , L10n.Term('BusinessProcesses.LBL_BPMN_PALETTE_TIMER_START_EVENT'       ), { eventDefinitionType: 'bpmn:TimerEventDefinition'      }),
		//'create.intermediate-event'           : createAction('bpmn:IntermediateThrowEvent', 'event'      , 'bpmn-icon-intermediate-event-none'            , L10n.Term('BusinessProcesses.LBL_BPMN_PALETTE_INTERMEDIATE_THROW_EVENT')  ),
		'create.message-intermediate-event'   : createAction('bpmn:IntermediateThrowEvent', 'event'      , 'bpmn-icon-intermediate-event-throw-message'   , L10n.Term('BusinessProcesses.LBL_BPMN_PALETTE_MESSAGE_EVENT'           ), { eventDefinitionType: 'bpmn:MessageEventDefinition'    }),
		//'create.escalation-intermediate-event': createAction('bpmn:IntermediateThrowEvent', 'event'      , 'bpmn-icon-intermediate-event-throw-escalation', L10n.Term('BusinessProcesses.LBL_BPMN_PALETTE_ESCALATION_EVENT'        ), { eventDefinitionType: 'bpmn:EscalationEventDefinition' }),
		'create.timer-event'                  : createAction('bpmn:IntermediateCatchEvent', 'event'      , 'bpmn-icon-intermediate-event-catch-timer'     , L10n.Term('BusinessProcesses.LBL_BPMN_PALETTE_TIMER_EVENT'             ), { eventDefinitionType: 'bpmn:TimerEventDefinition'      }),
		'create.exclusive-gateway'            : createAction('bpmn:ExclusiveGateway'      , 'gateway'    , 'bpmn-icon-gateway-xor'                        , L10n.Term('BusinessProcesses.LBL_BPMN_PALETTE_EXCLUSIVE_GATEWAY'       )  ),
		'create.event-gateway'                : createAction('bpmn:EventBasedGateway'     , 'gateway'    , 'bpmn-icon-gateway-eventbased'                 , L10n.Term('BusinessProcesses.LBL_BPMN_PALETTE_EVENT_BASED_GATEWAY'     )  ),
		'create.task'                         : createAction('bpmn:Task'                  , 'activity'   , 'bpmn-icon-task'                               , L10n.Term('BusinessProcesses.LBL_BPMN_PALETTE_TASK'                    )  ),
		'create.user-task'                    : createAction('bpmn:UserTask'              , 'activity'   , 'bpmn-icon-user'                               , L10n.Term('BusinessProcesses.LBL_BPMN_PALETTE_USER_TASK'               )  ),
		'create.business-rule-task'           : createAction('bpmn:BusinessRuleTask'      , 'activity'   , 'bpmn-icon-business-rule'                      , L10n.Term('BusinessProcesses.LBL_BPMN_PALETTE_BUSINESS_RULE_TASK'      )  ),
		'create.end-event'                    : createAction('bpmn:EndEvent'              , 'event'      , 'bpmn-icon-end-event-none'                     , L10n.Term('BusinessProcesses.LBL_BPMN_PALETTE_END_EVENT'               )  ),
		'create.message-end-event'            : createAction('bpmn:EndEvent'              , 'event'      , 'bpmn-icon-end-event-message'                  , L10n.Term('BusinessProcesses.LBL_BPMN_PALETTE_MESSAGE_END_EVENT'       ), { eventDefinitionType: 'bpmn:MessageEventDefinition'    }),
		//'create.data-object'        : createAction('bpmn:DataObjectReference'   , 'data-object', 'bpmn-icon-data-object'     ),
		//'create.data-store'         : createAction('bpmn:DataStoreReference'    , 'data-store' , 'bpmn-icon-data-store'      ),
		//'create.subprocess-expanded': createAction('bpmn:SubProcess'            , 'activity'   , 'bpmn-icon-subprocess-expanded', translate( 'Create expanded SubProcess' ), { isExpanded: true }),
		/*
		'create.participant-expanded':
		{
			group: 'collaboration',
			className: 'bpmn-icon-participant',
			title: translate( 'Create Pool/Participant' ),
			action:
			{
				dragstart: createParticipant,
				click: createParticipant
			}
		}
		*/
	});
	return actions;
};
