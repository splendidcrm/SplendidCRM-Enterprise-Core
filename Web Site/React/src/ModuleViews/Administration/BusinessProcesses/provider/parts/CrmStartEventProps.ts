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

var find              = require('lodash/collection/find');
var entryFactory      = require('bpmn-js-properties-panel/lib/factory/EntryFactory');
var is                = require('bpmn-js/lib/util/ModelUtil').is;
var getBusinessObject = require('bpmn-js/lib/util/ModelUtil').getBusinessObject;

function hasEventDefinition(element, eventDefinition)
{
	var bo = getBusinessObject(element);
	return !!find(bo.eventDefinitions || [], function(definition) { return is(definition, eventDefinition); });
}

// 09/08/2021 Paul.  Include the eventBus
export default function(group, element, bpmnFactory, elementRegistry, eventBus)
{
	if ( is(element, 'bpmn:StartEvent') && !hasEventDefinition(element, 'bpmn:TimerEventDefinition') )
	{
		// C:\Web.net\SplendidCRM6\Administration\BusinessProcesses\node_modules\bpmn-js-properties-panel\lib\factory\SelectEntryFactory.js
		group.entries.push(entryFactory.selectBox(
		{ 
			id            : 'RECORD_TYPE',
			//description   : L10n.Term('BusinessProcesses.LBL_BPMN_RECORD_TYPE_DESCRIPTION'),
			label         : L10n.Term('BusinessProcesses.LBL_BPMN_RECORD_TYPE'),
			modelProperty : 'RECORD_TYPE',
			selectOptions :
			[
				{ value: 'all'   , name: L10n.Term('.workflow_record_type_dom.all'   ) },
				{ value: 'new'   , name: L10n.Term('.workflow_record_type_dom.new'   ) },
				{ value: 'update', name: L10n.Term('.workflow_record_type_dom.update') }
			]
		}));
	}
};
