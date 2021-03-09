FishBase API
============

<!-- [![Build Status](https://travis-ci.org/ropensci/fishbaseapi.svg)](https://travis-ci.org/ropensci/fishbaseapi) -->

This is a volunteer effort from rOpenSci to provide a modern [RESTful API](http://en.wikipedia.org/wiki/Representational_state_transfer) to the backend SQL database behind the popular web resource <http://fishbase.org>. The FishBase team provides snapshots of the database 1 to a few times per year.

User quick start
----------------

The server may sometimes be unavailable due to server outages.

- API base url: <https://fishbase.ropensci.org>
- API documentation: <https://fishbaseapi.readme.io/>
- The [rfishbase2.0](https://github.com/ropensci/rfishbase/tree/rfishbase2.0) R package provides a convenient and powerful way to interact with the API.

Letsencrypt
-----------
We use [Letsencrypt](https://letsencrypt.org/) for https certs.

Technical specifications
------------------------

### Quick start

- **Dependencies**: Any machine with Docker installed, see: [docs.docker.com/installation](http://docs.docker.com/installation)
- [Download](https://github.com/ropensci/fishbaseapi/archive/master.zip) or clone the fishbaseapi repository
- Place a snapshot of the FishBase SQL dump (not provided) in a file called `fbapp.sql` inside the downloaded directory.

- From that directory, run the `mysqp-helpers/import.sh` bash script, which will use Docker to import the dump into a MySQL docker container. This may take a while but needs only be done once.
- Run the `docker.sh` script to launch the API.  (Alternately, the containers can be launched with `fig up`, or using the `fleet` service files provided for the CoreOS architecture.)

### Technical overview

- The API is written in Ruby using the Sinatra Framework. Currently all API methods are defined in the `api.rb` file. The Dockerfile included here defines the runtime environment required, which is downloaded automatically from Docker Hub as the [ropensci/fishbaseapi](https://registry.hub.docker.com/u/ropensci/fishbaseapi/) container.
- The API is served through a ruby unicorn server running behind a Letsencrypt proxy
- The API sends queries to a separate, linked MariaDB container (using the official Docker MariaDB image).
- API queries are cached in a REDIS database provided by a linked REDIS container (again using an official Docker image)

See the `docker.sh` script which orchestrates the linking and running of these separate containers.

Design principles
-----------------

### RESTful design

The API implementation follows RESTful design.  Data is queried by means of `GET` requests to specific URL endpoints, e.g.

```
GET https://fishbaseapi.info/species/2
```

Or optionally, using particular queries

```
GET https://fishbaseapi.info/species?Genus=Labroides
```

```
GET https://fishbaseapi.info/species?Genus=Labroides&fields=Species
```

Queries return data in the JSON format. By default a limit of 10 entries matching the query are returned, though this can be configured by appending the `&limit=` option to the query URL. Simply visit any of these URLs in a browser for an example return object.


### API Endpoints

The API design is to some extent constrained by the existing schema of the FishBase.org database.  At this time, endpoints correspond 1:1 with the tables of the database, and are named accordingly.  Future endpoints may provide more higher-level synthesis.  At this time, endpoints are implemented manually as time allows and existing use cases suggest; see [issue #2](https://github.com/ropensci/fishbaseapi/issues/2#issuecomment-73113433) for an overview.

Richer processing of (some of) the endpoint returns can be done client-side, as illustrated in the (in-development) [rfishbase2.0](https://github.com/ropensci/rfishbase/tree/rfishbase2.0) R client for the API.

### Database version

The Fishbase API supports multiple different versions.

You can request a different database version with a header like the following:

```
Accept: application/vnd.ropensci.v11+json
```

Where `201812` follows the format `YYYYMM` (four digits for year, then two digits for month, with no spaces/characters between them).

By default, we return the latest date version.

See the `/versions` route for description of the different versions and their names.

In the R client `rfishbase` the database version will likely be controlled by a parameter or option/env var, so users won't have to pass headers themselves.

### Why Docker?

Docker provides a fast and robust way to deploy all the necessary software required for the API on almost any platform. By using separate containers for the different services associated with the API, it becomes easier to scale the API across a cluster, isolate and diagnose points of failure. Individual containers providing services such as the MySQL database or REDIS cache can be restarted without disrupting other services of the API.
