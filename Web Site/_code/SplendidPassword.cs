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
using System.Text.RegularExpressions;
using System.Globalization;

namespace SplendidCRM
{
	public class SplendidPassword
	{
		private const int    TXT_INDICATORS_MIN_COUNT     =   2;  // Minimum number of textual descriptions
		private const int    TXT_INDICATORS_MAX_COUNT     =  10;  // Maximum number of textual descriptions.
		private const char   TXT_INDICATOR_DELIMITER      = ';';  // Text indicators are delimited with a semi colon

		private const string _sRemainingCharactersDefault = "{0} more characters"                ;
		private const string _sRemainingNumbersDefault    = "{0} more numbers"                   ;
		private const string _sRemainingLowerCaseDefault  = "{0} more lower case characters"     ;
		private const string _sRemainingUpperCaseDefault  = "{0} more upper case characters"     ;
		private const string _sRemainingSymbolsDefault    = "{0} symbol characters"              ;
		private const string _sRemainingMixedCaseDefault  = "{0} more mixed case characters"     ;
		private const string _sSatisfiedDefault           = "Nothing more required"              ;

		public  int    PreferredPasswordLength      = 6;
		public  int    MinimumLowerCaseCharacters   = 1;
		public  int    MinimumUpperCaseCharacters   = 0;
		public  int    MinimumNumericCharacters     = 1;
		public  int    MinimumSymbolCharacters      = 0;
		public  int    ComplexityNumber             = 2;

		private string sPrefixText                  = String.Empty;
		private string sTextStrengthDescriptions    = String.Empty;
		private string sSymbolCharacters            = String.Empty;
		private string sMessageRemainingCharacters  = String.Empty;
		private string sMessageRemainingNumbers     = String.Empty;
		private string sMessageRemainingLowerCase   = String.Empty;
		private string sMessageRemainingUpperCase   = String.Empty;
		private string sMessageRemainingMixedCase   = String.Empty;
		private string sMessageRemainingSymbols     = String.Empty;
		private string sMessageSatisfied            = String.Empty;

		public string PrefixText                   { get { return Sql.IsEmptyString(sPrefixText                ) ? "Strength: "                 : sPrefixText                ; } set { sPrefixText                 = value; } }
		public string TextStrengthDescriptions     { get { return Sql.IsEmptyString(sTextStrengthDescriptions  ) ? ";;;;;;"                     : sTextStrengthDescriptions  ; } set { sTextStrengthDescriptions   = value; } }
		public string SymbolCharacters             { get { return Sql.IsEmptyString(sSymbolCharacters          ) ? "!@#$%^&*()<>?~."            : sSymbolCharacters          ; } set { sSymbolCharacters           = value; } }
		public string MessageRemainingCharacters   { get { return Sql.IsEmptyString(sMessageRemainingCharacters) ? _sRemainingCharactersDefault : sMessageRemainingCharacters; } set { sMessageRemainingCharacters = value; } }
		public string MessageRemainingNumbers      { get { return Sql.IsEmptyString(sMessageRemainingNumbers   ) ? _sRemainingNumbersDefault    : sMessageRemainingNumbers   ; } set { sMessageRemainingNumbers    = value; } }
		public string MessageRemainingLowerCase    { get { return Sql.IsEmptyString(sMessageRemainingLowerCase ) ? _sRemainingLowerCaseDefault  : sMessageRemainingLowerCase ; } set { sMessageRemainingLowerCase  = value; } }
		public string MessageRemainingUpperCase    { get { return Sql.IsEmptyString(sMessageRemainingUpperCase ) ? _sRemainingUpperCaseDefault  : sMessageRemainingUpperCase ; } set { sMessageRemainingUpperCase  = value; } }
		public string MessageRemainingMixedCase    { get { return Sql.IsEmptyString(sMessageRemainingMixedCase ) ? _sRemainingMixedCaseDefault  : sMessageRemainingMixedCase ; } set { sMessageRemainingMixedCase  = value; } }
		public string MessageRemainingSymbols      { get { return Sql.IsEmptyString(sMessageRemainingSymbols   ) ? _sRemainingSymbolsDefault    : sMessageRemainingSymbols   ; } set { sMessageRemainingSymbols    = value; } }
		public string MessageSatisfied             { get { return Sql.IsEmptyString(sMessageSatisfied          ) ? _sSatisfiedDefault           : sMessageSatisfied          ; } set { sMessageSatisfied           = value; } }

