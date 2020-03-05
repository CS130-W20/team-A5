const express = require('express');
const stripe = require('stripe')('sk_test_5gplp1sIKFhQt744225EGwEI00jdqzWfG0');

const FundsController = (userModel, authService) => {
  const router = express.Router();

  router.post('/start', async (req, res) => {
    if (!req.body) return res.status(400).json({
      "message": "Malformed Request",
    });
    body = req.body

    // Get the user_id of the user sending the request
    const [user_info, err] = await authService.getLoggedInUserInfo(req.headers);

    // Make sure this is a valid user
    if (err) {
      return res.status(400).json({
        data: null,
        message: err
      });
    }
    
    const paymentIntent = await stripe.paymentIntents.create({
      amount: body.amount,
      currency: 'usd',
    });
    const clientSecret = paymentIntent.client_secret
  
    return res.status(200).json({
      data: {
        client_secret: clientSecret
      },
      message: ""
    })
  });

  router.post('/complete', async (req, res) => {
    if (!req.body) return res.status(400).json({
      "message": "Malformed Request",
    });
    body = req.body

    // Get the user_id of the user sending the request
    const [user_info, err] = await authService.getLoggedInUserInfo(req.headers);

    // Make sure this is a valid user
    if (err) {
      return res.status(400).json({
        data: null,
        message: err
      });
    }

    const paymentID = body.payment_id;

    const paymentIntent = await stripe.paymentIntents.retrieve(paymentID);

    if (paymentIntent && paymentIntent.status === 'succeeded') {
      const centsAmount = paymentIntent.amount

      const amount = centsAmount * 1.0 / 100;

      [user, err1] = await userModel.addUserFunds(user_info.id, amount)

      if (err1) {
        return res.status(400).json({
          data: null,
          message: err1
        });
      }

      return res.status(200).json({
        data: user,
        message: ""
      })
    } else {
      return res.status(400).json({
          data: null,
          message: "Payment not completed"
      });
    } 
  });

  return router;

}
  
module.exports = {
  FundsController,
};

