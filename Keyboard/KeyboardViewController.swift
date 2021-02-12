//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Nick Crews on 2/9/21.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var capsLocksButton: UIButton!
    @IBOutlet var otherCharButton: UIButton!
    @IBOutlet var specialCharButton: UIButton!
    
    @IBOutlet var charView1: UIView!
    @IBOutlet var charView2: UIView!
    @IBOutlet var charView3: UIView!
    
    
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
    
    var showSet = "ABC"
    var capsLockOn = "on"
    var capsChangeEnabled = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        
        self.nextKeyboardButton = UIButton(type: .system)
        self.nextKeyboardButton.setTitle(NSLocalizedString("TypingDNA", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        self.view.addSubview(self.nextKeyboardButton)
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

    }
    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        view.subviews.forEach({ $0.removeFromSuperview() })
        
        // For designing in XIB
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        view = objects[0] as? UIView;
        
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
        
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
        
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
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    
    func animButton(button: UIButton) {
        UIView.animate(withDuration: 0.05, animations: {
            button.transform = CGAffineTransform(scaleX: 1.04, y: 1.04)
        }, completion: {(_) -> Void in
            button.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
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
    
    @objc func keyPressed(sender: AnyObject?) {
        let button = sender as! UIButton
        let title = button.title(for: .normal)
        (textDocumentProxy as UIKeyInput).insertText(title!)
        checkCaps()
        animButton(button: button)
    }
    
    @objc func keyHeld(sender: AnyObject?) {
        
        let button = sender as! UIButton
        let title = button.title(for: .normal)
        heldKey = title!
        hold_timer?.invalidate()
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (time) in
            self.hold_timer?.invalidate()
            self.hold_timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.executeHeldKey), userInfo: nil, repeats: true)
        }
    }
    
    
    @IBAction func backSpacePressed(button: UIButton) {
        (textDocumentProxy as UIKeyInput).deleteBackward()
        animButton(button: button)
    }
    
    @IBAction func backSpaceHeld(button: UIButton) {
        heldKey = ""
        hold_timer?.invalidate()
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (time) in
            self.hold_timer?.invalidate()
            self.hold_timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.executeBackSpace), userInfo: nil, repeats: true)
        }
    }
    @objc func executeBackSpace() {
        (textDocumentProxy as UIKeyInput).deleteBackward()
    }
    
    @IBAction func spacePressed(button: UIButton) {
        (textDocumentProxy as UIKeyInput).insertText(" ")
        checkCaps()
        animButton(button: button)
    }
    @IBAction func spaceHeld(button: UIButton) {
        heldKey = " "
        hold_timer?.invalidate()
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (time) in
            self.hold_timer?.invalidate()
            self.hold_timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.executeHeldKey), userInfo: nil, repeats: true)
        }
    }
    @IBAction func returnHeld(button: UIButton) {
        heldKey = "\n"
        hold_timer?.invalidate()
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (time) in
            self.hold_timer?.invalidate()
            self.hold_timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.executeHeldKey), userInfo: nil, repeats: true)
        }
    }
    @IBAction func touchUp(_ sender: UIButton) {
        print("Invalidate it")
        hold_timer?.invalidate()
    }

    @objc private func longPress (longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == .began {
            print("long press began")
            
            hold_timer?.invalidate()
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (time) in
                self.hold_timer?.invalidate()
                self.hold_timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.executeHeldKey), userInfo: nil, repeats: true)
            }
        } else if longPressGestureRecognizer.state == .ended {
            print("long press stopped")
            hold_timer?.invalidate()
        }
    }
    
    var hold_timer: Timer?
    var heldKey = ""
    @objc func executeHeldKey() {
        print("holding key \(heldKey)")
        (textDocumentProxy as UIKeyInput).insertText(heldKey)
        checkCaps()
    }
    @IBAction func returnPressed(button: UIButton) {
        (textDocumentProxy as UIKeyInput).insertText("\n")
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