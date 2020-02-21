/**
 * A standalone service to help with raffle lifecycle events, such as randomly selecting a winner and updating databases
 * @constructor
 * 
 * @param  {ItemModel} itemModel - The ItemModel that provides access to the Item/Bid Database
 * @param  {UserModel} userModel - The UserModel that provides access to the User Database
 * @return {RaffleService} - Returns an instance of RaffleService
 */
const RaffleService = (itemModel, userModel) => {

	/**
	 * This method does the entire winner selection process, handling all 
	 * database calls and email notifications
	 * 
	 * What this method does
	 * 1. Selects winner with weighted random
	 * 2. Set that bid as the winner
	 * 3. Get user info for seller and winner
	 * 4. Send alert email to the winner
	 * TODO: Get shipping info here? From seller's zip code to winner's address
	 * TODO: Send shipping info email to the seller
	 * 
	 * @param  {Item} item - Item Object with status "AR" (aka, ready to have winner selected)
	 * @return {number} - ID of the winning Bid, -1 if an error (Error will be logged to console)
	 */
	const chooseAndNotifyWinner = async (item) => {
		const [bids, err2] = await itemModel.getBidsForItem(item['item_id']);

		if (err2) {
			console.log("Error while retreiving bids for item: " + item['item_id']);
			return -1;
		}

		// Build array of bid ids, with 1 entry per ticket bought
		let ticket_arr = []

		for (let i = 0; i < bids.length; i++) {
			let curr_bid = bids[i]
			let bid_id = curr_bid['bid_id']

			for (let count = 0; count < curr_bid['ticket_count']; count++) {
				ticket_arr.push(bid_id)
			}
		}

		// Get random integer between 0 and (number_of_tickets - 1)
		// TODO: This is pseudorandom for now, make really random later
		const winner_index = Math.floor(Math.random() * ticket_arr.length); 

		const winning_bid_id = ticket_arr[winner_index];

		// Now that we have the winning bid, set it as the winner
		const [winning_bid_info, e] = await itemModel.setBidAsWinner(winning_bid_id);

		// Update status of the item to "AS" ("Awaiting Shipment")
		let updated_item = await itemModel.updateItemStatus(item['item_id'], "AS")

		// Get user info of seller and winner
		const [seller_info, e1] = await userModel.getUserInfoById(item['seller_id'])
		const [winning_user_info, e2] = await userModel.getUserInfoById(winning_bid_info['user_id'])

		// TODO
		// Use this info to send alert emails and get shipping label
		// For now just print emails to ensure this happens correctly
		console.log("For item id " + item['item_id'])
		console.log("Seller email: " + seller_info['email'])
		console.log("Winner email: " + winning_user_info['email'])

		// Return id of the winning bid
		return winning_bid_id;
	}

	return {
    	chooseAndNotifyWinner,
  };
}

module.exports = {
  RaffleService,
};