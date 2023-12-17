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
import Sql  from '../../../../../scripts/Sql' ;
import L10n from '../../../../../scripts/L10n';

var is                = require('bpmn-js/lib/util/ModelUtil').is;
var getBusinessObject = require('bpmn-js/lib/util/ModelUtil').getBusinessObject;
var isAny             = require('bpmn-js/lib/features/modeling/util/ModelingUtil').isAny;
var cmdHelper         = require('bpmn-js-properties-panel/lib/helper/CmdHelper');
var elementHelper     = require('bpmn-js-properties-panel/lib/helper/ElementHelper');
var entryFactory      = require('bpmn-js-properties-panel/lib/factory/EntryFactory');

var CONDITIONAL_SOURCES =
[
	'bpmn:Activity',
	'bpmn:ExclusiveGateway',
	'bpmn:InclusiveGateway',
	'bpmn:ComplexGateway'
];

function isConditionalSource(element)
{
	return isAny(element, CONDITIONAL_SOURCES);
}

export default function(group, element, bpmnFactory)
{
	if ( is(element, 'bpmn:SequenceFlow') && isConditionalSource(element.source) )
	{
		//console.log('bpmn:SequenceFlow');
		// 05/10/2022 Paul.  Changed to textBox. 
		group.entries.push(entryFactory.textBox(
		{
			id            : 'condition',
			label         : L10n.Term('BusinessProcesses.LBL_BPMN_EXPRESSION'),
			modelProperty : 'condition',
			minRows       : 8,
			expandable    : true,
			get : function(element)
			{
				var bo = getBusinessObject(element);
				var conditionExpression = bo.conditionExpression;
				let values: any = {};
				if ( conditionExpression )
				{
					values.condition = conditionExpression.get('body');
				}
				return values;
			},
			set : function(element, values)
			{
				var commands = [];
				var conditionProps =
				{
					body: undefined
				};

				var condition = values.condition;
				conditionProps.body = condition;
				var update =
				{
					'conditionExpression': undefined
				};
				var bo = getBusinessObject(element);
				update.conditionExpression = elementHelper.createElement('bpmn:FormalExpression', conditionProps, bo, bpmnFactory );
				var source = element.source;
				// if default-flow, remove default-property from source
				if ( source.businessObject.default === bo )
				{
					commands.push(cmdHelper.updateProperties(source, { 'default': undefined }));
				}
				commands.push(cmdHelper.updateBusinessObject(element, bo, update));
				return commands;
			},
			validate : function(element, values)
			{
				let validationResult: any = {};
				if ( !values.condition )
				{
					validationResult.condition = 'Must provide a value';
				}
				return validationResult;
			}
		}));
	}
};

