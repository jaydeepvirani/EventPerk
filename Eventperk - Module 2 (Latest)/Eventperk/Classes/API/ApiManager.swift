//
//  ApiManager.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 30/03/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import RealmSwift
import AWSMobileHubHelper
import AWSCognitoIdentityProvider

class ApiManager: NSObject {
    static let shared = ApiManager()
    
    // Objects
    let realm = try! Realm()
    var pool: AWSCognitoIdentityUserPool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
    var user: AWSCognitoIdentityUser?
    
    func requestSignUp(userNameValue: String, emailValue: String, passwordValue: String, birthdateValue: String, firstNameFromText: String, lastNameFromText: String, pushEnabled: Bool, completion: @escaping (_ success: Bool, _ needsConfirmation: Bool) -> Void) {
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        
        let email = AWSCognitoIdentityUserAttributeType()
        email?.name = "email"
        email?.value = emailValue
        attributes.append(email!)
        
        let birthdate = AWSCognitoIdentityUserAttributeType()
        birthdate?.name = "birthdate"
        birthdate?.value = birthdateValue
        attributes.append(birthdate!)
        
        let firstName = AWSCognitoIdentityUserAttributeType()
        firstName?.name = "given_name"
        firstName?.value = firstNameFromText
        attributes.append(firstName!)
        
        let lastName = AWSCognitoIdentityUserAttributeType()
        lastName?.name = "family_name"
        lastName?.value = lastNameFromText
        attributes.append(lastName!)
        
        if pushEnabled {
//            let notifyme = AWSCognitoIdentityUserAttributeType()
//            notifyme?.name = "custom:send_push"
//            notifyme?.value = "true"
//            attributes.append(notifyme!)
        }
        
        //sign up the user
        self.pool.signUp(userNameValue, password: passwordValue, userAttributes: attributes, validationData: nil).continueWith {[weak self] (task: AWSTask<AWSCognitoIdentityUserPoolSignUpResponse>) -> AnyObject? in
            guard let _ = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    UIAlertView(title: error.userInfo["__type"] as? String,
                                message: error.userInfo["message"] as? String,
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                    completion(false, false)
                    return
                }
                
                if let result = task.result as AWSCognitoIdentityUserPoolSignUpResponse! {
                    // handle the case where user has to confirm his identity via email / SMS
                    if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                        //                        strongSelf.sentTo = result.codeDeliveryDetails?.destination
                        //                        strongSelf.performSegue(withIdentifier: "SignUpConfirmSegue", sender:sender)
                        completion(true, true)
                        return
                    } else {
//                        UIAlertView(title: "Registration Complete",
//                                    message: "Registration was successful.",
//                                    delegate: nil,
//                                    cancelButtonTitle: "Ok").show()
                        
                        completion(true, false)
                        return
                    }
                }
                
            })
            completion(false, false)
            return nil
        }
    }
    
    func requestConfirmation(codeValue: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let currentUser = self.realm.objects(EPUser.self).first else {
            completion(false)
            return
        }
        
        self.user = self.pool.getUser(currentUser.username())
        
        self.user?.confirmSignUp(codeValue, forceAliasCreation: true).continueWith(block: {(task: AWSTask) -> AnyObject? in
            DispatchQueue.main.async(execute: {
                if let error = task.error as? NSError {
                    UIAlertView(title: error.userInfo["__type"] as? String,
                                message: error.userInfo["message"] as? String,
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                    completion(false)
                } else {
                    UIAlertView(title: "Registration Complete",
                                message: "Registration was successful.",
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                    completion(true)
                }
            })
            return nil
        })
    }
    
    func requestEditProfile(userNameValue: String, emailValue: String, passwordValue: String, birthdateValue: String, pushEnabled: Bool, completion: @escaping (_ success: Bool, _ needsConfirmation: Bool) -> Void) {
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        
        let email = AWSCognitoIdentityUserAttributeType()
        email?.name = "email"
        email?.value = emailValue
        attributes.append(email!)
        
        let birthdate = AWSCognitoIdentityUserAttributeType()
        birthdate?.name = "birthdate"
        birthdate?.value = birthdateValue
        attributes.append(birthdate!)
        
        if pushEnabled {
            //            let notifyme = AWSCognitoIdentityUserAttributeType()
            //            notifyme?.name = "custom:send_push"
            //            notifyme?.value = "true"
            //            attributes.append(notifyme!)
        }
        
        //sign up the user
        self.pool.signUp(userNameValue, password: passwordValue, userAttributes: attributes, validationData: nil).continueWith {[weak self] (task: AWSTask<AWSCognitoIdentityUserPoolSignUpResponse>) -> AnyObject? in
            guard let _ = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    UIAlertView(title: error.userInfo["__type"] as? String,
                                message: error.userInfo["message"] as? String,
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                    completion(false, false)
                    return
                }
                
                if let result = task.result as AWSCognitoIdentityUserPoolSignUpResponse! {
                    // handle the case where user has to confirm his identity via email / SMS
                    if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                        //                        strongSelf.sentTo = result.codeDeliveryDetails?.destination
                        //                        strongSelf.performSegue(withIdentifier: "SignUpConfirmSegue", sender:sender)
                        completion(true, true)
                        return
                    } else {
                        //                        UIAlertView(title: "Registration Complete",
                        //                                    message: "Registration was successful.",
                        //                                    delegate: nil,
                        //                                    cancelButtonTitle: "Ok").show()
                        
                        completion(true, false)
                        return
                    }
                }
                
            })
            completion(false, false)
            return nil
        }
    }
    
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
}
