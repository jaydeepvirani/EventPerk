//
//  EPForgotPasswordViewController.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 22/03/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import SnapKit
import APESuperHUD
import AWSMobileHubHelper
import AWSCognitoIdentityProvider

class EPForgotPasswordViewController: EPBaseViewController {
    
    // UI
    @IBOutlet weak var topContainerView: UIView!
    
    // Constraints
    @IBOutlet weak var nextButtonConstraintBottom: NSLayoutConstraint!
    
    // Objects
    let emailInputView = EPInputView.instanceFromNib() as! EPInputView
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
            } else {
                nextButtonConstraintBottom.constant = (endFrame?.size.height ?? 0.0) + 20.0
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
    
    // MARK: - Init Methods
    
    override func adjustUI() {
        super.adjustUI()
        
        emailInputView.configure(.email, delegate: self)
        
        view.addSubview(emailInputView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        emailInputView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.snp.leading)
            make.top.equalTo(topContainerView.snp.bottom).offset(32)
            make.trailing.equalTo(self.view.snp.trailing)
            make.height.equalTo(44)
        }
    }

    // MARK: - Button Handling
    
    @IBAction func nextButtonDidPressed(_ sender: Any) {
        if !checkFieldValidation() {
            infoView.show(at: self.view, title: "Please try again", subtitle: "There is no account that match your email address.")
        } else {
            if let navView = self.navigationController?.view {
                infoView.show(at: navView, title: "Check your email", subtitle: "A link to reset your password have been sent to you")
                
                ApiManager.shared.user = ApiManager.shared.pool.getUser(emailInputView.textField.text!)
                
                APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
                ApiManager.shared.user?.forgotPassword().continueWith(block: {[weak self] (task: AWSTask) -> AnyObject? in
                    guard let strongSelf = self else {return nil}
                    DispatchQueue.main.async(execute: {
                        APESuperHUD.removeHUD(animated: true, presentingView: strongSelf.view, completion: nil)
                        
                        if let error = task.error as NSError? {
                            UIAlertView(title: error.userInfo["__type"] as? String,
                                        message: error.userInfo["message"] as? String,
                                        delegate: nil,
                                        cancelButtonTitle: "Ok").show()
                        } else {
                            if let viewController: EPNewPasswordViewController = self?.aStoryboard.instantiateVC() {
                                strongSelf.navigationController?.pushViewController(viewController, animated: true)
                            }
                        }
                    })
                    return nil
                })
                
            }
        }
    }
    
    // MARK: - Methods
    
    @discardableResult
    func checkFieldValidation() -> Bool {
        if isValid(email: emailInputView.textField.text) {
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
}

extension EPForgotPasswordViewController: UITextFieldDelegate {
    
}
