//
//  CreateEventStep5VC.swift
//  Eventperk
//
//  Created by Sandeep Gangajaliya on 02/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class CreateEventStep5VC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var btnPreview: UIButton!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var tblAttributes: UITableView!
    @IBOutlet var constNoteViewHeight: NSLayoutConstraint!
    @IBOutlet var viewServices: UIView!
    @IBOutlet var viewAddServices: UIView!
    @IBOutlet var btnEventServices: UIButton!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var arrAttributes = NSMutableArray()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print(dictCreateEventDetail)
        
        if dictCreateEventDetail.value(forKey: "EventAttributes") != nil {
            arrAttributes = dictCreateEventDetail.value(forKey: "EventAttributes") as! NSMutableArray
            
            if (arrAttributes.object(at: 0) as! NSMutableDictionary).value(forKey: "EventTitle") != nil {
                constNoteViewHeight.constant = 0
            }
        }else{
            self.createAttributes()
        }
        if dictCreateEventDetail.value(forKey: "EventServices") != nil {
            _ = ProjectUtilities.setUpIconsForServices(arrServices: dictCreateEventDetail.value(forKey: "EventServices") as! NSMutableArray, viewDragable: viewServices)
            constNoteViewHeight.constant = 0
            viewServices.bringSubview(toFront: btnEventServices)
        }
        
        tblAttributes.reloadData()
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
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOptionalInformationAction (_ sender: UIButton) {
        self.performSegue(withIdentifier: "optionalInformationSegue", sender: nil)
    }
    
    //MARK:- Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrAttributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        let cell:AttributesTableCell = tableView.dequeueReusableCell(withIdentifier: "AttributesTableCell", for: indexPath as IndexPath) as! AttributesTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let dictRowData = arrAttributes.object(at: indexPath.row) as! NSMutableDictionary
        
        if (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Event Description" {
            if dictRowData.value(forKey: "EventTitle") != nil  {
                cell.lblAttributeName.text = dictRowData.value(forKey: "EventTitle") as? String
                cell.lblAttributeDescription.text = dictRowData.value(forKey: "DescriptionWhenAttributeChanged") as? String
            }else{
                cell.lblAttributeName.text = dictRowData.value(forKey: "AttributeTitle") as? String
                cell.lblAttributeDescription.text = dictRowData.value(forKey: "AttributeDescription") as? String
            }
        }else if (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Event Budget" {
            
            if dictCreateEventDetail.value(forKey: "TotalEventBudget") != nil  {
                cell.lblAttributeName.text = "$\(dictCreateEventDetail.value(forKey: "TotalEventBudget") as! String) SGD"
                cell.lblAttributeDescription.text = dictRowData.value(forKey: "BudgetWhenAttributeChanged") as? String
            }else{
                cell.lblAttributeName.text = dictRowData.value(forKey: "AttributeTitle") as? String
                cell.lblAttributeDescription.text = dictRowData.value(forKey: "AttributeDescription") as? String
            }
            
        }else if (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Event Venue" {
            
            if dictCreateEventDetail.value(forKey: "VenueLocation") != nil {
                    cell.lblAttributeName.text = dictCreateEventDetail.value(forKey: "VenueLocation") as? String
                    cell.lblAttributeDescription.text = dictRowData.value(forKey: "VenueWhenAttributeChanged") as? String
            }else{
                cell.lblAttributeName.text = dictRowData.value(forKey: "AttributeTitle") as? String
                cell.lblAttributeDescription.text = dictRowData.value(forKey: "AttributeDescription") as? String
            }
        }
        else{
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
        }else if (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Event Venue" {
            
            self.performSegue(withIdentifier: "venueSegue", sender: nil)
        }else if (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as! String == "Sourcing Settings" {
            
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
        dictAttribute.setValue("Input budget for your event and each services", forKey: "AttributeDescription")
        dictAttribute.setValue("Edit budget of event and each services", forKey: "BudgetWhenAttributeChanged")
        arrAttributes.add(dictAttribute)
        
        dictAttribute = NSMutableDictionary()
        dictAttribute.setValue("Event Date and Duration", forKey: "AttributeTitle")
        dictAttribute.setValue("Input day and time of your event", forKey: "AttributeDescription")
        arrAttributes.add(dictAttribute)
        
        if dictCreateEventDetail.value(forKey: "HaveVenue") as! String == "true" {
            dictAttribute = NSMutableDictionary()
            dictAttribute.setValue("Event Venue", forKey: "AttributeTitle")
            dictAttribute.setValue("Input the location of your event venue", forKey: "AttributeDescription")
            dictAttribute.setValue("Only tendered vendors are able to view address", forKey: "VenueWhenAttributeChanged")
            arrAttributes.add(dictAttribute)
        }
        
        dictAttribute = NSMutableDictionary()
        dictAttribute.setValue("Sourcing Settings", forKey: "AttributeTitle")
        dictAttribute.setValue("Other vendors must send engagement requests", forKey: "AttributeDescription")
        arrAttributes.add(dictAttribute)
        
        dictCreateEventDetail.setValue(arrAttributes, forKey: "EventAttributes")
    }
    
    // MARK:- Segue
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
        }else if segue.identifier == "venueSegue" {
            let vc: CreateEventStep3VC = segue.destination as! CreateEventStep3VC
            vc.dictCreateEventDetail = dictCreateEventDetail
            vc.isFromCreateEventStep5 = true
        }else if segue.identifier == "optionalInformationSegue" {
            let vc: EventOptionalInformation = segue.destination as! EventOptionalInformation
            vc.dictCreateEventDetail = dictCreateEventDetail
        }
    }
}

class AttributesTableCell: UITableViewCell {
    
    @IBOutlet var lblAttributeName: UILabel!
    @IBOutlet var lblAttributeDescription: UILabel!
}
