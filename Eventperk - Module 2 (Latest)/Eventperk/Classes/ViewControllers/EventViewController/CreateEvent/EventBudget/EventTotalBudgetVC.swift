//
//  EventTotalBudgetVC.swift
//  Eventperk
//
//  Created by CIZO on 07/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import APESuperHUD

class EventTotalBudgetVC: UIViewController, UITextFieldDelegate {

    //MARK:- Outlet Declaration
    
    @IBOutlet var viewBudgetEntry: UIView!
    @IBOutlet var viewBudgetType: UIView!
    
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnSetTotalEventBudget: UIButton!
    @IBOutlet var btnSetIndividualServiceBudget: UIButton!
    
    @IBOutlet var viewServices: UIView!
    @IBOutlet var viewEventBudget: UIView!
    @IBOutlet var constNoteViewHeight: NSLayoutConstraint!
    
    @IBOutlet var lblBudgetTypeDescription: UILabel!
    
    @IBOutlet var txtBudget: UITextField!
    @IBOutlet var lblTotalBudget: UILabel!
    @IBOutlet var lblSetTotalEventBudget: UILabel!
    
    @IBOutlet var viewNext: UIView!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var imgNext: UIImageView!
    
    @IBOutlet var viewBack: UIView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var imgBack: UIImageView!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var arrServiceList = NSMutableArray()
    var arrViewServices = NSMutableArray()
    var intSelectedServiceIndex = 0
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
            arrViewServices = ProjectUtilities.setUpIconsForServices(arrServices: dictCreateEventDetail.value(forKey: "EventServices") as! NSMutableArray, viewDragable: viewServices, size: 50)
            constNoteViewHeight.constant = 0
            self.totalAttributedString(strTipBudget: "1500")
            txtBudget.isEnabled = true
            
            arrServiceList = (dictCreateEventDetail.value(forKey: "EventServices") as! NSMutableArray).mutableCopy() as! NSMutableArray
            
            self.setBudgetValidation()
            
            for i in 0 ..< arrViewServices.count  {
                
                let view = arrViewServices.object(at: i) as? ServicesView
                
                if view?.strEventBudget != "" {
                    
                    view?.layer.borderWidth = 1
                    view?.layer.borderColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0).cgColor
                }
            }
            
        }else{
            self.totalAttributedString(strTipBudget: "0.00")
            txtBudget.isEnabled = false
        }
        
        btnSave.layer.cornerRadius = 10
        
        viewEventBudget.layer.borderWidth = 1
        viewEventBudget.layer.borderColor = UIColor.init(red: 95.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1.0).cgColor
        
        self.setupTapGestures()
        
        viewBudgetEntry.isHidden = true
        
        btnSetTotalEventBudget.layer.cornerRadius = 20
        btnSetIndividualServiceBudget.layer.cornerRadius = 20
        
