//
//  AddNumberViewController.swift
//  Eventperk
//
//  Created by HARSHIT on 12/05/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

protocol AddPhoneNumberDelegate: class
{
    func phoneNumberVerified(strPhoneNumber: String)
}

class AddNumberViewController: UIViewController,UITextFieldDelegate
{
    @IBOutlet var phone_image:UIImageView!
    @IBOutlet var lbl_Status:UILabel!
    @IBOutlet var lbl_Detail:UILabel!
    @IBOutlet var txt_Mobile:UITextField!
    @IBOutlet var txt_Code:UITextField!
    @IBOutlet var btn_Send:UIButton!
    @IBOutlet var btn_Save:UIButton!
    @IBOutlet var btn_Clear:UIButton!
    let infoView = EPInfoView.instanceFromNib() as! EPInfoView
    
    weak var delegate: AddPhoneNumberDelegate?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btn_Clear.isHidden = true
        btn_Save.isHidden = true
        txt_Code.isHidden = true
        btn_Send.isHidden = false
    }
    
    @IBAction func clk_Back(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clk_Send(_ sender: UIButton)
    {
        if (txt_Mobile.text?.length)!>10
        {
            btn_Clear.isHidden = false
            btn_Save.isHidden = true
            txt_Code.isHidden = false
            btn_Send.isHidden = true
            phone_image.image = UIImage(named: "ic_ShakePhone")
            lbl_Status.text = "Code sent!"
            lbl_Detail.text = "Please enter the verification code."
        }
        else
        {
            infoView.show(at: self.view, title: "Please try again", subtitle: "Enter valid 10 digit mobile number!")
        }
    }

    @IBAction func clk_Save(_ sender: UIButton)
    {
        delegate?.phoneNumberVerified(strPhoneNumber: txt_Mobile.text!)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clk_Clear(_ sender: UIButton)
    {
        btn_Clear.isHidden = true
        btn_Save.isHidden = true
        txt_Code.isHidden = true
        btn_Send.isHidden = false
        phone_image.image = UIImage(named: "ic_BlackPhone")
        lbl_Status.text = "Add Phone Number"
        lbl_Detail.text = "Please enter you phone number and we'll send you a verification code"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if (textField == txt_Code && (textField.text?.length)!>=4)
        {
            btn_Clear.isHidden = true
            btn_Save.isHidden = false
            txt_Code.isHidden = true
            btn_Send.isHidden = true
            phone_image.image = UIImage(named: "ic_GreenPhone")
            lbl_Status.text = "Verification added!"
            lbl_Detail.text = txt_Mobile.text
            txt_Mobile.isHidden = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txt_Mobile
        {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@)", areaCode)
                index += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
            
        }
        else if(textField == txt_Code)
        {
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else {
            return true
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
