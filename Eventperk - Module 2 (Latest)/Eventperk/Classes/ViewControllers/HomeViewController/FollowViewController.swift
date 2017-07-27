//
//  FollowViewController.swift
//  Eventperk
//
//  Created by HARSHIT on 02/05/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class FollowViewController: UIViewController
{
    //MARK:- Outlet Declaration
    @IBOutlet var Following_View:UIView!
    @IBOutlet var Follower_View:UIView!

    @IBOutlet var lbl_Following:UILabel!
    @IBOutlet var lbl_Follower:UILabel!
    
    @IBOutlet var lbl_FollowingCount:UILabel!
    @IBOutlet var lbl_FollowerCount:UILabel!
    
    @IBOutlet var imgUserPic: UIImageView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.initialization()
    }
    
    //MARK:- Initialization
    
    func initialization(){
        if Constants.appDelegate.dictUserDetail.value(forKey: "pictureInData") != nil {
            imgUserPic.image = UIImage(data: Constants.appDelegate.dictUserDetail.value(forKey: "pictureInData") as! Data)
        }else if Constants.appDelegate.dictUserDetail.value(forKey: "picture") != nil {
            
            if let url = NSURL(string: Constants.appDelegate.dictUserDetail.value(forKey: "picture") as! String) {
                if let data = NSData(contentsOf: url as URL) {
                    imgUserPic.image = UIImage(data: data as Data)
                }else{
                    imgUserPic.image = UIImage.init(named: "ic_UserPic")
                }
            }else{
                imgUserPic.image = UIImage.init(named: "ic_UserPic")
            }
        }else{
            imgUserPic.image = UIImage.init(named: "ic_UserPic")
        }
    }
    
    @IBAction func clk_Back(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clk_Follower(_ sender: UIButton)
    {
        Following_View.backgroundColor = UIColor.white
        Follower_View.backgroundColor = UIColor.orange
        lbl_Following.textColor = UIColor.black
        lbl_Follower.textColor = UIColor.orange
    }
    
    @IBAction func clk_Following(_ sender: UIButton)
    {
        Following_View.backgroundColor = UIColor.orange
        Follower_View.backgroundColor = UIColor.white
        lbl_Following.textColor = UIColor.orange
        lbl_Follower.textColor = UIColor.black
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
