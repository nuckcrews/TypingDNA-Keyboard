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
    
    func write_user_data(id: String, data: [String: Any], completion: @escaping (_ result: String?, _ error: String?) -> Void) {
            db.collection("users").document(id).setData(data, merge: true) { (err) in
                err != nil ? completion(nil, "Error writing Data") : completion("posted data", nil)
            }
    }
    
    func get_user_data(device_id: String, completion: @escaping (_ result: [String: Any]?, _ error: String?) -> Void) {
        db.collection("users").whereField("device_id", isEqualTo: device_id).addSnapshotListener({ (snapshot, err) in
            if err == nil && snapshot != nil && snapshot?.documents.count ?? 0 > 0 {
                completion(snapshot?.documents[0].data(), nil)
            } else {
                completion(nil, "Error getting Data")
            }
        })
            
            
    }
    
}
