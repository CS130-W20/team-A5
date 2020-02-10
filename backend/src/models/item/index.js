const buyerView = ['item_name', 'pic_url', 'item_description', 'tags', 'sale_price', 'ticket_price', 'total_tickets','deadline']

const ItemModel = (repo) => {
  // Creates an item with given info
  const createItem= async (item_name, seller_id, pic_url, item_description, tags, sale_price, ticket_price, total_tickets, bids, deadline, status, current_ledger, token) => {

    const [item, err] = await repo.createItem(item_name, seller_id, pic_url, item_description, tags, sale_price, ticket_price, total_tickets, bids, deadline, status, current_ledger, token);

    return [item, err];
  };

  const getItemInfo = async (item_id) => {
    const [item, err] = await repo.getItemInfo(item_id);
    if (item == null) {
      return [null, "Item not found"]
    }
    return [item, err];
  };

  const getItemInfoRestricted = async (item_id) => {
    const [item, err] = await repo.getItemInfo(item_id);
    if (item == null) {
      return [null, "Item not found"]
    }
    return [_.pick(item, buyerView), err];
  };


  return {
    createItem,
    getItemInfo,
    getItemInfoRestricted,
  };
};

module.exports = {
  ItemModel,
};
