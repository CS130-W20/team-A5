# Rafflebay

#### Master Branch Build Status: 
![](https://api.travis-ci.org/CS130-W20/team-A5.svg?branch=master)

## Description
Our project, Rafflebay, is an online marketplace that uses a traditional raffle-based system to buy and sell goods. Our iOS application will consist of a searchable marketplace, where sellers are able to post goods they wish to sell and virtually distribute tickets to potential buyers. Buyers on the platform are able to purchase associated tickets with the item they wish to buy. Once all the tickets for a potential item have been sold, a winner is chosen at random who will receive the good. The seller of the item (e.g. headphones) chooses a selling price (e.g. $100) and a number of tickets to distribute (e.g. 10). The price of each ticket will be the selling price / number-of-tickets (e.g. $10 a ticket) such that the total amount the seller will receive by selling tickets will be equal to the amount he is looking for. This model will allow one ticket purchaser to win the item for an extremely large discount (e.g. 90%) whereas the rest receive nothing.

The novelty of this project is the ability for users to buy a valued product at an extremely discounted price, with the seller still getting a full price for his product. Additionally, this is a pro-seller market, catered towards boosting seller confidence. With the 2019 Supreme Court ruling which legalized sports betting at a federal level, more states have been proactive in changing state laws regarding online gambling, meaning that lottery-based apps like our own are essentially non-existent, following the trend of many foreign countries. For non-profit organizations, online raffles are already legal, however, no organization has an app-based online raffle service. 

## Directory Structure
We seperated our code into Frontend and Backend folders. The Frontend folder includes all presentation layer logic for implementing the iOS app. The backend is seperated into src and JSDoc_Output. In JSDoc_Output, all of the documentation for the backend is listed, including API descriptions. In src, our business and persistence logic is seperated within controllers and models

## Installation/Run instructions
To run the full app using the frontend, navigate to frontend/Rafflebay and click on Rafflebay.xcworkspace. Then, simply run the project and a simulator should appear.
To just test the backend, there are makefile commands that are listed within the README.md in the backend folder.

## Testing
To view the testing scenarios, [view the backend/tests folder](https://github.com/CS130-W20/team-A5/tree/master/backend/src/test).
The testing scenarios described, with their individiual test cases are as follows:

- Creating an item to sell  
  - Creating an item with accepted parameters was expected to succeed.  
  - Creating an item with no body of data describing the item was expected to fail.  
  - Creating an item with missing descriptive data was expected to fail.  
- Bidding on an item   
  - Creating a bid with accepted parameters was expected to succeed.   
  - Creating a bid for an unauthenticated user should fail.   
  - Creating a bid for a user with insufficient funds should fail.  
- Creating a user   
  - Creating a user with accepted parameters should succeed.   
  - Creating a user with missing optional fields should succeed.   
  - Creating a user with missing required fields should fail.   
  - Creating a user with empty required fields should fail.   
  - Creating two users with the same background data should fail.  
- Authenticating a user  
  - Authenticating a user with accepted parameters should succeed.  
  - Authenticating a user that does not exist should fail.   
  - Authenticating a user currently logged in should fail.   
  - Authenticating a known user with an incorrect password should fail.  
- Getting the info of other users  
  - Obtaining private information from a user that is not the one accessing the data should fail.   
  - Obtaining private information about a user that is the accessor of the data should succeed.   
- Choosing the winner of a raffle  
  - Choosing winners for an item that is not awaiting a raffle should fail.   
  - Choosing multiple winners for the same item should fail.   

## Relevant Links 
To view the documentation for the backend, [view the backend/JSDoc_Output folder](https://github.com/CS130-W20/team-A5/tree/master/backend/JSDoc_Output). 
