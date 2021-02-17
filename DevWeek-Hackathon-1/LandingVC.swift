//
//  LandingVC.swift
//  DevWeek-Hackathon-1
//
//  Created by Nick Crews on 2/12/21.
//

import UIKit
import Firebase

class LandingVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var mainScroll: UIScrollView!
    @IBOutlet weak var preLogView: UIView!
    @IBOutlet weak var postLogView: UIView!
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var enrollTextField: UITextField!
    @IBOutlet weak var phraseLbl: UILabel!
    @IBOutlet weak var textCountLbl: UILabel!
    @IBOutlet weak var completedEnrollLbl: UILabel!
    
    let query = Query()
    var user: User?
    var user_lstnr: ListenerRegistration?
    let txtField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtField.delegate = self
        self.view.addSubview(txtField)
        txtField.alpha = 0
        
        mainScroll.delegate = self
        enrollTextField.delegate = self
        enrollTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        self.preLogView.alpha = 0
        self.postLogView.alpha = 0
        self.resetView.alpha = 0
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        get_user(device_id: device_id)
        
    }

    func get_user(device_id: String) {
        query.get_user_data(device_id: device_id) { (res, err) in
            if err != nil || res == nil {
                UIView.animate(withDuration: 0.4) {
                    self.preLogView.alpha = 1
                    self.postLogView.alpha = 0
                    self.resetView.alpha = 0
                }
                self.txtField.becomeFirstResponder()
            } else {
                self.user = res
                self.listen_for_user(userID: res!.id)
            }
        }
    }
    func listen_for_user(userID: String) {
        user_lstnr?.remove()
        query.set_listner_user(userID: userID) { (res, lst, err) in
            if err != nil || res == nil {
                UIView.animate(withDuration: 0.4) {
                    self.preLogView.alpha = 1
                    self.postLogView.alpha = 0
                    self.resetView.alpha = 0
                }
                self.txtField.becomeFirstResponder()
            } else {
                self.user = res
                self.user_lstnr = lst
                self.completedEnrollLbl.text = "\(self.user!.enrollments ?? 0) of 3 complete"
                if self.user!.enrollments < 3 {
                    UIView.animate(withDuration: 0.4) {
                        self.preLogView.alpha = 0
                        self.postLogView.alpha = 1
                        self.resetView.alpha = 0
                    }
                    self.enrollTextField.text = ""
                    self.enrollTextField.becomeFirstResponder()
                } else {
                    UIView.animate(withDuration: 0.4) {
                        self.preLogView.alpha = 0
                        self.postLogView.alpha = 0
                        self.resetView.alpha = 1
                    }
                }
            }
        }
    }
    
    @IBAction func tapSettings(_ sender: UIButton) {
        sender.pulsate()
        UIApplication.shared.open(URL(string: "App-prefs:General&path=Keyboard")!)
    }
    @IBAction func tapReset(_ sender: UIButton) {
        if user == nil { return }
        let ref = Firestore.firestore().collection("users").document(user!.id)
        ref.setData(["enrollments": 0], merge: true)
        
        query.delete_dna_user(userID: user!.id) { (res, err) in
            print(err ?? "")
            print(res ?? "")
        }
    }
    
}
extension LandingVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let perc = Double(textField.text!.count) / Double(phraseLbl.text!.count)
        textCountLbl.text = "\(Int(perc * 100))%"
    }
    
}
