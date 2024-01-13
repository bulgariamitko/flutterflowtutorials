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