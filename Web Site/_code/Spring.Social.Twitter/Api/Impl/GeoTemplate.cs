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

using System;
using System.Globalization;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Threading.Tasks;

using Spring.Rest.Client;

namespace Spring.Social.Twitter.Api.Impl
{
    /// <summary>
    /// Implementation of <see cref="IGeoOperations"/>, providing a binding to Twitter's places and geo REST resources.
    /// </summary>
    /// <author>Craig Walls</author>
    /// <author>Bruno Baia (.NET)</author>
    class GeoTemplate : AbstractTwitterOperations, IGeoOperations
    {
        private RestTemplate restTemplate;

        public GeoTemplate(RestTemplate restTemplate)
        {
            this.restTemplate = restTemplate;
        }

        #region IGeoOperations Members

        public Task<Place> GetPlaceAsync(string placeId)
        {
            return this.restTemplate.GetForObjectAsync<Place>("geo/id/{placeId}.json", placeId);
	    }

        public Task<IList<Place>> ReverseGeoCodeAsync(double latitude, double longitude) 
        {
            return this.ReverseGeoCodeAsync(latitude, longitude, null, null);
	    }

        public Task<IList<Place>> ReverseGeoCodeAsync(double latitude, double longitude, PlaceType? granularity, string accuracy) 
        {
		    NameValueCollection parameters = this.BuildGeoParameters(latitude, longitude, granularity, accuracy, null);
            return this.restTemplate.GetForObjectAsync<IList<Place>>(this.BuildUrl("geo/reverse_geocode.json", parameters));
	    }

        public Task<IList<Place>> SearchAsync(double latitude, double longitude) 
        {
            return this.SearchAsync(latitude, longitude, null, null, null);
	    }

        public Task<IList<Place>> SearchAsync(double latitude, double longitude, PlaceType? granularity, string accuracy, string query) 
        {
		    NameValueCollection parameters = this.BuildGeoParameters(latitude, longitude, granularity, accuracy, query);
            return this.restTemplate.GetForObjectAsync<IList<Place>>(this.BuildUrl("geo/search.json", parameters));
	    }

        public Task<SimilarPlaces> FindSimilarPlacesAsync(double latitude, double longitude, string name) 
        {
            return this.FindSimilarPlacesAsync(latitude, longitude, name, null, null);
	    }

        public Task<SimilarPlaces> FindSimilarPlacesAsync(double latitude, double longitude, string name, string streetAddress, string containedWithin) 
        {
            NameValueCollection parameters = this.BuildPlaceParameters(latitude, longitude, name, streetAddress, containedWithin);
            return this.restTemplate.GetForObjectAsync<SimilarPlaces>(this.BuildUrl("geo/similar_places.json", parameters))
                .ContinueWith<SimilarPlaces>(task =>
                {
                    task.Result.PlacePrototype.Latitude = latitude;
                    task.Result.PlacePrototype.Longitude = longitude;
                    task.Result.PlacePrototype.Name = name;
                    task.Result.PlacePrototype.StreetAddress = streetAddress;
                    task.Result.PlacePrototype.ContainedWithin = containedWithin;
                    return task.Result;
                }, TaskContinuationOptions.ExecuteSynchronously);

	    }

        public Task<Place> CreatePlaceAsync(PlacePrototype placePrototype) 
        {
	        NameValueCollection request = this.BuildPlaceParameters(placePrototype.Latitude, placePrototype.Longitude, placePrototype.Name, placePrototype.StreetAddress, placePrototype.ContainedWithin);
            request.Add("token", placePrototype.CreateToken);
            return this.restTemplate.PostForObjectAsync<Place>("geo/place.json", request);
	    }
        #endregion

        #region Private Methods

        private NameValueCollection BuildGeoParameters(double latitude, double longitude, PlaceType? granularity, string accuracy, string query)
        {
            NameValueCollection nameValueCollection = new NameValueCollection();
            nameValueCollection.Add("lat", latitude.ToString((IFormatProvider) CultureInfo.InvariantCulture));
            nameValueCollection.Add("long", longitude.ToString((IFormatProvider) CultureInfo.InvariantCulture));
            if (granularity.HasValue)
            {
                nameValueCollection.Add("granularity", granularity.ToString().ToLower());
            }
            if (accuracy != null)
            {
                nameValueCollection.Add("accuracy", accuracy);
            }
            if (query != null)
            {
                nameValueCollection.Add("query", query);
            }
            return nameValueCollection;
        }

        private NameValueCollection BuildPlaceParameters(double latitude, double longitude, string name, string streetAddress, string containedWithin)
        {
            NameValueCollection nameValueCollection = new NameValueCollection();
            nameValueCollection.Add("lat", latitude.ToString((IFormatProvider) CultureInfo.InvariantCulture));
            nameValueCollection.Add("long", longitude.ToString((IFormatProvider) CultureInfo.InvariantCulture));
            nameValueCollection.Add("name", name);
            if (streetAddress != null)
            {
                nameValueCollection.Add("attribute:street_address", streetAddress);
            }
            if (containedWithin != null)
            {
                nameValueCollection.Add("contained_within", containedWithin);
            }
            return nameValueCollection;
        }

        #endregion
    }
}
