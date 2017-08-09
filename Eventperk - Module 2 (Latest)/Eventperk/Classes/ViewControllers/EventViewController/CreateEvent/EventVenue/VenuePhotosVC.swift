//
//  VenuePhotosVC.swift
//  Eventperk
//
//  Created by CIZO on 09/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class VenuePhotosVC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var btnDone: UIButton!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dictCreateEventDetail)
        self.initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initialization
    func initialization() {
        btnDone.layer.cornerRadius = 10
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
