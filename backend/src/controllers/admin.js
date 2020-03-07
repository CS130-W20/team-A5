const express = require('express');
const AdminController = (userModel, itemModel, raffleService) => {
  const router = express.Router();

  // The API path to choose a winner for all items awaiting a raffle
  router.get('/select_winners', async (req, res) => {
  	// TODO add security to this method
  	// Maybe make an admin user and only let them call this?
  	// Or just add a hardcoded secret to the header

  	// Get all items with the "AR" status

  	const [items, err1] = await itemModel.getItemsWithStatus("AR");

  	if (err1) {
      return res.status(400).json({
        data: null,
        message: err1
      });
    }

    // Create promises for the chooseAndNotifyWinner function on all items
    // We use promises so this lengthy process can be run in parallel for each item
    let promises = items.map((item) => {
      return raffleService.chooseAndNotifyWinner(item);
    });

    // Run the process for all items
    const results = await Promise.all(promises)

    return res.status(200).json({
      data: results,
      message: ""
    });
    
  });


  router.post('/tracking_update', async (req, res) => {
    
    let event;
    
    try {
      event = req.body;
    } catch (err) {
      return res.status(400).json({"err": `Webhook Error: ${err.message}`});
    }

    // Handle the event
    if (event.description == 'tracker.updated' && (event.result.status == "in_transit" || event.result.status == "delivered")) {
      // get the tracking information from the event
      const tracking_object = event.result;
      const tracking_url = tracking_object.public_url
      
      // get the shipment that is associated with the tracking number
      const [shipment, err1] = await itemModel.getShipmentInformation(tracking_object.tracking_code);
      if (err1) {
        return res.status(400).json({
          data: null,
          message: err1
        });
      }

      // get the item for the shipment
      const [item, err2] = await itemModel.getItemInfo(shipment['item_id'])
      if (err2) {
        return res.status(400).json({
          data: null,
          message: err2
        });
      }

      // get the winner information for the shipment
      const [winner, err3] = await userModel.getUserInfoById(shipment['winner_id'])
      if (err3) {
        return res.status(400).json({
          data: null,
          message: err3
        });
      }

      // send the email with the tracking url
      await raffleService.sendTrackingNumber(item, winner, tracking_url)  

      return res.status(200).json({"message": "Success"})

      } 
  });


  return router;
}
  
module.exports = {
  AdminController,
};
