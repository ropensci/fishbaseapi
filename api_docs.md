# Fishbase API

The Fishbase API is the new API for [Fishbase.org](http://www.fishbase.org/).

## Contents

* [Base url](#base-url)
* [HTTP methods](#http-methods)
* [Response codes](#response-codes)
* [Media types](#media-types)
* [Pagination](#pagination)
* [Authentication](#authentication)
* [Routes](#routes)
    * [root](#root)
    * [heartbeat](#heartbeat)
    * [docs](#docs)
    * [species](#species)
    * [species by id](#species-by-id)
    * [genera](#genera)
    * [genera by id](#genera-by-id)
    * [common name](#comnames)
    * [country](#country)
    * [countref](#countref)
    * [diet](#diet)
    * [ecology](#ecology)
    * [fecundity](#fecundity)
    * [fooditems](#fooditems)
    * [fao areas routes](#fao-areas-routes)
        * [faoarref](#faoarref)
        * [faoareas](#faoareas)

## Base URL

http://fishbase.ropensci.org

## HTTP methods

This is essentially a `read only` API. That is, we only allow `GET` requests on this API. 

Requests of all other types will be rejected, including `POST`, `PUT`, `COPY`, `HEAD`, `DELETE`.

## Response Codes

* 200 (OK) - request good!
* 302 (Found) - the root `/`, redirects to `/heartbeat`, and `/docs` redirects to these documents
* 400 (Bad request) - occurs when you have a malformed request, fix it and try again
* 404 (Not found) - occurs when you request a route that does not exist, fix it and try again
* 500 (Internal server error) - Server got itself in trouble; get in touch with us.


`400` responses will look something like 

```
HTTP/1.1 400 Bad Request
Cache-Control: public, must-revalidate, max-age=60
Connection: close
Content-Length: 61
Content-Type: application/json
Date: Thu, 26 Feb 2015 23:27:57 GMT
Server: nginx/1.7.9
Status: 400 Bad Request
X-Content-Type-Options: nosniff

{
    "error": "invalid request",
    "message": "maximum limit is 5000"
}
```

`404` responses will look something like 

```
HTTP/1.1 404 Not Found
Cache-Control: public, must-revalidate, max-age=60
Connection: close
Content-Length: 27
Content-Type: application/json
Date: Thu, 26 Feb 2015 23:27:16 GMT
Server: nginx/1.7.9
Status: 404 Not Found
X-Cascade: pass
X-Content-Type-Options: nosniff

{
    "error": "route not found"
}
```

`500` responses will look something like 

```
HTTP/1.1 500 Internal Server Error
Cache-Control: public, must-revalidate, max-age=60
Connection: close
Content-Length: 24
Content-Type: application/json
Date: Thu, 26 Feb 2015 23:19:57 GMT
Server: nginx/1.7.9
Status: 500 Internal Server Error
X-Content-Type-Options: nosniff

{
    "error": "server error"
}
```

### Response headers

`200` response header will look something like 

```
Access-Control-Allow-Methods: HEAD, GET
Access-Control-Allow-Origin: *
Cache-Control: public, must-revalidate, max-age=60
Connection: close
Content-Length: 10379
Content-Type: application/json; charset=utf8
Date: Mon, 09 Mar 2015 23:01:23 GMT
Server: nginx/1.7.10
Status: 200 OK
X-Content-Type-Options: nosniff
```

## Media Types

We use server up JSON in this API. All responses will have `Content-Type: application/json; ; charset=utf8`.

## Pagination

The query parameters `limit` (default = 10) and `offset` (default = 0) are always sent on the request.

The response body from the server will include data on records found in `count` and number
returned in `returned`:

* `"count": 1056`
* `"returned": 10`

## Authentication

We don't use any. Cheers :)

## Routes

### root

> GET [/]

Get heartbeat for the Fishbase API [GET]

This path redirects to `/heartbeat`
    
+ Response 302 (application/json)

        See `/heartbeat`

### heartbeat 

> GET [/heartbeat]

Get heartbeat for the Fishbase API [GET]
    
+ Response 200
    + [Headers](#response-headers)
    + Body
    ```
            [{
                "routes": [
                    "/docs",
                    "/heartbeat",
                    "/mysqlping",
                    "/comnames?<params>",
                    "/countref?<params>",
                    "/country?<params>",
                    "/diet?<params>",
                    "/morphdat?<params>",
                    "/morphmet?<params>",
                    ...
                ]
            }]
    ```

### docs 

> GET [/docs]

Go to the Fishbase API documentation

This path redirects to `http://docs.fishbaseapi.apiary.io`
    
+ Response 302 (application/json)

See [docs.fishbaseapi.apiary.io](http://docs.fishbaseapi.apiary.io) or you can look at this page

### species

> GET [/species{?genus}{?species}{?limit}{?offset}{?fields}]
 
List species

+ Parameters
    + genus (string, optional) ... String `name` of a genus.
    + species (string, optional) ... String `name` of a specific epithet.
    + limit (integer, optional) ... `number` of records to return.
            + Default: `10`
    + offset (integer, optional) ... Record `number` to start at.
            + Default: `0`
    + fields (string, optional, `SpecCode,Vulnerability`) ... Comma-separated `string` of fieds to return.
    
+ Response 200
    + [Headers](#response-headers)
    + Body
```
            [{
                "count": 1,
                "data": [
                {
                    "AnaCat": "potamodromous",
                    "AquacultureRef": 12108,
                    "Aquarium": "never/rarely",
                    "AquariumFishII": " ",
                    "AquariumRef": null,
                    "Author": "(Linnaeus, 1758)",
                    ...<cutoff>
                }
                ],
                "error": null,
                "returned": 1
            }]
```        

### Species by id 

> GET [/species/{id}]

List species by id

+ Parameters
    + id (integer, required, `5`) ... Species id `number`.
    
+ Response 200
    + [Headers](#response-headers)
    + Body
```
            [{
                "count": 1,
                "data": [
                {
                    "AnaCat": "oceanodromous",
                    "AquacultureRef": null,
                    "Aquarium": "public aquariums",
                    "AquariumFishII": "based mainly on capture",
                    "AquariumRef": 7251,
                    "Author": "(Linnaeus, 1766)",
                    ...<cutoff>
                }
                ],
                "error": null,
                "returned": 1
            }]
```
        
### Genera 

> GET [/genera{?genus}{?species}{?limit}{?offset}{?fields}]

List genera

+ Parameters
    + genus (string, optional, `Abalistes`) ... String `name` of a genus.
    + species (string, optional, `filamentosus`) ... String `name` of a specific epithet.
    + limit (integer, optional, `10`) ... `number` of records to return.
    + offset (integer, optional, `0`) ... Record `number` to start at.
    + fields (string, optional, `SpeciesCount,AreaCode`) ... Comma-separated `string` of fieds to return.
    
+ Response 200
    + [Headers](#response-headers)
    + Body
    
            [{
                "count": 1,
                "data": [
                {
                    "AnaCat": "potamodromous",
                    "AquacultureRef": 12108,
                    "Aquarium": "never/rarely",
                    "AquariumFishII": " ",
                    "AquariumRef": null,
                    "Author": "(Linnaeus, 1758)",
                    ...<cutoff>
                }
                ],
                "error": null,
                "returned": 1
            }]
       
### Genera by id 

> GET [/genera/{id}]

List genera by id

+ Parameters
    + id (required, integer, `5`) ... Genus id `number`.
    
+ Response 200
    + [Headers](#response-headers)
    + Body
    
            [{
                "count": 1,
                "data": [
                {
                    "AnaCat": "potamodromous",
                    "AquacultureRef": 12108,
                    "Aquarium": "never/rarely",
                    "AquariumFishII": " ",
                    "AquariumRef": null,
                    "Author": "(Linnaeus, 1758)",
                    ...<cutoff>
                }
                ],
                "error": null,
                "returned": 1
            }]
       
### comnames 

> GET [/comnames{?limit}{?offset}{?fields}]

Search the common names table 

+ Parameters
    + limit (optional, integer, `10`) ... `number` of records to return.
            + Default: `10`
    + offset (optional, integer, `0`) ... Record `number` to start at.
            + Default: `0`
    + fields (optional, string, `AreaCode`) ... Comma-separated `string` of fieds to return.
    
+ Response 200
    + [Headers](#response-headers)
    + Body
    
            [{
                {
                    "count": 302109,
                    "returned": 10,
                    "error": null,
                    "data": [
                    {
                        "autoctr": 236404,
                        "ComName": " ???????",
                        "Transliteration": "Varimeen",
                        "StockCode": 135,
                        "SpecCode": 121,
                        "C_Code": "356",
                        "Language": "Telugu",
                        "Script": "Telugu",
                        ...<cutoff>
                    }]
                }
            }]

### country 

> GET [/country{?limit}{?offset}{?fields}]

Search the country table

+ Parameters
    + limit (optional, integer, `10`) ... `number` of records to return.
            + Default: `10`
    + offset (optional, integer, `0`) ... Record `number` to start at.
            + Default: `0`
    + fields (optional, string, `CountryRefNo`) ... Comma-separated `string` of fieds to return.
    
+ Response 200
    + [Headers](#response-headers)
    + Body
    
            [{
                {
                    "count": 180452,
                    "returned": 10,
                    "error": null,
                    "data": [
                    {
                        "Abundance": null,
                        "AlsoRef": null,
                        "Aquaculture": "never/rarely",
                        "Bait": 0,
                        "Brackish": 1,
                        "C_Code": "428",
                        "Comments": null,
                        "CountryRefNo": 188,
                        ...<cutoff>
                    }]
                }
            }]
            
### countref 

> GET [/countref{?limit}{?offset}{?fields}]

Count ref

+ Parameters
    + limit (optional, integer, `10`) ... `number` of records to return.
    + offset (optional, integer, `0`) ... Record `number` to start at.
    + fields (optional, string, `AreaCode`) ... Comma-separated `string` of fieds to return.
    
+ Response 200
    + [Headers](#response-headers)
    + Body
    
            [{
                {
                    "count": 312,
                    "returned": 10,
                    "error": null,
                    "data": [
                    {
                        "ABB": "AFG",
                        "ACP": 0,
                        "Area": 652225,
                        "AreaCodeInland": 4,
                        "AreaCodeMarineI": null,
                        "AreaCodeMarineII": null,
                        "AreaCodeMarineIII": null,
                        ...<cutoff>
                    }]
                }
            }]


### diet 

> GET [/diet{?limit}{?offset}{?fields}]

Search the fish diet table

+ Parameters
    + limit (integer, optional, `10`) ... `number` of records to return.
            + Default: `10`
    + offset (integer, optional, `0`) ... Record `number` to start at.
            + Default: `0`
    + fields (optional, string, `CountryRefNo`) ... Comma-separated `string` of fieds to return.
    
+ Response 200
    + [Headers](#response-headers)
    + Body
    
            [{
                {
                    "count": 51059,
                    "returned": 10,
                    "error": null,
                    "data": [
                    {
                        "April": -1,
                        "August": 0,
                        "C_Code": "826",
                        "DateChecked": null,
                        "DateEntered": "1995-07-29 00:00:00 +0000",
                        "DateModified": "2010-12-17 00:00:00 +0000",
                        "December": 0,
                        "DietCode": 1,
                        ...<cutoff>
                    }]
                }
            }]


### ecology 

> GET [/ecology{?limit}{?offset}{?fields}]

Search the ecology table

+ Parameters
    + limit (integer, optional, `10`) ... `number` of records to return.
            + Default: `10`
    + offset (integer, optional, `0`) ... Record `number` to start at.
            + Default: `0`
    + fields (optional, string, `CountryRefNo`) ... Comma-separated `string` of fieds to return.
    
+ Response 200
    + [Headers](#response-headers)
    + Body
    
            [{
                {
                    "count": 10506,
                    "returned": 10,
                    "error": null,
                    "data": [
                    {
                        "AssociationRef": null,
                        "AssociationsRemarks": null,
                        "AssociationsWith": null,
                        "Bathypelagic": 0,
                        "BedsBivalve": 0,
                        "BedsOthers": 0,
                        "BedsRock": 0,
                        "Benthic": 0,
                        "BetweenPolyps": 0,
                        ...<cutoff>
                    }]
                }
            }]
            
### fecundity 

> GET [/fecundity{?limit}{?offset}{?fields}]

Search the fecundity table

+ Parameters
    + limit (integer, optional, `10`) ... `number` of records to return.
            + Default: `10`
    + offset (integer, optional, `0`) ... Record `number` to start at.
            + Default: `0`
    + fields (optional, string, `CountryRefNo`) ... Comma-separated `string` of fieds to return.
    
+ Response 200
    + [Headers](#response-headers)
    + Body
    
            [{
                {
                    "count": 2911,
                    "returned": 10,
                    "error": null,
                    "data": [
                    {
                        "FecunMinRef": 10439,
                        "FecundityMax": 289400,
                        "FecundityMin": 33800,
                        "FecundityRef": 10439,
                        "LengthFecunMax": 42.0,
                        "LengthFecunMin": 20.2,
                        ...<cutoff>
                    }]
                }
            }]
            
### fooditems 

> GET [/fooditems{?limit}{?offset}{?fields}]

Search the fooditems table

+ Parameters
    + limit (integer, optional, `10`) ... `number` of records to return.
            + Default: `10`
    + offset (integer, optional, `0`) ... Record `number` to start at.
            + Default: `0`
    + fields (optional, string, `CountryRefNo`) ... Comma-separated `string` of fieds to return.
    
+ Response 200
    + [Headers](#response-headers)
    + Body
    
            [{
                {
                    "count": 2911,
                    "returned": 10,
                    "error": null,
                    "data": [
                    {
                        "FoodI": "plants",
                        "FoodII": "phytoplankton",
                        "FoodIII": "blue-green algae",
                        "Foodgroup": "Merismopedioideae",
                        "Foodname": "Merismopedia",
                        "FoodsRefNo": 5410,
                        "Locality": "Lake Awasa.",
                        ...<cutoff>
                    }]
                }
            }]

### fao areas routes

#### faoarref 

> GET [/faoarref{?limit}{?offset}{?fields}]

+ Parameters
    + limit (optional, integer, `10`) ... `number` of records to return.
    + offset (optional, integer, `0`) ... Record `number` to start at.
    + fields (optional, string, `AreaCode,FAO`) ... Comma-separated `string` of fieds to return.
    
+ Response 200
    + [Headers](#response-headers)
    + Body
    
            [{
                "count": 28,
                "data": [
                    {
                    "AreaCode": 1,
                    "Coastline": 37908,
                    "Complete": -1,
                    "CompleteRef": 594,
                    "ContinentGrp": "Africa",
                    "EEZarea": 11981.0,
                    "E_W": "E",
                    "EasternLongitude": 78,
                    ...<cutoff>
                }
                ],
                "error": null,
                "returned": 10
            }]
            
#### faoareas 

> GET [/faoareas{?limit}{?offset}{?fields}]

+ Parameters
    + limit (optional, integer, `10`) ... `number` of records to return.
    + offset (optional, integer, `0`) ... Record `number` to start at.
    + fields (optional, string, `AreaCode`) ... Comma-separated `string` of fieds to return.
    
+ Response 200
    + [Headers](#response-headers)
    + Body
    
            [{
                "count": 28,
                "data": [
                    {
                    "AreaCode": 1,
                    "Coastline": 37908,
                    "Complete": -1,
                    "CompleteRef": 594,
                    "ContinentGrp": "Africa",
                    "EEZarea": 11981.0,
                    "E_W": "E",
                    "EasternLongitude": 78,
                    ...<cutoff>
                }
                ],
                "error": null,
                "returned": 10
            }]
