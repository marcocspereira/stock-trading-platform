# Implemented

## Requirements

- [x] Seed data for several businesses. A business requires a name and a number of shares that are available and some that are not.
- [x] Buyers should be able to view a list of businesses with available shares.
- [x] Buyers should be able to view the history of shares sold for a specific business, including quantity and price.
- [x] Buyers should be able to place a buy order with a specified quantity and price.
- [x] Owners should be able to view buy orders with details such as buyer's username, quantity, and price.
- [x] Owners should be able to accept or reject buy orders.
- [x] Implement HTTP basic authentication for API endpoints. Ensure only authenticated users can access the API.
- [x] Unit and end-to-end tests.

## Comments

* The authentication is done with HTTP basic authentication, for sake of simplicity.
* The tests are done with RSpec, located in `spec` folder. The `requests`specs act as integration tests, which didn't allow to mock services, using them.
* The database is seeded with some data to test the endpoints based on the `seeds.rb` file.
* The documented **cURL** examples are in the `curl_examples.md` file and are related to the endpoints in README.md and data in `seeds.rb`.
* The `BuyOrder` update uses the Factory Method design pattern to update the buy order, mapping the right class according to the user: **owner** can update the buy order status, **buyer** can update the buy order quantity and price. Both, only if the order is pending.
* There is a `Transaction` model, which is used to record the `approved` buy orders, however, without implement relationshing between `BuyOrder` and `Transaction`, only with `User` and `Business`.
* Despite of using Rails 8, there is no usage of new capabilities.

## TODO

* Implementing caching (e.g. Redis) for frequently accessed data (such as the number of shares left) to improve performance, reducing the number of requests to the database
* Implement wallets to represent currencies and transactions between users and businesses, to keep funds distinct and make easier to track balances for each currency.
* A limit for the number of shares that can be bought in a single buyer to avoid market manipulation/dominance, keeping track of the number of shares bought by a single buyer and validating the limit before creating a transaction.