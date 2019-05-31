# Fishbase API

The Fishbase API is the new API for [Fishbase.org](http://www.fishbase.org/).

## Contents

* [Base url](#base-url)
* [HTTP methods](#http-methods)
* [Response codes](#response-codes)
* [Media types](#media-types)
* [Pagination](#pagination)
* [Authentication](#authentication)
* [Parameters](#parameters)
    * [Common parameters](#common-parameters)
    * [Additional parameters](#additional-parameters)
* [Routes](#routes)
    * [root](#root)
    * [heartbeat](#heartbeat)
    * [docs](#docs)
    * [common name](#comnames)
    * [countref](#countref)
    * [country](#country)
    * [diet](#diet)
    * [ecology](#ecology)
    * [ecosystem](#ecosystem)
    * [fao areas routes](#fao-areas-routes)
        * [faoareas](#faoareas)
        * [faoareas by id](#faoareas-by-id)
        * [faoarref](#faoarref)
        * [faoarref by id](#faoarref-by-id)
    * [fecundity](#fecundity)
    * [fooditems](#fooditems)
    * [genera](#genera)
    * [genera by id](#genera-by-id)
    * [intrcase](#intrcase)
    * [listfields](#listfields)
    * [maturity](#maturity)
    * [morphdat](#morphdat)
    * [morphmet](#morphmet)
    * [occurrence](#occurrence)
    * [oxygen](#oxygen)
    * [popchar](#popchar)
    * [popgrowth](#popgrowth)
    * [poplf](#poplf)
    * [popll](#popll)
    * [popqb](#popqb)
    * [poplw](#poplw)
    * [predats](#predats)
    * [ration](#ration)
    * [refrens](#refrens)
    * [reproduc](#reproduc)
    * [species](#species)
    * [species by id](#species-by-id)
    * [spawning](#spawning)
    * [speed](#speed)
    * [stocks](#stocks)
    * [swimming](#swimming)
    * [synonyms](#synonyms)
    * [taxa](#taxa)

## Base URL

http://fishbase.ropensci.org

## HTTP methods

This is essentially a `read only` API. That is, we only allow `GET` (and `HEAD`) requests on this API.

Requests of all other types will be rejected with appropriate `405` code, including `POST`, `PUT`, `COPY`, `HEAD`, `DELETE`, etc.

## Response Codes

* 200 (OK) - request good!
* 302 (Found) - the root `/`, redirects to `/heartbeat`, and `/docs` redirects to these documents
* 400 (Bad request) - When you have a malformed request, fix it and try again
* 404 (Not found) - When you request a route that does not exist, fix it and try again
* 405 (Method not allowed) - When you use a prohibited HTTP method (we only allow `GET` and `HEAD`)
* 500 (Internal server error) - Server got itself in trouble; get in touch with us. (in [Issues](https://github.com/ropensci/fishbaseapi/issues))


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

`405` responses will look something like (with an empty body)

```
HTTP/1.1 405 Method Not Allowed
Access-Control-Allow-Methods: HEAD, GET
Access-Control-Allow-Origin: *
Cache-Control: public, must-revalidate, max-age=60
Connection: close
Content-Length: 0
Content-Type: application/json; charset=utf8
Date: Mon, 27 Jul 2015 20:48:27 GMT
Server: nginx/1.9.3
Status: 405 Method Not Allowed
X-Content-Type-Options: nosniff
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

### Response bodies

Response bodies generally look like:

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

Successful requests have 4 slots: 

* count: Number records found 
* returned: Number records returned
* error: If an error did not occur this is `null`, otherwise, an error message.
* data: The hash of data if any data returned. If no data found, this is an empty hash (hash of length zero)

## Media Types

We serve up only JSON in this API. All responses will have `Content-Type: application/json; charset=utf8`.

## Pagination

The query parameters `limit` (default = 10) and `offset` (default = 0) are always sent on the request (this doesn't apply to some routes, which don't accept any parameters (e.g., `/docs`)).

The response body from the server will include data on records found in `count` and number returned in `returned`:

* `"count": 1056`
* `"returned": 10`

Ideally, we'd put in a helpful [links object](http://jsonapi.org/format/#fetching-pagination) - hopefully we'll get that done in the future. 

## Authentication

We don't use any. Cheers :)

## Parameters

### Common parameters

+ limit (integer, optional) `number` of records to return.
    + Default: `10`
+ offset (integer, optional) Record `number` to start at.
    + Default: `0`
+ fields (string, optional) Comma-separated `string` of fieds to return.
    + Example: `SpecCode,Vulnerability`

Above parameters common to all routes except:

* [root](#root)
* [heartbeat](#heartbeat)
* [docs](#docs)
* [mysqlping](#mysqlping)

In addition, these do not support `limit` or `offset`:

* [listfields](#listfields)
 
### Additional parameters

Right now, any field that is returned from a route can also be queried on, except for the [/taxa route](#taxa), which only accepts `species` and `genus` in addition to the common parameters. All of the fields from each route are too long to list here - inspect data returned from a small data request, then change your query as desired.

Right now, parameters that are not found are silently dropped. For example, if you query with `/species?foo=bar` in a query, and `foo` is not a field in `species` route, then the `foo=bar` part is ignored. We may in the future error when parameters are not found.

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
                    "/docs/:table?",
                    "/heartbeat",
                    "/mysqlping",
                    "/comnames?<params>",
                    "/countref?<params>",
                    "/country?<params>",
                    "/diet?<params>",
                    "/ecology?<params>",
                    "/ecosystem?<params>",
                    ...
                ]
            }]
    ```

### docs

> GET [/docs]

Get brief description of each table in the Fishbase database. 

+ Response 200 (application/json)
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### docs by table

> GET [/docs/{table}]

Get all field names in a table. In the future, the returned data will include metadata on what each field means (understandable to a human), and what kind of data each field holds.

+ Response 200 (application/json)
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### mysqlping

> GET [/myslping]

Ping the MySQL server to see if it's up or not. Returns logical.

### comnames

> GET [/comnames{?limit}{?offset}{?fields}]

Search the common names table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### countref

> GET [/countref{?limit}{?offset}{?fields}]

Count ref

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### country

> GET [/country{?limit}{?offset}{?fields}]

Search the country table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### diet

> GET [/diet{?limit}{?offset}{?fields}]

Search the fish diet table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### ecology

> GET [/ecology{?limit}{?offset}{?fields}]

Search the ecology table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### ecosystem

> GET [/ecosystem{?limit}{?offset}{?fields}]

Search the ecosystem table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### fao areas routes

#### faoareas

> GET [/faoareas{?limit}{?offset}{?fields}]

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

#### faoareas by id

> GET [/faoareas{id}]

List faoareas by id

+ Parameters
    + id (required, integer, `5`) ... faoarea id `number`.

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)
    
#### faoarref

> GET [/faoarref{?limit}{?offset}{?fields}]

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

#### faoarref by id

> GET [/faoarref{id}]

List faoareas by id

+ Parameters
    + id (required, integer, `5`) ... faoarref id `number`.

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### fecundity

> GET [/fecundity{?limit}{?offset}{?fields}]

Search the fecundity table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### fooditems

> GET [/fooditems{?limit}{?offset}{?fields}]

Search the fooditems table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### Genera

> GET [/genera{?genus}{?species}{?limit}{?offset}{?fields}]

List genera

+ Parameters
    + genus (string, optional, `Abalistes`) ... String `name` of a genus.
    + species (string, optional, `filamentosus`) ... String `name` of a specific epithet.

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### Genera by id

> GET [/genera/{id}]

List genera by id

+ Parameters
    + id (required, integer, `5`) ... Genus id `number`.

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### intrcase

> GET [/intrcase{?limit}{?offset}{?fields}]

Search the intrcase table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### listfields

> GET [/listfields{?fields}{?exact}]

List fields across all tables. Optionally, search for particular fields. In addition, toggle the `exact` parameter to search for an exact match.

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### maturity

> GET [/maturity{?limit}{?offset}{?fields}]

Search the maturity table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### morphdat

> GET [/morphdat{?limit}{?offset}{?fields}]

Search the morphdat table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### morphmet

> GET [/morphmet{?limit}{?offset}{?fields}]

Search the morphmet table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### occurrence

> GET [/occurrence{?limit}{?offset}{?fields}]

Search the occurrence table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### oxygen

> GET [/oxygen{?limit}{?offset}{?fields}]

Search the oxygen table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### popchar

> GET [/popchar{?limit}{?offset}{?fields}]

Search the popchar table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### popgrowth

> GET [/popgrowth{?limit}{?offset}{?fields}]

Search the popgrowth table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### poplf

> GET [/poplf{?limit}{?offset}{?fields}]

Search the poplf table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)


### popll

> GET [/popll{?limit}{?offset}{?fields}]

Search the popll table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### popqb

> GET [/popqb{?limit}{?offset}{?fields}]

Search the popqb table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)


### poplw

> GET [/poplw{?limit}{?offset}{?fields}]

Search the poplw table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### predats

> GET [/predats{?limit}{?offset}{?fields}]

Search the predats table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)


### ration

> GET [/ration{?limit}{?offset}{?fields}]

Search the ration table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### refrens

> GET [/refrens{?limit}{?offset}{?fields}]

Search the refrens table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### reproduc

> GET [/reproduc{?limit}{?offset}{?fields}]

Search the reproduc table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### species

> GET [/species{?genus}{?species}{?limit}{?offset}{?fields}]

List species

+ Parameters
    + genus (string, optional) ... String `name` of a genus.
    + species (string, optional) ... String `name` of a specific epithet.

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### Species by id

> GET [/species/{id}]

List species by id

+ Parameters
    + id (integer, required, `5`) ... Species id `number`.

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### spawning

> GET [/spawning{?limit}{?offset}{?fields}]

Search the spawning table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### speed

> GET [/speed{?limit}{?offset}{?fields}]

Search the speed table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### stocks

> GET [/stocks{?limit}{?offset}{?fields}]

Search the stocks table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### swimming

> GET [/swimming{?limit}{?offset}{?fields}]

Search the swimming table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### synonyms

> GET [/synonyms{?limit}{?offset}{?fields}]

Search the synonyms table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### taxa

> GET [/taxa{?limit}{?offset}{?fields}]

The taxa route is a combined search using the species, genera, and families tables. 

The taxa route supports fuzzy seaerch for the two parameters: genus and species. Those two parameters are searched on the species table.

+ Parameters
    + genus (string, optional) Genus name
    + species (string, optional) Specific epithet name
+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)
