const functions = require('firebase-functions');
const admin = require('firebase-admin');
//const { event } = require('firebase-functions/lib/providers/analytics');
admin.initializeApp(functions.config().firebase);

exports.sendNotificationToTopic = functions.firestore.document('data/messages/{chatId}').onWrite(async (event) => {
    // let docId = event.after.id;
    let title = event.data.data().chatId;
    let content = event.data.data().recentMessage;
    var message = {
        notification: {
            title: 'Hello',
            message: 'Good'
        },
        topic: 'namelesscoder',
    };

    let response = await admin.messaging().send(message);
    console.log(response);
})
;