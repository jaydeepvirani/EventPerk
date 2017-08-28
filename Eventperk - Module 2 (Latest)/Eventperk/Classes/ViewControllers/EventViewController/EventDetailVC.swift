//
//  EventDetailVC.swift
//  Eventperk
//
//  Created by Sandeep on 26/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class EventDetailVC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var btnPreview: UIButton!
    @IBOutlet var btnEventServices: UIButton!
    
    @IBOutlet var viewServices: UIView!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblBudget: UILabel!
    @IBOutlet var lblStartDate: UILabel!
    @IBOutlet var lblEndDate: UILabel!
    @IBOutlet var lblVenueLocation: UILabel!
    @IBOutlet var lblTheEventTitle: UILabel!
    @IBOutlet var lblTheEvent: UILabel!
    @IBOutlet var lblTheItineraryTitle: UILabel!
    @IBOutlet var lblTheItinerary: UILabel!
    @IBOutlet var lblTheLogisticsTitle: UILabel!
    @IBOutlet var lblTheLogistics: UILabel!
    @IBOutlet var lblTheAdditionalTitle: UILabel!
    @IBOutlet var lblTheAdditional: UILabel!
    @IBOutlet var lblSoozed: UILabel!
    
    @IBOutlet var constVenueViewHeight: NSLayoutConstraint!
    @IBOutlet var constPostedViewHeight: NSLayoutConstraint!
    @IBOutlet var constSnoozedViewHeight: NSLayoutConstraint!
    
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rdv_tabBarController.setTabBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.initialization()
    }
    
    //MARK:- Initialization
    func initialization() {
        btnPreview.layer.cornerRadius = 10
        
        _ = ProjectUtilities.setUpIconsForServices(arrServices: dictCreateEventDetail.value(forKey: "EventServices") as! NSMutableArray, viewDragable: viewServices, size: 50)
        viewServices.bringSubview(toFront: btnEventServices)
        
        lblTitle.text = dictCreateEventDetail.value(forKey: "EventTitle") as? String
        lblDescription.text = dictCreateEventDetail.value(forKey: "EventDescription") as? String
        lblBudget.text = "$ \(dictCreateEventDetail.value(forKey: "TotalEventBudget") as! String) SGD"
        
        lblStartDate.text = ProjectUtilities.changeDateFormate(strDate: dictCreateEventDetail.value(forKey: "EventStartDate") as! String, strFormatter1: "MMM dd, yyyy hh:mm a", strFormatter2: "dd/MM/yyyy, hh:mm a") as String
        lblEndDate.text = ProjectUtilities.changeDateFormate(strDate: dictCreateEventDetail.value(forKey: "EventEndDate") as! String, strFormatter1: "MMM dd, yyyy hh:mm a", strFormatter2: "dd/MM/yyyy, hh:mm a") as String
        
        if dictCreateEventDetail.value(forKey: "HaveVenue") as! String == "Yes" &&  dictCreateEventDetail.value(forKey: "VenueLocation") != nil {
            lblVenueLocation.text = dictCreateEventDetail.value(forKey: "VenueLocation") as? String
            constVenueViewHeight.constant = 57
        }else{
            lblVenueLocation.text = "No venue"
            constVenueViewHeight.constant = 0
        }
        
        if dictCreateEventDetail.value(forKey: "TheEvent") != nil {
            
            lblTheEventTitle.text = "\nThe Event:"
            lblTheEvent.text = dictCreateEventDetail.value(forKey: "TheEvent") as? String
        }else{
            lblTheEventTitle.text = ""
            lblTheEvent.text = ""
        }
        if dictCreateEventDetail.value(forKey: "TheItinerary") != nil {
            lblTheItineraryTitle.text = "\nVendor Access:"
            lblTheItinerary.text = dictCreateEventDetail.value(forKey: "TheItinerary") as? String
        }else{
            lblTheItineraryTitle.text = ""
            lblTheItinerary.text = ""
        }
        if dictCreateEventDetail.value(forKey: "TheLogistics") != nil {
            lblTheLogisticsTitle.text = "\nInteraction with Vendors:"
            lblTheLogistics.text = dictCreateEventDetail.value(forKey: "TheLogistics") as? String
        }else{
            lblTheLogisticsTitle.text = ""
            lblTheLogistics.text = ""
        }
        if dictCreateEventDetail.value(forKey: "TheAdditional") != nil {
            lblTheAdditionalTitle.text = "\nOther Information to Note:"
            lblTheAdditional.text = dictCreateEventDetail.value(forKey: "TheAdditional") as? String
        }else{
            lblTheAdditionalTitle.text = ""
            lblTheAdditional.text = ""
        }
        
        if dictCreateEventDetail.value(forKey: "SnoozeFrom") != nil {
            
            lblSoozed.text = ((((ProjectUtilities.changeDateFormate(strDate: dictCreateEventDetail.value(forKey: "SnoozeFrom") as! String, strFormatter1: "dd MMMM yyyy", strFormatter2: "dd MMM")) as String) as String) as String) + " - " + ((ProjectUtilities.changeDateFormate(strDate: dictCreateEventDetail.value(forKey: "SnoozeTo") as! String, strFormatter1: "dd MMMM yyyy", strFormatter2: "dd MMM")) as String)
            
        }else{
            lblSoozed.text = ""
        }
        
        if dictCreateEventDetail.value(forKey: "Status") as! String == "Snoozed" {
            constSnoozedViewHeight.constant = 41
            constPostedViewHeight.constant = 0
        }else{
            constSnoozedViewHeight.constant = 0
            constPostedViewHeight.constant = 41
        }
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnVenueLocationAction (_ sender: UIButton) {
        if dictCreateEventDetail.value(forKey: "HaveVenue") as! String == "Yes" &&  dictCreateEventDetail.value(forKey: "VenueLocation") != nil  {
            
            self.performSegue(withIdentifier: "venueSegue", sender: nil)
        }
    }
    
    //MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "previewEventProfileSegue" {
            let vc: PreviewEventProfileVC = segue.destination as! PreviewEventProfileVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "eventServiceListSegue" {
            let vc: EventServiceListVC = segue.destination as! EventServiceListVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "eventDescriptionSegue" {
            let vc: EventDescriptionVC = segue.destination as! EventDescriptionVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "eventTotalBudgetSegue" {
            let vc: EventTotalBudgetVC = segue.destination as! EventTotalBudgetVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "dateAndDurationSegue" {
            let vc: EventDateAndDurationVC = segue.destination as! EventDateAndDurationVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "venueSegue" {
            let vc: CreateEventStep3VC = segue.destination as! CreateEventStep3VC
            vc.dictCreateEventDetail = dictCreateEventDetail
            vc.isFromCreateEventStep5 = true
        }else if segue.identifier == "sourcingOptionsSegue" {
            let vc: SourcingOptionsVC = segue.destination as! SourcingOptionsVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "optionalInformationSegue" {
            let vc: EventOptionalInformation = segue.destination as! EventOptionalInformation
            vc.dictCreateEventDetail = dictCreateEventDetail
            vc.isFromEventDetail = true
        }else if segue.identifier == "eventVisibilitySegue1" || segue.identifier == "eventVisibilitySegue2" {
            let vc: EventVisibilityVC = segue.destination as! EventVisibilityVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }
    }
}
