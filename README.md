# README

## Tools
* Ruby 3.2.3
* Rails 8.0.1
* RSpec + Shoulda + FactoryBot + Faker
* MySQL 8.0
* Docker

## Configuration

### Other pages

* [cURL examples](readmes/curl_examples.md)
* [RSpec examples](readmes/specs.md)
* [Implemented](readmes/implemented.md)
### Index

* Launch the app
* Seed data
* Endpoints
* Run tests

This uses Docker and no other scenario was tested. You can use `http://localhost:3000` or `http://0.0.0.0:3000`.

### Launch the app

It will create two containers:

* one for the web service
* one for the database

To start...

* Use **docker compose** inside the root folder.

```bash
# one bash session
docker compose up --build

# if you want to run something inside web container (e.g., bash)
docker compose exec web bash # other bash session
````

### Seed data

For testing purposes, it was created an endpoint to run the seed data.

```bash
# cURL
curl -X POST http://localhost:3000/run_seeds
# {"message":"Seed data has been successfully run."}
````

### Endpoints

All these endpoints are available at `http://localhost:3000/api/v1` and are just for authenticated users. Check [seeds.rb file](db/seeds.rb) to see the data created and use the `/run_seeds` endpoint to reset the data.

**Businesses**
* `GET /api/v1/businesses` to list businesses

**Transactions**
* `GET /api/v1/businesses/:business_id/transactions` to list transactions for a business

**Buy Orders**
* `GET /api/v1/businesses/:business_id/buy_orders` to list buy orders for a business -> available only for owners
* `GET /api/v1/buy_orders/:id` to show a buy order -> available for all users
* `POST /api/v1/buy_orders` to create a buy order
* `PUT /api/v1/buy_orders/:id` to update a buy order -> owners can update status of pending buy orders to cancelled or approved; buyers can update its quantity or price while pending
* `DELETE /api/v1/buy_orders/:id` to delete a buy order -> only for buyers that submitted the buy order and it is pending



Check **[cURL examples](readmes/curl_examples.md)** to test get information on how to test/use them).


## Run tests

Using terminal
```bash
docker compose up
docker compose exec web bash # other terminal
# inside container
rspec

# if returns error, run
bin/rails db:create
# then 
rspec # again
```

It may display output like [this specs file](specs.md).