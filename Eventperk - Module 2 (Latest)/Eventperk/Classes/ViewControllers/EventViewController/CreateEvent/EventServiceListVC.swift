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
    
    //MARK: Dragable View
    var snapX:CGFloat = 40.0 /// must be >= 1.0
    var snapY:CGFloat = 40.0 /// must be >= 1.0
    
    var threshold:CGFloat = 0.0 /// how far to move before dragging
    
    var selectedView:UIView? /// the guy we're dragging
    
    var shouldDragY = true /// drag in the Y direction?
    var shouldDragX = true /// drag in the X direction?
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var arrServiceList = NSMutableArray()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dictCreateEventDetail)
        self.initialization()
        self.createServiceArray()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initialization
    func initialization() {
        btnSave.layer.cornerRadius = 10
        
        var myview = ServicesView()
        viewServicesIcon.addSubview(myview)
        myview.frame = CGRect(x: 10, y: 40, width: 40, height: 40)
        
        myview = ServicesView()
        viewServicesIcon.addSubview(myview)
        myview.frame = CGRect(x: 60, y: 80, width: 40, height: 40)
        myview.fillColor = UIColor(red: 1.0, green: 0.5, blue: 1.0, alpha: 1.0).cgColor
        
        setupGestures()
    }
    
    func setupGestures() {
        let pan = UIPanGestureRecognizer(target:self, action:#selector(self.pan(_:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        self.view.addGestureRecognizer(pan)
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddFromLikesAction (_ sender: UIButton) {
        
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
        
        let p:CGPoint = rec.location(in: self.view)
        var center:CGPoint = .zero
        
        switch rec.state {
        case .began:
            print("began")
            selectedView = view.hitTest(p, with: nil)
            if selectedView != nil {
                self.view.bringSubview(toFront: selectedView!)
            }
            
        case .changed:
            if let subview = selectedView {
                center = subview.center
                let distance = sqrt(pow((center.x - p.x), 2.0) + pow((center.y - p.y), 2.0))
                print("distance \(distance) threshold \(threshold)")
                
                if subview is MyView {
                    if distance > threshold {
                        if shouldDragX {
                            subview.center.x = p.x - (p.x.truncatingRemainder(dividingBy: snapX))
                        }
                        if shouldDragY {
                            subview.center.y = p.y - (p.y.truncatingRemainder(dividingBy: snapY))
                        }
                    }
                }
            }
            
        case .ended:
            print("ended")
            if let subview = selectedView {
                if subview is MyView {
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
        dictService.setValue("Lifestyle Services", forKey: "SubServiceTitle")
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
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "likedEventServicesSegue" {
            
            let vc: LikedEventServicesVC = segue.destination as! LikedEventServicesVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }else if segue.identifier == "eventSubServiceListSegue" {
            
            let vc: EventSubServiceList = segue.destination as! EventSubServiceList
            vc.dictCreateEventDetail = dictCreateEventDetail
            vc.strSelectedSubService = (arrServiceList.object(at: tblService.tag) as! NSMutableDictionary).value(forKey: "SubServiceTitle") as! String
        }
    }
}

class EventServiceListTableCell: UITableViewCell {
    
    @IBOutlet var lblServiceTitle: UILabel!
}
