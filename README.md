Fishbase API
=======

Draft Fishbase API - using Ruby's Sinatra framework

`http` is a command line tool from the Python library [httpie](https://github.com/jakubroztocil/httpie) used below - `curl` will do that same thing.

`jq` is used below to make examples brief - get it at [http://stedolan.github.io/jq/](http://stedolan.github.io/jq/).

This is being developed on a local machine - will be on a public server soon (hopefully). Data is not included in this repo, so you can't actually follow the below instructions, unless you have the DB :)

## Base URL

will be here when there's a public url, for testing locally it's `http://localhost:4567`

## The endpoints so far

* `/heartbeat`
* `/species`
* `/genera`
* `/faoareas`
* `/faoarrefs`
* `/fooditems`
* `/oxygens`
* `/taxa`
* `/synonyms`
* `/comnames`
* `/populations`

## Setup database

Uncompress the database dump, e.g.: `2013-12-13_10-53-23_fbapp.7z`. Then start mysql and load into mysql

```sh
mysql.server start
mysql -u root fbapp < 2013-12-13_10-53-23_fbapp.sql
```

The load step takes a while...

## Clone

```sh
git clone git@github.com:ropensci/fishbaseapi.git
cd fishbaseapi
```

## Setup

```sh
bundle install
```

## Start Sinatra

```sh
ruby api.rb
```

## Heartbeat

The root `localhost:4567` redirects to `/heartbeat` 

```sh
curl -L http://localhost:4567
# or equivalently curl http://localhost:4567/heartbeat
```

```sh
{
    "paths": [
        "/heartbeat",
        "/species/:id?<params>",
        "/genera/:id?<params>",
        "/faoareas/:id?<params>",
        "/faoarrefs/:id?<params>",
        "/fooditems?<params>",
        "/oxygens?<params>",
        "/taxa?<params>",
        "/synonyms?<params>",
        "/comnames?<params>",
        "/populations?<params>"
    ]
}
```

## Get a species by id 

This id is the `SpecCode` in many tables in the FishBase DB

```sh
curl http://localhost:4567/species/2
```

```sh
{
    "count": 1,
    "data": [
        {
            "AnaCat": "potamodromous",
            "AquacultureRef": 12108,
            "Aquarium": "never/rarely",
            "AquariumFishII": " ",
            "AquariumRef": null,
            "Author": "(Linnaeus, 1758)",
            "BaitRef": null,
            "BodyShapeI": "fusiform / normal",
            "Brack": -1,
            "Comments": "Occur in a wide variety of freshwater habitats like rivers, lakes, sewage canals and irrigation channels (Ref. 28714).  Mainly diurnal.  Feed mainly on phytoplankton or benthic algae.    Oviparous (Ref. 205).  Mouthbrooding by females (Ref. 2). Extended temperature range 8-42 °C, natural temperature range 13.5 - 33 °C (Ref. 3).  Marketed fresh and frozen (Ref. 9987).",
            "CommonLength": null,
            "CommonLengthF": null,
            "CommonLengthRef": null,
            "Complete": null,
            "Dangerous": "potential pest",
            "DangerousRef": null,
            "DateChecked": "2003-01-28 00:00:00 -0800",
            "DateEntered": "1990-10-17 00:00:00 -0700",
            "DateModified": "2013-03-30 00:00:00 -0700",
    ...<cutoff>
        }
    ],
    "error": null,
    "returned": 1
}
```

## Get a species searching by genus

```sh
http 'http://localhost:4567/species/?genus=Aborichthys' | jq '.data[] | {author: .Author, genus: .Genus, species: .Species}'
```

```sh
{
  "species": "elongatus",
  "genus": "Aborichthys",
  "author": "Hora, 1921"
}
{
  "species": "garoensis",
  "genus": "Aborichthys",
  "author": "Hora, 1925"
}
{
  "species": "kempi",
  "genus": "Aborichthys",
  "author": "Chaudhuri, 1913"
}
{
  "species": "rosammai",
  "genus": "Aborichthys",
  "author": "Sen, 2009"
}
{
  "species": "tikaderi",
  "genus": "Aborichthys",
  "author": "Barman, 1985"
}
```


## faoareas

```sh
http 'http://localhost:4567/faoareas/2?limit=2' | jq '.data[]'
```

```sh
{
    "AreaCode": 2,
    "DateChecked": null,
    "DateEntered": "1990-10-19 00:00:00 -0700",
    "DateModified": "1994-04-18 00:00:00 -0700",
    "Entered": 2,
    "Expert": null,
    "Modified": 2,
    "SpecCode": 2,
    "Status": "introduced",
    "StockCode": 1,
    "TS": null,
    "autoctr": 484
},
{
    "AreaCode": 2,
    "DateChecked": null,
    "DateEntered": "1993-08-04 00:00:00 -0700",
    "DateModified": "1994-08-02 00:00:00 -0700",
    "Entered": 2,
    "Expert": null,
    "Modified": null,
    "SpecCode": 3,
    "Status": "introduced",
    "StockCode": 3,
    "TS": null,
    "autoctr": 490
}
```


## faoarrefs

```sh
http 'http://localhost:4567/faoarrefs?limit=3&fields=SpeciesCount,AreaCode,Shelf,Coastline' | jq '.data[]'
```

```sh
{
  "Coastline": 37908,
  "Shelf": 1326,
  "AreaCode": 1,
  "SpeciesCount": 3519
}
{
  "Coastline": 183950,
  "Shelf": 5632,
  "AreaCode": 2,
  "SpeciesCount": 1827
}
{
  "Coastline": 30663,
  "Shelf": 1985,
  "AreaCode": 3,
  "SpeciesCount": 5189
}
```


## Get food items

```sh
http 'http://localhost:4567/fooditems/?limit=3' | jq '.data[] | {species: .SpecCode, food1: .FoodI, food2: .FoodII, food3: .FoodIII}'
```

```sh
{
  "food3": "debris",
  "food2": "detritus",
  "food1": "detritus",
  "species": 2
}
{
  "food3": "debris",
  "food2": "detritus",
  "food1": "detritus",
  "species": 2
}
{
  "food3": "n.a./others",
  "food2": "others",
  "food1": "others",
  "species": 2
}
```


## Get metabolism data from oxygen table

```sh
http 'http://localhost:4567/oxygens?limit=3&speccode=2' | jq '.data[] | {species: .SpecCode, weight: .Weight, salinity: .Salinity, oxygen_consumption: .OxygenCons}'
```

```sh
{
  "oxygen_consumption": 245.89999,
  "salinity": 0,
  "weight": 2.1,
  "species": 2
}
{
  "oxygen_consumption": 185.89999,
  "salinity": 0,
  "weight": 9.2,
  "species": 2
}
{
  "oxygen_consumption": 142.39999,
  "salinity": 0,
  "weight": 9.5,
  "species": 2
}
```

## Taxonomic data endpoint

This endpoint performs a join between the `speices`, `families`, and `genera` tables.

```sh
http 'localhost:4567/taxa/?species=elongatus&limit=3'
```

```sh
{
    "count": 83,
    "data": [
        {
            "Author": "Hora, 1921",
            "Class": "Actinopterygii",
            "FamCode": 692,
            "Family": "Nemacheilidae",
            "GenCode": 784,
            "Genus": "Aborichthys",
            "Order": "Cypriniformes",
            "Remark": null,
            "SpecCode": 24516,
            "Species": "elongatus",
            "SpeciesRefNo": 4832,
            "SubFamily": null,
            "SubGenCode": null
        },
        {
            "Author": "(Regan, 1908)",
            "Class": "Actinopterygii",
            "FamCode": 122,
            "Family": "Cyprinidae",
            "GenCode": 1697,
            "Genus": "Acheilognathus",
            "Order": "Cypriniformes",
            "Remark": "Needs a taxonomic reference.",
            "SpecCode": 9525,
            "Species": "elongatus",
            "SpeciesRefNo": 6376,
            "SubFamily": "Acheilognathinae",
            "SubGenCode": null
        },
        {
            "Author": "(Whitley, 1952)",
            "Class": "Actinopterygii",
            "FamCode": 268,
            "Family": "Aploactinidae",
            "GenCode": 9786,
            "Genus": "Adventor",
            "Order": "Scorpaeniformes",
            "Remark": null,
            "SpecCode": 27470,
            "Species": "elongatus",
            "SpeciesRefNo": 6192,
            "SubFamily": null,
            "SubGenCode": null
        }
    ],
    "error": null,
    "returned": 3
}
```

## Synonyms endpoint

This endpoint only queries the `synonyms` table.

```sh
http 'http://localhost:4567/synonyms?speccode=9&limit=2' | jq '.data[] | {syncode: .SynCode, speccode: .SpecCode, syngenus: .SynGenus, synspecies: .SynSpecies, status: .Status}'
```

```sh
{
  "status": "synonym",
  "synspecies": "stellairs",
  "syngenus": "Abalistes",
  "speccode": 9,
  "syncode": 149720
}
{
  "status": "accepted name",
  "synspecies": "stellaris",
  "syngenus": "Abalistes",
  "speccode": 9,
  "syncode": 53544
}
```


## Modify requests

### limit number of results

```sh
http 'http://localhost:4567/species/?genus=Aborichthys&limit=5' | jq '.data[] | {vulnerability: .Vulnerability, genus: .Genus, length: .Length}'
```

```sh
{
  "length": 5.4,
  "genus": "Aborichthys",
  "vulnerability": 13.79
}
{
  "length": 3.8,
  "genus": "Aborichthys",
  "vulnerability": 10
}
{
  "length": 8.1,
  "genus": "Aborichthys",
  "vulnerability": 21.72
}
{
  "length": null,
  "genus": "Aborichthys",
  "vulnerability": 19.03
}
{
  "length": 10.5,
  "genus": "Aborichthys",
  "vulnerability": 26.05
}
```

### get certain fields back

```sh
http 'http://localhost:4567/species/?genus=Aborichthys&fields=Genus,Length' | jq '.data[]'
```

```sh
{
    "Genus": "Aborichthys",
    "Length": 5.4
},
{
    "Genus": "Aborichthys",
    "Length": 3.8
},
{
    "Genus": "Aborichthys",
    "Length": 8.1
},
{
    "Genus": "Aborichthys",
    "Length": null
},
{
    "Genus": "Aborichthys",
    "Length": 10.5
}
```
