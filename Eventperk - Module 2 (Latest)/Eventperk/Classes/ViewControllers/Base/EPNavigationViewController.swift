//
//  EPNavigationViewController.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 21/03/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class EPNavigationViewController: UINavigationController {

    private let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.clear
        navigationBar.tintColor = UIColor.white
        view.backgroundColor = UIColor.clear
        
        // Remove underline
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
        navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17),
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        interactivePopGestureRecognizer?.delegate = nil
        
        // Gradient Background For Navigation Bar
        
        gradient.frame = CGRect(x: 0, y: -20, width: view.bounds.size.width, height: view.bounds.size.height)
        gradient.colors = [UIColor.backgroundGradientLeftTop.cgColor, UIColor.backgroundGradientRightBottom.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        navigationBar.layer.insertSublayer(gradient, at: 0)
        navigationBar.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
