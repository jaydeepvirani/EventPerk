//
//  CreateEventStep1VC.swift
//  Eventperk
//
//  Created by Sandeep Gangajaliya on 31/07/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class CreateEventStep1VC: UIViewController {

    //MARK:- Outlet Declaration
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rdv_tabBarController.setTabBarHidden(true, animated: true)
        self.initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initialization
    func initialization() {
        
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEventTypeAction (_ sender: UIButton) {
        
        if sender.tag == 1{
            dictCreateEventDetail.setValue("Social", forKey: "EventType")
        }else{
            dictCreateEventDetail.setValue("Corporate", forKey: "EventType")
        }
    }
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createEventStep2Segue" {
            
            let vc: CreateEventStep2VC = segue.destination as! CreateEventStep2VC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }
    }
}
