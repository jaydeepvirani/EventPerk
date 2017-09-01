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
    @IBOutlet var lblVenue: UILabel!
    
    @IBOutlet var sldrGuest: UISlider!
    
    @IBOutlet var constDescriptionViewHeight: NSLayoutConstraint!
    
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
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sliderValueDidChanged (_ sender: UISlider) {
        
        lblGuestCount.text = "\(Int(sender.value))"
    }
    
    @IBAction func btnVenueOptionSwitchAction (_ sender: UISwitch) {
        
        if sender.isOn {
            lblVenue.text = "Yes"
        }else{
            lblVenue.text = "No"
        }
        
        if dictCreateEventDetail.value(forKey: "EventAttributes") != nil {
            dictCreateEventDetail.removeObject(forKey: "EventAttributes")
        }
        
        if dictCreateEventDetail.value(forKey: "EventServices") != nil {
            dictCreateEventDetail.removeObject(forKey: "EventServices")
        }
    }
    
    @IBAction func btnNextAction (_ sender: UIButton) {
        
        dictCreateEventDetail.setValue(lblGuestCount.text, forKey: "NumberOfGuest")
        dictCreateEventDetail.setValue(lblVenue.text, forKey: "HaveVenue")
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
        EventProfile.insertUpdateEventData(dictEventDetail: dictCreateEventDetail) { (errors: [NSError]?) in
            
            APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
            if errors == nil {
                
                self.performSegue(withIdentifier: "createEventStep5Segue", sender: nil)
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
