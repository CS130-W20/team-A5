const express = require('express');
const ItemController = (itemModel, authService) => {
  const router = express.Router();

  // The API path to create a new item. Creates an item object and returns that object
  router.post('/postitem', async (req, res) => {
    if (!req.body) return res.status(400).json({
      "message": "Malformed Request",
    });
    body = req.body

    const item_name = body['item_name']
    const seller_id = body['seller_id']
    const pic_url = body['pic_url']
    const item_description = body['item_description']
    const tags = body['tags']
    const sale_price = body['sale_price']
    const ticket_price = body['ticket_price']
    const total_tickets = body['total_tickets']
    const bids = body['bids']
    const is_ended = body['is_ended']
    const deadline = body['deadline']
    const status = body['status']
    const current_ledger = body['current_ledger']

    // TEMP Creation of token for item to simulate authentication
    const token = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
    
    const [item, err] = await itemModel.createItem(
      item_name,
      seller_id,
      pic_url,
      item_description,
      tags,
      sale_price,
      ticket_price,
      total_tickets,
      bids,
      is_ended,
      deadline,
      status,
      current_ledger,
      token,
    );

    if (err) {
      return res.status(400).json({
        data: null,
        message: err.message,
      });
    }
    return res.status(200).json({
      data: item,
      message: '',
    });
  });

  router.post('/getitem', async (req, res) => {
    
    if (!req.body) return res.status(400).json({
      "message": "Malformed Request",
    });
    body = req.body

    const item_id = body['item_id']
    const item_name = body['item_name']

    const [item, err] = await itemModel.findItem(item_id, item_name)

    if (err) {
      return res.status(400).json({
        data: null,
        message: err,
      });
    }
    return res.status(200).json({
      data: item,
      message: '',
    });

  })

  // Gets the item info for the item with item_id specified
  // If the logged in user is not the seller, we show an 
  // abbreviated item page of name, picture, description
  // tags, price, and ticket price
  router.get('/:item_id', async (req, res) => {
    const params = req.params;
    const item_id = parseInt(params.item_id, 10);
  
    // Get the user_id of the user sending the request, to check if the ids match
    const [user_info, err1] = await authService.getLoggedInUserInfo(req.headers);
    

    if (err1) {
      return res.status(400).json({
        data: null,
        message: err1
      });
    }

    const [item1, err2] = await itemModel.getItemInfo(item_id)
    if (err2) {
      return res.status(400).json({
        data: null,
        message: err.message
      });
    }
    // if the logged in user is the one selling the item, show full information
    if (user_info['id'] == item1['seller_id']) {
      return res.status(200).json({
        data: item1,
        message: ""
      });
    }

    // otherwise, return only item name, picture description
    const [item2, err3] = await itemModel.getItemInfoRestricted(item_id)
    if (err3) {
      return res.status(400).json({
        data: null,
        message: err.message
      });
    }

    return res.status(200).json({
      data: item2,
      message: ""
    });
  });

  return router;

}
  
module.exports = {
  ItemController,
};

