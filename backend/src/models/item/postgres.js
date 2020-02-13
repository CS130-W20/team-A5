// Wrapper around postgres data functions for the Item Model. Requires a
// postgres connection and ability to make valid postgres queries.

const ItemRepo = (postgres) => {
  //Setup the item table if it does not exist
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


  // Uses createItemTableSQL to create the table, and logs the error.
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

  // Inserts an item entry into the items table
  const createItemSQL = `
    INSERT INTO items(item_name, seller_id, pic_url, item_description, tags, sale_price, ticket_price, total_tickets, deadline, status, current_ledger)
    VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
    RETURNING *;`;

  // Uses createItemSQL and inserts an item into the items column. If we get an
  // error, then we return the (null, error), otherwise return (data, null)
  const createItem = async (item_name, seller_id, pic_url, item_description, tags, sale_price, ticket_price, total_tickets, deadline, status, current_ledger) => {
    const values = [item_name, seller_id, pic_url, item_description, tags, sale_price, ticket_price, total_tickets, deadline, status, current_ledger];
    try {
      const client = await postgres.connect();
      const res = await client.query(createItemSQL, values);
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err];
    }
  };

  // Retrieve the item id where the id is given and the user is the seller
  // Aggregates the total tickets sold value into the returned info for ease of
  // Displaying this info to users
  const getItemInfoSQL = `
    SELECT 
      items.*, 
      COALESCE(SUM(bids.total_cost),0) AS current_ledger,
      CAST(COALESCE(SUM(bids.ticket_count),0) AS integer) AS tickets_sold
    FROM items LEFT JOIN bids 
      ON items.item_id = bids.item_id 
    WHERE items.item_id = $1
    GROUP BY items.item_id;`

  // Uses getItemInfoSQL to retrieve the item, and return either (item, null),
  // or (null, error)
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

  // SQL to update the status of an item
  const updateItemStatusSQL = `
    UPDATE items SET status = $1;`

  // SQL to create a new Bid item
  const createBidSQL = `
    INSERT INTO bids(user_id, item_id, ticket_count, total_cost, did_win, refunded)
    VALUES ($1, $2, $3, $4, false, false)
    RETURNING *;`

  // Use createBidSQL to create a new bid, tying together a user 
  // and item they have bid on

  // THIS METHOD IS ATOMIC
  // Steps to take
  // 1. Get tickets sold count for item
  // 2. Ensure it is possible to make the transaction
  // 3. Create the bid
  // 4. If this used up all the tickets, set the item status to "AR" ("Awaiting Raffle")
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

      // Ensure the item is still accepting bids
      if (status != "IP") {
        return [null, "The raffle is no longer in progress"];
      }
      console.log(typeof soldCount)
      // Ensure there are enough tickets left to sell
      if (soldCount + ticket_count > totalTix) {
        return [null, "Attempt to purchase too many tickets"];
      }

      // Create bid
      const res = await client.query(createBidSQL, values);

      // If this used up the last of the tickets, set the item status to "AR" ("Awaiting Raffle")
      if (soldCount + ticket_count == totalTix) {
        const itemStatusRes = await client.query(updateItemStatusSQL, ["AR"]);
      }
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err.message];
    }
  };

  return {
    setupRepo,
    createItem,
    getItemInfo,
    createBid,
  };
};

module.exports = {
  ItemRepo,
};
