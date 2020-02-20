# Rafflebay
Our project, Rafflebay, is an online marketplace that uses a traditional raffle-based system to buy and sell goods. Our iOS application will consist of a searchable marketplace, where sellers are able to post goods they wish to sell and virtually distribute tickets to potential buyers. Buyers on the platform are able to purchase associated tickets with the item they wish to buy. Once all the tickets for a potential item have been sold, a winner is chosen at random who will receive the good. The seller of the item (e.g. headphones) chooses a selling price (e.g. $100) and a number of tickets to distribute (e.g. 10). The price of each ticket will be the selling price / number-of-tickets (e.g. $10 a ticket) such that the total amount the seller will receive by selling tickets will be equal to the amount he is looking for. This model will allow one ticket purchaser to win the item for an extremely large discount (e.g. 90%) whereas the rest receive nothing.

The novelty of this project is the ability for users to buy a valued product at an extremely discounted price, with the seller still getting a full price for his product. Additionally, this is a pro-seller market, catered towards boosting seller confidence. With the 2019 Supreme Court ruling which legalized sports betting at a federal level, more states have been proactive in changing state laws regarding online gambling, meaning that lottery-based apps like our own are essentially non-existent, following the trend of many foreign countries. For non-profit organizations, online raffles are already legal, however, no organization has an app-based online raffle service. 

## Directory Structure
We seperated our code into Frontend and Backend folders. The Frontend folder includes all presentation layer logic for implementing the iOS app. The backend is seperated into src and JSDoc_Output. In JSDoc_Output, all of the documentation for the backend is listed, including API descriptions. In src, our business and persistence logic is seperated within controllers and models

## Installation/Run instructions
To run the full app using the frontend, ****.
To just test the backend, there are makefile commands that are listed within the README.md in the backend folder.

## Relevant Links 
To view the documentation for the backend, [view the backend/JSDoc_Output folder](https://github.com/CS130-W20/team-A5/tree/master/backend/JSDoc_Output). 