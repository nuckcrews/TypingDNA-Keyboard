//
//  Queries.swift
//  Keyboard
//
//  Created by Nick Crews on 2/12/21.
//

import Foundation
import Firebase

class Query {
    
    let db = Firestore.firestore()
    let functions = Functions.functions()
    
    func write_user_data(id: String, data: [String: Any], completion: @escaping (_ result: String?, _ error: String?) -> Void) {
        print("writing to user \(id)")
        db.collection("users").document(id).setData(data, merge: true) { (err) in
            print("completed writing to user \(id)")
            err != nil ? completion(nil, "Error getting Data") : completion("posted data", nil)
        }
    }
    
    func get_user_data(id: String, completion: @escaping (_ result: [String: Any]?, _ error: String?) -> Void) {
        db.collection("users").document(id).addSnapshotListener { (snapshot, err) in
            if err != nil && snapshot != nil && snapshot?.data() != nil {
                completion(snapshot?.data(), nil)
            } else {
                completion(nil, "Error getting Data")
            }
        }
    }
    
    func get_user(id: String, completion: @escaping (_ result: [String: Any]?, _ error: String?) -> Void) {
        functions.httpsCallable("get_user").call(["id": id]) { (res, err) in
            if let err = err {
                completion(nil, err.localizedDescription)
            } else {
                print(res?.data)
                if let result = res?.data as? [String: Any] {
                    completion(result, nil)
                } else {
                    completion(nil, "result in wrong format")
                }
                
            }
        }
    }
    
}
