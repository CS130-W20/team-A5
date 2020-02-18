const bcrypt = require('bcrypt');
const _ = require('lodash');

const saltRounds = 12;

const allButPasshash = ['id', 'first_name', 'last_name', 'email', 'pic_url', 'address_1', 'address_2', 'city', 'state', 'zip', 'phone', 'balance', 'auth_token']

const UserModel = (repo) => {
  // Creates a user with given info
  const createUser = async (first_name, last_name, email, password, pic_url, address_1, address_2, city, state, zip, phone, token) => {
    const passhash = await bcrypt.hash(password, saltRounds);
    const [user, err] = await repo.createUser(first_name, last_name, email, passhash, pic_url, address_1, address_2, city, state, zip, phone, token);

    return [_.pick(user, allButPasshash), err];
  };

  const getUserInfoByToken = async (token) => {
    const [user, err] = await repo.getUserInfoByAuthToken(token);
    if (user == null) {
      return [null, "User not found"]
    }
    return [_.pick(user, allButPasshash), err];
  };

  // Returns all user info (except passhash) given a user id
  const getUserInfoById = async (id) => {
    const [user, err] = await repo.getUserInfoById(id);
    return [_.pick(user, allButPasshash), err];
  }

  // Retrieve abbreviated user fields from the user column by a user's id. This should
  // only ever return one user, since IDs should be unique
  const getOtherUserInfo = async (id) => {
    const [user, err] = await repo.getUserInfoById(id);
    return [_.pick(user, ['id', 'first_name', 'last_name', 'pic_url']), err];
  };

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

  const debitUserFunds = async (user_id, amount) => {
    return await repo.debitUserFunds(user_id, amount);
  }

  return {
    createUser,
    getUserInfoByToken,
    getUserInfoById,
    getOtherUserInfo,
    verifyPasswordAndReturnUser,
    debitUserFunds,
  };
};

module.exports = {
  UserModel,
};
