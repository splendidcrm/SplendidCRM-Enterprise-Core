

-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:36 AM.
print 'TERMINOLOGY Discounts en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'ERR_DISCOUNT_NOT_FOUND'                        , N'en-US', N'Discounts', null, null, N'Discount Not Found.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'Discounts', null, null, N'Discount List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'Discounts', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PRICING_FACTOR'                       , N'en-US', N'Discounts', null, null, N'Pricing Factor';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PRICING_FORMULA'                      , N'en-US', N'Discounts', null, null, N'Pricing Formular';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'Discounts', null, null, N'Discounts';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'Discounts', null, null, N'Dis';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'Discounts', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEW_FORM_TITLE'                            , N'en-US', N'Discounts', null, null, N'Create Discount';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PERCENTAGE'                                , N'en-US', N'Discounts', null, null, N'Percentage(%)';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_POINTS'                                    , N'en-US', N'Discounts', null, null, N'Points';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRICING_FACTOR'                            , N'en-US', N'Discounts', null, null, N'Pricing Factor:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRICING_FACTOR_DESC'                       , N'en-US', N'Discounts', null, null, N'This value will be a currency for a Fixed Discount.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRICING_FORMULA'                           , N'en-US', N'Discounts', null, null, N'Pricing Formula:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRICING_FORMULA_DESC'                      , N'en-US', N'Discounts', null, null, N'';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_DISCOUNT_LIST'                             , N'en-US', N'Discounts', null, null, N'Discounts';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_DISCOUNT'                              , N'en-US', N'Discounts', null, null, N'Create Discount';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'Discounts'                                     , N'en-US', null, N'moduleList'                        ,  93, N'Discounts';
GO


set nocount off;
GO

/* -- #if Oracle
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spTERMINOLOGY_Discounts_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Discounts_en_us')
/
-- #endif IBM_DB2 */
