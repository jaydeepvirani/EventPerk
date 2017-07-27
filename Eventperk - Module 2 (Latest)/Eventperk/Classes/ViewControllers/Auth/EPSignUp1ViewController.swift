//
//  EPSignUp1ViewController.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 22/03/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import RealmSwift

class EPSignUp1ViewController: EPBaseViewController {
    
    // UI
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    
    // Constraints
    @IBOutlet weak var nextButtonConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var scrollViewConstraintBottom: NSLayoutConstraint!
    
    // Objects
    let firstNameView = EPInputView.instanceFromNib() as! EPInputView
    let lastNameView = EPInputView.instanceFromNib() as! EPInputView
    let emailView = EPInputView.instanceFromNib() as! EPInputView
    let infoView = EPInfoView.instanceFromNib() as! EPInfoView
    
    let realm = try! Realm()

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
        
        firstNameView.configure(.firstName, delegate: self)
        lastNameView.configure(.lastName, delegate: self)
        emailView.configure(.email, delegate: self)
        
        scrollContentView.addSubview(firstNameView)
        scrollContentView.addSubview(lastNameView)
        scrollContentView.addSubview(emailView)
        
        firstNameView.textField.becomeFirstResponder()
    
        setupConstraints()
        
        createUser()
    }
    
    func setupConstraints() {
        firstNameView.snp.makeConstraints { (make) in
            make.leading.equalTo(scrollContentView.snp.leading)
            make.top.equalTo(topContainerView.snp.bottom).offset(32)
            make.trailing.equalTo(scrollContentView.snp.trailing)
            make.height.equalTo(44)
        }
        
        lastNameView.snp.makeConstraints { (make) in
            make.leading.equalTo(scrollContentView.snp.leading)
            make.top.equalTo(firstNameView.snp.bottom).offset(8)
            make.trailing.equalTo(scrollContentView.snp.trailing)
            make.height.equalTo(44)
        }
        
        emailView.snp.makeConstraints { (make) in
            make.leading.equalTo(scrollContentView.snp.leading)
            make.top.equalTo(lastNameView.snp.bottom).offset(8)
            make.trailing.equalTo(scrollContentView.snp.trailing)
            make.height.equalTo(44)
            make.bottom.equalTo(scrollContentView.snp.bottom)
        }
    }
    
    // MARK: - Methods
    
    func createUser() {
        let user = EPUser()
        do {
            try realm.write {
                realm.delete(realm.objects(EPUser.self))
                realm.add(user)
            }
        } catch {
            fatalError()
        }
    }
    
    @discardableResult
    func checkFieldValidation() -> Bool {
        if isValid(email: emailView.textField.text),
            let firstName = firstNameView.textField.text, firstName.length > 0,
            let lastName = lastNameView.textField.text, lastName.length > 0 {
        
            return true
        }
        return false
    }
    
    func isValid(email string: String?) -> Bool {
        guard let string = string, string.length != 0 else { return false } 
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: string)
    }
    
    
    // MARK: - Button Handling
    
    @IBAction func nextButtonDidPressed(_ sender: Any) {
        if !checkFieldValidation() {
            infoView.show(at: self.view, title: "Please try again", subtitle: "You will need to fill in your name and email before proceeding")
        } else {
            guard let user = realm.objects(EPUser.self).first else { return }
            
            do {
                try realm.write {
                    user.firstName = firstNameView.textField.text ?? ""
                    user.lastName = lastNameView.textField.text ?? ""
                    user.email = emailView.textField.text?.lowercased() ?? ""
                }
            } catch {
                fatalError()
            }
            
            if let viewController: EPSignUp2ViewController = aStoryboard.instantiateVC() {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

extension EPSignUp1ViewController: UITextFieldDelegate {
    
}
