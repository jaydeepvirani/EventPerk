//
//  EventSnoozedVC.swift
//  Eventperk
//
//  Created by Sandeep on 26/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import APESuperHUD

class EventSnoozedVC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var btnFrom: UIButton!
    @IBOutlet var btnTo: UIButton!
    @IBOutlet var btnSetSnooze: UIButton!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var isChangedFrom = false
    var strFromDate = ""
    var strToDate = ""
    
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
        
        if dictCreateEventDetail.value(forKey: "SnoozeFrom") != nil {
            
            strFromDate = dictCreateEventDetail.value(forKey: "SnoozeFrom") as! String
            strToDate = dictCreateEventDetail.value(forKey: "SnoozeTo") as! String
            
            btnFrom.setTitle("From \(strFromDate)", for: UIControlState.normal)
            btnTo.setTitle("To \(strToDate)", for: UIControlState.normal)
            
        }else{
            btnFrom.setTitle("From \(ProjectUtilities.stringFromDate(date: Date(), strFormatter: "dd MMMM yyyy"))", for: UIControlState.normal)
            btnTo.setTitle("To \(ProjectUtilities.stringFromDate(date: Date(), strFormatter: "dd MMMM yyyy"))", for: UIControlState.normal)
            
            strFromDate = ProjectUtilities.stringFromDate(date: Date(), strFormatter: "dd MMMM yyyy")
            strToDate = ProjectUtilities.stringFromDate(date: Date(), strFormatter: "dd MMMM yyyy")
            
        }
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnDateSelectionAction (_ sender: UIButton) {
        if sender.tag == 1 {
            
            let gregorian = NSCalendar(calendarIdentifier: .gregorian)
            var offsetComponents = DateComponents()
            offsetComponents.year = 200
            let maxDate = gregorian!.date(byAdding: offsetComponents, to: Date(), options: [])!
            
            ActionSheetDatePicker.show(withTitle: "Select from date", datePickerMode: .date, selectedDate: Date(), minimumDate: Date(), maximumDate: maxDate, doneBlock: { (picker,selectedDate,origin) in
                
                self.btnFrom.setTitle("From \(ProjectUtilities.stringFromDate(date: selectedDate as! Date, strFormatter: "dd MMMM yyyy"))", for: UIControlState.normal)
                self.strFromDate = ProjectUtilities.stringFromDate(date: selectedDate as! Date, strFormatter: "dd MMMM yyyy")
                
                self.isChangedFrom = true
                
                self.btnTo.setTitle("To", for: UIControlState.normal)
                self.strToDate = ""
                
                self.btnSetSnooze.isSelected = false
                self.btnSetSnooze.backgroundColor = UIColor.red
                
            }, cancel: { (ActionSheetDatePicker) in
                
            }, origin: sender)
            
        }else{
            let minDate = ProjectUtilities.dateFromString(strDate: self.strFromDate, strFormatter:"dd MMMM yyyy")
            
            let gregorian = NSCalendar(calendarIdentifier: .gregorian)
            var offsetComponents = DateComponents()
            offsetComponents.month = 1
            let maxDate = gregorian!.date(byAdding: offsetComponents, to: minDate, options: [])!
            
            ActionSheetDatePicker.show(withTitle: "Select to date", datePickerMode: .date, selectedDate: minDate, minimumDate: minDate, maximumDate: maxDate, doneBlock: { (picker,selectedDate,origin) in
                
                self.btnTo.setTitle("To \(ProjectUtilities.stringFromDate(date: selectedDate as! Date, strFormatter: "dd MMMM yyyy"))", for: UIControlState.normal)
                
                self.strToDate = ProjectUtilities.stringFromDate(date: selectedDate as! Date, strFormatter: "dd MMMM yyyy")
                
                if self.isChangedFrom == true {
                    
                    self.btnSetSnooze.isSelected = true
                    self.btnSetSnooze.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
                }
                
            }, cancel: { (ActionSheetDatePicker) in
                
            }, origin: sender)
        }
    }
    
    @IBAction func btnSetSnoozeAction (_ sender: UIButton) {
        
        if btnSetSnooze.isSelected == true{
            
            dictCreateEventDetail.setValue(strFromDate, forKey: "SnoozeFrom")
            dictCreateEventDetail.setValue(strToDate, forKey: "SnoozeTo")
            dictCreateEventDetail.setValue("Snoozed", forKey: "Status")
            
            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
            EventProfile.insertUpdateEventData(dictEventDetail: dictCreateEventDetail) { (errors: [NSError]?) in
                
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                if errors == nil {
                    
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                }
            }
        }
    }
}
