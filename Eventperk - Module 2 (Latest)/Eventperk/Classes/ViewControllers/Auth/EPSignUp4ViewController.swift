//
//  EPSignUp4ViewController.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 23/03/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import RealmSwift
import APESuperHUD

class EPSignUp4ViewController: EPBaseViewController {
    
    // UI
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var skipButton: EPRoundButton!
    
    // Objects
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation Bar
    
    @IBAction func backButtonDidPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func adjustUI() {
        super.adjustUI()

        skipButton.titleLabel?.font = .arial(14)
    }
    
    // MARK: - Button Handling
    
    @IBAction func skipButtonDidPressed(_ sender: Any) {
        requestSignUp(isNotify: false)
    }
    
    @IBAction func notifyMeDidPressed(_ sender: Any) {
        requestSignUp(isNotify: true)
    }
    
    // MARK: - Requests
    
    func requestSignUp(isNotify: Bool) {
        guard let user: EPUser = realm.objects(EPUser.self).first else { return }
        
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
        
        ApiManager.shared.requestSignUp(userNameValue: user.username(), emailValue: user.email, passwordValue: user.password, birthdateValue: user.birthday, firstNameFromText: user.firstName, lastNameFromText: user.lastName, pushEnabled: isNotify) { (success, needsConfirmation) in
            APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
        
            if success && needsConfirmation {
                if let viewController: EPSignUpConfirmationViewController = self.aStoryboard.instantiateVC() {
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            } else if success {
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
