//
//  EventViewController.swift
//  Eventperk
//
//  Created by HARSHIT on 21/04/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSMobileHubHelper
import APESuperHUD

class EventViewController: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var viewEvent: UIView!
    @IBOutlet var viewNavigationBar: UIView!
    @IBOutlet var tblEventList: UITableView!
    
    //MARK: No Events
    @IBOutlet var viewNoEventView: UIView!
    @IBOutlet var imgAppIcon: UIImageView!
    @IBOutlet var btnCreateEvent: UIButton!
    
    //MARK: Other
    var arrEventList = NSMutableArray()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.rdv_tabBarController.setTabBarHidden(false, animated: true)
        
        viewNoEventView.isHidden = true
        viewEvent.isHidden = true
        self.getEventList()
    }
    
    //MARK:- Initialization
    func initialization() {
        imgAppIcon.layer.shadowRadius = 4
        imgAppIcon.layer.shadowOffset = CGSize.init(width: 0, height: 8)
        imgAppIcon.layer.shadowColor = UIColor.black.cgColor
        imgAppIcon.layer.shadowOpacity = 0.75
        
        btnCreateEvent.layer.borderColor = UIColor.white.cgColor
        btnCreateEvent.layer.borderWidth = 1.0
        btnCreateEvent.layer.cornerRadius = 23.0
    }
    
    //MARK:- AWS Call
    
    func getEventList() {
        
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
        EventProfile.getEventList({ (response: NSMutableArray, success:Bool) in
            print(response)
            
            APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
            
            if success {
                self.viewNoEventView.isHidden = true
                self.viewEvent.isHidden = false
                self.arrEventList = response.mutableCopy() as! NSMutableArray
                self.tblEventList.reloadData()
            }else {
                self.viewNoEventView.isHidden = false
                self.viewEvent.isHidden = true
            }
        })
    }
    
    //MARK:- Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrEventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        let cell:EventListTableCell = tableView.dequeueReusableCell(withIdentifier: "EventListTableCell", for: indexPath as IndexPath) as! EventListTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let dict = arrEventList.object(at: indexPath.row) as! NSMutableDictionary
        
        if dict.value(forKey: "EventTitle") != nil {
            
            cell.lblTitle.text = dict.value(forKey: "EventTitle") as? String
        }else{
            cell.lblTitle.text = "Event \(indexPath.row+1)"
        }
        
        if dict.value(forKey: "EventServices") != nil {
            _ = ProjectUtilities.setUpIconsForServices(arrServices: dict.value(forKey: "EventServices") as! NSMutableArray, viewDragable: cell.viewServices, size: 40)
        }else{
            _ = ProjectUtilities.setUpIconsForServices(arrServices: NSMutableArray(), viewDragable: cell.viewServices, size: 40)
        }
        
        cell.lblDescription.textColor = UIColor.black
        if dict.value(forKey: "Status") as! String == "Incomplete" {
            let intStepsCount = self.findRemainingSteps(dict: dict)
            
            if intStepsCount == 0 {
                cell.lblDescription.text = "Completed: Ready"
            }else {
                
                if intStepsCount == 1 {
                    cell.lblDescription.text = "Incomplete: \(intStepsCount) Step Left"
                }else{
                    cell.lblDescription.text = "Incomplete: \(intStepsCount) Steps Left"
                }
            }
        }else if dict.value(forKey: "Status") as! String == "Inprogress" {
            cell.lblDescription.text = "Completed: Sourcing"
            
        }else if dict.value(forKey: "Status") as! String == "Snoozed" {
            cell.lblDescription.text = "Completed: Snoozed Till \(ProjectUtilities.changeDateFormate(strDate: dict.value(forKey: "SnoozeTo") as! String, strFormatter1: "dd MMMM yyyy", strFormatter2: "dd MMM yyyy"))"
            
            cell.lblDescription.textColor = UIColor.red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        let dict = arrEventList.object(at: indexPath.row) as! NSMutableDictionary
        
        if dict.value(forKey: "Status") as! String == "Incomplete" {
            self.performSegue(withIdentifier: "createEventStep5Segue", sender: indexPath.row)
        }else if dict.value(forKey: "Status") as! String == "Inprogress" || dict.value(forKey: "Status") as! String == "Snoozed" {
            self.performSegue(withIdentifier: "eventDetailSegue", sender: indexPath.row)
        }
    }
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createEventStep5Segue" {
            
            let vc: CreateEventStep5VC = segue.destination as! CreateEventStep5VC
            vc.dictCreateEventDetail = arrEventList.object(at: sender as! Int) as! NSMutableDictionary
        }else if segue.identifier == "eventDetailSegue" {
            
            let vc: EventDetailVC = segue.destination as! EventDetailVC
            vc.dictCreateEventDetail = arrEventList.object(at: sender as! Int) as! NSMutableDictionary
        }
    }
    
    // MARK:- Validation
    
    func findRemainingSteps(dict: NSMutableDictionary) -> NSInteger {
        
        var intStepsCount = 0
        if dict.value(forKey: "EventServices") == nil {
            intStepsCount = intStepsCount + 1
        }else if ProjectUtilities.checkForServices(arrServices: dict.value(forKey: "EventServices") as! NSMutableArray) == false {
            intStepsCount = intStepsCount + 1
        }
        
        if dict.value(forKey: "EventTitle") == nil {
            intStepsCount = intStepsCount + 1
        }
        
        if dict.value(forKey: "TotalEventBudget") == nil  {
            intStepsCount = intStepsCount + 1
        }
        
        if dict.value(forKey: "EventStartDate") == nil && dict.value(forKey: "EventEndDate") == nil {
            intStepsCount = intStepsCount + 1
        }
        
        if dict.value(forKey: "HaveVenue") as! String == "Yes" && dict.value(forKey: "VenueLocation") == nil {
            intStepsCount = intStepsCount + 1
        }
        
        if dict.value(forKey: "SourcingOption") == nil {
            intStepsCount = intStepsCount + 1
        }
        
        return intStepsCount
    }
}

class EventListTableCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    @IBOutlet var viewServices: UIView!
}
