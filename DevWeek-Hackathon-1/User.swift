//
//  User.swift
//  DevWeek-Hackathon-1
//
//  Created by Nick Crews on 2/17/21.
//

import Foundation
import Firebase


class User {

    private var _id: String!
    private var _last_use: String!
    private var _in_use: Bool!
    private var _device_id: String!
    private var _enrollments: Int!
    public var ref: DocumentReference!

    var id: String! {
        return _id
    }
    var last_use: String! {
        return _last_use
    }
    var in_use: Bool! {
        return _in_use
    }
    var device_id: String! {
        return _device_id
    }
    var enrollments: Int! {
        return _enrollments
    }

    init(userID: String, data: [String: Any]) {
        _id = userID
        if let last_use = data["last_use"] as? String {
            _last_use = last_use
        }
        if let in_use = data["in_use"] as? Bool {
            _in_use = in_use
        }
        if let device_id = data["device_id"] as? String {
            _device_id = device_id
        }
        if let enrollments = data["enrollments"] as? Int {
            _enrollments = enrollments
        }
        ref = Firestore.firestore().collection("users").document(userID)
    }

}
