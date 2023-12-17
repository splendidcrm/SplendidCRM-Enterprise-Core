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
using System.Collections;

// 07/31/2006 Paul.  Stop using VisualBasic library to increase compatibility with Mono. 
namespace SplendidCRM
{
	public class ControlChars
	{
		public static string CrLf
		{
			get { return "\r\n"; }
		}

			public static char Cr
		{
			get { return '\r'; }
		}

			public static char Lf
		{
			get { return '\n'; }
		}

			public static char Tab
		{
			get { return '\t'; }
		}
	}

	public enum TriState
	{
		UseDefault = -2,
		True = -1,
		False = 0,
	}
	
	public enum CompareMethod
	{
		Binary = 0,
		Text = 1,
	}

	public class Strings
	{
		public static string Space(int nCount)
		{
			return new string(' ', nCount);
		}

		public static string[] Split(string s, string sDelimiter, int nLimit, CompareMethod Compare)
		{
			ArrayList lst = new ArrayList();
			int nOffset = 0;
			if ( sDelimiter == String.Empty )
				sDelimiter = " ";
			while ( (nOffset = s.IndexOf(sDelimiter)) >= 0 )
			{
				if ( nLimit > 0 && lst.Count == nLimit-1 )
					break;
				lst.Add(s.Substring(0, nOffset));
				s = s.Substring(nOffset + sDelimiter.Length);
			}
			if ( lst.Count == 0 || s.Length > 0 )
				lst.Add(s);
			return lst.ToArray(typeof(System.String)) as string[];
		}
		
		/*
		// 03/07/2008 Paul.  Force the use of the culture-specific currency formatting. 
		public static string FormatCurrency(object o, int NumDigitsAfterDecimal, TriState IncludeLeadingDigit, TriState UseParensForNegativeNumbers, TriState GroupDigits)
		{
			// 07/31/2006 Paul.  We will always format with thousands separator and zero decimal places.
			//string sCurrencySymbol = System.Globalization.CultureInfo.CurrentCulture.NumberFormat.CurrencySymbol;
			if ( o == null || o is DateTime )
				throw(new Exception("Invalid currency expression"));
			string sValue = String.Format("{0:$#,#}", o);
			return sValue;
		}
		*/
	}

	public class Information
	{
		public static bool IsDate(object o)
		{
			if ( o == null )
				return false;
			else if ( o is DateTime )
				return true;
			else if ( o is String )
			{
				try
				{
					DateTime.Parse(o as String);
					return true;
				}
				catch
				{
				}
			}
			return false;
		}

		public static bool IsNumeric(object o)
		{
			if ( o == null || o is DateTime )
				return false;
			else if ( o is Int16 || o is Int32 || o is Int64 || o is Decimal || o is Single || o is Double )
				return true;
			else
			{
				try
				{
					if ( o is String )
						Double.Parse(o as String);
					else
						Double.Parse(o.ToString());
					return true;
				}
				catch
				{
				}
			}
			return false;
		}
	}
}

