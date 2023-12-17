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
using System.Text;

namespace Spring.Social.Etsy.Api
{
	[Serializable]
	public class MailingAddress
	{
		public String            id                      { get; set; }
		public String            firstName               { get; set; }
		public String            lastName                { get; set; }
		public String            phone                   { get; set; }
		public String            company                 { get; set; }
		public String            address1                { get; set; }
		public String            address2                { get; set; }
		public String            city                    { get; set; }
		public String            province                { get; set; }
		public String            provinceCode            { get; set; }
		public String            country                 { get; set; }
		public String            countryCode             { get; set; }
		public String            zip                     { get; set; }
		public float             latitude                { get; set; }
		public float             longitude               { get; set; }

		public MailingAddress()
		{
		}

		public MailingAddress(string sStreet, string sCity, string sState, string sPostalCode, string sCountry)
		{
			sStreet = sStreet.Replace(ControlChars.CrLf, "\n");
			string[] arrLine = sStreet.Split(ControlChars.Lf);
			if ( arrLine.Length > 0 ) this.address1 = arrLine[0];
			if ( arrLine.Length > 1 ) this.address2 = arrLine[1];
			this.city      = sCity      ;
			this.province  = sState     ;
			this.zip       = sPostalCode;
			this.country   = sCountry   ;
		}

		public override string ToString()
		{
			StringBuilder sb = new StringBuilder();
			if ( sb.Length > 0 ) sb.Append(", ");  sb.Append(address1);
			if ( sb.Length > 0 ) sb.Append(", ");  sb.Append(address2);
			if ( sb.Length > 0 ) sb.Append(", ");  sb.Append(city    );
			if ( sb.Length > 0 ) sb.Append(", ");  sb.Append(province);
			if ( sb.Length > 0 ) sb.Append(", ");  sb.Append(country );
			if ( sb.Length > 0 ) sb.Append(", ");  sb.Append(zip     );
			return sb.ToString();
		}
	}
}
