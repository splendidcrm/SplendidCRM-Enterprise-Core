if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwOPPORTUNITIES_List')
	Drop View dbo.vwOPPORTUNITIES_List;
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
-- 08/12/2021 Paul.  Add Machine Learning prediction fields. 
Create View dbo.vwOPPORTUNITIES_List
as
select vwOPPORTUNITIES.*
     , OPPORTUNITIES_PREDICTIONS.PROBABILITY AS ML_PROBABILITY
     , OPPORTUNITIES_PREDICTIONS.SCORE
     , OPPORTUNITIES_PREDICTIONS.PREDICTION
  from vwOPPORTUNITIES
  left outer join OPPORTUNITIES_PREDICTIONS
               on OPPORTUNITIES_PREDICTIONS.OPPORTUNITY_ID = vwOPPORTUNITIES.ID
              and OPPORTUNITIES_PREDICTIONS.DELETED        = 0

GO

Grant Select on dbo.vwOPPORTUNITIES_List to public;
GO


