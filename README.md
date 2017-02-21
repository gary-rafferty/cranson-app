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

```bash

# /plans will return all plans in batches of 50. Uses link-header pagination
$ curl localhost:3000/plans
[
  {
    "id":14939,
    "status":"Decided",
    "decision_date":"2017-01-27",
    "description":"Two storey extension to existing two storey two bedroom dwelling...",
    "location":"POINT (53.38008495113 -6.44010327988883)",
    "more_info_link":"http://planning.fingalcoco.ie/swiftlg/apas/run/WPHAPPDETAIL.DisplayURL?theApnID=FW16A/0147",
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
```

#### Importing data

Run `./bin/rake planning_applications:import` to retrieve/parse/insert the remote dataset.

_As we include other authorities, it will probably make sense to namespace these tasks e.g `fingal:import`._

#### Testing

Run `./bin/rake spec` to run the current specs

#### TODOs

- [x] List all applications
- [x] Show a single application
- [x] Text search on planning address
- [x] Search applications within n metres
- [ ] API entry point for search within n metres
- [x] Pagination across API responses
- [ ] Deploy to Heroku (Postgis extension required)
- [ ] Use scheduler to retrieve/parse the dataset each day
- [ ] Can we derive / access any other resources not exposed in the dataset
- [ ] Investigate other authority datasets

#### Contributing

Please do. Usual guidelines :)
