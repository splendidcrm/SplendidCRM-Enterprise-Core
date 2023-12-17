
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
-- 05/29/2008 Paul.  CARD_NAME will be NULL when transaction originates from PayPal. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS_TRANSACTIONS' and COLUMN_NAME = 'CARD_NAME' and IS_NULLABLE = 'NO') begin -- then
	print 'alter table PAYMENTS_TRANSACTIONS alter column CARD_NAME nvarchar(150) null';
	alter table PAYMENTS_TRANSACTIONS alter column CARD_NAME nvarchar(150) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS_TRANSACTIONS' and COLUMN_NAME = 'CARD_TYPE' and IS_NULLABLE = 'NO') begin -- then
	print 'alter table PAYMENTS_TRANSACTIONS alter column CARD_TYPE nvarchar(25) null';
	alter table PAYMENTS_TRANSACTIONS alter column CARD_TYPE nvarchar(25) null;
end -- if;
GO

-- 12/12/2015 Paul.  Need to increase PAYMENT_GATEWAY to allow for combined Gateway and Login. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS_TRANSACTIONS' and COLUMN_NAME = 'PAYMENT_GATEWAY' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table PAYMENTS_TRANSACTIONS alter column PAYMENT_GATEWAY nvarchar(100) null';
	alter table PAYMENTS_TRANSACTIONS alter column PAYMENT_GATEWAY nvarchar(100) null;
end -- if;
GO

