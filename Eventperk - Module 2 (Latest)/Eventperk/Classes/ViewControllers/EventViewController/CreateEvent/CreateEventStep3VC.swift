//
//  CreateEventStep3VC.swift
//  Eventperk
//
//  Created by Sandeep Gangajaliya on 01/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CreateEventStep3VC: UIViewController, CLLocationManagerDelegate, PlaceSearchTextFieldDelegate, UIScrollViewDelegate, UITextFieldDelegate {

    //MARK:- Outlet Declaration
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblTypeDescription: UILabel!
    @IBOutlet var lblLocationDescription: UILabel!
    
    @IBOutlet var scrlView: UIScrollView!
    @IBOutlet var viewLocationInput: UIView!
    @IBOutlet var txtAddress: MVPlaceSearchTextField!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var btnNext: UIButton!
    
    @IBOutlet var constNoteViewHeight: NSLayoutConstraint!
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var dictLocationInDetail = NSMutableDictionary()
    var annotation = MKPointAnnotation()
    var isFromCreateEventStep5 = false
    
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
        
        txtAddress.placeSearchDelegate                 = self
        txtAddress.strApiKey                           = "AIzaSyC19LdEsnuBpSlirKQ5pXUKzTm6eqJnFFw"
        txtAddress.superViewOfList                     = self.view
        txtAddress.autoCompleteShouldHideOnSelection   = true
        txtAddress.maximumNumberOfAutoCompleteRows     = 5
        txtAddress.autoCompleteRegularFontName =  "HelveticaNeue-Bold"
        txtAddress.autoCompleteBoldFontName = "HelveticaNeue"
        txtAddress.autoCompleteTableCornerRadius=0.0
        txtAddress.autoCompleteRowHeight=35
        txtAddress.autoCompleteTableCellTextColor=UIColor.black// [UIColor colorWithWhite:0.131 alpha:1.000]
        txtAddress.autoCompleteFontSize=14
        txtAddress.autoCompleteTableBorderWidth=1.0
        txtAddress.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=true
        txtAddress.autoCompleteShouldHideOnSelection=true
        txtAddress.autoCompleteShouldHideClosingKeyboard=true
        txtAddress.autoCompleteShouldSelectOnExactMatchAutomatically = true
        txtAddress.autoCompleteTableFrame = CGRect.init(x: 10, y: 200, width: Constants.ScreenSize.SCREEN_WIDTH - 20, height: 200)//Make(57, txtPlaceSearch.frame.size.height+150.0, 254, 200.0);
        
        Constants.appDelegate.locationManager.startUpdatingLocation()
        self.getAddressFromLocation()
        viewLocationInput.layer.cornerRadius = 20
        
        let location = CLLocationCoordinate2D(latitude: Constants.appDelegate.latitude, longitude: Constants.appDelegate.longitude)
        let viewRegion = MKCoordinateRegionMakeWithDistance(location, 200, 200)
        mapView.setRegion(viewRegion, animated: false)
        
        if isFromCreateEventStep5 == true {
            lblTitle.text = "Venue"
            lblTypeDescription.text = "Input your event location and upload images to make your profile look great!"
            lblLocationDescription.text = "Please search and set you location"
        }else{
            constNoteViewHeight.constant = 0
        }
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelAddressTextAction (_ sender: UIButton) {
        txtAddress.text = ""
        txtAddress.becomeFirstResponder()
        
        btnNext.isSelected = false
        btnNext.backgroundColor = UIColor.red
        
        let location = CLLocationCoordinate2D(latitude: Constants.appDelegate.latitude, longitude: Constants.appDelegate.longitude)
        let viewRegion = MKCoordinateRegionMakeWithDistance(location, 200, 200)
        mapView.setRegion(viewRegion, animated: false)
        
        mapView.removeAnnotation(annotation)
        
        dictLocationInDetail = NSMutableDictionary()
    }
    
    @IBAction func btnNextAction (_ sender: UIButton) {
        if btnNext.isSelected == true {
            if isFromCreateEventStep5 == false {
                self.performSegue(withIdentifier: "createEventStep4Segue", sender: nil)
            }else{
                self.performSegue(withIdentifier: "venueLocationSegue", sender: nil)
            }
        }
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
            
            self.dictLocationInDetail = NSMutableDictionary()
            
            if (placemarks?.count)! > 0 {
                if let containsPlacemark = (placemarks?[0]) {
                    
                    var strAddress = ""
                    if containsPlacemark.subThoroughfare != nil {
                        strAddress = strAddress + containsPlacemark.subThoroughfare! + " "
                        self.dictLocationInDetail.setValue(containsPlacemark.subThoroughfare, forKey: "Unit")
                    }
                    if containsPlacemark.thoroughfare != nil {
                        strAddress = strAddress + containsPlacemark.thoroughfare! + " "
                        self.dictLocationInDetail.setValue(containsPlacemark.thoroughfare, forKey: "Street")
                    }
                    if containsPlacemark.locality != nil {
                        strAddress = strAddress + containsPlacemark.locality! + " "
                        self.dictLocationInDetail.setValue(containsPlacemark.locality, forKey: "City")
                    }
                    if containsPlacemark.administrativeArea != nil {
                        strAddress = strAddress + containsPlacemark.administrativeArea! + " "
                        self.dictLocationInDetail.setValue(containsPlacemark.administrativeArea, forKey: "State")
                    }
                    if containsPlacemark.postalCode != nil {
                        strAddress = strAddress + containsPlacemark.postalCode! + " "
                        self.dictLocationInDetail.setValue(containsPlacemark.postalCode, forKey: "PostalCode")
                    }
                    if containsPlacemark.country != nil {
                        strAddress = strAddress + containsPlacemark.country!
                        self.dictLocationInDetail.setValue(containsPlacemark.country, forKey: "Country")
                    }
                    
                    print(strAddress)
                    self.txtAddress.text = strAddress
                    
                    self.btnNext.isSelected = true
                    self.btnNext.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
                }
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    //MARK: Google Place API
    public func placeSearchResponse(forSelectedPlace responseDict: NSMutableDictionary!) {
        
        print(responseDict)
        
        mapView.removeAnnotation(annotation)
        
        let location = CLLocationCoordinate2D(latitude: (((responseDict.value(forKey:"result") as! NSDictionary).value(forKey:"geometry") as! NSDictionary).value(forKey:"location") as! NSDictionary).value(forKey: "lat")  as! Double, longitude: (((responseDict.value(forKey:"result") as! NSDictionary).value(forKey:"geometry") as! NSDictionary).value(forKey:"location") as! NSDictionary).value(forKey: "lng")  as! Double)
        annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        let viewRegion = MKCoordinateRegionMakeWithDistance(location, 200, 200)
        mapView.setRegion(viewRegion, animated: false)
        
        btnNext.isSelected = true
        btnNext.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        
        dictLocationInDetail = NSMutableDictionary()
        if responseDict.value(forKey: "result") != nil && (responseDict.value(forKey: "result") as! NSDictionary).value(forKey: "address_components") != nil{
            
            if let arrTemp = (responseDict.value(forKey: "result") as! NSDictionary).value(forKey: "address_components") as? NSArray {
                
                for i in 0 ..< arrTemp.count {
                    
                    let strKeyName = ((arrTemp.object(at: i) as! NSDictionary).value(forKey: "types") as! NSArray).object(at: 0) as! String
                    let strValue = (arrTemp.object(at: i) as! NSDictionary).value(forKey: "long_name") as! String
                    
                    if  strKeyName == "street_number" {
                        dictLocationInDetail.setValue(strValue, forKey: "Unit")
                    }
                    if  strKeyName == "route" {
                        dictLocationInDetail.setValue(strValue, forKey: "Street")
                    }
                    if  strKeyName == "locality" {
                        dictLocationInDetail.setValue(strValue, forKey: "City")
                    }
                    if  strKeyName == "administrative_area_level_1" {
                        dictLocationInDetail.setValue(strValue, forKey: "State")
                    }
                    if  strKeyName == "country" {
                        dictLocationInDetail.setValue(strValue, forKey: "Country")
                    }
                    if  strKeyName == "postal_code" {
                        dictLocationInDetail.setValue(strValue, forKey: "PostalCode")
                    }
                }
            }
        }
    }
    
    public func placeSearchWillShowResult() {
        
    }
    
    public func placeSearchWillHideResult() {
        
    }
    public func placeSearchResultCell(_ cell: UITableViewCell!, with placeObject: PlaceObject!, at index: Int) {
        
        if index % 2 == 0 {
            
            cell.contentView.backgroundColor = UIColor.lightGray
        }else{
            cell.contentView.backgroundColor = UIColor.white
        }
    }
    
    //MARK:- TextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        dictLocationInDetail = NSMutableDictionary()
        scrlView.setContentOffset(CGPoint.init(x: 0, y: 120), animated: true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrlView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        
        if txtAddress.text != "" {
            btnNext.isSelected = true
            btnNext.backgroundColor = UIColor.init(red: 0.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        }else{
            btnNext.isSelected = false
            btnNext.backgroundColor = UIColor.red
        }
    }
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createEventStep4Segue" {
            
            dictCreateEventDetail.setValue(txtAddress.text, forKey: "Location")
            dictCreateEventDetail.setValue(dictLocationInDetail, forKey: "EventLocationInDetial")
            
            let vc: CreateEventStep4VC = segue.destination as! CreateEventStep4VC
            vc.dictCreateEventDetail = dictCreateEventDetail
            
        }else if segue.identifier == "venueLocationSegue"{
            
            dictCreateEventDetail.setValue(txtAddress.text, forKey: "VenueLocation")
            dictCreateEventDetail.setValue(dictLocationInDetail, forKey: "VenueLocationInDetial")
           
            let vc: EventVenueLocationVC = segue.destination as! EventVenueLocationVC
            vc.dictCreateEventDetail = dictCreateEventDetail
        }
    }
}

