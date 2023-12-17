
-- 01/27/2015 Paul.  Reduce view name to support Oracle. 
if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwQUOTES_LINE_ITEMS_QuickBooksOnline')
	Drop View dbo.vwQUOTES_LINE_ITEMS_QuickBooksOnline;
GO

