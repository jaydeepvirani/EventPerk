//
//  EventOptionalInformation.swift
//  Eventperk
//
//  Created by Bhavik iOS Developer on 09/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import APESuperHUD

class EventOptionalInformation: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var btnPermenentlyDeactivateAccount: UIButton!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var isFromEventDetail = false
    
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
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to permenently deactivate event?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.default) { (action) in
            
            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
            EventProfile.removeEvent(eventId: self.dictCreateEventDetail.value(forKey: "id") as! String, completionHandler: { (errors: [NSError]?) in
                
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                if errors == nil {
                    
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            
                    if viewControllers.count == 3 {
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                    }else{
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 7], animated: true)
                    }
                }
            })
        })
        alert.addAction(UIAlertAction.init(title: "No", style: UIAlertActionStyle.cancel) { (action) in
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "eventDetailVC" {
            
            let vc: EventDetailsVC = segue.destination as! EventDetailsVC
            vc.dictCreateEventDetail = dictCreateEventDetail
            vc.isFromEventDetail = isFromEventDetail
        }else if segue.identifier == "eventCharacteristicsSegue" {
            
            let vc: EventCharacteristicsVC = segue.destination as! EventCharacteristicsVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }
    }
}
