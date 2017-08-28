//
//  EventVisibilityVC.swift
//  Eventperk
//
//  Created by Sandeep on 26/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import APESuperHUD

class EventVisibilityVC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var lblSnoozed: UILabel!
    
    @IBOutlet var imgCheckBox: UIImageView!
    @IBOutlet var imgArrowPosted: UIImageView!
    @IBOutlet var imgArrowSnoozed: UIImageView!
    
    @IBOutlet var btnPosted: UIButton!
    @IBOutlet var btnSnoozed: UIButton!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.initialization()
        
        print(dictCreateEventDetail)
    }
    
    //MARK:- Initialization
    func initialization() {
        
        if dictCreateEventDetail.value(forKey: "Status") as! String == "Snoozed" {
            
            imgCheckBox.isHidden = true
            imgArrowPosted.isHidden = false
            imgArrowSnoozed.isHidden = true
            
            if dictCreateEventDetail.value(forKey: "SnoozeFrom") != nil {
                lblSnoozed.text = ((((ProjectUtilities.changeDateFormate(strDate: dictCreateEventDetail.value(forKey: "SnoozeFrom") as! String, strFormatter1: "dd MMMM yyyy", strFormatter2: "dd MMM")) as String) as String) as String) + " - " + ((ProjectUtilities.changeDateFormate(strDate: dictCreateEventDetail.value(forKey: "SnoozeTo") as! String, strFormatter1: "dd MMMM yyyy", strFormatter2: "dd MMM")) as String)
            }else{
                lblSnoozed.text = ""
            }
            
            btnPosted.isEnabled = true
            btnSnoozed.isEnabled = false
            
        }else{
            imgCheckBox.isHidden = false
            imgArrowPosted.isHidden = true
            imgArrowSnoozed.isHidden = false
            
            lblSnoozed.text = ""
            
            btnPosted.isEnabled = false
            btnSnoozed.isEnabled = true
        }
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPostedAction (_ sender: UIButton) {
        
        dictCreateEventDetail.setValue("Inprogress", forKey: "Status")
        
        if dictCreateEventDetail.value(forKey: "SnoozeFrom") != nil {
            dictCreateEventDetail.removeObject(forKey: "SnoozeFrom")
            dictCreateEventDetail.removeObject(forKey: "SnoozeTo")
        }
        
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
        EventProfile.insertUpdateEventData(dictEventDetail: dictCreateEventDetail) { (errors: [NSError]?) in
            
            APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
            if errors == nil {
                
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func btnPermanentyDeactivateEventAction (_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to permenently deactivate posted event?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.default) { (action) in
            
            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
            EventProfile.removeEvent(eventId: self.dictCreateEventDetail.value(forKey: "id") as! String, completionHandler: { (errors: [NSError]?) in
                
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                if errors == nil {
                    
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
                }
            })
        })
        alert.addAction(UIAlertAction.init(title: "No", style: UIAlertActionStyle.cancel) { (action) in
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "eventSnoozedSegue" {
            let vc: EventSnoozedVC = segue.destination as! EventSnoozedVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }
    }
}
