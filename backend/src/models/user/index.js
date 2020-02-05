const _ = require('lodash');

const UserModel = (repo) => {
  // Creates a user with given info
  const createUser = async (first_name, last_name, email, pic_url, address_1, address_2, city, state, zip, phone) => {
    return repo.createUser(first_name, last_name, email, pic_url, address_1, address_2, city, state, zip, phone);
  };

  const getUser = async (id) => {
    return await repo.getUser(id);
  };

  return {
    createUser,
    getUser,
  };
};

module.exports = {
  UserModel,
};
