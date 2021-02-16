const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp();

exports.get_user = functions.https.onCall(async (data, response) => {
    const db = admin.firestore();
    const uid = data.id;
    const ref = db.collection("users").doc(uid);
    const doc = await ref.get();
    if (!doc.exists) {
        console.log("No such doc");
        return "No such doc";
    } else {
        console.log("Document data: ", doc.data);
        console.log(doc.data);
        return doc.data;
    }
});
