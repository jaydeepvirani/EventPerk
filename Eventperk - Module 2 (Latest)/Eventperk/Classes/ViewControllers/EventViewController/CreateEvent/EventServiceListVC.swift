//
//  EventServiceListVC.swift
//  Eventperk
//
//  Created by Bhavik iOS Developer on 04/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class EventServiceListVC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var tblService: UITableView!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var arrServiceList = NSMutableArray()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dictCreateEventDetail)
        self.initialization()
        self.createServiceArray()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initialization
    func initialization() {
        btnSave.layer.cornerRadius = 10
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddFromLikesAction (_ sender: UIButton) {
        
    }
    
    //MARK:- Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrServiceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        let cell:EventServiceListTableCell = tableView.dequeueReusableCell(withIdentifier: "EventServiceListTableCell", for: indexPath as IndexPath) as! EventServiceListTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.lblServiceTitle.text = (arrServiceList.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "ServiceTitle") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tblService.tag = indexPath.row
        self.performSegue(withIdentifier: "eventSubServiceListSegue", sender: nil)
    }
    
    //MARK:- Service Array
    func createServiceArray() {
        
        var dictService = NSMutableDictionary()
        dictService.setValue("Add Food & Bevrages Services", forKey: "ServiceTitle")
        dictService.setValue("Food & Bevrages Services", forKey: "SubServiceTitle")
        arrServiceList.add(dictService)
        
        dictService = NSMutableDictionary()
        dictService.setValue("Add Entertainment Services", forKey: "ServiceTitle")
        dictService.setValue("Entertainment Services", forKey: "SubServiceTitle")
        arrServiceList.add(dictService)
        
        dictService = NSMutableDictionary()
        dictService.setValue("Add Lifestyle Services", forKey: "ServiceTitle")
        dictService.setValue("Lifestyle Services", forKey: "SubServiceTitle")
        arrServiceList.add(dictService)
        
        dictService = NSMutableDictionary()
        dictService.setValue("Add Facility Services", forKey: "ServiceTitle")
        dictService.setValue("Facility Services", forKey: "SubServiceTitle")
        arrServiceList.add(dictService)
        
        if dictCreateEventDetail.value(forKey: "HaveVenue") as! String == "true" {
            dictService = NSMutableDictionary()
            dictService.setValue("Add Venue Services", forKey: "ServiceTitle")
            dictService.setValue("Venue Services", forKey: "SubServiceTitle")
            arrServiceList.add(dictService)
        }
    }
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "likedEventServicesSegue" {
            
            let vc: LikedEventServicesVC = segue.destination as! LikedEventServicesVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "eventSubServiceListSegue" {
            
            let vc: EventSubServiceList = segue.destination as! EventSubServiceList
            vc.dictCreateEventDetail = dictCreateEventDetail
            vc.strSelectedSubService = (arrServiceList.object(at: tblService.tag) as! NSMutableDictionary).value(forKey: "SubServiceTitle") as! String
        }
    }
}

class EventServiceListTableCell: UITableViewCell {
    
    @IBOutlet var lblServiceTitle: UILabel!
}
