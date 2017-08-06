//
//  MyView.swift
//  KindOfADrag
//
//  Created by Gene De Lisa on 9/2/14.
//  Copyright (c) 2014 Gene De Lisa. All rights reserved.
//

import UIKit

class ServicesView: UIView {
    
    var imgServiceIcon = UIImageView()
    var intTag = 0
    var strServiceType = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBehavior()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func addBehavior() {
        imgServiceIcon = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        imgServiceIcon.contentMode = UIViewContentMode.center//scaleAspectFit
        self.addSubview(imgServiceIcon)
    }
}
