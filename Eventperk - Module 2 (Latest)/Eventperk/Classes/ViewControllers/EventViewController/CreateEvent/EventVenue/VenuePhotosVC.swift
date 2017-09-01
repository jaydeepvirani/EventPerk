//
//  VenuePhotosVC.swift
//  Eventperk
//
//  Created by CIZO on 09/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import Photos
//import BSImagePicker
import AWSDynamoDB
import AWSMobileHubHelper
import AWSCognitoIdentityProvider
import APESuperHUD

class VenuePhotosVC: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    //MARK:- Outlet Declaration
    @IBOutlet var btnDone: UIButton!
    @IBOutlet var btnAddPhoto: UIButton!
    @IBOutlet var constNoteViewHeight: NSLayoutConstraint!
    
    @IBOutlet var imgPhoto: UIImageView!
    @IBOutlet var colPhotos: UICollectionView!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var arrPhotos = NSMutableArray()
    var isLongPressGestureEnable = false
    
    var intPhotoUploadingIndex = 0
    var isEditedPhoto = false
    
    fileprivate var manager: AWSUserFileManager!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dictCreateEventDetail)
        self.initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initialization
    func initialization() {
        btnDone.layer.cornerRadius = 10
        btnAddPhoto.layer.cornerRadius = 10
        
        if dictCreateEventDetail.value(forKey: "VenuePhotos") != nil{
            
            arrPhotos.addObjects(from: (dictCreateEventDetail.value(forKey: "VenuePhotos") as! NSMutableArray) as! [Any])
            self.validateData()
        }else{
            for _ in 0 ..< 4 {
                arrPhotos.add(" ")
            }
        }
        
        let tappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(VenuePhotosVC.tapped(sender:)))
        self.view.addGestureRecognizer(tappedRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(VenuePhotosVC.longPressed(sender:)))
        self.colPhotos.addGestureRecognizer(longPressRecognizer)
        
        manager = AWSUserFileManager.defaultUserFileManager()
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddPhotoAction (_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction.init(title: "Take Photo", style: UIAlertActionStyle.default) { (action) in
            self.takePhoto()
        })
        alert.addAction(UIAlertAction.init(title: "Choose Photo", style: UIAlertActionStyle.default) { (action) in
            self.choosePhoto()
        })
        alert.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnDoneAction (_ sender: UIButton) {
        
        if btnDone.isSelected == true {
            
            self.loopPhoto()
        }
    }
    
    //MARK: Cell Events
    @IBAction func btnCrossAction (_ sender: UIButton) {
        
        isEditedPhoto = true
        arrPhotos.removeObject(at: sender.tag)
        isLongPressGestureEnable = false
        colPhotos.reloadData()
        self.validateData()
    }
    
    //MARK:- CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return arrPhotos.count != 0 ? arrPhotos.count-1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell{
     
        let cell : VenuePhotosCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VenuePhotosCollectionCell", for: indexPath) as! VenuePhotosCollectionCell
        
        if ((arrPhotos.object(at: indexPath.row+1)) as AnyObject).isKind(of: UIImage.self) {
            cell.imgVenue.image = arrPhotos.object(at: indexPath.row+1) as? UIImage
        }else if arrPhotos.object(at: indexPath.row+1) as! String != " " {
            cell.imgVenue.sd_setImage(with: NSURL(string: arrPhotos.object(at: indexPath.row+1) as! String) as URL!)
        }
        
        cell.btnCross.tag = indexPath.row+1
        cell.btnCross.addTarget(self, action: #selector(btnCrossAction(_:)), for: UIControlEvents.touchUpInside)
        
        if isLongPressGestureEnable == true {
            cell.btnCross.isHidden = false
            cell.imgVenue.shake()
            cell.btnCross.shake()
        }else{
            cell.btnCross.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView : UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize{
        
        return CGSize.init(width: (Constants.ScreenSize.SCREEN_WIDTH-8)/3, height: (Constants.ScreenSize.SCREEN_WIDTH-8)/3)
    }
    
    //MARK:- Image Picker
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = .camera
            self.present(imag, animated: true, completion: nil)
        }
    }
    
    func choosePhoto() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = .photoLibrary
            self.present(imag, animated: true, completion: nil)
        }
        
