//
//  VenuePhotosVC.swift
//  Eventperk
//
//  Created by CIZO on 09/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import Photos
import BSImagePicker

class VenuePhotosVC: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    //MARK:- Outlet Declaration
    @IBOutlet var btnDone: UIButton!
    @IBOutlet var btnAddPhoto: UIButton!
    @IBOutlet var constNoteViewHeight: NSLayoutConstraint!
    
    @IBOutlet var imgPhoto: UIImageView!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var arrPhotos = NSMutableArray()
    
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
        
//        let animation = CABasicAnimation(keyPath: "position")
//        animation.duration = 0.07
//        animation.repeatCount = .infinity
//        animation.autoreverses = true
//        animation.fromValue = NSValue(cgPoint: CGPoint.init(x: 45 - 10, y: 45))
//        animation.toValue = NSValue(cgPoint: CGPoint.init(x: 45 + 10, y: 45))
//        imgPhoto.layer.add(animation, forKey: "position")
        
//        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
//        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        animation.duration = 0.6
//        animation.repeatCount = .infinity
//        animation.autoreverses = true
//        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
//        imgPhoto.layer.add(animation, forKey: "shake")
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddPhotoAction (_ sender: UIButton) {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.isAdditive = true
        animation.duration = 0.07
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint.init(x: 0, y: 2))
        animation.toValue = NSValue(cgPoint: CGPoint.init(x: 2, y: 0))
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        imgPhoto.layer.add(animation, forKey: "position")
        
//        let alert = UIAlertController(title: nil, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
//        
//        alert.addAction(UIAlertAction.init(title: "Take Photo", style: UIAlertActionStyle.default) { (action) in
//            self.takePhoto()
//        })
//        alert.addAction(UIAlertAction.init(title: "Choose Photo", style: UIAlertActionStyle.default) { (action) in
//            self.choosePhoto()
//        })
//        alert.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
//        })
//        self.present(alert, animated: true, completion: nil)
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
        
        let vc = BSImagePickerViewController()
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
            
            print(arrTemp)
            self.arrPhotos.addObjects(from: arrTemp as! [Any])
            
            self.imgPhoto.image = self.arrPhotos.object(at: 0) as? UIImage
            
            self.validateData()
        }, completion: nil)
    }
    
    //MARK: ImagePicker Delegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
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
        }else{
            constNoteViewHeight.constant = 46
        }
    }
}
