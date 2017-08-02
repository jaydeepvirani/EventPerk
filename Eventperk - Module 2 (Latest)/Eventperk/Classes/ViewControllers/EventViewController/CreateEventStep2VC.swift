//
//  CreateEventStep2VC.swift
//  Eventperk
//
//  Created by Sandeep Gangajaliya on 01/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class CreateEventStep2VC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var lblEventType: UILabel!
    @IBOutlet var tblSubEventList: UITableView!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var arrSubEventTitles = NSArray()
    
    
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
        lblEventType.text = "Great! What type of social \(dictCreateEventDetail.value(forKey: "EventType") as! String) event is this ?"
        
        if dictCreateEventDetail.value(forKey: "EventType") as! String == "Social" {
            arrSubEventTitles = ["Anniversary", "Birthday", "Ceremony", "Festival", "Reunion", "Theme", "Wedding", "Other"]
        }else{
            arrSubEventTitles = ["Conference", "Charity", "Dinner & Dance", "Expo & Launch", "Networking", "Trade Fair", "Seminar", "Other"]
        }
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrSubEventTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        let cell:CreateEventStep2TableCell = tableView.dequeueReusableCell(withIdentifier: "CreateEventStep2TableCell", for: indexPath as IndexPath) as! CreateEventStep2TableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.lblSubEventType.text = arrSubEventTitles.object(at: indexPath.row) as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
        dictCreateEventDetail.setValue(arrSubEventTitles.object(at: indexPath.row) as! String, forKey: "SubEventType")
        
        self.performSegue(withIdentifier: "createEventStep3Segue", sender: nil)
    }
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createEventStep3Segue" {
            
            let vc: CreateEventStep3VC = segue.destination as! CreateEventStep3VC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }
    }
}

class CreateEventStep2TableCell: UITableViewCell {
    
    @IBOutlet var lblSubEventType: UILabel!
}
