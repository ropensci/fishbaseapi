Fishbase API
=======

Draft Fishbase API - using Ruby's Sinatra framework

`jq` is used below to make examples brief - get it at [http://stedolan.github.io/jq/](http://stedolan.github.io/jq/).

## Clone this repo

```sh
git clone git@github.com:ropensci/fishbaseapi.git
cd fishbaseapi
bundle install
```

## Start Sinatra

```sh
cd fishbaseapi
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
    paths: [
        "/heartbeat",
        "/species/:id?params..."
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
    "error": null
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


## limit number of results

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

## get certain fields back

```sh
http 'http://localhost:4567/species/?genus=Aborichthys&fields=Genus,Length'
```

```sh
{
    "count": 5,
    "data": [
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
    ],
    "error": null
}
```
