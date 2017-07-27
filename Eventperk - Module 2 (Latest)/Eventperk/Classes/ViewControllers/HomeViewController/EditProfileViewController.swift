//
//  EditProfileViewController.swift
//  Eventperk
//
//  Created by HARSHIT on 01/05/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import OpalImagePicker
import Photos
import CountryPicker
import AWSDynamoDB
import AWSMobileHubHelper
import APESuperHUD
import RealmSwift
import AWSCognitoIdentityProvider

class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,dismissPopDelegate,CountryPickerDelegate,UITextFieldDelegate, AddPhoneNumberDelegate
{
    
    //MARK:- Variable Declaration
    @IBOutlet var txtFirstName:UITextField!
    @IBOutlet var txtLastName:UITextField!
    @IBOutlet var txt_Gender:UITextField!
    @IBOutlet var txt_BirthDate:UITextField!
    @IBOutlet var user_pic:UIImageView!
    @IBOutlet var lbl_AboutMe:UILabel!
    @IBOutlet var txt_Country:UITextField!
    @IBOutlet var txt_Email:UITextField!
    
    //MARK: About us popup
    
    @IBOutlet var viewAboutUsPopup: UIView!
    @IBOutlet var viewAboutUsPopupIn: UIView!
    @IBOutlet var txtViewAboutUs: UITextView!
    
    //MARK: Other Variable
    var userProfile = UserProfile()
    var dictUserDetail = Constants.appDelegate.dictUserDetail
    var isNeedToUploadPhoto = false
    
    var addPhoneDelegate = AddNumberViewController()
    
    let infoView = EPInfoView.instanceFromNib() as! EPInfoView
    let countryPicker = CountryPicker()
    var popup: AAPopUp = AAPopUp(popup: AAPopUps<String? ,String>("Main" ,identifier: "AboutEditViewController"))
    
    let realm = try! Realm()
    var user: AWSCognitoIdentityUser?
    let pool: AWSCognitoIdentityUserPool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
    fileprivate var manager: AWSUserFileManager!
    
    //MARK:- View Life Cycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        popup.setDelegate(controller: self)
        countryPicker.delegate = self
        addPhoneDelegate.delegate = self
        
        manager = AWSUserFileManager.defaultUserFileManager()
        
        self.initialization()
        
        viewAboutUsPopup.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.view.addSubview(viewAboutUsPopup)
        viewAboutUsPopup.isHidden = true
        
        viewAboutUsPopupIn.clipsToBounds = true
        viewAboutUsPopupIn.layer.cornerRadius = 8.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initialization
    
    func initialization(){
        
        self.displayData()
//        self.getUserDetails()
    }
    
    func displayData(){
        
        txtFirstName.text = self.dictUserDetail.value(forKey: "given_name") as? String
        txtLastName.text = self.dictUserDetail.value(forKey: "family_name") as? String
        
        if self.dictUserDetail.value(forKey: "zoneinfo") != nil {
            lbl_AboutMe.text = self.dictUserDetail.value(forKey: "zoneinfo") as? String
            txtViewAboutUs.text = self.dictUserDetail.value(forKey: "zoneinfo") as? String
        }
        if self.dictUserDetail.value(forKey: "email") != nil {
            txt_Email.text = self.dictUserDetail.value(forKey: "email") as? String
        }
        if self.dictUserDetail.value(forKey: "gender") != nil {
            txt_Gender.text = self.dictUserDetail.value(forKey: "gender") as? String
        }
        if self.dictUserDetail.value(forKey: "birthdate") != nil {
            txt_BirthDate.text = ProjectUtilities.changeDateFormate(strDate: self.dictUserDetail.value(forKey: "birthdate") as! String, strFormatter1: "dd.MM.yyyy", strFormatter2: "dd MMM yyyy") as String
        }
        if self.dictUserDetail.value(forKey: "locale") != nil {
            txt_Country.text = self.dictUserDetail.value(forKey: "locale") as? String
        }
        
        if dictUserDetail.value(forKey: "pictureInData") != nil {
            user_pic.image = UIImage(data: dictUserDetail.value(forKey: "pictureInData") as! Data)
        }else if dictUserDetail.value(forKey: "picture") != nil {
            
            if let url = NSURL(string: dictUserDetail.value(forKey: "picture") as! String) {
                if let data = NSData(contentsOf: url as URL) {
                    user_pic.image = UIImage(data: data as Data)
                }else{
                    user_pic.image = UIImage.init(named: "ic_UserPic")
                }
            }else{
                user_pic.image = UIImage.init(named: "ic_UserPic")
            }
        }else{
            user_pic.image = UIImage.init(named: "ic_UserPic")
        }
    }
    
