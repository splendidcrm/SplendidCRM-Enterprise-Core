if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSEMANTIC_MODEL_Rebuild' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSEMANTIC_MODEL_Rebuild;
GO


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
Create Procedure dbo.spSEMANTIC_MODEL_Rebuild
as
  begin
	set nocount on
	
	declare @MODIFIED_USER_ID                   uniqueidentifier;
	declare @TABLE_NAME                         nvarchar(64);

	declare @ColumnName                         nvarchar(64);
	declare @ColumnType                         nvarchar(30);
	declare @CsType                             nvarchar(20);
	declare @colid                              int;
	declare @length                             int;
	declare @IsNullable                         bit;

	declare @FIELD_ID                           uniqueidentifier;
	declare @NAME                               nvarchar(64);
	declare @COLUMN_INDEX                       int;
	declare @DATA_TYPE                          nvarchar(25);
	declare @FORMAT                             nvarchar(10);
	declare @WIDTH                              int;
	declare @NULLABLE                           bit;
	declare @IS_AGGREGATE                       bit;
	declare @SORT_DESCENDING                    bit;
	declare @IDENTIFYING_ATTRIBUTE              bit;
	declare @DETAIL_ATTRIBUTE                   bit;
	declare @AGGREGATE_ATTRIBUTE                bit;
	declare @VALUE_SELECTION                    nvarchar(25);
	declare @CONTEXTUAL_NAME                    nvarchar(25);
	declare @DISCOURAGE_GROUPING                bit;
	declare @AGGREGATE_FUNCTION_NAME            nvarchar(25);
	declare @DEFAULT_AGGREGATE                  bit;
	declare @VARIATION_PARENT_ID                uniqueidentifier;

	declare @JOIN_ID                            uniqueidentifier;
	declare @LHS_MODULE                         nvarchar(100);
	declare @LHS_TABLE                          nvarchar( 64);
	declare @LHS_KEY                            nvarchar( 64);
	declare @RHS_MODULE                         nvarchar(100);
	declare @RHS_TABLE                          nvarchar( 64);
	declare @RHS_KEY                            nvarchar( 64);
	declare @JOIN_TABLE                         nvarchar( 64);
	declare @JOIN_KEY_LHS                       nvarchar( 64);
	declare @JOIN_KEY_RHS                       nvarchar( 64);
	declare @RELATIONSHIP_TYPE                  nvarchar( 64);
	declare @RELATIONSHIP_ROLE_COLUMN_VALUE     nvarchar( 50);
	declare @CARDINALITY                        nvarchar( 25);

	-- 01/12/2010 Paul.  Move these files to the bottom of the list to simplify migration to Oracle. 
	declare @RELATIONSHIP_ROLE_COLUMN           nvarchar( 64);
	declare @ID                                 uniqueidentifier;
	declare @TEMP_ID                            uniqueidentifier;

-- #if SQL_Server /*
	-- 12/13/2009 Paul.  We don't need the MODULE_NAME or the DISPLAY_NAME. 
	declare TABLE_CURSOR cursor for
	select distinct
	       ID
	     , TABLE_NAME
	  from vwMODULES_Reporting
	 where TABLE_NAME is not null
	 order by TABLE_NAME;
-- #endif SQL_Server */

	print N'Semantic Model Tables';
	open TABLE_CURSOR;
	fetch next from TABLE_CURSOR into @ID, @TABLE_NAME;
	while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
		if not exists(select * from SEMANTIC_MODEL_TABLES where NAME = @TABLE_NAME and DELETED = 0) begin -- then
			exec dbo.spSEMANTIC_MODEL_TABLES_InsertOnly @ID out, null, @TABLE_NAME, @TABLE_NAME, N'List';
			set @VARIATION_PARENT_ID     = @ID;  -- The parent is the ID of the table. 
			set @NULLABLE                = 1;
			set @IDENTIFYING_ATTRIBUTE   = null;
			set @DETAIL_ATTRIBUTE        = null;
			set @VALUE_SELECTION         = null;
			set @CONTEXTUAL_NAME         = null;
			set @DISCOURAGE_GROUPING     = null;

			set @COLUMN_INDEX            = 0;  -- We want the table count to be at the top of the list of fields. 
			set @AGGREGATE_FUNCTION_NAME = N'Count';
			set @NAME                    = N'# ' + @TABLE_NAME;
			set @DATA_TYPE               = N'Integer';
			set @FORMAT                  = N'n0';
			set @SORT_DESCENDING         = 1;
			set @IS_AGGREGATE            = 1;
			set @AGGREGATE_ATTRIBUTE     = 1;
			set @DEFAULT_AGGREGATE       = 0;
			set @TEMP_ID                 = null;
			exec dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly @TEMP_ID out, null, @TABLE_NAME, @NAME, @COLUMN_INDEX, @DATA_TYPE, @FORMAT, @WIDTH, @NULLABLE, @IS_AGGREGATE, @SORT_DESCENDING, @IDENTIFYING_ATTRIBUTE, @DETAIL_ATTRIBUTE, @AGGREGATE_ATTRIBUTE, @VALUE_SELECTION, @CONTEXTUAL_NAME, @DISCOURAGE_GROUPING, @AGGREGATE_FUNCTION_NAME, @DEFAULT_AGGREGATE, @VARIATION_PARENT_ID;
		end -- if;

