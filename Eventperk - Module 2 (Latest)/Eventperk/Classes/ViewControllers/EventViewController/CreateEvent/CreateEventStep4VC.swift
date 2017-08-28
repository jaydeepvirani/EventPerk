//
//  CreateEventStep4VC.swift
//  Eventperk
//
//  Created by Sandeep Gangajaliya on 01/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import APESuperHUD

class CreateEventStep4VC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblGuestCount: UILabel!
    
    @IBOutlet var btnYesVenue: UIButton!
    @IBOutlet var btnNoVenue: UIButton!
    
    @IBOutlet var constDescriptionViewHeight: NSLayoutConstraint!
    @IBOutlet var constVenueViewHeight: NSLayoutConstraint!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var isFromEventDetail = false
    
    
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
        
        if isFromEventDetail == true {
            lblTitle.text = "Pax"
            
            constDescriptionViewHeight.constant = 0
            constVenueViewHeight.constant = 0
            
            if dictCreateEventDetail.value(forKey: "NumberOfGuest") != nil {    
                lblGuestCount.text = dictCreateEventDetail.value(forKey: "NumberOfGuest") as? String
            }
        }
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
        
        if dictCreateEventDetail.value(forKey: "EventServices") != nil {
            dictCreateEventDetail.removeObject(forKey: "EventServices")
        }
    }
    
    @IBAction func btnNextAction (_ sender: UIButton) {
        
        if isFromEventDetail == true {
            dictCreateEventDetail.setValue(lblGuestCount.text, forKey: "NumberOfGuest")
        }else{
            dictCreateEventDetail.setValue(lblGuestCount.text, forKey: "NumberOfGuest")
            dictCreateEventDetail.setValue(btnYesVenue.isSelected == true ? "Yes" : "No", forKey: "HaveVenue")
        }
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
        EventProfile.insertUpdateEventData(dictEventDetail: dictCreateEventDetail) { (errors: [NSError]?) in
            
            APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
            if errors == nil {
                
                if self.isFromEventDetail == true {
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    self.performSegue(withIdentifier: "createEventStep5Segue", sender: nil)
                }
            }
        }
    }
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createEventStep5Segue" {
            
            let vc: CreateEventStep5VC = segue.destination as! CreateEventStep5VC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }
    }
}
