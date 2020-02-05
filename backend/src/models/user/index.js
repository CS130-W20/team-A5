const _ = require('lodash');

const UserModel = (repo) => {
  // Creates a user with given info
  const createUser = async (first_name, last_name, email, pic_url, address_1, address_2, city, state, zip, phone, token) => {
    return repo.createUser(first_name, last_name, email, pic_url, address_1, address_2, city, state, zip, phone, token);
  };

  const getUserInfoByToken = async (id) => {
    return await repo.getUserInfoByAuthToken(id);
  };

  const getOtherUserInfo = async (id) => {
    return await repo.getOtherUserInfo(id);
  };

  return {
    createUser,
    getUserInfoByToken,
    getOtherUserInfo,
  };
};

module.exports = {
  UserModel,
};
