const express = require('express');
const UserController = (userModel) => {
  const router = express.Router();

  // The API path to create a new user. Creates a user object and returns that object
  router.post('/signup', async (req, res) => {
    if (!req.body) return res.status(400).json({
      "message": "Malformed Request",
    });
    body = req.body

    const first_name = body['first_name']
    const last_name = body['last_name']
    const email = body['email']
    const pic_url = body['pic_url']
    const address_1 = body['address_1']
    const address_2 = body['address_2']
    const city = body['city']
    const state = body['state']
    const zip = body['zip']
    const phone = body['phone']
    
    const [user, err] = await userModel.createUser(
      first_name,
      last_name,
      email,
      pic_url,
      address_1, 
      address_2,
      city,
      state,
      zip, 
      phone,
    );

    if (err) {
      return res.status(400).json({
        data: null,
        message: err.message,
      });
    }
    return res.status(200).json({
      data: user,
      message: '',
    });
  });

  return router;

}
  
module.exports = {
  UserController,
};

