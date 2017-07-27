//
//  AboutEditViewController.swift
//  Eventperk
//
//  Created by HARSHIT on 10/05/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

protocol dismissPopDelegate: class
{
    func dismissPopUpTextView(_ textView:UITextView)
}

class AboutEditViewController: UIViewController {

    @IBOutlet var txt_About: UITextView!
    var delegate: dismissPopDelegate?

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func passAlong() {
    }
    
    @IBAction func clk_Submit(_ sender: UIButton)
    {
        self.delegate?.dismissPopUpTextView(self.txt_About)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
