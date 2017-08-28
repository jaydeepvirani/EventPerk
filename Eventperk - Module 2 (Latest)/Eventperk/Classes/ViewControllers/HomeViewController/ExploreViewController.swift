//
//  ExploreViewController.swift
//  Eventperk
//
//  Created by HARSHIT on 21/04/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import AASegmentedControl
import AWSDynamoDB
import AWSMobileHubHelper
import AWSCognitoIdentityProvider
import RealmSwift
import APESuperHUD


class ExploreViewController: UIViewController,UITextFieldDelegate {

    //MARK: Outlet Declaration
    @IBOutlet var segmentedControls: AASegmentedControl!
    @IBOutlet var searchBar : UITextField!
    
    let realm = try! Realm()
    var user: AWSCognitoIdentityUser?
    let pool: AWSCognitoIdentityUserPool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
    
    
    //MARK: View Life Cycel
    override func viewDidLoad()
    {   
        super.viewDidLoad()
        
        self.initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Initialization
    
    func initialization(){
        self.setupSegmentedControl()
        
        if Constants.appDelegate.dictUserDetail.value(forKey: "given_name") == nil {
            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
            self.getUserDetails()
        }
    }
    
    func setupSegmentedControl()
    {
        segmentedControls.itemNames = ["Inspirations", "Innovations", "Aspirations"]
        segmentedControls.selectedIndex = 0
        segmentedControls.addTarget(self,
                                 action: #selector(ExploreViewController.segmentValueChanged(_:)),
                                 for: .valueChanged)
    }
    
    func segmentValueChanged(_ sender: AASegmentedControl)
    {
        print("SelectedIndex: ", sender.selectedIndex)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    // MARK: - AWSCall
    
    func scanWithFilterWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        
        scanExpression.filterExpression = "#userId = :userId"
        scanExpression.expressionAttributeNames = ["#userId": "userId" ,]
        scanExpression.expressionAttributeValues = [":userId": AWSIdentityManager.default().identityId! ,]
        
        objectMapper.scan(UserProfile.self, expression: scanExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
           
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as NSError?)
            })
        }
    }
    
    func getUserDetails() {
        
        self.user = self.pool.getUser(Constants.appDelegate.dictUserDetail.value(forKey: "userName") as! String)
        
        self.user?.getDetails().continueWith( block: { (task) in
            DispatchQueue.main.async(execute: {
                
                if task.error != nil {
                    APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                    
                    NSLog("\(task.error!)")
                } else {
                    
                    let response = task.result! as AWSCognitoIdentityUserGetDetailsResponse
                    if response != nil {
                        
                        Constants.appDelegate.dictUserDetail = NSMutableDictionary()
                        
                        for attribute in response.userAttributes! {
                            
                            Constants.appDelegate.dictUserDetail.setValue(attribute.value, forKey: attribute.name!)
                        }
                        
                        Constants.appDelegate.dictUserDetail.setValue((((Constants.appDelegate.dictUserDetail.value(forKey: "email") as! String).components(separatedBy: "@")) as NSArray).object(at: 0) as! String, forKey: "userName")
                        
                        if Constants.appDelegate.dictUserDetail.value(forKey: "picture") != nil {
                            
                            if let url = NSURL(string: Constants.appDelegate.dictUserDetail.value(forKey: "picture") as! String) {
                                if let data = NSData(contentsOf: url as URL) {
                                    
                                    Constants.appDelegate.dictUserDetail.setValue(data as Data, forKey: "pictureInData")
                                }
                            }
                        }
                        
                        let archivedInfo = NSKeyedArchiver.archivedData(withRootObject: Constants.appDelegate.dictUserDetail)
                        UserDefaults.standard.set(archivedInfo, forKey: "UserDetail")
                        UserDefaults.standard.synchronize()
                    }
                    APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                }
            })
        })
    }
    
    func insertSampleDataWithCompletionHandler(_ completionHandler: @escaping (_ errors: [NSError]?) -> Void) {
        
        guard let user: EPUser = realm.objects(EPUser.self).first else { return }
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        var errors: [NSError] = []
        let group: DispatchGroup = DispatchGroup()
        
        let itemForGet: UserProfile! = UserProfile()
        
        itemForGet._userId = AWSIdentityManager.default().identityId!
        itemForGet._aboutMe = " "
        itemForGet._birthDate = user.birthday
        itemForGet._createdDate = ProjectUtilities.stringFromDate(date: Date(), strFormatter: "dd MM yyyy")
        itemForGet._createdTime = ProjectUtilities.stringFromDate(date: Date(), strFormatter: "HH:mm:ss")
        itemForGet._currentSignInAt = "currentSignInAt"
        itemForGet._currentSignInIp = "currentSignInIp"
        itemForGet._deviceType = "iOS"
        itemForGet._email = user.email
        itemForGet._encryptedPassword = "encryptedPassword"
        itemForGet._firstName = user.firstName
        itemForGet._gender = "Not specified"
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
