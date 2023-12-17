

-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:40 AM.
print 'TERMINOLOGY PaymentGateway en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'PaymentGateway', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GATEWAY'                                   , N'en-US', N'PaymentGateway', null, null, N'Gateway:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GATEWAY_LOGIN'                             , N'en-US', N'PaymentGateway', null, null, N'Login:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GATEWAY_PASSWORD'                          , N'en-US', N'PaymentGateway', null, null, N'Password:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DEFAULT'                              , N'en-US', N'PaymentGateway', null, null, N'Default';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'PaymentGateway', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'PaymentGateway', null, null, N'Payment Gateway List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_GATEWAY'                              , N'en-US', N'PaymentGateway', null, null, N'Gateway';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LOGIN'                                , N'en-US', N'PaymentGateway', null, null, N'Login';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'PaymentGateway', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PASSWORD'                             , N'en-US', N'PaymentGateway', null, null, N'Password';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TEST_MODE'                            , N'en-US', N'PaymentGateway', null, null, N'Test Mode';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LOGIN'                                     , N'en-US', N'PaymentGateway', null, null, N'Login:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'PaymentGateway', null, null, N'Payment Gateways';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'PaymentGateway', null, null, N'PaG';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'PaymentGateway', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PASSWORD'                                  , N'en-US', N'PaymentGateway', null, null, N'Password:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEARCH_FORM_TITLE'                         , N'en-US', N'PaymentGateway', null, null, N'Payment Gateway Search';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_MODE'                                 , N'en-US', N'PaymentGateway', null, null, N'Test Mode:';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_PAYMENT_GATEWAY'                       , N'en-US', N'PaymentGateway', null, null, N'Create Payment Gateway';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_PAYMENT_GATEWAYS'                          , N'en-US', N'PaymentGateway', null, null, N'Payment Gateways';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

Declare
	StoO_selcnt INTEGER := 0;
BEGIN
	BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'PaymentGateway'                                , N'en-US', null, N'moduleList'                        ,  82, N'Payment Gateway';

-- 12/09/2010 Paul.  We have to delete the existing list in order to update it completely. 
if not exists(select * from TERMINOLOGY where LIST_NAME = N'payment_gateway_dom' and NAME = N'FirstData' and DELETED = 0) begin -- then
	delete TERMINOLOGY
	 where LIST_NAME   = N'payment_gateway_dom';
end -- if;

