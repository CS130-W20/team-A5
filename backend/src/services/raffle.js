const EasyPost = require('@easypost/api');
const api = new EasyPost('EZTK306be7aecba44da486ac37dd01871296leZm7Qb3VVPb0bv17K3ACA')

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
		// Use emails to send shipping label and tracking number to winner and seller
		// For now just create a new shipping object with this information
		
		// Get the shipment object
		const shipment = await createShippingLabel(item, seller_info, winning_user_info)

		// Buy the lowest rate shipment option
		const sh = shipment.buy(shipment.lowestRate(['USPS'], ['First']))

		// Create a new shipment object with the shipping label and tracking number, to be used later or an error if the shipment was not created
		sh.then(function(result) {
			const [object, e3] = itemModel.createShipment(item['item_id'], result.postage_label.label_url, result.tracking_code)
		}).catch(function(err) {
			console.log("Error creating shipping label " + err)
		})

		console.log("For item id " + item['item_id'])
		console.log("Seller email: " + seller_info['email'])
		console.log("Winner email: " + winning_user_info['email'])

		// Return id of the winning bid
		return winning_bid_id;
	}


	/**
	 * This method creates the shipment item using EasyPost
	 * 
	 * What this method does:
	 * 1. Get address of both buyer and seller
	 * 2. Get information for the parcel
	 * 3. Create the shipment
	 * 4. Return the created shipment
	 * 
	 * @param  {Item} item - Item object that is being sold
	 * @param  {User} seller - Seller of the item, the From Address
	 * @param  {User} winner - Winner of the item, the To Address
	 * @return {Shipment} - Shipment created using EasyPost API
	 */
	const createShippingLabel = async (item, seller, winner) => {
		
		// From address is the seller of the item
		const fromAddress = new api.Address({
		  name: seller['first_name'] + " " + seller['last_name'], 
		  street1: seller['address_1'],
		  street2: seller['address_2'],
		  city: seller['city'],
		  state: seller['state'],
		  zip: seller['zip'],
		  phone: seller['phone']
		});

		fromAddress.save()

		// To address is the winner of the item
		const toAddress = new api.Address({
		  name: winner['first_name'] + " " + winner['last_name'], 
		  street1: winner['address_1'],
		  street2: winner['address_2'],
		  city: winner['city'],
		  state: winner['state'],
		  zip: winner['zip'],
		  phone: winner['phone']
		});

		toAddress.save()
		

		// Parcel information
		// Arbitrary numbers since we don't record this for the item
		// TODO: Add these fields when user creates an item
		// OR just keep them arbitrary for now
		const parcel = new api.Parcel({
		  length: 9,
		  width: 6,
		  height: 2,
		  weight: 10,
		});

		parcel.save()

		// Create the shipment item
		const shipment = new api.Shipment({
		  to_address: toAddress,
		  from_address: fromAddress,
		  parcel: parcel
		});

		await shipment.save()

		// Return the shipment
		return shipment;

	}

	return {
    	chooseAndNotifyWinner,
    	createShippingLabel,
  };
}

module.exports = {
  RaffleService,
};