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

#### Seeding

Run `./bin/rake planning_applications:import` to seed the db with plans from the last seven years.

#### Testing

Run `./bin/rake spec` to run the current specs

#### TODOs

- [x] List all applications
- [x] Show a single application
- [x] Text search on planning address
- [x] Search applications within n metres
- [ ] API entry point for search within n metres
- [x] Pagination across API responses
- [ ] Determine update frequency of Fingal dataset
- [ ] Investigate other authority datasets

#### Contributing

Please do. Usual guidelines :)
