
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
exec dbo.spSqlUpdateIndex 'IDX_ACCOUNTS_THREADS_ACCOUNT_ID'                       , 'ACCOUNTS_THREADS'               , 'ACCOUNT_ID'         , 'DELETED'      , 'THREAD_ID'           ;
exec dbo.spSqlUpdateIndex 'IDX_ACCOUNTS_THREADS_THREAD_ID'                        , 'ACCOUNTS_THREADS'               , 'THREAD_ID'          , 'DELETED'      , 'ACCOUNT_ID'          ;
exec dbo.spSqlUpdateIndex 'IDX_BUGS_THREADS_BUG_ID'                               , 'BUGS_THREADS'                   , 'BUG_ID'             , 'DELETED'      , 'THREAD_ID'           ;
exec dbo.spSqlUpdateIndex 'IDX_BUGS_THREADS_THREAD_ID'                            , 'BUGS_THREADS'                   , 'THREAD_ID'          , 'DELETED'      , 'BUG_ID'              ;
exec dbo.spSqlUpdateIndex 'IDX_CASES_THREADS_CASE_ID'                             , 'CASES_THREADS'                  , 'CASE_ID'            , 'DELETED'      , 'THREAD_ID'           ;
exec dbo.spSqlUpdateIndex 'IDX_CASES_THREADS_THREAD_ID'                           , 'CASES_THREADS'                  , 'THREAD_ID'          , 'DELETED'      , 'CASE_ID'             ;
exec dbo.spSqlUpdateIndex 'IDX_CONTRACT_TYPES_DOCUMENTS_CONTRACT_TYPE_ID'         , 'CONTRACT_TYPES_DOCUMENTS'       , 'CONTRACT_TYPE_ID'   , 'DELETED'      , 'DOCUMENT_ID'         ;
exec dbo.spSqlUpdateIndex 'IDX_CONTRACT_TYPES_DOCUMENTS_DOCUMENT_ID'              , 'CONTRACT_TYPES_DOCUMENTS'       , 'DOCUMENT_ID'        , 'DELETED'      , 'CONTRACT_TYPE_ID'    ;
exec dbo.spSqlUpdateIndex 'IDX_CONTRACTS_CONTACTS_CONTRACT_ID'                    , 'CONTRACTS_CONTACTS'             , 'CONTRACT_ID'        , 'DELETED'      , 'CONTACT_ID'          ;
exec dbo.spSqlUpdateIndex 'IDX_CONTRACTS_CONTACTS_CONTACT_ID'                     , 'CONTRACTS_CONTACTS'             , 'CONTACT_ID'         , 'DELETED'      , 'CONTRACT_ID'         ;
exec dbo.spSqlUpdateIndex 'IDX_CONTRACTS_DOCUMENTS_CONTRACT_ID'                   , 'CONTRACTS_DOCUMENTS'            , 'CONTRACT_ID'        , 'DELETED'      , 'DOCUMENT_ID'         , 'DOCUMENT_REVISION_ID';
exec dbo.spSqlUpdateIndex 'IDX_CONTRACTS_DOCUMENTS_DOCUMENT_ID'                   , 'CONTRACTS_DOCUMENTS'            , 'DOCUMENT_ID'        , 'DELETED'      , 'CONTRACT_ID'         ;
exec dbo.spSqlUpdateIndex 'IDX_CONTRACTS_OPPORTUNITIES_CONTRACT_ID'               , 'CONTRACTS_OPPORTUNITIES'        , 'CONTRACT_ID'        , 'DELETED'      , 'OPPORTUNITY_ID'      ;
exec dbo.spSqlUpdateIndex 'IDX_CONTRACTS_OPPORTUNITIES_OPPORTUNITY_ID'            , 'CONTRACTS_OPPORTUNITIES'        , 'OPPORTUNITY_ID'     , 'DELETED'      , 'CONTRACT_ID'         ;
exec dbo.spSqlUpdateIndex 'IDX_CONTRACTS_PRODUCTS_CONTRACT_ID'                    , 'CONTRACTS_PRODUCTS'             , 'CONTRACT_ID'        , 'DELETED'      , 'PRODUCT_ID'          ;
exec dbo.spSqlUpdateIndex 'IDX_CONTRACTS_PRODUCTS_PRODUCT_ID'                     , 'CONTRACTS_PRODUCTS'             , 'PRODUCT_ID'         , 'DELETED'      , 'CONTRACT_ID'         ;
exec dbo.spSqlUpdateIndex 'IDX_CONTRACTS_QUOTES_CONTRACT_ID'                      , 'CONTRACTS_QUOTES'               , 'CONTRACT_ID'        , 'DELETED'      , 'QUOTE_ID'            ;
exec dbo.spSqlUpdateIndex 'IDX_CONTRACTS_QUOTES_QUOTE_ID'                         , 'CONTRACTS_QUOTES'               , 'QUOTE_ID'           , 'DELETED'      , 'CONTRACT_ID'         ;
exec dbo.spSqlUpdateIndex 'IDX_EMAILS_CONTRACTS_EMAIL_ID'                         , 'EMAILS_CONTRACTS'               , 'EMAIL_ID'           , 'DELETED'      , 'CONTRACT_ID'         ;
exec dbo.spSqlUpdateIndex 'IDX_EMAILS_CONTRACTS_CONTRACT_ID'                      , 'EMAILS_CONTRACTS'               , 'CONTRACT_ID'        , 'DELETED'      , 'EMAIL_ID'            ;
exec dbo.spSqlUpdateIndex 'IDX_EMAILS_QUOTES_EMAIL_ID'                            , 'EMAILS_QUOTES'                  , 'EMAIL_ID'           , 'DELETED'      , 'QUOTE_ID'            ;
exec dbo.spSqlUpdateIndex 'IDX_EMAILS_QUOTES_QUOTE_ID'                            , 'EMAILS_QUOTES'                  , 'QUOTE_ID'           , 'DELETED'      , 'EMAIL_ID'            ;
exec dbo.spSqlUpdateIndex 'IDX_FORECASTS_OPPORTUNITIES_FORECAST_ID'               , 'FORECASTS_OPPORTUNITIES'        , 'FORECAST_ID'        , 'DELETED'      , 'OPPORTUNITY_ID'      ;
exec dbo.spSqlUpdateIndex 'IDX_FORECASTS_OPPORTUNITIES_OPPORTUNITY_ID'            , 'FORECASTS_OPPORTUNITIES'        , 'OPPORTUNITY_ID'     , 'DELETED'      , 'FORECAST_ID'         ;
exec dbo.spSqlUpdateIndex 'IDX_INVOICES_ACCOUNTS_INVOICE_ID'                      , 'INVOICES_ACCOUNTS'              , 'INVOICE_ID'         , 'ACCOUNT_ROLE' , 'DELETED'             , 'ACCOUNT_ID'          ;
exec dbo.spSqlUpdateIndex 'IDX_INVOICES_ACCOUNTS_ACCOUNT_ID'                      , 'INVOICES_ACCOUNTS'              , 'ACCOUNT_ID'         , 'ACCOUNT_ROLE' , 'DELETED'             , 'INVOICE_ID'          ;
exec dbo.spSqlUpdateIndex 'IDX_INVOICES_CONTACTS_INVOICE_ID'                      , 'INVOICES_CONTACTS'              , 'INVOICE_ID'         , 'CONTACT_ROLE' , 'DELETED'             , 'CONTACT_ID'          ;
exec dbo.spSqlUpdateIndex 'IDX_INVOICES_CONTACTS_CONTACT_ID'                      , 'INVOICES_CONTACTS'              , 'CONTACT_ID'         , 'CONTACT_ROLE' , 'DELETED'             , 'INVOICE_ID'          ;
exec dbo.spSqlUpdateIndex 'IDX_INVOICES_PAYMENTS_INVOICE_ID'                      , 'INVOICES_PAYMENTS'              , 'INVOICE_ID'         , 'DELETED'      , 'PAYMENT_ID'          ;
exec dbo.spSqlUpdateIndex 'IDX_INVOICES_PAYMENTS_PAYMENT_ID'                      , 'INVOICES_PAYMENTS'              , 'PAYMENT_ID'         , 'DELETED'      , 'INVOICE_ID'          ;
exec dbo.spSqlUpdateIndex 'IDX_LEADS_THREADS_LEAD_ID'                             , 'LEADS_THREADS'                  , 'LEAD_ID'            , 'DELETED'      , 'THREAD_ID'           ;
exec dbo.spSqlUpdateIndex 'IDX_LEADS_THREADS_THREAD_ID'                           , 'LEADS_THREADS'                  , 'THREAD_ID'          , 'DELETED'      , 'LEAD_ID'             ;
exec dbo.spSqlUpdateIndex 'IDX_OPPORTUNITIES_THREADS_THREAD_ID'                   , 'OPPORTUNITIES_THREADS'          , 'THREAD_ID'          , 'DELETED'      , 'OPPORTUNITY_ID'      ;
exec dbo.spSqlUpdateIndex 'IDX_OPPORTUNITIES_THREADS_OPPORTUNITY_ID'              , 'OPPORTUNITIES_THREADS'          , 'OPPORTUNITY_ID'     , 'DELETED'      , 'THREAD_ID'           ;
exec dbo.spSqlUpdateIndex 'IDX_ORDERS_ACCOUNTS_ORDER_ID'                          , 'ORDERS_ACCOUNTS'                , 'ORDER_ID'           , 'ACCOUNT_ROLE' , 'DELETED'             , 'ACCOUNT_ID'          ;
exec dbo.spSqlUpdateIndex 'IDX_ORDERS_ACCOUNTS_ACCOUNT_ID'                        , 'ORDERS_ACCOUNTS'                , 'ACCOUNT_ID'         , 'ACCOUNT_ROLE' , 'DELETED'             , 'ORDER_ID'            ;
exec dbo.spSqlUpdateIndex 'IDX_ORDERS_CONTACTS_ORDER_ID'                          , 'ORDERS_CONTACTS'                , 'ORDER_ID'           , 'CONTACT_ROLE' , 'DELETED'             , 'CONTACT_ID'          ;
exec dbo.spSqlUpdateIndex 'IDX_ORDERS_CONTACTS_CONTACT_ID'                        , 'ORDERS_CONTACTS'                , 'CONTACT_ID'         , 'CONTACT_ROLE' , 'DELETED'             , 'ORDER_ID'            ;
exec dbo.spSqlUpdateIndex 'IDX_ORDERS_OPPORTUNITIES_ORDER_ID'                     , 'ORDERS_OPPORTUNITIES'           , 'ORDER_ID'           , 'DELETED'      , 'OPPORTUNITY_ID'      ;
exec dbo.spSqlUpdateIndex 'IDX_ORDERS_OPPORTUNITIES_OPPORTUNITY_ID'               , 'ORDERS_OPPORTUNITIES'           , 'OPPORTUNITY_ID'     , 'DELETED'      , 'ORDER_ID'            ;
exec dbo.spSqlUpdateIndex 'IDX_PRODUCT_BUNDLE_QUOTE_BUNDLE_ID'                    , 'PRODUCT_BUNDLE_QUOTE'           , 'BUNDLE_ID'          , 'DELETED'      , 'QUOTE_ID'            ;
exec dbo.spSqlUpdateIndex 'IDX_PRODUCT_BUNDLE_QUOTE_QUOTE_ID'                     , 'PRODUCT_BUNDLE_QUOTE'           , 'QUOTE_ID'           , 'DELETED'      , 'BUNDLE_ID'           ;
exec dbo.spSqlUpdateIndex 'IDX_PRODUCT_PRODUCT_PARENT_ID'                         , 'PRODUCT_PRODUCT'                , 'PARENT_ID'          , 'DELETED'      , 'CHILD_ID'            ;
exec dbo.spSqlUpdateIndex 'IDX_PRODUCT_PRODUCT_CHILD_ID'                          , 'PRODUCT_PRODUCT'                , 'CHILD_ID'           , 'DELETED'      , 'PARENT_ID'           ;
exec dbo.spSqlUpdateIndex 'IDX_PROJECT_THREADS_PROJECT_ID'                        , 'PROJECT_THREADS'                , 'PROJECT_ID'         , 'DELETED'      , 'THREAD_ID'           ;
exec dbo.spSqlUpdateIndex 'IDX_PROJECT_THREADS_THREAD_ID'                         , 'PROJECT_THREADS'                , 'THREAD_ID'          , 'DELETED'      , 'PROJECT_ID'          ;
exec dbo.spSqlUpdateIndex 'IDX_QUOTES_ACCOUNTS_QUOTE_ID'                          , 'QUOTES_ACCOUNTS'                , 'QUOTE_ID'           , 'ACCOUNT_ROLE' , 'DELETED'             , 'ACCOUNT_ID'          ;
exec dbo.spSqlUpdateIndex 'IDX_QUOTES_ACCOUNTS_ACCOUNT_ID'                        , 'QUOTES_ACCOUNTS'                , 'ACCOUNT_ID'         , 'ACCOUNT_ROLE' , 'DELETED'             , 'QUOTE_ID'            ;
exec dbo.spSqlUpdateIndex 'IDX_QUOTES_CONTACTS_QUOTE_ID'                          , 'QUOTES_CONTACTS'                , 'QUOTE_ID'           , 'CONTACT_ROLE' , 'DELETED'             , 'CONTACT_ID'          ;
exec dbo.spSqlUpdateIndex 'IDX_QUOTES_CONTACTS_CONTACT_ID'                        , 'QUOTES_CONTACTS'                , 'CONTACT_ID'         , 'CONTACT_ROLE' , 'DELETED'             , 'QUOTE_ID'            ;
exec dbo.spSqlUpdateIndex 'IDX_QUOTES_OPPORTUNITIES_QUOTE_ID'                     , 'QUOTES_OPPORTUNITIES'           , 'QUOTE_ID'           , 'DELETED'      , 'OPPORTUNITY_ID'      ;
exec dbo.spSqlUpdateIndex 'IDX_QUOTES_OPPORTUNITIES_OPPORTUNITY_ID'               , 'QUOTES_OPPORTUNITIES'           , 'OPPORTUNITY_ID'     , 'DELETED'      , 'QUOTE_ID'            ;
exec dbo.spSqlUpdateIndex 'IDX_TEAM_MEMBERSHIPS_TEAM_ID'                          , 'TEAM_MEMBERSHIPS'               , 'TEAM_ID'            , 'DELETED'      , 'USER_ID'             , 'ID'                  ;
exec dbo.spSqlUpdateIndex 'IDX_TEAM_MEMBERSHIPS_USER_ID'                          , 'TEAM_MEMBERSHIPS'               , 'USER_ID'            , 'DELETED'      , 'TEAM_ID'             , 'ID'                  , 'PRIVATE'      ;
GO

