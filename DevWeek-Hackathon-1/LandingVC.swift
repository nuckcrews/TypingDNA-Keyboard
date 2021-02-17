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
    
    let query = Query()
    
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
        query.get_user_data(device_id: device_id) { (res, err) in
            if err != nil {
                print(err)
                UIView.animate(withDuration: 0.4) {
                    self.preLogView.alpha = 1
                    self.postLogView.alpha = 0
                }
                self.txtField.becomeFirstResponder()
            } else {
                print(res)
                UIView.animate(withDuration: 0.4) {
                    self.preLogView.alpha = 0
                    self.postLogView.alpha = 1
                }
                self.enrollTextField.becomeFirstResponder()
            }
        }
        print("Device ID:", UIDevice.current.identifierForVendor!.uuidString)
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
    }
    
    @IBAction func tapSettings(_ sender: UIButton) {
        sender.pulsate()
        
        UIApplication.shared.open(URL(string: "App-prefs:General&path=Keyboard")!)
        
    }

}
extension LandingVC: UITextFieldDelegate {

    @objc func textFieldDidChange(_ textField: UITextField) {
        let perc = Double(textField.text!.count) / Double(phraseLbl.text!.count)
        textCountLbl.text = "\(Int(perc * 100))%"
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
    }
}
