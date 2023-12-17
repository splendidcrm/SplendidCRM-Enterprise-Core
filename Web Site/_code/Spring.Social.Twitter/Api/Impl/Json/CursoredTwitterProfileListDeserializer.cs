#region License

/*
 * Copyright 2002-2012 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#endregion

using System.Collections.Generic;

using Spring.Json;

namespace Spring.Social.Twitter.Api.Impl.Json
{
    /// <summary>
    /// JSON deserializer for cursored list of Twitter user's profiles. 
    /// </summary>
    /// <author>Bruno Baia</author>
    class CursoredTwitterProfileListDeserializer : IJsonDeserializer
    {
        public object Deserialize(JsonValue value, JsonMapper mapper)
        {
            CursoredList<TwitterProfile> twitterProfiles = new CursoredList<TwitterProfile>();
            twitterProfiles.PreviousCursor = value.GetValue<long>("previous_cursor");
            twitterProfiles.NextCursor = value.GetValue<long>("next_cursor");
            foreach (JsonValue itemValue in value.GetValues("users"))
            {
                twitterProfiles.Add(mapper.Deserialize<TwitterProfile>(itemValue));
            }
            return twitterProfiles;
        }
    }
}