// Wrapper around postgres data functions for the User Model. Requires a
// postgres connection and ability to make valid postgres queries.
const UserRepo = (postgres) => {
  //Setup the user table if it does not exist
  const createUserTableSQL = `
    CREATE TABLE IF NOT EXISTS users(
      id SERIAL PRIMARY KEY,
      first_name text,
      last_name text,
      email text NOT NULL UNIQUE,
      pic_url text,
      address_1 text,
      address_2 text,
      city text,
      state text,
      zip text,
      phone text,
      created_at timestamptz DEFAULT NOW()
    );`;

  // Uses createUserTableSQL to create the table, and logs the error.
  const setupRepo = async () => {
    try {
      const client = await postgres.connect();
      await client.query(createUserTableSQL);
      client.release();
      console.log('User Table Created');
      return null;
    } catch (err) {
      return err;
    }
  };

  // Inserts a user entry into the users table
  const createUserSQL = `
    INSERT INTO users(first_name, last_name, email, pic_url, address_1, address_2, city, state, zip, phone)
    VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
    RETURNING *;`;

  // Users createUserSQL and inserts a user into the users column. If we get an
  // error, then we return the (null, error), otherwise return (data, null)
  const createUser = async (first_name, last_name, email, pic_url, address_1, address_2, city, state, zip, phone) => {
    const values = [first_name, last_name, email, pic_url, address_1, address_2, city, state, zip, phone];
    try {
      const client = await postgres.connect();
      const res = await client.query(createUserSQL, values);
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err];
    }
  };

  // Retrieve all user fields from the user column by a user's id. This should
  // only ever return one user, since IDs should be unique
  const getUserSQL = `
    SELECT * FROM users WHERE id=$1;`;

  // Uses getUserSQL to retrieve the user, and return either (user, null),
  // or (null, error)
  const getUser = async (id) => {
    const values = [id];
    try {
      const client = await postgres.connect();
      const res = await client.query(getUserSQL, values);
      client.release();
      return [res.rows[0], null];
    } catch (err) {
      return [null, err];
    }
  };

  return {
    setupRepo,
    createUser,
    getUser,
  };
};

module.exports = {
  UserRepo,
};
