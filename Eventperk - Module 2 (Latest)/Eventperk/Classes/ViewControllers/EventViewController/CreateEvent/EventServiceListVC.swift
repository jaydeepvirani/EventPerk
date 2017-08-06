//
//  EventServiceListVC.swift
//  Eventperk
//
//  Created by Bhavik iOS Developer on 04/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class EventServiceListVC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var tblService: UITableView!
    
    @IBOutlet var viewServicesIcon: UIView!
    
    @IBOutlet var constNoteViewHeight: NSLayoutConstraint!
    
    //MARK: Dragable View
    var snapX:CGFloat = 1.0 /// must be >= 1.0
    var snapY:CGFloat = 1.0 /// must be >= 1.0
    
    var threshold:CGFloat = 0.0 /// how far to move before dragging
    
    var selectedView: UIView? /// the guy we're dragging
    
    var shouldDragY = true /// drag in the Y direction?
    var shouldDragX = true /// drag in the X direction?
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var arrServiceList = NSMutableArray()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(dictCreateEventDetail)
        
        self.setUpServicesView()
    }
    
    //MARK:- Initialization
    func initialization() {
        btnSave.layer.cornerRadius = 10
        setupGestures()
        
        if dictCreateEventDetail.value(forKey: "EventServices") != nil {
            arrServiceList = (dictCreateEventDetail.value(forKey: "EventServices") as! NSMutableArray).mutableCopy() as! NSMutableArray
        }else{
            createServiceArray()
        }
    }
    
    //MARK:- Setup Dragable
    
    func setUpServicesView() {
        
        ProjectUtilities.setUpIconsForServices(arrServices: arrServiceList, viewDragable: viewServicesIcon)
        
        var valid = false
        
        for i in 0 ..< arrServiceList.count {
            if (arrServiceList.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") != nil {
                for _ in 0 ..< ((arrServiceList.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).count {
                    
                    valid = true
                    break
                }
            }
        }
        self.saveButtonValidation(isSelected: valid)
    }
    
    func setupGestures() {
        let pan = UIPanGestureRecognizer(target:self, action:#selector(self.pan(_:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        viewServicesIcon.addGestureRecognizer(pan)
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveAction (_ sender: UIButton) {
        
        if btnSave.isSelected == true {
            dictCreateEventDetail.setValue(arrServiceList, forKey: "EventServices")
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:- Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrServiceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        let cell:EventServiceListTableCell = tableView.dequeueReusableCell(withIdentifier: "EventServiceListTableCell", for: indexPath as IndexPath) as! EventServiceListTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.lblServiceTitle.text = (arrServiceList.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "ServiceTitle") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tblService.tag = indexPath.row
        self.performSegue(withIdentifier: "eventSubServiceListSegue", sender: nil)
    }
    
    //MARK:- Gesture
    
    func pan(_ rec:UIPanGestureRecognizer) {
        
        let p:CGPoint = rec.location(in: viewServicesIcon)
        var center:CGPoint = .zero
        
        switch rec.state {
        case .began:
            print("began")
            selectedView = viewServicesIcon.hitTest(p, with: nil)
            if selectedView != nil {
                viewServicesIcon.bringSubview(toFront: selectedView!)
            }
            
        case .changed:
            if let subview = selectedView {
                center = subview.center
                let distance = sqrt(pow((center.x - p.x), 2.0) + pow((center.y - p.y), 2.0))
                
                if subview is ServicesView {
                    if distance > threshold {
                        if shouldDragX {
                            subview.center.x = p.x - (p.x.truncatingRemainder(dividingBy: snapX))
                            if subview.frame.minX < 0 {
                                subview.frame = CGRect.init(x: 0, y: subview.frame.minY, width: subview.frame.size.width, height: subview.frame.size.height)
                            }
                            if subview.center.x + 20 > Constants.ScreenSize.SCREEN_WIDTH {
                                subview.frame = CGRect.init(x: Constants.ScreenSize.SCREEN_WIDTH-40, y: subview.frame.minY, width: subview.frame.size.width, height: subview.frame.size.height)
                            }
                        }
                        if shouldDragY {
                            subview.center.y = p.y - (p.y.truncatingRemainder(dividingBy: snapY))
                            if subview.frame.minY < 0 {
                                subview.frame = CGRect.init(x: subview.frame.minX, y: 0, width: subview.frame.size.width, height: subview.frame.size.height)
                            }
                            if subview.center.y + 20 > 200 {
                                subview.frame = CGRect.init(x: subview.frame.minX, y: 160, width: subview.frame.size.width, height: subview.frame.size.height)
                            }
                        }
                    }
                }
            }
            
        case .ended:
            print("ended")
            if let subview = selectedView {
                if subview is ServicesView {
                    // do whatever
                }
            }
            selectedView = nil
            
        case .possible:
            print("possible")
        case .cancelled:
            print("cancelled")
            selectedView = nil
        case .failed:
            print("failed")
            selectedView = nil
        }
    }
    
    //MARK:- Service Array
    func createServiceArray() {
        
        var dictService = NSMutableDictionary()
        dictService.setValue("Add Food & Bevrages Services", forKey: "ServiceTitle")
        dictService.setValue("Food & Bevrages Services", forKey: "SubServiceTitle")
        arrServiceList.add(dictService)
        
        dictService = NSMutableDictionary()
        dictService.setValue("Add Entertainment Services", forKey: "ServiceTitle")
        dictService.setValue("Entertainment Services", forKey: "SubServiceTitle")
        arrServiceList.add(dictService)
        
        dictService = NSMutableDictionary()
        dictService.setValue("Add Lifestyle Services", forKey: "ServiceTitle")
        dictService.setValue("Productivity Services", forKey: "SubServiceTitle")
        arrServiceList.add(dictService)
        
        dictService = NSMutableDictionary()
        dictService.setValue("Add Facility Services", forKey: "ServiceTitle")
        dictService.setValue("Facility Services", forKey: "SubServiceTitle")
        arrServiceList.add(dictService)
        
        if dictCreateEventDetail.value(forKey: "HaveVenue") as! String == "true" {
            dictService = NSMutableDictionary()
            dictService.setValue("Add Venue Services", forKey: "ServiceTitle")
            dictService.setValue("Venue Services", forKey: "SubServiceTitle")
            arrServiceList.add(dictService)
        }
    }
    
    func saveButtonValidation(isSelected: Bool) {
        
        if isSelected == true {
                
            btnSave.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
            btnSave.isSelected = true
            constNoteViewHeight.constant = 0
        }else{
            btnSave.backgroundColor = UIColor.red
            btnSave.isSelected = true
            constNoteViewHeight.constant = 46
        }
    }
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "likedEventServicesSegue" {
            
            let vc: LikedEventServicesVC = segue.destination as! LikedEventServicesVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "eventSubServiceListSegue" {
            
            let vc: EventSubServiceList = segue.destination as! EventSubServiceList
            vc.arrServiceList = arrServiceList
            vc.strSelectedSubService = (arrServiceList.object(at: tblService.tag) as! NSMutableDictionary).value(forKey: "SubServiceTitle") as! String
        }
    }
}

class EventServiceListTableCell: UITableViewCell {
    
    @IBOutlet var lblServiceTitle: UILabel!
}
