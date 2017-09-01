//
//  CreateEventStep5VC.swift
//  Eventperk
//
//  Created by Sandeep Gangajaliya on 02/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import APESuperHUD

class CreateEventStep5VC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var btnPreview: UIButton!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var tblAttributes: UITableView!
    @IBOutlet var constNoteViewHeight: NSLayoutConstraint!
    @IBOutlet var viewServices: UIView!
    @IBOutlet var viewAddServices: UIView!
    @IBOutlet var btnEventServices: UIButton!
    @IBOutlet var constStartButtonHeight: NSLayoutConstraint!
    
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var arrAttributes = NSMutableArray()
    
    var isAllAttributeFulfilled = false
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print(dictCreateEventDetail)
        
        if dictCreateEventDetail.value(forKey: "EventAttributes") != nil {
            arrAttributes = dictCreateEventDetail.value(forKey: "EventAttributes") as! NSMutableArray
            
        }else{
            self.createAttributes()
        }
        if dictCreateEventDetail.value(forKey: "EventServices") != nil {
            
            _ = ProjectUtilities.setUpIconsForServices(arrServices: dictCreateEventDetail.value(forKey: "EventServices") as! NSMutableArray, viewDragable: viewServices, size: 50)
            viewServices.bringSubview(toFront: btnEventServices)
        }
        
        tblAttributes.reloadData()
        
        self.checkAttributeValidation()
        
        self.rdv_tabBarController.setTabBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initialization
    func initialization() {
        btnPreview.layer.cornerRadius = 10
        
        tblAttributes.rowHeight  = UITableViewAutomaticDimension
        tblAttributes.estimatedRowHeight = 80
    }
    
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        if viewControllers.count > 2 {
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 6], animated: true)
        }else{
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnPreviewAction (_ sender: UIButton) {
        self.performSegue(withIdentifier: "previewEventProfileSegue", sender: nil)
    }
    
    @IBAction func btnOptionalInformationAction (_ sender: UIButton) {
        self.performSegue(withIdentifier: "optionalInformationSegue", sender: nil)
    }
    
    @IBAction func btnStartAction (_ sender: UIButton) {
        
        if dictCreateEventDetail.value(forKey: "Status") as! String == "Incomplete" {
            
            if dictCreateEventDetail.value(forKey: "SourcingOption") as! String == "Don't use Eventperk sourcing" {
                dictCreateEventDetail.setValue("Snoozed", forKey: "Status")
            }else{
                dictCreateEventDetail.setValue("Inprogress", forKey: "Status")
            }
        }
        
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
        EventProfile.insertUpdateEventData(dictEventDetail: dictCreateEventDetail) { (errors: [NSError]?) in
            
            APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
            if errors == nil {
                
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                if viewControllers.count > 2 {
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 6], animated: true)
                }else{
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    //MARK:- Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrAttributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        let cell:AttributesTableCell = tableView.dequeueReusableCell(withIdentifier: "AttributesTableCell", for: indexPath as IndexPath) as! AttributesTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let dictRowData = arrAttributes.object(at: indexPath.row) as! NSMutableDictionary
        
        var isNeedToSetDefaultTitle = false
        
        if (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Event Description" {
            if dictCreateEventDetail.value(forKey: "EventTitle") != nil  {
                cell.lblAttributeName.text = dictCreateEventDetail.value(forKey: "EventTitle") as? String
                cell.lblAttributeDescription.text = dictRowData.value(forKey: "DescriptionWhenAttributeChanged") as? String
                
                isNeedToSetDefaultTitle = true
            }
        }else if (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Event Budget" {
            
            if dictCreateEventDetail.value(forKey: "TotalEventBudget") != nil  {
                cell.lblAttributeName.text = "$\(dictCreateEventDetail.value(forKey: "TotalEventBudget") as! String) SGD"
                cell.lblAttributeDescription.text = dictRowData.value(forKey: "BudgetWhenAttributeChanged") as? String
                
                isNeedToSetDefaultTitle = true
            }
        }else if (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Event Date and Duration" {
            
            if dictCreateEventDetail.value(forKey: "EventStartDate") != nil {
                cell.lblAttributeName.text = (ProjectUtilities.changeDateFormate(strDate: dictCreateEventDetail.value(forKey: "EventStartDate") as! String, strFormatter1: "MMM dd, yyyy hh:mm a", strFormatter2: "MMM dd, yyyy") as String) + " at " + (ProjectUtilities.changeDateFormate(strDate: dictCreateEventDetail.value(forKey: "EventStartDate") as! String, strFormatter1: "MMM dd, yyyy hh:mm a", strFormatter2: "hh:mm a") as String)
                cell.lblAttributeDescription.text = dictRowData.value(forKey: "DateWhenAttributeChanged") as? String
                
                isNeedToSetDefaultTitle = true
            }
        }
        else if (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Event Venue" {
            
            if dictCreateEventDetail.value(forKey: "VenueLocation") != nil {
                cell.lblAttributeName.text = dictCreateEventDetail.value(forKey: "VenueLocation") as? String
                cell.lblAttributeDescription.text = dictRowData.value(forKey: "VenueWhenAttributeChanged") as? String
                
                isNeedToSetDefaultTitle = true
            }
        }else if (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Sourcing Settings" {
            
            if dictCreateEventDetail.value(forKey: "SourcingOption") != nil {
                cell.lblAttributeName.text = dictCreateEventDetail.value(forKey: "SourcingOption") as? String
                cell.lblAttributeDescription.text = dictRowData.value(forKey: "SorurcingWhenAttributeChanged") as? String
                
                isNeedToSetDefaultTitle = true
            }
        }
        
        if isNeedToSetDefaultTitle == false {
            cell.lblAttributeName.text = dictRowData.value(forKey: "AttributeTitle") as? String
            cell.lblAttributeDescription.text = dictRowData.value(forKey: "AttributeDescription") as? String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Event Description" {
            
            self.performSegue(withIdentifier: "eventDescriptionSegue", sender: nil)
        }else if (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Event Budget" {
                
            self.performSegue(withIdentifier: "eventTotalBudgetSegue", sender: nil)
        }else if (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Event Date and Duration" {
            
            self.performSegue(withIdentifier: "dateAndDurationSegue", sender: nil)
        }else if (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Event Venue" {
            
            self.performSegue(withIdentifier: "venueLocationSegue", sender: nil)
        }else if (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Sourcing Settings" {
            
            self.performSegue(withIdentifier: "sourcingOptionsSegue", sender: nil)
        }
    }
    
    //MARK:- Create Attribute Array
    func createAttributes() {
        var dictAttribute = NSMutableDictionary()
        dictAttribute.setValue("Event Description", forKey: "AttributeTitle")
        dictAttribute.setValue("Input name and highlights of your event", forKey: "AttributeDescription")
        dictAttribute.setValue("Edit name and highlights of your event", forKey: "DescriptionWhenAttributeChanged")
        arrAttributes.add(dictAttribute)
        
        dictAttribute = NSMutableDictionary()
        dictAttribute.setValue("Event Budget", forKey: "AttributeTitle")
        dictAttribute.setValue("input budget for your event or each services", forKey: "AttributeDescription")
        dictAttribute.setValue("Edit budget of event and each services", forKey: "BudgetWhenAttributeChanged")
        arrAttributes.add(dictAttribute)
        
        dictAttribute = NSMutableDictionary()
        dictAttribute.setValue("Event Date and Duration", forKey: "AttributeTitle")
        dictAttribute.setValue("Input day and time of your event", forKey: "AttributeDescription")
        dictAttribute.setValue("Edit date and time of your event", forKey: "DateWhenAttributeChanged")
        arrAttributes.add(dictAttribute)
        
        if dictCreateEventDetail.value(forKey: "HaveVenue") as! String == "Yes" {
            dictAttribute = NSMutableDictionary()
            dictAttribute.setValue("Event Venue", forKey: "AttributeTitle")
            dictAttribute.setValue("Input the location of your event venue", forKey: "AttributeDescription")
            dictAttribute.setValue("Only tendered vendors are able to view address", forKey: "VenueWhenAttributeChanged")
            arrAttributes.add(dictAttribute)
        }
        
        dictAttribute = NSMutableDictionary()
        dictAttribute.setValue("Sourcing Settings", forKey: "AttributeTitle")
        dictAttribute.setValue("Other vendors must send engagement requests", forKey: "AttributeDescription")
        dictAttribute.setValue("Edit sourcing setting", forKey: "SorurcingWhenAttributeChanged")
        arrAttributes.add(dictAttribute)
        
        dictCreateEventDetail.setValue(arrAttributes, forKey: "EventAttributes")
    }
    
    //MARK:- Attribute Validation
    
    func checkAttributeValidation() {
        
        isAllAttributeFulfilled = true
        var isNeedToSetNoteView = true
        
        if dictCreateEventDetail.value(forKey: "EventServices") == nil {
            
            isAllAttributeFulfilled = false
            
        }else if ProjectUtilities.checkForServices(arrServices: dictCreateEventDetail.value(forKey: "EventServices") as! NSMutableArray) == false {
            
            isAllAttributeFulfilled = false
        }else{
            isNeedToSetNoteView = false
        }
        
        if dictCreateEventDetail.value(forKey: "EventTitle") == nil {
            isAllAttributeFulfilled = false
        }else{
            isNeedToSetNoteView = false
        }
        
        if dictCreateEventDetail.value(forKey: "TotalEventBudget") == nil  {
            isAllAttributeFulfilled = false
        }else{
            isNeedToSetNoteView = false
        }
        
        if dictCreateEventDetail.value(forKey: "EventStartDate") == nil  {
            isAllAttributeFulfilled = false
        }else{
            isNeedToSetNoteView = false
        }
        if dictCreateEventDetail.value(forKey: "EventEndDate") == nil  {
            isAllAttributeFulfilled = false
        }else{
            isNeedToSetNoteView = false
        }
        
        if dictCreateEventDetail.value(forKey: "HaveVenue") as! String == "Yes" && dictCreateEventDetail.value(forKey: "VenueLocation") == nil {
            
            isAllAttributeFulfilled = false
        }else{
            isNeedToSetNoteView = false
        }
        
        if dictCreateEventDetail.value(forKey: "SourcingOption") == nil {
            isAllAttributeFulfilled = false
        }else{
            isNeedToSetNoteView = false
        }
        
        if isAllAttributeFulfilled == true {
            constStartButtonHeight.constant = 40
        }else{
            constStartButtonHeight.constant = 0
        }
        
        if isNeedToSetNoteView == true{
            constNoteViewHeight.constant = 63.5
        }else{
            constNoteViewHeight.constant = 0
        }
    }
    
    //MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "eventDescriptionSegue" {
            let vc: EventDescriptionVC = segue.destination as! EventDescriptionVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "eventServiceListSegue" {
            let vc: EventServiceListVC = segue.destination as! EventServiceListVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "eventTotalBudgetSegue" {
            let vc: EventTotalBudgetVC = segue.destination as! EventTotalBudgetVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "dateAndDurationSegue" {
            let vc: EventDateAndDurationVC = segue.destination as! EventDateAndDurationVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "venueLocationSegue" {
            let vc: EventVenueLocationVC = segue.destination as! EventVenueLocationVC
            vc.dictCreateEventDetail = dictCreateEventDetail
//            vc.isFromCreateEventStep5 = true
        }else if segue.identifier == "optionalInformationSegue" {
            let vc: EventOptionalInformation = segue.destination as! EventOptionalInformation
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "sourcingOptionsSegue" {
            let vc: SourcingOptionsVC = segue.destination as! SourcingOptionsVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "previewEventProfileSegue" {
            let vc: PreviewEventProfileVC = segue.destination as! PreviewEventProfileVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }
    }
}

class AttributesTableCell: UITableViewCell {
    
    @IBOutlet var lblAttributeName: UILabel!
    @IBOutlet var lblAttributeDescription: UILabel!
}
