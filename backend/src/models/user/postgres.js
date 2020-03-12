/**
 * Wrapper around postgres data functions for the User Model. 
 * Requires a postgres connection and ability to make valid postgres queries.
 *
 * @constructor
 * 
 * @param  {PostgresDB} postgres - Database instance
 * @return {UserRepo} - UserRepo Object
 */
const UserRepo = (postgres) => {
  /**
   * Sets up the user table if it does not exist
   * 
   * @type {string}
   */
  const createUserTableSQL = `
    CREATE TABLE IF NOT EXISTS users(
      id SERIAL PRIMARY KEY,
      first_name text,
      last_name text,
      email text NOT NULL UNIQUE,
      passhash text NOT NULL,
      pic_url text,
      address_1 text,
      address_2 text,
      city text,
      state text,
      zip text,
      phone text,
      balance float,
      auth_token text,
      created_at timestamptz DEFAULT NOW()
    );`;

  /**
   * Sets up the payments table
   *
   * @type {string}
   */
  const createPaymentTableSQL = `
    CREATE TABLE IF NOT EXISTS payments(
      payment_id text PRIMARY KEY,
      user_id integer NOT NULL,
      amount float,
      completed BOOLEAN,
      FOREIGN KEY (user_id) REFERENCES users(id),
      timestamp timestamptz DEFAULT NOW()
    );`

  /**
   * Uses createUserTableSQL and createPaymentTableSQL to create the tables.
   * 
   * @return {string} - Return Null if the table is created, and an error otherwise
   */
  const setupRepo = async () => {
    try {
      const client = await postgres.connect();
      await client.query(createUserTableSQL);
      await client.query(createPaymentTableSQL);
      client.release();
      console.log('User Table Created');
      console.log('Payments Table Created')
      return null;
    } catch (err) {
      return err;
    }
  };

  /**
   * Retrieve the user when the email is given
   * 
   * @type {string}
   */
  const getUserInfoByEmailSQL = `
    SELECT * FROM users WHERE email=$1;`;

  /**
   * Uses getUserInfoByEmailSQL to retrieve the user, and return either (user, null), or (null, error)
   * 
   * @param  {string} email - Email of the user to retrieve
   * @return {Array<{0: User, 1: String}>} - Array with Rafflebay User Object and error (only one or the other)
   */
  const getUserInfoByEmail = async (email) => {
    const values = [email];
    try {
      const client = await postgres.connect();
      const res = await client.query(getUserInfoByEmailSQL, values);
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err];
    }
  };

  /**
   * Inserts a user entry into the users table
   * 
   * @type {string}
   */
  const createUserSQL = `
    INSERT INTO users(first_name, last_name, email, passhash, pic_url, address_1, address_2, city, state, zip, phone, balance, auth_token)
    VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, 0, $12)
    RETURNING *;`;

  /**
   * Users createUserSQL and inserts a user into the users column. 
   * If we get an error, then we return the (null, error), otherwise return (data, null)
   * 
   * @param  {string} first_name - First name of the user
   * @param  {string} last_name - Last name of the user
   * @param  {string} email - Email of the user
   * @param  {string} password - Password of user
   * @param  {string} pic_url - Profile picture of user
   * @param  {string} address_1 - Address line 1 for user address
   * @param  {string} address_2 - Address line 2 for user address
   * @param  {string} city - City for user address
   * @param  {string} state - State for user address
   * @param  {string} zip - Zip code for user address
   * @param  {string} phone - Phone number of user
   * @param  {string} token - Authentication token for user
   * @return {Array<{0: User, 1: String}>} - Array with Rafflebay User Object and error (only one or the other)
   */
  const createUser = async (first_name, last_name, email, passhash, pic_url, address_1, address_2, city, state, zip, phone, token) => {
    const values = [first_name, last_name, email, passhash, pic_url, address_1, address_2, city, state, zip, phone, token];
	const emails = [email];
    try {
      const client = await postgres.connect();
	  const check = await client.query(getUserInfoByEmailSQL, emails); 
	  if(check.rows.length == 0){
      const res = await client.query(createUserSQL, values);
      client.release();
      return [res.rows[0], null];
	  } else {
		  client.release();
		  return[null, "User Already Exists"];
	  }
    } catch (err) {
      return [null, err];
    }
  };

  /**
   * Retrieve the user when given the auth_token
   * 
   * @type {string}
   */
  const getUserInfoByAuthTokenSQL = `
    SELECT * FROM users WHERE auth_token=$1;`;

  /**
   * Uses getUserIDByAuthTokenSQL to retrieve the user, and return either (user, null), or (null, error)
   * 
   * @param  {string} token - Authentication token for the user
   * @return {Array<{0: User, 1: String}>} - Array with Rafflebay User Object and error (only one or the other)
   */
  const getUserInfoByAuthToken = async (token) => {
    const values = [token];
    try {
      const client = await postgres.connect();
      const res = await client.query(getUserInfoByAuthTokenSQL, values);
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err];
    }
  };


  /**
   * Retrieves the user when the id is given, other layers can pick certain fields to return
   * @type {string}
   */
  const getUserInfoByIdSQL = `
    SELECT * FROM users WHERE id=$1;`;

  /**
   * Uses getUserInfoByIdSQL to retrieve the user, and return either (user, null), or (null, error)
   * 
   * @param  {number} id - ID of user to retrieve
   * @return {Array<{0: User, 1: String}>} - Array with Rafflebay User Object and error (only one or the other)
   */
  const getUserInfoById = async (id) => {
    const values = [id];
    try {
      const client = await postgres.connect();
      const res = await client.query(getUserInfoByIdSQL, values);
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err];
    }
  };

  /**
   * SQL to debit funds from user balance
   * 
   * @type {string}
   */
  const debitUserFundsSQL = `
    UPDATE users 
    SET balance = (balance - $2)
    WHERE id = $1
    RETURNING *`;

  /**
   * Debits user funds. Assume controller/caller has verified that this will not make the balance negative
   * 
   * @param  {number} user_id - ID of user to update
   * @param  {number} amount - Amount used to update user balance
   * @return {Array<{0: User, 1: String}>} - Array with Rafflebay User Object and error (only one or the other)
   */
  const debitUserFunds = async (user_id, amount) => {
    const values = [user_id, amount];
    try {
      const client = await postgres.connect();
      const res = await client.query(debitUserFundsSQL, values);
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err];
    }
  };

  /**
   * SQL to add funds to user balance
   * 
   * @type {string}
   */
  const addUserFundsSQL = `
    UPDATE users 
    SET balance = (balance + $2)
    WHERE id = $1
    RETURNING *`;

  /**
   * Adds user funds. 
   * 
   * @param  {number} user_id - ID of user to update
   * @param  {number} amount - Amount used to update user balance
   * @return {Array<{0: User, 1: String}>} - Array with Rafflebay User Object and error (only one or the other)
   */
  const addUserFunds = async (user_id, amount) => {
    const values = [user_id, amount];
    try {
      const client = await postgres.connect();
      const res = await client.query(addUserFundsSQL, values);
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err];
    }
  };

  /**
   * SQL to create new payment table entry
   * @type {string}
   */
  const createPaymentSQL = `
    INSERT INTO payments(payment_id, amount, user_id, completed)
    VALUES($1, $2, $3, false)
    RETURNING *;
  `;

  /**
   * Creates a new payment entry 
   * 
   * @param  {string} payment_id - Stripe payment ID
   * @param  {float} amount - Dollar amount of payment
   * @param  {number} user_id - Rafflebay user id of the payment
   * @return {Array<{0: Payment, 1: String}>} - Array with Rafflebay Payment Object and error (only one or the other)
   */
  const createPayment = async (payment_id, amount, user_id) => {
    const values = [payment_id, amount, user_id];
    try {
      const client = await postgres.connect();
      const res = await client.query(createPaymentSQL, values);
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err];
    }
  }

  /**
   * SQL to get payment info by a payment id
   * @type {string}
   */
  const getPaymentByIdSQL = `
    SELECT * FROM payments
    WHERE payment_id=$1;
  `;

  /**
   * Gets the info of a payment
   * 
   * @param  {string} payment_id - Stripe Payment ID
   * @return {Array<{0: Payment, 1: String}>} - Array with Rafflebay Payment Object and error (only one or the other)
   */
  const getPaymentInfoByPaymentId = async (payment_id) => {
    const values = [payment_id];
    try {
      const client = await postgres.connect();
      const res = await client.query(getPaymentByIdSQL, values);
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err];
    }
  }

  /**
   * SQL to set a payment as completed
   * 
   * @type {string}
   */
  const setPaymentCompletedSQL = `
    UPDATE payments SET completed=true
    WHERE payment_id=$1
    RETURNING *;
  `;

  /**
   * Sets a given payment ID as completed, i.e. funds have been transferred
   * @param  {string} payment_id - Stripe payment ID
   * @return {Array<{0: Payment, 1: String}>} - Array with Rafflebay Payment Object and error (only one or the other)
   */
  const setPaymentCompleted = async (payment_id) => {
    const values = [payment_id];
    try {
      const client = await postgres.connect();
      const res = await client.query(setPaymentCompletedSQL, values);
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err];
    }
  };

  return {
    setupRepo,
    createUser,
    getUserInfoByAuthToken,
    getUserInfoByEmail,
    getUserInfoById,
    debitUserFunds,
    addUserFunds,
    createPayment,
    getPaymentInfoByPaymentId,
    setPaymentCompleted,
  };
};

module.exports = {
  UserRepo,
};
