# token-authentication-boilerplate
Boiler plate for an api token authentication system, has separate admin user privileges 

## Install
* all you have to do is install all gems
```
bundle install
```

## First account
* To create your first account 
* First migrate the db
```
rails db:migrate
```
* Then open a console instance
```
rails c
```
* Then create a new user with the following values
```
User.create!(username: "$USERNAME", password: Digest::SHA256.hexdigest("$PASSWORD"), is_admin: true)
```
* Substitute USERNAME and PASSWORD for values of your choice
* Setting is_admin to true makes the newly created user an admin or vice versa

## Authenticating Users
* There are two built in methods that allow you to authenticate a user before endpoint execution with either admin level privileges or user level privileges
* if you call auth_user before your endpoint both admin and regular users will have access
* if you call auth_admin before your endpoint only admin users will have access
    * Response Errors
        * Returns a status code of 400 if you are missing the auth token in your header
        * Returns a status code of 401 if any part of the authentication process didn't work
    * Success
        * Executes endpoint, see that endpoints description for errors

## Endpoints

* POST /login
    * Params: json string with keys username and password
        ```json
        {
          "username": "test",
          "password": "test-password"
        }
        ```
    * Errors
        * Returns a status code of 400 if you have missing parameters
        * Returns a status code of 401 if you passed an invalid pair of credentials
    * Success
        * Returns a status code of 200 and a json string with an authentication token
            ```json
            {
              "token": "**token**"
            }
            ```

* GET /user
    * User must pass a valid Admin Authorization token in request header
    * Errors
        * Handled by authentication
    * Success
        * Returns a json array of json strings containing users id, username and is_admin boolean

* POST /user
    * User must pass a valid Admin Authorization token in request header
    * Params: json string with keys username and password
        ```json
        {
          "username": "test",
          "password": "test-password"
        }
        ```
    * Errors
        * Returns a status code of 400 if you have missing parameters
        * Returns a status code of 401 if the username you passed is already a registered user
    * Success
        * Returns a status code of 200 a json string saying the user has been created, if you want an authentication token you must call /login

* DELETE /user/:id
    * User must pass a valid Admin Authorization token in request header
    * Errors
        * Returns a status code of 400 if the user couldn't be deleted due to the id doesn't exist
    * Success
        * Json string saying user was deleted

* GET /auth_test
    * User must pass a valid Admin/User Authorization token in request header
    * If valid will return a json string saying Authorized
    * Else will return a json string saying unauthorized
    
* GET /admin_test
    * User must pass a valid Admin Authorization token in request header
    * If valid will return a json string saying Authorized
    * Else will return a json string saying unauthorized