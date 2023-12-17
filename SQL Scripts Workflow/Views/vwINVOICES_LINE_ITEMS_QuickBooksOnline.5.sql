
-- 01/27/2015 Paul.  Reduce view name to support Oracle. 
if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwINVOICES_LINE_ITEMS_QuickBooksOnline')
	Drop View dbo.vwINVOICES_LINE_ITEMS_QuickBooksOnline;
GO

