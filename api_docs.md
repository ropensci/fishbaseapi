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
    * [species](#species)
    * [species by id](#species-by-id)
    * [genera](#genera)
    * [genera by id](#genera-by-id)
    * [common name](#comnames)
    * [country](#country)
    * [countref](#countref)
    * [diet](#diet)
    * [ecology](#ecology)
    * [fao areas routes](#fao-areas-routes)
        * [faoarref](#faoarref)
        * [faoareas](#faoareas)
    * [fecundity](#fecundity)
    * [fooditems](#fooditems)
    * [genera](#fooditems)
    * [intrcase](#intrcase)
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
    * [spawning](#spawning)
    * [species](#species)
    * [speed](#speed)
    * [stocks](#stocks)
    * [swimming](#swimming)
    * [synonyms](#synonyms)
    * [taxa](#taxa)

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

### Additional parameters

Right now, any field that is returned from a route can also be queried on, except for the [/taxa route](#taxa), which only accepts `species` and `genus` in addition to the common parameters. All of the fields from each route are too long to list here - inspect data returned from a small data request, then change your query as desired.


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

### mysqlping

> GET [/myslping]

Ping the MySQL server to see if it's up or not. Returns logical.

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

### comnames

> GET [/comnames{?limit}{?offset}{?fields}]

Search the common names table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### country

> GET [/country{?limit}{?offset}{?fields}]

Search the country table

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### countref

> GET [/countref{?limit}{?offset}{?fields}]

Count ref

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

### fao areas routes

#### faoarref

> GET [/faoarref{?limit}{?offset}{?fields}]

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

#### faoareas

> GET [/faoareas{?limit}{?offset}{?fields}]

+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)

### intrcase

> GET [/intrcase{?limit}{?offset}{?fields}]

Search the intrcase table

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

Search the taxa table

+ Parameters
    + genus (string, optional) Genus name
    + species (string, optional) Specific epithet name
+ Response 200
    + [Headers](#response-headers)
    + [Body](#response-bodies)
