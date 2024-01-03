const functions = require('firebase-functions');
const admin = require('firebase-admin');
const fetch = require('node-fetch');

// This function is triggered by a webhook with a POST request
exports.newMsgTrigger = functions.https.onRequest(async (request, response) => {
    // Extract details from the request payload
    const payload = request.body;
    const locationId = payload.locationId;

    // Find the company based on the locationId
    const companyDoc = await findCompanyByLocationId(locationId);
    const accesstoken = companyDoc.accesstoken;

    // Define endpoint and headers for the new request
    const endpoint = "https://services.leadconnectorhq.com/conversations/search";
    const headers = {
        'Authorization': `Bearer ${accesstoken}`,
        'Accept': 'application/json',
        'Version': '2021-04-15'
    };

    // Make a GET request to the endpoint
    const queryParams = { locationId: locationId };
    const conversationDetails = await makeGetRequest(endpoint, queryParams, headers);

    // Parse the response to get conversation details
    const conversation = conversationDetails.conversations[0];

    // Prepare the new document data
    const newDocumentData = {
        conversationID: conversation.id,
        company: locationId,
        prospect: conversation.fullName,
        companyref: companyDoc.ref, // Find the company ref in the database
        sentfrom: await findBotRefByCompany(companyDoc), // Find the bot reference in the database
        sentto: conversation.contactId,
        lastmessage: conversation.lastMessageBody,
        lastsent: new Date(conversation.lastMessageDate)
    };

    // Create a new document in the sub-collection 'conversations'
    await createDocumentInConversationsSubCollection(newDocumentData);

    // Send a response back to the webhook initiator
    response.send({ status: 'success', data: newDocumentData });
});

// Helper function to find company by locationId
async function findCompanyByLocationId(locationId) {
    const db = admin.firestore();
    const companyCollection = db.collection('company');

    const snapshot = await companyCollection.where('locationID', '==', locationId).limit(1).get();
    if (snapshot.empty) {
        console.log('No matching company found.');
        throw new Error('No matching company found.');
    }

    // Assuming there is only one company with the locationId
    const companyDoc = snapshot.docs[0];
    return {
        accesstoken: companyDoc.data().accesstoken,
        ref: companyDoc.ref.path // Firestore path to the document
    };
}

// Helper function to make a GET request
async function makeGetRequest(endpoint, queryParams, headers) {
    // Construct query string from queryParams object
    const queryString = new URLSearchParams(queryParams).toString();
    const urlWithParams = `${endpoint}?${queryString}`;

    try {
        const fetch = await import('node-fetch');
        const response = await fetch.default(urlWithParams, { method: 'GET', headers: headers });
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return await response.json();
    } catch (error) {
        console.error("Error making GET request:", error);
        throw error;
    }
}

// Helper function to create a document in 'conversations' sub-collection
async function createDocumentInConversationsSubCollection(documentData) {
    const db = admin.firestore();
    // const companyRef = db.collection('company').doc(documentData.company);
    // const conversationsRef = companyRef.collection('conversations');
    const conversationsRef = documentData.sentfrom.collection('conversations');

    try {
        // Add a new document with a generated id.
        const newDocRef = await conversationsRef.add(documentData);
        console.log(`New document created with ID: ${newDocRef.id}`);
    } catch (error) {
        console.error('Error creating document in conversations sub-collection:', error);
        throw error; // Rethrow the error to be caught by the caller
    }
}

// Helper function to find bot reference by company
async function findBotRefByCompany(companyRef) {
    const db = admin.firestore();
    const aibotCollection = db.collection('aibot');
    const companyRefDocument = db.doc(companyRef.ref);


    console.log("Searching for bot with companyRef:", companyRef.ref);

    try {
        const snapshot = await aibotCollection.where('companyref', '==', companyRefDocument).limit(1).get();
        if (snapshot.empty) {
            throw new Error('No matching bot found for the given company reference.');
        }

        // Assuming there is only one bot document per company
        return snapshot.docs[0].ref;
    } catch (error) {
        console.error("Error finding bot by company reference:", error);
        throw error; // Rethrow the error to be handled by the caller
    }
}