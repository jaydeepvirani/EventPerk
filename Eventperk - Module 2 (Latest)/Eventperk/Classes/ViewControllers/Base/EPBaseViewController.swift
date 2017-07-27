//
//  EPBaseViewController.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 21/03/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class EPBaseViewController: UIViewController {

    let aStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .clear
        
        adjustUI()
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
    
    func adjustUI() {
        let gradient = CAGradientLayer()
        
        if let _ = navigationController {
            gradient.frame = CGRect(x: 0, y: -64, width: view.bounds.size.width, height: view.bounds.size.height + 64)
        } else {
            gradient.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        }
        
        gradient.colors = [UIColor.backgroundGradientLeftTop.cgColor, UIColor.backgroundGradientRightBottom.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: - Methods
    
    @IBAction func endEditingDidTapped(_ sender: Any) {
        view.endEditing(true)
    }

}
