
-- 01/27/2015 Paul.  Reduce view name to support Oracle. 
if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPRODUCT_TEMPLATES_QuickBooksOnline')
	Drop View dbo.vwPRODUCT_TEMPLATES_QuickBooksOnline;
GO

