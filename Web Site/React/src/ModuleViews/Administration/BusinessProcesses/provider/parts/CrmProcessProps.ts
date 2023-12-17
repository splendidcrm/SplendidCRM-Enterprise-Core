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

var entryFactory          = require('bpmn-js-properties-panel/lib/factory/EntryFactory');
var cmdHelper             = require('bpmn-js-properties-panel/lib/helper/CmdHelper');
var getBusinessObject     = require('bpmn-js/lib/util/ModelUtil').getBusinessObject;
var is                    = require('bpmn-js/lib/util/ModelUtil').is;
import popupEntryFactory  from './factory/ModulePopupEntryFactory';

function ensureNotNull(prop)
{
	if ( !prop )
	{
		throw new Error(prop + ' must be set.');
	}
	return prop;
}

// 09/08/2021 Paul.  Include the eventBus
export default function(group, element, bpmnFactory, elementRegistry, eventBus)
{
	if ( is(element, 'bpmn:Process') )
	{
		// 07/06/2016 Paul.  Override the default Name property and make it required. 
		for ( var i = 0; i < group.entries.length; i++ )
		{
			var option = group.entries[i];
			if ( option.id == 'name' )
			{
				option.validate = function(element)
				{
					var value = this.get(element)[this.id];
					if ( Sql.ToString(value) == '' )
					{
						var err = new Object();
						err[this.id] = L10n.Term('.ERR_REQUIRED_FIELD');
						return err;
					}
				};
				break;
			}
		}
		// C:\Web.net\SplendidCRM6\Administration\BusinessProcesses\node_modules\bpmn-js-properties-panel\lib\factory\SelectEntryFactory.js
		group.entries.push(entryFactory.selectBox(
		{
			id            : 'PROCESS_STATUS',
			//description   : L10n.Term('BusinessProcesses.LBL_BPMN_PROCESS_STATUS_DESCRIPTION'),
			label         : L10n.Term('BusinessProcesses.LBL_BPMN_PROCESS_STATUS'),
			modelProperty : 'PROCESS_STATUS',
			selectOptions :
			[
				// 07/30/2016 Paul.  Make the default false so that the process needs to be manually activated. 
				{ value: 'false', name: L10n.Term('.workflow_status_dom.False') },
				{ value: 'true' , name: L10n.Term('.workflow_status_dom.True' ) }
			],
			get : function (element)
			{
				var businessObject = getBusinessObject(element);
				var res = {};
				var prop = ensureNotNull(this.id);
				res[prop] = businessObject.get(prop);
				//console.log('CrmProcessProps get ' + prop + ' = ' + res[prop]);
				// 07/06/2016 Paul.  Would like a way to set the default value to the schema. 
				//if ( res[prop] === undefined )
				//{
				//	res[prop] = 'false';
				//	businessObject.set(prop, res[prop]);
				//}
				return res;
			}
		}));

		// 09/08/2021 Paul.  Include the eventBus
		group.entries.push(popupEntryFactory(
		{
			id            : 'PROCESS_USER_',
			label         : L10n.Term('BusinessProcesses.LBL_BPMN_PROCESS_USER'),
			modelProperty : 'PROCESS_USER_',
			module        : 'Users',
			get: function(element, node)
			{
				var values = {};
				if ( node !== undefined )
				{
					var businessObject = getBusinessObject(element);
					values[this.modelProperty + 'ID'  ] = businessObject.get(this.modelProperty + 'ID'  );
					values[this.modelProperty + 'NAME'] = businessObject.get(this.modelProperty + 'NAME');
				}
				return values;
			},
			set: function(element, values, node)
			{
				var res = {};
				if ( node !== undefined )
				{
					res[this.modelProperty + 'ID'  ] = values[this.modelProperty + 'ID'  ];
					res[this.modelProperty + 'NAME'] = values[this.modelProperty + 'NAME'];
				}
				return cmdHelper.updateProperties(element, res);
			},
			validate : function(element)
			{
				return [];
			}
		}, element, bpmnFactory, eventBus));
	}
};
