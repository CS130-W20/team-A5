const ItemModel = (repo) => {
  // Creates an item with given info
  const createItem= async (item_name, seller_id, pic_url, item_description, tags, sale_price, ticket_price, total_tickets, deadline, status) => {

    const [item, err] = await repo.createItem(item_name, seller_id, pic_url, item_description, tags, sale_price, ticket_price, total_tickets, deadline, status);

    return [item, err];
  };

  const getItemInfo = async (item_id) => {
    const [item, err] = await repo.getItemInfo(item_id);
    if (item == null) {
      return [null, "Item not found"]
    }
    return [item, err];
  };

  // Gets all bids for a given item_id
  const getBidsForItem = async (item_id) => {
    return await repo.getBidsForItem(item_id);
  }

  // Sets a bid as the winner given a bid_id
  const setBidAsWinner = async (bid_id) => {
    return await repo.setBidAsWinner(bid_id);
  }

  // Gets all items with a given status
  const getItemsWithStatus = async (status) => {
    return await repo.getItemsWithStatus(status);
  }

  // Updates item with given id to the given status
  const updateItemStatus = async (item_id, status) => {
    return await repo.updateItemStatus(item_id, status);
  }

  // Calls repo method to create a bid. The repo method is atomic, will ensure bid can
  // go through before creating
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
