# Rafflebay Backend
The backend for Rafflebay

## Makefile commands

* **make**: Runs **make build** and **make run**
* **make build**: Builds the docker container
* **make run**: Runs the server and postgres 
* **make run_background**: Runs the server and postgres in the background (i.e. you will see no output)
* **make stop**: If you run **make run_background**, use this to stop the server
* **make p_shell**: Opens an interactive psql shell connected to our postgres instance
* **make jsdoc**: Updates the JSDoc output in local file JSDoc_Output
* **make test**: Builds and runs a server for the testing environment.
* **make reset_db**: **CAUTION** THIS WILL DELETE ALL DATA IN THE DB. Use when you change schemas and you are ok losing data. Tables will be recreated on the next re-start of server.

**Note**: **make jsdoc**, **make p_shell**, and **make reset_db** can only be run while the server is running

## How to do authorized requests
Use the `auth_token` from the user model to make requests
  - Add `Authorization: Bearer <ACCESS_TOKEN>` to the header of the request


## API Definitions

### User Model Definition
**Note:** The user model also contains a hash of the user password, but that will never be returned
```
{
  "id": <RAFFLEBAY_USER_ID>,
  "first_name": "<user_first_name>",
  "last_name": "<user_last_name>",
  "email": "<user_email>",
  "picture_url": "<profile_picture_url>",
  "address_1": "<user_address_line_one>",
  "address_2": "<user_address_line_two>",
  "city": "<user_address_city>",
  "state": "<user_address_state>",
  "zip": "<user_address_zip>",
  "phone": "<user_phone>",
  "balance": <current_balance_of_user>,
  "auth_token": "<authentication_token_to_be_used_in_future_requests>",
  "created_at": "<CREATED_AT_TIMESTAMP>",
}
```

### Create new user
POST /api/users/signup (*No access token in header needed for this request*)
```
{
  "first_name": "<user_first_name>",
  "last_name": "<user_last_name>",
  "email": "<user_email>",
  "password": "<password>",
  "pic_url": "<profile_picture_url>",
  "address_1": "<user_address_line_one>",
  "address_2": "<user_address_line_two>",
  "city": "<user_address_city>",
  "state": "<user_address_state>",
  "zip": "<user_address_zip>",
  "phone": "<user_phone>"
}
```
returns
```
{
  "data": <USER_MODEL_ABOVE>,
  "message": "<ERROR_MESSAGE>",
}

```
### Login
POST /api/users/login (*No access token in header needed for this request*)
```
{
	"email": "<user_email",
	"password": "<user_password>"
}
```

returns
```
{
  "data": <USER_MODEL_ABOVE>,
  "message": "<ERROR_MESSAGE>",
}

```

### Get user info of logged in user
GET /api/users/me

returns
```
{
  "data": <USER_MODEL_ABOVE>,
  "message": "<ERROR_MESSAGE>",
}

```

### Get user info of other user
GET /api/users/{user_id}

returns
```
{
  "data": 
	{
	  "id": <RAFFLEBAY_USER_ID>,
	  "first_name": "<user_first_name>",
	  "last_name": "<user_last_name>",
	  "email": "<user_email>",
	  "picture_url": "<profile_picture_url>"
	},
  "message": "<ERROR_MESSAGE>",
}
```
**Note:** If the user ID specified is that of the logged in user, the full user info will be given

### Item Model Definition
```
{
  "item_id": <item_id>,
  "item_name": "<item_name>",
  "seller_id": <RAFFLEBAY_USER_ID>,
  "pic_url": "<item_pic_url>",
  "item_description": "<item_description>",
  "tags": "<item_tags>",
  "sale_price": <item_sale_price>,
  "ticket_price": <item_ticket_price>,
  "total_tickets": <item_total_number_tickets>,
  "tickets_sold": <total_tickets_sold_so_far>,
  "bids": "<item_bid_list>",
  "deadline": "<item_deadline_timestamp>",
  "status": "<item_current_status>",
  "current_ledger": <item_current_ledger>,
  "created_at":"<CREATED_AT_TIMESTAMP>",
}
```

### Bid Model Definition
```
{
  "bid_id": <id_of_bid>,
  "user_id": <RAFFLEBAY_USER_ID>,
  "item_id": <id_of_item_bid_is_for>
  "ticket_count": <number_of_tickets_in_bid>,
  "total_cost": <total_cost_of_bid>,
  "did_win": <boolean>,
  "refunded": <boolean>,
  "timestamp": <when_bid_was_created>
}
```

### Create new item
POST /api/items/create 
```
{
  "item_name": "<item_name>",
  "pic_url": "<item_pic_url>",
  "item_description": "<item_description>",
  "tags": "<item_tags>",
  "sale_price": <item_sale_price>,
  "total_tickets": <item_total_number_tickets>,
}
```
returns
```
{
  "data": <ITEM_MODEL_ABOVE>,
  "message": "<ERROR_MESSAGE>",
}
```

### Get item info when you are the seller
GET /api/items/{item_id}

returns
```
{
  "data": <ITEM_MODEL_ABOVE>,
  "message": "<ERROR_MESSAGE>",
}
```

### Get item info when you are not the seller
GET /api/items/{item_id}

returns
```
{
  "data": {
      "item_name": "<item_name>",
      "seller_id": <RAFFLEBAY_USER_ID>,
      "pic_url": "<item_pic_url>",
      "item_description": "<item_description>",
      "tags": "<item_tags>",
      "sale_price": <item_sale_price>,
      "ticket_price": <item_ticket_price>,
      "total_tickets": <item_total_number_tickets>,
      "status": "<item_current_status>",
      "deadline": "<item_deadline_timestamp>"
  },
  "message": ""
}
```

### Buy tickets for an item
POST /api/items/bid/{item_id}
```
{
  "ticket_count": <number_of_tickets_in_bid>,
  "total_cost": <total_cost_of_bid>,
}
```

returns
```
{
  "data": {
    "bid: <BID_MODEL_ABOVE>,
    "new_user_balance": <new_balance_of_user_after_purchase>
  }
  "message": "<error_message>"
}
```

### View all items selling and bidding
GET /api/items/me

returns
```
{
  "data": {
    "items_selling": [<ITEM_MODEL_ABOVE>],
    "items_bidding": [
      {
        "item_name": "<item_name>",
        "seller_id": <RAFFLEBAY_USER_ID>,
        "pic_url": "<item_pic_url>",
        "item_description": "<item_description>",
        "tags": "<item_tags>",
        "sale_price": <item_sale_price>,
        "ticket_price": <item_ticket_price>,
        "total_tickets": <item_total_number_tickets>,
        "status": "<item_current_status>",
        "deadline": "<item_deadline_timestamp>"
        "total_cost": <total_ticket_cost>,
        "tickets_bought": <total_tickets_bought>
      }
    ]
  },
  "message": "<error_message>"
}
```

### Get Item Feed
GET /api/items/feed *No auth_token needed*

returns
```
{
  "data": [
    {
      <BUYER_ITEM_VIEW>
    },
    ...
    ],
  "message": "<ERROR_MESSAGE>"
}
```
