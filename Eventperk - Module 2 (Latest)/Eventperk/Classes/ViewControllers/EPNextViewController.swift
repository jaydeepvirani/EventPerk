//
//  EPNextViewController.swift
//  Eventperk
//
//  Created by Pavel Volobuev on 03/04/2017.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class EPNextViewController: EPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .orange
        
        let label = UILabel(frame: CGRect(x: 20, y: 100, width: K.ScreenSize.WIDTH - 40, height: 44))
        label.text = "You are logging in. Next Module"
        label.textAlignment = .center
        view.addSubview(label)
        
//        let button = UIButton(type: .custom)
//        button.frame = CGRect(x: 15, y: 28, width: 200, height: 28)
//        button.addTarget(self, action: #selector(backButton(_:)), for: .touchUpInside)
//        button.setTitle("Logout", for: .normal)
//        view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func backButton(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
