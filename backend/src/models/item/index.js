/**
 * Function to define the Item Model
 * @constructor
 * @param  {Database} repo - Database Model to be used
 * @return {ItemModel} - ItemModel Object
 */
const ItemModel = (repo) => {
  // Creates an item with given info
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
   * @return {Array<{0: Bid, 1: String}>} - Array with new Rafflebay Bid Object and error (only one or the other)
   */
  const createBid = async (user_id, item_id, ticket_count, total_cost) => {
    return await repo.createBid(user_id, item_id, ticket_count, total_cost);
  }

  return {
    createItem,
    getItemInfo,
    createBid,
    getBidsForItem,
    setBidAsWinner,
    getItemsWithStatus,
    updateItemStatus,
  };
};

module.exports = {
  ItemModel,
};
