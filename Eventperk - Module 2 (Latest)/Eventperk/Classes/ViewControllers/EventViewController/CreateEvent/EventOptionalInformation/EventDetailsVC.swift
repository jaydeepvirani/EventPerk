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
    @IBOutlet var lblGuestCount: UILabel!
    
    @IBOutlet var constGuestCountViewHeight: NSLayoutConstraint!
    
    //MARK:- TextInputView
    @IBOutlet var viewTextInputView: UIView!
    @IBOutlet var viewTextInputViewIn: UIView!
    @IBOutlet var lblTextInputTitle: UILabel!
    @IBOutlet var textViewInput: UITextView!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var isFromEventDetail = false
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dictCreateEventDetail)
        self.initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        
//        if isFromEventDetail {
//            
//            if dictCreateEventDetail.value(forKey: "NumberOfGuest") as? String != lblGuestCount.text  {
//               
//                dictCreateEventDetail.setValue(lblGuestCount.text, forKey: "NumberOfGuest")
//                EventProfile.insertUpdateEventData(dictEventDetail: dictCreateEventDetail) { (errors: [NSError]?) in
//                }
//            }
//        }
    }
    
    //MARK:- Initialization
    func initialization() {
        btnPreview.layer.cornerRadius = 10
        viewTextInputViewIn.layer.cornerRadius = 10
        
        viewTextInputView.frame = CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: Constants.ScreenSize.SCREEN_HEIGHT)
        self.view.addSubview(viewTextInputView)
        viewTextInputView.isHidden = true
        
        if dictCreateEventDetail.value(forKey: "TheEvent") != nil{
            lblEvent.text = dictCreateEventDetail.value(forKey: "TheEvent") as? String
        }
        if dictCreateEventDetail.value(forKey: "TheItinerary") != nil{
            lblItinerary.text = dictCreateEventDetail.value(forKey: "TheItinerary") as? String
        }
        if dictCreateEventDetail.value(forKey: "TheLogistics") != nil{
            lblLogistics.text = dictCreateEventDetail.value(forKey: "TheLogistics") as? String
        }
        if dictCreateEventDetail.value(forKey: "TheAdditional") != nil{
            lblAdditional.text = dictCreateEventDetail.value(forKey: "TheAdditional") as? String
        }
        
        constGuestCountViewHeight.constant = 0
//        if isFromEventDetail == true{
//            constGuestCountViewHeight.constant = 88
//            if dictCreateEventDetail.value(forKey: "NumberOfGuest") != nil {
//                lblGuestCount.text = dictCreateEventDetail.value(forKey: "NumberOfGuest") as? String
//            }
//        }else{
//            constGuestCountViewHeight.constant = 0
//        }
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPreviewAction (_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "previewEventProfileSegue", sender: nil)
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
    
    @IBAction func btnGuestCountAction (_ sender: UIButton) {
        
        var intCount = Int(lblGuestCount.text!)
        if sender.tag == 1{
            if intCount != 0 {
                intCount = intCount! - 1
            }
        }else{
            intCount = intCount! + 1
        }
        lblGuestCount.text = "\(String(describing: intCount!))"
    }
    
    //MARK:- TextView Delegate
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if viewTextInputView.tag == 1 {
            if textView.text == "" {
                lblEvent.text = "What makes your event unique ?"
            }else{
                lblEvent.text = textView.text
            }
            dictCreateEventDetail.setValue(textView.text, forKey: "TheEvent")
        }else if viewTextInputView.tag == 2 {
            if textView.text == "" {
                lblItinerary.text = "What schedules do you have for your event ?"
            }else{
                lblItinerary.text = textView.text
            }
            dictCreateEventDetail.setValue(textView.text, forKey: "TheItinerary")
        }else if viewTextInputView.tag == 3 {
            if textView.text == "" {
                lblLogistics.text = "What arrangements do you have for your event ?"
            }else{
                lblLogistics.text = textView.text
            }
            dictCreateEventDetail.setValue(textView.text, forKey: "TheLogistics")
        }else if viewTextInputView.tag == 4 {
            if textView.text == "" {
                lblAdditional.text = "Any other information to share ?"
            }else{
                lblAdditional.text = textView.text
            }
            dictCreateEventDetail.setValue(textView.text, forKey: "TheAdditional")
        }
        
        if textView.text != "" {
            
            EventProfile.insertUpdateEventData(dictEventDetail: dictCreateEventDetail) { (errors: [NSError]?) in
            }
        }
        
        viewTextInputView.isHidden = true
    }
    
    //MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewEventProfileSegue" {
            let vc: PreviewEventProfileVC = segue.destination as! PreviewEventProfileVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }
    }
}
