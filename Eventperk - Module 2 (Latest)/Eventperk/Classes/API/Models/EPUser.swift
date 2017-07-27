//
//  EPUser.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 30/03/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import RealmSwift

class EPUser: Object {
    dynamic var email = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var birthday = ""
    dynamic var password = ""
    dynamic var notifyMe = false
//    dynamic var gender = ""
//    dynamic var aboutMe = ""
    
    func username() -> String {
        
        if email != "" {
            return ((email.components(separatedBy: "@")) as NSArray).object(at: 0) as! String
        }else{
            return ""
        }
    }
}

class EPUserProfile: Object {
    
    dynamic var userId = ""
    dynamic var aboutMe = ""
    dynamic var birthDate = ""
    dynamic var createdDate = 0
    dynamic var createdTime = 0
    dynamic var currentSignInAt = ""
    dynamic var currentSignInIp = ""
    dynamic var deviceType = ""
    dynamic var email = ""
    dynamic var encryptedPassword = ""
    dynamic var firstName = ""
    dynamic var gender = ""
    dynamic var language = ""
    dynamic var lastName = ""
    dynamic var lastSignInAt = ""
    dynamic var lastSignInIp = ""
    dynamic var locale = ""
    dynamic var logInStatus = ""
    dynamic var phoneNumber = 0
    dynamic var responseRate = ""
    dynamic var signInCount = ""
    dynamic var userPhoto = ""
}
