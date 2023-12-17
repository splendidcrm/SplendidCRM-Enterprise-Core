

print 'DATA_PRIVACY_FIELDS Defaults';
GO

-- delete from DATA_PRIVACY_FIELDS;
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Accounts', 'EMAIL1';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Accounts', 'EMAIL2';
GO

exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'SALUTATION';
-- 06/30/2018 Paul.  Include the name field so that it can be treated as erased in the ListView. 
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'NAME';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'FIRST_NAME';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'LAST_NAME';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'TITLE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'REFERED_BY';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'BIRTHDATE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'PHONE_HOME';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'PHONE_MOBILE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'PHONE_WORK';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'PHONE_OTHER';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'PHONE_FAX';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'EMAIL1';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'EMAIL2';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'ASSISTANT';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'ASSISTANT_PHONE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'WEBSITE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'TWITTER_SCREEN_NAME';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'PRIMARY_ADDRESS_STREET';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'PRIMARY_ADDRESS_CITY';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'PRIMARY_ADDRESS_STATE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'PRIMARY_ADDRESS_POSTALCODE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'PRIMARY_ADDRESS_COUNTRY';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'ALT_ADDRESS_STREET';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'ALT_ADDRESS_CITY';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'ALT_ADDRESS_STATE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'ALT_ADDRESS_POSTALCODE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Contacts', 'ALT_ADDRESS_COUNTRY';
GO

exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'SALUTATION';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'NAME';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'FIRST_NAME';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'LAST_NAME';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'TITLE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'REFERED_BY';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'BIRTHDATE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'PHONE_HOME';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'PHONE_MOBILE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'PHONE_WORK';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'PHONE_OTHER';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'PHONE_FAX';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'EMAIL1';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'EMAIL2';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'ASSISTANT';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'ASSISTANT_PHONE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'WEBSITE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'TWITTER_SCREEN_NAME';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'PRIMARY_ADDRESS_STREET';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'PRIMARY_ADDRESS_CITY';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'PRIMARY_ADDRESS_STATE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'PRIMARY_ADDRESS_POSTALCODE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'PRIMARY_ADDRESS_COUNTRY';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'ALT_ADDRESS_STREET';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'ALT_ADDRESS_CITY';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'ALT_ADDRESS_STATE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'ALT_ADDRESS_POSTALCODE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Leads', 'ALT_ADDRESS_COUNTRY';
GO

exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'SALUTATION';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'NAME';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'FIRST_NAME';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'LAST_NAME';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'TITLE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'REFERED_BY';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'BIRTHDATE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'PHONE_HOME';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'PHONE_MOBILE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'PHONE_WORK';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'PHONE_OTHER';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'PHONE_FAX';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'EMAIL1';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'EMAIL2';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'ASSISTANT';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'ASSISTANT_PHONE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'WEBSITE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'TWITTER_SCREEN_NAME';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'PRIMARY_ADDRESS_STREET';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'PRIMARY_ADDRESS_CITY';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'PRIMARY_ADDRESS_STATE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'PRIMARY_ADDRESS_POSTALCODE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'PRIMARY_ADDRESS_COUNTRY';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'ALT_ADDRESS_STREET';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'ALT_ADDRESS_CITY';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'ALT_ADDRESS_STATE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'ALT_ADDRESS_POSTALCODE';
exec dbo.spDATA_PRIVACY_FIELDS_InsertOnly null, 'Prospects', 'ALT_ADDRESS_COUNTRY';
GO

set nocount on;
GO

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

call dbo.spDATA_PRIVACY_FIELDS_Defaults()
/

call dbo.spSqlDropProcedure('spDATA_PRIVACY_FIELDS_Defaults')
/

-- #endif IBM_DB2 */

