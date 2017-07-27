//
//  EPSignUpConfirmationViewController.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 02/04/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import RealmSwift
import APESuperHUD
import AWSDynamoDB
import AWSMobileHubHelper
import Realm

class EPSignUpConfirmationViewController: EPBaseViewController {
    
    // UI
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    
    @IBOutlet weak var emailAuthFieldView: EPAuthFieldView!
    @IBOutlet weak var passwordAuthFieldView: EPAuthFieldView!
    
    // Constraints
    @IBOutlet weak var nextButtonConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var scrollViewConstraintBottom: NSLayoutConstraint!
    
    // Objects
    let codeView = EPInputView.instanceFromNib() as! EPInputView
    let infoView = EPInfoView.instanceFromNib() as! EPInfoView
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    override func adjustUI() {
        super.adjustUI()
        
        codeView.configure(.code)
        
        scrollContentView.addSubview(codeView)
        
        codeView.textField.becomeFirstResponder()
        
        setupConstraints()
    }
    
    func setupConstraints() {
        codeView.snp.makeConstraints { (make) in
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
        if let code = codeView.textField.text, code.characters.count == 6 {
            return true
        }
        return false
    }

    // MARK: - Button Handling
    
    @IBAction func nextButtonDidPressed(_ sender: Any) {
        if !checkFieldValidation() {
            infoView.show(at: self.view, title: "Please try again", subtitle: "Your code needs to be 6 digits length")
        } else {
            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
            
            ApiManager.shared.requestConfirmation(codeValue: codeView.textField.text!, completion: { (success) in
                
                if success {
                    
                    if let viewController: EPAuthViewController = self.aStoryboard.instantiateVC() {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
            })
        }
    }
    
    //MARK:- AWS Call
    
    func insertSampleDataWithCompletionHandler(_ completionHandler: @escaping (_ errors: [NSError]?) -> Void) {
        
        guard let user: EPUser = realm.objects(EPUser.self).first else { return }
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        var errors: [NSError] = []
        let group: DispatchGroup = DispatchGroup()
        
        let itemForGet: UserProfile! = UserProfile()
        
        itemForGet._userId = AWSIdentityManager.default().identityId!
        itemForGet._aboutMe = " "
        itemForGet._birthDate = user.birthday
        itemForGet._createdDate = "11111111"
        itemForGet._createdTime = "11111111"
        itemForGet._currentSignInAt = "currentSignInAt"
        itemForGet._currentSignInIp = "currentSignInIp"
        itemForGet._deviceType = "iOS"
        itemForGet._email = user.email
        itemForGet._encryptedPassword = "encryptedPassword"
        itemForGet._firstName = user.firstName
        itemForGet._gender = " "
        itemForGet._language = "language"
        itemForGet._lastName = user.lastName
        itemForGet._lastSignInAt = "lastSignInAt"
        itemForGet._lastSignInIp = "lastSignInIp"
        itemForGet._locale = " "
        itemForGet._logInStatus = "logInStatus"
        itemForGet._phoneNumber = 0
        itemForGet._responseRate = "responseRate"
        itemForGet._signInCount = "signInCount"
        itemForGet._userPhoto = ["test"]
        
        group.enter()
        
        
        objectMapper.save(itemForGet, completionHandler: {(error: Error?) -> Void in
            if let error = error as? NSError {
                DispatchQueue.main.async(execute: {
                    errors.append(error)
                })
            }
            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main, execute: {
            if errors.count > 0 {
                completionHandler(errors)
            }
            else {
                completionHandler(nil)
            }
        })
    }
}

