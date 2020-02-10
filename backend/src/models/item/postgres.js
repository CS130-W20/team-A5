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
      bids text,
      deadline timestamptz,
      status text,
      current_ledger float,
      created_at timestamptz DEFAULT NOW()
    );`;


  // Uses createItemTableSQL to create the table, and logs the error.
  const setupRepo = async () => {
    try {
      const client = await postgres.connect();
      await client.query(createItemTableSQL);
      client.release();
      console.log('Item Table Created');
      return null;
    } catch (err) {
      return err;
    }
  };

  // Inserts an item entry into the items table
  const createItemSQL = `
    INSERT INTO items(item_name, seller_id, pic_url, item_description, tags, sale_price, ticket_price, total_tickets, bids, deadline, status, current_ledger)
    VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
    RETURNING *;`;

  // Uses createItemSQL and inserts an item into the items column. If we get an
  // error, then we return the (null, error), otherwise return (data, null)
  const createItem = async (item_name, seller_id, pic_url, item_description, tags, sale_price, ticket_price, total_tickets, bids, deadline, status, current_ledger) => {
    const values = [item_name, seller_id, pic_url, item_description, tags, sale_price, ticket_price, total_tickets, bids, deadline, status, current_ledger];
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
  const getItemInfoSQL = `
    SELECT * FROM items WHERE item_id=$1;`;

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

  return {
    setupRepo,
    createItem,
    getItemInfo,
  };
};

module.exports = {
  ItemRepo,
};
