//
//  EventVenueLocationVC.swift
//  Eventperk
//
//  Created by Bhavik iOS Developer on 09/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class EventVenueLocationVC: UIViewController, UITextFieldDelegate {

    //MARK:- Outlet Declaration
    @IBOutlet var btnSave: UIButton!
    
    @IBOutlet var txtStreet: UITextField!
    @IBOutlet var txtUnit: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtState: UITextField!
    @IBOutlet var txtPostal: UITextField!
    @IBOutlet var txtCountry: UITextField!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    
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
        btnSave.layer.cornerRadius = 10
        
        if dictCreateEventDetail.value(forKey: "VenueLocationInDetial") != nil {
            
            if (dictCreateEventDetail.value(forKey: "VenueLocationInDetial") as! NSMutableDictionary).value(forKey: "Street") != nil {
                
                txtStreet.text = (dictCreateEventDetail.value(forKey: "VenueLocationInDetial") as! NSMutableDictionary).value(forKey: "Street") as? String
            }
            if (dictCreateEventDetail.value(forKey: "VenueLocationInDetial") as! NSMutableDictionary).value(forKey: "Unit") != nil {
                
                txtUnit.text = (dictCreateEventDetail.value(forKey: "VenueLocationInDetial") as! NSMutableDictionary).value(forKey: "Unit") as? String
            }
            if (dictCreateEventDetail.value(forKey: "VenueLocationInDetial") as! NSMutableDictionary).value(forKey: "City") != nil {
                
                txtCity.text = (dictCreateEventDetail.value(forKey: "VenueLocationInDetial") as! NSMutableDictionary).value(forKey: "City") as? String
            }
            if (dictCreateEventDetail.value(forKey: "VenueLocationInDetial") as! NSMutableDictionary).value(forKey: "State") != nil {
                
                txtState.text = (dictCreateEventDetail.value(forKey: "VenueLocationInDetial") as! NSMutableDictionary).value(forKey: "State") as? String
            }
            if (dictCreateEventDetail.value(forKey: "VenueLocationInDetial") as! NSMutableDictionary).value(forKey: "PostalCode") != nil {
                
                txtPostal.text = (dictCreateEventDetail.value(forKey: "VenueLocationInDetial") as! NSMutableDictionary).value(forKey: "PostalCode") as? String
            }
            if (dictCreateEventDetail.value(forKey: "VenueLocationInDetial") as! NSMutableDictionary).value(forKey: "Country") != nil {
                
                txtCountry.text = (dictCreateEventDetail.value(forKey: "VenueLocationInDetial") as! NSMutableDictionary).value(forKey: "Country") as? String
            }
            
            self.saveButtonValidation()
        }
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveAction (_ sender: UIButton) {
        if btnSave.isSelected == true {
            self.performSegue(withIdentifier: "venuePhotosSegue", sender: nil)
        }
    }
    
    //MARK:- UITextFieldDelegate
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        self.saveButtonValidation()
    }
    
    //MARK:- Validation
    func saveButtonValidation() {
        
        if txtCity.text == "" || txtState.text == "" || txtCountry.text == "" || txtPostal.text == "" {
            
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