//        btnSetTotalEventBudget.layer.borderColor = UIColor.init(red: 255.0/255.0, green: 153.0/255.0, blue: 51.0/255.0, alpha: 1.0).cgColor
//        btnSetTotalEventBudget.layer.borderWidth = 1
        btnSetIndividualServiceBudget.layer.borderColor = UIColor.init(red: 255.0/255.0, green: 153.0/255.0, blue: 51.0/255.0, alpha: 1.0).cgColor
        btnSetIndividualServiceBudget.layer.borderWidth = 1
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextAction (_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if btnNext.isSelected == true {
            txtBudget.text = "0"
            self.setBudgetValidation()
            if intSelectedServiceIndex < arrViewServices.count-1 {
                intSelectedServiceIndex = intSelectedServiceIndex+1
            }
            
            selectedServiceView = (arrViewServices.object(at: intSelectedServiceIndex) as! ServicesView)
        }
        
        setNextButtonState()
        setBackButtonState()
        
        if selectedServiceView != nil {
            self.budgetTypeAttributedString(strBudgetType: (selectedServiceView?.strServiceType)!)
        }
    }
    
    @IBAction func btnBackBudgetAction (_ sender: UIButton) {
        
        self.view.endEditing(true)
        txtBudget.text = "0"
        if intSelectedServiceIndex != 0 {
            intSelectedServiceIndex = intSelectedServiceIndex-1
        }
        
        selectedServiceView = (arrViewServices.object(at: intSelectedServiceIndex) as! ServicesView)
        
        setNextButtonState()
        setBackButtonState()
        
        if selectedServiceView != nil {
            self.budgetTypeAttributedString(strBudgetType: (selectedServiceView?.strServiceType)!)
        }
    }
    
    @IBAction func btnSaveAction (_ sender: UIButton) {
        
        if btnSave.isSelected == true {
            
            
            if btnSetTotalEventBudget.isSelected == true {
                dictCreateEventDetail.setValue(txtBudget.text, forKey: "TotalEventBudget")
            }else{
                
                var intTotalEventBudget = 0
                for i in 0 ..< arrViewServices.count {
                    let view = (arrViewServices.object(at: i) as! ServicesView)
                    
                    if view.strEventBudget != "" {
                        intTotalEventBudget = intTotalEventBudget + Int(view.strEventBudget)!
                    }
                }
                dictCreateEventDetail.setValue("\(intTotalEventBudget)", forKey: "TotalEventBudget")
                dictCreateEventDetail.setValue(arrServiceList, forKey: "EventServices")
            }
            
            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
            EventProfile.insertUpdateEventData(dictEventDetail: dictCreateEventDetail) { (errors: [NSError]?) in
                
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                if errors == nil {
                    
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func btnSetBudgetTypeAction (_ sender: UIButton) {
        
        btnSetTotalEventBudget.isSelected = false
        btnSetIndividualServiceBudget.isSelected = false
        
        lblBudgetTypeDescription.text = "Give your event a budget and work with your means"
        
        if sender.tag == 1 {
            btnSetTotalEventBudget.isSelected = true
            btnSetTotalEventBudget.backgroundColor = UIColor.init(red: 255.0/255.0, green: 153.0/255.0, blue: 51.0/255.0, alpha: 1.0)
            btnSetIndividualServiceBudget.backgroundColor = UIColor.clear
            btnSetTotalEventBudget.layer.borderColor = UIColor.init(red: 255.0/255.0, green: 153.0/255.0, blue: 51.0/255.0, alpha: 1.0).cgColor
            btnSetTotalEventBudget.layer.borderWidth = 1
            
            if dictCreateEventDetail.value(forKey: "TotalEventBudget") != nil {
                
                txtBudget.text = dictCreateEventDetail.value(forKey: "TotalEventBudget") as? String
            }
            
        }else{
            btnSetTotalEventBudget.backgroundColor = UIColor.clear
            btnSetTotalEventBudget.layer.borderColor = UIColor.init(red: 255.0/255.0, green: 153.0/255.0, blue: 51.0/255.0, alpha: 1.0).cgColor
            btnSetTotalEventBudget.layer.borderWidth = 1
            btnSetIndividualServiceBudget.isSelected = true
            btnSetIndividualServiceBudget.backgroundColor = UIColor.init(red: 255.0/255.0, green: 153.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        }
        
        if sender.tag == 2 && arrViewServices.count != 0 {
            setNextButtonState()
            setBackButtonState()
            
            selectedServiceView = (arrViewServices.object(at: 0) as! ServicesView)
            
            if selectedServiceView != nil {
                self.budgetTypeAttributedString(strBudgetType: (selectedServiceView?.strServiceType)!)
                
                if selectedServiceView?.strEventBudget != "" {
                    txtBudget.text = selectedServiceView?.strEventBudget
                }else{
                    txtBudget.text = "0"
                }
            }
        }else{
//            viewBack.isHidden = true
//            viewNext.isHidden = true
        }
        
        viewBudgetType.isHidden = true
        viewBudgetEntry.isHidden = false
    }
    
    //MARK:- Gesture
    
    func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target:self, action:#selector(self.tapGesture(_:)))
        viewServices.addGestureRecognizer(tapGesture)
    }
    
    func tapGesture(_ rec:UITapGestureRecognizer) {
      
        self.view.endEditing(true)
        if btnSetIndividualServiceBudget.isSelected == true {
            
            let p:CGPoint = rec.location(in: viewServices)
            
            var selectedView: UIView?
            selectedView = viewServices.hitTest(p, with: nil)
            
            if selectedView != nil {
                viewServices.bringSubview(toFront: selectedView!)
            }
            if let subview = selectedView {
                if subview is ServicesView {
                    
                    selectedServiceView = subview as? ServicesView
                    
                    if selectedServiceView?.strEventBudget != "" {
                        txtBudget.text = selectedServiceView?.strEventBudget
                    }else{
                        txtBudget.text = "0"
                    }
                    
                    self.budgetTypeAttributedString(strBudgetType: (selectedServiceView?.strServiceType)!)
                    
                    intSelectedServiceIndex = (selectedView?.tag)!
                    
                    setNextButtonState()
                    setBackButtonState()
                }
            }
        }
    }
    
    //MARK:- TextField Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.text == "0" {
            
           textField.text = ""
        }
        return true
    }
    
    @IBAction func textFielTextdDidChanged(_ sender: Any) {
        if btnSetIndividualServiceBudget.isSelected == true {
            self.setNextButtonState()
            if selectedServiceView != nil {
                if txtBudget.text != "0" && txtBudget.text != "" {
                    selectedServiceView?.strEventBudget = txtBudget.text!
                    selectedServiceView?.layer.borderWidth = 1
                    selectedServiceView?.layer.borderColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0).cgColor
                }else{
                    selectedServiceView?.layer.borderWidth = 0
                }
            }
        }
        self.setBudgetValidation()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if btnSetIndividualServiceBudget.isSelected == true {
            if selectedServiceView != nil {
                
                (((arrServiceList.object(at: (selectedServiceView?.index)!) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: (selectedServiceView?.subIndex)!) as! NSMutableDictionary).setValue(textField.text, forKey: "Budget\(String(describing: (selectedServiceView?.intItemCountIndex)!))")
                
                selectedServiceView?.strEventBudget = txtBudget.text!
                
                if txtBudget.text != "0" && txtBudget.text != "" {
                    selectedServiceView?.layer.borderWidth = 1
                    selectedServiceView?.layer.borderColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0).cgColor
                    
                    return
                }
                selectedServiceView?.layer.borderWidth = 0
            }
        }
    }
    
    //MARK:- Budget Validation
    func setBudgetValidation() {
        
        var isShowSaveButton = false
        if btnSetTotalEventBudget.isSelected == true && txtBudget.text != "0" && txtBudget.text != "" {
            isShowSaveButton = true
        }else {
            for i in 0 ..< arrViewServices.count {
                let view = (arrViewServices.object(at: i) as! ServicesView)
                
                if view.strEventBudget == "" {
                    isShowSaveButton = false
                    break
                }
                isShowSaveButton = true
            }
        }
        
        if isShowSaveButton == true {
            btnSave.isSelected = true
            btnSave.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        }else{
            btnSave.isSelected = false
            btnSave.backgroundColor = UIColor.red
        }
    }
    
    //MARK:- Set Next Button State
    func setNextButtonState() {
        
        if intSelectedServiceIndex < arrViewServices.count - 1 {
//            viewNext.isHidden = false
            if txtBudget.text != "0" && txtBudget.text != "" {
                btnNext.isSelected = true
                imgNext.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
            }else{
                btnNext.isSelected = false
                imgNext.backgroundColor = UIColor.red
            }
        }else{
//            viewNext.isHidden = true
            btnNext.isSelected = false
            imgNext.backgroundColor = UIColor.red
        }
    }
    
    func setBackButtonState() {
        
//        if intSelectedServiceIndex != 0 {
//            viewBack.isHidden = false
//        }else{
//            viewBack.isHidden = true
//        }
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