exec dbo.spTERMINOLOGY_InsertOnly N'Amazon'                                        , N'en-US', null, N'payment_gateway_dom'               ,   1, N'Amazon'                ;
exec dbo.spTERMINOLOGY_InsertOnly N'AuthorizeNet'                                  , N'en-US', null, N'payment_gateway_dom'               ,   2, N'AuthorizeNet'          ;
exec dbo.spTERMINOLOGY_InsertOnly N'BankOfAmerica'                                 , N'en-US', null, N'payment_gateway_dom'               ,   3, N'BankOfAmerica'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'Barclays'                                      , N'en-US', null, N'payment_gateway_dom'               ,   4, N'Barclays'              ;
exec dbo.spTERMINOLOGY_InsertOnly N'CyberSource'                                   , N'en-US', null, N'payment_gateway_dom'               ,   5, N'CyberSource'           ;
exec dbo.spTERMINOLOGY_InsertOnly N'Echo'                                          , N'en-US', null, N'payment_gateway_dom'               ,   6, N'Echo'                  ;
exec dbo.spTERMINOLOGY_InsertOnly N'Ecx'                                           , N'en-US', null, N'payment_gateway_dom'               ,   7, N'Ecx'                   ;
exec dbo.spTERMINOLOGY_InsertOnly N'ePoch'                                         , N'en-US', null, N'payment_gateway_dom'               ,   8, N'ePoch'                 ;
exec dbo.spTERMINOLOGY_InsertOnly N'eProcessing'                                   , N'en-US', null, N'payment_gateway_dom'               ,   9, N'eProcessing'           ;
exec dbo.spTERMINOLOGY_InsertOnly N'eSecPayments'                                  , N'en-US', null, N'payment_gateway_dom'               ,  10, N'eSecPayments'          ;
exec dbo.spTERMINOLOGY_InsertOnly N'ElavonNative'                                  , N'en-US', null, N'payment_gateway_dom'               ,  11, N'ElavonNative'          ;
exec dbo.spTERMINOLOGY_InsertOnly N'ElavonViaKlix'                                 , N'en-US', null, N'payment_gateway_dom'               ,  12, N'ElavonViaKlix'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'ElavonVirtualMerchant'                         , N'en-US', null, N'payment_gateway_dom'               ,  13, N'ElavonVirtualMerchant' ;
exec dbo.spTERMINOLOGY_InsertOnly N'FirstData'                                     , N'en-US', null, N'payment_gateway_dom'               ,  14, N'FirstData'             ;
exec dbo.spTERMINOLOGY_InsertOnly N'FirstDataGlobalGateway'                        , N'en-US', null, N'payment_gateway_dom'               ,  15, N'FirstDataGlobalGateway';
exec dbo.spTERMINOLOGY_InsertOnly N'GlobalPayments'                                , N'en-US', null, N'payment_gateway_dom'               ,  16, N'GlobalPayments'        ;
exec dbo.spTERMINOLOGY_InsertOnly N'GoogleCheckout'                                , N'en-US', null, N'payment_gateway_dom'               ,  17, N'GoogleCheckout'        ;
exec dbo.spTERMINOLOGY_InsertOnly N'HSBC'                                          , N'en-US', null, N'payment_gateway_dom'               ,  18, N'HSBC'                  ;
exec dbo.spTERMINOLOGY_InsertOnly N'Innovative'                                    , N'en-US', null, N'payment_gateway_dom'               ,  19, N'Innovative'            ;
exec dbo.spTERMINOLOGY_InsertOnly N'Intellipay'                                    , N'en-US', null, N'payment_gateway_dom'               ,  20, N'Intellipay'            ;
exec dbo.spTERMINOLOGY_InsertOnly N'ioNgate'                                       , N'en-US', null, N'payment_gateway_dom'               ,  21, N'ioNgate'               ;
exec dbo.spTERMINOLOGY_InsertOnly N'Itransact'                                     , N'en-US', null, N'payment_gateway_dom'               ,  22, N'Itransact'             ;
exec dbo.spTERMINOLOGY_InsertOnly N'ItransactXml'                                  , N'en-US', null, N'payment_gateway_dom'               ,  23, N'ItransactXml'          ;
exec dbo.spTERMINOLOGY_InsertOnly N'LinkPoint'                                     , N'en-US', null, N'payment_gateway_dom'               ,  24, N'LinkPoint'             ;
exec dbo.spTERMINOLOGY_InsertOnly N'Mcps'                                          , N'en-US', null, N'payment_gateway_dom'               ,  25, N'Mcps'                  ;
exec dbo.spTERMINOLOGY_InsertOnly N'Moneris'                                       , N'en-US', null, N'payment_gateway_dom'               ,  26, N'Moneris'               ;
exec dbo.spTERMINOLOGY_InsertOnly N'NaviGate'                                      , N'en-US', null, N'payment_gateway_dom'               ,  27, N'NaviGate'              ;
exec dbo.spTERMINOLOGY_InsertOnly N'NetBilling'                                    , N'en-US', null, N'payment_gateway_dom'               ,  28, N'NetBilling'            ;
exec dbo.spTERMINOLOGY_InsertOnly N'Ogone'                                         , N'en-US', null, N'payment_gateway_dom'               ,  29, N'Ogone'                 ;
exec dbo.spTERMINOLOGY_InsertOnly N'OptimalPayment'                                , N'en-US', null, N'payment_gateway_dom'               ,  30, N'OptimalPayment'        ;
exec dbo.spTERMINOLOGY_InsertOnly N'PayCom'                                        , N'en-US', null, N'payment_gateway_dom'               ,  31, N'PayCom'                ;
exec dbo.spTERMINOLOGY_InsertOnly N'PayflowLink'                                   , N'en-US', null, N'payment_gateway_dom'               ,  32, N'PayflowLink'           ;
exec dbo.spTERMINOLOGY_InsertOnly N'PayflowPro'                                    , N'en-US', null, N'payment_gateway_dom'               ,  33, N'PayflowPro'            ;
exec dbo.spTERMINOLOGY_InsertOnly N'PayflowProExpress'                             , N'en-US', null, N'payment_gateway_dom'               ,  34, N'PayflowProExpress'     ;
exec dbo.spTERMINOLOGY_InsertOnly N'PaymentechNative'                              , N'en-US', null, N'payment_gateway_dom'               ,  35, N'PaymentechNative'      ;
exec dbo.spTERMINOLOGY_InsertOnly N'PaymentechOrbital'                             , N'en-US', null, N'payment_gateway_dom'               ,  36, N'PaymentechOrbital'     ;
exec dbo.spTERMINOLOGY_InsertOnly N'PayPal'                                        , N'en-US', null, N'payment_gateway_dom'               ,  37, N'PayPal'                ;
exec dbo.spTERMINOLOGY_InsertOnly N'PayPalPro'                                     , N'en-US', null, N'payment_gateway_dom'               ,  38, N'PayPalPro'             ;
exec dbo.spTERMINOLOGY_InsertOnly N'PayPalProExpress'                              , N'en-US', null, N'payment_gateway_dom'               ,  39, N'PayPalProExpress'      ;
exec dbo.spTERMINOLOGY_InsertOnly N'PayReady'                                      , N'en-US', null, N'payment_gateway_dom'               ,  40, N'PayReady'              ;
exec dbo.spTERMINOLOGY_InsertOnly N'PlanetPayment'                                 , N'en-US', null, N'payment_gateway_dom'               ,  41, N'PlanetPayment'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'PlugnPay'                                      , N'en-US', null, N'payment_gateway_dom'               ,  42, N'PlugnPay'              ;
exec dbo.spTERMINOLOGY_InsertOnly N'PSiGate'                                       , N'en-US', null, N'payment_gateway_dom'               ,  43, N'PSiGate'               ;
exec dbo.spTERMINOLOGY_InsertOnly N'QuickBooks'                                    , N'en-US', null, N'payment_gateway_dom'               ,  44, N'QuickBooks'            ;
exec dbo.spTERMINOLOGY_InsertOnly N'Realex'                                        , N'en-US', null, N'payment_gateway_dom'               ,  45, N'Realex'                ;
exec dbo.spTERMINOLOGY_InsertOnly N'SagePay'                                       , N'en-US', null, N'payment_gateway_dom'               ,  46, N'SagePay'               ;
exec dbo.spTERMINOLOGY_InsertOnly N'SecurePay'                                     , N'en-US', null, N'payment_gateway_dom'               ,  47, N'SecurePay'             ;
exec dbo.spTERMINOLOGY_InsertOnly N'SkipJack'                                      , N'en-US', null, N'payment_gateway_dom'               ,  48, N'SkipJack'              ;
exec dbo.spTERMINOLOGY_InsertOnly N'TrustCommerce'                                 , N'en-US', null, N'payment_gateway_dom'               ,  49, N'TrustCommerce'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'Vital'                                         , N'en-US', null, N'payment_gateway_dom'               ,  50, N'Vital'                 ;
exec dbo.spTERMINOLOGY_InsertOnly N'RbsWorldPay'                                   , N'en-US', null, N'payment_gateway_dom'               ,  51, N'RbsWorldPay'           ;
exec dbo.spTERMINOLOGY_InsertOnly N'Validate'                                      , N'en-US', null, N'payment_gateway_dom'               ,  52, N'Validate'              ;
GO

