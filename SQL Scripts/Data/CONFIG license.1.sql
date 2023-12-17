

print 'CONFIG License';
GO

set nocount on;
GO

exec dbo.spCONFIG_InsertOnly null, 'system', 'license', '<p>Any use of the contents of this file are subject to the SplendidCRM Source Code License 
Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
using this file, you have unconditionally agreed to the terms and conditions of the License, 
including but not limited to restrictions on the number of users therein, and you may not use this 
file except in compliance with the License. </p>

<p>SplendidCRM owns all proprietary rights, including all copyrights, patents, trade secrets, and 
trademarks, in and to the contents of this file.  You will not link to or in any way combine the 
contents of this file or any derivatives with any Open Source Code in any manner that would require 
the contents of this file to be made available to any third party. </p>

<p>IN NO EVENT SHALL SPLENDIDCRM BE RESPONSIBLE FOR ANY DAMAGES OF ANY KIND, INCLUDING ANY DIRECT, 
SPECIAL, PUNITIVE, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES.  Other limitations of liability 
and disclaimers set forth in the License. </p>
';

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

call dbo.spCONFIG_License()
/

call dbo.spSqlDropProcedure('spCONFIG_License')
/

-- #endif IBM_DB2 */