-- #if SQL_Server /*
		declare COLUMN_CURSOR cursor for
		select upper(ColumnName)
		     , ColumnType
		     , CsType
		     , colid
		     , length
		     , IsNullable
		  from            vwSqlColumns
		  left outer join SEMANTIC_MODEL_FIELDS
		               on SEMANTIC_MODEL_FIELDS.NAME       = upper(vwSqlColumns.ColumnName)
		              and SEMANTIC_MODEL_FIELDS.TABLE_NAME = @TABLE_NAME
		 where ObjectName = 'vw' + @TABLE_NAME
		   and ColumnName <> 'ID_C'
		   and SEMANTIC_MODEL_FIELDS.ID is null
		 order by colid;
-- #endif SQL_Server */

		open COLUMN_CURSOR;
		fetch next from COLUMN_CURSOR into @ColumnName, @ColumnType, @CsType, @colid, @length, @IsNullable;
/* -- #if Oracle
		IF COLUMN_CURSOR%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
		while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
			set @FIELD_ID                = null;
			set @NAME                    = null;
			set @COLUMN_INDEX            = null;
			set @DATA_TYPE               = null;
			set @FORMAT                  = null;
			set @WIDTH                   = null;
			set @NULLABLE                = null;
			set @IS_AGGREGATE            = null;
			set @SORT_DESCENDING         = null;
			set @IDENTIFYING_ATTRIBUTE   = null;
			set @DETAIL_ATTRIBUTE        = null;
			set @AGGREGATE_ATTRIBUTE     = null;
			set @VALUE_SELECTION         = null;
			set @CONTEXTUAL_NAME         = null;
			set @DISCOURAGE_GROUPING     = null;
			set @AGGREGATE_FUNCTION_NAME = null;
			set @DEFAULT_AGGREGATE       = null;
			set @VARIATION_PARENT_ID     = null;

			set @NAME = @ColumnName;
			set @COLUMN_INDEX = @colid;
			if @IsNullable = 1 begin -- then
				set @NULLABLE = 1;
			end -- if;
			if @ColumnName = 'ID' begin -- then
				set @IDENTIFYING_ATTRIBUTE = 1;
				set @DETAIL_ATTRIBUTE      = 1;
				set @VALUE_SELECTION       = N'List';
				set @CONTEXTUAL_NAME       = N'Merge';
			end -- if;
			if @ColumnName = 'NAME' begin -- then
				set @IDENTIFYING_ATTRIBUTE = 1;
				set @DETAIL_ATTRIBUTE      = 1;
				set @VALUE_SELECTION       = N'List';
				set @CONTEXTUAL_NAME       = N'Role';
			end -- if;

			if @CsType = 'Guid' begin -- then
				set @DATA_TYPE             = N'String';
				set @WIDTH                 = 36;
				set @SORT_DESCENDING       = 0;
				set @DISCOURAGE_GROUPING   = 1;
			end -- if;
			if @CsType = 'short' begin -- then
				set @DATA_TYPE             = N'Integer';
				set @SORT_DESCENDING       = 1;
				set @FORMAT                = N'n0';
			end -- if;
			if @CsType = 'Int32' begin -- then
				set @DATA_TYPE             = N'Integer';
				set @WIDTH                 = 3;
				set @SORT_DESCENDING       = 1;
				set @FORMAT                = N'g';
			end -- if;
			if @CsType = 'Int64' begin -- then
				set @DATA_TYPE             = N'Integer';
				set @SORT_DESCENDING       = 1;
				set @FORMAT                = N'n0';
			end -- if;
			if @CsType = 'float' begin -- then
				set @DATA_TYPE             = N'Integer';
				set @WIDTH                 = 7;
				set @SORT_DESCENDING       = 1;
				set @FORMAT                = N'f3';
			end -- if;
			if @CsType = 'decimal' begin -- then
				set @DATA_TYPE             = N'Integer';
				set @WIDTH                 = 8;
				set @SORT_DESCENDING       = 1;
				set @FORMAT                = N'g0';
			end -- if;
			if @CsType = 'bool' begin -- then
				set @DATA_TYPE             = N'Boolean';
				set @SORT_DESCENDING       = 0;
			end -- if;
			if @CsType = 'DateTime' begin -- then
				set @DATA_TYPE             = N'DateTime';
				set @SORT_DESCENDING       = 0;
				set @FORMAT                = N'd';
			end -- if;
			if @CsType = 'enum' begin -- then
				set @DATA_TYPE             = N'String';
				set @WIDTH                 = @length;
				set @SORT_DESCENDING       = 0;
				set @VALUE_SELECTION       = N'Dropdown';
			end -- if;
			if @CsType = 'byte[]' begin -- then
				set @DATA_TYPE             = N'Image';
				set @WIDTH                 = @length;
				set @SORT_DESCENDING       = 0;
				set @DISCOURAGE_GROUPING   = 1;
			end -- if;
			if @CsType = 'ansistring' or @CsType = 'string' begin -- then
				set @DATA_TYPE             = N'String';
				set @SORT_DESCENDING       = 0;
				if @length > 0 and @length < 40 begin -- then
					set @WIDTH = @length;
				end -- if;
				if @NAME = N'NAME' or @ColumnType = N'nvarchar(max)' or @ColumnType = N'text' or @ColumnType = N'ntext' begin -- then
					set @DISCOURAGE_GROUPING   = 1;
				end -- if;
			end -- if;

			exec dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly @FIELD_ID out, null, @TABLE_NAME, @NAME, @COLUMN_INDEX, @DATA_TYPE, @FORMAT, @WIDTH, @NULLABLE, @IS_AGGREGATE, @SORT_DESCENDING, @IDENTIFYING_ATTRIBUTE, @DETAIL_ATTRIBUTE, @AGGREGATE_ATTRIBUTE, @VALUE_SELECTION, @CONTEXTUAL_NAME, @DISCOURAGE_GROUPING, @AGGREGATE_FUNCTION_NAME, @DEFAULT_AGGREGATE, @VARIATION_PARENT_ID;

			if @CsType = 'Int32' or @CsType = 'Int64' or @CsType = 'float' or @CsType = 'decimal' begin -- then
				set @VARIATION_PARENT_ID     = @FIELD_ID;
				set @NULLABLE                = 1;
				set @IS_AGGREGATE            = 1;
				set @SORT_DESCENDING         = 1;
				set @IDENTIFYING_ATTRIBUTE   = null;
				set @DETAIL_ATTRIBUTE        = null;
				set @AGGREGATE_ATTRIBUTE     = null;
				set @VALUE_SELECTION         = null;
				set @CONTEXTUAL_NAME         = null;
				set @DISCOURAGE_GROUPING     = null;

				set @AGGREGATE_FUNCTION_NAME = N'Sum';
				set @NAME                    = N'Total ' + @ColumnName;
				set @DEFAULT_AGGREGATE       = 1;
				set @TEMP_ID                 = null;
				exec dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly @TEMP_ID out, null, @TABLE_NAME, @NAME, @COLUMN_INDEX, @DATA_TYPE, @FORMAT, @WIDTH, @NULLABLE, @IS_AGGREGATE, @SORT_DESCENDING, @IDENTIFYING_ATTRIBUTE, @DETAIL_ATTRIBUTE, @AGGREGATE_ATTRIBUTE, @VALUE_SELECTION, @CONTEXTUAL_NAME, @DISCOURAGE_GROUPING, @AGGREGATE_FUNCTION_NAME, @DEFAULT_AGGREGATE, @VARIATION_PARENT_ID;

				set @VARIATION_PARENT_ID     = @FIELD_ID;
				set @AGGREGATE_FUNCTION_NAME = N'Avg';
				set @NAME                    = N'Avg ' + @ColumnName;
				set @DEFAULT_AGGREGATE       = 0;
				set @TEMP_ID                 = null;
				exec dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly @TEMP_ID out, null, @TABLE_NAME, @NAME, @COLUMN_INDEX, @DATA_TYPE, @FORMAT, @WIDTH, @NULLABLE, @IS_AGGREGATE, @SORT_DESCENDING, @IDENTIFYING_ATTRIBUTE, @DETAIL_ATTRIBUTE, @AGGREGATE_ATTRIBUTE, @VALUE_SELECTION, @CONTEXTUAL_NAME, @DISCOURAGE_GROUPING, @AGGREGATE_FUNCTION_NAME, @DEFAULT_AGGREGATE, @VARIATION_PARENT_ID;

				set @VARIATION_PARENT_ID     = @FIELD_ID;
				set @AGGREGATE_FUNCTION_NAME = N'Min';
				set @NAME                    = N'Min ' + @ColumnName;
				set @DEFAULT_AGGREGATE       = 0;
				set @TEMP_ID                 = null;
				exec dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly @TEMP_ID out, null, @TABLE_NAME, @NAME, @COLUMN_INDEX, @DATA_TYPE, @FORMAT, @WIDTH, @NULLABLE, @IS_AGGREGATE, @SORT_DESCENDING, @IDENTIFYING_ATTRIBUTE, @DETAIL_ATTRIBUTE, @AGGREGATE_ATTRIBUTE, @VALUE_SELECTION, @CONTEXTUAL_NAME, @DISCOURAGE_GROUPING, @AGGREGATE_FUNCTION_NAME, @DEFAULT_AGGREGATE, @VARIATION_PARENT_ID;

				set @VARIATION_PARENT_ID     = @FIELD_ID;
				set @AGGREGATE_FUNCTION_NAME = N'Max';
				set @NAME                    = N'Max ' + @ColumnName;
				set @DEFAULT_AGGREGATE       = 0;
				set @TEMP_ID                 = null;
				exec dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly @TEMP_ID out, null, @TABLE_NAME, @NAME, @COLUMN_INDEX, @DATA_TYPE, @FORMAT, @WIDTH, @NULLABLE, @IS_AGGREGATE, @SORT_DESCENDING, @IDENTIFYING_ATTRIBUTE, @DETAIL_ATTRIBUTE, @AGGREGATE_ATTRIBUTE, @VALUE_SELECTION, @CONTEXTUAL_NAME, @DISCOURAGE_GROUPING, @AGGREGATE_FUNCTION_NAME, @DEFAULT_AGGREGATE, @VARIATION_PARENT_ID;
			end -- if;
			if @CsType = 'DateTime' begin -- then
				set @VARIATION_PARENT_ID     = @FIELD_ID;
				set @NULLABLE                = 1;
				set @SORT_DESCENDING         = 0;
				set @DEFAULT_AGGREGATE       = null;
				set @IDENTIFYING_ATTRIBUTE   = null;
				set @DETAIL_ATTRIBUTE        = null;
				set @AGGREGATE_ATTRIBUTE     = null;
				set @VALUE_SELECTION         = null;
				set @CONTEXTUAL_NAME         = null;
				set @DISCOURAGE_GROUPING     = null;

				set @AGGREGATE_FUNCTION_NAME = N'Day';
				set @NAME                    = @ColumnName + N' Day';
				set @DATA_TYPE               = N'Integer';
				set @FORMAT                  = null;
				set @SORT_DESCENDING         = 0;
				set @IS_AGGREGATE            = null;
				set @TEMP_ID                 = null;
				exec dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly @TEMP_ID out, null, @TABLE_NAME, @NAME, @COLUMN_INDEX, @DATA_TYPE, @FORMAT, @WIDTH, @NULLABLE, @IS_AGGREGATE, @SORT_DESCENDING, @IDENTIFYING_ATTRIBUTE, @DETAIL_ATTRIBUTE, @AGGREGATE_ATTRIBUTE, @VALUE_SELECTION, @CONTEXTUAL_NAME, @DISCOURAGE_GROUPING, @AGGREGATE_FUNCTION_NAME, @DEFAULT_AGGREGATE, @VARIATION_PARENT_ID;

				set @AGGREGATE_FUNCTION_NAME = N'Month';
				set @NAME                    = @ColumnName + N' Month';
				set @DATA_TYPE               = N'Integer';
				set @FORMAT                  = null;
				set @SORT_DESCENDING         = 0;
				set @IS_AGGREGATE            = null;
				set @TEMP_ID                 = null;
				exec dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly @TEMP_ID out, null, @TABLE_NAME, @NAME, @COLUMN_INDEX, @DATA_TYPE, @FORMAT, @WIDTH, @NULLABLE, @IS_AGGREGATE, @SORT_DESCENDING, @IDENTIFYING_ATTRIBUTE, @DETAIL_ATTRIBUTE, @AGGREGATE_ATTRIBUTE, @VALUE_SELECTION, @CONTEXTUAL_NAME, @DISCOURAGE_GROUPING, @AGGREGATE_FUNCTION_NAME, @DEFAULT_AGGREGATE, @VARIATION_PARENT_ID;

				set @AGGREGATE_FUNCTION_NAME = N'Year';
				set @NAME                    = @ColumnName + N' Year';
				set @DATA_TYPE               = N'Integer';
				set @FORMAT                  = N'0000';
				set @SORT_DESCENDING         = 0;
				set @IS_AGGREGATE            = null;
				set @TEMP_ID                 = null;
				exec dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly @TEMP_ID out, null, @TABLE_NAME, @NAME, @COLUMN_INDEX, @DATA_TYPE, @FORMAT, @WIDTH, @NULLABLE, @IS_AGGREGATE, @SORT_DESCENDING, @IDENTIFYING_ATTRIBUTE, @DETAIL_ATTRIBUTE, @AGGREGATE_ATTRIBUTE, @VALUE_SELECTION, @CONTEXTUAL_NAME, @DISCOURAGE_GROUPING, @AGGREGATE_FUNCTION_NAME, @DEFAULT_AGGREGATE, @VARIATION_PARENT_ID;

				set @AGGREGATE_FUNCTION_NAME = N'Quarter';
				set @NAME                    = @ColumnName + N' Quarter';
				set @DATA_TYPE               = N'Integer';
				set @FORMAT                  = N'Q0';
				set @SORT_DESCENDING         = 0;
				set @IS_AGGREGATE            = null;
				set @TEMP_ID                 = null;
				exec dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly @TEMP_ID out, null, @TABLE_NAME, @NAME, @COLUMN_INDEX, @DATA_TYPE, @FORMAT, @WIDTH, @NULLABLE, @IS_AGGREGATE, @SORT_DESCENDING, @IDENTIFYING_ATTRIBUTE, @DETAIL_ATTRIBUTE, @AGGREGATE_ATTRIBUTE, @VALUE_SELECTION, @CONTEXTUAL_NAME, @DISCOURAGE_GROUPING, @AGGREGATE_FUNCTION_NAME, @DEFAULT_AGGREGATE, @VARIATION_PARENT_ID;

				set @AGGREGATE_FUNCTION_NAME = N'Min';
				set @NAME                    = @ColumnName + N' First';
				set @DATA_TYPE               = N'DateTime';
				set @FORMAT                  = N'd';
				set @SORT_DESCENDING         = 1;
				set @IS_AGGREGATE            = 1;
				set @TEMP_ID                 = null;
				exec dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly @TEMP_ID out, null, @TABLE_NAME, @NAME, @COLUMN_INDEX, @DATA_TYPE, @FORMAT, @WIDTH, @NULLABLE, @IS_AGGREGATE, @SORT_DESCENDING, @IDENTIFYING_ATTRIBUTE, @DETAIL_ATTRIBUTE, @AGGREGATE_ATTRIBUTE, @VALUE_SELECTION, @CONTEXTUAL_NAME, @DISCOURAGE_GROUPING, @AGGREGATE_FUNCTION_NAME, @DEFAULT_AGGREGATE, @VARIATION_PARENT_ID;

				set @AGGREGATE_FUNCTION_NAME = N'Max';
				set @NAME                    = @ColumnName + N' Last';
				set @DATA_TYPE               = N'DateTime';
				set @FORMAT                  = N'd';
				set @SORT_DESCENDING         = 1;
				set @IS_AGGREGATE            = 1;
				set @TEMP_ID                 = null;
				exec dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly @TEMP_ID out, null, @TABLE_NAME, @NAME, @COLUMN_INDEX, @DATA_TYPE, @FORMAT, @WIDTH, @NULLABLE, @IS_AGGREGATE, @SORT_DESCENDING, @IDENTIFYING_ATTRIBUTE, @DETAIL_ATTRIBUTE, @AGGREGATE_ATTRIBUTE, @VALUE_SELECTION, @CONTEXTUAL_NAME, @DISCOURAGE_GROUPING, @AGGREGATE_FUNCTION_NAME, @DEFAULT_AGGREGATE, @VARIATION_PARENT_ID;

			end -- if;
			fetch next from COLUMN_CURSOR into @ColumnName, @ColumnType, @CsType, @colid, @length, @IsNullable;
/* -- #if Oracle
			IF COLUMN_CURSOR%NOTFOUND THEN
				StoO_sqlstatus := 2;
				StoO_fetchstatus := -1;
			ELSE
				StoO_sqlstatus := 0;
				StoO_fetchstatus := 0;
			END IF;
-- #endif Oracle */
		end -- while;
		close COLUMN_CURSOR;
		deallocate COLUMN_CURSOR;

		fetch next from TABLE_CURSOR into @ID, @TABLE_NAME;
