//
//  EPInfoView.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 29/03/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class EPInfoView: UIView {
    
    // UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "EPInfoView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = .arial(12)
        subtitleLabel.font = .arial(12)
        
        titleLabel.textColor = .infoRed
        subtitleLabel.textColor = .infoBlack
    }

    
    // MARK: - Show Methods
    func show(at view: UIView,
              title: String,
              subtitle: String,
              titleColor: UIColor? = .infoRed) {
        
        view.addSubview(self)
        
        self.snp.removeConstraints()
        
        self.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leading)
            make.top.equalTo(view.snp.top).offset(20)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
        titleLabel.textColor = titleColor
        
        self.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1.0
        }
        
        delay(2.25) {
            UIView.animate(withDuration: 1) {
                self.alpha = 0.0
            }
        }
    }
}
