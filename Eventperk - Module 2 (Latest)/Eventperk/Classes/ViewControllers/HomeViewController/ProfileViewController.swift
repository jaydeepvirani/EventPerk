//
//  ProfileViewController.swift
//  Eventperk
//
//  Created by HARSHIT on 21/04/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import HCSStarRatingView
import AWSDynamoDB
import AWSMobileHubHelper
import APESuperHUD
import RealmSwift
import AWSCognitoIdentityProvider

class ProfileViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource
{
    //MARK:- Outlet Declaration
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblOrigin: UILabel!
    @IBOutlet var lblVerifiedInformation: UILabel!
    @IBOutlet var lblAboutMe: UILabel!
    @IBOutlet var lblMemberSince: UILabel!
    
    @IBOutlet var imgUserPic: UIImageView!
    
    @IBOutlet var starRatingView:HCSStarRatingView!
    @IBOutlet var collection_View:UICollectionView!
    @IBOutlet var dashLine_View:UIView!
    
    @IBOutlet var lbl_Services:UILabel!
    @IBOutlet var lbl_Review:UILabel!
    
    //MARK: Other Variable
    var userProfile = UserProfile()
    
    let realm = try! Realm()
    var user: AWSCognitoIdentityUser?
    let pool: AWSCognitoIdentityUserPool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
    
    //MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        starRatingView.value = 0
        starRatingView.isUserInteractionEnabled = false
        
        self.initialization()
    }
    
    override func viewDidLayoutSubviews() {
        dashLine_View.addDashedLine()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.displayData()
    }
    
    //MARK:- Initialization
    
    func initialization(){
        
        self.collection_View.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        
//        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
//        self.getUserDetails()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.profileUpdateNotification), name: NSNotification.Name(rawValue: "profileUpdateNotification"), object: nil)
    }
    
    func displayData(){
        
        let dictUserDetail = Constants.appDelegate.dictUserDetail
        
        lblName.text = "\(dictUserDetail.value(forKey: "given_name") as! String)" + " " + "\(dictUserDetail.value(forKey: "family_name") as! String)"
        
        if dictUserDetail.value(forKey: "locale") != nil {
            lblOrigin.text = dictUserDetail.value(forKey: "locale") as? String
        }
        if dictUserDetail.value(forKey: "email_verified") as! String == "true" {
            lblVerifiedInformation.text = dictUserDetail.value(forKey: "email") as? String
        }
        if dictUserDetail.value(forKey: "zoneinfo") != nil {
            lblAboutMe.text = dictUserDetail.value(forKey: "zoneinfo") as? String
        }
        if dictUserDetail.value(forKey: "updated_at") != nil {
            lblMemberSince.text = "Member since " + (ProjectUtilities.changeDateFormate(strDate: dictUserDetail.value(forKey: "updated_at") as! String, strFormatter1: "dd MM yyyy", strFormatter2: "MMM yyyy") as String)
        }
        
        if dictUserDetail.value(forKey: "pictureInData") != nil {
            imgUserPic.image = UIImage(data: dictUserDetail.value(forKey: "pictureInData") as! Data)
        }else if dictUserDetail.value(forKey: "picture") != nil {
            
            if let url = NSURL(string: dictUserDetail.value(forKey: "picture") as! String) {
                if let data = NSData(contentsOf: url as URL) {
                    imgUserPic.image = UIImage(data: data as Data)
                }else{
                    imgUserPic.image = UIImage.init(named: "ic_UserPic")
                }
            }else{
                imgUserPic.image = UIImage.init(named: "ic_UserPic")
            }
        }else{
            imgUserPic.image = UIImage.init(named: "ic_UserPic")
        }
    }
    
    //MARK:- Button TouchUp
    
    @IBAction func clk_Back(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clk_ViewAll(_ sender: UIButton)
    {
        let viewEventVC = ViewAllEventsViewController(nibName: "ViewAllEventsViewController", bundle: nil)
        self.navigationController?.pushViewController(viewEventVC, animated: true)
    }
    
    @IBAction func clk_EditProfile(_ sender: UIButton)
    {
        let editProfileVC = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @IBAction func clk_Follwo(_ sender: UIButton)
    {
        let followVC = FollowViewController(nibName: "FollowViewController", bundle: nil)
        self.navigationController?.pushViewController(followVC, animated: true)
    }
    
    @IBAction func clk_Service(_ sender: UIButton)
    {
        lbl_Services.textColor = UIColor.orange
        lbl_Review.textColor = UIColor.black
    }
    
    @IBAction func clk_Review(_ sender: UIButton)
    {
        lbl_Services.textColor = UIColor.black
        lbl_Review.textColor = UIColor.orange
    }
    
    //MARK:- CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    //MARK:- AWS Call
    
    func getUserDetails() {
        
        self.user = self.pool.getUser(Constants.appDelegate.dictUserDetail.value(forKey: "userName") as! String)
        
        self.user?.getDetails().continueWith( block: { (task) in
            DispatchQueue.main.async(execute: {
            
                if task.error != nil {
                    NSLog("\(task.error!)")
                } else {
                    
                    let response = task.result! as AWSCognitoIdentityUserGetDetailsResponse
                    if response != nil {
                        for attribute in response.userAttributes! {
                            
                            Constants.appDelegate.dictUserDetail.setValue(attribute.value ?? "", forKey: attribute.name!)
                        }
                        
                        self.displayData()
                    }
                }
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
            })
        })
    }
    
    func getItemWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        
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
    
    //MARK:- NSNotification Method
    
    func profileUpdateNotification(){
        
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
        self.getUserDetails()
    }
}

extension UIView {
    
    func addDashedLine(color: UIColor = .lightGray)
    {
        layer.sublayers?.filter({ $0.name == "DashedTopLine" }).map({ $0.removeFromSuperlayer() })
        backgroundColor = .clear
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [4, 4]
        
        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        shapeLayer.path = path
        
        layer.addSublayer(shapeLayer)
    }
}
