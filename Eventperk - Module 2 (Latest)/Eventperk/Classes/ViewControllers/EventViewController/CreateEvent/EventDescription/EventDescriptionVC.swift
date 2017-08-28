//
//  EventDescriptionVC.swift
//  Eventperk
//
//  Created by Bhavik iOS Developer on 03/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import APESuperHUD

class EventDescriptionVC: UIViewController, UITextViewDelegate {

    //MARK:- Outlet Declaration
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSummary: UILabel!
    @IBOutlet var viewNote: UIView!
    
    //MARK: TextInput View
    @IBOutlet var viewTextInputView: UIView!
    @IBOutlet var viewTextInputViewIn: UIView!
    @IBOutlet var txtViewInput: UIPlaceHolderTextView!
    @IBOutlet var lblCharacterLeft: UILabel!
    @IBOutlet var constCharacterLeftViewHeight: NSLayoutConstraint!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dictCreateEventDetail)
        self.initialization()
        
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initialization
    func initialization() {
        btnSave.layer.cornerRadius = 10
        viewTextInputViewIn.layer.cornerRadius = 10
        
        viewTextInputView.frame = CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: Constants.ScreenSize.SCREEN_HEIGHT)
        self.view.addSubview(viewTextInputView)
        viewTextInputView.isHidden = true
        
        if dictCreateEventDetail.value(forKey: "EventTitle") != nil {
            
            lblTitle.text = dictCreateEventDetail.value(forKey: "EventTitle") as? String
            lblSummary.text = dictCreateEventDetail.value(forKey: "EventDescription") as? String
            
            let numberOfChars = lblTitle.text?.characters.count
            lblCharacterLeft.text = "\(String(describing: numberOfChars)) characters left"
        }
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnInputViewAction (_ sender: UIButton) {
        
        viewTextInputView.isHidden = false
        txtViewInput.becomeFirstResponder()
        txtViewInput.text = ""
        
        if sender.tag == 1 {
            
            if lblTitle.text != "Give your event a headline" {
                
                txtViewInput.text = lblTitle.text
                let numberOfChars = txtViewInput.text.characters.count
                lblCharacterLeft.text = "\(numberOfChars) characters left"
            }
            
            txtViewInput.tag = 1
            constCharacterLeftViewHeight.constant = 25
        }else {
            
            if lblSummary.text != "Give a highlight of your event" {
                txtViewInput.text = lblSummary.text
            }
            txtViewInput.tag = 2
            constCharacterLeftViewHeight.constant = 0
        }
    }
    
    @IBAction func btnSaveAction (_ sender: UIButton) {
        if btnSave.isSelected {
            dictCreateEventDetail.setValue(lblTitle.text, forKey: "EventTitle")
            dictCreateEventDetail.setValue(lblSummary.text, forKey: "EventDescription")
            
            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
            EventProfile.insertUpdateEventData(dictEventDetail: dictCreateEventDetail) { (errors: [NSError]?) in
                
                APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                if errors == nil {
                    
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    //MARK:- TextView Delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.tag == 1{
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.characters.count
            if numberOfChars <= 35 {
                lblCharacterLeft.text = "\(35-numberOfChars) characters left"
            }
            return numberOfChars <= 35
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.tag == 1 {
            lblTitle.text = textView.text
            if textView.text == ""{
                lblTitle.text = "Give your event a headline"
            }
        }else{
            lblSummary.text = textView.text
            if textView.text == ""{
                lblSummary.text = "Give a highlight of your event"
            }
        }
        
        
        
        viewTextInputView.isHidden = true
        self.checkForValidation()
    }
    
    //MARK:- Validations
    func checkForValidation() {
        
        if lblTitle.text != "Give your event a headline" && lblSummary.text != "Give a highlight of your event" {
            btnSave.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
            btnSave.isSelected = true
            viewNote.isHidden = true
        }else{
            btnSave.backgroundColor = UIColor.red
            btnSave.isSelected = false
            viewNote.isHidden = false
        }
    }
}
