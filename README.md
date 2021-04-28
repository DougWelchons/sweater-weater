# Sweater Weather API

###### Author: [Doug Welchons](https://github.com/DougWelchons)


Sweater Weather it the backend portion of a travel site, leveraging external APIs for travel time as well as current and forecasted weather for your arrival time.

This project was built with:
* Ruby version 2.5.3
* Rails version 5.2.5

This project was tested with:
* RSpec version 3.10

#### Contents
- [program setup](#program-setup)
- [Endpoint documentation](#endpoint-documentation)
  - [Forecast](#forecast)
  - [Background](#background)
  - [Road Trip](#road_trip)
  - [Sessions](#sessions)
  - [Users](#users)

- [Testing](#testing)
  - [Running tests](#running-tests)
  - [Tests for each endpoint](#tests-for-each-endpont)
    - [Forecast](#forecast-endpoint)
    - [Background](#background-endpoint)
    - [Road Trip](#road_trip-endpoint)
    - [Sessions](#sessions-endpoint)
    - [Users](#users-endpoint)

### program setup
To run the program on you own machine follow these setup steps:
```
$ git clone "repo URL"
$ cd sweater-weather
$ bundle install
```

In order to set up the database run the following:
```
$ rails db:create
$ rails db:migrate
```
If you have an existing database called `sweater-weather` you will have to run `rails db:drop` prior to setting up the database
alternatively you can run `rails db:{drop,create,migrate}` to set up the database.

### Endpoint Documentation

###### Forecast
- This endpoint returns the weather forecast for a given city including:
  - current weather
  - daily weather for the next five days
  - hourly weather for the next 8 hours

  - required query params:
    - location=<location> if in the US, <location> should include city and state, otherwise it should include city and country.
  - example:
    - http://localhost:3000/api/v1/forecast?location=libby,mt

###### Backgrounds
- This endpoint returns an image for a given city.
  - required query params:
    - location=<location> if in the US, <location> should include city and state, otherwise it should include city and country.
  - example:
    - http://localhost:3000/api/v1/backgrounds?location=libby,mt

###### Road_trip
- This endpoint returns the starting city, destination city, estimated travel time, and forecast in the destination for the arrival time.
  - required query params:
    - api_key=<api_key> a valid api key is required for this endpoint
    - origin=<location> if in the US, <location> should include city and state, otherwise it should include city and country.
    - destination=<location> if in the US, <location> should include city and state, otherwise it should include city and country.
  - other notes
    - if a road trip route cannot be found, the duration will return as "impossible", and there will be no weather data
  - example:
    - http://localhost:3000/api/v1/road_trip
      Content-Type: application/json
      Accept: application/json

      body:
            {
              "origin": "libby,mt",
              "destination": "denver,co",
              "api_key": <valid_api_key>
            }

###### Sessions
- This endpoint returns a users api_key if valid email and password are provided
  - required query params:
    - email=<users_email>
    - password=<users_password>
  - other notes
    anything other then a valid email and matching password are provided "Invalid Login" will be returned
  - example:
    - http://localhost:3000/api/v1/sessions
      Content-Type: application/json
      Accept: application/json

      body:
            {
              "email": "email@domain.com",
              "password": "password"
            }

###### Users
- This endpoint creates a new user and returns a user api_key
  - required query params:
    - email=<users_email>
    - password=<users_password>
    - password_confirmation=<users_password>
  - example:
    - http://localhost:3000/api/v1/sessions
      Content-Type: application/json
      Accept: application/json

      body:
            {
              "email": "email@domain.com",
              "password": "password"
              password_confirmation: "password"
            }

### Testing
##### Running tests
- you can run the entire test suite with `bundle exec rspec`
- you can run an individual test suite with `bundle exec rspec <file path>` for example: `bundle exec rspec spec/requests/forecast_endpoint_spec.rb`
- you can run an individual test or an entier describe block with `bundle exec rspec <file path>:<line number>` where the `<line number>` is the line a the test or describe block starts on


#### Tests for each endpoint
##### Forecast endpoint
- happy path testing includes:
  - endpoint returns a 200 response with the proper data structure
- Edge case & Sad path testing includes:
  - endpoint returns a 400 error if location param is not provided
  - endpoint returns a 400 error if location is blank


##### Backgrounds endpoint
- happy path testing includes:
  - endpoint returns a 200 response an image url and other relevant info
- Edge case & Sad path testing includes:
  - endpoint returns a 400 error if location param is not provided
  - endpoint returns a 400 error if location is blank

##### Road_trip endpoint
- happy path testing includes:
  - endpoint returns a 200 response with the proper data structure
  - endpoint returns a 200 response without weather if trip is impossible
- Edge case & Sad path testing includes:
  - endpoint returns a 400 response if no origin is provided
  - endpoint returns a 400 response if origin is blank
  - endpoint returns a 400 response if no destination is provided
  - endpoint returns a 400 response if destination is blank
  - endpoint returns a 400 response if no api key is provided
  - endpoint returns a 400 response if api key is invalid
  - endpoint returns a 400 response if api key is blank

##### Sessions endpoint
- happy path testing includes:
  - endpoint returns a 200 response with necessary return data
  - endpoint returns a 200 response without weather if trip is impossible
- Edge case & Sad path testing includes:
  - endpoint returns a 400 response if no email provided
  - endpoint returns a 400 response if email doesn't match any users
  - endpoint returns a 400 response if password is incorrect
  - endpoint returns a 400 response if no password provided

##### Users endpoint
- happy path testing includes:
  - endpoint returns a 201 response with necessary return data
- Edge case & Sad path testing includes:
  - endpoint returns a 400 response if no email provided
  - endpoint returns a 400 response if email is not in the right format
  - endpoint returns a 400 response if email already exists
  - endpoint returns a 400 response if passwords dont match
  - endpoint returns a 400 response if no password provided
  - endpoint returns a 400 response if no password_confirmation provided
