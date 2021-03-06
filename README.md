# Cranson-App

#### Description

This is a Rails API application that will be used to serve up planning applications parsed using [Cranson](https://github.com/gary-rafferty/cranson).  

The purpose is to expose an intuitive interface to query and retrieve planning applications.  
Ideally, I'd like to be able to query things like  
- Show me all applications submitted last month.
- Show me all pending applications within 5 kilometres of my house.
- Show me recently decided applications.

For now, I've only looked into the Fingal's dataset (because that's my local authority) but ideally, this could extend to other authorities.
To get an idea of how we parse the Fingal dataset, see the [Cranson](https://github.com/gary-rafferty/cranson) repository.

#### Usage

Full documentation can be found [here](http://api.cranson.co).   
Some high-level usage can be found below.

```bash

# /plans will return all plans in batches of 50. Uses link-header pagination
$ curl localhost:3000/plans
[
  {
    "id":14939,
    "status":"Decided",
    "decision_date":"2017-01-27",
    "description":"Two storey extension to existing two storey two bedroom dwelling...",
    "link":"http://planning.fingalcoco.ie/swiftlg/apas/run/WPHAPPDETAIL.DisplayURL?theApnID=FW16A/0147",
    "reference":"FW16A/0147",
    "registration_date":"2016-12-29",
    "address":"The Wren's Nest, R121, Westmanstown, Clonsilla, Dublin 15"
  }
  // snipped
]

# /plans/:id will return a single plan resource
$ curl localhost:3000/plans/14939

# /plans/search?query=str will return all plans with addresses containing str
$ curl localhost:3000/plans/search?query=raheny

# /plans/within?kilometres=n&latlng=xxx,yyy will returns all plans within n kilometres of latlng
$ curl localhost:3000/plans/within?kilometres=1&latlng=53.3841296,-6.0731679

# /plans/decided will return all decided plans
$ curl localhost:3000/plans/decided

# /plans/invalid will return all invalid plans
$ curl localhost:3000/plans/invalid

# /plans/unknown will return all unknown plans
$ curl localhost:3000/plans/unknown

# /plans/pending will return all pending plans
$ curl localhost:3000/plans/pending

# /plans/on_appeal will return all on_appeal plans
$ curl localhost:3000/plans/on_appeal

# /plans/recently_registered will return all plans registered in the last month
$ curl localhost:3000/plans/recently_registered

# /plans/recently_decided will return all plans decided in the last month 
$ curl localhost:3000/plans/recently_decided

```

#### Importing data

Run `./bin/rake planning_applications:import` to retrieve/parse/insert the remote dataset.

_As we include other authorities, it will probably make sense to namespace these tasks e.g `fingal:import`._

The import task accepts an optional `false` flag that disables auditing during import. 
This is useful if you are expecting data to change, but do not want the audits to be created.

`./bin/rake planning_applications:import[false]`.

#### Testing

Run `./bin/rake spec` to run the current specs

#### TODOs

- [ ] Can we derive / access any other resources not exposed in the dataset?
- [ ] Add support for new authorities as the become parseable by Cranson

#### Contributing

Please do. Usual guidelines :)
