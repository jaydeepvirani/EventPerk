//
//  EPAuthFieldView.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 21/03/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class EPAuthFieldView: UIView {
    
    // UI
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Init Methods
    
    func setupUI() {
        backgroundColor = .clear
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        
        textField.font = .sanFrancisco(14)
        textField.textColor = .white
    }
    
    func setupConstraints() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.size.height / 2
    }

}
