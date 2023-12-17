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
 * IN NO EVENT SHALL SPLENDIDCRM BE RESPONSIBLE FOR ANY DAMAGES OF ANY KIND, INCLUDING ANY DIRECT, 
 * SPECIAL, PUNITIVE, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES.  Other limitations of liability 
 * and disclaimers set forth in the License. 
 * 
 *********************************************************************************************************************/
using System;
using System.Collections.Generic;
using Spring.Json;
using Spring.Rest.Client;
using Spring.Social.OAuth1;
using Spring.Http.Converters;
using Spring.Http.Converters.Json;
using Spring.Http.Converters.Xml;
using Spring.Social.QuickBooks.Api.Impl.Json;

namespace Spring.Social.QuickBooks.Api.Impl
{
	public class QuickBooksTemplate : AbstractOAuth1ApiBinding, IQuickBooks
	{
		private static readonly Uri API_URI_BASE = new Uri("https://qb.sbfinance.intuit.com/v3/"); // ("https://quickbooks.api.intuit.com/v3");

		public IAccountOperations       accountOperations      ;
		public ICustomerOperations      customerOperations     ;
		public IEstimateOperations      estimateOperations     ;
		public IInvoiceOperations       invoiceOperations      ;
		public ISalesOrderOperations    salesOrderOperations   ;
		public IPaymentOperations       paymentOperations      ;
		public ICreditMemoOperations    creditMemoOperations   ;
		public IItemOperations          itemOperations         ;
		public IShipMethodOperations    shipMethodOperations   ;
		public ITaxRateOperations       taxRateOperations      ;
		public ITaxCodeOperations       taxCodeOperations      ;
		public IPaymentMethodOperations paymentMethodOperations;
		public ITermOperations          termOperations         ;

		public QuickBooksTemplate(string consumerKey, string consumerSecret, string accessToken, string accessTokenSecret, string companyId) : base(consumerKey, consumerSecret, accessToken, accessTokenSecret)
		{
			this.accountOperations       = new AccountTemplate      (this.RestTemplate, companyId);
			this.customerOperations      = new CustomerTemplate     (this.RestTemplate, companyId);
			this.estimateOperations      = new EstimateTemplate     (this.RestTemplate, companyId);
			this.invoiceOperations       = new InvoiceTemplate      (this.RestTemplate, companyId);
			this.salesOrderOperations    = new SalesOrderTemplate   (this.RestTemplate, companyId);
			this.paymentOperations       = new PaymentTemplate      (this.RestTemplate, companyId);
			this.creditMemoOperations    = new CreditMemoTemplate   (this.RestTemplate, companyId);
			this.itemOperations          = new ItemTemplate         (this.RestTemplate, companyId);
			this.shipMethodOperations    = new ShipMethodTemplate   (this.RestTemplate, companyId);
			this.taxRateOperations       = new TaxRateTemplate      (this.RestTemplate, companyId);
			this.taxCodeOperations       = new TaxCodeTemplate      (this.RestTemplate, companyId);
			this.paymentMethodOperations = new PaymentMethodTemplate(this.RestTemplate, companyId);
			this.termOperations          = new TermTemplate         (this.RestTemplate, companyId);
		}

		#region IQuickBooks Members
		public IAccountOperations       AccountOperations       { get { return this.accountOperations      ; } }
		public ICustomerOperations      CustomerOperations      { get { return this.customerOperations     ; } }
		public IEstimateOperations      EstimateOperations      { get { return this.estimateOperations     ; } }
		public IInvoiceOperations       InvoiceOperations       { get { return this.invoiceOperations      ; } }
		public ISalesOrderOperations    SalesOrderOperations    { get { return this.salesOrderOperations   ; } }
		public IPaymentOperations       PaymentOperations       { get { return this.paymentOperations      ; } }
		public ICreditMemoOperations    CreditMemoOperations    { get { return this.creditMemoOperations   ; } }
		public IItemOperations          ItemOperations          { get { return this.itemOperations         ; } }
		public IShipMethodOperations    ShipMethodOperations    { get { return this.shipMethodOperations   ; } }
		public ITaxRateOperations       TaxRateOperations       { get { return this.taxRateOperations      ; } }
		public ITaxCodeOperations       TaxCodeOperations       { get { return this.taxCodeOperations      ; } }
		public IPaymentMethodOperations PaymentMethodOperations { get { return this.paymentMethodOperations; } }
		public ITermOperations          TermOperations          { get { return this.termOperations         ; } }
		public IRestOperations          RestOperations          { get { return this.RestTemplate           ; } }
		#endregion

