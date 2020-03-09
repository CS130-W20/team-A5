const express = require('express');
const {FundsController} = require('./funds.js')

const UserController = (userModel, authService) => {
  const router = express.Router();
  const fundsController = FundsController(userModel, authService);

  // The API path to create a new user. Creates a user object and returns that object
  router.post('/signup', async (req, res) => {
    if (!req.body) return res.status(400).json({
      "message": "Malformed Request",
    });
    body = req.body

    const first_name = body['first_name']
    const last_name = body['last_name']
    const email = body['email']
    const password = body['password']
    const pic_url = body['pic_url']
    const address_1 = body['address_1']
    const address_2 = body['address_2']
    const city = body['city']
    const state = body['state']
    const zip = body['zip']
    const phone = body['phone']

    // Give user a default pic_url if they don't upload one
    
    if (pic_url == null || pic_url == "") {
      pic_url = "profile"
    }

    // TEMP Creation of token for user to simulate authentication
    const token = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
    
    const [user, err] = await userModel.createUser(
      first_name,
      last_name,
      email,
      password,
      pic_url,
      address_1, 
      address_2,
      city,
      state,
      zip, 
      phone,
      token,
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

  router.post('/login', async (req, res) => {
    
    if (!req.body) return res.status(400).json({
      "message": "Malformed Request",
    });
    body = req.body

    const email = body['email']
    const password = body['password']

    const [user, err] = await userModel.verifyPasswordAndReturnUser(email, password)

    if (err) {
      return res.status(400).json({
        data: null,
        message: err,
      });
    }
    return res.status(200).json({
      data: user,
      message: '',
    });

  })

  // Gets the logged in user using the authentication token passed in the request header
  router.get('/me', async (req, res) => {
  
    // Get the user_id of the user sending the request
    const [user_info, err] = await authService.getLoggedInUserInfo(req.headers);

    if (err) {
      return res.status(400).json({
        data: null,
        message: err
      });
    }

    return res.status(200).json({
      data: user_info,
      message: ""
    });
  });

  // Gets the user info for the user with id specified
  // If this is not the logged in user, we show an abbreviated profile of 
  // first name, last name, and profile picture
  router.get('/:id', async (req, res) => {
    const params = req.params;
    const id = parseInt(params.id, 10);
  
    // Get the user_id of the user sending the request, to check if the ids match
    const [user_info, err1] = await authService.getLoggedInUserInfo(req.headers);

    if (err1) {
      return res.status(400).json({
        data: null,
        message: err1
      });
    }

    if (user_info['id'] == id) {
      return res.status(200).json({
        data: user_info,
        message: ""
      });
    }

    // Since we are accessing a user who is not the logged in user, show an abbreviated profile
    const [user, err2] = await userModel.getOtherUserInfo(id);
    if (err2) {
      return res.status(400).json({
        data: null,
        message: err.message
      });
    }

    return res.status(200).json({
      data: user,
      message: ""
    });
  });

  router.use('/funds', fundsController);

  return router;

}
  
module.exports = {
  UserController,
};

