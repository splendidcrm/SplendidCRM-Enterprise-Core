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
 *********************************************************************************************************************/
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
/*
1. Define Condition for Workflow Execution 
	-- TYPE
	compare_specific     : When a field in the target module changes to or from a specified value  
	trigger_record_change: When the target module changes             (hidden when trigger_record_change already exists)
	compare_change       : When a field on the target module changes  (hidden when compare_specific exists)
	filter_field         : When a field in the target module contains a specified value  
	filter_rel_field     : When the target module changes and a field in a related module contains a specified value  


2a. compare_specific: When Alternate Phone: changes to or from specified value 
	<input type="hidden" name="module" value="WorkFlowTriggerShells">
	<input type="hidden" id='record' name="record" value="680a2500-a29b-42e4-060f-48825e03a1bc">
	<input type="hidden" id='workflow_id' name="workflow_id" value="c39feba9-7c87-e461-385f-4881f980ffce">
	<input type="hidden" id='parent_id' name="parent_id" value="c39feba9-7c87-e461-385f-4881f980ffce">
	<input type="hidden" name="action" value="Save">
	<input type="hidden" name="return_module" value="">
	<input type="hidden" name="return_id" value="">
	<input type="hidden" name="return_action" value="">
	<input type="hidden" name="sugar_body_only" value="true">
	<input type="hidden" id='type' name="type" value="compare_specific">
	<input type="hidden" name="frame_type" value="Primary">
	<input type="hidden" id='field' name="field" value="phone_alternate">
	<input type="hidden" id='type' name="type" value="compare_specific">
	<input type="hidden" id='base_module' name="base_module" value="Accounts">

	mod_future_trigger
	mod_past_trigger
	
	<input type="hidden" id='future_trigger_lhs_module' name="future_trigger_lhs_module" value="Accounts">
	<input type="hidden" id='future_trigger_lhs_field' name="future_trigger_lhs_field" value="phone_alternate">
	<input type="hidden" id='future_trigger_rhs_value' name="future_trigger_rhs_value" value="111">
	<input type="hidden" id='future_trigger_exp_id' name="future_trigger_exp_id" value="71664690-81b5-218f-4bc3-48825e66f53b">
	<input type="hidden" id='future_trigger_operator' name="future_trigger_operator" value="Equals">
	<input type="hidden" id='future_trigger_exp_type' name="future_trigger_exp_type" value="phone">
	<input type="hidden" id='future_trigger_time_int' name="future_trigger_time_int" value="">
	<input type="hidden" id='default_href_future_trigger' name="default_href_future_trigger" value="value">
	
	
	<input type="hidden" id='past_trigger_lhs_module' name="past_trigger_lhs_module" value="Accounts">
	<input type="hidden" id='past_trigger_lhs_field' name="past_trigger_lhs_field" value="phone_alternate">
	<input type="hidden" id='past_trigger_rhs_value' name="past_trigger_rhs_value" value="222">
	<input type="hidden" id='past_trigger_exp_id' name="past_trigger_exp_id" value="7008f54a-fbae-3149-3656-48825ec4e6df">
	<input type="hidden" id='past_trigger_operator' name="past_trigger_operator" value="Equals">
	<input type="hidden" id='past_trigger_exp_type' name="past_trigger_exp_type" value="phone">
	<input type="hidden" id='default_href_past_trigger' name="default_href_past_trigger" value="value">

2b. trigger_record_change: When the target module changes 
	<input type="hidden" name="module" value="WorkFlowTriggerShells">
	<input type="hidden" id='record' name="record" value="1abcfde8-dea4-d2ea-d459-4882a860ba37">
	<input type="hidden" id='workflow_id' name="workflow_id" value="a5d83146-a94a-1175-ae1d-4881fad6aa0f">
	<input type="hidden" id='parent_id' name="parent_id" value="a5d83146-a94a-1175-ae1d-4881fad6aa0f">
	<input type="hidden" id='action' name="action" value="CreateStep2">
	<input type="hidden" name="return_module" value="">
	<input type="hidden" name="return_id" value="">
	<input type="hidden" name="return_action" value="">
	<input type="hidden" name="sugar_body_only" value="true">
	<input type="hidden" id='plugin_action' name="plugin_action">
	<input type="hidden" id='plugin_module' name="plugin_module">
	<input type="hidden" name="frame_type" value="Primary">
	<input type="hidden" id='rel_module' name="rel_module" value="">
	<input type="hidden" id='prev_display_text' name='prev_display_text' value="">
	<input type="hidden" id='field' name='field' value="">
	<input type="hidden" id='base_module' name="base_module" value="Accounts">
	<input type="hidden" id='meta_filter_name' name="meta_filter_name" value="normal_trigger">

2c. compare_change: When Billing City: changes 
	<input type="hidden" name="module" value="WorkFlowTriggerShells">
	<input type="hidden" id='record' name="record" value="50702001-71fc-539f-3634-4882615df633">
	<input type="hidden" id='workflow_id' name="workflow_id" value="c39feba9-7c87-e461-385f-4881f980ffce">
	<input type="hidden" id='parent_id' name="parent_id" value="c39feba9-7c87-e461-385f-4881f980ffce">
	<input type="hidden" id='action' name="action" value="CreateStep2">
	<input type="hidden" name="return_module" value="">
	<input type="hidden" name="return_id" value="">
	<input type="hidden" name="return_action" value="">
	<input type="hidden" name="sugar_body_only" value="true">
	<input type="hidden" id='plugin_action' name="plugin_action">
	<input type="hidden" id='plugin_module' name="plugin_module">
	<input type="hidden" name="frame_type" value="Secondary">
	<input type="hidden" id='rel_module' name="rel_module" value="">
	<input type="hidden" id='prev_display_text' name='prev_display_text' value="">
	<input type="hidden" id='field' name='field' value="billing_address_city">
	<input type="hidden" id='base_module' name="base_module" value="Accounts">
	<input type="hidden" id='meta_filter_name' name="meta_filter_name" value="normal_trigger">

2d. filter_field: When a field in the target module contains a specified value 
	<input type="hidden" name="module" value="WorkFlowTriggerShells">
	<input type="hidden" id='record' name="record" value="a3cd6340-fecc-3262-58a5-488262a72245">
	<input type="hidden" id='workflow_id' name="workflow_id" value="c39feba9-7c87-e461-385f-4881f980ffce">
	<input type="hidden" id='parent_id' name="parent_id" value="c39feba9-7c87-e461-385f-4881f980ffce">
	<input type="hidden" name="action" value="SaveFilter">
	<input type="hidden" name="return_module" value="">
	<input type="hidden" name="return_id" value="">
	<input type="hidden" name="return_action" value="">
	<input type="hidden" name="sugar_body_only" value="true">
	<input type="hidden" id='type' name="type" value="filter_field">
	<input type="hidden" id='field' name="field" value="">
	<input type="hidden" name="frame_type" value="Secondary">
	<input type="hidden" id='rel_module' name="rel_module" value="">
	<input type="hidden" id='base_module' name="base_module" value="Accounts">

		<input type="hidden" id='trigger_lhs_module' name="trigger_lhs_module" value="Accounts">
		<input type="hidden" id='trigger_lhs_field' name="trigger_lhs_field" value="rating">
		<input type="hidden" id='trigger_rhs_value' name="trigger_rhs_value" value="8888">
		<input type="hidden" id='trigger_exp_id' name="trigger_exp_id" value="ab030bf0-b81b-33c7-db69-4882627cdeea">
		<input type="hidden" id='trigger_operator' name="trigger_operator" value="Equals">
		<input type="hidden" id='trigger_exp_type' name="trigger_exp_type" value="varchar">
		<input type="hidden" id='default_href_trigger' name="default_href_trigger" value="field">

2e. filter_rel_field: Specify related Bug Tracker's field 
	<input type="hidden" name="module" value="WorkFlowTriggerShells">
	<input type="hidden" id='record' name="record" value="bb070c98-07d0-f79a-2e44-4882a7a2bbad">
	<input type="hidden" id='workflow_id' name="workflow_id" value="c39feba9-7c87-e461-385f-4881f980ffce">
	<input type="hidden" id='parent_id' name="parent_id" value="c39feba9-7c87-e461-385f-4881f980ffce">
	<input type="hidden" name="action" value="SaveFilter">
	<input type="hidden" name="return_module" value="">
	<input type="hidden" name="return_id" value="">
	<input type="hidden" name="return_action" value="">
	<input type="hidden" name="sugar_body_only" value="true">
	<input type="hidden" id='type' name="type" value="filter_rel_field">
	<input type="hidden" id='field' name="field" value="">
	<input type="hidden" name="frame_type" value="Secondary">
	<input type="hidden" id='rel_module' name="rel_module" value="bugs">
	<input type="hidden" id='base_module' name="base_module" value="Accounts">

		<input type="hidden" id='trigger_lhs_module' name="trigger_lhs_module" value="Bugs">
		<input type="hidden" id='trigger_lhs_field' name="trigger_lhs_field" value="product_category">
		<input type="hidden" id='trigger_rhs_value' name="trigger_rhs_value" value="Accounts">
		<input type="hidden" id='trigger_exp_id' name="trigger_exp_id" value="c21ed9f6-c562-779f-c093-4882a72f65d8">
		<input type="hidden" id='trigger_operator' name="trigger_operator" value="Equals">
		<input type="hidden" id='trigger_exp_type' name="trigger_exp_type" value="enum">
		<input type="hidden" id='default_href_trigger' name="default_href_trigger" value="field">

*/

if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WORKFLOW_TRIGGER_SHELLS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WORKFLOW_TRIGGER_SHELLS';
	Create Table dbo.WORKFLOW_TRIGGER_SHELLS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WORKFLOW_TRIGGER_SHELLS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, PARENT_ID                           uniqueidentifier null
		, FIELD                               nvarchar(100) null
		, TYPE                                nvarchar(25) null
		, FRAME_TYPE                          nvarchar(25) null
		, EVAL                                nvarchar(max) null
		, SHOW_PAST                           bit null
		, REL_MODULE                          nvarchar(100) null
		, REL_MODULE_TYPE                     nvarchar(25) null
		, PARAMETERS                          nvarchar(100) null
		)

	create index IDX_WORKFLOW_TRIGGER_SHELLS_PARENT_ID on WORKFLOW_TRIGGER_SHELLS (PARENT_ID)
  end
GO

