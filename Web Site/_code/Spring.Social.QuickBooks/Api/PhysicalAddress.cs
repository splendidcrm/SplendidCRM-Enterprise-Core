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

namespace Spring.Social.QuickBooks.Api
{
	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/020_key_concepts/0700_other_topics#PhysicalAddress
	[Serializable]
	public class PhysicalAddress
	{
		public String            Id                      { get; set; }
		public String            Line1                   { get; set; }  // 500 chars. 
		public String            Line2                   { get; set; }  // 500 chars. 
		public String            Line3                   { get; set; }  // 500 chars. 
		public String            Line4                   { get; set; }  // 500 chars. 
		public String            Line5                   { get; set; }  // 500 chars. 
		public String            City                    { get; set; }  // 255 chars. 
		public String            Country                 { get; set; }  // 255 chars. 
		public String            CountryCode             { get; set; }
		public String            CountrySubDivisionCode  { get; set; }  // 255 chars. 
		public String            PostalCode              { get; set; }  //  30 chars. 
		public String            PostalCodeSuffix        { get; set; }
		public String            Lat                     { get; set; }
		public String            Long                    { get; set; }
		public String            Tag                     { get; set; }
		public String            Note                    { get; set; }

		public PhysicalAddress()
		{
		}

		public PhysicalAddress(string sStreet, string sCity, string sState, string sPostalCode, string sCountry)
		{
			sStreet = sStreet.Replace(ControlChars.CrLf, "\n");
			sStreet = Sql.Truncate(sStreet, 2000);  // Limit confirmed 06/22/2014. 
			// 06/22/2014 Paul.  The main QuickBooks Online does not have a per-line limit, just a street field limit. 
			string[] arrLine = sStreet.Split(ControlChars.Lf);
			if ( arrLine.Length > 0 ) this.Line1 = arrLine[0];
			if ( arrLine.Length > 1 ) this.Line2 = arrLine[1];
			if ( arrLine.Length > 2 ) this.Line3 = arrLine[2];
			if ( arrLine.Length > 3 ) this.Line4 = arrLine[3];
			if ( arrLine.Length > 4 ) this.Line5 = arrLine[4];
			this.City                   = Sql.Truncate(sCity      , 255);  // Limit confirmed 06/22/2014. 
			this.CountrySubDivisionCode = Sql.Truncate(sState     , 255);  // Limit confirmed 06/22/2014. 
			this.PostalCode             = Sql.Truncate(sPostalCode,  30);  // Limit confirmed 06/22/2014. 
			this.Country                = Sql.Truncate(sCountry   , 255);  // Limit confirmed 06/22/2014. 
		}
	}
}
