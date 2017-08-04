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
            cell.lblTitle.textColor = UIColor.darkGray
            
        }else{
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView : UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize{
        
        let size: CGSize = ((arrTabs.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "TabTitle") as! String).size(attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14.0)])
        return CGSize.init(width: size.width+18, height: 50)
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
}

class LikedEventServicesCollectionCell: UICollectionViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgLine: UIImageView!
}
