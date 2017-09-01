//
//  EventServiceListVC.swift
//  Eventperk
//
//  Created by Bhavik iOS Developer on 04/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import APESuperHUD

class EventServiceListVC: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate {

    //MARK:- Outlet Declaration
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var tblService: UITableView!
    
    @IBOutlet var viewServicesIcon: UIView!
    @IBOutlet var viewServicesTags: UIView!
    
    @IBOutlet var constNoteViewHeight: NSLayoutConstraint!
    
    //MARK:- TextInputView
    @IBOutlet var viewTextInputView: UIView!
    @IBOutlet var viewTextInputViewIn: UIView!
    @IBOutlet var lblTextInputTitle: UILabel!
    @IBOutlet var textViewInput: UITextView!
    
    //MARK:- TagsView
    @IBOutlet var lblTags: UILabel!
    
    @IBOutlet var constTagsViewHeight: NSLayoutConstraint!
    
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
    var arrServiceListViews = NSMutableArray()
    var arrUndoList = NSMutableArray()
    var arrRedoList = NSMutableArray()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(dictCreateEventDetail)
        
        self.setUpServicesView()
        
        let intTime: Int = Int((Int64)(1 * Double(NSEC_PER_SEC)))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(intTime) / Double(NSEC_PER_SEC), execute: {() -> Void in
            DispatchQueue.main.async(execute: {(_: Void) -> Void in
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            })
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    //MARK:- Initialization
    func initialization() {
        btnSave.layer.cornerRadius = 10
        viewTextInputViewIn.layer.cornerRadius = 10
        viewServicesTags.isHidden = true
        
        setupGestures()
        
        if dictCreateEventDetail.value(forKey: "EventServices") != nil {
            arrServiceList = (dictCreateEventDetail.value(forKey: "EventServices") as! NSMutableArray).mutableCopy() as! NSMutableArray
        }else{
            createServiceArray()
        }
        
        viewTextInputView.frame = CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: Constants.ScreenSize.SCREEN_HEIGHT)
        self.view.addSubview(viewTextInputView)
        viewTextInputView.isHidden = true
        
        constTagsViewHeight.constant = 0
    }
    
    //MARK:- Setup Dragable
    func setUpServicesView() {
        
        arrServiceListViews = ProjectUtilities.setUpIconsForServices(arrServices: arrServiceList, viewDragable: viewServicesIcon, size: 50)
        
        self.saveButtonValidation(isSelected: ProjectUtilities.checkForAllServicesTags(arrServices: arrServiceList))
        
        if ProjectUtilities.checkForServices(arrServices: arrServiceList) {
            constNoteViewHeight.constant = 0
        }else{
            constNoteViewHeight.constant = 46
        }
        
        selectedServiceView = nil
        
        self.showBordersServicesView()
        constTagsViewHeight.constant = 0
    }
    
    func setUpServiceTagsView() {
        
        viewServicesTags.removeAllSubviews()
        
        if selectedServiceView != nil {
            
            var lastUpdatedX = 10
            var lastUpdatedY = 10
            
            if selectedServiceView?.strTags != ""{
                
                let arrTags = (selectedServiceView?.strTags)!.components(separatedBy: ",") as NSArray
                
                for i in 0 ..< arrTags.count {
                    
                    let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 999)
                    let boundingBox = (arrTags.object(at: i) as! String).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13.0)], context: nil)
                    
                    if Constants.ScreenSize.SCREEN_WIDTH - 10 < CGFloat(lastUpdatedX + Int(boundingBox.size.width) + 20) {
                        lastUpdatedY = lastUpdatedY + 34
                        lastUpdatedX = 10
                    }
                    
                    let lblTag = UILabel.init(frame: CGRect.init(x: lastUpdatedX, y: lastUpdatedY, width: Int(boundingBox.size.width) + 20, height: 30))
                    
                    lblTag.textAlignment = NSTextAlignment.center
                    lblTag.font = UIFont.systemFont(ofSize: 13.0)
                    lblTag.text = "#\(arrTags.object(at: i) as! String)"
                    
