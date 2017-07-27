//
//  EPNewPasswordViewController.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 03/04/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import RealmSwift
import APESuperHUD
import AWSMobileHubHelper
import AWSCognitoIdentityProvider

class EPNewPasswordViewController: EPBaseViewController {
    
    // UI
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    
    // Constraints
    @IBOutlet weak var nextButtonConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var scrollViewConstraintBottom: NSLayoutConstraint!
    
    // Objects
    let codeView = EPInputView.instanceFromNib() as! EPInputView
    let passwordView = EPInputView.instanceFromNib() as! EPInputView
    let infoView = EPInfoView.instanceFromNib() as! EPInfoView

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                nextButtonConstraintBottom.constant = 20.0
                scrollViewConstraintBottom.constant = 0.0
            } else {
                nextButtonConstraintBottom.constant = (endFrame?.size.height ?? 0.0) + 20.0
                scrollViewConstraintBottom.constant = endFrame?.size.height ?? 0.0
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - Navigation Bar
    
    @IBAction func backButtonDidPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    override func adjustUI() {
        super.adjustUI()
        
        codeView.configure(.code)
        passwordView.configure(.password)
        
        scrollContentView.addSubview(codeView)
        scrollContentView.addSubview(passwordView)
        
        codeView.textField.becomeFirstResponder()
        
        setupConstraints()
    }
    
    func setupConstraints() {
        codeView.snp.makeConstraints { (make) in
            make.leading.equalTo(scrollContentView.snp.leading)
            make.top.equalTo(topContainerView.snp.bottom).offset(32)
            make.trailing.equalTo(scrollContentView.snp.trailing)
            make.height.equalTo(44)
        }
        
        passwordView.snp.makeConstraints { (make) in
            make.leading.equalTo(scrollContentView.snp.leading)
            make.top.equalTo(codeView.snp.bottom).offset(8)
            make.trailing.equalTo(scrollContentView.snp.trailing)
            make.height.equalTo(44 + 28)
            make.bottom.equalTo(scrollContentView.snp.bottom)
        }
        
        view.layoutIfNeeded()
    }
    
    // MARK: - Methods
    
    @discardableResult
    func checkFieldValidation() -> Bool {
        if isValid(password: passwordView.textField.text),
            let text = codeView.textField.text, text.characters.count == 6 {
            
            return true
        }
        return false
    }
    
    func isValid(password string: String?) -> Bool {
        guard let string = string,
            string.characters.count > 7 else { return false }
        
        var isUppercase = false
        var isLowercase = false
        for stringElement in string.unicodeScalars {
            if CharacterSet.uppercaseLetters.contains(stringElement) {
                isUppercase = true
            }
            if CharacterSet.lowercaseLetters.contains(stringElement) {
                isLowercase = true
            }
        }
        
        if isUppercase && isLowercase {
            return true
        }
        
        return false
    }

    // MARK: - Button Handling
    
    @IBAction func nextButtonDidPressed(_ sender: Any) {
        if !checkFieldValidation() {
            infoView.show(at: self.view, title: "Please try again", subtitle: "Your code or password is invalid.")
        } else {
            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
            
            _ = ApiManager.shared.user?.confirmForgotPassword(codeView.textField.text!, password: passwordView.textField.text!).continueWith(block: {[weak self] (task: AWSTask) -> AnyObject? in
                guard let strongSelf = self else { return nil }
                DispatchQueue.main.async(execute: {
                    APESuperHUD.removeHUD(animated: true, presentingView: strongSelf.view, completion: nil)
                    
                    if let error = task.error as NSError? {
                        UIAlertView(title: error.userInfo["__type"] as? String,
                                    message: error.userInfo["message"] as? String,
                                    delegate: nil,
                                    cancelButtonTitle: "Ok").show()
                    } else {
                        UIAlertView(title: "Password Reset Complete",
                                    message: "Password Reset was completed successfully.",
                                    delegate: nil,
                                    cancelButtonTitle: "Ok").show()

                        strongSelf.navigationController?.popToRootViewController(animated: true)
                    }
                })
                return nil
            })
        }
    }
}
