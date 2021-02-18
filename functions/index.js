const functions = require("firebase-functions");
const config = require("./config.js");
const https = require("https");
const querystring = require("querystring");
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

exports.post_typing_pattern = functions.https.onCall(async (info, context) => {
    const tp = info.typingPattern;
    let result = 1;
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
            "Cache-Control": "no-cache",
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
            const rs = JSON.parse(responseData);
            result = rs.result;
            console.log(JSON.parse(responseData));
        });
    });
    req.on("error", function(e) {
        console.error(e);
     });
     req.write(
        querystring.stringify(data)
     );
     req.end();
     await new Promise((resolve, reject) => setTimeout(resolve, 4000));
     return result;
});


exports.delete_dna_user = functions.https.onCall(async (info, context) => {
    const id = info.id;
    const options = {
        hostname: config.DNA_BASE_URL,
        port: 443,
        path: "/user/" + id,
        method: "DELETE",
        headers: {
            "Cache-Control": "no-cache",
            "Authorization": "Basic " +
            new Buffer
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
            console.log(JSON.parse(responseData));
        });
    });
    req.on("error", function(e) {
        console.error(e);
    });
    req.end();
    return "Deleted User";
});

exports.get_user_enrollment = functions.https.onCall(async (info, context) => {
    const id = info.id;
    const options = {
        hostname: config.DNA_BASE_URL,
        port: 443,
        path: "/user/" + id,
        method: "GET",
        headers: {
            "Cache-Control": "no-cache",
            "Authorization": "Basic " +
            new Buffer
            .from(config.DNA_API_KEY + ":" + config.DNA_API_SECRET)
            .toString("base64"),
        },
    };
    const r = await returnEnrollments(options);
    return r;
});

async function returnEnrollments(options) {
    let responseData = "";
    let mobileCount = 0;
    const req = https.request(options, function(res) {
        res.on("data", function(chunk) {
            responseData += chunk;
        });
        res.on("end", function() {
            const js = JSON.parse(responseData);
            mobileCount = js.mobilecount;
            return mobileCount;
        });
    });
    req.on("error", function(e) {
        console.error(e);
    });
    req.end();
    await new Promise((resolve, reject) => setTimeout(resolve, 3000));
    return mobileCount;
}

exports.post_dna_enrollments = functions.https.onCall(async (data, context) => {
    const uid = data.id;
    const ref = db.collection("users").doc(uid);
    const res = await ref.set(data.data, {merge: true});
    return res;
});
