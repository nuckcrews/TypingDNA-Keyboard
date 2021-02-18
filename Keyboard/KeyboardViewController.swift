//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Nick Crews on 2/9/21.
//

import UIKit
import Firebase
import MultiProgressView

class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet weak var capsLocksButton: UIButton!
    @IBOutlet weak var otherCharButton: UIButton!
    @IBOutlet weak var specialCharButton: UIButton!
    @IBOutlet weak var backSpaceBtn: UIButton!
    
    @IBOutlet weak var charView1: UIView!
    @IBOutlet weak var charView2: UIView!
    @IBOutlet weak var charView3: UIView!
    
    @IBOutlet weak var progressView: MultiProgressView!
    @IBOutlet weak var progressLbl: UILabel!
    
    var progressSection = ProgressViewSection()
    
    var topRow = UIView()
    var topRow2 = UIView()
    var topRow3 = UIView()
    var top2Row = UIView()
    var top2Row2 = UIView()
    var top2Row3 = UIView()
    var top3Row = UIView()
    var top3Row2 = UIView()
    var top3Row3 = UIView()
    
    var charSet1 = [["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"], ["A", "S", "D", "F", "G", "H", "J", "K", "L"], ["Z", "X", "C", "V", "B", "N", "M"]]
    var charSet2 = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"], ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""], [".", ",", "?", "!", "'"]]
    var charSet3 = [["[", "]", "{", "}", "#", "%", "^", "*", "+", "="], ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"], [".", ",", "?", "!", "'"]]
    
    var query: Query!
    var showSet = "ABC"
    var capsLockOn = "on"
    var capsChangeEnabled = true
    var hold_timer: Timer?
    var enrollments = 0
    var prev_emotion: emotion = .normal
    enum emotion {
        case normal
        case abnormal
    }
    struct emotion_color {
        var blue = UIColor(red: 0.66, green: 0.79, blue: 1.00, alpha: 1.00)
        var green = UIColor(red: 0.00, green: 0.57, blue: 0.58, alpha: 1.00)
        var red = UIColor(red: 1.00, green: 0.49, blue: 0.47, alpha: 1.00)
    }
    
    var tdna = TypingDNARecorderMobile()
    var textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        FirebaseApp.configure()
        
        query = Query()
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        TypingDNARecorderMobile.reset()
        manage_user()
        
        textField.becomeFirstResponder()
        
        view.subviews.forEach({ $0.removeFromSuperview() })
        
        // For designing in XIB
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        view = objects[0] as? UIView;
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(gesture:)))
        longPressGesture.minimumPressDuration = 0.5 // Minimum duration to trigger the action
        backSpaceBtn.addGestureRecognizer(longPressGesture)
        
        progressView.delegate = self
        progressView.dataSource = self
        
        progressView.setProgress(section: 0, to: 100.0) //animatable
        
        switch prev_emotion {
        case .normal:
            progressSection.backgroundColor = emotion_color().blue
        default:
            progressSection.backgroundColor = emotion_color().red
        }
        
        progressSection.layer.cornerRadius = 7
        
        layoutKeyRows()
        
        if capsLockOn  == "on" {
            capsLocksButton.backgroundColor = .white
            capsLocksButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        } else if capsLockOn == "off" {
            capsLocksButton.backgroundColor = UIColor(red: 0.74, green: 0.76, blue: 0.78, alpha: 1.00)
            capsLocksButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        } else {
            capsLocksButton.backgroundColor = .white
            capsLocksButton.setImage(UIImage(systemName: "arrow.up.to.line.alt"), for: .normal)
        }
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        
        TypingDNARecorderMobile.addTarget(textField)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
        
    }
    
    func manage_user() {
        guard let uid = Auth.auth().currentUser?.uid else {
            create_user()
            print("no user")
            return
        }
        let data: [String: Any] = [
            "last_use": Standard_Date(dt: Date()).string as Any,
            "in_use": true as Any,
            "device_id": UIDevice.current.identifierForVendor!.uuidString as Any
        ]
        query.write_user_data(id: uid, data: data) { (res, err) in
            err != nil ? print(err ?? "error posting data") : print(res ?? "success")
            self.query.get_dna_enrollments(userID: uid) { (enr, err) in
                if err == nil && enr != nil {
                    self.enrollments = enr!
                    self.progressView.setProgress(section: 0, to: 0)
                }
            }
        }
    }
    func create_user() {
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard let user = authResult?.user else {
                print("could not sign in user")
                return
            }
            let uid = user.uid
            let data: [String: Any] = [
                "last_use": Standard_Date(dt: Date()).string as Any,
                "in_use": true as Any,
                "device_id": UIDevice.current.identifierForVendor!.uuidString as Any,
                "enrollments": 0 as Any
            ]
            self.query.write_user_data(id: uid, data: data) { (res, err) in
                err != nil ? print(err ?? "error posting data") : print(res ?? "success")
                self.query.get_dna_enrollments(userID: uid) { (enr, err) in
                    if err == nil && enr != nil {
                        self.enrollments = enr!
                        print("Enrollments 1", self.enrollments)
                    }
                }
            }
        }
    }
    
    func layoutKeyRows() {
        charView1.alpha = 1
        charView2.alpha = 0
        charView3.alpha = 0
        
        // Set 1
        let bw = (Int(self.view.frame.width) - 6) / charSet1[0].count
        let buttons = createButtons(titles: charSet1[0])
        topRow = UIView(frame: CGRect(x: 3, y: 0, width: self.view.frame.width - 6, height: 44))
        
        for button in buttons {
            topRow.addSubview(button)
        }
        
        let w2 = bw * charSet1[1].count
        let buttons2 = createButtons(titles: charSet1[1])
        topRow2 = UIView(frame: CGRect(x: (Int(self.view.frame.width) - w2) / 2, y: 50, width: w2, height: 44))
        
        for button in buttons2 {
            topRow2.addSubview(button)
        }
        
        let w3 = bw * charSet1[2].count
        let buttons3 = createButtons(titles: charSet1[2])
        topRow3 = UIView(frame: CGRect(x: (Int(self.view.frame.width) - w3) / 2, y: 100, width: w3, height: 44))
        
        for button in buttons3 {
            topRow3.addSubview(button)
        }
        
        self.charView1.addSubview(topRow)
        self.charView1.addSubview(topRow2)
        self.charView1.addSubview(topRow3)
        
        addConstraints(buttons: buttons, containingView: topRow)
        addConstraints(buttons: buttons2, containingView: topRow2)
        addConstraints(buttons: buttons3, containingView: topRow3)
        
        // Set 2
        let bw2 = (Int(self.view.frame.width) - 6) / charSet2[0].count
        let buttonsSet2 = createButtons(titles: charSet2[0])
        top2Row = UIView(frame: CGRect(x: 3, y: 0, width: self.view.frame.width - 6, height: 44))
        
        for button in buttonsSet2 {
            top2Row.addSubview(button)
        }
        
        let w2set2 = bw2 * charSet2[1].count
        let buttons2Set2 = createButtons(titles: charSet2[1])
        top2Row2 = UIView(frame: CGRect(x: (Int(self.view.frame.width) - w2set2) / 2, y: 50, width: w2set2, height: 44))
        
        for button in buttons2Set2 {
            top2Row2.addSubview(button)
        }
        
        let w3set2 = bw * (charSet2[2].count + 2)
        let buttons3Set2 = createButtons(titles: charSet2[2])
        top2Row3 = UIView(frame: CGRect(x: (Int(self.view.frame.width) - w3set2) / 2, y: 100, width: w3set2, height: 44))
        
        for button in buttons3Set2 {
            top2Row3.addSubview(button)
        }
        
        self.charView2.addSubview(top2Row)
        self.charView2.addSubview(top2Row2)
        self.charView2.addSubview(top2Row3)
        
        addConstraints(buttons: buttonsSet2, containingView: top2Row)
        addConstraints(buttons: buttons2Set2, containingView: top2Row2)
        addConstraints(buttons: buttons3Set2, containingView: top2Row3)
        
        // Set 3
        let bw3 = (Int(self.view.frame.width) - 6) / charSet3[0].count
        let buttonsSet3 = createButtons(titles: charSet3[0])
        top3Row = UIView(frame: CGRect(x: 3, y: 0, width: self.view.frame.width - 6, height: 44))
        
        for button in buttonsSet3 {
            top3Row.addSubview(button)
        }
        
        let w2set3 = bw3 * charSet3[1].count
        let buttons2Set3 = createButtons(titles: charSet3[1])
        top3Row2 = UIView(frame: CGRect(x: (Int(self.view.frame.width) - w2set3) / 2, y: 50, width: w2set3, height: 44))
        
        for button in buttons2Set3 {
            top3Row2.addSubview(button)
        }
        
        let w3set3 = bw * (charSet3[2].count + 2)
        let buttons3Set3 = createButtons(titles: charSet3[2])
        top3Row3 = UIView(frame: CGRect(x: (Int(self.view.frame.width) - w3set3) / 2, y: 100, width: w3set3, height: 44))
        
        for button in buttons3Set3 {
            top3Row3.addSubview(button)
        }
        
        self.charView3.addSubview(top3Row)
        self.charView3.addSubview(top3Row2)
        self.charView3.addSubview(top3Row3)
        
        addConstraints(buttons: buttonsSet3, containingView: top3Row)
        addConstraints(buttons: buttons2Set3, containingView: top3Row2)
        addConstraints(buttons: buttons3Set3, containingView: top3Row3)
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        //        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    
    func animButton(button: UIButton) {
        UIView.animate(withDuration: 0.05, animations: {
            button.transform = CGAffineTransform(scaleX: 1.06, y: 1.06)
        }, completion: {(_) -> Void in
            button.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    @objc func keyPressed(sender: AnyObject?) {
        let button = sender as! UIButton
        let title = button.title(for: .normal)
        (textDocumentProxy as UIKeyInput).insertText(title!)
        textField.insertText(title!)
        checkCaps()
        animButton(button: button)
    }
    
    @IBAction func backSpacePressed(button: UIButton) {
        (textDocumentProxy as UIKeyInput).deleteBackward()
        textField.deleteBackward()
        animButton(button: button)
    }
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            print("Began")
            hold_timer?.invalidate()
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (time) in
                self.hold_timer?.invalidate()
                self.hold_timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.executeBackSpace), userInfo: nil, repeats: true)
            }
        } else if gesture.state == .ended {
            print("End")
            backSpaceBtn.isHighlighted = false
            hold_timer?.invalidate()
        }
    }
    @objc func executeBackSpace() {
        backSpaceBtn.isHighlighted = true
        (textDocumentProxy as UIKeyInput).deleteBackward()
        textField.deleteBackward()
    }
    @IBAction func spacePressed(button: UIButton) {
        (textDocumentProxy as UIKeyInput).insertText(" ")
        textField.insertText(" ")
        checkCaps()
        animButton(button: button)
    }
    @IBAction func returnPressed(button: UIButton) {
        (textDocumentProxy as UIKeyInput).insertText("\n")
        textField.insertText("\n")
        checkCaps()
        animButton(button: button)
    }
    @IBAction func tap123(button: UIButton) {
        if showSet == "ABC" {
            showSet = "123"
            charView1.alpha = 0
            charView2.alpha = 1
            charView3.alpha = 0
            specialCharButton.alpha = 1
            capsLocksButton.alpha = 0
            specialCharButton.setTitle("#+=", for: .normal)
            otherCharButton.setTitle("ABC", for: .normal)
        } else if showSet == "123" || showSet == "#+=" {
            showSet = "ABC"
            charView1.alpha = 1
            charView2.alpha = 0
            charView3.alpha = 0
            specialCharButton.alpha = 0
            capsLocksButton.alpha = 1
            specialCharButton.setTitle("#+=", for: .normal)
            otherCharButton.setTitle("123", for: .normal)
        }
        animButton(button: button)
    }
    @IBAction func tapSpecialChars(button: UIButton) {
        if showSet == "123" {
            showSet = "#+="
            charView1.alpha = 0
            charView2.alpha = 0
            charView3.alpha = 1
            specialCharButton.setTitle("123", for: .normal)
        } else {
            showSet = "123"
            charView1.alpha = 0
            charView2.alpha = 1
            charView3.alpha = 0
            specialCharButton.setTitle("#+=", for: .normal)
            
        }
        animButton(button: button)
    }
    @IBAction func capsLockPressed(button: UIButton) {
        if capsChangeEnabled {
            if capsLockOn == "on" {
                capsLockOn = "off"
            } else if capsLockOn == "off" {
                capsLockOn = "on"
            } else {
                capsLockOn = "off"
            }
            changeCaps(containerView: topRow)
            changeCaps(containerView: topRow2)
            changeCaps(containerView: topRow3)
            
            if capsLockOn == "on" {
                capsLocksButton.backgroundColor = .white
                capsLocksButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
            } else {
                capsLocksButton.backgroundColor = UIColor(red: 0.74, green: 0.76, blue: 0.78, alpha: 1.00)
                capsLocksButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
            }
            animButton(button: button)
        }
    }
    @IBAction func capsLocksDoubleTap(button: UIButton) {
        
        capsLockOn = "hold"
        capsChangeEnabled = false
        
        changeCaps(containerView: topRow)
        changeCaps(containerView: topRow2)
        changeCaps(containerView: topRow3)
        
        capsLocksButton.backgroundColor = .white
        capsLocksButton.setImage(UIImage(systemName: "arrow.up.to.line.alt"), for: .normal)
        animButton(button: button)
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(enableCaps), userInfo: nil, repeats: false)
    }
    
    func checkCaps() {
        if capsLockOn == "on" {
            capsLockOn = "off"
            
            changeCaps(containerView: topRow)
            changeCaps(containerView: topRow2)
            changeCaps(containerView: topRow3)
            
            capsLocksButton.backgroundColor = UIColor(red: 0.74, green: 0.76, blue: 0.78, alpha: 1.00)
            capsLocksButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        }
    }
    @objc func enableCaps() {
        capsChangeEnabled = true
    }
    func changeCaps(containerView: UIView) {
        for view in containerView.subviews {
            if let button = view as? UIButton {
                let buttonTitle = button.titleLabel!.text
                if capsLockOn == "on" || capsLockOn == "hold" {
                    let text = buttonTitle!.uppercased()
                    button.setTitle("\(text)", for: .normal)
                } else {
                    let text = buttonTitle!.lowercased()
                    button.setTitle("\(text)", for: .normal)
                }
            }
        }
    }
    
    func createButtons(titles: [String]) -> [UIButton] {
        var buttons = [UIButton]()
        for title in titles {
            let button = KeyboardButton()
            button.setTitle(title, for: .normal)
            button.titleLabel?.font =  UIFont.systemFont(ofSize: 17)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            button.setTitleColor(UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00), for: .normal)
            button.addTarget(self, action: #selector(keyPressed(sender:)), for: .touchUpInside)
            buttons.append(button)
        }
        return buttons
    }
    func addConstraints(buttons: [UIButton], containingView: UIView){
        
        for (index, button) in buttons.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: containingView, attribute: .top, multiplier: 1.0, constant: 1)
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: containingView, attribute: .bottom, multiplier: 1.0, constant: -1)
            
            var leftConstraint : NSLayoutConstraint!
            if index == 0 {
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: containingView, attribute: .left, multiplier: 1.0, constant: 1)
            } else {
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: buttons[index-1], attribute: .right, multiplier: 1.0, constant: 6)
                let widthConstraint = NSLayoutConstraint(item: buttons[0], attribute: .width, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1.0, constant: 0)
                containingView.addConstraint(widthConstraint)
            }
            
            var rightConstraint : NSLayoutConstraint!
            if index == buttons.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: containingView, attribute: .right, multiplier: 1.0, constant: -1)
            } else {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: buttons[index+1], attribute: .left, multiplier: 1.0, constant: -6)
            }
            containingView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
}
extension KeyboardViewController {
    
