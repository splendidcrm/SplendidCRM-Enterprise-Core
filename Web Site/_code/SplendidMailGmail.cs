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
using System.IO;
using System.Web;
using System.Net;
using System.Net.Mail;
using System.Diagnostics;

using Google.Apis.Gmail.v1;
using Google.Apis.Gmail.v1.Data;
using MimeKit;
using MimeKit.IO;
using MimeKit.IO.Filters;

namespace SplendidCRM
{
	public class SplendidMailGmail : SplendidMailClient
	{
		private HttpApplicationState Application        = new HttpApplicationState();
		private GoogleApps           GoogleApps         ;
		private Guid                 USER_ID;

		public SplendidMailGmail(GoogleApps GoogleApps, Guid gOAUTH_TOKEN_ID)
		{
			this.GoogleApps  = GoogleApps     ;
			this.USER_ID     = gOAUTH_TOKEN_ID;
		}

		// http://stackoverflow.com/questions/35655019/gmail-draft-html-with-attachment-with-mimekit-c-sharp-winforms-and-google-api
		private class UrlEncodeFilter : IMimeFilter
		{
			byte[] output = new byte[8192];

			#region IMimeFilter implementation
			public byte[] Filter (byte[] input, int startIndex, int length, out int outputIndex, out int outputLength)
			{
				if ( output.Length < input.Length )
					Array.Resize (ref output, input.Length);

				int endIndex = startIndex + length;
				outputLength = 0;
				outputIndex  = 0;
				for ( int index = startIndex; index < endIndex; index++ )
				{
					switch ( (char) input[index] )
					{
						case '\r':
						case '\n':
						case '=' :
							break;
						case '+' :
							output[outputLength++] = (byte) '-';
							break;
						case '/' :
							output[outputLength++] = (byte) '_';
							break;
						default  :
							output[outputLength++] = input[index];
							break;
					}
				}
				return output;
			}

			public byte[] Flush (byte[] input, int startIndex, int length, out int outputIndex, out int outputLength)
			{
				return Filter (input, startIndex, length, out outputIndex, out outputLength);
			}

			public void Reset ()
			{
			}
			#endregion
		}

		// http://stackoverflow.com/questions/35655019/gmail-draft-html-with-attachment-with-mimekit-c-sharp-winforms-and-google-api
		public static string Base64UrlEncode(MimeMessage message)
		{
			string sData1 = String.Empty;
			string sData2 = String.Empty;
			// 12/06/2018 Paul.  The encoding is having a problem.  Try the simple approach. 
			// Google.Apis.Requests.RequestError Invalid value for ByteString: WC1TcGxlbmRpZENSTS1JRDogODkzYzllMmEtYmI3NC00ZTA3LWFlYjAtYjk2ODYwM2U0MzFkDQpGcm9tOiBQYXVsIFJvbnkgPHBhdWxAc3BsZW5kaWRjcm0uY29tPg0KVG86IHNwbGVuZGlkY3JtQGdtYWlsLmNvbQ0KU3ViamVjdDogVGVzdCBmcm9tIER5cGVybWl0DQpDb250ZW50LVR5cGU6IHRleHQvcGxhaW4NCgDQo 
			// [400] Errors [ Message[Invalid value for ByteString: WC1TcGxlbmRpZENSTS1JRDogODkzYzllMmEtYmI3NC00ZTA3LWFlYjAtYjk2ODYwM2U0MzFkDQpGcm9tOiBQYXVsIFJvbnkgPHBhdWxAc3BsZW5kaWRjcm0uY29tPg0KVG86IHNwbGVuZGlkY3JtQGdtYWlsLmNvbQ0KU3ViamVjdDogVGVzdCBmcm9tIER5cGVybWl0DQpDb250ZW50LVR5cGU6IHRleHQvcGxhaW4NCgDQo] Location[raw - other] Reason[invalid] Domain[global] ] 
			/*
			using ( MemoryStream stream = new MemoryStream() )
			{
				using ( FilteredStream filtered = new FilteredStream (stream) )
				{
					filtered.Add(EncoderFilter.Create(ContentEncoding.Base64));
					filtered.Add(new UrlEncodeFilter());
					message.WriteTo(filtered);
					filtered.Flush();
				}
				sData1 = System.Text.Encoding.ASCII.GetString (stream.GetBuffer (), 0, (int) stream.Length);
			}
			*/
			// 12/06/2018 Paul.  We have seen a very clear instance where the two techniques do not yield the same result. 
			// As the simple solution works, just go with it. 
			// WC1TcGxlbmRpZENSTS1JRDogNmU2MTJhMmEtYWY5NS00NTE4LWJjNDAtNmVkYWI1ZTNhNGZiDQpGcm9tOiBQYXVsIFJvbnkgPHBhdWxAc3BsZW5kaWRjcm0uY29tPg0KVG86IHNwbGVuZGlkY3JtQGdtYWlsLmNvbQ0KU3ViamVjdDogVGVzdCBmcm9tIER5cGVybWl0DQpDb250ZW50LVR5cGU6IHRleHQvcGxhaW4NCgDQo
			//WC1TcGxlbmRpZENSTS1JRDogNmU2MTJhMmEtYWY5NS00NTE4LWJjNDAtNmVkYWI1ZTNhNGZiDQpGcm9tOiBQYXVsIFJvbnkgPHBhdWxAc3BsZW5kaWRjcm0uY29tPg0KVG86IHNwbGVuZGlkY3JtQGdtYWlsLmNvbQ0KU3ViamVjdDogVGVzdCBmcm9tIER5cGVybWl0DQpDb250ZW50LVR5cGU6IHRleHQvcGxhaW4NCg0K
			using (var stream = new MemoryStream ())
			{
				message.WriteTo (stream);
				sData2 = Convert.ToBase64String (stream.GetBuffer (), 0, (int) stream.Length)
					.Replace ('+', '-')
					.Replace ('/', '_')
					.Replace ("=", "");
			}
			//Console.Write(sData1);
			//Console.Write(sData2);
			return sData2;
		}

		public static byte[] Base64UrlDecode(string arg)
		{
			string s = arg;
			s = s.Replace('-', '+'); // 62nd char of encoding
			s = s.Replace('_', '/'); // 63rd char of encoding
			switch (s.Length % 4) // Pad with trailing '='s
			{
				case 0: break; // No pad chars in this case
				case 2: s += "=="; break; // Two pad chars
				case 3: s += "=" ; break; // One pad char
				default: throw new Exception("Illegal base64url string!");
			}
			return Convert.FromBase64String(s); // Standard base64 decoder
		}

		override public void Send(MailMessage mail)
		{
			// https://developers.google.com/api-client-library/dotnet/apis/gmail/v1
			Google.Apis.Services.BaseClientService.Initializer initializer = GoogleApps.GetUserCredentialInitializer(USER_ID, GmailService.Scope.GmailSend);
			GmailService service = new GmailService(initializer);

			// http://www.mimekit.net/
			// http://www.mimekit.net/docs/html/Introduction.htm
			// http://stackoverflow.com/questions/35655019/gmail-draft-html-with-attachment-with-mimekit-c-sharp-winforms-and-google-api
			MimeMessage mimeMsg = MimeMessage.CreateFromMailMessage(mail);
			Message msg = new Message()
			{
				Raw = Base64UrlEncode(mimeMsg)
			};
			// https://developers.google.com/gmail/api/v1/reference/users/messages/send
			service.Users.Messages.Send(msg, "me").Execute();
		}
	}
}
