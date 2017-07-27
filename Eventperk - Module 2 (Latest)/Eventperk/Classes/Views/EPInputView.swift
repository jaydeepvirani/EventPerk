//
//  EPInputView.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 22/03/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

enum InputType {
    case email
    case firstName
    case lastName
    case password
    case birthday
    case code
}

protocol EPInputViewDelegate: NSObjectProtocol {
    func inputViewDidPressed(_ inputView: EPInputView)
}

extension EPInputViewDelegate {
    func inputViewDidPressed(_ inputView: EPInputView) {}
}

class EPInputView: UIView {
    
    // UI
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var showButton: UIButton!
    
    // Constraints
    @IBOutlet weak var showButtonConstraintHeight: NSLayoutConstraint!
    
    // Objects
    weak var delegate: EPInputViewDelegate?
    
    // Variables
    var isSelected = false
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "EPInputView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func setupUI() {
        backgroundColor = .clear
        
        textField.font = .sanFrancisco(18)
        textField.tintColor = .white
        textField.textColor = .white
        textField.keyboardType = .emailAddress
        
        showButton.setTitle("Show", for: .normal)
        
        showButtonConstraintHeight.priority = 800
    }
    
    func configure(_ type: InputType, delegate: UITextFieldDelegate? = nil) {
        textField.delegate = delegate
        
        switch type {
        case .email:
            textField.placeholder = "Email Address"
        case .firstName:
            textField.placeholder = "First Name"
        case .lastName:
            textField.placeholder = "Last Name"
        case .password:
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            showButtonConstraintHeight.priority = 250
        case .birthday:
            textField.placeholder = "Date of Birth"
            textField.delegate = self
        case .code:
            textField.placeholder = "Code from Email"
            textField.keyboardType = .numberPad
        }
    }

    // MARK: - Button Handling
    
    @IBAction func showButtonDidPressed(_ sender: Any) {
        isSelected = !isSelected
        
        if isSelected {
            showButton.setTitle("Hide", for: .normal)
        } else {
            showButton.setTitle("Show", for: .normal)
        }
        
        textField.isSecureTextEntry = !isSelected
    }
    
}

extension EPInputView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.inputViewDidPressed(self)
        return false
    }
}
