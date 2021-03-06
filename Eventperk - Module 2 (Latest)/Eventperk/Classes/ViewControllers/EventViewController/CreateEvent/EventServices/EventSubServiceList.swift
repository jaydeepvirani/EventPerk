//
//  EventSubServiceList.swift
//  Eventperk
//
//  Created by Bhavik iOS Developer on 05/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class EventSubServiceList: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var lblSubServiceName: UILabel!
    
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var tblSubServiceList: UITableView!
    
    @IBOutlet var lblNotes: UILabel!
    @IBOutlet var constViewNotesHeight: NSLayoutConstraint!
    
    //MARK: Other Objects
    var arrServiceList = NSMutableArray()
    var arrSubServiceList = NSMutableArray()
    var strSelectedSubService = ""
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(arrServiceList)
        self.initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initialization
    func initialization() {
        
        lblSubServiceName.text = strSelectedSubService
        btnSave.layer.cornerRadius = 10
        
        let index = (arrServiceList.value(forKey: "SubServiceTitle") as AnyObject).index(of: strSelectedSubService)
        if index != NSNotFound {
            
            if (arrServiceList.object(at: index) as! NSMutableDictionary).value(forKey: "SubServices") != nil{
                
                arrSubServiceList = ((arrServiceList.object(at: index) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).mutableCopy() as! NSMutableArray
            }
        }
        if arrSubServiceList.count == 0 {
            self.createSubServiceArray()
        }
        self.saveButtonValidation()
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveAction (_ sender: UIButton) {
        
        if btnSave.isSelected == true {
            let index = (arrServiceList.value(forKey: "SubServiceTitle") as AnyObject).index(of: strSelectedSubService)
            if index != NSNotFound {
                
                (arrServiceList.object(at: index) as! NSMutableDictionary).setValue(arrSubServiceList, forKey: "SubServices")
            }
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Cell Event
    @IBAction func btnMinusAction (_ sender: UIButton) {
        
        var intItemCount = 0
        if (arrSubServiceList.object(at: sender.tag) as! NSMutableDictionary).value(forKey: "ItemCount") != nil && (arrSubServiceList.object(at: sender.tag) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger != 0 {
            
            intItemCount = (arrSubServiceList.object(at: sender.tag) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger - 1
            
            (arrSubServiceList.object(at: sender.tag) as! NSMutableDictionary).setValue(intItemCount, forKey: "ItemCount")
        }
        tblSubServiceList.reloadData()
        self.saveButtonValidation()
    }
    
    @IBAction func btnPlusAction (_ sender: UIButton) {
        
        var intItemCount = 0
        if (arrSubServiceList.object(at: sender.tag) as! NSMutableDictionary).value(forKey: "ItemCount") != nil {
            
            intItemCount = (arrSubServiceList.object(at: sender.tag) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger
        }
        
        intItemCount = intItemCount + 1
        (arrSubServiceList.object(at: sender.tag) as! NSMutableDictionary).setValue(intItemCount, forKey: "ItemCount")
        tblSubServiceList.reloadData()
        self.saveButtonValidation()
    }
    
    //MARK:- Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrSubServiceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        
        let cell:EventSubServiceListTableCell = tableView.dequeueReusableCell(withIdentifier: "EventSubServiceListTableCell", for: indexPath as IndexPath) as! EventSubServiceListTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.lblTitle.text = (arrSubServiceList.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "SubServiceTitle") as? String
        
        cell.imgSubServiceIcon.image = UIImage.init(named: (arrSubServiceList.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "SubServiceTitle") as! String)
        
        if (arrSubServiceList.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "ItemCount") != nil && (arrSubServiceList.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger != 0 {
            
            cell.imgSubServiceIcon.isHidden = true
            cell.lblItemCount.isHidden = false
            
            cell.lblItemCount.text = "\(((arrSubServiceList.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "ItemCount"))!)"
        }else{
            
            cell.imgSubServiceIcon.isHidden = false
            cell.lblItemCount.isHidden = true
        }
        
        cell.btnMinus.tag = indexPath.row
        cell.btnPlus.tag = indexPath.row
        
        cell.btnMinus.addTarget(self, action: #selector(self.btnMinusAction(_:)), for: UIControlEvents.touchUpInside)
        cell.btnPlus.addTarget(self, action: #selector(self.btnPlusAction(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    //MARK:- Sub Service Array
    func createSubServiceArray() {
        
        var dictService = NSMutableDictionary()
        if strSelectedSubService == "Food & Bevrages Services" {
            
            dictService.setValue("Buffets", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Beverages", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Cakes", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Desserts", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Live Cooking Stations", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Packed Meals", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            lblNotes.text = "If you need to different variations of services for example fruit juice and alcohol services, you have to select 2."
            
        }else if strSelectedSubService == "Entertainment Services" {
            
            dictService.setValue("Emcees", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Games and Activities", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Mascots", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Messages", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Music DJs", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Musicians", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Performances", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Photo Booths", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            lblNotes.text = "If you need to different variations of services for example bouncy castle and face painting services, you have to select 2."
            
        }else if strSelectedSubService == "Productivity Services" {
            
            dictService.setValue("Cleanings", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Decorations", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Favors and Gifts", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Hair and Makeup", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Photographers", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Printings", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Table and Chairs", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Videographers", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            lblNotes.text = "If you need to different variations of services for example area cleaning and washing services services, you have to select 2."
  
        }else if strSelectedSubService == "Facility Services" {
            
            dictService.setValue("Audio Visuals", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Barricades and Fencings", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Ground Protections", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Lightings", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Staging and Backdrops", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Tents", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            lblNotes.text = "If you need to different variations of services for example field ground and carpeted ground services, you have to select 2."
            
        }else if strSelectedSubService == "Venue Services" {
            
            dictService.setValue("Cafes", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Functions Halls", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Hotels and Villas", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Rental Houces", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            dictService = NSMutableDictionary()
            dictService.setValue("Resorts and Chalets", forKey: "SubServiceTitle")
            arrSubServiceList.add(dictService)
            
            lblNotes.text = "If you need to different variations of services for example cafe 1 for morning and cafe 2 for evening services, you have to select 2."
        }
    }
    
    //MARK:- Validations
    
    func saveButtonValidation() {
        
        for i in 0 ..< arrSubServiceList.count {
            if (arrSubServiceList.object(at: i) as! NSMutableDictionary).value(forKey: "ItemCount") != nil && (arrSubServiceList.object(at: i) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger != 0 {
                
                btnSave.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
                btnSave.isSelected = true
                constViewNotesHeight.constant = 0
                return
            }
        }
        btnSave.backgroundColor = UIColor.red
        btnSave.isSelected = true
        constViewNotesHeight.constant = 69.5
    }
}

class EventSubServiceListTableCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblItemCount: UILabel!
    
    @IBOutlet var imgSubServiceIcon: UIImageView!
    
    @IBOutlet var btnMinus: UIButton!
    @IBOutlet var btnPlus: UIButton!
}
