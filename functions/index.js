const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.pushMsgNotification =
functions.firestore.document("lists/{document}")
    .onUpdate((snapshot, context) => {
      const snapshotData = snapshot.after.data();
      const listName = snapshotData.list_name;
      const username = snapshotData.last_message_userName;
      const lastMessage = snapshotData.last_message;
      const topic = snapshot.after.id;
      // const parentDocData = snapshot.ref.parent.parent.get();
      // const listName = parentDocData.data().list_name;
      // const senderUserName = parentDocData.data().last_message_userName;
      console.log(topic);
      return admin.messaging().sendToTopic(topic, {
        notification: {
          title: listName,
          body: (username + ": " + lastMessage),
        },
        data: {
          listId: topic,
        },
      });
    });
