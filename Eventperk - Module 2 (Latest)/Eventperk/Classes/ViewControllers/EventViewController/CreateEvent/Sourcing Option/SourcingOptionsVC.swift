//
//  SourcingOptionsVC.swift
//  Eventperk
//
//  Created by Bhavik iOS Developer on 10/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import APESuperHUD

class SourcingOptionsVC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var lblSourcingOption: UILabel!
    
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnUseEventperkSorcing: UIButton!
    @IBOutlet var btnDontUseEventperkSorcing: UIButton!
    
    @IBOutlet var imgCheckBoxUseEventperkSorcing: UIImageView!
    @IBOutlet var imgCheckBoxDontUseEventperkSorcing: UIImageView!
    
    @IBOutlet var constNoteViewHeight: NSLayoutConstraint!
    @IBOutlet var constUserEventPerkViewHeight: NSLayoutConstraint!
    
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
        btnSave.layer.cornerRadius = 10.0
        constUserEventPerkViewHeight.constant = 0
        
        if dictCreateEventDetail.value(forKey: "SourcingOption") != nil{
            
            if dictCreateEventDetail.value(forKey: "SourcingOption") as! String == "Use Eventperk sourcing" {
                
                btnUseEventperkSorcing.isSelected = true
                imgCheckBoxUseEventperkSorcing.image = UIImage(named: "Checked_Checkbox_Line_Icon")
                constUserEventPerkViewHeight.constant = 277
                
            }else{
                btnDontUseEventperkSorcing.isSelected = true
                imgCheckBoxDontUseEventperkSorcing.image = UIImage(named: "Checked_Checkbox_Line_Icon")
                constUserEventPerkViewHeight.constant = 0
            }
            btnSave.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
            btnSave.isSelected = true
            
            constNoteViewHeight.constant = 0
        }
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveAction (_ sender: UIButton) {
        if btnSave.isSelected == true {
            
            var strSourcingOption = "Use Eventperk sourcing"
            if btnDontUseEventperkSorcing.isSelected == true{
                strSourcingOption = "Don't use Eventperk sourcing"
            }
            dictCreateEventDetail.setValue(strSourcingOption, forKey: "SourcingOption")
            
            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
            EventProfile.insertUpdateEventData(dictEventDetail: dictCreateEventDetail) { (errors: [NSError]?) in
                
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                if errors == nil {
                    
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func btnSelectOptionAction (_ sender: UIButton) {
        
        btnUseEventperkSorcing.isSelected = false
        btnDontUseEventperkSorcing.isSelected = false
        
        imgCheckBoxUseEventperkSorcing.image = UIImage(named: "Unchecked_Checkbox_Line_Icon")
        imgCheckBoxDontUseEventperkSorcing.image = UIImage(named: "Unchecked_Checkbox_Line_Icon")
        
        if sender.tag == 1 {
            btnUseEventperkSorcing.isSelected = true
            imgCheckBoxUseEventperkSorcing.image = UIImage(named: "Checked_Checkbox_Line_Icon")
            constUserEventPerkViewHeight.constant = 277
        }else{
            btnDontUseEventperkSorcing.isSelected = true
            imgCheckBoxDontUseEventperkSorcing.image = UIImage(named: "Checked_Checkbox_Line_Icon")
            constUserEventPerkViewHeight.constant = 0
        }
        
        btnSave.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        btnSave.isSelected = true
        
        constNoteViewHeight.constant = 0
    }
}
