//
//  LikedEventServicesVC.swift
//  Eventperk
//
//  Created by Bhavik iOS Developer on 04/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class LikedEventServicesVC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var colTabs: UICollectionView!
    @IBOutlet var tblLikedServices: UITableView!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var arrTabs = NSMutableArray()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dictCreateEventDetail)
        self.initialization()
        self.createTabArray()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initialization
    func initialization() {
        
        tblLikedServices.rowHeight = UITableViewAutomaticDimension
        tblLikedServices.estimatedRowHeight = 298
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UICollectionView
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return arrTabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell : LikedEventServicesCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikedEventServicesCollectionCell", for: indexPath) as! LikedEventServicesCollectionCell
        
        cell.lblTitle.text = (arrTabs.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "TabTitle") as? String
        
        if (arrTabs.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "isSelected") != nil && (arrTabs.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "isSelected") as! String == "true" {
            
            cell.lblTitle.textColor = UIColor.black
            cell.imgLine.isHidden = false
            
        }else{
            cell.lblTitle.textColor = UIColor.lightGray
            cell.imgLine.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath){
        
        let index = (arrTabs.value(forKey: "isSelected") as AnyObject).index(of: "true")
        if index != NSNotFound{
            (arrTabs.object(at: index) as! NSMutableDictionary).setValue("false", forKey: "isSelected")
        }
        
        (arrTabs.object(at: indexPath.row) as! NSMutableDictionary).setValue("true", forKey: "isSelected")
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView : UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize{
        
        let size: CGSize = ((arrTabs.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "TabTitle") as! String).size(attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14.0)])
        return CGSize.init(width: size.width+18, height: 50)
    }
    
    //MARK:- Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        let cell:LikedEventServicesTableCell = tableView.dequeueReusableCell(withIdentifier: "LikedEventServicesTableCell", for: indexPath as IndexPath) as! LikedEventServicesTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.btnAddToEvent.layer.cornerRadius = 10
        
        return cell
    }
    
    //MARK:- Tabs
    func createTabArray() {
        
        var dictTab = NSMutableDictionary()
        dictTab.setValue("Inspiration", forKey: "TabTitle")
        dictTab.setValue("true", forKey: "isSelected")
        arrTabs.add(dictTab)
        
        dictTab = NSMutableDictionary()
        dictTab.setValue("Innovations", forKey: "TabTitle")
        arrTabs.add(dictTab)
        
        dictTab = NSMutableDictionary()
        dictTab.setValue("Up Coming", forKey: "TabTitle")
        arrTabs.add(dictTab)
    }
    
    //MARK:- Attributed String
    
    func attributedString() {
        var font = UIFont(name: "Helvetica-Bold", size: 14.0)
        var attrsDictionary: [AnyHashable: Any] = [ NSFontAttributeName : font ]
        var attrString = NSMutableAttributedString(string: str1, attributes: attrsDictionary as? [String : Any] ?? [String : Any]())
        font = UIFont(name: "Helvetica", size: 14.0)
        attrsDictionary = [ NSFontAttributeName : font ]
        var newAttString = NSAttributedString(string: str2, attributes: attrsDictionary as? [String : Any] ?? [String : Any]())
        attrString.append(newAttString)
        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: (attrString.string as NSString).range(of: str1))
        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: (attrString.string as NSString).range(of: str2))

    }
    
    
}

class LikedEventServicesCollectionCell: UICollectionViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgLine: UIImageView!
}

class LikedEventServicesTableCell: UITableViewCell {
    
    @IBOutlet var btnAddToEvent: UIButton!
    @IBOutlet weak var viewRating: CosmosView!
}