/*        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 6
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            print("Selected: \(asset)")
        }, deselect: { (asset: PHAsset) -> Void in
            print("Deselected: \(asset)")
        }, cancel: { (assets: [PHAsset]) -> Void in
            print("Cancel: \(assets)")
        }, finish: { (assets: [PHAsset]) -> Void in
            print("Finish: \(assets)")
            
            let arrTemp = NSMutableArray()
            let requestOptions = PHImageRequestOptions()
            requestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
            requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
            // this one is key
            requestOptions.isSynchronous = true
            
            for asset in assets{
                if (asset.mediaType == PHAssetMediaType.image){
                    
                    PHImageManager.default().requestImage(for: asset , targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: requestOptions, resultHandler: { (pickedImage, info) in
                        
                        arrTemp.add(pickedImage!)
                    })
                }
            }
            self.arrPhotos.addObjects(from: arrTemp as! [Any])
            self.perform(#selector(VenuePhotosVC.validateData), with: nil, afterDelay: 0.1)
        }, completion: nil)*/
    }
    
    //MARK: ImagePicker Delegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if arrPhotos.count != 0 && arrPhotos.object(at: 0) as? String == " " {
            arrPhotos.removeAllObjects()
        }
        
        isEditedPhoto = true
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            arrPhotos.add(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
        
        self.validateData()
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Validations
    func validateData() {
        
        if arrPhotos.count != 0 {
            constNoteViewHeight.constant = 0
            btnDone.isSelected = true
            btnDone.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
            
            if ((arrPhotos.object(at: 0)) as AnyObject).isKind(of: UIImage.self) {
                self.imgPhoto.image = self.arrPhotos.object(at: 0) as? UIImage
            }else if arrPhotos.object(at: 0) as! String != " " {
                self.imgPhoto.sd_setImage(with: NSURL(string: arrPhotos.object(at: 0) as! String) as URL!)
            }
            
            self.colPhotos.reloadData()
        }else{
            constNoteViewHeight.constant = 46
            btnDone.isSelected = false
            btnDone.backgroundColor = UIColor.red
        }
    }
    
    //MARK:- Gesture
    func longPressed(sender: UILongPressGestureRecognizer){
        
        if arrPhotos.count != 0 && arrPhotos.object(at: 0) as? String != " " {
            isLongPressGestureEnable = true
            colPhotos.reloadData()
        }
    }
    
    func tapped(sender: UITapGestureRecognizer){
        isLongPressGestureEnable = false
        colPhotos.reloadData()
    }
    
    //MARK:- Upload Venue Photos
    func loopPhoto(){
        
        if intPhotoUploadingIndex < arrPhotos.count && isEditedPhoto == true {
            if ((arrPhotos.object(at: intPhotoUploadingIndex)) as AnyObject).isKind(of: UIImage.self) {
                self.uploadVenuePhoto(img: (arrPhotos.object(at: intPhotoUploadingIndex) as? UIImage)!)
            }else{
                intPhotoUploadingIndex = intPhotoUploadingIndex + 1
                self.loopPhoto()
            }
        }else{
            
            if isEditedPhoto == true {
                dictCreateEventDetail.setValue(arrPhotos, forKey: "VenuePhotos")
                
                APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
                EventProfile.insertUpdateEventData(dictEventDetail: dictCreateEventDetail) { (errors: [NSError]?) in
                    
                    APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                    if errors == nil {
                        
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                    }
                }
            }else{
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
        }
    }
    
    func uploadVenuePhoto(img: UIImage){
        
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
        
        var imgVenue: UIImage = UIImage()
        imgVenue = ObjectiveCMethods.scaleAndRotateImage(img)
        
        let data = UIImagePNGRepresentation(imgVenue)!
        
        let strPhotoUrl = "uploads/\((dictCreateEventDetail.value(forKey: "id"))!)\(intPhotoUploadingIndex).png"
        let localContent = manager.localContent(with: data, key: strPhotoUrl)
        localContent.uploadWithPin(onCompletion: false, progressBlock: {[weak self] (content: AWSLocalContent, progress: Progress) in
            
            print("Inprogress")
            
            }, completionHandler: {[weak self] (content: AWSLocalContent?, error: Error?) in
                if let error = error {
                    print("Failed to upload an object. \(error)")
                    APESuperHUD.removeHUD(animated: true, presentingView: (self?.view)!, completion: nil)
                } else {
                    
                    print("success")
                    
                    self?.arrPhotos.replaceObject(at: (self?.intPhotoUploadingIndex)!, with: "https://s3-ap-southeast-1.amazonaws.com/eventperkios-userfiles-mobilehub-1122713487/\(strPhotoUrl)")
                    
                    self?.intPhotoUploadingIndex = (self?.intPhotoUploadingIndex)! + 1
                    self?.loopPhoto()
                    
//                        self.arrPhotos.replaceObject(at: self.intPhotoUploadingIndex, with: "https://s3-ap-southeast-1.amazonaws.com/eventperkios-userfiles-mobilehub-1122713487/\(strPhotoUrl)")
//                        self.intPhotoUploadingIndex = self.intPhotoUploadingIndex + 1
//                        self.loopPhoto()
                }
        })
    }
}

class VenuePhotosCollectionCell: UICollectionViewCell {
    
    @IBOutlet var imgVenue: UIImageView!
    @IBOutlet var btnCross: UIButton!
}
