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


  return router;
}
  
module.exports = {
  AdminController,
};
