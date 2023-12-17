if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCONFIG_QuickBooksChanged' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCONFIG_QuickBooksChanged;
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
Create Procedure dbo.spCONFIG_QuickBooksChanged
	( @MODIFIED_USER_ID    uniqueidentifier
	)
as
  begin
	set nocount on

	declare @QUICKBOOKS_ENABLED    bit;
	declare @OLD_PAYMENT_TERM_LIST nvarchar(50);
	declare @NEW_PAYMENT_TERM_LIST nvarchar(50);
	declare @OLD_PAYMENT_TYPE_LIST nvarchar(50);
	declare @NEW_PAYMENT_TYPE_LIST nvarchar(50);
	
	-- select DETAIL_NAME, DATA_FIELD, LIST_NAME  from DETAILVIEWS_FIELDS where DATA_FIELD = 'PAYMENT_TERMS' and DEFAULT_VIEW = 0 and DELETED = 0;
	-- select DETAIL_NAME, DATA_FIELD, LIST_NAME  from DETAILVIEWS_FIELDS where DATA_FIELD = 'PAYMENT_TYPE'  and DEFAULT_VIEW = 0 and DELETED = 0;
	-- select EDIT_NAME  , DATA_FIELD, CACHE_NAME from EDITVIEWS_FIELDS   where DATA_FIELD = 'PAYMENT_TERMS' and DEFAULT_VIEW = 0 and DELETED = 0;
	-- select EDIT_NAME  , DATA_FIELD,CACHE_NAME  from EDITVIEWS_FIELDS   where DATA_FIELD = 'PAYMENT_TYPE'  and DEFAULT_VIEW = 0 and DELETED = 0;
	-- select GRID_NAME  , DATA_FIELD, LIST_NAME  from GRIDVIEWS_COLUMNS  where DATA_FIELD = 'PAYMENT_TYPE'  and DEFAULT_VIEW = 0 and DELETED = 0;
	set @QUICKBOOKS_ENABLED = dbo.fnCONFIG_Boolean(N'QuickBooks.Enabled');
	if @QUICKBOOKS_ENABLED = 1 begin -- then
		set @OLD_PAYMENT_TERM_LIST = N'payment_terms_dom';
		set @NEW_PAYMENT_TERM_LIST = N'PaymentTerms';
		set @OLD_PAYMENT_TYPE_LIST = N'payment_type_dom';
		set @NEW_PAYMENT_TYPE_LIST = N'PaymentTypes';
	end else begin
		set @OLD_PAYMENT_TERM_LIST = N'PaymentTerms';
		set @NEW_PAYMENT_TERM_LIST = N'payment_terms_dom';
		set @OLD_PAYMENT_TYPE_LIST = N'PaymentTypes';
		set @NEW_PAYMENT_TYPE_LIST = N'payment_type_dom';
	end -- if;
	
	if exists(select * from DETAILVIEWS_FIELDS where DATA_FIELD = 'PAYMENT_TERMS' and LIST_NAME = @OLD_PAYMENT_TERM_LIST and DELETED = 0) begin -- then
		print 'DETAILVIEWS_FIELDS: Updating Payment Terms';
		update DETAILVIEWS_FIELDS
		   set LIST_NAME         = @NEW_PAYMENT_TERM_LIST
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where DATA_FIELD        = 'PAYMENT_TERMS'
		   and LIST_NAME         = @OLD_PAYMENT_TERM_LIST
		   and DELETED           = 0;
	end -- if;
	
	if exists(select * from EDITVIEWS_FIELDS where DATA_FIELD = 'PAYMENT_TERMS' and CACHE_NAME = @OLD_PAYMENT_TERM_LIST and DELETED = 0) begin -- then
		print 'EDITVIEWS_FIELDS: Updating Payment Terms';
		update EDITVIEWS_FIELDS
		   set CACHE_NAME        = @NEW_PAYMENT_TERM_LIST
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where DATA_FIELD        = 'PAYMENT_TERMS'
		   and CACHE_NAME        = @OLD_PAYMENT_TERM_LIST
		   and DELETED           = 0;
	end -- if;
	
	if exists(select * from DETAILVIEWS_FIELDS where DATA_FIELD = 'PAYMENT_TYPE' and LIST_NAME = @OLD_PAYMENT_TYPE_LIST and DELETED = 0) begin -- then
		print 'DETAILVIEWS_FIELDS: Updating Payment Type';
		update DETAILVIEWS_FIELDS
		   set LIST_NAME         = @NEW_PAYMENT_TYPE_LIST
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where DATA_FIELD        = 'PAYMENT_TYPE'
		   and LIST_NAME         = @OLD_PAYMENT_TYPE_LIST
		   and DELETED           = 0;
	end -- if;
	
	if exists(select * from EDITVIEWS_FIELDS where DATA_FIELD = 'PAYMENT_TYPE' and CACHE_NAME = @OLD_PAYMENT_TYPE_LIST and DELETED = 0) begin -- then
		print 'EDITVIEWS_FIELDS: Updating Payment Type';
		update EDITVIEWS_FIELDS
		   set CACHE_NAME        = @NEW_PAYMENT_TYPE_LIST
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where DATA_FIELD        = 'PAYMENT_TYPE'
		   and CACHE_NAME        = @OLD_PAYMENT_TYPE_LIST
		   and DELETED           = 0;
	end -- if;
	
	if exists(select * from GRIDVIEWS_COLUMNS where DATA_FIELD = 'PAYMENT_TYPE' and LIST_NAME = @OLD_PAYMENT_TYPE_LIST and DELETED = 0) begin -- then
		print 'GRIDVIEWS_COLUMNS: Updating Payment Types';
		update GRIDVIEWS_COLUMNS
		   set LIST_NAME         = @NEW_PAYMENT_TYPE_LIST
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where DATA_FIELD        = 'PAYMENT_TYPE'
		   and LIST_NAME         = @OLD_PAYMENT_TYPE_LIST
		   and DELETED           = 0;
	end -- if;
  end
GO

Grant Execute on dbo.spCONFIG_QuickBooksChanged to public;
GO

