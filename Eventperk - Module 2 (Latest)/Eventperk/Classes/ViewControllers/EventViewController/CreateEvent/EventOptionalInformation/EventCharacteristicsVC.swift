//
//  EventCharacteristicsVC.swift
//  Eventperk
//
//  Created by Bhavik iOS Developer on 09/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import APESuperHUD

class EventCharacteristicsVC: UIViewController {
    
    //MARK:- Outlet Declaration
    @IBOutlet var btnSave: UIButton!
    
    @IBOutlet var lblEventType: UILabel!
    @IBOutlet var lblEventCategory: UILabel!
    @IBOutlet var lblCounty: UILabel!
    @IBOutlet var lblGuest: UILabel!
    @IBOutlet var lblVenue: UILabel!
    
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
        
        lblEventType.text = dictCreateEventDetail.value(forKey: "EventType") as? String
        lblEventCategory.text = dictCreateEventDetail.value(forKey: "EventCategory") as? String
        if (dictCreateEventDetail.value(forKey:"EventLocationInDetail") as! NSMutableDictionary).value(forKey: "Country") != nil {
            lblCounty.text = (dictCreateEventDetail.value(forKey:"EventLocationInDetail") as! NSMutableDictionary).value(forKey: "Country") as? String
        }
        lblGuest.text = dictCreateEventDetail.value(forKey: "NumberOfGuest") as? String
        lblVenue.text = dictCreateEventDetail.value(forKey: "HaveVenue") as? String
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveAction (_ sender: UIButton) {
        
        if btnSave.isSelected == true {
            if dictCreateEventDetail.value(forKey: "HaveVenue") as? String != lblVenue.text {
                
                if ((dictCreateEventDetail.value(forKey: "EventAttributes") as! NSMutableArray).object(at: 3) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Event Venue" {
                    (dictCreateEventDetail.value(forKey: "EventAttributes") as! NSMutableArray).removeObject(at: 3)
                }else{
                    
                    let dictAttribute = NSMutableDictionary()
                    dictAttribute.setValue("Event Venue", forKey: "AttributeTitle")
                    dictAttribute.setValue("Input the location of your event venue", forKey: "AttributeDescription")
                    dictAttribute.setValue("Only tendered vendors are able to view address", forKey: "VenueWhenAttributeChanged")
                    (dictCreateEventDetail.value(forKey: "EventAttributes") as! NSMutableArray).insert(dictAttribute, at: 3)
                    
                }
                if dictCreateEventDetail.value(forKey: "VenueLocation") != nil {
                   dictCreateEventDetail.removeObject(forKey: "VenueLocation")
                }
                if dictCreateEventDetail.value(forKey: "VenueLocationInDetail") != nil {
                    dictCreateEventDetail.removeObject(forKey: "VenueLocationInDetail")
                }
            }
            
            dictCreateEventDetail.setValue(lblEventType.text, forKey: "EventType")
            dictCreateEventDetail.setValue(lblEventCategory.text, forKey: "EventCategory")
            if (dictCreateEventDetail.value(forKey:"EventLocationInDetail") as! NSMutableDictionary).value(forKey: "Country") != nil {
                (dictCreateEventDetail.value(forKey:"EventLocationInDetail") as! NSMutableDictionary).setValue(lblCounty.text, forKey: "Country")
            }
            
            dictCreateEventDetail.setValue(lblGuest.text, forKey: "NumberOfGuest")
            dictCreateEventDetail.setValue(lblVenue.text, forKey: "HaveVenue")
            
            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
            EventProfile.insertUpdateEventData(dictEventDetail: dictCreateEventDetail) { (errors: [NSError]?) in
                
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                if errors == nil {
                    
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func btnEventCharacteristicsOptionsAction (_ sender: UIButton) {
        
        if dictCreateEventDetail.value(forKey: "Status") as! String == "Incomplete" {
            var intSelection = 0
            if sender.tag == 1 {
                
                if lblEventType.text == "Corporate"{
                    intSelection = 1
                }
                
                ActionSheetMultipleStringPicker.show(withTitle: "Selece event type", rows: [["Social", "Corporate"]], initialSelection: [intSelection], doneBlock: {
                    picker, indexes, values in
                    let selecedValue = values as? Array<Any>
                    self.lblEventType.text = selecedValue?[0] as? String
                    self.lblEventCategory.text = ""
                    self.validateSaveButton()
                    return
                }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
                
            }else if sender.tag == 2 {
                
                var arrEventCategory = [Any]()
                if lblEventType.text == "Social" {
                    arrEventCategory = ["Anniversary", "Birthday", "Ceremony", "Festival", "Reunion", "Theme", "Wedding"]
                }else{
                    arrEventCategory = ["Conference", "Charity", "Dinner & Dance", "Expo & Launch", "Networking", "Trade Fair", "Seminar"]
                }
                
                let index = (arrEventCategory as AnyObject).index(of: lblEventCategory.text!)
                if index != NSNotFound {
                    intSelection = index
                }
                
                ActionSheetMultipleStringPicker.show(withTitle: "Selece event category", rows: [arrEventCategory], initialSelection: [intSelection], doneBlock: {
                    picker, indexes, values in
                    let selecedValue = values as? Array<Any>
                    self.lblEventCategory.text = selecedValue?[0] as? String
                    self.validateSaveButton()
                    return
                }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
                
            }else if sender.tag == 3 {
                
                ActionSheetMultipleStringPicker.show(withTitle: "Selece country", rows: [["Singapore"]], initialSelection: [0], doneBlock: {
                    picker, indexes, values in
                    let selecedValue = values as? Array<Any>
                    self.lblCounty.text = selecedValue?[0] as? String
                    self.validateSaveButton()
                    return
                }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
                
            }else if sender.tag == 4 {
                
                let arrGuest = NSMutableArray()
                for i in 0 ..< 10000 {
                    arrGuest.add("\(i)")
                }
                
                let index = (arrGuest as AnyObject).index(of: lblGuest.text!)
                if index != NSNotFound {
                    intSelection = index
                }
                
                ActionSheetMultipleStringPicker.show(withTitle: "Selece country", rows: [arrGuest], initialSelection: [intSelection], doneBlock: {
                    picker, indexes, values in
                    let selecedValue = values as? Array<Any>
                    self.lblGuest.text = selecedValue?[0] as? String
                    self.validateSaveButton()
                    return
                }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
                
            }else if sender.tag == 5 {
                
                if lblVenue.text == "No" {
                    intSelection = 1
                }
                
                ActionSheetMultipleStringPicker.show(withTitle: "Selece country", rows: [["Yes", "No"]], initialSelection: [intSelection], doneBlock: {
                    picker, indexes, values in
                    let selecedValue = values as? Array<Any>
                    self.lblVenue.text = selecedValue?[0] as? String
                    self.validateSaveButton()
                    return
                }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
                
            }
        }
    }
    
    //MARK: Validate Data
    func validateSaveButton() {
        
        btnSave.isSelected = true
        btnSave.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    }
}