/* -- #if Oracle
		IF TABLE_CURSOR%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close TABLE_CURSOR;
	deallocate TABLE_CURSOR;

	print N'Semantic Model Roles';
-- #if SQL_Server /*
	declare RELATIONSHIP_CURSOR cursor for
	select ID
	     , upper(LHS_MODULE  )
	     , upper(LHS_TABLE   )
	     , upper(LHS_KEY     )
	     , upper(RHS_MODULE  )
	     , upper(RHS_TABLE   )
	     , upper(RHS_KEY     )
	     , upper(JOIN_TABLE  )
	     , upper(JOIN_KEY_LHS)
	     , upper(JOIN_KEY_RHS)
	     , RELATIONSHIP_TYPE
	     , RELATIONSHIP_ROLE_COLUMN
	     , RELATIONSHIP_ROLE_COLUMN_VALUE
	  from vwRELATIONSHIPS_Reporting
	 where LHS_MODULE in (select MODULE_NAME from vwMODULES_Reporting where TABLE_NAME is not null)
	   and RHS_MODULE in (select MODULE_NAME from vwMODULES_Reporting where TABLE_NAME is not null)
	 order by LHS_MODULE, RHS_MODULE;
-- #endif SQL_Server */

	open RELATIONSHIP_CURSOR;
