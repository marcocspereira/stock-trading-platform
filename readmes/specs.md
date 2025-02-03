# RSpec Test Results

## Business
- has a valid factory
- is expected to belong to owner required: true
- is expected to have many buy_orders
- is expected to have many transactions
- is expected to validate that :name cannot be empty/falsy
- is expected to validate that :total_shares looks like an integer greater than or equal to 0
- is expected to validate that :available_shares looks like an integer greater than or equal to 0

### #is_available?
- returns true if the business has available shares

### #pending_shares
- returns the number of pending shares

### #remaining_shares
- returns the number of remaining shares

---

## BuyOrder
- has a valid factory
- is expected to belong to buyer required: true
- is expected to belong to business required: true
- is expected to validate that :quantity cannot be empty/falsy
- is expected to validate that :quantity looks like an integer greater than 0
- is expected to validate that :price cannot be empty/falsy
- is expected to validate that :price looks like a number greater than 0
- is expected to validate that :status is either `"pending"`, `"approved"`, or `"rejected"`

### #pending?
- returns true if the buy order is pending

### #approve!
- updates the status to approved

### #reject!
- updates the status to rejected

---

## Transaction
- has a valid factory
- is expected to belong to user required: true
- is expected to belong to business required: true
- is expected to validate that :quantity cannot be empty/falsy
- is expected to validate that :quantity looks like an integer greater than 0
- is expected to validate that :price cannot be empty/falsy
- is expected to validate that :price looks like a number greater than 0

---

## User
- has a valid factory
- is invalid without a password
- is expected to have many owned_businesses `class_name => Business`
- is expected to have many buy_orders
- is expected to have many transactions

---

## API Endpoints

### GET /api/v1/businesses
#### When the user is not authenticated
- behaves like an unauthorized request
  - returns an unauthorized response

#### When the user is authenticated
- When the user is a buyer
  - returns the businesses available for the buyer
- When the user is an owner
  - does not return own businesses

---

### POST /api/v1/businesses/:business_id/buy_orders
#### When the user is not authenticated
- behaves like an unauthorized request
  - returns an unauthorized response

#### When the user is authenticated
- When parameters are missing
  - returns a `422 unprocessable entity` error
- When user is the owner of the business
  - returns a `422 unprocessable entity` error
- When the business is not available
  - returns a `422 unprocessable entity` error
- When the quantity is invalid
  - returns a `422 unprocessable entity` error
- When the parameters are valid
  - returns a `201 created` status

---

### DELETE /api/v1/buy_orders/:id
#### When the user is not authenticated
- behaves like an unauthorized request
  - returns an unauthorized response

#### When the user is authenticated
- When the buy order is pending
  - deletes the buy order
- When the buy order is not pending
  - does not delete the buy order

---

### GET /api/v1/buy_orders
#### When the user is not authenticated
- behaves like an unauthorized request
  - returns an unauthorized response

#### When the user is authenticated
- returns all their buy orders

---

### GET /api/v1/businesses/:business_id/buy_orders
#### When the user is not authenticated
- behaves like an unauthorized request
  - returns an unauthorized response

#### When the user is authenticated
- returns all buy orders for their business

---

### GET /api/v1/buy_orders/:id
#### When the user is not authenticated
- behaves like an unauthorized request
  - returns an unauthorized response

#### When the user is authenticated
- When the user is not the buyer or the owner of the business that the order is for
  - returns a forbidden error
- When the user is the buyer or the owner of the business that the order is for
  - returns the buy order

---

### PUT /api/v1/buy_orders/:id
#### When the user is not authenticated
- behaves like an unauthorized request
  - returns an unauthorized response

#### When the user is authenticated
- When the user is not the buyer or the owner of the business that the order is for
  - returns an error
- When the user is the one who made the order
  - When one of the params is negative
    - returns an error
  - When updating the values of the order
    - updates the values of the order
- When the user is the owner of the business that the order is for
  - When approving a pending order
    - updates the status of the order, the available shares of the business, and creates a transaction
  - When rejecting a pending order
    - updates the status of the order and does not update the available shares of the business or create a transaction
  - When approving/rejecting a non-pending order
    - returns an error
  - When updating the values of the order
    - is not allowed

---

### GET /api/v1/businesses/:business_id/transactions
#### When the user is not authenticated
- behaves like an unauthorized request
  - returns an unauthorized response

#### When the user is authenticated
- returns the transactions for the business

---

## BuyOrders::BaseUpdater
### #initialize
- assigns buy_order and user
- initializes errors as an empty array

### #call
- raises `NotImplementedError`

### #validate_pending!
- When buy order is pending
  - does not raise an error
- When buy order is not pending
  - raises `InvalidBuyOrderError`

### #validate_owner!
- When user is the owner
  - does not raise an error
- When user is not the owner
  - raises `ForbiddenActionError`

### #validate_buyer!
- When user is the buyer
  - does not raise an error
- When user is not the buyer
  - raises `ForbiddenActionError`

---

## BuyOrders::Creator
### #initialize
- assigns `current_user`, `business_id`, and `params`

### #call
- creates a new buy order

---

## BuyOrders::Destroyer
### #initialize
- assigns `buy_order_id` and `current_user`

### #call
- destroys the buy order

---

## BuyOrders::Fetcher
### #call
- When `business_id` is provided
  - returns all buy orders for the business owner
- When `business_id` is not provided
  - returns all buy orders for the user

---

## BuyOrders::Updater
### #build
- When the user is the business owner
  - returns a `StatusUpdater`
- When the user is the buy order buyer
  - returns a `ValueUpdater`
- When the user is neither the business owner nor the buy order buyer
  - raises an error
