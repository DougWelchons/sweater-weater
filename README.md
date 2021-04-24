# Rails Engine API

###### Auther: [Doug Welchons](https://github.com/DougWelchons)


Rails engine is designed to simulate the backend portion of a internet sales platform,
providing to the front end program (not a part of this project), API endpoints to relevant data in the database.


This project was built with:
* Ruby version 2.5.3
* Rails version 5.2.5

This project was tested with:
* RSpec version 3.10

#### Contents
- [program setup](#program-setup)
- [Endpoint documentation](#endpoint-documentation)
  - [Forecast](#forecast-items)

- [Testing](#testing)
  - [Running tests](#running-tests)
  - [Tests for each endpoint](#tests-for-each-endpont)
    - [Forecast](#forecast-endpoints)

### program setup
To run the program on you own machine follow these setup steps:
```
$ git clone "repo URL"
$ cd rails-engine
$ bundle install
```

In order to set up the database run the following:
```
$ rails db:create
$ rails db:migrate
$ rails db:seed
```
If you have an existing database called `rails-engine` you will have to run `rails db:drop` prior to setting up the database
alternatively you can run `rails db:{drop,create,migrate,seed}` to set up the database.

### Endpoint Documentation
###### All items
- This endpoint returns the weather forecast for a given city including:
  - current weather
  - daily weather for the next five days
  - hourly weather for the next 8 hours

  - required query params:
    - location=<location> if in the US, <location> should include city and state, otherwise it should include city and country.
  - example:
    - http://localhost:3000/api/v1/forecast?location=libby,mt




### Testing
##### Running tests
- you can run the entire test suite with `bundle exec rspec`
- you can run an individual test suite with `bundle exec rspec <file path>` for example: `bundle exec rspec spec/requests/forecast_endpoint_spec.rb`
- you can run an individual test or an entier describe block with `bundle exec rspec <file path>:<line number>` where the `<line number>` is the line a the test or describe block starts on


#### Tests for each endpoint
##### forecast endpoints
- happy path testing includes:
  -
- Edge case testing includes:
  -
- Sad Path testing includes:
  -
