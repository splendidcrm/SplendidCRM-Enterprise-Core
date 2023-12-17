
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
-- 04/19/2010 Paul.  The foreign key should have been dropped long ago. The PRODUCT_ID will point to the ORDERS_LINE_ITEMS table. 
if exists(select * from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS where CONSTRAINT_NAME = 'FK_CONTRACTS_PRODUCTS_PRODUCT_ID') begin -- then
	print 'alter table CONTRACTS_PRODUCTS drop constraint FK_CONTRACTS_PRODUCTS_PRODUCT_ID;';

	alter table CONTRACTS_PRODUCTS drop constraint FK_CONTRACTS_PRODUCTS_PRODUCT_ID;
end -- if;
GO