/* -- #if Oracle
	IF RELATIONSHIP_CURSOR%NOTFOUND THEN
		StoO_sqlstatus := 2;
		StoO_fetchstatus := -1;
	ELSE
		StoO_sqlstatus := 0;
		StoO_fetchstatus := 0;
	END IF;
-- #endif Oracle */
	fetch next from RELATIONSHIP_CURSOR into @JOIN_ID, @LHS_MODULE, @LHS_TABLE, @LHS_KEY, @RHS_MODULE, @RHS_TABLE, @RHS_KEY, @JOIN_TABLE, @JOIN_KEY_LHS, @JOIN_KEY_RHS, @RELATIONSHIP_TYPE, @RELATIONSHIP_ROLE_COLUMN, @RELATIONSHIP_ROLE_COLUMN_VALUE;
	while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
		if exists(select * from SEMANTIC_MODEL_TABLES where NAME = @LHS_TABLE and DELETED = 0) and exists(select * from SEMANTIC_MODEL_TABLES where NAME = @RHS_TABLE and DELETED = 0) begin -- then
			if @JOIN_TABLE is null begin -- then
				if @LHS_TABLE <> @RHS_TABLE begin -- then
					-- print @LHS_TABLE + N' - ' + @RHS_TABLE;
					-- 12/12/2009 Paul.  First create the LHS role. 
					set @CARDINALITY = null;
					set @NAME        = null;
					if @LHS_KEY = 'ID' begin -- then
						set @CARDINALITY = N'OptionalMany';
					end else begin
						set @CARDINALITY = N'OptionalOne';
					end -- if;
					if @LHS_KEY <> 'ID' begin -- then
						if @RELATIONSHIP_ROLE_COLUMN_VALUE is null begin -- then
							set @NAME = @LHS_KEY;
						end else begin
							set @NAME = @LHS_KEY + N' ' + @RELATIONSHIP_ROLE_COLUMN_VALUE;
						end -- if;
					end -- if;
					set @TEMP_ID = null;
					exec dbo.spSEMANTIC_MODEL_ROLES_InsertOnly @TEMP_ID out, null, @LHS_TABLE, @LHS_KEY, @RHS_TABLE, @RHS_KEY, @CARDINALITY, @NAME;
					
					-- 12/12/2009 Paul.  Then create the RHS role. 
					set @CARDINALITY = null;
					set @NAME        = null;
					if @RHS_KEY = 'ID' begin -- then
						set @CARDINALITY = N'OptionalMany';
					end else begin
						set @CARDINALITY = N'OptionalOne';
					end -- if;
					if @RHS_KEY <> 'ID' begin -- then
						if @RELATIONSHIP_ROLE_COLUMN_VALUE is null begin -- then
							set @NAME = @RHS_KEY;
						end else begin
							set @NAME = @RHS_KEY + N' ' + @RELATIONSHIP_ROLE_COLUMN_VALUE;
						end -- if;
					end -- if;
					set @TEMP_ID = null;
					exec dbo.spSEMANTIC_MODEL_ROLES_InsertOnly @TEMP_ID, null, @RHS_TABLE, @RHS_KEY, @LHS_TABLE, @LHS_KEY, @CARDINALITY, @NAME;
				end -- if;
			end else begin
				-- print @JOIN_TABLE;
				if not exists(select * from SEMANTIC_MODEL_TABLES where NAME = @JOIN_TABLE and DELETED = 0) begin -- then
					exec dbo.spSEMANTIC_MODEL_TABLES_InsertOnly @JOIN_ID out, null, @JOIN_TABLE, @JOIN_TABLE, N'FilteredList';
					set @VARIATION_PARENT_ID     = @JOIN_ID;  -- The parent is the ID of the table. 
					set @NULLABLE                = 1;
					set @IDENTIFYING_ATTRIBUTE   = null;
					set @DETAIL_ATTRIBUTE        = null;
					set @VALUE_SELECTION         = null;
					set @CONTEXTUAL_NAME         = null;
					set @DISCOURAGE_GROUPING     = null;
					
					set @COLUMN_INDEX            = 0;  -- We want the table count to be at the top of the list of fields. 
					set @AGGREGATE_FUNCTION_NAME = N'Count';
					set @NAME                    = N'# ' + @JOIN_TABLE;
					set @DATA_TYPE               = N'Integer';
					set @FORMAT                  = N'n0';
					set @WIDTH                   = null;
					set @SORT_DESCENDING         = 1;
					set @IS_AGGREGATE            = 1;
					set @AGGREGATE_ATTRIBUTE     = 1;
					set @DEFAULT_AGGREGATE       = 0;
					set @TEMP_ID                 = null;
					exec dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly @TEMP_ID out, null, @JOIN_TABLE, @NAME, @COLUMN_INDEX, @DATA_TYPE, @FORMAT, @WIDTH, @NULLABLE, @IS_AGGREGATE, @SORT_DESCENDING, @IDENTIFYING_ATTRIBUTE, @DETAIL_ATTRIBUTE, @AGGREGATE_ATTRIBUTE, @VALUE_SELECTION, @CONTEXTUAL_NAME, @DISCOURAGE_GROUPING, @AGGREGATE_FUNCTION_NAME, @DEFAULT_AGGREGATE, @VARIATION_PARENT_ID;
					
					set @FIELD_ID                = null;
					set @NAME                    = null;
					set @COLUMN_INDEX            = null;
					set @DATA_TYPE               = null;
					set @FORMAT                  = null;
					set @WIDTH                   = null;
					set @NULLABLE                = null;
					set @IS_AGGREGATE            = null;
					set @SORT_DESCENDING         = null;
					set @IDENTIFYING_ATTRIBUTE   = null;
					set @DETAIL_ATTRIBUTE        = null;
					set @AGGREGATE_ATTRIBUTE     = null;
					set @VALUE_SELECTION         = null;
					set @CONTEXTUAL_NAME         = null;
					set @DISCOURAGE_GROUPING     = null;
					set @AGGREGATE_FUNCTION_NAME = null;
					set @DEFAULT_AGGREGATE       = null;
					set @VARIATION_PARENT_ID     = null;
					
					set @NAME                    = @JOIN_KEY_LHS;
					set @COLUMN_INDEX            = 1;
					set @IDENTIFYING_ATTRIBUTE   = 1;
					set @DETAIL_ATTRIBUTE        = 1;
					set @DATA_TYPE               = N'String';
					set @WIDTH                   = 36;
					set @SORT_DESCENDING         = 0;
					set @DISCOURAGE_GROUPING     = 1;
					exec dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly @FIELD_ID out, null, @JOIN_TABLE, @NAME, @COLUMN_INDEX, @DATA_TYPE, @FORMAT, @WIDTH, @NULLABLE, @IS_AGGREGATE, @SORT_DESCENDING, @IDENTIFYING_ATTRIBUTE, @DETAIL_ATTRIBUTE, @AGGREGATE_ATTRIBUTE, @VALUE_SELECTION, @CONTEXTUAL_NAME, @DISCOURAGE_GROUPING, @AGGREGATE_FUNCTION_NAME, @DEFAULT_AGGREGATE, @VARIATION_PARENT_ID;
					
					set @NAME                    = @JOIN_KEY_RHS;
					set @COLUMN_INDEX            = 2;
					set @IDENTIFYING_ATTRIBUTE   = 1;
					set @DETAIL_ATTRIBUTE        = 1;
					set @DATA_TYPE               = N'String';
					set @WIDTH                   = 36;
					set @SORT_DESCENDING         = 0;
					set @DISCOURAGE_GROUPING     = 1;
					exec dbo.spSEMANTIC_MODEL_FIELDS_InsertOnly @FIELD_ID out, null, @JOIN_TABLE, @NAME, @COLUMN_INDEX, @DATA_TYPE, @FORMAT, @WIDTH, @NULLABLE, @IS_AGGREGATE, @SORT_DESCENDING, @IDENTIFYING_ATTRIBUTE, @DETAIL_ATTRIBUTE, @AGGREGATE_ATTRIBUTE, @VALUE_SELECTION, @CONTEXTUAL_NAME, @DISCOURAGE_GROUPING, @AGGREGATE_FUNCTION_NAME, @DEFAULT_AGGREGATE, @VARIATION_PARENT_ID;
				end -- if;
				
				-- print @LHS_TABLE + N' - ' + @JOIN_TABLE;
				set @NAME        = null;
				set @CARDINALITY = N'OptionalMany';
				set @TEMP_ID     = null;
				exec dbo.spSEMANTIC_MODEL_ROLES_InsertOnly @TEMP_ID out, null, @LHS_TABLE, @LHS_KEY, @JOIN_TABLE, @JOIN_KEY_LHS, @CARDINALITY, @NAME;
				
				set @NAME        = @JOIN_KEY_LHS;
				set @CARDINALITY = N'One';
				set @TEMP_ID     = null;
				exec dbo.spSEMANTIC_MODEL_ROLES_InsertOnly @TEMP_ID out, null, @JOIN_TABLE, @JOIN_KEY_LHS, @LHS_TABLE, @LHS_KEY, @CARDINALITY, @NAME;

				-- print @RHS_TABLE + N' - ' + @JOIN_TABLE;
				set @NAME        = null;
				set @CARDINALITY = N'OptionalMany';
				set @TEMP_ID     = null;
				exec dbo.spSEMANTIC_MODEL_ROLES_InsertOnly @TEMP_ID out, null, @RHS_TABLE, @RHS_KEY, @JOIN_TABLE, @JOIN_KEY_RHS, @CARDINALITY, @NAME;
				
				set @NAME        = @JOIN_KEY_RHS;
				set @CARDINALITY = N'One';
				set @TEMP_ID     = null;
				exec dbo.spSEMANTIC_MODEL_ROLES_InsertOnly @TEMP_ID out, null, @JOIN_TABLE, @JOIN_KEY_RHS, @RHS_TABLE, @RHS_KEY, @CARDINALITY, @NAME;
			end -- if;
		end -- if;
		fetch next from RELATIONSHIP_CURSOR into @JOIN_ID, @LHS_MODULE, @LHS_TABLE, @LHS_KEY, @RHS_MODULE, @RHS_TABLE, @RHS_KEY, @JOIN_TABLE, @JOIN_KEY_LHS, @JOIN_KEY_RHS, @RELATIONSHIP_TYPE, @RELATIONSHIP_ROLE_COLUMN, @RELATIONSHIP_ROLE_COLUMN_VALUE;
/* -- #if Oracle
		IF RELATIONSHIP_CURSOR%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close RELATIONSHIP_CURSOR;

	deallocate RELATIONSHIP_CURSOR;
  end
GO


/*
delete from SEMANTIC_MODEL_ROLES ;
delete from SEMANTIC_MODEL_FIELDS;
delete from SEMANTIC_MODEL_TABLES;
exec dbo.spSEMANTIC_MODEL_Rebuild ;
*/

Grant Execute on dbo.spSEMANTIC_MODEL_Rebuild to public;
GO

