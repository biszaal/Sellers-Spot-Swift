const functions = require('firebase-functions');
const admin = require('firebase-admin');
//const { event } = require('firebase-functions/lib/providers/analytics');
admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// exports.sendNotificationToTopic = functions.firestore.document('messages/{uid}').onWrite(async (event) => {
//     // let docId = event.after.id;
//     let title = event.data.data().chatId;
//     let content = event.data.data().recentMessage;
//     var message = {
//         notification: {
//             title: 'Hello',
//             message: content
//         },
//         topic: 'namelesscoder',
//     };

//     let response = await admin.messaging().send(message);
//     console.log(response);
// })
// ;

exports.sendMessage = functions.database.document('messages/{chatId}').onCreate(event =>
    {
        const docId = event.params.chatId;

        const name = event.data.data().userOne;
        const productRef = admin.firestore().Collection('messages').doc(docId)

        return productRef.update({ message: '${name} I love it'})
    });