		protected override void ConfigureRestTemplate(RestTemplate restTemplate)
		{
			restTemplate.BaseAddress = API_URI_BASE;
		}

		protected override IList<IHttpMessageConverter> GetMessageConverters()
		{
			IList<IHttpMessageConverter> converters = base.GetMessageConverters();
			converters.Add(new ByteArrayHttpMessageConverter());
			converters.Add(this.GetJsonMessageConverter());
#if NET_3_0 || SILVERLIGHT
			converters.Add(new XElementHttpMessageConverter());
			converters.Add(new DataContractHttpMessageConverter(true));
			converters.Add(new DataContractJsonHttpMessageConverter(true));
#endif
			return converters;
		}

		protected virtual SpringJsonHttpMessageConverter GetJsonMessageConverter()
		{
			JsonMapper jsonMapper = new JsonMapper();
			jsonMapper.RegisterDeserializer(typeof(QBase                        ), new QBaseDeserializer                        ());
			jsonMapper.RegisterDeserializer(typeof(Account                      ), new AccountDeserializer                      ());
			jsonMapper.RegisterDeserializer(typeof(Customer                     ), new CustomerDeserializer                     ());
			jsonMapper.RegisterDeserializer(typeof(Invoice                      ), new InvoiceDeserializer                      ());
			jsonMapper.RegisterDeserializer(typeof(Estimate                     ), new EstimateDeserializer                     ());
			jsonMapper.RegisterDeserializer(typeof(Item                         ), new ItemDeserializer                         ());
			jsonMapper.RegisterDeserializer(typeof(Payment                      ), new PaymentDeserializer                      ());
			jsonMapper.RegisterDeserializer(typeof(CreditMemo                   ), new CreditMemoDeserializer                   ());
			jsonMapper.RegisterDeserializer(typeof(SalesOrder                   ), new SalesOrderDeserializer                   ());
			
			jsonMapper.RegisterDeserializer(typeof(ModificationMetaData         ), new ModificationMetaDataDeserializer         ());
			jsonMapper.RegisterDeserializer(typeof(ReferenceType                ), new ReferenceTypeDeserializer                ());
			jsonMapper.RegisterDeserializer(typeof(TelephoneNumber              ), new TelephoneNumberDeserializer              ());
			jsonMapper.RegisterDeserializer(typeof(EmailAddress                 ), new EmailAddressDeserializer                 ());
			jsonMapper.RegisterDeserializer(typeof(WebSiteAddress               ), new WebSiteAddressDeserializer               ());
			jsonMapper.RegisterDeserializer(typeof(PhysicalAddress              ), new PhysicalAddressDeserializer              ());
			jsonMapper.RegisterDeserializer(typeof(GenericContactType           ), new GenericContactTypeDeserializer           ());
			jsonMapper.RegisterDeserializer(typeof(ContactInfo                  ), new ContactInfoDeserializer                  ());
			jsonMapper.RegisterDeserializer(typeof(CreditChargeInfo             ), new CreditChargeInfoDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(JobInfo                      ), new JobInfoDeserializer                      ());
			jsonMapper.RegisterDeserializer(typeof(MemoRef                      ), new MemoRefDeserializer                      ());

			jsonMapper.RegisterDeserializer(typeof(Currency                     ), new CurrencyDeserializer                     ());
			jsonMapper.RegisterDeserializer(typeof(MarkupInfo                   ), new MarkupInfoDeserializer                   ());
			jsonMapper.RegisterDeserializer(typeof(UOMRef                       ), new UOMRefDeserializer                       ());
			jsonMapper.RegisterDeserializer(typeof(EntityTypeRef                ), new EntityTypeRefDeserializer                ());
			jsonMapper.RegisterDeserializer(typeof(PaymentLineDetail            ), new PaymentLineDetailDeserializer            ());
			jsonMapper.RegisterDeserializer(typeof(DiscountLineDetail           ), new DiscountLineDetailDeserializer           ());
			jsonMapper.RegisterDeserializer(typeof(TaxLineDetail                ), new TaxLineDetailDeserializer                ());
			jsonMapper.RegisterDeserializer(typeof(SalesItemLineDetail          ), new SalesItemLineDetailDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(ItemBasedExpenseLineDetail   ), new ItemBasedExpenseLineDetailDeserializer   ());
			jsonMapper.RegisterDeserializer(typeof(AccountBasedExpenseLineDetail), new AccountBasedExpenseLineDetailDeserializer());
			jsonMapper.RegisterDeserializer(typeof(DepositLineDetail            ), new DepositLineDetailDeserializer            ());
			jsonMapper.RegisterDeserializer(typeof(PurchaseOrderItemLineDetail  ), new PurchaseOrderItemLineDetailDeserializer  ());
			jsonMapper.RegisterDeserializer(typeof(ItemReceiptLineDetail        ), new ItemReceiptLineDetailDeserializer        ());
			jsonMapper.RegisterDeserializer(typeof(JournalEntryLineDetail       ), new JournalEntryLineDetailDeserializer       ());
			jsonMapper.RegisterDeserializer(typeof(GroupLineDetail              ), new GroupLineDetailDeserializer              ());
			jsonMapper.RegisterDeserializer(typeof(DescriptionLineDetail        ), new DescriptionLineDetailDeserializer        ());
			jsonMapper.RegisterDeserializer(typeof(SubTotalLineDetail           ), new SubTotalLineDetailDeserializer           ());
			jsonMapper.RegisterDeserializer(typeof(SalesOrderItemLineDetail     ), new SalesOrderItemLineDetailDeserializer     ());
			jsonMapper.RegisterDeserializer(typeof(DiscountOverride             ), new DiscountOverrideDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(ItemComponentLine            ), new ItemComponentLineDeserializer            ());
			jsonMapper.RegisterDeserializer(typeof(ShipMethod                   ), new ShipMethodDeserializer                   ());
			jsonMapper.RegisterDeserializer(typeof(PaymentMethod                ), new PaymentMethodDeserializer                ());
			jsonMapper.RegisterDeserializer(typeof(Term                         ), new TermDeserializer                         ());
			jsonMapper.RegisterDeserializer(typeof(TaxRate                      ), new TaxRateDeserializer                      ());
			jsonMapper.RegisterDeserializer(typeof(TaxCode                      ), new TaxCodeDeserializer                      ());
			jsonMapper.RegisterDeserializer(typeof(EffectiveTaxRate             ), new EffectiveTaxRateDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(TxnTaxDetail                 ), new TxnTaxDetailDeserializer                 ());
			jsonMapper.RegisterDeserializer(typeof(TaxRateDetail                ), new TaxRateDetailDeserializer                ());
			jsonMapper.RegisterDeserializer(typeof(TaxRateRefList               ), new TaxRateRefListDeserializer               ());
			jsonMapper.RegisterDeserializer(typeof(Line                         ), new LineDeserializer                         ());
			jsonMapper.RegisterDeserializer(typeof(LinkedTxn                    ), new LinkedTxnDeserializer                    ());
			
			jsonMapper.RegisterDeserializer(typeof(QBasePagination              ), new QBasePaginationDeserializer              ());
			jsonMapper.RegisterDeserializer(typeof(IList<QBase                 >), new QBaseListDeserializer                    ());
			jsonMapper.RegisterDeserializer(typeof(IList<Account               >), new AccountListDeserializer                  ());
			jsonMapper.RegisterDeserializer(typeof(IList<Customer              >), new CustomerListDeserializer                 ());
			jsonMapper.RegisterDeserializer(typeof(IList<Invoice               >), new InvoiceListDeserializer                  ());
			jsonMapper.RegisterDeserializer(typeof(IList<Estimate              >), new EstimateListDeserializer                 ());
			jsonMapper.RegisterDeserializer(typeof(IList<Item                  >), new ItemListDeserializer                     ());
			jsonMapper.RegisterDeserializer(typeof(IList<Payment               >), new PaymentListDeserializer                  ());
			jsonMapper.RegisterDeserializer(typeof(IList<CreditMemo            >), new CreditMemoListDeserializer               ());
			jsonMapper.RegisterDeserializer(typeof(IList<SalesOrder            >), new SalesOrderListDeserializer               ());
			jsonMapper.RegisterDeserializer(typeof(IList<TaxRateDetail         >), new TaxRateDetailListDeserializer            ());

			jsonMapper.RegisterDeserializer(typeof(IList<PhysicalAddress       >), new PhysicalAddressListDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(IList<ContactInfo           >), new ContactInfoListDeserializer              ());
			jsonMapper.RegisterDeserializer(typeof(IList<Line                  >), new LineListDeserializer                     ());
			jsonMapper.RegisterDeserializer(typeof(IList<LinkedTxn             >), new LinkedTxnListDeserializer                ());
			jsonMapper.RegisterDeserializer(typeof(IList<ItemComponentLine     >), new ItemComponentLineListDeserializer        ());
			jsonMapper.RegisterDeserializer(typeof(IList<ShipMethod            >), new ShipMethodListDeserializer               ());
			jsonMapper.RegisterDeserializer(typeof(IList<TaxRate               >), new TaxRateListDeserializer                  ());
			jsonMapper.RegisterDeserializer(typeof(IList<TaxCode               >), new TaxCodeListDeserializer                  ());
			jsonMapper.RegisterDeserializer(typeof(IList<PaymentMethod         >), new PaymentMethodListDeserializer            ());
			jsonMapper.RegisterDeserializer(typeof(IList<Term                  >), new TermListDeserializer                     ());
			jsonMapper.RegisterDeserializer(typeof(IList<EffectiveTaxRate      >), new EffectiveTaxRateListDeserializer         ());

			jsonMapper.RegisterSerializer  (typeof(Account                      ), new AccountSerializer                        ());
			jsonMapper.RegisterSerializer  (typeof(Customer                     ), new CustomerSerializer                       ());
			jsonMapper.RegisterSerializer  (typeof(Invoice                      ), new InvoiceSerializer                        ());
			jsonMapper.RegisterSerializer  (typeof(Estimate                     ), new EstimateSerializer                       ());
			jsonMapper.RegisterSerializer  (typeof(Item                         ), new ItemSerializer                           ());
			jsonMapper.RegisterSerializer  (typeof(Payment                      ), new PaymentSerializer                        ());
			jsonMapper.RegisterSerializer  (typeof(CreditMemo                   ), new CreditMemoSerializer                     ());
			jsonMapper.RegisterSerializer  (typeof(SalesOrder                   ), new SalesOrderSerializer                     ());

			jsonMapper.RegisterSerializer  (typeof(ModificationMetaData         ), new ModificationMetaDataSerializer           ());
			jsonMapper.RegisterSerializer  (typeof(ReferenceType                ), new ReferenceTypeSerializer                  ());
			jsonMapper.RegisterSerializer  (typeof(TelephoneNumber              ), new TelephoneNumberSerializer                ());
			jsonMapper.RegisterSerializer  (typeof(EmailAddress                 ), new EmailAddressSerializer                   ());
			jsonMapper.RegisterSerializer  (typeof(WebSiteAddress               ), new WebSiteAddressSerializer                 ());
			jsonMapper.RegisterSerializer  (typeof(PhysicalAddress              ), new PhysicalAddressSerializer                ());
			jsonMapper.RegisterSerializer  (typeof(GenericContactType           ), new GenericContactTypeSerializer             ());
			jsonMapper.RegisterSerializer  (typeof(ContactInfo                  ), new ContactInfoSerializer                    ());
			jsonMapper.RegisterSerializer  (typeof(CreditChargeInfo             ), new CreditChargeInfoSerializer               ());
			jsonMapper.RegisterSerializer  (typeof(JobInfo                      ), new JobInfoSerializer                        ());
			jsonMapper.RegisterSerializer  (typeof(MemoRef                      ), new MemoRefSerializer                        ());

			jsonMapper.RegisterSerializer  (typeof(Currency                     ), new CurrencySerializer                       ());
			jsonMapper.RegisterSerializer  (typeof(MarkupInfo                   ), new MarkupInfoSerializer                     ());
			jsonMapper.RegisterSerializer  (typeof(UOMRef                       ), new UOMRefSerializer                         ());
			jsonMapper.RegisterSerializer  (typeof(EntityTypeRef                ), new EntityTypeRefSerializer                  ());
			jsonMapper.RegisterSerializer  (typeof(PaymentLineDetail            ), new PaymentLineDetailSerializer              ());
			jsonMapper.RegisterSerializer  (typeof(DiscountLineDetail           ), new DiscountLineDetailSerializer             ());
			jsonMapper.RegisterSerializer  (typeof(TaxLineDetail                ), new TaxLineDetailSerializer                  ());
			jsonMapper.RegisterSerializer  (typeof(SalesItemLineDetail          ), new SalesItemLineDetailSerializer            ());
			jsonMapper.RegisterSerializer  (typeof(ItemBasedExpenseLineDetail   ), new ItemBasedExpenseLineDetailSerializer     ());
			jsonMapper.RegisterSerializer  (typeof(AccountBasedExpenseLineDetail), new AccountBasedExpenseLineDetailSerializer  ());
			jsonMapper.RegisterSerializer  (typeof(DepositLineDetail            ), new DepositLineDetailSerializer              ());
			jsonMapper.RegisterSerializer  (typeof(PurchaseOrderItemLineDetail  ), new PurchaseOrderItemLineDetailSerializer    ());
			jsonMapper.RegisterSerializer  (typeof(ItemReceiptLineDetail        ), new ItemReceiptLineDetailSerializer          ());
			jsonMapper.RegisterSerializer  (typeof(JournalEntryLineDetail       ), new JournalEntryLineDetailSerializer         ());
			jsonMapper.RegisterSerializer  (typeof(GroupLineDetail              ), new GroupLineDetailSerializer                ());
			jsonMapper.RegisterSerializer  (typeof(DescriptionLineDetail        ), new DescriptionLineDetailSerializer          ());
			jsonMapper.RegisterSerializer  (typeof(SubTotalLineDetail           ), new SubTotalLineDetailSerializer             ());
			jsonMapper.RegisterSerializer  (typeof(SalesOrderItemLineDetail     ), new SalesOrderItemLineDetailSerializer       ());
			jsonMapper.RegisterSerializer  (typeof(DiscountOverride             ), new DiscountOverrideSerializer               ());
			jsonMapper.RegisterSerializer  (typeof(ItemComponentLine            ), new ItemComponentLineSerializer              ());
			jsonMapper.RegisterSerializer  (typeof(ShipMethod                   ), new ShipMethodSerializer                     ());
			jsonMapper.RegisterSerializer  (typeof(PaymentMethod                ), new PaymentMethodSerializer                  ());
			jsonMapper.RegisterSerializer  (typeof(Term                         ), new TermSerializer                           ());
			jsonMapper.RegisterSerializer  (typeof(TaxRate                      ), new TaxRateSerializer                        ());
			jsonMapper.RegisterSerializer  (typeof(TaxCode                      ), new TaxCodeSerializer                        ());
			jsonMapper.RegisterSerializer  (typeof(EffectiveTaxRate             ), new EffectiveTaxRateSerializer               ());
			jsonMapper.RegisterSerializer  (typeof(TxnTaxDetail                 ), new TxnTaxDetailSerializer                   ());
			jsonMapper.RegisterSerializer  (typeof(TaxRateDetail                ), new TaxRateDetailSerializer                  ());
			jsonMapper.RegisterSerializer  (typeof(TaxRateRefList               ), new TaxRateRefListSerializer                 ());
			jsonMapper.RegisterSerializer  (typeof(Line                         ), new LineSerializer                           ());
			jsonMapper.RegisterSerializer  (typeof(LinkedTxn                    ), new LinkedTxnSerializer                      ());

			jsonMapper.RegisterSerializer  (typeof(List<PhysicalAddress        >), new PhysicalAddressListSerializer            ());
			jsonMapper.RegisterSerializer  (typeof(List<ContactInfo            >), new ContactInfoListSerializer                ());
			jsonMapper.RegisterSerializer  (typeof(List<Line                   >), new LineListSerializer                       ());
			jsonMapper.RegisterSerializer  (typeof(List<LinkedTxn              >), new LinkedTxnListSerializer                  ());
			jsonMapper.RegisterSerializer  (typeof(List<ItemComponentLine      >), new ItemComponentLineListSerializer          ());
			jsonMapper.RegisterSerializer  (typeof(List<ShipMethod             >), new ShipMethodListSerializer                 ());
			jsonMapper.RegisterSerializer  (typeof(List<TaxRate                >), new TaxRateListSerializer                    ());
			jsonMapper.RegisterSerializer  (typeof(List<TaxCode                >), new TaxCodeListSerializer                    ());
			jsonMapper.RegisterSerializer  (typeof(List<PaymentMethod          >), new PaymentMethodListSerializer              ());
			jsonMapper.RegisterSerializer  (typeof(List<Term                   >), new TermListSerializer                       ());
			jsonMapper.RegisterSerializer  (typeof(List<EffectiveTaxRate       >), new EffectiveTaxRateListSerializer           ());
			jsonMapper.RegisterSerializer  (typeof(List<TaxRateDetail          >), new TaxRateDetailListSerializer              ());

			return new SpringJsonHttpMessageConverter(jsonMapper);
		}
	}
}
