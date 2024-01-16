const functions = require('firebase-functions');
const admin = require('firebase-admin');
// To avoid deployment errors, do not call admin.initializeApp() in your code
const cors = require('cors')({ origin: true });

exports.delUserFromCF = functions.https.onRequest((data, res) => {
    cors(data, res, async () => {
        const userId = data.body.data.userToDel;
        const authUserId = data.body.data.authUser;
        const db = admin.firestore();
        const userRef = db.collection('users').doc(userId);
        const authUserRef = db.collection('users').doc(authUserId);

        try {
            // Check if the auth user is an admin
            const authUserDoc = await authUserRef.get();
            if (authUserDoc.exists && authUserDoc.data().permission === 'admin') {
                // Proceed with deletion if user is an admin
                await userRef.delete();
                console.log('Deleted user document from Firestore');
                res.status(200).send('User deleted successfully');
            } else {
                // If not an admin, return an error response
                console.error('Unauthorized attempt to delete user');
                res.status(403).send('Unauthorized: Only admins can delete users');
            }
        } catch (error) {
            console.error('Error in user deletion process:', error);
            res.status(500).send('Error during user deletion process');
        }
    });
});