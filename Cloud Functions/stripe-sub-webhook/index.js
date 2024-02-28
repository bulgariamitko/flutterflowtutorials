// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=kraILQ25At8
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const stripe = require('stripe')('YOUR_KEY');

const app = express();
const db = admin.firestore();

exports.stripeSubscriptions = functions.https.onRequest(async (req, res) => {
    // Stripe webhook secret
    const sig = req.headers['stripe-signature'];
    const endpointSecret = "YOUR_KEY";

    let event;

    try {
        event = stripe.webhooks.constructEvent(req.rawBody.toString('utf8'), sig, endpointSecret);
    } catch (err) {
        functions.logger.log(":warning: Webhook signature verification failed.", err);
        return res.status(400).send(`Webhook Error: ${err.message}`);
    }

    try {
        const subscription = event.data.object;
        // Retrieve the customer ID from the subscription event
        const customerId = subscription.customer;

        // Fetch the customer object from Stripe to get the email
        const customer = await stripe.customers.retrieve(customerId);
        const userEmail = customer.email;

        switch (event.type) {
            case 'customer.subscription.created':
                // const customer = event.data.object;
                // // Ensure userEmail is not undefined
                // const userEmail = customer.email;
                if (userEmail) {
                    const usersRef = db.collection('users');
                    const snapshot = await usersRef.where('email', '==', userEmail).get();
                    if (snapshot.empty) {
                        await usersRef.add({ email: userEmail, active_sub: true });
                    } else {
                        snapshot.forEach(doc => {
                            usersRef.doc(doc.id).update({ active_sub: true });
                        });
                    }
                } else {
                    functions.logger.log("Email is undefined for customer.subscription.created event");
                }
                break;
            case 'customer.subscription.deleted':
                // const deletedCustomer = event.data.object;
                // const deletedUserEmail = deletedCustomer.email;
                if (userEmail) {
                    const deletedUsersRef = db.collection('users');
                    const deletedSnapshot = await deletedUsersRef.where('email', '==', userEmail).get();
                    if (!deletedSnapshot.empty) {
                        deletedSnapshot.forEach(doc => {
                            deletedUsersRef.doc(doc.id).update({ active_sub: false });
                        });
                    }
                } else {
                    functions.logger.log("Email is undefined for customer.subscription.deleted event");
                }
                break;
            default:
                console.log(`Unhandled event type ${event.type}`);
        }

        return res.send({ received: true });
    } catch (error) {
        functions.logger.error("Error in handling event", error);
        reportError(error); // Replace with your error reporting function
        return res.status(500).send("Internal Server Error");
    }
});