

print 'TERMINOLOGY ActivityStream Professional en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_CREATED'                     , N'en-US', N'Contracts', null, null, N'Created <a href="~/Contracts/view.aspx?ID={0}">{1}</a> Contract.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_UPDATED'                     , N'en-US', N'Contracts', null, null, N'Updated <span class="ActivityStreamUpdateFields">{0}</span> on <a href="~/Contracts/view.aspx?ID={1}">{2}</a>.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_DELETED'                     , N'en-US', N'Contracts', null, null, N'Deleted {0} Contract.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_CREATED'                     , N'en-US', N'Contracts', null, null, N'ID NAME';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_UPDATED'                     , N'en-US', N'Contracts', null, null, N'STREAM_COLUMNS ID NAME';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_DELETED'                     , N'en-US', N'Contracts', null, null, N'NAME';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_CREATED'                     , N'en-US', N'KBDocuments', null, null, N'Created <a href="~/KBDocuments/view.aspx?ID={0}">{1}</a> KB Document.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_UPDATED'                     , N'en-US', N'KBDocuments', null, null, N'Updated <span class="ActivityStreamUpdateFields">{0}</span> on <a href="~/KBDocuments/view.aspx?ID={1}">{2}</a>.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_DELETED'                     , N'en-US', N'KBDocuments', null, null, N'Deleted {0} KB Document.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_CREATED'                     , N'en-US', N'KBDocuments', null, null, N'ID NAME';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_UPDATED'                     , N'en-US', N'KBDocuments', null, null, N'STREAM_COLUMNS ID NAME';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_DELETED'                     , N'en-US', N'KBDocuments', null, null, N'NAME';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_CREATED'                     , N'en-US', N'Quotes', null, null, N'Created <a href="~/Quotes/view.aspx?ID={0}">{1}</a> Quote.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_UPDATED'                     , N'en-US', N'Quotes', null, null, N'Updated <span class="ActivityStreamUpdateFields">{0}</span> on <a href="~/Quotes/view.aspx?ID={1}">{2}</a>.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_DELETED'                     , N'en-US', N'Quotes', null, null, N'Deleted {0} Quote.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_CREATED'                     , N'en-US', N'Quotes', null, null, N'ID NAME';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_UPDATED'                     , N'en-US', N'Quotes', null, null, N'STREAM_COLUMNS ID NAME';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_DELETED'                     , N'en-US', N'Quotes', null, null, N'NAME';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_CREATED'                     , N'en-US', N'Orders', null, null, N'Created <a href="~/Orders/view.aspx?ID={0}">{1}</a> Order.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_UPDATED'                     , N'en-US', N'Orders', null, null, N'Updated <span class="ActivityStreamUpdateFields">{0}</span> on <a href="~/Orders/view.aspx?ID={1}">{2}</a>.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_DELETED'                     , N'en-US', N'Orders', null, null, N'Deleted {0} Order.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_CREATED'                     , N'en-US', N'Orders', null, null, N'ID NAME';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_UPDATED'                     , N'en-US', N'Orders', null, null, N'STREAM_COLUMNS ID NAME';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_DELETED'                     , N'en-US', N'Orders', null, null, N'NAME';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_CREATED'                     , N'en-US', N'Invoices', null, null, N'Created <a href="~/Invoices/view.aspx?ID={0}">{1}</a> Invoice.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_UPDATED'                     , N'en-US', N'Invoices', null, null, N'Updated <span class="ActivityStreamUpdateFields">{0}</span> on <a href="~/Invoices/view.aspx?ID={1}">{2}</a>.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_DELETED'                     , N'en-US', N'Invoices', null, null, N'Deleted {0} Invoice.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_CREATED'                     , N'en-US', N'Invoices', null, null, N'ID NAME';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_UPDATED'                     , N'en-US', N'Invoices', null, null, N'STREAM_COLUMNS ID NAME';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_DELETED'                     , N'en-US', N'Invoices', null, null, N'NAME';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_CREATED'                     , N'en-US', N'Surveys', null, null, N'Created <a href="~/Surveys/view.aspx?ID={0}">{1}</a> Survey.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_UPDATED'                     , N'en-US', N'Surveys', null, null, N'Updated <span class="ActivityStreamUpdateFields">{0}</span> on <a href="~/Surveys/view.aspx?ID={1}">{2}</a>.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FORMAT_DELETED'                     , N'en-US', N'Surveys', null, null, N'Deleted {0} Survey.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_CREATED'                     , N'en-US', N'Surveys', null, null, N'ID NAME';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_UPDATED'                     , N'en-US', N'Surveys', null, null, N'STREAM_COLUMNS ID NAME';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREAM_FIELDS_DELETED'                     , N'en-US', N'Surveys', null, null, N'NAME';

GO

set nocount off;
GO

/* -- #if Oracle
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			StoO_selcnt := 0;
		WHEN OTHERS THEN
			RAISE;
	END;
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spTERMINOLOGY_ActivityStream_Pro_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_ActivityStream_Pro_en_us')
/
-- #endif IBM_DB2 */
