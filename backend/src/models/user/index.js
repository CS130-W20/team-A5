const bcrypt = require('bcrypt');
const _ = require('lodash');

const saltRounds = 12;

const allButPasshash = ['id', 'first_name', 'last_name', 'email', 'pic_url', 'address_1', 'address_2', 'city', 'state', 'zip', 'phone', 'auth_token']

const UserModel = (repo) => {
  // Creates a user with given info
  const createUser = async (first_name, last_name, email, password, pic_url, address_1, address_2, city, state, zip, phone, token) => {
    const passhash = await bcrypt.hash(password, saltRounds);
    const [user, err] = await repo.createUser(first_name, last_name, email, passhash, pic_url, address_1, address_2, city, state, zip, phone, token);

    return [_.pick(user, allButPasshash), err];
  };

  const getUserInfoByToken = async (id) => {
    const [user, err] = await repo.getUserInfoByAuthToken(id);
    return [_.pick(user, allButPasshash), err];
  };

  const getOtherUserInfo = async (id) => {
    return await repo.getOtherUserInfo(id);
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

  return {
    createUser,
    getUserInfoByToken,
    getOtherUserInfo,
    verifyPasswordAndReturnUser,
  };
};

module.exports = {
  UserModel,
};
