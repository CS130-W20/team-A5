const bcrypt = require('bcrypt');
const _ = require('lodash');

const saltRounds = 12;

const allButPasshash = ['id', 'first_name', 'last_name', 'email', 'pic_url', 'address_1', 'address_2', 'city', 'state', 'zip', 'phone', 'balance', 'auth_token']

/**
 * Function to define the User Model
 * @constructor
 * @param  {UserRepo} repo - User Database Model to be used
 * @return {UserModel} - UserModel Object
 */
const UserModel = (repo) => {
  /**
   * Creates a user with given info
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
  const createUser = async (first_name, last_name, email, password, pic_url, address_1, address_2, city, state, zip, phone, token) => {
    const passhash = await bcrypt.hash(password, saltRounds);
    const [user, err] = await repo.createUser(first_name, last_name, email, passhash, pic_url, address_1, address_2, city, state, zip, phone, token);

    return [_.pick(user, allButPasshash), err];
  };

  /**
   * Gets user info (except pass_hash) given the user's authentication token
   * 
   * @param  {string} token - Authentication token used to get user information
   * @return {Array<{0: User, 1: String}>} - Array with Rafflebay User Object and error (only one or the other)
   */
  const getUserInfoByToken = async (token) => {
    const [user, err] = await repo.getUserInfoByAuthToken(token);
    if (user == null) {
      return [null, "User not found"]
    }
    return [_.pick(user, allButPasshash), err];
  };

  /**
   * Returns all user info (except passhash) given a user id
   * 
   * @param  {string} id - ID of user to get
   * @return {Array<{0: User, 1: String}>} - Array with Rafflebay User Object and error (only one or the other)
   */
  const getUserInfoById = async (id) => {
    const [user, err] = await repo.getUserInfoById(id);
    return [_.pick(user, allButPasshash), err];
  }

  /**
   * Retrieve abbreviated user fields from the user column by a user's id. 
   * This should only ever return one user, since IDs should be unique
   *
   * @param  {number} id - ID of user to get 
   * @return {Array<{0: User, 1: String}>} - Array with Rafflebay User Object and error (only one or the other)
   */
  const getOtherUserInfo = async (id) => {
    const [user, err] = await repo.getUserInfoById(id);
    return [_.pick(user, ['id', 'first_name', 'last_name', 'pic_url']), err];
  };

  /**
   * Verifies a users email and password for user login
   * 
   * @param  {string} email - Email string of user for login
   * @param  {string} password - Password string of user for login
   * @return {Array<{0: User, 1: String}>} - Array with Rafflebay User Object and error (only one or the other)
   */
  const verifyPasswordAndReturnUser = async (email, password) => {
    const [user, err] = await repo.getUserInfoByEmail(email);
    if (err) {
      return [null, err];
    }
    if (user == null) {
      return [null, "Incorrect Email"];
    }
    const pass_match = await bcrypt.compare(password, user.passhash)
    
    if (pass_match) {
      return [_.pick(user, allButPasshash), null]
    }
    return [null, "Incorrect Password"];
  };

  /**
   * Debits funds from a user's account
   * 
   * @param  {number} user_id - ID for user to debit funds from
   * @param  {number} amount - Amount to remove from user's account
   * @return {Array<{0: User, 1: String}>} - Array with updated Rafflebay User Object and error (only one or the other)
   */
  const debitUserFunds = async (user_id, amount) => {
    const [user, err] = await repo.debitUserFunds(user_id, amount);
    return [_.pick(user, allButPasshash), err];
  }

  /**
   * Adds funds to a user's account, and sets the corresponding payment to be completed
   * 
   * @param  {number} user_id - ID for user to add funds
   * @param  {number} amount - Amount to deposit into user's account
   * @param  {number} payment_id - Stripe Payment ID to be set completed
   * @return {Array<{0: User, 1: String}>} - Array with updated Rafflebay User Object and error (only one or the other)
   */
  const addUserFundsAndSetPaymentCompleted = async (user_id, amount, payment_id) => {
    const [payment, err1] = await repo.setPaymentCompleted(payment_id);
    if (err1) {
      return [null, err1]
    }

    const [user, err2] = await repo.addUserFunds(user_id, amount);
    return [_.pick(user, allButPasshash), err2];
  }

  /**
   * Tells the database to create a new payment entry
   * 
   * @param  {string} payment_id - Stripe payment ID
   * @param  {float} amount - Dollar amount of payment
   * @param  {number} user_id - Rafflebay user id of the payment
   * @return {Array<{0: Payment, 1: String}>} - Array with Rafflebay Payment Object and error (only one or the other)
   */
  const createPayment = async (payment_id, amount, user_id) => {
    return await repo.createPayment(payment_id, amount, user_id);
  }

  /**
   * Gets payment info from database 
   * 
   * @param  {string} payment_id - Stripe Payment ID
   * @return {Array<{0: Payment, 1: String}>} - Array with Rafflebay Payment Object and error (only one or the other)
   */
  const getPaymentInfoByPaymentId = async (payment_id) => {
    return await repo.getPaymentInfoByPaymentId(payment_id);
  }

  return {
    createUser,
    getUserInfoByToken,
    getUserInfoById,
    getOtherUserInfo,
    verifyPasswordAndReturnUser,
    debitUserFunds,
    addUserFundsAndSetPaymentCompleted,
    createPayment,
    getPaymentInfoByPaymentId,
  };
};

module.exports = {
  UserModel,
};
