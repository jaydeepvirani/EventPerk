//
//  CreateEventStep3VC.swift
//  Eventperk
//
//  Created by Sandeep Gangajaliya on 01/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import CoreLocation

class CreateEventStep3VC: UIViewController, CLLocationManagerDelegate {

    //MARK:- Outlet Declaration
    @IBOutlet var viewLocationInput: UIView!
    
    @IBOutlet var txtAddress: UITextField!
    
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
        
        Constants.appDelegate.locationManager.startUpdatingLocation()
        self.getAddressFromLocation()
        viewLocationInput.layer.cornerRadius = 20
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelAddressTextAction (_ sender: UIButton) {
        txtAddress.text = ""
        txtAddress.becomeFirstResponder()
    }
    
    //MARK:- Address
    
    func getAddressFromLocation(){
        
        let location = CLLocation(latitude: Constants.appDelegate.latitude, longitude: Constants.appDelegate.longitude)
        print(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            Constants.appDelegate.locationManager.stopUpdatingLocation()
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                if let containsPlacemark = (placemarks?[0]) {
                    
                    var strAddress = ""
                    
                    if containsPlacemark.locality != nil {
                        strAddress = strAddress + containsPlacemark.locality! + ", "
                    }
                    if containsPlacemark.country != nil {
                        strAddress = strAddress + containsPlacemark.country! + " "
                    }
                    print(strAddress)
                    self.txtAddress.text = strAddress
                }
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createEventStep4Segue" {
            
            dictCreateEventDetail.setValue(txtAddress.text, forKey: "Location")
            
            let vc: CreateEventStep4VC = segue.destination as! CreateEventStep4VC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }
    }
}

