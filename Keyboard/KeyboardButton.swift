//
//  KeyboardButton.swift
//  Keyboard
//
//  Created by Nick Crews on 2/9/21.
//

import Foundation
import UIKit

class KeyboardButton: UIButton {
    
    var defaultBackgroundColor: UIColor = .white
    var highlightBackgroundColor: UIColor = .lightGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = isHighlighted ? highlightBackgroundColor : defaultBackgroundColor
    }
    
    
}


// MARK: - Private Methods
private extension KeyboardButton {
    func commonInit() {
        layer.cornerRadius = 6.0
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 0.0
        layer.shadowOpacity = 0.35
    }
}


class KeyboardSpecialButton: UIButton {
    
    var defaultBackgroundColor: UIColor = UIColor(red: 0.74, green: 0.76, blue: 0.78, alpha: 1.00)
    var highlightBackgroundColor: UIColor = .lightGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = isHighlighted ? highlightBackgroundColor : defaultBackgroundColor
    }
    
    
}


// MARK: - Private Methods
private extension KeyboardSpecialButton {
    func commonInit() {
        layer.cornerRadius = 6.0
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 0.0
        layer.shadowOpacity = 0.35
    }
}


class KeyboardUpperButton: UIButton {
    
    var defaultBackgroundColor: UIColor = UIColor(red: 0.74, green: 0.76, blue: 0.78, alpha: 1.00)
    var highlightBackgroundColor: UIColor = .lightGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        backgroundColor = isHighlighted ? highlightBackgroundColor : defaultBackgroundColor
    }
    
    
}


// MARK: - Private Methods
private extension KeyboardUpperButton {
    func commonInit() {
        layer.cornerRadius = 6.0
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 0.0
        layer.shadowOpacity = 0.35
    }
}
