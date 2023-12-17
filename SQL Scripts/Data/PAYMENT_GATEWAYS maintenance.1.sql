

print 'PAYMENT_GATEWAYS Maintenance';
GO

set nocount on;
GO


-- 12/12/2015 Paul.  Change to LibraryPaymentGateways. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'PaymentGateway.Library'   , 'dotnetCharge';
-- exec dbo.spCONFIG_InsertOnly null, 'system', 'PaymentGateway.Library'   , 'nsoftware.InPayWeb';
GO

-- select * from vwCONFIG where NAME like 'PaymentGateway%'
-- delete from PAYMENT_GATEWAYS;
if not exists(select * from vwPAYMENT_GATEWAYS) begin -- then
	if exists(select * from vwCONFIG where NAME = 'PaymentGateway' and VALUE is not null) begin -- then
		if exists(select * from vwCONFIG where NAME = 'PaymentGateway_Login' and VALUE is not null) begin -- then
			print 'PAYMENT_GATEWAYS: Adding existing default Payment Gateway to table. ';
			declare @ID                uniqueidentifier;
			declare @MODIFIED_USED_ID  uniqueidentifier;
			declare @NAME              nvarchar(50);
			declare @GATEWAY           nvarchar(25);
			declare @LOGIN             nvarchar(50);
			declare @PASSWORD          nvarchar(100);
			declare @TEST_MODE         bit;
			declare @DESCRIPTION       nvarchar(max);
			declare @ID_TEXT           nvarchar(36);
			set @NAME      = dbo.fnCONFIG_String ('PaymentGateway'         ) -- @NAME
			set @GATEWAY   = dbo.fnCONFIG_String ('PaymentGateway'         ) -- GATEWAY
			set @LOGIN     = dbo.fnCONFIG_String ('PaymentGateway_Login'   ) -- @LOGIN
			set @PASSWORD  = dbo.fnCONFIG_String ('PaymentGateway_Password') -- @PASSWORD
			set @TEST_MODE = dbo.fnCONFIG_Boolean('PaymentGateway_TestMode') -- @TEST_MODE
			exec dbo.spPAYMENT_GATEWAYS_Update @ID out, @MODIFIED_USED_ID, @NAME, @GATEWAY, @LOGIN, @PASSWORD, @TEST_MODE, @DESCRIPTION;
			set @ID_TEXT = cast(@ID as char(36));
			exec dbo.spCONFIG_InsertOnly null, 'system', 'PaymentGateway_ID', @ID_TEXT;
		end -- if;
	end -- if;
end -- if;
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

call dbo.spPAYMENT_GATEWAYS_Maintenance()
/

call dbo.spSqlDropProcedure('spPAYMENT_GATEWAYS_Maintenance')
/

-- #endif IBM_DB2 */

