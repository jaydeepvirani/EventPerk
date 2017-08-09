//
//  EventOptionalInformation.swift
//  Eventperk
//
//  Created by Bhavik iOS Developer on 09/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class EventOptionalInformation: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var btnPermenentlyDeactivateAccount: UIButton!
    
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
        
        btnPermenentlyDeactivateAccount.layer.cornerRadius = 20
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPermenantlyDeactivateEventAction (_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "eventDetailVC" {
            
            let vc: EventDetailsVC = segue.destination as! EventDetailsVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "eventCharacteristicsSegue" {
            
            let vc: EventCharacteristicsVC = segue.destination as! EventCharacteristicsVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }
    }
}
