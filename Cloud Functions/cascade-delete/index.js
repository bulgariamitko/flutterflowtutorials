// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=WG9_qYUJY1I
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

const functions = require('firebase-functions');
const admin = require('firebase-admin');
// To avoid deployment errors, do not call admin.initializeApp() in your code

exports.cleanupUserData = functions.firestore
    .document('users/{userId}')
    .onDelete(async (snap, context) => {
        const userId = context.params.userId;
        const db = admin.firestore();
        const userRef = db.collection('users').doc(userId);

        // Collections and their respective fields to check
        const references = {
            'support_tickets': 'userRef',
            'chats': ['user_a', 'user_b'],
            'chat_messages': 'user',
            'notifications': 'notification_for'
        };

        try {
            await admin.auth().deleteUser(userId);
            console.log('Successfully deleted user from Firebase Authentication');
        } catch (error) {
            console.error('Error deleting user from Firebase Authentication:', error);
        }

        // Handling deletion of list of documents
        const usersSnapshot = await db.collection('orders').where('users', 'array-contains', userRef).get();
        usersSnapshot.forEach(userDoc => {
            const userRef = userDoc.ref;
            // Remove the listing reference from the array
            userRef.update({
                listings: admin.firestore.FieldValue.arrayRemove(userRef)
            });
        });

        // Helper function to delete documents with the user reference
        const deleteDocs = async (collection, field) => {
            console.log('Checking collection:', collection, 'for field:', field);
            const querySnapshot = await db.collection(collection).where(field, '==', userRef).get();
            if (querySnapshot.empty) {
                console.log('No documents found in', collection, 'with', field, 'referencing user', userId);
            } else {
                querySnapshot.forEach(doc => {
                    console.log('Deleting document in', collection, 'with ID:', doc.id);
                    doc.ref.delete();
                });
            }
        };

        // Delete the 'fcm_tokens' sub-collection and its documents
        const fcmTokensQuerySnapshot = await userRef.collection('fcm_tokens').get();
        fcmTokensQuerySnapshot.forEach(tokenDoc => {
            console.log('Deleting document in fcm_tokens with ID:', tokenDoc.id);
            tokenDoc.ref.delete();
        });

        // Iterate over the collections and fields
        for (const [collection, field] of Object.entries(references)) {
            if (Array.isArray(field)) {
                // If the field is an array, iterate over each field in the array
                for (const f of field) {
                    await deleteDocs(collection, f);
                }
            } else {
                await deleteDocs(collection, field);
            }
        }
    });