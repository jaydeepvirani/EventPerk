//
//  EPSignUp3ViewController.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 22/03/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import RealmSwift
import ActionSheetPicker_3_0

class EPSignUp3ViewController: EPBaseViewController {
    
    // UI
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    
    // Constraints
    @IBOutlet weak var nextButtonConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var scrollViewConstraintBottom: NSLayoutConstraint!
    
    // Objects
    let birthdayView = EPInputView.instanceFromNib() as! EPInputView
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
        
        birthdayView.configure(.birthday)
        birthdayView.delegate = self
        
        scrollContentView.addSubview(birthdayView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        birthdayView.snp.makeConstraints { (make) in
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
        if isValid(birth: birthdayView.textField.text) {
            
            return true
        }
        return false
    }
    
    func isValid(birth string: String?) -> Bool {
        guard let string = string else { return false }
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        
        if let date = dateFormater.date(from: string) {
            if date.age > 18 {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - Button Handling
    
    @IBAction func nextButtonDidPressed(_ sender: Any) {
        if !checkFieldValidation() {
            infoView.show(at: self.view, title: "Please try again", subtitle: "You must be at least 18 years old.")
        } else {
            guard let user = realm.objects(EPUser.self).first else { return }
            
            do {
                try realm.write {
                    user.birthday = birthdayView.textField.text ?? ""
                }
            } catch {
                fatalError()
            }
            
            if let viewController: EPSignUp4ViewController = aStoryboard.instantiateVC() {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
}

extension EPSignUp3ViewController: EPInputViewDelegate {
    func inputViewDidPressed(_ inputView: EPInputView) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        
        var currentDate = Date()
        if let text = inputView.textField.text,
            let date = dateFormater.date(from: text) {
            
            currentDate = date
        }
        
        let datePicker = ActionSheetDatePicker(title: inputView.textField.placeholder, datePickerMode: .date, selectedDate: currentDate, doneBlock: { (picker, values, indexes) in
            if let date = values as? Date {
                inputView.textField.text = dateFormater.string(from: date)
            }
        }, cancel: { picker in return }, origin: self.view)
        
        let maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        
        datePicker?.maximumDate = maximumDate
        datePicker?.toolbarButtonsColor = .backgroundGradientLeftTop
        datePicker?.show()
    }
}
