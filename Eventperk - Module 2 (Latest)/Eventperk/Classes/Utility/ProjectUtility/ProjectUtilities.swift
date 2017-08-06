//
//  ProjectUtility.swift
//  Happy Roads
//
//  Created by fiplmac1 on 01/10/16.
//  Copyright © 2016 fusion. All rights reserved.
//

import UIKit

class ProjectUtilities: NSObject
{
    
    //MARK:- Change DateForamatter
    class func stringFromDate (date: Date, strFormatter strDateFormatter: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormatter
        
        let convertedDate = dateFormatter.string(from: date)
        
        return convertedDate
    }
    
    class func changeDateFormate (strDate: String, strFormatter1 strDateFormatter1: String, strFormatter2 strDateFormatter2: String) -> NSString
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormatter1
        
        if let date = dateFormatter.date(from: strDate)
        {
            dateFormatter.dateFormat = strDateFormatter2
            
            if let strConvertedDate:NSString = dateFormatter.string(from: date) as NSString?
            {
                return strConvertedDate
            }
        }
        return ""
    }
    
    //MARK:- Animate Popup
    class func animatePopupView (viewPopup: UIView)
    {
        viewPopup.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001);
        
        UIView.animate(withDuration: 0.3/1.5, animations: {
            
            viewPopup.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            
        }) { (finished) in
            
            UIView.animate(withDuration: 0.3/2, animations: {
                viewPopup.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9);
            }, completion: { (finished) in
                
                UIView.animate(withDuration: 0.3/2, animations: {
                    viewPopup.transform = CGAffineTransform.identity;
                })
            })
        }
    }
    
    //MARK:- Setup Dragable Services
    class func setUpIconsForServices(arrServices: NSMutableArray, viewDragable: UIView) {
        
        var lastUpdatedX = 0
        var lastUpdatedY = 0
        
        for view in viewDragable.subviews{
            
            if !view.isKind(of: UIButton.self) {
                view.removeFromSuperview()
            }
        }
        
        for i in 0 ..< arrServices.count {
            if (arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") != nil {
                for j in 0 ..< ((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).count {
                    
                    if (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "ItemCount") != nil && (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger != 0 {
                        
                        if Constants.ScreenSize.SCREEN_WIDTH < CGFloat(lastUpdatedX + 40) {
                            lastUpdatedY = lastUpdatedY + 40
                            lastUpdatedX = 0
                        }
                        
                        let myview = ServicesView()
                        viewDragable.addSubview(myview)
                        myview.frame = CGRect(x: lastUpdatedX, y: lastUpdatedY, width: 40, height: 40)
                        myview.imgServiceIcon.image = UIImage(named: (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "SubServiceTitle") as! String)
                        
                        myview.tag = j
                        myview.strServiceType = (arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServiceTitle") as! String
                        
                        lastUpdatedX = lastUpdatedX + 40
                    }
                }
            }
        }
    }
}
