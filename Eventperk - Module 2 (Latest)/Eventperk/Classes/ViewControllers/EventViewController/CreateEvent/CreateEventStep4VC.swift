//
//  CreateEventStep4VC.swift
//  Eventperk
//
//  Created by Sandeep Gangajaliya on 01/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class CreateEventStep4VC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var lblGuestCount: UILabel!
    
    @IBOutlet var btnYesVenue: UIButton!
    @IBOutlet var btnNoVenue: UIButton!
    
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
        btnYesVenue.isSelected = true
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnGuestCountAction (_ sender: UIButton) {
        
        var intCount = Int(lblGuestCount.text!)
        if sender.tag == 1{
            if intCount != 0 {
                intCount = intCount! - 1
            }
        }else{
            intCount = intCount! + 1
        }
        lblGuestCount.text = "\(String(describing: intCount!))"
    }
    
    @IBAction func btnVenueOptionAction (_ sender: UIButton) {
        
        btnYesVenue.isSelected = false
        btnNoVenue.isSelected = false
        if sender == btnYesVenue {
            btnYesVenue.isSelected = true
        }else{
            btnNoVenue.isSelected = true
        }
        
        if dictCreateEventDetail.value(forKey: "EventAttributes") != nil {
            dictCreateEventDetail.removeObject(forKey: "EventAttributes")
        }
    }
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createEventStep5Segue" {
            
            dictCreateEventDetail.setValue(lblGuestCount.text, forKey: "NumberOfGuest")
            dictCreateEventDetail.setValue(btnYesVenue.isSelected == true ? "true" : "false", forKey: "HaveVenue")
            
            let vc: CreateEventStep5VC = segue.destination as! CreateEventStep5VC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }
    }
}
