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

  // Calls repo method to create a bid. The repo method is atomic, will ensure bid can
  // go through before creating
  const createBid = async (user_id, item_id, ticket_count, total_cost) => {
    return await repo.createBid(user_id, item_id, ticket_count, total_cost);
  }

  return {
    createItem,
    getItemInfo,
    createBid,
  };
};

module.exports = {
  ItemModel,
};
