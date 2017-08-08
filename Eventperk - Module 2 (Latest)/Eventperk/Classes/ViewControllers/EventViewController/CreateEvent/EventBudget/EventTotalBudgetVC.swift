//
//  EventTotalBudgetVC.swift
//  Eventperk
//
//  Created by CIZO on 07/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class EventTotalBudgetVC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var viewServices: UIView!
    @IBOutlet var viewEventBudget: UIView!
    @IBOutlet var constNoteViewHeight: NSLayoutConstraint!
    
    @IBOutlet var lblTotalBudget: UILabel!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var selectedView: UIView?
    
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
            ProjectUtilities.setUpIconsForServices(arrServices: dictCreateEventDetail.value(forKey: "EventServices") as! NSMutableArray, viewDragable: viewServices)
            constNoteViewHeight.constant = 0
            
            self.totalAttributedString(strTipBudget: "1500")
        }else{
            self.totalAttributedString(strTipBudget: "0.00")
        }
        
        viewEventBudget.layer.borderWidth = 1
        viewEventBudget.layer.borderColor = UIColor.init(red: 95.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1.0).cgColor
        
        self.setupTapGestures()
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Gesture
    
    func setupTapGestures() {
        let pan = UITapGestureRecognizer(target:self, action:#selector(self.tapGesture(_:)))
        viewServices.addGestureRecognizer(pan)
    }
    
    func tapGesture(_ rec:UITapGestureRecognizer) {
        let p:CGPoint = rec.location(in: viewServices)
        selectedView = viewServices.hitTest(p, with: nil)
        if selectedView != nil {
            viewServices.bringSubview(toFront: selectedView!)
        }
        if let subview = selectedView {
            
            if subview is ServicesView {
                let view = subview as! ServicesView
                view.layer.borderColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0).cgColor
                view.layer.borderWidth = 1
            }
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
}
