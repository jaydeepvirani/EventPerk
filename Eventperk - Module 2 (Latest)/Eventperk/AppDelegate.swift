//
//  AppDelegate.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 21/03/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift
import AWSCognitoIdentityProvider
import AWSMobileHubHelper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,RDVTabBarControllerDelegate {

    var window: UIWindow?
    var isVendor: Bool?
    var storyBoard: UIStoryboard?
    
    var dictUserDetail = NSMutableDictionary()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.

        self.storyBoard = UIStoryboard(name: "Main", bundle: nil)
        IQKeyboardManager.sharedManager().enable = true
        setupDatabase()
        
        if UserDefaults.standard.value(forKey: "UserDetail") != nil {
            
            let unarchivedObject = UserDefaults.standard.object(forKey: "UserDetail") as? NSData
            dictUserDetail = NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as! Data) as! NSMutableDictionary
//            print("User detail = ",dictUserDetail)
        }
        
        return AWSMobileClient.sharedInstance.didFinishLaunching(application, withOptions: launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AWSMobileClient.sharedInstance.applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return AWSMobileClient.sharedInstance.withApplication(application, withURL: url, withSourceApplication: sourceApplication, withAnnotation: annotation)
    }
    
    func LoadUserTabMenu()
    {
        let exploreVC = self.storyBoard?.instantiateViewController(withIdentifier: "ExploreViewController") as! ExploreViewController
        let likeVC = self.storyBoard?.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
        let eventVC = self.storyBoard?.instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
        let inboxVC = self.storyBoard?.instantiateViewController(withIdentifier: "InboxViewController") as! InboxViewController
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        
        let exploreNav = UINavigationController(rootViewController: exploreVC)
        exploreNav.navigationBar.isHidden = true
        let likeNav = UINavigationController(rootViewController: likeVC)
        likeNav.navigationBar.isHidden = true
        let eventNav = UINavigationController(rootViewController: eventVC)
        eventNav.navigationBar.isHidden = true
        let inboxNav = UINavigationController(rootViewController: inboxVC)
        inboxNav.navigationBar.isHidden = true

        let _tabBarController = RDVTabBarController()
        _tabBarController.delegate = self;
        _tabBarController.viewControllers = [exploreNav,likeNav,eventNav,inboxNav,profileVC]
        
        let arr_Title = ["Explore","Likes","Events","Inbox","Profile"]
        
        for i in 0..<arr_Title.count
        {
            let item = _tabBarController.tabBar.items[i] as! RDVTabBarItem
            let selectedimage = UIImage(named: "ic_D\(i)")
            let normalimage = UIImage(named: "ic_\(i)")
            item.title = arr_Title[i] as String
            item.setFinishedSelectedImage(selectedimage, withFinishedUnselectedImage: normalimage)
        }
        self.isVendor = false
        self.window?.rootViewController = _tabBarController
        self.window?.makeKeyAndVisible()
    }
    
    func LoadVendorTabMenu()
    {
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        let requestVC = VendorRequestViewController(nibName: "VendorRequestViewController", bundle: nil)
        let revenuesVC = VendorRevenuesViewController(nibName: "VendorRevenuesViewController", bundle: nil)
        let servicesVC = VendorRevenuesViewController(nibName: "VendorRevenuesViewController", bundle: nil)
        let inboxVC = self.storyBoard?.instantiateViewController(withIdentifier: "InboxViewController") as! InboxViewController
        
        let requestNav = UINavigationController(rootViewController: requestVC)
        requestNav.navigationBar.isHidden = true
        
        let revenuesNav = UINavigationController(rootViewController: revenuesVC)
        revenuesNav.navigationBar.isHidden = true
        
        let serviceNav = UINavigationController(rootViewController: servicesVC)
        serviceNav.navigationBar.isHidden = true
        
        let inboxNav = UINavigationController(rootViewController: inboxVC)
        inboxNav.navigationBar.isHidden = true
        
        let _tabBarController = RDVTabBarController()
        _tabBarController.delegate = self;
        _tabBarController.viewControllers = [requestNav,revenuesNav,serviceNav,inboxNav,profileVC]
        
        let arr_Title = ["Requests","Revenues","Events","Inbox","Profile"]
        
        for i in 0..<arr_Title.count
        {
            let item = _tabBarController.tabBar.items[i] as! RDVTabBarItem
            if i<=2
            {
                let selectedimage = UIImage(named: "ic_VD\(i)")
                let normalimage = UIImage(named: "ic_V\(i)")
                item.title = arr_Title[i] as String
                item.setFinishedSelectedImage(selectedimage, withFinishedUnselectedImage: normalimage)
            }
            else
            {
                let selectedimage = UIImage(named: "ic_D\(i)")
                let normalimage = UIImage(named: "ic_\(i)")
                item.title = arr_Title[i] as String
                item.setFinishedSelectedImage(selectedimage, withFinishedUnselectedImage: normalimage)
            }
        }
        self.isVendor = true
        self.window?.rootViewController = _tabBarController
        self.window?.makeKeyAndVisible()
    }
    
    func LogOutTabMenu()
    {
//        AWSCognitoUserPoolsSignInProvider.sharedInstance().logout()
        
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let navVC = storyBoard.instantiateViewController(withIdentifier: "EPNavigationViewController") as! UINavigationController
//        navVC.navigationController?.popToRootViewController(animated: true)
//        self.window?.rootViewController = navVC
//        self.window?.makeKeyAndVisible()
    }
    
    func getVenderModeStatus() -> Bool
    {
        return self.isVendor!
    }
    
    // MARK: - Database
    
    func setupDatabase ()
    {
        let config = Realm.Configuration (
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            
            // PRODFIX: Check it before Production (set schema version the same as app build number)
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        if K.Platform.isSimulator
        {
            // Save db to Mac Desktop
            let dbPath = String(format:"/Users/%@/Desktop/Eventperk/", NSHomeDirectory().components(separatedBy: "/")[2])
            try! FileManager.default.createDirectory(at: URL(fileURLWithPath: dbPath), withIntermediateDirectories: true, attributes: nil)
            Realm.Configuration.defaultConfiguration.fileURL = URL(string: dbPath.appending("eventperk.realm"))
        }
    }
    
    func tabBarController(_ tabBarController: RDVTabBarController!, didSelect viewController: UIViewController!) {
        
    }
    
    func tabBarController(_ tabBarController: RDVTabBarController!, didSelect index: Int) {
        
    }
}

class ProjectUtilities: NSObject
{
    class func stringFromDate (date: Date, strFormatter strDateFormatter: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormatter
        
        let convertedDate = dateFormatter.string(from: date)
        
        return convertedDate
    }
    
    class func changeDateFormate (strDate: String, strFormatter1 strDateFormatter1: String, strFormatter2 strDateFormatter2: String) -> NSString
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormatter1
        
        if let date = dateFormatter.date(from: strDate)
        {
            dateFormatter.dateFormat = strDateFormatter2
            
            if let strConvertedDate:NSString = dateFormatter.string(from: date) as NSString?
            {
                return strConvertedDate
            }
        }
        return ""
    }
    
    class func animatePopupView (viewPopup: UIView)
    {
        viewPopup.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001);
        
        UIView.animate(withDuration: 0.3/1.5, animations: {
            
            viewPopup.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            
        }) { (finished) in
            
            UIView.animate(withDuration: 0.3/2, animations: {
                viewPopup.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9);
                }, completion: { (finished) in
                    
                    UIView.animate(withDuration: 0.3/2, animations: {
                        viewPopup.transform = CGAffineTransform.identity;
                    })
            })
        }
    }
}

