//
//  ProjectUtility.swift
//  Happy Roads
//
//  Created by fiplmac1 on 01/10/16.
//  Copyright © 2016 fusion. All rights reserved.
//

import UIKit

let SampleDataGeneratorSampleDataStringPrefix: String = "Eventperk"
let SampleDataGeneratorSampleDataNumberMinimum: UInt32 = 1111000000
let SampleDataGeneratorSampleDataNumberMaximum: UInt32 = 1111999999
let SampleDataGeneratorRandomNumberMaximum: UInt32 = SampleDataGeneratorSampleDataNumberMaximum - SampleDataGeneratorSampleDataNumberMinimum
let SampleDataGeneratorSampleDataPartition: UInt8 = 4

class ProjectUtilities: NSObject
{
    
    //MARK:- Change DateForamatter
    class func stringFromDate (date: Date, strFormatter strDateFormatter: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormatter
        
        let convertedDate = dateFormatter.string(from: date)
        
        return convertedDate
    }
    
    class func dateFromString (strDate: String, strFormatter strDateFormatter: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormatter
        
        let convertedDate = dateFormatter.date(from: strDate)
        
        return convertedDate!
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
    class func setUpIconsForServices(arrServices: NSMutableArray, viewDragable: UIView, size: NSInteger) -> NSMutableArray {
        
        var lastUpdatedX = 0
        var lastUpdatedY = 0
        
        for view in viewDragable.subviews{
            
            if !view.isKind(of: UIButton.self) {
                view.removeFromSuperview()
            }
        }
        
        let arrViewService = NSMutableArray()
        
        var intArrIndex = 0
        
        for i in 0 ..< arrServices.count {
            if (arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") != nil {
                for j in 0 ..< ((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).count {
                    
                    if (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "ItemCount") != nil && (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger != 0 {
                        
                        for k in 0 ..< ((((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger) {
                            
                            if viewDragable.frame.width < CGFloat(lastUpdatedX + size) {
                                lastUpdatedY = lastUpdatedY + size
                                lastUpdatedX = 0
                            }
                            
                            let myView = ServicesView()
                            viewDragable.addSubview(myView)
                            
                            myView.frame = CGRect(x: lastUpdatedX, y: lastUpdatedY, width: size, height: size)
                            
                            if size == 50 {
                                myView.imgServiceIcon.image = UIImage(named: "\((((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "SubServiceTitle") as! String)1")
                            }else{
                                myView.imgServiceIcon.image = UIImage(named: (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "SubServiceTitle") as! String)
                            }
                            
                            myView.imgServiceIcon.frame = CGRect(x: 0, y: 0, width: size, height: size)
                            if size == 15 {
                                myView.imgServiceIcon.contentMode = UIViewContentMode.scaleAspectFit
                            }
                            
                            myView.tag = j
                            myView.strServiceType = (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "SubServiceTitle") as! String
                            
                            lastUpdatedX = lastUpdatedX + size
                            
                            myView.index = i
                            myView.subIndex = j
                            myView.intArrIndex = intArrIndex
                            myView.intItemCountIndex = k
                            
                            if (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "\(k)") != nil {
                                
                                myView.strTags = (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "\(k)") as! String
                            }
                            
                            if (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "Budget\(k)") != nil {
                                
                                myView.strEventBudget = (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "Budget\(k)") as! String
                            }
                            
                            arrViewService.add(myView)
                            
                            intArrIndex = intArrIndex + 1
                        }
                    }
                }
            }
        }
        
        return arrViewService
    }
    
    class func checkForAllServicesTags(arrServices: NSMutableArray) -> Bool {
        
        if ProjectUtilities.checkForServices(arrServices: arrServices) {
            
            for i in 0 ..< arrServices.count {
                if (arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") != nil {
                    for j in 0 ..< ((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).count {
                        
                        if (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "ItemCount") != nil && (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger != 0 {
                            
                            
                            for k in 0 ..< ((((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger) {
                                
                                if (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "\(k)") == nil {
                                    
                                    return false
                                }else{
                                    let arrTags = ((((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "\(k)") as! String).components(separatedBy: ",") as NSArray
                                    if arrTags.count < 3 {
                                        
                                        return false
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return true
        }else{
            return false
        }
    }
    
    class func checkForServices(arrServices: NSMutableArray) -> Bool {
        
        for i in 0 ..< arrServices.count {
            if (arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") != nil {
                for j in 0 ..< ((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).count {
                    
                    if (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "ItemCount") != nil && (((arrServices.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger != 0 {
                        
                        return true
                    }
                }
            }
        }
        return false
    }
    
    class func randomSampleStringWithAttributeName(_ attributeName: String) -> String {
        return "\(SampleDataGeneratorSampleDataStringPrefix)-\(attributeName)-\(randomNumber().formattedIntegerString())-\(Constants.appDelegate.dictUserDetail.value(forKey: "email") as! String)"
    }
    
    class func randomNumber() -> UInt32 {
        return arc4random_uniform(SampleDataGeneratorRandomNumberMaximum)
    }
}

extension UIImageView {
    
    override func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.isAdditive = true
        animation.duration = 0.07
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint.init(x: -1, y: 1))
        animation.toValue = NSValue(cgPoint: CGPoint.init(x: 1, y: -1))
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.layer.add(animation, forKey: "position")
    }
}

extension UIButton {
    
    override func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.isAdditive = true
        animation.duration = 0.07
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint.init(x: -1, y: 1))
        animation.toValue = NSValue(cgPoint: CGPoint.init(x: 1, y: -1))
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.layer.add(animation, forKey: "position")
    }
}

extension UInt32 {
    fileprivate func formattedIntegerString() -> String {
        return String(format: "%06d", self)
    }
    
    fileprivate func formattedLongString() -> String {
        return String(format: "%06llu", self)
    }
}
