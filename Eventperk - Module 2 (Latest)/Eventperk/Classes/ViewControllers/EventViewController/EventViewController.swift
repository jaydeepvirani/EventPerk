//
//  EventViewController.swift
//  Eventperk
//
//  Created by HARSHIT on 21/04/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSMobileHubHelper

class EventViewController: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var imgAppIcon: UIImageView!
    @IBOutlet var btnCreateEvent: UIButton!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.rdv_tabBarController.setTabBarHidden(false, animated: true)
    }
    
    //MARK:- Initialization
    func initialization() {
        imgAppIcon.layer.shadowRadius = 4
        imgAppIcon.layer.shadowOffset = CGSize.init(width: 0, height: 8)
        imgAppIcon.layer.shadowColor = UIColor.black.cgColor
        imgAppIcon.layer.shadowOpacity = 0.75
        
        btnCreateEvent.layer.borderColor = UIColor.white.cgColor
        btnCreateEvent.layer.borderWidth = 1.0
        btnCreateEvent.layer.cornerRadius = 20.0
    }
}
