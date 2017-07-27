//
//  EPSignUp2ViewController.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 22/03/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import RealmSwift
//import AWSMobileHubHelper
//import AWSCognitoIdentityProvider

class EPSignUp2ViewController: EPBaseViewController {
    
    // UI
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    
    // Constraints
    @IBOutlet weak var nextButtonConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var scrollViewConstraintBottom: NSLayoutConstraint!
    
    // Objects
    let passwordView = EPInputView.instanceFromNib() as! EPInputView
    let infoView = EPInfoView.instanceFromNib() as! EPInfoView
//    var pool: AWSCognitoIdentityUserPool?
//    var user: AWSCognitoIdentityUser?
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
//        self.pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
//        self.user = self.pool?.getUser("Test")
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
        
        passwordView.configure(.password, delegate: self)
        
        scrollContentView.addSubview(passwordView)
        
        passwordView.textField.becomeFirstResponder()
        
        setupConstraints()
    }
    
    func setupConstraints() {
        passwordView.snp.makeConstraints { (make) in
            make.leading.equalTo(scrollContentView.snp.leading)
            make.top.equalTo(topContainerView.snp.bottom).offset(32)
            make.trailing.equalTo(scrollContentView.snp.trailing)
            make.height.equalTo(44)
            make.bottom.equalTo(scrollContentView.snp.bottom)
        }
    }
    
    // MARK: - Methods
    
    @discardableResult
    func checkFieldValidation() -> Bool {
        if isValid(password: passwordView.textField.text) {
            
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
            infoView.show(at: self.view, title: "Please try again", subtitle: "Your have to be 8 characters long, and at least 1 upper and 1 lower case")
        } else {
            guard let user = realm.objects(EPUser.self).first else { return }
            
            do {
                try realm.write {
                    user.password = passwordView.textField.text ?? ""
                }
            } catch {
                fatalError()
            }
            
            if let viewController: EPSignUp3ViewController = aStoryboard.instantiateVC() {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
//            requestSignUp(userNameValue: "Test", emailValue: "pahanius@mail.ru", passwordValue: "Qwerty123")
//            onConfirm(confirmationCode: "")
//            resendCode()
        }
    }
    
}

// Request
extension EPSignUp2ViewController {
//    func requestSignUp(userNameValue: String, emailValue: String, passwordValue: String) {
//        var attributes = [AWSCognitoIdentityUserAttributeType]()
//        
//        let email = AWSCognitoIdentityUserAttributeType()
//        email?.name = "email"
//        email?.value = emailValue
//        attributes.append(email!)
//        
//        let birthdate = AWSCognitoIdentityUserAttributeType()
//        birthdate?.name = "birthdate"
//        birthdate?.value = "18.02.1988"
//        attributes.append(birthdate!)
//        
//        //sign up the user
//        self.pool?.signUp(userNameValue, password: passwordValue, userAttributes: attributes, validationData: nil).continueWith {[weak self] (task: AWSTask<AWSCognitoIdentityUserPoolSignUpResponse>) -> AnyObject? in
//            guard let strongSelf = self else { return nil }
//            DispatchQueue.main.async(execute: {
//                if let error = task.error as? NSError {
//                    UIAlertView(title: error.userInfo["__type"] as? String,
//                                message: error.userInfo["message"] as? String,
//                                delegate: nil,
//                                cancelButtonTitle: "Ok").show()
//                    return
//                }
//                
//                if let result = task.result as AWSCognitoIdentityUserPoolSignUpResponse! {
//                    // handle the case where user has to confirm his identity via email / SMS
//                    if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
////                        strongSelf.sentTo = result.codeDeliveryDetails?.destination
////                        strongSelf.performSegue(withIdentifier: "SignUpConfirmSegue", sender:sender)
//                    } else {
//                        UIAlertView(title: "Registration Complete",
//                                    message: "Registration was successful.",
//                                    delegate: nil,
//                                    cancelButtonTitle: "Ok").show()
//                        strongSelf.presentingViewController?.dismiss(animated: true, completion: nil)
//                    }
//                }
//                
//            })
//            return nil
//        }
//    }
//    
//    func onConfirm(confirmationCode: String) {
//        let confirmationCodeValue = "185768"
////        guard let confirmationCodeValue = self.confirmationCode.text, !confirmationCodeValue.isEmpty else {
////            UIAlertView(title: "Confirmation code missing.",
////                        message: "Please enter a valid confirmation code.",
////                        delegate: nil,
////                        cancelButtonTitle: "Ok").show()
////            return
////        }
//        self.user?.confirmSignUp(confirmationCodeValue, forceAliasCreation: true).continueWith(block: {[weak self] (task: AWSTask) -> AnyObject? in
//            guard let strongSelf = self else { return nil }
//            DispatchQueue.main.async(execute: {
//                if let error = task.error as? NSError {
//                    UIAlertView(title: error.userInfo["__type"] as? String,
//                                message: error.userInfo["message"] as? String,
//                                delegate: nil,
//                                cancelButtonTitle: "Ok").show()
//                } else {
//                    UIAlertView(title: "Registration Complete",
//                                message: "Registration was successful.",
//                                delegate: nil,
//                                cancelButtonTitle: "Ok").show()
//                    strongSelf.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//                }
//            })
//            return nil
//        })
//    }
//    
//    func resendCode() {
//        self.user?.resendConfirmationCode().continueWith(block: {[weak self] (task: AWSTask<AWSCognitoIdentityUserResendConfirmationCodeResponse>) -> AnyObject? in
//            guard let _ = self else { return nil }
//            DispatchQueue.main.async(execute: {
//                if let error = task.error as? NSError {
//                    UIAlertView(title: error.userInfo["__type"] as? String,
//                                message: error.userInfo["message"] as? String,
//                                delegate: nil,
//                                cancelButtonTitle: "Ok").show()
//                } else if let result = task.result as AWSCognitoIdentityUserResendConfirmationCodeResponse! {
//                    UIAlertView(title: "Code Resent",
//                                message: "Code resent to \(result.codeDeliveryDetails?.destination!)",
//                        delegate: nil,
//                        cancelButtonTitle: "Ok").show()
//                }
//            })
//            return nil
//        })
//    }
}

extension EPSignUp2ViewController: UITextFieldDelegate {
    
}
