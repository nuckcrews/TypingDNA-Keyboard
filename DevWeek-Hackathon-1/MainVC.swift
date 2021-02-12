//
//  ViewController.swift
//  DevWeek-Hackathon-1
//
//  Created by Nick Crews on 2/9/21.
//

import UIKit


class MainVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textCountLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    var tdna = TypingDNARecorderMobile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitBtn.layer.cornerRadius = 12
        
        textField.delegate = self
        
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        

    }


}
extension MainVC {
    
    // Get type 1 pattern. Recommended on mobile, for sensitive fixed texts (passwords/pins).
    @IBAction func type1Btn(_ sender: UIButton) {
        //let str = textField.text!; let typingPattern = TypingDNARecorderMobile.getTypingPattern(1, 0, str, 0);
        let typingPattern = TypingDNARecorderMobile.getTypingPattern(1, 0, "", 0, textField)
        print("Type 1: ", typingPattern)
    }
    
    // Get type 2 pattern. Recommended on mobile, for non-sensitive fixed texts.
    @IBAction func type2Btn(_ sender: UIButton) {
        let typingPattern = TypingDNARecorderMobile.getTypingPattern(2, 0, "", 0, textField)
        print("Type 2: ", typingPattern)
    }
    
    // Get type 0 pattern (anytext pattern). NOT recommended on mobile version because it needs 120+ chars to work well.
    @IBAction func type0Btn(_ sender: UIButton) {
        let typingPattern = TypingDNARecorderMobile.getTypingPattern(0, 0, "", 0)
        print("Type 0: ",typingPattern)
    }
    
    @IBAction func resetBtn(_ sender: UIButton) {
        textField.text = ""
        textCountLbl.text = "0"
        TypingDNARecorderMobile.reset(true)
    }
    
}
extension MainVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        textCountLbl.text = "\(textField.text!.count)"
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