    // Get type 1 pattern. Recommended on mobile, for sensitive fixed texts (passwords/pins).
    @IBAction func type1Btn(_ sender: UIButton) {
        //let str = textField.text!; let typingPattern = TypingDNARecorderMobile.getTypingPattern(1, 0, str, 0);
        let typingPattern = TypingDNARecorderMobile.getTypingPattern(1, 0, "", 0, textField)
        print("Type 1: ", typingPattern)
    }
    
    // Get type 2 pattern. Recommended on mobile, for non-sensitive fixed texts.
    @IBAction func type2Btn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: {(_) -> Void in
            sender.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        enrollments < 3 ? submit_for_enrollment() : submit_typing_pattern()
    }
    func submit_for_enrollment() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let typingPattern = TypingDNARecorderMobile.getTypingPattern(0, 0, "", 0)
        
        print("Type 2: ", typingPattern)
        textField.text = ""
        query.post_typing_pattern(id: uid, tp: typingPattern) { (res, err) in
            print(err ?? "")
            print(res ?? "")
            let r = res as? Int
            print("Here's the result", r)
            if r == 1 {
                self.progressLbl.text = "Normal"
                self.prev_emotion = .normal
                self.progressSection.backgroundColor = emotion_color().blue
            } else {
                self.progressLbl.text = "Abnormal"
                self.prev_emotion = .abnormal
                self.progressSection.backgroundColor = emotion_color().red
            }
        }
        enrollments += 1
        query.post_dna_enrollments(id: uid, enrs: enrollments) { (res, err) in
            print(err ?? "")
            print(res ?? "")
        }
        TypingDNARecorderMobile.reset(true)
        TypingDNARecorderMobile.addTarget(textField)
        TypingDNARecorderMobile.start()
    }
    
    func submit_typing_pattern() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print("txtfield", textField.text)
        let typingPattern = TypingDNARecorderMobile.getTypingPattern(0, 0, "", 0, textField)
        
        print("Type 2: ", typingPattern)
        textField.text = ""
        query.post_typing_pattern(id: uid, tp: typingPattern) { (res, err) in
            print(err ?? "")
            print(res ?? "")
        }
        enrollments += 1
        query.post_dna_enrollments(id: uid, enrs: enrollments) { (res, err) in
            print(err ?? "")
            print(res ?? "")
        }
        TypingDNARecorderMobile.reset(true)
        TypingDNARecorderMobile.addTarget(textField)
        TypingDNARecorderMobile.start()
    }
    
    // Get type 0 pattern (anytext pattern). NOT recommended on mobile version because it needs 120+ chars to work well.
    @IBAction func type0Btn(_ sender: UIButton) {
        let typingPattern = TypingDNARecorderMobile.getTypingPattern(0, 0, "", 0, textField)
        print("Type 0: ",typingPattern)
    }
    
    @IBAction func resetBtn(_ sender: UIButton) {
        textField.text = ""
        TypingDNARecorderMobile.reset(true)
    }
}

extension KeyboardViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        let perc = Double(textField.text!.count) / Double(150)
        if textField.text!.count == 150 {
            submit_typing_pattern()
        }
        progressView.setProgress(section: 0, to: Float(perc))
    }
}

extension KeyboardViewController: MultiProgressViewDataSource, MultiProgressViewDelegate {
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return 1
    }
    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        return progressSection
    }
}

class Standard_Date: DateFormatter {
    
    public var date: Date?
    public var string: String?
    
    init(dt: Date) {
        super.init()
        date = dt
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        string = self.string(from: dt)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


