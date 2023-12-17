var assign            = require('lodash/object/assign'                           );
var forEach           = require('lodash/collection/forEach'                      );
var isArray           = require('lodash/lang/isArray'                            );
var is                = require('bpmn-js/lib/util/ModelUtil'                     ).is;
var isExpanded        = require('bpmn-js/lib/util/DiUtil'                        ).isExpanded;
var isAny             = require('bpmn-js/lib/features/modeling/util/ModelingUtil').isAny;
var getChildLanes     = require('bpmn-js/lib/features/modeling/util/LaneUtil'    ).getChildLanes;
var isEventSubProcess = require('bpmn-js/lib/util/DiUtil'                        ).isEventSubProcess;

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
function ContextPadProvider(contextPad, modeling, elementFactory, connect, create, popupMenu, canvas, rules, translate)
{
	contextPad.registerProvider(this);

	this._contextPad     = contextPad;
	this._modeling       = modeling;
	this._elementFactory = elementFactory;
	this._connect        = connect;
	this._create         = create;
	this._popupMenu      = popupMenu;
	this._canvas         = canvas;
	this._rules          = rules;
	this._translate      = translate;
}

ContextPadProvider.$inject =
[
	'contextPad',
	'modeling',
	'elementFactory',
	'connect',
	'create',
	'popupMenu',
	'canvas',
	'rules',
	'translate'
];

export default ContextPadProvider;


