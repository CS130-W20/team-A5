const EasyPost = require('@easypost/api');
const api = new EasyPost('EZTK306be7aecba44da486ac37dd01871296leZm7Qb3VVPb0bv17K3ACA')
const sgMail = require('@sendgrid/mail');
sgMail.setApiKey(process.env.SENDGRID_API_KEY);


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
	 * 1. Selects winner with weighted random, using true random seeds from the frontend
	 * 2. Set that bid as the winner
	 * 3. Get user info for seller and winner
	 * 4. Send alert email to the winner
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

		// Also build a sum of all of the random seeds of the bids
		let random_sum = 0
		for (let i = 0; i < bids.length; i++) {
			let curr_bid = bids[i]
			let bid_id = curr_bid['bid_id']
			random_sum += curr_bid['random_seed']

			for (let count = 0; count < curr_bid['ticket_count']; count++) {
				ticket_arr.push(bid_id)
			}
		}

		// Use the random seed sum from the bids to get an index of the winner
		const winner_index = random_sum % ticket_arr.length

		const winning_bid_id = ticket_arr[winner_index];

		// Now that we have the winning bid, set it as the winner
		const [winning_bid_info, e] = await itemModel.setBidAsWinner(winning_bid_id);

		// Update status of the item to "AS" ("Awaiting Shipment")
		let updated_item = await itemModel.updateItemStatus(item['item_id'], "AS")

		// Get user info of seller and winner
		const [seller_info, e1] = await userModel.getUserInfoById(item['seller_id'])
		const [winning_user_info, e2] = await userModel.getUserInfoById(winning_bid_info['user_id'])
		
		// Get the shipment object
		const shipment = await createShippingLabel(item, seller_info, winning_user_info)

		// Buy the lowest rate shipment option
		// Then create a new shipment object with the shipping label and tracking number, to be used later or an error if the shipment was not created
		// Then send an email to the seller with the shipping label
		let sh = await shipment.buy(shipment.lowestRate(['USPS'], ['First']))
		const [shipping_object, e3] = await itemModel.createShipment(item['item_id'], winning_bid_info['user_id'], item['seller_id'], sh.postage_label.label_url, sh.tracking_code);
		await sendShippingLabel(item, seller_info, sh.postage_label.label_url)
		if (e3) {
			console.log("Error while creating shipment object");
			return -1;
		}

		return winning_bid_id;
	}

	/**
	 * Function to send the tracking number to the winner
	 * Used once Easypost notifies us that the shipment was shipped
	 * @param  {Item} item - Item information that is being shipped
	 * @param  {User} winner - User who won the item
	 * @param  {string} tracking_code - tracking number
	 * @return {null} - Nothing is returned
	 */
	const sendTrackingNumber = async (item, winner, tracking_code) => {
		const msg = {
		  to: winner['email'],
		  from: 'admin@rafflebay.com',
		  subject: 'Your tracking number for your Rafflebay Item',
		  text: 'Congratulations! You won ' + item['item_name'] + ' . Here is the tracking code so you can follow your item: ' + tracking_code + ' . Enjoy!',
		};
		sgMail.send(msg);
	}


	/**
	 * Function to send the shipment label to the seller
	 * Used right after we create the shipping label
	 * @param  {Item} item - Item information that is being shipped
	 * @param  {User} seller - User who is selling the item
	 * @param  {string} label - link to the shipment label
	 * @return {null} - Nothing is returned
	 */
	const sendShippingLabel = async (item, seller, label) => {
		const msg = {
		  to: seller['email'],
		  from: 'admin@rafflebay.com',
		  subject: 'Your shipping label for your Rafflebay Item',
		  text: 'Congratulations! You sold ' + item['item_name'] + ' . Here is a link to the shipping label so you can send your item: ' + label + ' . Enjoy!',
		};
		sgMail.send(msg);
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
    	sendTrackingNumber,
    	sendShippingLabel,
    	createShippingLabel,
  };
}

module.exports = {
  RaffleService,
};