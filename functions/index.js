const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

exports.get_user = functions.https.onCall(async (data, context) => {
    const uid = data.id;
    const ref = db.collection("users").doc(uid);
    const doc = await ref.get();
    if (!doc.exists) {
        console.log("No such doc");
        return "No such doc";
    } else {
        console.log("Document data: ", doc.data());
        return doc.data();
    }
});

exports.post_user = functions.https.onCall(async (data, context) => {
    const uid = data.id;
    const ref = db.collection("users").doc(uid);
    const res = await ref.set(data.data, {merge: true});
    return res;
});
