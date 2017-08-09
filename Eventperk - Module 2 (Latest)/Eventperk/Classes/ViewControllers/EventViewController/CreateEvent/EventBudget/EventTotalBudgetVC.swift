//
//  EventTotalBudgetVC.swift
//  Eventperk
//
//  Created by CIZO on 07/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class EventTotalBudgetVC: UIViewController, UITextFieldDelegate {

    //MARK:- Outlet Declaration
    @IBOutlet var viewServices: UIView!
    @IBOutlet var viewEventBudget: UIView!
    @IBOutlet var constNoteViewHeight: NSLayoutConstraint!
    
    @IBOutlet var btnSave: UIButton!
    
    @IBOutlet var txtBudget: UITextField!
    @IBOutlet var lblTotalBudget: UILabel!
    @IBOutlet var lblSetTotalEventBudget: UILabel!
    
    @IBOutlet var viewNext: UIView!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var imgNext: UIImageView!
    
    @IBOutlet var viewBack: UIView!
    @IBOutlet var btnBack: UIButton!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var dictEventBudget = NSMutableDictionary()
    var strBudgetCurrentState = "Total Budget"
    
    var arrViewServices = NSMutableArray()
    
    var selectedServiceView: ServicesView?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initialization
    func initialization() {
        
        if dictCreateEventDetail.value(forKey: "EventServices") != nil {
            arrViewServices = ProjectUtilities.setUpIconsForServices(arrServices: dictCreateEventDetail.value(forKey: "EventServices") as! NSMutableArray, viewDragable: viewServices)
            constNoteViewHeight.constant = 0
            self.totalAttributedString(strTipBudget: "1500")
        }else{
            self.totalAttributedString(strTipBudget: "0.00")
        }
        
        btnSave.layer.cornerRadius = 10
        
        viewEventBudget.layer.borderWidth = 1
        viewEventBudget.layer.borderColor = UIColor.init(red: 95.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1.0).cgColor
        
        self.setupTapGestures()
        self.setNextButtonState()
        
        viewBack.isHidden = true
        btnSave.isHidden = true
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextAction (_ sender: UIButton) {
        
        self.view.endEditing(true)
        if btnNext.isSelected == true {
            self.setBudgetValidation()
            viewNext.isHidden = true
            viewBack.isHidden = false
        }
    }
    
    @IBAction func btnBackBudgetAction (_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        viewNext.isHidden = false
        viewBack.isHidden = true
        txtBudget.text = dictEventBudget.value(forKey: "TotalEventBudget") as? String
        strBudgetCurrentState = "Total Budget"
        for i in 0 ..< arrViewServices.count {
            let view = (arrViewServices.object(at: i) as! ServicesView)
            view.layer.borderWidth = 0
        }
        
        lblTotalBudget.text = "Set a total event budget"
    }
    
    @IBAction func btnSaveAction (_ sender: UIButton) {
        
        
        dictCreateEventDetail.setValue(dictEventBudget.value(forKey:"TotalEventBudget") as! String, forKey: "TotalEventBudget")
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Gesture
    
    func setupTapGestures() {
        let pan = UITapGestureRecognizer(target:self, action:#selector(self.tapGesture(_:)))
        viewServices.addGestureRecognizer(pan)
    }
    
    func tapGesture(_ rec:UITapGestureRecognizer) {
      
        self.view.endEditing(true)
        if strBudgetCurrentState == "Individual Budget" {
            
            let p:CGPoint = rec.location(in: viewServices)
            
            var selectedView: UIView?
            selectedView = viewServices.hitTest(p, with: nil)
            
            if selectedView != nil {
                viewServices.bringSubview(toFront: selectedView!)
            }
            if let subview = selectedView {
                if subview is ServicesView {
                    
                    for i in 0 ..< arrViewServices.count {
                        let view = (arrViewServices.object(at: i) as! ServicesView)
                        view.layer.borderWidth = 0
                    }
                    selectedServiceView = subview as? ServicesView
                    if selectedServiceView?.layer.borderWidth == 1 {
                        selectedServiceView?.layer.borderWidth = 0
                    }else{
                        selectedServiceView?.layer.borderColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0).cgColor
                        selectedServiceView?.layer.borderWidth = 1
                        
                        txtBudget.text = "0"
                    }
                   self.budgetTypeAttributedString(strBudgetType: (selectedServiceView?.strServiceType)!)
                }
            }
        }
    }
    
    //MARK:- TextField Delegate
    @IBAction func textFielTextdDidChanged(_ sender: Any) {
        if strBudgetCurrentState == "Total Budget" {
            self.setNextButtonState()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if strBudgetCurrentState == "Individual Budget" {
            if selectedServiceView != nil {
                if txtBudget.text != "0" && txtBudget.text != "" {
                    dictEventBudget.setValue(txtBudget.text, forKey: (selectedServiceView?.strServiceType)!)
                    selectedServiceView?.strEventBudget = txtBudget.text!
                }
            }
            self.setBudgetValidation()
        }
    }
    
    //MARK:- Budget Validation
    func setBudgetValidation() {
        
        if strBudgetCurrentState == "Total Budget" {
            strBudgetCurrentState = "Individual Budget"
            dictEventBudget.setValue(txtBudget.text, forKey: "TotalEventBudget")
            txtBudget.text = "0"
            
            let view = (arrViewServices.object(at: 0) as! ServicesView)
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0).cgColor
            selectedServiceView = view
            self.budgetTypeAttributedString(strBudgetType: view.strServiceType)
        }else if strBudgetCurrentState == "Individual Budget"{
            
        }
        
        var isShowSaveButton = true
        for i in 0 ..< arrViewServices.count {
            let view = (arrViewServices.object(at: i) as! ServicesView)
            
            if view.strEventBudget == "" {
                isShowSaveButton = false
                break
            }
        }
        
        if dictEventBudget.value(forKey: "TotalEventBudget") != nil && dictEventBudget.value(forKey: "TotalEventBudget") as! String != "" && dictEventBudget.value(forKey: "TotalEventBudget") as! String != "0" && isShowSaveButton == true{
            
            btnSave.isHidden = false
        }else{
            btnSave.isHidden = true
        }
    }
    
    //MARK:- Set Next Button State
    func setNextButtonState() {
        
        viewNext.isHidden = false
        if dictCreateEventDetail.value(forKey: "EventServices") == nil {
            viewNext.isHidden = true
        }else if txtBudget.text == "0" || txtBudget.text == "" {
            btnNext.isSelected = false
            imgNext.backgroundColor = UIColor.red
        }else{
            btnNext.isSelected = true
            imgNext.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        }
    }
    
    //MARK:- Attributed String
    func totalAttributedString(strTipBudget: String) {
        var font = UIFont.systemFont(ofSize: 14.0)
        var attrsDictionary: [AnyHashable: Any] = [NSFontAttributeName : font]
        
        let attrString = NSMutableAttributedString(string: "Total Budget Tip:", attributes: attrsDictionary as? [String : Any] ?? [String : Any]())
        
        font = UIFont.boldSystemFont(ofSize: 14.0)
        attrsDictionary = [ NSFontAttributeName : font]
        var newAttString = NSMutableAttributedString(string: " $\(strTipBudget) SGD", attributes: attrsDictionary as? [String : Any] ?? [String : Any]())
        attrString.append(newAttString)
        
        font = UIFont.systemFont(ofSize: 14.0)
        attrsDictionary = [ NSFontAttributeName : font]
        newAttString = NSMutableAttributedString(string: " based on demand and successfully completed projects", attributes: attrsDictionary as? [String : Any] ?? [String : Any]())
        attrString.append(newAttString)
        
        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0), range: (attrString.string as NSString).range(of: " $\(strTipBudget) SGD"))
        
        lblTotalBudget.attributedText = attrString
    }
    
    func budgetTypeAttributedString(strBudgetType: String) {
        var font = UIFont.systemFont(ofSize: 14.0)
        var attrsDictionary: [AnyHashable: Any] = [NSFontAttributeName : font]
        
        let attrString = NSMutableAttributedString(string: "Set a ", attributes: attrsDictionary as? [String : Any] ?? [String : Any]())
        
        font = UIFont.systemFont(ofSize: 14.0)
        attrsDictionary = [ NSFontAttributeName : font]
        var newAttString = NSMutableAttributedString(string: strBudgetType, attributes: attrsDictionary as? [String : Any] ?? [String : Any]())
        attrString.append(newAttString)
        
        font = UIFont.systemFont(ofSize: 14.0)
        attrsDictionary = [ NSFontAttributeName : font]
        newAttString = NSMutableAttributedString(string: " budget", attributes: attrsDictionary as? [String : Any] ?? [String : Any]())
        attrString.append(newAttString)
        
        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0), range: (attrString.string as NSString).range(of: strBudgetType))
        
        lblSetTotalEventBudget.attributedText = attrString
    }
}
