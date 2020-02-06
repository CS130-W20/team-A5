# Rafflebay Backend
The backend for Rafflebay

## Makefile commands

* **make**: Runs **make build** and **make run**
* **make build**: Builds the docker container
* **make run**: Runs the server and postgres 
* **make run_background**: Runs the server and postgres in the background (i.e. you will see no output)
* **make stop**: If you run **make run_background**, use this to stop the server
* **make p_shell**: Opens an interactive psql shell connected to our postgres instance
* **make reset_db**: **CAUTION** THIS WILL DELETE ALL DATA IN THE DB. Use when you change schemas and you are ok losing data. Tables will be recreated on the next re-start of server.

**Note**: Both **make p_shell** and **make reset_db** can only be run while the server is running

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