                    lblTag.layer.borderWidth = 1
                    lblTag.layer.borderColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
                    lblTag.layer.cornerRadius = 5
                    
                    viewServicesTags.addSubview(lblTag)
                    
                    lastUpdatedX = lastUpdatedX + Int(boundingBox.size.width) + 24
                }
                
            }
        }
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        
        if viewServicesIcon.isHidden == true {
            viewServicesIcon.isHidden = false
            viewServicesTags.isHidden = true
        }else{
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnSaveAction (_ sender: UIButton) {
        
        if btnSave.isSelected == true {
            dictCreateEventDetail.setValue(arrServiceList, forKey: "EventServices")
            
            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
            EventProfile.insertUpdateEventData(dictEventDetail: dictCreateEventDetail) { (errors: [NSError]?) in
                
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                if errors == nil {
                    
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func btnServicesOptionAction (_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            if selectedServiceView != nil {
                var intCount = (((arrServiceList.object(at: (selectedServiceView?.index)!) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: (selectedServiceView?.subIndex)!) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger
                
                intCount = intCount - 1
                
                (((arrServiceList.object(at: (selectedServiceView?.index)!) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: (selectedServiceView?.subIndex)!) as! NSMutableDictionary).setValue(intCount, forKey: "ItemCount")
                
                self.arrUndoList.add(selectedServiceView!)
                self.setUpServicesView()
            }
            
        }else if sender.tag == 2 {
            
            if selectedServiceView != nil {                
                var intCount = (((arrServiceList.object(at: (selectedServiceView?.index)!) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: (selectedServiceView?.subIndex)!) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger
                
                intCount = intCount + 1
                
                (((arrServiceList.object(at: (selectedServiceView?.index)!) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: (selectedServiceView?.subIndex)!) as! NSMutableDictionary).setValue(intCount, forKey: "ItemCount")
                
                self.setUpServicesView()
            }
            
        }else if sender.tag == 3 {
            
            if selectedServiceView != nil {
                
                viewTextInputView.isHidden = false
                textViewInput.becomeFirstResponder()
                textViewInput.text = selectedServiceView?.strTags
                lblTextInputTitle.text = selectedServiceView?.strServiceType
//                self.setUpServiceTagsView()
//                
//                if viewServicesIcon.isHidden == false {
//                    viewServicesIcon.isHidden = true
//                    viewServicesTags.isHidden = false
//                }else{
//                    viewServicesIcon.isHidden = false
//                    viewServicesTags.isHidden = true
//                }
            }
            
        }else if sender.tag == 4 {
            
            if arrUndoList.count != 0 {
                let view = arrUndoList.object(at: arrUndoList.count - 1) as? ServicesView
                
                var intCount = (((arrServiceList.object(at: (view?.index)!) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: (view?.subIndex)!) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger
                
                intCount = intCount + 1
                
                (((arrServiceList.object(at: (view?.index)!) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: (view?.subIndex)!) as! NSMutableDictionary).setValue(intCount, forKey: "ItemCount")
                
                self.setUpServicesView()
                
                arrUndoList.removeObject(at: arrUndoList.count - 1)
                arrRedoList.add(view!)
            }
            
        }else if sender.tag == 5 {
            if arrRedoList.count != 0 {
                let view = arrRedoList.object(at: arrRedoList.count - 1) as? ServicesView
                
                var intCount = (((arrServiceList.object(at: (view?.index)!) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: (view?.subIndex)!) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger
                
                intCount = intCount - 1
                
                (((arrServiceList.object(at: (view?.index)!) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: (view?.subIndex)!) as! NSMutableDictionary).setValue(intCount, forKey: "ItemCount")
                
                self.setUpServicesView()
                
                arrRedoList.removeObject(at: arrRedoList.count - 1)
                arrUndoList.add(view!)
            }
        }
    }
    
    @IBAction func btnPleaseAddTagsAction (_ sender: UIButton) {
        
        if selectedServiceView != nil {
            viewTextInputView.isHidden = false
            lblTextInputTitle.text = selectedServiceView?.strServiceType
            textViewInput.becomeFirstResponder()
            
            textViewInput.text = selectedServiceView?.strTags
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
    func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target:self, action:#selector(self.panGesture(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        viewServicesIcon.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target:self, action:#selector(self.tapGesture(_:)))
        viewServicesIcon.addGestureRecognizer(tapGesture)
    }
    
    func panGesture(_ rec:UIPanGestureRecognizer) {
        
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
    
    func tapGesture(_ rec:UITapGestureRecognizer) {
        
        self.view.endEditing(true)
            
        let p:CGPoint = rec.location(in: viewServicesIcon)
        
        var selectedView: UIView?
        selectedView = viewServicesIcon.hitTest(p, with: nil)
        
        selectedServiceView = nil
        
        if selectedView != nil {
            viewServicesIcon.bringSubview(toFront: selectedView!)
        }
        
        self.showBordersServicesView()
        
        if let subview = selectedView {
            if subview is ServicesView {
                
                selectedServiceView = subview as? ServicesView
                
                selectedServiceView?.layer.borderWidth = 1
                selectedServiceView?.layer.borderColor = UIColor.init(red: 38.0/255.0, green: 170.0/255.0, blue: 202.0/255.0, alpha: 1.0).cgColor
                
                intSelectedServiceIndex = (selectedView?.tag)!
                
                constTagsViewHeight.constant = 35
                
                if selectedServiceView?.strTags != "" {
                    
                    self.setTagsLabelText()
                }else{
                    lblTags.text = "Please add tags"
                }
                
                return
            }
        }
        
        constTagsViewHeight.constant = 0
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
        
        if dictCreateEventDetail.value(forKey: "HaveVenue") as! String == "No" {
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
        }else{
            btnSave.backgroundColor = UIColor.red
            btnSave.isSelected = false
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
    
    //MARK:- TextView Delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let arrTags = textViewInput.text.components(separatedBy: ",") as NSArray
        if arrTags.count > 5 && text == "," {
            
            return false
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewTextInputView.isHidden = true
        
        selectedServiceView?.strTags = textView.text
        
        arrServiceListViews.replaceObject(at: (selectedServiceView?.intArrIndex)!, with: selectedServiceView!)
        
        (((arrServiceList.object(at: (selectedServiceView?.index)!) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: (selectedServiceView?.subIndex)!) as! NSMutableDictionary).setValue(textView.text, forKey: "\(String(describing: (selectedServiceView?.intItemCountIndex)!))")
        
        self.setUpServiceTagsView()
        
//        let arrTags = (selectedServiceView?.strTags)!.components(separatedBy: ",") as NSArray
//        if arrTags.count >= 3 {
//            selectedServiceView?.layer.borderWidth = 1
//            selectedServiceView?.layer.borderColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0).cgColor
//        }
        
        self.setTagsLabelText()
        
        self.saveButtonValidation(isSelected: ProjectUtilities.checkForAllServicesTags(arrServices: arrServiceList))
    }
    
    //MARK:- Tags Label
    func setTagsLabelText() {
        let arrTags = (selectedServiceView?.strTags)!.components(separatedBy: ",") as NSArray
        var strTemp = ""
        for i in 0 ..< arrTags.count {
            strTemp = strTemp + "#\(arrTags.object(at: i) as! String)"
            
            if i < arrTags.count-1 {
                strTemp = strTemp + ", "
            }
        }
        lblTags.text = strTemp
    }
    
    //MARK:- Show Border
    func showBordersServicesView(){
        
        for i in 0 ..< arrServiceListViews.count {
            
            let view = arrServiceListViews.object(at: i) as? ServicesView
            
            view?.layer.borderWidth = 1
            
            let arrTags = (view?.strTags)!.components(separatedBy: ",") as NSArray
            if arrTags.count >= 3 {
                
                view?.layer.borderColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0).cgColor
            }else{
                view?.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
}

class EventServiceListTableCell: UITableViewCell {
    
    @IBOutlet var lblServiceTitle: UILabel!
}