ContextPadProvider.prototype.getContextPadEntries = function(element)
{
	var contextPad     = this._contextPad;
	var modeling       = this._modeling;
	var elementFactory = this._elementFactory;
	var connect        = this._connect;
	var create         = this._create;
	var popupMenu      = this._popupMenu;
	var canvas         = this._canvas;
	var rules          = this._rules;
	var translate      = this._translate;

	var actions = {};

	if (element.type === 'label')
	{
		return actions;
	}

	var businessObject = element.businessObject;

	function startConnect(event, element, autoActivate)
	{
		connect.start(event, element, autoActivate);
	}

	function removeElement(e)
	{
		modeling.removeElements([ element ]);
	}

	function getReplaceMenuPosition(element)
	{
		var Y_OFFSET         = 5;
		var diagramContainer = canvas.getContainer();
		var pad              = contextPad.getPad(element).html;
		var diagramRect      = diagramContainer.getBoundingClientRect();
		var padRect          = pad.getBoundingClientRect();
		var top              = padRect.top  - diagramRect.top ;
		var left             = padRect.left - diagramRect.left;

		var pos =
		{
			x: left,
			y: top + padRect.height + Y_OFFSET
		};
		return pos;
	}


	/**
	 * Create an append action
	 *
	 * @param {String} type
	 * @param {String} className
	 * @param {String} [title]
	 * @param {Object} [options]
	 *
	 * @return {Object} descriptor
	 */
	function appendAction(type, className, title?, options?)
	{
		if ( typeof title !== 'string' )
		{
			options = title;
			title = translate('Append {type}', { type: type.replace(/^bpmn\:/, '') });
		}

		function appendListener(event, element)
		{
			var shape = elementFactory.createShape(assign({ type: type }, options));
			create.start(event, shape, element);
		}

		return {
			group: 'model',
			className: className,
			title: title,
			action:
			{
				dragstart: appendListener,
				click: appendListener
			}
		};
	}

	function splitLaneHandler(count)
	{
		return function(event, element) {
			// actual split
			modeling.splitLane(element, count);
			// refresh context pad after split to
			// get rid of split icons
			contextPad.open(element, true);
		};
	}

	if ( isAny(businessObject, [ 'bpmn:Lane', 'bpmn:Participant' ]) && isExpanded(businessObject) )
	{
		var childLanes = getChildLanes(element);
		assign(actions,
		{
			'lane-insert-above':
			{
				group: 'lane-insert-above',
				className: 'bpmn-icon-lane-insert-above',
				title: translate('Add Lane above'),
				action:
				{
					click: function(event, element)
					{
						modeling.addLane(element, 'top');
					}
				}
			}
		});

		if ( childLanes.length < 2 )
		{
			if ( element.height >= 120 )
			{
				assign(actions,
				{
					'lane-divide-two':
					{
						group: 'lane-divide',
						className: 'bpmn-icon-lane-divide-two',
						title: translate('Divide into two Lanes'),
						action:
						{
							click: splitLaneHandler(2)
						}
					}
				});
			}
			if ( element.height >= 180 )
			{
				assign(actions,
				{
					'lane-divide-three':
					{
						group: 'lane-divide',
						className: 'bpmn-icon-lane-divide-three',
						title: translate('Divide into three Lanes'),
						action:
						{
							click: splitLaneHandler(3)
						}
					}
				});
			}
		}

		assign(actions,
		{
			'lane-insert-below':
			{
				group: 'lane-insert-below',
				className: 'bpmn-icon-lane-insert-below',
				title: translate('Add Lane below'),
				action:
				{
					click: function(event, element)
					{
						modeling.addLane(element, 'bottom');
					}
				}
			}
		});

	}

	if ( is(businessObject, 'bpmn:FlowNode') )
	{
		if ( is(businessObject, 'bpmn:EventBasedGateway') )
		{
			assign(actions,
			{
				'append.user-task'                  : appendAction('bpmn:UserTask'              , 'bpmn-icon-user'),
				//'append.receive-task'               : appendAction('bpmn:ReceiveTask'           , 'bpmn-icon-receive-task'),
				//'append.message-intermediate-event' : appendAction('bpmn:IntermediateCatchEvent', 'bpmn-icon-intermediate-event-catch-message'  , { eventDefinitionType: 'bpmn:MessageEventDefinition'    }),
				//'append.condtion-intermediate-event': appendAction('bpmn:IntermediateCatchEvent', 'bpmn-icon-intermediate-event-catch-condition', { eventDefinitionType: 'bpmn:ConditionalEventDefinition'}),
				//'append.signal-intermediate-event'  : appendAction('bpmn:IntermediateCatchEvent', 'bpmn-icon-intermediate-event-catch-signal'   , { eventDefinitionType: 'bpmn:SignalEventDefinition'     })
				'append.timer-intermediate-event'   : appendAction('bpmn:IntermediateCatchEvent', 'bpmn-icon-intermediate-event-catch-timer'    , { eventDefinitionType: 'bpmn:TimerEventDefinition'      }),
				'append.business-rule-task'         : appendAction('bpmn:BusinessRuleTask'      , 'bpmn-icon-business-rule'),
			});
		}
		else if ( isEventType(businessObject, 'bpmn:BoundaryEvent', 'bpmn:CompensateEventDefinition') )
		{
			assign(actions,
			{
				'append.compensation-activity': appendAction('bpmn:Task', 'bpmn-icon-task', translate('Append compensation activity'), { isForCompensation: true })
			});
		}
		else if (  !is(businessObject, 'bpmn:EndEvent')
		        && !businessObject.isForCompensation
		        && !isEventType(businessObject, 'bpmn:IntermediateThrowEvent', 'bpmn:LinkEventDefinition')
		        && !isEventSubProcess(businessObject) )
		{
			assign(actions,
			{
				'append.end-event'         : appendAction('bpmn:EndEvent', 'bpmn-icon-end-event-none'),
				'append.gateway'           : appendAction('bpmn:ExclusiveGateway', 'bpmn-icon-gateway-xor'),
				'append.append-task'       : appendAction('bpmn:Task', 'bpmn-icon-task'),
				//'append.intermediate-event': appendAction('bpmn:IntermediateThrowEvent', 'bpmn-icon-intermediate-event-none')
			});
		}
	}

	var replaceMenu;

	if ( popupMenu._providers['bpmn-replace'] )
	{
		replaceMenu = popupMenu.create('bpmn-replace', element);
	}

	if ( replaceMenu && !replaceMenu.isEmpty() )
	{
		// Replace menu entry
		assign(actions,
		{
			'replace':
			{
				group: 'edit',
				className: 'bpmn-icon-screw-wrench',
				title: translate('Change type'),
				action:
				{
					click: function(event, element)
					{
						replaceMenu.open(assign(getReplaceMenuPosition(element),
						{
							cursor: { x: event.x, y: event.y }
						}), element);
					}
				}
			}
		});
	}

	if ( isAny(businessObject, [ 'bpmn:FlowNode', 'bpmn:InteractionNode', 'bpmn:DataObjectReference', 'bpmn:DataStoreReference' ]) )
	{
		assign(actions,
		{
			'append.text-annotation': appendAction('bpmn:TextAnnotation', 'bpmn-icon-text-annotation'),
			'connect':
			{
				group: 'connect',
				className: 'bpmn-icon-connection-multi',
				title: translate('Connect using ' + (businessObject.isForCompensation ? '' : 'Sequence/MessageFlow or ') + 'Association'),
				action:
				{
					click: startConnect,
					dragstart: startConnect
				}
			}
		});
	}

	if ( isAny(businessObject, ['bpmn:DataObjectReference', 'bpmn:DataStoreReference']) )
	{
		assign(actions,
		{
			'connect':
			{
				group: 'connect',
				className: 'bpmn-icon-connection-multi',
				title: translate('Connect using DataInputAssociation'),
				action:
				{
					click: startConnect,
					dragstart: startConnect
				}
			}
		});
	}

	// delete element entry, only show if allowed by rules
	var deleteAllowed = rules.allowed('elements.delete', { elements: [ element ] });

	if ( isArray(deleteAllowed) )
	{
		// was the element returned as a deletion candidate?
		deleteAllowed = deleteAllowed[0] === element;
	}
	if ( deleteAllowed )
	{
		assign(actions,
		{
			'delete':
			{
				group: 'edit',
				className: 'bpmn-icon-trash',
				title: translate('Remove'),
				action:
				{
					click: removeElement,
					dragstart: removeElement
				}
			}
		});
	}
	return actions;
};

function isEventType(eventBo, type, definition)
{
	var isType = eventBo.$instanceOf(type);
	var isDefinition = false;

	var definitions = eventBo.eventDefinitions || [];
	forEach( definitions, function(def)
	{
		if ( def.$type === definition )
		{
			isDefinition = true;
		}
	});
	return isType && isDefinition;
}
