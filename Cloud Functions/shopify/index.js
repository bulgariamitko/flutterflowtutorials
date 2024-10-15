const functions = require('firebase-functions');
const admin = require('firebase-admin');

const db = admin.firestore();

exports.handleShopifyWebhook = functions.https.onRequest(async (req, res) => {
    if (req.method !== 'POST') {
        return res.status(405).send('Method Not Allowed');
    }

    const payload = req.body;

    // Log the entire payload
    console.log('Received payload:', JSON.stringify(payload, null, 2));

    try {
        let orderId;
        if (payload.line_items && payload.line_items.length > 0) {
            // This might be the actual structure Shopify uses
            orderId = payload.id;
            await processOrder(orderId, payload);
        } else if (payload.shopifyOrderLineItem) {
            orderId = payload.shopifyOrderLineItem.order._link;
            await processOrderLineItem(orderId, payload);
        } else if (payload.shopifyOrder) {
            orderId = payload.id;
            await processOrder(orderId, payload);
        } else {
            console.error('Unknown payload type');
            console.error('Payload structure:', Object.keys(payload));
            return res.status(400).send('Invalid payload');
        }

        return res.status(200).send('Webhook processed successfully');
    } catch (error) {
        console.error('Error processing webhook:', error);
        return res.status(500).send('Internal Server Error');
    }
});

async function processOrderLineItem(orderId, payload) {
    const purchaseRef = db.collection('purchases').doc(orderId);
    const doc = await purchaseRef.get();

    const albumId = payload.shopifyOrderLineItem.sku || 'unknown-sku';
    const albumRef = db.collection('album').doc(albumId);
    const purchaseDate = admin.firestore.Timestamp.fromDate(new Date(payload.shopifyOrderLineItem.shopifyUpdatedAt));
    const total = parseFloat(payload.shopifyOrderLineItem.price) || 0;

    console.log('Processing order line item:', { orderId, albumId, purchaseDate, total });

    const albumDoc = await albumRef.get();
    if (!albumDoc.exists) {
        throw new Error(`No matching album found for id: ${albumId}`);
    }

    const albumData = albumDoc.data();
    const sellerRef = albumData.createdby;
    if (!sellerRef) {
        throw new Error(`No seller reference found for album: ${albumId}`);
    }

    const purchaseData = {
        shopify_id: orderId,
        album_ref: albumRef,
        purchase_date: purchaseDate,
        purchase_type: "album",
        seller_ref: sellerRef,
        total: total,
        stripe_checkout_session_id: "bought using shopify",
    };

    if (doc.exists) {
        const updateData = {};
        for (const [key, value] of Object.entries(purchaseData)) {
            if (value !== null && value !== undefined && value !== '') {
                updateData[key] = value;
            }
        }
        await purchaseRef.update(updateData);
        console.log(`Updated existing purchase document: ${orderId}`);
    } else {
        await purchaseRef.set(purchaseData);
        console.log(`Created new purchase document: ${orderId}`);
    }
}

async function processOrder(orderId, payload) {
    const purchaseRef = db.collection('purchases').doc(orderId);
    const doc = await purchaseRef.get();

    const email = payload.shopifyOrder.email || null;
    const purchaseDate = admin.firestore.Timestamp.fromDate(new Date(payload.shopifyOrder.shopifyCreatedAt));

    console.log('Processing order:', { orderId, email, purchaseDate });

    let buyerRef = null;
    if (email) {
        const usersRef = db.collection('users');
        const userSnapshot = await usersRef.where('email', '==', email).get();

        if (!userSnapshot.empty) {
            buyerRef = userSnapshot.docs[0].ref;
        } else {
            console.log('No matching user found for email:', email);
        }
    }

    const orderData = {
        shopify_id: orderId,
        purchase_date: purchaseDate,
        stripe_payment_completed: true,
    };

    if (buyerRef) orderData.buyer_ref = buyerRef;
    if (email) orderData.email = email;

    if (doc.exists) {
        const updateData = {};
        for (const [key, value] of Object.entries(orderData)) {
            if (value !== null && value !== undefined && value !== '') {
                updateData[key] = value;
            }
        }
        await purchaseRef.update(updateData);
        console.log(`Updated existing purchase document: ${orderId}`);
    } else {
        await purchaseRef.set(orderData);
        console.log(`Created new purchase document: ${orderId}`);
    }
}