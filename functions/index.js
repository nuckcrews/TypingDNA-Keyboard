const functions = require("firebase-functions");
const config = require("./config.js");

const admin = require("firebase-admin");
admin.initializeApp();

const https = require("https");
const querystring = require("querystring");

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

exports.post_typing_pattern = functions.https.onCall(async (info, context) => {
    const tp = info.typingPattern;
    const data = {
        tp: tp,
    };
    const options = {
        hostname: config.DNA_BASE_URL,
        port: 443,
        path: "/auto/" + info.id,
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Cache-Control'": "no-cache",
            "Authorization":
                "Basic " + new Buffer
                .from(config.DNA_API_KEY + ":" + config.DNA_API_SECRET)
                .toString("base64"),
        },
    };
    let responseData = "";
    const req = https.request(options, function(res) {
        res.on("data", function(chunk) {
            responseData += chunk;
        });
        res.on("end", function() {
            const responseRes = JSON.parse(responseData);
            const ref = db.collection("users").doc(info.id);
            ref.set({enrollments: responseRes.enrollment}, {merge: true});
            console.log(responseRes);
        });
    });
    req.on("error", function(e) {
        console.error(e);
     });
     req.write(
        querystring.stringify(data)
     );
     req.end();

     return "End of function";
});

exports.get_user_enrollment = functions.https.onCall(async (data, context) => {

});
