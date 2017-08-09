//
//  EventDetailsVC.swift
//  Eventperk
//
//  Created by Bhavik iOS Developer on 09/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class EventDetailsVC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var btnPreview: UIButton!
    
    @IBOutlet var lblEvent: UILabel!
    @IBOutlet var lblItinerary: UILabel!
    @IBOutlet var lblLogistics: UILabel!
    @IBOutlet var lblAdditional: UILabel!
    
    //MARK:- TextInputView
    @IBOutlet var viewTextInputView: UIView!
    @IBOutlet var viewTextInputViewIn: UIView!
    @IBOutlet var lblTextInputTitle: UILabel!
    @IBOutlet var textViewInput: UITextView!
    
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
        btnPreview.layer.cornerRadius = 10
        viewTextInputViewIn.layer.cornerRadius = 10
        
        viewTextInputView.frame = CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: Constants.ScreenSize.SCREEN_HEIGHT)
        self.view.addSubview(viewTextInputView)
        viewTextInputView.isHidden = true
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPreviewAction (_ sender: UIButton) {
    }
    
    @IBAction func btnEventDetailAction (_ sender: UIButton) {
        
        viewTextInputView.isHidden = false
        textViewInput.becomeFirstResponder()
        if viewTextInputView.tag != sender.tag {
            textViewInput.text = ""
        }
        viewTextInputView.tag = sender.tag
        
        if sender.tag == 1 {
            lblTextInputTitle.text = "The Event"
        }else if sender.tag == 2 {
            lblTextInputTitle.text = "The Itinerary"
        }else if sender.tag == 3 {
            lblTextInputTitle.text = "The Logistics"
        }else if sender.tag == 4 {
            lblTextInputTitle.text = "The Additional"
        }
    }
    
    //MARK:- TextView Delegate
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if viewTextInputView.tag == 1 {
            if textView.text == "" {
                lblEvent.text = "What makes your event unique ?"
            }else{
                lblEvent.text = textView.text
            }
        }else if viewTextInputView.tag == 2 {
            if textView.text == "" {
                lblItinerary.text = "What schedules do you have for your event ?"
            }else{
                lblItinerary.text = textView.text
            }
        }else if viewTextInputView.tag == 3 {
            if textView.text == "" {
                lblLogistics.text = "What arrangements do you have for your event ?"
            }else{
                lblLogistics.text = textView.text
            }
        }else if viewTextInputView.tag == 4 {
            if textView.text == "" {
                lblAdditional.text = "Any other information to share ?"
            }else{
                lblAdditional.text = textView.text
            }
        }
        
        viewTextInputView.isHidden = true
    }
}
