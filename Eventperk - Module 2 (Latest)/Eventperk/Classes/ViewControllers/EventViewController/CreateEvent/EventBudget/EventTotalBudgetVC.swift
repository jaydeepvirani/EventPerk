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
    
    @IBOutlet var txtBudget: UITextField!
    @IBOutlet var lblTotalBudget: UILabel!
    @IBOutlet var lblSetTotalEventBudget: UILabel!
    
    @IBOutlet var viewNext: UIView!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var imgNext: UIImageView!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var dictEventBudget = NSMutableDictionary()
    var strBudgetCurrentState = "Total Budget"
    var isEventTapGestureEnable = false
    
    var arrViewServices = NSMutableArray()
    
    var selectedView: UIView?
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
        
        viewEventBudget.layer.borderWidth = 1
        viewEventBudget.layer.borderColor = UIColor.init(red: 95.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1.0).cgColor
        
        self.setupTapGestures()
        self.setNextButtonState()
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextAction (_ sender: UIButton) {
        
        self.view.endEditing(true)
        if btnNext.isSelected == true {
            if strBudgetCurrentState == "Total Budget" {
                isEventTapGestureEnable = true
                strBudgetCurrentState = "Individual Budget"
                lblSetTotalEventBudget.text = "Set Individual budget"
            }else{
            }
        }
    }
    
    //MARK:- Gesture
    
    func setupTapGestures() {
        let pan = UITapGestureRecognizer(target:self, action:#selector(self.tapGesture(_:)))
        viewServices.addGestureRecognizer(pan)
    }
    
    func tapGesture(_ rec:UITapGestureRecognizer) {
        self.view.endEditing(true)
        
        if isEventTapGestureEnable == true {
            let p:CGPoint = rec.location(in: viewServices)
            selectedView = viewServices.hitTest(p, with: nil)
            if selectedView != nil {
                viewServices.bringSubview(toFront: selectedView!)
            }
            if let subview = selectedView {
                if subview is ServicesView {
                    
                    if strBudgetCurrentState == "Individual Budget" {
                        for i in 0 ..< arrViewServices.count {
                            
                            let view = (arrViewServices.object(at: i) as! ServicesView)
                            view.layer.borderWidth = 0
                        }
                    }
                    selectedServiceView = subview as? ServicesView
                    
                    if selectedServiceView?.layer.borderWidth == 1 {
                        selectedServiceView?.layer.borderWidth = 0
                    }else{
                        selectedServiceView?.layer.borderColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0).cgColor
                        selectedServiceView?.layer.borderWidth = 1
                    }
                    
                    lblTotalBudget.text = selectedServiceView?.strServiceType
                }
            }
        }
    }
    
    //MARK:- TextField Delegate
    @IBAction func textFielTextdDidChanged(_ sender: Any) {
        self.setNextButtonState()
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