		public bool IsValid(string pwd, ref string pwdRequirements)
		{
			pwd = pwd.Trim();
			int complexity = 0;

			//***********************************************
			// Length Criteria
			if ( pwd.Length < this.PreferredPasswordLength )
				pwdRequirements = String.Format(this.MessageRemainingCharacters, this.PreferredPasswordLength - pwd.Length);

			//***********************************************
			// Numeric Criteria
			// Does it contain numbers?
			if ( this.MinimumNumericCharacters > 0 )
			{
				Regex numbersRegex = new Regex("[0-9]");
				int numCount = numbersRegex.Matches(pwd).Count;
				if ( numCount >= this.MinimumNumericCharacters )
				{
					complexity++;
				}
				else
				{
					if ( pwdRequirements != String.Empty )
						pwdRequirements += ", ";
					pwdRequirements += String.Format(this.MessageRemainingNumbers, this.MinimumNumericCharacters - numCount);
				}
			}

			//***********************************************
			// Casing Criteria
			// Does it contain lowercase AND uppercase Text
			if ( this.MinimumLowerCaseCharacters > 0 && this.MinimumUpperCaseCharacters > 0 )
			{
				Regex lowercaseRegex = new Regex("[a-z]");
				Regex uppercaseRegex = new Regex("[A-Z]");
				int numLower = lowercaseRegex.Matches(pwd).Count;
				// 01/09/2022 Paul.  Was not counting upper case characters properly. 
				int numUpper = uppercaseRegex.Matches(pwd).Count;
				if ( numLower > 0 || numUpper > 0 )
				{
					if ( this.MinimumLowerCaseCharacters > 0 && numLower >= this.MinimumLowerCaseCharacters )
					{
						complexity++;
					}
					else 
					{
						if ( pwdRequirements != String.Empty )
							pwdRequirements += ", ";
						pwdRequirements += String.Format(this.MessageRemainingLowerCase, this.MinimumLowerCaseCharacters - numLower);
					}
					if ( this.MinimumUpperCaseCharacters > 0 && numUpper >= this.MinimumUpperCaseCharacters )
					{
						complexity++;
					}
					else
					{
						if ( pwdRequirements != String.Empty )
							pwdRequirements += ", ";
						pwdRequirements += String.Format(this.MessageRemainingUpperCase, this.MinimumUpperCaseCharacters - numUpper);
					}
				}
				else
				{
					if ( pwdRequirements != String.Empty )
						pwdRequirements += ", ";
					// 01/09/2022 Paul.  Need to foramt the string with the minimum number. 
					pwdRequirements += String.Format(this.MessageRemainingMixedCase, this.MinimumLowerCaseCharacters + this.MinimumUpperCaseCharacters);
				}
			}
			else if ( this.MinimumLowerCaseCharacters > 0 || this.MinimumUpperCaseCharacters > 0 )
			{
				Regex mixedRegex = new Regex("[a-z,A-Z]");
				int numMixed = mixedRegex.Matches(pwd).Count;
				if ( numMixed >= (this.MinimumLowerCaseCharacters + this.MinimumUpperCaseCharacters) )
				{
					complexity++;
				}
				else
				{
					if ( pwdRequirements != String.Empty )
						pwdRequirements += ", ";
					pwdRequirements += String.Format(this.MessageRemainingMixedCase, this.MinimumLowerCaseCharacters + this.MinimumUpperCaseCharacters);
				}
			}

			//***********************************************
			// Symbol Criteria
			// Does it contain any special symbols?
			if ( this.MinimumSymbolCharacters > 0 )
			{
				Regex symbolRegex = null;
				if ( this.SymbolCharacters != null && this.SymbolCharacters != String.Empty )
				{
					// http://www.regular-expressions.info/characters.html
					Regex specialRegex = new Regex(@"[\+\-\!\(\)\{\}\[\]\^\" + "\"" + @"\~\*\:\?\\]|&&|\|\|");
					// 03/05/2011 Paul.  Fix issue with escaping the symbol characters. 
					string _escapedSymbolCharacters = specialRegex.Replace(this.SymbolCharacters, @"\$0");
					symbolRegex = new Regex("[" + _escapedSymbolCharacters + "]");
				}
				else
				{
					symbolRegex = new Regex("[^a-z,A-Z,0-9,\x20]");  // related to work item 1034
				}
				
				int numCount = symbolRegex.Matches(pwd).Count;
				if ( numCount >= this.MinimumSymbolCharacters )
				{
					complexity++;
				}
				else
				{
					if ( pwdRequirements != String.Empty )
						pwdRequirements += ", ";
					pwdRequirements += String.Format(this.MessageRemainingSymbols, this.MinimumSymbolCharacters - numCount);
				}
			}
			// 02/20/2011 Paul.  If the password meets the complexity requiements, then ignore the other failures. 
			if ( pwd.Length >= this.PreferredPasswordLength && complexity >= this.ComplexityNumber )
				pwdRequirements = String.Empty;
			return Sql.IsEmptyString(pwdRequirements);
		}
	}

}

