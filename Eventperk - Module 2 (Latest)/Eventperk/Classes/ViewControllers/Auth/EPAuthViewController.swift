//
//  EPAuthViewController.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 21/03/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import AWSMobileHubHelper
import FBSDKLoginKit
import APESuperHUD
import RealmSwift

class EPAuthViewController: EPBaseViewController
{
    // UI
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var emailAuthFieldView: EPAuthFieldView!
    @IBOutlet weak var passwordAuthFieldView: EPAuthFieldView!
    
    // Constraints
    @IBOutlet weak var scrollViewConstraintBottom: NSLayoutConstraint!
    
    // Objects
    let infoView = EPInfoView.instanceFromNib() as! EPInfoView
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AnyObject>?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .clear
        
        if Constants.appDelegate.dictUserDetail.value(forKey: "email") != nil {
            let App_Delegate = (UIApplication.shared.delegate as? AppDelegate)
            App_Delegate?.LoadUserTabMenu()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                scrollViewConstraintBottom.constant = 0.0
            } else {
                scrollViewConstraintBottom.constant = endFrame?.size.height ?? 0.0
            }

            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            
                            self.view.layoutIfNeeded()
            }, completion: { (finished) in
                if (endFrame?.origin.y)! < UIScreen.main.bounds.size.height {
                    let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
                    self.scrollView.setContentOffset(bottomOffset, animated: true)
                }
            })
        }
    }
    
    // MARK: - Init Methods
    
    override func adjustUI() {
        super.adjustUI()
        
        appLogoImageView.layer.shadowColor = UIColor.black.cgColor
        appLogoImageView.layer.shadowOpacity = 0.5
        appLogoImageView.layer.shadowOffset = CGSize(width: 6, height: 6)
        appLogoImageView.layer.shadowRadius = 10

        termsLabel.textColor = .white
        termsLabel.numberOfLines = 0
        let infoText = "By Signing up | I agree to Eventperk's Terms of Service, Nondiscrimenation Policy, Payments Terms of Service, Privacy Policy, Customer Refund Policy, and Vendor Guarantee Terms."
        let attribute = NSMutableAttributedString.init(string: infoText)
        //
        let underlineArray = ["Terms of Service", "Nondiscrimenation Policy", "Payments Terms of Service", "Privacy Policy", "Customer Refund Policy", "Guarantee Terms."]
        for underlineInfoText in underlineArray {
            let range = (infoText as NSString).range(of: underlineInfoText)
            attribute.addAttributes([NSUnderlineStyleAttributeName: 1], range: range)
        }
        termsLabel.attributedText = attribute
        
        AWSFacebookSignInProvider.sharedInstance().setPermissions(["public_profile"]);
    }
    
    // MARK: - Methods
    
    @discardableResult
    func checkFieldValidation() -> Bool {
        if emailAuthFieldView.textField.text!.length > 0 &&
            isValid(password: passwordAuthFieldView.textField.text) {
         
            return true
        }
        return false
    }
    
    func isValid(email string: String?) -> Bool {
        guard let string = string else { return false }
        if string.length == 0 { return true }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: string)
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
    
    @IBAction func scrollViewDidTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonDidPressed(_ sender: Any)
    {
        self.view.endEditing(true)
        #if DEBUG
//        emailAuthFieldView.textField.text = "edwin.wm.phng@hotmail.com"
//        passwordAuthFieldView.textField.text = "qwerQWER"
//            emailAuthFieldView.textField.text = "siddharth.b.shukla@gmail.com"
            emailAuthFieldView.textField.text = "gangajaliya.sandeep@gmail.com"
            passwordAuthFieldView.textField.text = "Admin123"
        #endif

        
        if !checkFieldValidation() {
            infoView.show(at: self.view, title: "Please try again", subtitle: "Credentials you have entered does not match")
        } else {
            handleUserPoolSignInFlowStart()
            handleCustomSignIn()
        }
    }
    
    @IBAction func forgotPasswordButtonDidPressed(_ sender: Any) {
        if let viewController: EPForgotPasswordViewController = aStoryboard.instantiateVC() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func facebookLoginDidPressed(_ sender: Any) {
        handleLoginWithSignInProvider(AWSFacebookSignInProvider.sharedInstance())
    }
    
    @IBAction func signUpButtonDidPressed(_ sender: Any) {
        if let viewController: EPSignUp1ViewController = aStoryboard.instantiateVC() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - Requests
    
    func handleLoginWithSignInProvider(_ signInProvider: AWSSignInProvider) {
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
        
        AWSIdentityManager.default().login(signInProvider: signInProvider, completionHandler: {(result: Any?, error: Error?) in
            // If no error reported by SignInProvider, discard the sign-in view controller.
            
            if error == nil
            {
                
                Constants.appDelegate.dictUserDetail.setValue(self.emailAuthFieldView.textField.text?.lowercased(), forKey: "email")
                Constants.appDelegate.dictUserDetail.setValue((((Constants.appDelegate.dictUserDetail.value(forKey: "email") as! String).components(separatedBy: "@")) as NSArray).object(at: 0) as! String, forKey: "userName")
                
                let archivedInfo = NSKeyedArchiver.archivedData(withRootObject: Constants.appDelegate.dictUserDetail)
                UserDefaults.standard.set(archivedInfo, forKey: "UserDetail")
                UserDefaults.standard.synchronize()
                
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                let App_Delegate = (UIApplication.shared.delegate as? AppDelegate)
                App_Delegate?.LoadUserTabMenu()
                
                
                
//                DispatchQueue.main.async(execute: {
//                    
//                    let App_Delegate = (UIApplication.shared.delegate as? AppDelegate)
//                    App_Delegate?.LoadUserTabMenu()
//                    
//                    APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
//                })
            }
            else
            {
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
            }
            
        })
    }
}

// Extension containing methods which call different operations on Cognito User Pools (Sign In, Sign Up, Forgot Password)
extension EPAuthViewController {
    
    func handleCustomSignIn() {
        // set the interactive auth delegate to self, since this view controller handles the login process for user pools
        AWSCognitoUserPoolsSignInProvider.sharedInstance().setInteractiveAuthDelegate(self)
        self.handleLoginWithSignInProvider(AWSCognitoUserPoolsSignInProvider.sharedInstance())
    }
}

// Extension to adopt the `AWSCognitoIdentityInteractiveAuthenticationDelegate` protocol
extension EPAuthViewController: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    
    // this function handles the UI setup for initial login screen, in our case, since we are already on the login screen, we just return the View Controller instance
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        return self
    }
    
    // prepare and setup the ViewController that manages the Multi-Factor Authentication
