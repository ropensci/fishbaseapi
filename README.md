Fishbase API
=======

Draft Fishbase API - using Ruby's Sinatra framework

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

```sh
curl http://localhost::4567/heartbeat
```

```sh
{
  status: "ok"
}
```

The root redirects to `/heartbeat` (`/heartbeat` gives the same thing)

```sh
curl -L http://localhost:4567
```

```sh
{
    status: "ok",
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
    "error": null,
    "status": "ok"
}
```

## Get a species searching by genus

```sh
http http://localhost:4567/species/?genus=Aborichthys | jq '.data[] | {author: .Author, genus: .Genus, species: .Species}'
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
