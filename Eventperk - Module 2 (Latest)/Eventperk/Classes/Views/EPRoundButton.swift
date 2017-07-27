//
//  EPRoundButton.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 23/03/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class EPRoundButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func setupUI() {
        backgroundColor = .clear
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        
        setTitleColor(.white, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.size.height / 2
    }

}
