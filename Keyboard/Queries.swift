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
        functions.httpsCallable("post_user").call(["id": id, "data": data]) { (res, err) in
            if let err = err {
                completion(nil, err.localizedDescription)
            } else {
                completion("Successfully posted data", nil)
            }
        }
    }
    func get_user_data(id: String, completion: @escaping (_ result: [String: Any]?, _ error: String?) -> Void) {
        functions.httpsCallable("get_user").call(["id": id]) { (res, err) in
            if let err = err {
                completion(nil, err.localizedDescription)
            } else {
                if let result = res?.data as? [String: Any] {
                    completion(result, nil)
                } else {
                    completion(nil, "result in wrong format")
                }
            }
        }
    }
    func post_typing_pattern(id: String, tp: String, completion: @escaping (_ result: Any?, _ error: String?) -> Void) {
        functions.httpsCallable("post_typing_pattern").call(["id": id, "typingPattern": tp]) { (res, err) in
            completion(res?.data, err?.localizedDescription)
        }
    }
    func get_dna_enrollments(userID: String, completion: @escaping (_ result: Int?, _ error: String?) -> Void) {
        functions.httpsCallable("get_user_enrollment").call(["id": userID]) { (res, err) in
            completion(res?.data as? Int, err?.localizedDescription)
        }
    }
    func post_dna_enrollments(id: String, enrs: Int, completion: @escaping (_ result: Any?, _ error: String?) -> Void) {
        functions.httpsCallable("post_dna_enrollments").call(["id": id, "data": ["enrollments": enrs]]) { (res, err) in
            completion(res?.data, err?.localizedDescription)
        }
    }
    
    
}