-- 12/12/2015 Paul.  Change to LibraryPaymentGateways. 
exec dbo.spTERMINOLOGY_InsertOnly N'gwAuthorizeNet'                                , N'en-US', null, N'payment_gateway_nsoftware'         ,   1, N'Authorize.Net AIM'                                        ;  -- http://www.authorize.net 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwEprocessing'                                 , N'en-US', null, N'payment_gateway_nsoftware'         ,   2, N'eProcessing Transparent Database Engine'                  ;  -- http://www.eProcessingNetwork.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwIntellipay'                                  , N'en-US', null, N'payment_gateway_nsoftware'         ,   3, N'Intellipay ExpertLink'                                    ;  -- http://www.intellipay.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwITransact'                                   , N'en-US', null, N'payment_gateway_nsoftware'         ,   4, N'iTransact RediCharge HTML'                                ;  -- http://www.itransact.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwNetBilling'                                  , N'en-US', null, N'payment_gateway_nsoftware'         ,   5, N'NetBilling DirectMode'                                    ;  -- http://www.netbilling.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPayFlowPro'                                  , N'en-US', null, N'payment_gateway_nsoftware'         ,   6, N'Verisign PayFlow Pro'                                     ;  -- https://www.paypal.com/webapps/mpp/payflow-payment-gateway 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwUSAePay'                                     , N'en-US', null, N'payment_gateway_nsoftware'         ,   7, N'USA ePay CGI Transaction Gateway'                         ;  -- http://www.usaepay.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPlugNPay'                                    , N'en-US', null, N'payment_gateway_nsoftware'         ,   8, N'Plug ''n Pay'                                             ;  -- http://www.plugnpay.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPlanetPayment'                               , N'en-US', null, N'payment_gateway_nsoftware'         ,   9, N'Planet Payment iPay'                                      ;  -- http://planetpayment.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwMPCS'                                        , N'en-US', null, N'payment_gateway_nsoftware'         ,  10, N'MPCS'                                                     ;  -- http://merchantcommerce.net/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwRTWare'                                      , N'en-US', null, N'payment_gateway_nsoftware'         ,  11, N'RTWare'                                                   ;  -- http://www.rtware.net/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwECX'                                         , N'en-US', null, N'payment_gateway_nsoftware'         ,  12, N'ECX'                                                      ;  -- http://www.ecx.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwBankOfAmerica'                               , N'en-US', null, N'payment_gateway_nsoftware'         ,  13, N'Bank of America  (Global Gateway e4)'                     ;  -- http://bankofamerica.com/merchantservices 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwInnovative'                                  , N'en-US', null, N'payment_gateway_nsoftware'         ,  14, N'Innovative Gateway'                                       ;  -- http://www.innovativegateway.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwMerchantAnywhere'                            , N'en-US', null, N'payment_gateway_nsoftware'         ,  15, N'Merchant Anywhere (Transaction Central Classic)'          ;  -- http://www.merchantanywhere.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwSkipjack'                                    , N'en-US', null, N'payment_gateway_nsoftware'         ,  16, N'SkipJack'                                                 ;  -- http://www.skipjack.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwIntuitPaymentSolutions'                      , N'en-US', null, N'payment_gateway_nsoftware'         ,  17, N'Intuit Payment Solutions'                                 ;  -- http://payments.intuit.com/ (Formerly called ECHOnline) 
--exec dbo.spTERMINOLOGY_InsertOnly N'gw3DSI'                                        , N'en-US', null, N'payment_gateway_nsoftware'         ,  18, N'3 Delta Systems (3DSI) EC-Linx'                           ;  -- http://www.3dsi.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwTrustCommerce'                               , N'en-US', null, N'payment_gateway_nsoftware'         ,  19, N'TrustCommerce API'                                        ;  -- http://www.trustcommerce.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPSIGate'                                     , N'en-US', null, N'payment_gateway_nsoftware'         ,  20, N'PSIGate HTML'                                             ;  -- http://www.psigate.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPayFuse'                                     , N'en-US', null, N'payment_gateway_nsoftware'         ,  21, N'PayFuse XML (ClearCommerce Engine)'                       ;  -- http://www.firstnationalmerchants.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPayFlowLink'                                 , N'en-US', null, N'payment_gateway_nsoftware'         ,  22, N'PayFlow Link'                                             ;  -- https://www.paypal.com/webapps/mpp/payflow-payment-gateway 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwOrbital'                                     , N'en-US', null, N'payment_gateway_nsoftware'         ,  23, N'Chase Paymentech Orbital Gateway V5.6'                    ;  -- http://www.chasepaymentech.com  
--exec dbo.spTERMINOLOGY_InsertOnly N'gwLinkPoint'                                   , N'en-US', null, N'payment_gateway_nsoftware'         ,  24, N'LinkPoint'                                                ;  -- http://www.linkpoint.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwMoneris'                                     , N'en-US', null, N'payment_gateway_nsoftware'         ,  25, N'Moneris eSelect Plus Canada'                              ;  -- http://www.moneris.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwUSight'                                      , N'en-US', null, N'payment_gateway_nsoftware'         ,  26, N'uSight Gateway Post-Auth'                                 ;
--exec dbo.spTERMINOLOGY_InsertOnly N'gwFastTransact'                                , N'en-US', null, N'payment_gateway_nsoftware'         ,  27, N'Fast Transact VeloCT (Direct Mode)'                       ;  -- http://www.fasttransact.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwNetworkMerchants'                            , N'en-US', null, N'payment_gateway_nsoftware'         ,  28, N'NetworkMerchants Direct-Post API'                         ;  -- http://www.nmi.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwOgone'                                       , N'en-US', null, N'payment_gateway_nsoftware'         ,  29, N'Ogone DirectLink'                                         ;  -- http://www.ogone.be 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPRIGate'                                     , N'en-US', null, N'payment_gateway_nsoftware'         ,  30, N'TransFirst Transaction Central Classic (formerly PRIGate)';  -- http://www.transfirst.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwMerchantPartners'                            , N'en-US', null, N'payment_gateway_nsoftware'         ,  31, N'Merchant Partners (Transaction Engine)'                   ;  -- http://www.merchantpartners.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwCyberCash'                                   , N'en-US', null, N'payment_gateway_nsoftware'         ,  32, N'CyberCash'                                                ;  -- https://www.paypal.com/cybercash 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwFirstData'                                   , N'en-US', null, N'payment_gateway_nsoftware'         ,  33, N'First Data Global Gateway (Linkpoint)'                    ;  -- http://www.firstdata.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwYourPay'                                     , N'en-US', null, N'payment_gateway_nsoftware'         ,  34, N'YourPay (Linkpoint)'                                      ;  -- http://www.yourpay.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwACHPayments'                                 , N'en-US', null, N'payment_gateway_nsoftware'         ,  35, N'ACH Payments AGI'                                         ;  -- http://www.ach-payments.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPaymentsGateway'                             , N'en-US', null, N'payment_gateway_nsoftware'         ,  36, N'Payments Gateway AGI'                                     ;  -- https://www.paymentsgateway.net/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwCyberSource'                                 , N'en-US', null, N'payment_gateway_nsoftware'         ,  37, N'Cyber Source SOAP API'                                    ;  -- http://www.cybersource.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwEway'                                        , N'en-US', null, N'payment_gateway_nsoftware'         ,  38, N'eWay XML API (Australia)'                                 ;  -- http://www.eway.com.au/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwGoEMerchant'                                 , N'en-US', null, N'payment_gateway_nsoftware'         ,  39, N'goEmerchant XML'                                          ;  -- http://www.goemerchant.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwTransFirst'                                  , N'en-US', null, N'payment_gateway_nsoftware'         ,  40, N'TransFirst eLink'                                         ;  -- http://www.transfirst.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwChase'                                       , N'en-US', null, N'payment_gateway_nsoftware'         ,  41, N'Chase Merchant Services (Linkpoint)'                      ;  -- http://www.chase.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwNexCommerce'                                 , N'en-US', null, N'payment_gateway_nsoftware'         ,  42, N'Thompson Merchant Services NexCommerce (iTransact mode)'  ;  -- http://www.thompsonmerchant.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwWorldPay'                                    , N'en-US', null, N'payment_gateway_nsoftware'         ,  43, N'WorldPay Select Junior Invisible'                         ;  -- http://www.worldpay.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwTransactionCentral'                          , N'en-US', null, N'payment_gateway_nsoftware'         ,  44, N'TransFirst Transaction Central Classic'                   ;  -- http://www.transfirst.com. 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwSterling'                                    , N'en-US', null, N'payment_gateway_nsoftware'         ,  45, N'Sterling SPOT XML API'                                    ;  -- http://www.sterlingpayment.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPayJunction'                                 , N'en-US', null, N'payment_gateway_nsoftware'         ,  46, N'PayJunction Trinity Gateway'                              ;  -- http://www.payjunction.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwSECPay'                                      , N'en-US', null, N'payment_gateway_nsoftware'         ,  47, N'SECPay (United Kingdom) API Solution'                     ;  -- http://www.secpay.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPaymentExpress'                              , N'en-US', null, N'payment_gateway_nsoftware'         ,  48, N'Payment Express PXPost'                                   ;  -- http://www.paymentexpress.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwMyVirtualMerchant'                           , N'en-US', null, N'payment_gateway_nsoftware'         ,  49, N'Elavon/NOVA/My Virtual Merchant'                          ;  -- http://www.myvirtualmerchant.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwSagePayments'                                , N'en-US', null, N'payment_gateway_nsoftware'         ,  50, N'Sage Payment Solutions (Bankcard HTTPS Post protocol)'    ;  -- http://www.sagepayments.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwSecurePay'                                   , N'en-US', null, N'payment_gateway_nsoftware'         ,  51, N'SecurePay (Script API/COM Object Interface)'              ;  -- http://securepay.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwMonerisUSA'                                  , N'en-US', null, N'payment_gateway_nsoftware'         ,  52, N'Moneris eSelect Plus USA'                                 ;  -- http://www.moneris.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwBeanstream'                                  , N'en-US', null, N'payment_gateway_nsoftware'         ,  53, N'Beanstream Process Transaction API'                       ;  -- http://beanstream.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwVerifi'                                      , N'en-US', null, N'payment_gateway_nsoftware'         ,  54, N'Verifi Direct-Post API'                                   ;  -- http://www.verifi.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwSagePay'                                     , N'en-US', null, N'payment_gateway_nsoftware'         ,  55, N'SagePay Direct (Previously Protx)'                        ;  -- http://www.sagepay.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwMerchantESolutions'                          , N'en-US', null, N'payment_gateway_nsoftware'         ,  56, N'Merchant E-Solutions Payment Gateway (Trident API)'       ;  -- http://merchante-solutions.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPayLeap'                                     , N'en-US', null, N'payment_gateway_nsoftware'         ,  57, N'PayLeap Web Services API'                                 ;  -- http://www.payleap.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPayPoint'                                    , N'en-US', null, N'payment_gateway_nsoftware'         ,  58, N'PayPoint.net (Previously SECPay) API Solution'            ;  -- http://paypoint.net 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwWorldPayXML'                                 , N'en-US', null, N'payment_gateway_nsoftware'         ,  59, N'Worldpay XML (Direct/Invisible)'                          ;  -- http://www.worldpay.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwProPay'                                      , N'en-US', null, N'payment_gateway_nsoftware'         ,  60, N'ProPay Merchant Services API'                             ;  -- http://www.propay.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwQBMS'                                        , N'en-US', null, N'payment_gateway_nsoftware'         ,  61, N'Intuit QuickBooks Merchant Services'                      ;  -- http://payments.intuit.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwHeartland'                                   , N'en-US', null, N'payment_gateway_nsoftware'         ,  62, N'Heartland POS Gateway'                                    ;  -- http://www.heartlandpaymentsystems.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwLitle'                                       , N'en-US', null, N'payment_gateway_nsoftware'         ,  63, N'Litle Online Gateway'                                     ;  -- http://www.litle.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwBrainTree'                                   , N'en-US', null, N'payment_gateway_nsoftware'         ,  64, N'BrainTree DirectPost (Server-to-Server Orange) Gateway'   ;  -- http://www.braintreepaymentsolutions.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwJetPay'                                      , N'en-US', null, N'payment_gateway_nsoftware'         ,  65, N'JetPay Gateway'                                           ;  -- http://www.jetpay.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwHSBC'                                        , N'en-US', null, N'payment_gateway_nsoftware'         ,  66, N'HSBC XML API (ClearCommerce Engine)'                      ;  -- http://www.business.hsbc.co.uk/1/2/business-banking/business-payment-processing/business-debit-and-credit-card-processing 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwBluePay'                                     , N'en-US', null, N'payment_gateway_nsoftware'         ,  67, N'BluePay 2.0 Post'                                         ;  -- http://www.bluepay.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwAdyen'                                       , N'en-US', null, N'payment_gateway_nsoftware'         ,  68, N'Adyen API Payments'                                       ;  -- http://www.adyen.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwBarclay'                                     , N'en-US', null, N'payment_gateway_nsoftware'         ,  69, N'Barclay ePDQ (DirectLink)'                                ;  -- http://www.barclaycard.co.uk/business/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPayTrace'                                    , N'en-US', null, N'payment_gateway_nsoftware'         ,  70, N'PayTrace Payment Gateway'                                 ;  -- http://www.paytrace.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwYKC'                                         , N'en-US', null, N'payment_gateway_nsoftware'         ,  71, N'YKC Gateway'                                              ;  -- http://www.ykc-bos.co.jp/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwCyberbit'                                    , N'en-US', null, N'payment_gateway_nsoftware'         ,  72, N'Cyberbit Gateway'                                         ;
--exec dbo.spTERMINOLOGY_InsertOnly N'gwGoToBilling'                                 , N'en-US', null, N'payment_gateway_nsoftware'         ,  73, N'GoToBilling Gateway'                                      ;  -- http://www.gotobilling.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwTransNationalBankcard'                       , N'en-US', null, N'payment_gateway_nsoftware'         ,  74, N'TransNational Bankcard'                                   ;  -- http://www.tnbci.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwNetbanx'                                     , N'en-US', null, N'payment_gateway_nsoftware'         ,  75, N'Netbanx'                                                  ;  -- http://www.netbanx.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwMIT'                                         , N'en-US', null, N'payment_gateway_nsoftware'         ,  76, N'MIT'                                                      ;  -- http://www.centrodepagos.com.mx 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwDataCash'                                    , N'en-US', null, N'payment_gateway_nsoftware'         ,  77, N'DataCash'                                                 ;  -- http://www.datacash.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwACHFederal'                                  , N'en-US', null, N'payment_gateway_nsoftware'         ,  78, N'ACH Federal'                                              ;  -- http://www.achfederal.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwGlobalIris'                                  , N'en-US', null, N'payment_gateway_nsoftware'         ,  79, N'Global Iris (HSBC)'                                       ;  -- http://www.globalpaymentsinc.com/UK/customerSupport/globaliris.html 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwFirstDataE4'                                 , N'en-US', null, N'payment_gateway_nsoftware'         ,  80, N'First Data Global Gateway E4'                             ;  -- http://www.firstdata.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwFirstAtlantic'                               , N'en-US', null, N'payment_gateway_nsoftware'         ,  81, N'First Atlantic Commerce'                                  ;  -- http://www.firstatlanticcommerce.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwBluefin'                                     , N'en-US', null, N'payment_gateway_nsoftware'         ,  82, N'Bluefin'                                                  ;  -- http://www.bluefin.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPayscape'                                    , N'en-US', null, N'payment_gateway_nsoftware'         ,  83, N'Payscape'                                                 ;  -- http://www.payscape.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPayDirect'                                   , N'en-US', null, N'payment_gateway_nsoftware'         ,  84, N'Pay Direct (Link2Gov)'                                    ;  -- http://www.fisglobal.com/products-government-governmentpayments 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwAuthorizeNetCIM'                             , N'en-US', null, N'payment_gateway_nsoftware'         ,  85, N'Authorize.NET CIM'                                        ;  -- http://www.authorize.net 
--exec dbo.spTERMINOLOGY_InsertOnly N'gw5thDimension'                                , N'en-US', null, N'payment_gateway_nsoftware'         ,  86, N'5th Dimension Logistics'                                  ;  -- http://www.5thdl.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwWorldPayLink'                                , N'en-US', null, N'payment_gateway_nsoftware'         ,  87, N'WorldPay US Link Gateway'                                 ;  -- http://www.worldpay.com/us 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPaymentWorkSuite'                            , N'en-US', null, N'payment_gateway_nsoftware'         ,  88, N'3DSI Payment WorkSuite'                                   ;  -- http://www.3dsi.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPSIGateXML'                                  , N'en-US', null, N'payment_gateway_nsoftware'         ,  89, N'PSIGate XML'                                              ;  -- http://www.psigate.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwFirstDataPayPoint'                           , N'en-US', null, N'payment_gateway_nsoftware'         ,  90, N'First Data PayPoint'                                      ;  -- https://www.firstdata.com/en_us/customer-center/financial-institutions/paypoint.html 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwExPay'                                       , N'en-US', null, N'payment_gateway_nsoftware'         ,  91, N'ExPay Gateway'                                            ;  -- http://www.expay.asia 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPayvision'                                   , N'en-US', null, N'payment_gateway_nsoftware'         ,  92, N'Payvision Gateway'                                        ;  -- http://www.payvision.com/ 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwConverge'                                    , N'en-US', null, N'payment_gateway_nsoftware'         ,  93, N'Converge (formerly MyVirtualMerchant)'                    ;  -- http://www.myvirtualmerchant.com 
--exec dbo.spTERMINOLOGY_InsertOnly N'gwPayeezy'                                     , N'en-US', null, N'payment_gateway_nsoftware'         ,  94, N'Payeezy Gateway (formerly First Data E4)'                 ;  -- https://www.payeezy.com 

-- 12/16/2015 Paul.  We have to add support manually as we must manually handle the creation of the customer profile. 
delete from TERMINOLOGY
 where LIST_NAME = N'payment_gateway_nsoftware'
   and NAME not in ('gwAuthorizeNet');
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

call dbo.spTERMINOLOGY_PaymentGateway_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_PaymentGateway_en_us')
/
-- #endif IBM_DB2 */
