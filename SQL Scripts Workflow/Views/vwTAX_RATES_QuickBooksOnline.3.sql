
-- 01/27/2015 Paul.  Reduce view name to support Oracle. 
if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTAX_RATES_QuickBooksOnline')
	Drop View dbo.vwTAX_RATES_QuickBooksOnline;
GO

