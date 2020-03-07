const express = require('express');
const stripe = require('stripe')(process.env.STRIPE_API_KEY);

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
    
    // Create a payment object with this info
    let payment_id = paymentIntent.id
    let cents_amount = body.amount*1.0 

    let amount = cents_amount / 100

    let user_id = user_info.id


    const [payment_info, err1] = await userModel.createPayment(payment_id, amount, user_id)

    if (err1) {
      return res.status(400).json({
        data: null,
        message: err1.message
      });
    }
  
    return res.status(200).json({
      data: {
        client_secret: clientSecret
      },
      message: ""
    })
  });

  router.post('/complete', async (req, res) => {
    const stripe_signature = request.headers['stripe-signature'];
    let event;

    
    try {
      event = stripe.webhooks.constructEvent(req.body, stripe_signature, process.env.STRIPE_WEBHOOK_SIGNATURE);
    } catch (err) {
      return res.status(400).json({"err": `Webhook Error: ${err.message}`});
    }

    // Handle the event
    if (event.type == 'payment_intent.succeeded') {
      const paymentIntent = event.data.object;

      const payment_id = paymentIntent.id;
      
      const [payment_info, err1] = await userModel.getPaymentInfoByPaymentId(payment_id)

      if (err1 || payment_info == null) {
        return res.status(400).json({"err": "No payment found"});
      }

      // Check to make sure there can be no duplicate payment confirmations
      if (payment_info.completed) {
        return res.status(400).json({"err": "Payment has already been completed"});
      }

      // Payment matches up, so update a user's account, and mark the payment as completed
      let user_id = payment_info.user_id
      let amount = payment_info.amount

      const [updated_user_info, err2] = await userModel.addUserFundsAndSetPaymentCompleted(user_id, amount, payment_id);

      if (err2) {
        return res.status(400).json({"err": err1.message});
      }

      // If no errors, send back status 200, Stripe doesnt need any body
      return res.status(200).json({"message": "Success"})

      } else {
        return res.status(400).send("Invalid Event Type");
      } 
  });

  return router;

}
  
module.exports = {
  FundsController,
};

