# Examples

Note: We'll use [jq](http://stedolan.github.io/jq/) below in some example to simplify examples. If you don't know jq already, it's worth learning.

* [API heartbeat](#heartbeat)
* [List tables in SQL DB](#docs)
* [Querying tables](#querying-tables)
    * [Basic query](#basic-query)
    * [Limit](#limit)
    * [Offset](#offset)
    * [Fields](#fields)
* [Query by id](#by-id)

## Heartbeat

```
curl 'http://fishbase.ropensci.org/heartbeat'
```

```
{
  "routes": [
    "/docs/:table?",
    "/heartbeat",
    "/mysqlping",
    "/comnames?<params>",
...
```

`curl -L 'http://fishbase.ropensci.org'` does the same thing

## Docs

All tables

```
curl 'http://fishbase.ropensci.org/docs'
```

```
{
  "count": 37,
  "returned": 37,
  "error": null,
  "data": [
    {
      "table": "heartbeat",
      "description": "API endpoint to confirm that the API is up. Lists all available endpoints",
      "links": null
    },
    {
      "table": "mysqlping",
      "description": "API endpoint to test the status of the database",
      "links": null
    },
...
```

A single table (here, the `species` table)

```
curl 'http://fishbase.ropensci.org/docs/species'
```

```
{
  "count": 99,
  "returned": 99,
  "error": null,
  "data": [
    {
      "table_name": "species",
      "column_name": "SpecCode"
    },
    {
      "table_name": "species",
      "column_name": "Genus"
    },
...
```

## Querying tables

Most of the routes follow a common pattern, and accept a set of the same parameters.

### Basic query

We'll use the `fields` parameter to select a small set of fields, and the `limit` parameter to give back just a few results, to keep examples brief.

```
curl 'http://fishbase.ropensci.org/comnames?fields=ComName,Language&limit=3'
```

```
{
  "count": 305636,
  "returned": 3,
  "error": null,
  "data": [
    {
      "ComName": "\"Ala'ihi",
      "Language": "Hawaiian"
    },
    {
      "ComName": "'A'a",
      "Language": "Samoan"
    },
    {
      "ComName": "'A'ava",
      "Language": "Marquesan"
    }
  ]
}
```


### Limit

The `limit` parameter is available in most routes, and is by default set to 10. 

```
curl 'http://fishbase.ropensci.org/comnames?limit=3' | jq '.data | length'

3
```

```
curl 'http://fishbase.ropensci.org/comnames?limit=30' | jq '.data | length'

30
```

### Offset

The `offset` parameter is available in most routes, and is by default set to 0. This parameter allows you to set the record at which you start to retrieve data. You can use this in combination with the `limit` parameter to page through results. 

```
curl 'http://fishbase.ropensci.org/comnames?limit=1&fields=ComName'
```

```
{
  "count": 305636,
  "returned": 1,
  "error": null,
  "data": [
    {
      "ComName": "\"Ala'ihi"
    }
  ]
}
```

vs. 

```
curl 'http://fishbase.ropensci.org/comnames?limit=1&offset=1&fields=ComName'
```

```
{
  "count": 305636,
  "returned": 1,
  "error": null,
  "data": [
    {
      "ComName": "'A'a"
    }
  ]
}
```


### Fields

The `fields` parameter allows you to determine what fields are returned. This requires knowing what fields can be returned. Thus, we suggest doing a small query (e.g., `limit=1`) to get possible fields, then another request with the `fields` parameter to determine what comes back. 

```
curl 'http://fishbase.ropensci.org/ecosystem?limit=1'
```

```
{
  "count": 134770,
  "returned": 1,
  "error": null,
  "data": [
    {
      "autoctr": 1,
      "E_CODE": 1,
      "EcosystemRefno": 50628,
      "Speccode": 549,
      "Stockcode": 565,
      "Status": "native",
      "Abundance": null,
      "LifeStage": "adults",
      "Remarks": null,
      "Entered": 10,
      "Dateentered": "2007-11-12 00:00:00 +0000",
      "Modified": null,
      "Datemodified": "2007-11-12 00:00:00 +0000",
      "Expert": null,
      "Datechecked": null,
      "WebURL": null,
      "TS": null
    }
  ]
}
```

Now we can get back a subset of fields that we are interested in:

```
curl 'http://fishbase.ropensci.org/ecosystem?limit=1&fields=LifeStage,Remarks,Dateentered'
```

```
{
  "count": 134770,
  "returned": 1,
  "error": null,
  "data": [
    {
      "LifeStage": "adults",
      "Remarks": null,
      "Dateentered": "2007-11-12 00:00:00 +0000"
    }
  ]
}
```


## By id

A few routes support querying by id in the route itself (e.g., `/species/5`). Those are: 

* `/species`
* `/genera`
* `/faoareas`
* `/faoarref`

An example:

```
curl 'http://fishbase.ropensci.org/species/3?fields=Genus,Species,Saltwater,DepthRangeShallow'
```

```
{
  "count": 1,
  "returned": 1,
  "error": null,
  "data": [
    {
      "Genus": "Oreochromis",
      "Species": "mossambicus",
      "Saltwater": 0,
      "DepthRangeShallow": 1
    }
  ]
}
```
