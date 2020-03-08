/**
 * Function to define the Item Model
 * @constructor
 * @param  {ItemRepo} repo - Item Database Model to be used
 * @return {ItemModel} - ItemModel Object
 */
const ItemModel = (repo) => {

  /**
   * Creates an item with given info
   * 
   * @param  {string} item_name - Name of item to add
   * @param  {number} seller_id - ID of user posting the item
   * @param  {string} pic_url - Picture of the item to sell
   * @param  {string} item_description - Description of item to sell
   * @param  {string} tags - Tags used to describe item
   * @param  {number} sale_price - Price for item
   * @param  {number} ticket_price - Price for each ticket for the item
   * @param  {number} total_tickets - Amount of tickets to sell
   * @param  {timestamp} deadline - Deadline for the item to sell
   * @param  {string} status - Status of the sale
   * @return {Array<{0: Item, 1: String}>} - Array with new Rafflebay Item Object and error (only one or the other)
   */
  const createItem= async (item_name, seller_id, pic_url, item_description, tags, sale_price, ticket_price, total_tickets, deadline, status) => {

    const [item, err] = await repo.createItem(item_name, seller_id, pic_url, item_description, tags, sale_price, ticket_price, total_tickets, deadline, status);

    return [item, err];
  };

  /**
   * Gets item info given an item id
   * 
   * @param  {number} item_id - ID of item to get
   * @return {Array<{0: Item, 1: String}>} - Array with Rafflebay Item Object and error (only one or the other)
   */
  const getItemInfo = async (item_id) => {
    const [item, err] = await repo.getItemInfo(item_id);
    if (item == null) {
      return [null, "Item not found"]
    }
    return [item, err];
  };
 
  /**
   * Gets all bids for a given item_id
   * 
   * @param  {number} item_id - ID of item to get bids for
   * @return {Array<{0: Array<Bid>, 1: String}>} - Array with Array of Bids for given item_id and error (only one or the other)
   */
  const getBidsForItem = async (item_id) => {
    return await repo.getBidsForItem(item_id);
  }

  /**
   * Sets a bid as the winner given a bid_id
   * 
   * @param  {number} bid_id - ID of bid to set as the winner
   * @return {Array<{0: Bid, 1: String}>} - Array with Rafflebay Bid Object and error (only one or the other)
   */
  const setBidAsWinner = async (bid_id) => {
    return await repo.setBidAsWinner(bid_id);
  }

  /**
   * Gets all items with a given status
   * 
   * @param  {string} status - Status string of ("IP", "AR", "AS") to get items for
   * @return {Array<{0: Array<Item>, 1: String}>} - Array with Array of Items for given status and error (only one or the other)
   */
  const getItemsWithStatus = async (status) => {
    return await repo.getItemsWithStatus(status);
  }

  /**
   * Updates item with given id to the given status
   * 
   * @param  {number} item_id - ID of item to change status for
   * @param  {string} status - Status string of ("IP", "AR", "AS") to set item
   * @return {Array<{0: Item, 1: String}>} - Array with Rafflebay Item Object and error (only one or the other)
   */
  const updateItemStatus = async (item_id, status) => {
    return await repo.updateItemStatus(item_id, status);
  }

  /**
   * Calls repo method to create a bid. 
   * The repo method is atomic, will ensure bid can go through before creating
   * 
   * @param  {number} user_id - ID of user creating the bid
   * @param  {number} item_id - ID of item bid is for
   * @param  {number} ticket_count - Number of tickets being purchased
   * @param  {number} total_cost - Total cost of entire bid
   * @param  {number} random_seed - Random seed value for this bid given by the frontend
   * @return {Array<{0: Bid, 1: String}>} - Array with new Rafflebay Bid Object and error (only one or the other)
   */
  const createBid = async (user_id, item_id, ticket_count, total_cost, random_seed) => {
    return await repo.createBid(user_id, item_id, ticket_count, total_cost, random_seed);
  }

  /**
   * Get all items where user was the seller
   * 
   * @param  {number} seller_id - ID of user selling the item
   * @return {Array<{0: Item, 1: String}>} - Array with Raffelbay Item Objects for seller and error (only one or the other)
   */
  const getItemsForSeller = async(seller_id) => {
    return await repo.getItemsForSeller(seller_id)
  }

  /**
   * Gets all bids for user
   * 
   * @param  {number} user_id - ID of user bidding on item
   * @return {Array<{0: Bid, 1: String}>} - Array with Rafflebay Bid Objects for userand error (only one or the other)
   */
  const getBidsForUser = async(user_id) => {
    return await repo.getBidsForUser(user_id)
  }

  /**
   * Creates a new Shipment object
   * 
   * @param  {number} item_id - ID of item for shipment
   * @param  {number} winner_id - ID of user who won item
   * @param  {number} seller_id - ID of user who sold item
   * @param  {string} label - String for URL for shipping label
   * @param  {string} tracking_number - String for tracking number for the shipment
   * @return {Array<{0: Shipment, 1: String}>} - Array with Rafflebay Shipment Objects and error (only one or the other)
   */
  const createShipment = async(item_id, winner_id, seller_id, label, tracking_number) => {
    return await repo.createShipment(item_id, winner_id, seller_id, label, tracking_number)
  }

  /**
   * Gets a shipment object with the given tracking number
   * 
   * @param  {string} tracking_number - String for the tracking number for the shipment
   * @return {Array<{0: Shipment, 1: String}>} - Array with Rafflebay Shipment Objects and error (only one or the other)
   */
  const getShipmentInformation = async(tracking_number) => {
    return await repo.getShipmentInformation(tracking_number)
  }

  /**
   * Gets info of all items that are in progress
   * 
   * @return {Array<{0: Array<Item>, 1: String}>} - Array with array of Rafflebay Item Objects and error (only one or the other)
   */
  const getItemFeed = async() => {
    return await repo.getItemFeed();
  }

  /**
   * Gets all items that have passed their deadline
   * @return {Array<{0: Array<Item>, 1: String}>} - Array with array of Rafflebay Item Objects and error (only one or the other)
   */
  const getItemsPastDeadline = async() => {
    return await repo.getItemsPastDeadline();
  }


  return {
    createItem,
    getItemInfo,
    createBid,
    getBidsForItem,
    setBidAsWinner,
    getItemsWithStatus,
    updateItemStatus,
    getItemsForSeller,
    getBidsForUser,
    createShipment,
    getShipmentInformation,
    getItemFeed,
    getItemsPastDeadline,
  };
};

module.exports = {
  ItemModel,
};
