# CURL examples

Considering that the app is running at `http://localhost:3000/api/v1` and the user `test1` with password `password1` is created, after running the seeds, you can use the following examples to test the endpoints.

Other users are `test2` with password `password2` and `test3` with password `password3`.

## Businesses

### List all businesses
```bash
# input
curl -u test1:password1 -X GET http://localhost:3000/api/v1/businesses

# output
[
  {"id":7,"name":"Test Business","total_shares":100,"available_shares":100,"owner":{"id":7,"username":"test1"}},
  {"id":8,"name":"Test Business","total_shares":100,"available_shares":100,"owner":{"id":8,"username":"test2"}},
  {"id":9,"name":"Test Business","total_shares":100,"available_shares":100,"owner":{"id":8,"username":"test2"}}
]
```

## Transactions

### List all transactions for a business
```bash
# input
curl -u test1:password1 -X GET http://localhost:3000/api/v1/businesses/7/transactions

# output
[
  {"id":5,"price":"100.0","quantity":10,"created_at":"2025-02-03 01:25:03"}
]

# input
curl -u test1:password1 -X GET http://localhost:3000/api/v1/businesses/8/transactions

# output
[
  {"id":6,"price":"119.0","quantity":19,"created_at":"2025-02-03 01:25:03"}
]
```

## Buy Orders

### List all buy orders for a business
```bash
# input
curl -u test1:password1 -X GET http://localhost:3000/api/v1/businesses/7/buy_orders

# output
[
  {"id":15,"buyer_id":8,"business_id":7,"quantity":10,"price":"100.0","status":"approved"},
  {"id":18,"buyer_id":9,"business_id":7,"quantity":1,"price":"100.0","status":"pending"},
  {"id":19,"buyer_id":9,"business_id":7,"quantity":2,"price":"101.0","status":"pending"},
  {"id":20,"buyer_id":9,"business_id":7,"quantity":3,"price":"102.0","status":"pending"},
  {"id":21,"buyer_id":9,"business_id":7,"quantity":4,"price":"103.0","status":"pending"}
]
```

### List all buy orders for a user
```bash
# input
curl -u test1:password1 -X GET http://localhost:3000/api/v1/buy_orders

# output
[
  {"id":16,"buyer_id":7,"business_id":8,"quantity":19,"price":"119.0","status":"approved"},
  {"id":17,"buyer_id":7,"business_id":8,"quantity":1,"price":"99.0","status":"rejected"}
]
```

### Create a buy order for a business
```bash
# input when user is the owner of the business
curl -u test1:password1 -X POST http://localhost:3000/api/v1/businesses/7/buy_orders \
  -H "Content-Type: application/json" \
  -d '{"buy_order": {"price": 12, "quantity": 1}}'

# output
{"error":"You are the owner of this business and cannot buy shares"}

# input when user is not the owner of the business
curl -u test1:password1 -X POST http://localhost:3000/api/v1/businesses/8/buy_orders \
  -H "Content-Type: application/json" \
  -d '{"buy_order": {"price": 12, "quantity": 1}}'

# output (returns the buy order created, with status pending)
{"id":22,"buyer_id":7,"business_id":8,"quantity":1,"price":"12.0","status":"pending"}
```

### Update a buy order
```bash
# input (as the owner of the business to approve a buy order)
curl -u test1:password1 -X PUT http://localhost:3000/api/v1/buy_orders/18 \
  -H "Content-Type: application/json" \
  -d '{"buy_order": {"status": "approved"}}'

# output
{"id":18,"buyer_id":9,"business_id":7,"quantity":1,"price":"100.0","status":"approved"}

# input (as the buyer to change a value but the buy order is not pending)
curl -u test1:password1 -X PUT http://localhost:3000/api/v1/buy_orders/18 \
  -H "Content-Type: application/json" \
  -d '{"buy_order": {"price": 100, "quantity": 2}}'

# output
{"error":"Buy order is not pending"}
```
