//
//  EventVenueLocationVC.swift
//  Eventperk
//
//  Created by Bhavik iOS Developer on 09/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import APESuperHUD

class EventVenueLocationVC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var btnSave: UIButton!
    
    @IBOutlet var lblVenuePhotos: UILabel!
    @IBOutlet var lblCountry: UILabel!
    @IBOutlet var lblStreet: UILabel!
    @IBOutlet var lblUnit: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblPostalCode: UILabel!
    
    @IBOutlet var viewTextInputView: UIView!
    @IBOutlet var viewTextInputViewIn: UIView!
    @IBOutlet var lblTextInputTitle: UILabel!
    @IBOutlet var textViewInput: UITextView!
    
    @IBOutlet var constNoteViewHeight: NSLayoutConstraint!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dictCreateEventDetail)
        
        btnSave.layer.cornerRadius = 10
        viewTextInputViewIn.layer.cornerRadius = 10
        
        viewTextInputView.frame = CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: Constants.ScreenSize.SCREEN_HEIGHT)
        self.view.addSubview(viewTextInputView)
        viewTextInputView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initialization
    func initialization() {
        
        if dictCreateEventDetail.value(forKey: "VenuePhotos") != nil{
            lblVenuePhotos.text = "Tap to edit images"
        }
        
        if dictCreateEventDetail.value(forKey: "VenueLocationInDetail") != nil {
            
            if (dictCreateEventDetail.value(forKey: "VenueLocationInDetail") as! NSDictionary).value(forKey: "Country") != nil {
                
                lblCountry.text = (dictCreateEventDetail.value(forKey: "VenueLocationInDetail") as! NSDictionary).value(forKey: "Country") as? String
            }
            
            if (dictCreateEventDetail.value(forKey: "VenueLocationInDetail") as! NSDictionary).value(forKey: "Street") != nil {
                
                lblStreet.text = (dictCreateEventDetail.value(forKey: "VenueLocationInDetail") as! NSDictionary).value(forKey: "Street") as? String
                lblStreet.textColor = UIColor.black
            }
            
            if (dictCreateEventDetail.value(forKey: "VenueLocationInDetail") as! NSDictionary).value(forKey: "Unit") != nil {
                
                lblUnit.text = (dictCreateEventDetail.value(forKey: "VenueLocationInDetail") as! NSDictionary).value(forKey: "Unit") as? String
                lblUnit.textColor = UIColor.black
            }
            
            if (dictCreateEventDetail.value(forKey: "VenueLocationInDetail") as! NSDictionary).value(forKey: "City") != nil {
                
                lblCity.text = (dictCreateEventDetail.value(forKey: "VenueLocationInDetail") as! NSDictionary).value(forKey: "City") as? String
                lblCity.textColor = UIColor.black
            }
            
            if (dictCreateEventDetail.value(forKey: "VenueLocationInDetail") as! NSDictionary).value(forKey: "PostalCode") != nil {
                
                lblPostalCode.text = (dictCreateEventDetail.value(forKey: "VenueLocationInDetail") as! NSDictionary).value(forKey: "PostalCode") as? String
                lblPostalCode.textColor = UIColor.black
            }
            
            constNoteViewHeight.constant = 0
        }
        
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectionAction (_ sender: UIButton) {
        if sender.tag == 1 {
            self.performSegue(withIdentifier: "venuePhotosSegue", sender: nil)
        }else if sender.tag == 2 {
            
        }else if sender.tag == 3 {
            viewTextInputView.isHidden = false
            textViewInput.becomeFirstResponder()
            lblTextInputTitle.text = "Street"
        }else if sender.tag == 4 {
            viewTextInputView.isHidden = false
            textViewInput.becomeFirstResponder()
            lblTextInputTitle.text = "Unit"
        }else if sender.tag == 5 {
            viewTextInputView.isHidden = false
            textViewInput.becomeFirstResponder()
            lblTextInputTitle.text = "City"
        }else if sender.tag == 6 {
            viewTextInputView.isHidden = false
            textViewInput.becomeFirstResponder()
            lblTextInputTitle.text = "Postal Code"
        }
        
        textViewInput.tag = sender.tag
        textViewInput.text = ""
    }
    
    @IBAction func btnSaveAction (_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if btnSave.isSelected == true {
            
            let dict = NSMutableDictionary()
            
            var str = ""
            dict.setValue(lblCountry.text, forKey: "Country")
            dict.setValue(lblStreet.text, forKey: "Street")
            
            if lblUnit.text != "e. g. # 08-12 Kingston Building" {
                dict.setValue(lblUnit.text, forKey: "Unit")
                
                str = lblUnit.text!
            }
            dict.setValue(lblCity.text, forKey: "City")
            dict.setValue(lblPostalCode.text, forKey: "PostalCode")
            dictCreateEventDetail.setValue(dict, forKey: "VenueLocationInDetail")
            
            str = str + " " + lblStreet.text! + " " + lblCity.text! + " " + lblCountry.text! + " " + lblPostalCode.text!
            
            dictCreateEventDetail.setValue(str, forKey: "VenueLocation")
            
            
            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
            EventProfile.insertUpdateEventData(dictEventDetail: dictCreateEventDetail) { (errors: [NSError]?) in
                
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                if errors == nil {
                    
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    //MARK:- TextView Delegate
    func textViewDidEndEditing(_ textView: UITextView) {
        viewTextInputView.isHidden = true
        
        if textView.text != "" {
            if textViewInput.tag == 3 {
                lblStreet.text = textView.text
                lblStreet.textColor = UIColor.black
            }else if textViewInput.tag == 4 {
                lblUnit.text = textView.text
                lblUnit.textColor = UIColor.black
            }else if textViewInput.tag == 5 {
                lblCity.text = textView.text
                lblCity.textColor = UIColor.black
            }else if textViewInput.tag == 6 {
                lblPostalCode.text = textView.text
                lblPostalCode.textColor = UIColor.black
            }
            
            constNoteViewHeight.constant = 0
        }
        
        self.saveButtonValidation()
    }
    
    //MARK:- Validation
    func saveButtonValidation() {
        
        if lblStreet.text == "e. g. 1 Kingston Road" || lblCity.text == "e. g. SIngapore" || lblPostalCode.text == "e. g. 2334501" {
            
            btnSave.isSelected = false
            btnSave.backgroundColor = UIColor.red
        }else{
            btnSave.isSelected = true
            btnSave.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        }
    }
    
    //MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "venuePhotosSegue" {
            let vc: VenuePhotosVC = segue.destination as! VenuePhotosVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }
    }
}