    //MARK:- Button Click
    
    @IBAction func clk_Back(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clk_Gender(_ sender: UIButton)
    {
        ActionSheetMultipleStringPicker.show(withTitle: "Selece Gender", rows: [
            ["Not specified", "Male", "Female", "Other"]
            ], initialSelection: [0], doneBlock: {
                picker, indexes, values in
                let selecedValue = values as? Array<Any>
                self.txt_Gender.text = selecedValue?[0] as? String
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func clk_BirthDate(_ sender: UIButton)
    {
        let minDate = self.MinSelectionDate(NSDate() as Date)
        let maxDate = self.MaxSelectionDate(NSDate() as Date)
        
        ActionSheetDatePicker.show(withTitle: "Select Birth date", datePickerMode: .date, selectedDate: maxDate, minimumDate: minDate, maximumDate: maxDate, doneBlock: { (picker,selectedDate,origin) in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            self.txt_BirthDate.text = formatter.string(from: (selectedDate as! Date))
        }, cancel: { (ActionSheetDatePicker) in
            
        }, origin: sender)
    }
    
    @IBAction func clk_EditText(_ sender: UIButton)
    {
        self.viewAboutUsPopup.isHidden = false
        ProjectUtilities.animatePopupView(viewPopup: self.viewAboutUsPopup)
        txtViewAboutUs.becomeFirstResponder()
        
//        popup.setText(text: lbl_AboutMe.text!)
//        popup.present { popup in
//            popup.dismissWithTag(9)
//        }
    }
    
    @IBAction func clk_EditMobile(sender: AnyObject)
    {
        let addNumberVC = AddNumberViewController(nibName: "AddNumberViewController", bundle: nil)
        self.navigationController?.pushViewController(addNumberVC, animated: true)
        addNumberVC.delegate = self
    }
    
    @IBAction func clk_EditImage(_ sender: UIButton)
    {
        ActionSheetStringPicker.show(withTitle: "Select Source", rows: ["Camera","Photo Gallery"], initialSelection: 0, doneBlock: { (picker, index, value) in
            if (index == 0)
            {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
                {
                    let imag = UIImagePickerController()
                    imag.delegate = self
                    imag.sourceType = .camera
                    self.present(imag, animated: true, completion: nil)
                }
            }
            else
            {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
                {
                    let imag = UIImagePickerController()
                    imag.delegate = self
                    imag.sourceType = .photoLibrary
                    self.present(imag, animated: true, completion: nil)
                }
            }
            }, cancel: { (picker) in
                
            }, origin: sender)
    }
    
    @IBAction func btnSaveAction(_ sender: UIButton){
        
        self.view.endEditing(true)
        
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
        if isNeedToUploadPhoto == true {
            self.perform(#selector(self.uploadProfilePic), with: nil, afterDelay: 0.1)
        }else{
            self.perform(#selector(self.updateProfile), with: nil, afterDelay: 0.1)
        }
    }
    
    //MARK: AboutUs Popup
    
    @IBAction func btnCloseAboutUsPopupAction(_ sender: UIButton){
        viewAboutUsPopup.isHidden = true
        self.view.endEditing(true)
    }
    
    @IBAction func btnSubmitAboutUsPopupAction(_ sender: UIButton){
        self.view.endEditing(true)
        viewAboutUsPopup.isHidden = true
        lbl_AboutMe.text = txtViewAboutUs.text
    }
    
    //MARK:- Other
    
    func dismissPopUpTextView(_ textView:UITextView)
    {
        lbl_AboutMe.text = textView.text
        popup.dismissPopup()
    }
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailTest.evaluate(with: testStr)
    }
    
    func MinSelectionDate(_ from: Date) -> Date
    {
        let gregorian = NSCalendar(calendarIdentifier: .gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.year = -200
        return gregorian!.date(byAdding: offsetComponents, to: from, options: [])!
    }
    
    func MaxSelectionDate(_ from: Date) -> Date
    {
        let gregorian = NSCalendar(calendarIdentifier: .gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.year = -18
        return gregorian!.date(byAdding: offsetComponents, to: from, options: [])!
    }
    
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == txt_Country
        {
            txt_Country.inputView = countryPicker
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        if textField == txt_Email
        {
            if self.isValidEmail(testStr: textField.text!)
            {
                ActionSheetStringPicker.show(withTitle: "Confirm Email Change", rows: ["Yes","No"], initialSelection: 0, doneBlock: { (picker, index, value) in
                    
                    }, cancel: { (picker) in
                        
                    }, origin: textField)
            }
            else
            {
                infoView.show(at: self.view, title: "Invalid Email Format", subtitle: "Please correct email format!")
            }
        }
        return true
    }
    
    //MARK:- Picker View
    
    public func countryPicker(_ picker: CountryPicker!, didSelectCountryWithName name: String!, code: String!)
    {
        txt_Country.text = name
    }
    
    //MARK:- ImagePicker
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.user_pic.image = pickedImage
            isNeedToUploadPhoto = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- AWS Call
    
    func getUserDetails() {
        
        self.user = self.pool.getUser(Constants.appDelegate.dictUserDetail.value(forKey: "userName") as! String)
        
        self.user?.getDetails().continueWith( block: { (task) in
            DispatchQueue.main.async(execute: {
                
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                if task.error != nil {
                    NSLog("\(task.error)")
                } else {
                    
                    let response = task.result! as AWSCognitoIdentityUserGetDetailsResponse
                    for attribute in response.userAttributes! {
                        
                        self.dictUserDetail.setValue(attribute.value ?? "", forKey: attribute.name!)
                    }
                    
                    print(self.dictUserDetail)
                    self.displayData()
                }
            })
        })
    }
    
    func updateProfile() {
        
        self.user = self.pool.getUser(self.dictUserDetail.value(forKey: "userName") as! String)
        
        var attributes = [AWSCognitoIdentityUserAttributeType]()

        let firstName = AWSCognitoIdentityUserAttributeType()
        firstName?.name = "given_name"
        firstName?.value = txtFirstName.text
        attributes.append(firstName!)
        
        let lastName = AWSCognitoIdentityUserAttributeType()
        lastName?.name = "family_name"
        lastName?.value = txtLastName.text
        attributes.append(lastName!)
        
        let aboutMe = AWSCognitoIdentityUserAttributeType()
        aboutMe?.name = "zoneinfo"
        aboutMe?.value = lbl_AboutMe.text
        attributes.append(aboutMe!)

        let gender = AWSCognitoIdentityUserAttributeType()
        gender?.name = "gender"
        gender?.value = txt_Gender.text
        attributes.append(gender!)

        let birthdate = AWSCognitoIdentityUserAttributeType()
        birthdate?.name = "birthdate"
        birthdate?.value = ProjectUtilities.changeDateFormate(strDate: txt_BirthDate.text!, strFormatter1: "dd MMM yyyy", strFormatter2: "dd.MM.yyyy") as String
        attributes.append(birthdate!)

        let email = AWSCognitoIdentityUserAttributeType()
        email?.name = "email"
        email?.value = txt_Email.text
        attributes.append(email!)

        let locale = AWSCognitoIdentityUserAttributeType()
        locale?.name = "locale"
        locale?.value = txt_Country.text
        attributes.append(locale!)
        
        if self.dictUserDetail.value(forKey: "picture") != nil {
            let picture = AWSCognitoIdentityUserAttributeType()
            picture?.name = "picture"
            picture?.value = self.dictUserDetail.value(forKey: "picture") as? String
            attributes.append(picture!)
        }
        
        self.user?.update(attributes)
        
        APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
        
        let message: String = "Profile has been updated successfully"
        let alartController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alartController.addAction(dismissAction)
        self.present(alartController, animated: true, completion: nil)
        
        Constants.appDelegate.dictUserDetail.setValue(txtFirstName.text, forKey: "given_name")
        Constants.appDelegate.dictUserDetail.setValue(txtLastName.text, forKey: "family_name")
        Constants.appDelegate.dictUserDetail.setValue(lbl_AboutMe.text, forKey: "zoneinfo")
        Constants.appDelegate.dictUserDetail.setValue(txt_Gender.text, forKey: "gender")
        Constants.appDelegate.dictUserDetail.setValue(ProjectUtilities.changeDateFormate(strDate: txt_BirthDate.text!, strFormatter1: "dd MMM yyyy", strFormatter2: "dd.MM.yyyy") as String, forKey: "birthdate")
        Constants.appDelegate.dictUserDetail.setValue(txt_Country.text, forKey: "locale")
        
        if self.dictUserDetail.value(forKey: "picture") != nil {
            Constants.appDelegate.dictUserDetail.setValue(self.dictUserDetail.value(forKey: "picture") as! String, forKey: "picture")
        }
        
        let archivedInfo = NSKeyedArchiver.archivedData(withRootObject: Constants.appDelegate.dictUserDetail)
        UserDefaults.standard.set(archivedInfo, forKey: "UserDetail")
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileUpdateNotification"), object: nil)
    }
    
    func updateProfileWithCompletionHandler(_ completionHandler: @escaping (_ errors: NSError) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        userProfile?._userId = AWSIdentityManager.default().identityId!
        userProfile?._aboutMe = lbl_AboutMe.text
        userProfile?._birthDate = txt_BirthDate.text
        userProfile?._createdDate = "11111111"
        userProfile?._createdTime = "11111111"
        userProfile?._currentSignInAt = "currentSignInAt"
        userProfile?._currentSignInIp = "currentSignInIp"
        userProfile?._deviceType = "iOS"
        userProfile?._email = txt_Email.text
        userProfile?._encryptedPassword = "encryptedPassword"
        userProfile?._firstName = txtFirstName.text
        userProfile?._gender = txt_Gender.text
        userProfile?._language = "language"
        userProfile?._lastName = txtLastName.text
        userProfile?._lastSignInAt = "lastSignInAt"
        userProfile?._lastSignInIp = "lastSignInIp"
        userProfile?._locale = txt_Country.text
        userProfile?._logInStatus = "logInStatus"
        userProfile?._responseRate = "responseRate"
        userProfile?._signInCount = "signInCount"
        userProfile?._userPhoto = ["test"]
        
        objectMapper.save(userProfile!, completionHandler: {(error: Error?) in
            DispatchQueue.main.async(execute: {
                
                if error != nil {
                    completionHandler((error as? NSError)!)
                }else{
                    completionHandler(NSError())
                }
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
    
    func insertSampleDataWithCompletionHandler(_ completionHandler: @escaping (_ errors: [NSError]?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        var errors: [NSError] = []
        let group: DispatchGroup = DispatchGroup()
        
        let itemForGet: UserProfile! = UserProfile()
        
        itemForGet._userId = AWSIdentityManager.default().identityId!
        itemForGet._aboutMe = lbl_AboutMe.text
        itemForGet._birthDate = txt_BirthDate.text
        itemForGet._createdDate = "11111111"
        itemForGet._createdTime = "11111111"
        itemForGet._currentSignInAt = "currentSignInAt"
        itemForGet._currentSignInIp = "currentSignInIp"
        itemForGet._deviceType = "iOS"
        itemForGet._email = txt_Email.text
        itemForGet._encryptedPassword = "encryptedPassword"
        itemForGet._firstName = txtFirstName.text
        itemForGet._gender = txt_Gender.text
        itemForGet._language = "language"
        itemForGet._lastName = txtLastName.text
        itemForGet._lastSignInAt = "lastSignInAt"
        itemForGet._lastSignInIp = "lastSignInIp"
        itemForGet._locale = txt_Country.text
        itemForGet._logInStatus = "logInStatus"
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
    
    //MARK:- AddPhoneNumber Delegate
    
    func phoneNumberVerified(strPhoneNumber: String) {
        
        _ = strPhoneNumber
    }
    
    //MARK:- Upload Profile Pic
    
    func uploadProfilePic(){
        
        var imgUser: UIImage = UIImage()
        imgUser = ObjectiveCMethods.scaleAndRotateImage(user_pic.image)
        
        let data = UIImagePNGRepresentation(imgUser)!
        
        let strPhotoUrl = "uploads/\(Constants.appDelegate.dictUserDetail.value(forKey: "userName") as! String).png"
        let localContent = manager.localContent(with: data, key: strPhotoUrl)
        localContent.uploadWithPin(onCompletion: false, progressBlock: {[weak self] (content: AWSLocalContent, progress: Progress) in
            
                print("Inprogress")
            
            }, completionHandler: {[weak self] (content: AWSLocalContent?, error: Error?) in
                if let error = error {
                    print("Failed to upload an object. \(error)")
                    APESuperHUD.removeHUD(animated: true, presentingView: (self?.view)!, completion: nil)
                } else {
                    
                    print("success")
                    self?.isNeedToUploadPhoto = false
                    
                    self?.dictUserDetail.setValue("https://s3-ap-southeast-1.amazonaws.com/eventperkios-userfiles-mobilehub-1122713487/\(strPhotoUrl)", forKey: "picture")
                    self?.updateProfile()
                    
                    self?.dictUserDetail.setValue(data, forKey: "pictureInData")
                    Constants.appDelegate.dictUserDetail = (self?.dictUserDetail)!
                    
                    let archivedInfo = NSKeyedArchiver.archivedData(withRootObject: Constants.appDelegate.dictUserDetail)
                    UserDefaults.standard.set(archivedInfo, forKey: "UserDetail")
                    UserDefaults.standard.synchronize()
                }
            })
    }
}
