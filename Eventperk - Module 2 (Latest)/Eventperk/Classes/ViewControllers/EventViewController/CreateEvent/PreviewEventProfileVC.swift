//
//  PreviewEventProfileVC.swift
//  Eventperk
//
//  Created by Sandeep on 11/08/17.
//  Copyright © 2017 Eventperk. All rights reserved.
//

import UIKit

class PreviewEventProfileVC: UIViewController {

    //MARK:- Outlet Declaration
    @IBOutlet var colPhotos: UICollectionView!
    @IBOutlet var colServices: UICollectionView!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblCountry: UILabel!
    @IBOutlet var lblEventDate: UILabel!
    @IBOutlet var lblOrganizedBy: UILabel!
    @IBOutlet var lblSummary: UILabel!
    @IBOutlet var lblTypeOfEvent: UILabel!
    @IBOutlet var lblGuest: UILabel!
    @IBOutlet var lblBudget: UILabel!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var lblVenue: UILabel!
    
    @IBOutlet var lblTheEventTitle: UILabel!
    @IBOutlet var lblTheEvent: UILabel!
    @IBOutlet var lblTheItineraryTitle: UILabel!
    @IBOutlet var lblTheItinerary: UILabel!
    @IBOutlet var lblTheLogisticTitle: UILabel!
    @IBOutlet var lblTheLogistic: UILabel!
    @IBOutlet var lblTheAdditionalTitle: UILabel!
    @IBOutlet var lblTheAdditional: UILabel!
    
    
    //MARK: Other Objects
    var dictCreateEventDetail = NSMutableDictionary()
    var arrPhotos = NSMutableArray()
    var arrServices = NSMutableArray()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initialization
    func initialization() {
        
        if dictCreateEventDetail.value(forKey: "VenuePhotos") != nil {
            
            arrPhotos.addObjects(from: dictCreateEventDetail.value(forKey: "VenuePhotos") as? NSMutableArray as! [Any])
        }
        if dictCreateEventDetail.value(forKey: "EventServices") != nil {
            
            let arrTemp = dictCreateEventDetail.value(forKey: "EventServices") as! NSMutableArray
            
            for i in 0 ..< arrTemp.count {
                if (arrTemp.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") != nil {
                    for j in 0 ..< ((arrTemp.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).count {
                        
                        if (((arrTemp.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "ItemCount") != nil && (((arrTemp.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary).value(forKey: "ItemCount") as! NSInteger != 0 {
                            
                            let dict = ((arrTemp.object(at: i) as! NSMutableDictionary).value(forKey: "SubServices") as! NSMutableArray).object(at: j) as! NSMutableDictionary
                            
                            arrServices.add(dict)
                        }
                    }
                }
            }
        }
        
        if dictCreateEventDetail.value(forKey: "EventTitle") != nil {
            lblTitle.text = dictCreateEventDetail.value(forKey: "EventTitle") as? String
        }
        
        if dictCreateEventDetail.value(forKey: "EventLocationInDetial") != nil && (dictCreateEventDetail.value(forKey: "EventLocationInDetial") as! NSMutableDictionary).value(forKey: "Country") != nil{
            
            lblCountry.text = (dictCreateEventDetail.value(forKey: "EventLocationInDetial") as! NSMutableDictionary).value(forKey: "Country") as? String
        }
        
        if dictCreateEventDetail.value(forKey: "EventStartDate") != nil {
            
            lblEventDate.text = ProjectUtilities.changeDateFormate(strDate: dictCreateEventDetail.value(forKey: "EventStartDate") as! String, strFormatter1: "MMM dd, yyyy hh:mm a", strFormatter2: "MMM dd, yyyy") as String
        }
        
        lblOrganizedBy.text = "Organized by \(Constants.appDelegate.dictUserDetail.value(forKey: "given_name") as! String)"
        
        lblSummary.text = dictCreateEventDetail.value(forKey: "EventDescription") as? String
        
        lblTypeOfEvent.text = "\(dictCreateEventDetail.value(forKey: "EventType") as! String)/\(dictCreateEventDetail.value(forKey: "EventCategory") as! String)"
        
        lblGuest.text = dictCreateEventDetail.value(forKey: "NumberOfGuest") as? String
        
        if dictCreateEventDetail.value(forKey: "TotalEventBudget") != nil  {
            lblBudget.text = "$\(dictCreateEventDetail.value(forKey: "TotalEventBudget") as! String) SGD"
        }
        
        if dictCreateEventDetail.value(forKey: "EventStartDate") != nil && dictCreateEventDetail.value(forKey: "EventEndDate") != nil {
            
            lblDuration.text = "\(dictCreateEventDetail.value(forKey: "EventStartDate") as! String) to \(dictCreateEventDetail.value(forKey: "EventEndDate") as! String)"
        }
        
        if dictCreateEventDetail.value(forKey: "VenueLocation") != nil  {
            lblVenue.text = dictCreateEventDetail.value(forKey: "VenueLocation") as? String
        }
        
        if dictCreateEventDetail.value(forKey: "TheEvent") != nil  {
            
            lblTheEventTitle.text = "\nThe Event:"
            lblTheEvent.text = dictCreateEventDetail.value(forKey: "TheEvent") as? String
        }else{
            lblTheEventTitle.text = ""
            lblTheEvent.text = ""
        }
        if dictCreateEventDetail.value(forKey: "TheItinerary") != nil  {
            lblTheItineraryTitle.text = "\nThe Itinerary:"
            lblTheItinerary.text = dictCreateEventDetail.value(forKey: "TheItinerary") as? String
        }else{
            lblTheItineraryTitle.text = ""
            lblTheItinerary.text = ""
        }
        if dictCreateEventDetail.value(forKey: "TheLogistics") != nil  {
            lblTheLogisticTitle.text = "\nThe Logistics:"
            lblTheLogistic.text = dictCreateEventDetail.value(forKey: "TheLogistics") as? String
        }else{
            lblTheLogisticTitle.text = ""
            lblTheLogistic.text = ""
        }
        if dictCreateEventDetail.value(forKey: "TheAdditional") != nil  {
            lblTheAdditionalTitle.text = "\nThe Additional:"
            lblTheAdditional.text = dictCreateEventDetail.value(forKey: "TheAdditional") as? String
        }else{
            lblTheAdditionalTitle.text = ""
            lblTheAdditional.text = ""
        }
    }
    
    //MARK:- Button TouchUp
    @IBAction func btnBackAction (_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UICollectionView
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        if collectionView == colPhotos {
            return arrPhotos.count
        }else{
            return arrServices.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell{
        
        if collectionView == colPhotos {
            let cell : PreviewEventProfilePhotoCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewEventProfilePhotoCollectionCell", for: indexPath) as! PreviewEventProfilePhotoCollectionCell
            
            cell.imgPhoto.image = arrPhotos.object(at: indexPath.row) as? UIImage
            
            return cell
        }else{
            let cell : PreviewEventProfileServiceCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewEventProfileServiceCollectionCell", for: indexPath) as! PreviewEventProfileServiceCollectionCell
            
            cell.imgServiceIcon.image = UIImage(named: (arrServices.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "SubServiceTitle") as! String)
            cell.lblServiceTitle.text = "\((arrServices.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "ItemCount")!) \((arrServices.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "SubServiceTitle") as! String)"
            
            return cell
        }
    }
    
    func collectionView(_ collectionView : UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize{
        
        if collectionView == colPhotos {
            return CGSize.init(width: Constants.ScreenSize.SCREEN_WIDTH, height: 250)
        }else{
            let size: CGSize = "\((arrServices.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "ItemCount")!) \((arrServices.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "SubServiceTitle") as! String)".size(attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 13.0)])
            return CGSize.init(width: size.width, height: 70)
        }
    }
}

class PreviewEventProfilePhotoCollectionCell: UICollectionViewCell {
    @IBOutlet var imgPhoto: UIImageView!
}

class PreviewEventProfileServiceCollectionCell: UICollectionViewCell {
    
    @IBOutlet var imgServiceIcon: UIImageView!
    @IBOutlet var lblServiceTitle: UILabel!
}
