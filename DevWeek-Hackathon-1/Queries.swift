//
//  Queries.swift
//  DevWeek-Hackathon-1
//
//  Created by Nick Crews on 2/12/21.
//

import Foundation
import Firebase

class Query {
    
    let db = Firestore.firestore()
    let functions = Functions.functions()
    
    func write_user_data(id: String, data: [String: Any], completion: @escaping (_ result: String?, _ error: String?) -> Void) {
        db.collection("users").document(id).setData(data, merge: true) { (err) in
            err != nil ? completion(nil, "Error writing Data") : completion("posted data", nil)
        }
    }
    func get_user_data(device_id: String, completion: @escaping (_ result: User?, _ error: String?) -> Void) {
        db.collection("users").whereField("device_id", isEqualTo: device_id).addSnapshotListener({ (snapshot, err) in
            if err == nil && snapshot != nil && snapshot?.documents.count ?? 0 > 0 {
                let user = User(userID: snapshot!.documents[0].documentID, data: snapshot!.documents[0].data())
                completion(user, nil)
            } else {
                completion(nil, "Error getting Data")
            }
        })
    }
    func set_listner_user(userID: String, completion: @escaping (_ result: User?, _ lstnr: ListenerRegistration?, _ error: String?) -> Void) {
        var lst: ListenerRegistration?
        lst = db.collection("users").document(userID).addSnapshotListener { (snapshot, err) in
            if err == nil && snapshot != nil && snapshot?.data() != nil {
                let user = User(userID: userID, data: snapshot!.data()!)
                completion(user, lst, nil)
            } else {
                completion(nil, lst, "Error getting user data")
            }
        }
    }
    func delete_dna_user(userID: String, completion: @escaping (_ result: Any?, _ error: String?) -> Void) {
        functions.httpsCallable("delete_dna_user").call(["id": userID]) { (res, err) in
            completion(res?.data, err?.localizedDescription)
        }
    }
    
}
