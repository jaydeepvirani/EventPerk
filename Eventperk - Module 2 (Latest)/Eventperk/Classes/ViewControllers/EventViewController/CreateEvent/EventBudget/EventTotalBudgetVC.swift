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
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    
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
        }
        
        viewEventBudget.layer.borderWidth = 1
        viewEventBudget.layer.borderColor = UIColor.init(red: 95.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1.0).cgColor
    }
    
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Attributed String
    func attributedString() {
        var font = UIFont.boldSystemFont(ofSize: 14.0)
        var attrsDictionary: [AnyHashable: Any] = [NSFontAttributeName : font]
        let attrString = NSMutableAttributedString(string: "Total Budget Tip:", attributes: attrsDictionary as? [String : Any] ?? [String : Any]())
        font = UIFont.systemFont(ofSize: 14.0)
        attrsDictionary = [ NSFontAttributeName : font]
        let newAttString = NSMutableAttributedString(string: " $0.00 SGD", attributes: attrsDictionary as? [String : Any] ?? [String : Any]())
        
        attrString.append(newAttString)
    }
}
