/**
 * Wrapper around postgres data functions for the Item Model. 
 * Requires a postgres connection and ability to make valid postgres queries.
 * 
 * @param  {Database} postgres - Database for the objects
 * @return {ItemRepo} - ItemRepo Object
 */
const ItemRepo = (postgres) => {
  
  /**
   * Set up the item table if it does not exist
   * 
   * @type {string}
   */
  const createItemTableSQL = `
    CREATE TABLE IF NOT EXISTS items(
      item_id SERIAL PRIMARY KEY,
      item_name text NOT NULL,
      seller_id integer NOT NULL,
      pic_url text,
      item_description text,
      tags text,
      sale_price float NOT NULL,
      ticket_price float,
      total_tickets integer NOT NULL,
      deadline timestamptz,
      status text,
      created_at timestamptz DEFAULT NOW()
    );`;

  /**
   * Set up the bid table if it does not exist
   * 
   * @type {string}
   */
  const createBidTableSQL = `
    CREATE TABLE IF NOT EXISTS bids(
      bid_id SERIAL PRIMARY KEY,
      user_id integer NOT NULL,
      item_id integer NOT NULL,
      ticket_count integer NOT NULL,
      total_cost float,
      did_win BOOLEAN,
      refunded BOOLEAN,
      timestamp timestamptz DEFAULT NOW(),
      FOREIGN KEY (user_id) REFERENCES users(id),
      FOREIGN KEY (item_id) REFERENCES items(item_id)
    );`;

  /**
   * Uses createItemTableSQL and createBidTableSQL to create the tables, and logs the error.
   * 
   * @return {string} - Return Null if the tables are created, and an error otherwise
   */
  const setupRepo = async () => {
    try {
      const client = await postgres.connect();
      await client.query(createItemTableSQL);
      await client.query(createBidTableSQL);
      client.release();
      console.log('Item Table Created');
      console.log('Bid Table Created');
      return null;
    } catch (err) {
      return err;
    }
  };

  /**
   * Inserts an item entry into the items tabl
   * 
   * @type {string}
   */
  const createItemSQL = `
    INSERT INTO items(item_name, seller_id, pic_url, item_description, tags, sale_price, ticket_price, total_tickets, deadline, status)
    VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
    RETURNING *;`;

  /**
   * Uses createItemSQL and inserts an item into the items column. 
   * If we get an error, then we return the (null, error), otherwise return (data, null)
   * 
   * @param  {string} item_name - Name of item
   * @param  {number} seller_id - ID of user who posted item
   * @param  {string} pic_url - String of url for item picture
   * @param  {string} item_description - Description for item
   * @param  {string} tags - List of tags to describe the item
   * @param  {number} sale_price - Price of the item
   * @param  {number} ticket_price - Price of the tickets for the item
   * @param  {number} total_tickets - Amount of tickets being sold
   * @param  {datetime} deadline - Time until raffle closes
   * @param  {string} status - Status of the raffle
   * @return {Array<{0: Item, 1: String}>} - Array with Rafflebay Item Object and error (only one or the other)
   */
  const createItem = async (item_name, seller_id, pic_url, item_description, tags, sale_price, ticket_price, total_tickets, deadline, status) => {
    const values = [item_name, seller_id, pic_url, item_description, tags, sale_price, ticket_price, total_tickets, deadline, status];
    try {
      const client = await postgres.connect();
      const res = await client.query(createItemSQL, values);
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err];
    }
  };

  /**
   * Retrieve the item id where the id is given and the user is the seller.
   * Aggregates the total tickets sold value into the returned info for ease of displaying this info to users
   * 
   * @type {string}
   */
  const getItemInfoSQL = `
    SELECT 
      items.*, 
      COALESCE(SUM(bids.total_cost),0) AS current_ledger,
      CAST(COALESCE(SUM(bids.ticket_count),0) AS integer) AS tickets_sold
    FROM items LEFT JOIN bids 
      ON items.item_id = bids.item_id 
    WHERE items.item_id = $1
    GROUP BY items.item_id;`

  /**
   * Uses getItemInfoSQL to retrieve the item, and return either (item, null), or (null, error)
   * 
   * @param  {number} item_id - ID of item to get info of
   * @return {Array<{0: Item, 1: String}>} - Array with Rafflebay Item Object and error (only one or the other)
   */
  const getItemInfo= async (item_id) => {
    const values = [item_id];
    try {
      const client = await postgres.connect();
      const res = await client.query(getItemInfoSQL, values);
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err];
    }
  };

  /**
   * Gets all bids for a specified item id
   * 
   * @type {string}
   */
  const getBidsForItemSQL = `
    SELECT * from bids where item_id=$1;`;

  /**
   * Given an item id, get all bids
   * 
   * @param  {number} item_id - ID of item to get bids for
   * @return {Array<{0: Array<Bid>, 1: String}>} - Array with array of Rafflebay Bid Objects and error (only one or the other)
   */
  const getBidsForItem = async(item_id) => {
    const values = [item_id];
    try {
      const client = await postgres.connect();
      const res = await client.query(getBidsForItemSQL, values);
      client.release();
      return [res.rows, null];
    } catch (err) {
      return [null, err];
    }
  }

  /**
   * Sets a bid with a given bid_id as the winning bid
   * 
   * @type {string}
   */
  const setBidAsWinnerSQL = `
    UPDATE bids SET did_win=true WHERE bid_id=$1 RETURNING *;`;

  /**
   * Given a bid ID, set it as a winner
   * 
   * @param  {number} bid_id - ID of bid to update
   * @return {Array<{0: Bid, 1: String}>} - Array with Rafflebay Bid Object and error (only one or the other)
   */
  const setBidAsWinner = async(bid_id) => {
    const values = [bid_id];
    try {
      const client = await postgres.connect();
      const res = await client.query(setBidAsWinnerSQL, values);
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err];
    }
  }

  /**
   * Gets all items with a given status
   * Includes current-ledger and tickets_sold as this will be used for displaying items
   * 
   * @type {string}
   */
  const getItemsWithStatusSQL = `
    SELECT 
      items.*, 
      COALESCE(SUM(bids.total_cost),0) AS current_ledger,
      CAST(COALESCE(SUM(bids.ticket_count),0) AS integer) AS tickets_sold
    FROM items LEFT JOIN bids 
      ON items.item_id = bids.item_id 
    WHERE items.status = $1
    GROUP BY items.item_id;`;

  /**
   * Returns all items with a given status.
   * Includes aggregated fields current_ledger and tickets_sold
   * 
   * @param  {string} status - Status of items to look for 
   * @return {Array<{0: Array<Item>, 1: String}>} - Array with array of Rafflebay Item Objects and error (only one or the other)
   */
  const getItemsWithStatus= async (status) => {
    const values = [status];
    try {
      const client = await postgres.connect();
      const res = await client.query(getItemsWithStatusSQL, values);
      client.release();
      return [res.rows, null];
    } catch (err) {
      return [null, err];
    }
  };

  /**
   * Updates the status of an item
   * 
   * @type {string}
   */
  const updateItemStatusSQL = `
    UPDATE items SET status = $2 WHERE item_id=$1;`

  /**
   * Sets the item with the given id to the given status
   * 
   * @param  {number} id - ID of item to update
   * @param  {string} status - Status to update item to
   * @return {Array<{0: Item, 1: String}>} - Array with Rafflebay Item Object and error (only one or the other)
   */
  const updateItemStatus= async (id, status) => {
    const values = [id, status];
    try {
      const client = await postgres.connect();
      const res = await client.query(updateItemStatusSQL, values);
      client.release();
      return [res.rows, null];
    } catch (err) {
      return [null, err];
    }
  };

  /**
   * Creates a new bid item
   * 
   * @type {string}
   */
  const createBidSQL = `
    INSERT INTO bids(user_id, item_id, ticket_count, total_cost, did_win, refunded)
    VALUES ($1, $2, $3, $4, false, false)
    RETURNING *;`

 
  /**
   * Use createBidSQL to create a new bid, tying together a user and item they have bid on
   * THIS METHOD IS ATOMIC
   * Steps to take
   * 1. Get tickets sold count for item
   * 2. Ensure it is possible to make the transaction
   * 3. Create the bid
   * 4. If this used up all the tickets, set the item status to "AR" ("Awaiting Raffle")
   * 
   * @param  {number} user_id - ID of user buying the bid
   * @param  {number} item_id - ID of the item being bid on
   * @param  {number} ticket_count - Amount of tickets user wants to buy
   * @param  {number} total_cost - Total cost of tickets that are being bought
   * @return {Array<{0: Bid, 1: String}>} - Array with Rafflebay Bid Object and error (only one or the other)
   */
  const createBid = async(user_id, item_id, ticket_count, total_cost) => {
    const values = [user_id, item_id, ticket_count, total_cost]
    try {
      const client = await postgres.connect();

      // Get all info about the item
      const itemRes = await client.query(getItemInfoSQL, [item_id]);
      const item = itemRes.rows[0]
      const soldCount = item['tickets_sold']
      const totalTix = item['total_tickets'];
      const status = item['status'];
      const seller_id = item['seller_id']

      // Ensure the seller is not bidding on their own item
      if (seller_id == user_id) {
        return [null, "Not allowed to buy tickets for own item"];
      }

      // Ensure the item is still accepting bids
      if (status != "IP") {
        return [null, "The raffle is no longer in progress"];
      }
      // Ensure there are enough tickets left to sell
      if (soldCount + ticket_count > totalTix) {
        return [null, "Attempt to purchase too many tickets"];
      }

      // Create bid
      const res = await client.query(createBidSQL, values);

      // If this used up the last of the tickets, set the item status to "AR" ("Awaiting Raffle")
      if (soldCount + ticket_count == totalTix) {
        const itemStatusRes = await updateItemStatus(item_id, "AR");
      }
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err.message];
    }
  };

  /**
   * Gets list of items by seller_id
   * Includes aggregated fields current_ledger and tickets_sold
   * 
   * @type {string}
   */
  const getItemsForSellerSQL = `
    SELECT 
      items.*, 
      COALESCE(SUM(bids.total_cost),0) AS current_ledger,
      CAST(COALESCE(SUM(bids.ticket_count),0) AS integer) AS tickets_sold
    FROM items LEFT JOIN bids 
      ON items.item_id = bids.item_id 
    WHERE items.seller_id = $1
    GROUP BY items.item_id;`

  /**
   * Gets all items that are sold by the user with seller_id
   * 
   * @param  {number} seller_id - ID of user who put up the item
   * @return {Array<{0: Array<Item>, 1: String}>} - Array with array of Rafflebay Item Objects and error (only one or the other)
   */
  const getItemsForSeller = async(seller_id) => {
    const values = [seller_id]
    try {
      const client = await postgres.connect();
      const res = await client.query(getItemsForSellerSQL, values);
      client.release();
      return [res.rows, null];
    } catch (err) {
      return [null, err];
    }
  };

  /**
   * Gets list of bids by user_id
   * Includes aggregated fields total_cost and tickets_bought
   * 
   * @type {string}
   */
  const getBidsForUserSQL = `
    SELECT 
      items.*, 
      COALESCE(SUM(bids.total_cost),0) AS total_cost,
      CAST(COALESCE(SUM(bids.ticket_count),0) AS integer) AS tickets_bought
    FROM items LEFT JOIN bids 
      ON items.item_id = bids.item_id 
    WHERE bids.user_id = $1
    GROUP BY items.item_id;`

  /**
   * Gets all bids for user with user_id
   * 
   * @param  {number} user_id - ID of user who bought the bids
   * @return {Array<{0: Array<Bid>, 1: String}>} - Array with array of Rafflebay Bid Objects and error (only one or the other)
   */
  const getBidsForUser = async(user_id) => {
    const values = [user_id]
    try {
      const client = await postgres.connect();
      const res = await client.query(getBidsForUserSQL, values);
      client.release();
      return [res.rows, null];
    } catch (err) {
      return [null, err];
    }
  };

  return {
    setupRepo,
    createItem,
    getItemInfo,
    createBid,
    getBidsForItem,
    setBidAsWinner,
    getItemsWithStatus,
    updateItemStatus,
    getItemsForSeller,
    getBidsForUser,
  };
};

module.exports = {
  ItemRepo,
};