//    func startMultiFactorAuthentication() -> AWSCognitoIdentityMultiFactorAuthentication {
//        let storyboard = UIStoryboard(name: "UserPools", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "MFA")
//        DispatchQueue.main.async(execute: {
//            self.present(viewController, animated:true, completion:nil);
//        })
//        return viewController as! AWSCognitoIdentityMultiFactorAuthentication
//    }
}

// Extension to adopt the `AWSCognitoIdentityPasswordAuthentication` protocol
extension EPAuthViewController: AWSCognitoIdentityPasswordAuthentication {
    
    func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource as? AWSTaskCompletionSource<AnyObject>
    }
    
    func didCompleteStepWithError(_ error: Error?) {
        if let error = error as NSError? {
            DispatchQueue.main.async(execute: {
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                
                UIAlertView(title: error.userInfo["__type"] as? String,
                            message: error.userInfo["message"] as? String,
                            delegate: nil,
                            cancelButtonTitle: "Ok").show()
            })
        }
    }
}

// Extension to adopt the `AWSCognitoUserPoolsSignInHandler` protocol
extension EPAuthViewController: AWSCognitoUserPoolsSignInHandler {
    func handleUserPoolSignInFlowStart() {
        // check if both username and password fields are provided
        guard let username = self.emailAuthFieldView.textField.text?.lowercased(), !username.isEmpty,
            let password = self.passwordAuthFieldView.textField.text, !password.isEmpty else {
                DispatchQueue.main.async(execute: {
                    UIAlertView(title: "Missing UserName / Password",
                                message: "Please enter a valid user name / password.",
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                })
                return
        }
        // set the task completion result as an object of AWSCognitoIdentityPasswordAuthenticationDetails with username and password that the app user provides
        self.passwordAuthenticationCompletion?.set(result: AWSCognitoIdentityPasswordAuthenticationDetails(username: username, password: password))
    }
}

