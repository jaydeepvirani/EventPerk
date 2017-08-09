//
//  EventCharacteristicsVC.swift
//  Eventperk
//
//  Created by Bhavik iOS Developer on 09/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

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
        lblCounty.text = dictCreateEventDetail.value(forKey: "Country") as? String
        lblGuest.text = dictCreateEventDetail.value(forKey: "NumberOfGuest") as? String
        lblVenue.text = dictCreateEventDetail.value(forKey: "HaveVenue") as? String
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
