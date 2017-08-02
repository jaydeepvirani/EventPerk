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
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var arrAttributes = NSMutableArray()
    
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
        btnPreview.layer.cornerRadius = 8
        
        tblAttributes.rowHeight  = UITableViewAutomaticDimension
        tblAttributes.estimatedRowHeight = 80
        
        self.createAttributes()
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrAttributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        let cell:AttributesTableCell = tableView.dequeueReusableCell(withIdentifier: "AttributesTableCell", for: indexPath as IndexPath) as! AttributesTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.lblAttributeName.text = (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeTitle") as? String
        cell.lblAttributeDescription.text = (arrAttributes.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "AttributeDescription") as? String
        
        return cell
    }
    
    //MARK:- Create Attribute Array
    func createAttributes() {
        var dictAttribute = NSMutableDictionary()
        dictAttribute.setValue("Event Description", forKey: "AttributeTitle")
        dictAttribute.setValue("Input name and highlights of your event", forKey: "AttributeDescription")
        arrAttributes.add(dictAttribute)
        
        dictAttribute = NSMutableDictionary()
        dictAttribute.setValue("Event Budget", forKey: "AttributeTitle")
        dictAttribute.setValue("Input budget for your event and each services", forKey: "AttributeDescription")
        arrAttributes.add(dictAttribute)
        
        dictAttribute = NSMutableDictionary()
        dictAttribute.setValue("Event Date and Duration", forKey: "AttributeTitle")
        dictAttribute.setValue("Input day and time of your event", forKey: "AttributeDescription")
        arrAttributes.add(dictAttribute)
        
        if dictCreateEventDetail.value(forKey: "HaveVenue") as! String == "true" {
            dictAttribute = NSMutableDictionary()
            dictAttribute.setValue("Event Venue", forKey: "AttributeTitle")
            dictAttribute.setValue("Input the location of your event venue", forKey: "AttributeDescription")
            arrAttributes.add(dictAttribute)
        }
        
        dictAttribute = NSMutableDictionary()
        dictAttribute.setValue("Sourcing Settings", forKey: "AttributeTitle")
        dictAttribute.setValue("Other vendors must send engagement requests", forKey: "AttributeDescription")
        arrAttributes.add(dictAttribute)
    }
}

class AttributesTableCell: UITableViewCell {
    
    @IBOutlet var lblAttributeName: UILabel!
    @IBOutlet var lblAttributeDescription: UILabel!
}
