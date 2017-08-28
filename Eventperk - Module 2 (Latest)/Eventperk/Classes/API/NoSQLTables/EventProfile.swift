//
//  EventProfile.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.18
//

import Foundation
import UIKit
import AWSDynamoDB
import AWSMobileHubHelper

class EventProfile: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _id: String?
    var _eventCategory: String?
    var _eventDescription: String?
    var _eventLocation: String?
    var _eventLocationInDetail: [String: String]?
    var _eventTitle: String?
    var _eventType: String?
    var _haveVenue: String?
    var _numberOfGuest: String?
    var _sourcingOption: String?
    var _userEmail: String?
    var _venueLocation: String?
    var _venueLocationInDetail: [String: String]?
    var _venuePhotos: NSArray?
    var _eventStartDate: String?
    var _eventEndDate: String?
    var _eventServices: NSArray?
    var _totalEventBudget: String?
    var _theEvent: String?
    var _theItinerary: String?
    var _theLogistics: String?
    var _theAdditional: String?
    var _status: String?
    var _snoozeFrom: String!
    var _snoozeTo: String!
    
    
    class func dynamoDBTableName() -> String {

        return "eventperkios-mobilehub-1122713487-eventProfile"
    }
    
    class func hashKeyAttribute() -> String {

        return "id"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_id" : "id",
            "_eventCategory" : "EventCategory",
            "_eventDescription" : "EventDescription",
            "_eventLocation" : "EventLocation",
            "_eventLocationInDetail" : "EventLocationInDetail",
            "_eventTitle" : "EventTitle",
            "_eventType" : "EventType",
            "_haveVenue" : "HaveVenue",
            "_numberOfGuest" : "NumberOfGuest",
            "_sourcingOption" : "SourcingOption",
            "_userEmail" : "UserEmail",
            "_venueLocation" : "VenueLocation",
            "_venueLocationInDetail" : "VenueLocationInDetail",
            "_venuePhotos" : "VenuePhotos",
            "_eventStartDate" : "EventStartDate",
            "_eventEndDate" : "EventEndDate",
            "_eventServices" : "EventServices",
            "_totalEventBudget" : "TotalEventBudget",
            "_theEvent" : "TheEvent",
            "_theItinerary" : "TheItinerary",
            "_theLogistics" : "TheLogistics",
            "_theAdditional" : "TheAdditional",
            "_status": "Status",
            "_snoozeFrom": "SnoozeFrom",
            "_snoozeTo": "SnoozeTo",
        ]
    }
    
    class func insertUpdateEventData(dictEventDetail: NSMutableDictionary, completionHandler: @escaping (_ errors: [NSError]?) -> Void) {
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        var errors: [NSError] = []
        let group: DispatchGroup = DispatchGroup()
        
        if dictEventDetail.value(forKey: "id") == nil {
            dictEventDetail.setValue(ProjectUtilities.randomSampleStringWithAttributeName("EventId"), forKey: "id")
        }
        
        let eventProfile: EventProfile! = EventProfile()
        eventProfile._id = dictEventDetail.value(forKey: "id") as? String
        eventProfile._status = dictEventDetail.value(forKey: "Status") as? String
        eventProfile._userEmail = Constants.appDelegate.dictUserDetail.value(forKey: "email") as? String
        eventProfile._eventType = dictEventDetail.value(forKey: "EventType") as? String
        eventProfile._eventCategory = dictEventDetail.value(forKey: "EventCategory") as? String
        eventProfile._eventLocation = dictEventDetail.value(forKey: "EventLocation") as? String
        eventProfile._eventLocationInDetail = dictEventDetail.value(forKey: "EventLocationInDetail") as? [String:String]
        eventProfile._numberOfGuest = dictEventDetail.value(forKey: "NumberOfGuest") as? String
        eventProfile._haveVenue = dictEventDetail.value(forKey: "HaveVenue") as? String
        eventProfile._eventTitle = dictEventDetail.value(forKey: "EventTitle") as? String
        eventProfile._eventDescription = dictEventDetail.value(forKey: "EventDescription") as? String
        eventProfile._venueLocation = dictEventDetail.value(forKey: "VenueLocation") as? String
        eventProfile._venueLocationInDetail = dictEventDetail.value(forKey: "VenueLocationInDetail") as? [String:String]
        eventProfile._sourcingOption = dictEventDetail.value(forKey: "SourcingOption") as? String
        eventProfile._eventStartDate = dictEventDetail.value(forKey: "EventStartDate") as? String
        eventProfile._eventEndDate = dictEventDetail.value(forKey: "EventEndDate") as? String
        eventProfile._eventServices = dictEventDetail.value(forKey: "EventServices") as? NSArray
        eventProfile._totalEventBudget = dictEventDetail.value(forKey: "TotalEventBudget") as? String
        eventProfile._theEvent = dictEventDetail.value(forKey: "TheEvent") as? String
        eventProfile._theItinerary = dictEventDetail.value(forKey: "TheItinerary") as? String
        eventProfile._theLogistics = dictEventDetail.value(forKey: "TheLogistics") as? String
        eventProfile._theAdditional = dictEventDetail.value(forKey: "TheAdditional") as? String
        eventProfile._venuePhotos = dictEventDetail.value(forKey: "VenuePhotos") as? NSArray
        
        eventProfile._snoozeFrom = dictEventDetail.value(forKey: "SnoozeFrom") as? String
        eventProfile._snoozeTo = dictEventDetail.value(forKey: "SnoozeTo") as? String
        
        group.enter()
        
        objectMapper.save(eventProfile, completionHandler: {(error: Error?) -> Void in
            if let error = error as NSError? {
                DispatchQueue.main.async(execute: {
                    errors.append(error)
                })
            }
            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main, execute: {
            if errors.count > 0 {
                completionHandler(errors)
            }
            else {
                completionHandler(nil)
            }
        })
    }
    
    class func getEventList(_ completionHandler: @escaping (_ response: NSMutableArray, _ success: Bool) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "begins_with(#UserEmail, :UserEmail)"
        scanExpression.expressionAttributeNames = ["#UserEmail": "UserEmail"]
        scanExpression.expressionAttributeValues = [":UserEmail": (Constants.appDelegate.dictUserDetail.value(forKey: "email") as! String)]
        
        objectMapper.scan(EventProfile.self, expression: scanExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            
            DispatchQueue.main.async(execute: {
                
                if error != nil || response?.items.count == 0 {
                    completionHandler(NSMutableArray(), false)
                }else{
                    var results: [AWSDynamoDBObjectModel] = response!.items
                    print(results)
                    
                    results = ObjectiveCMethods.arrayByReplacingNulls(withBlanks: results as [AnyObject]) as! [AWSDynamoDBObjectModel]
                    
                    let arrEventList = NSMutableArray()
                    
                    for i in 0 ..< results.count{
                        let model: EventProfile = (results[i] as? EventProfile)!
                        
                        let dictEvent = NSMutableDictionary()
                        dictEvent.setValue(model._id!, forKey: "id")
                        dictEvent.setValue(model._status!, forKey: "Status")
                        dictEvent.setValue(model._userEmail!, forKey: "UserEmail")
                        dictEvent.setValue(model._eventType!, forKey: "EventType")
                        dictEvent.setValue(model._eventCategory!, forKey: "EventCategory")
                        dictEvent.setValue(model._eventLocation!, forKey: "EventLocation")
                        dictEvent.setValue(model._numberOfGuest!, forKey: "NumberOfGuest")
                        dictEvent.setValue(model._haveVenue!, forKey: "HaveVenue")
                        
                        if model._eventLocationInDetail != nil {
                            dictEvent.setValue(((model._eventLocationInDetail!) as! NSMutableDictionary).mutableCopy() as! NSMutableDictionary, forKey: "EventLocationInDetail")
                        }
                        
                        if model._eventTitle != nil {
                            dictEvent.setValue(model._eventTitle!, forKey: "EventTitle")
                        }
                        if model._eventDescription != nil {
                            dictEvent.setValue(model._eventDescription!, forKey: "EventDescription")
                        }
                        if model._sourcingOption != nil {
                            dictEvent.setValue(model._sourcingOption!, forKey: "SourcingOption")
                        }
                        if model._venueLocation != nil {
                            dictEvent.setValue(model._venueLocation!, forKey: "VenueLocation")
                        }
                        if model._venueLocationInDetail != nil {
                            dictEvent.setValue(model._venueLocationInDetail!, forKey: "VenueLocationInDetail")
                        }
                        if model._venuePhotos != nil {
                            dictEvent.setValue((model._venuePhotos!).mutableCopy() as! NSMutableArray, forKey: "VenuePhotos")
                        }
                        if model._eventStartDate != nil {
                            dictEvent.setValue(model._eventStartDate!, forKey: "EventStartDate")
                        }
                        if model._eventEndDate != nil {
                            dictEvent.setValue(model._eventEndDate!, forKey: "EventEndDate")
                        }
                        if model._eventServices != nil {
                            dictEvent.setValue((model._eventServices!).mutableCopy() as! NSMutableArray, forKey: "EventServices")
                        }
                        if model._totalEventBudget != nil {
                            dictEvent.setValue(model._totalEventBudget!, forKey: "TotalEventBudget")
                        }
                        if model._theEvent != nil {
                            dictEvent.setValue(model._theEvent!, forKey: "TheEvent")
                        }
                        if model._theItinerary != nil {
                            dictEvent.setValue(model._theItinerary!, forKey: "TheItinerary")
                        }
                        if model._theLogistics != nil {
                            dictEvent.setValue(model._totalEventBudget!, forKey: "TheLogistics")
                        }
                        if model._theAdditional != nil {
                            dictEvent.setValue(model._theAdditional!, forKey: "TheAdditional")
                        }
                        
                        if model._snoozeFrom != nil {
                            
                            dictEvent.setValue(model._snoozeFrom!, forKey: "SnoozeFrom")
                            dictEvent.setValue(model._snoozeTo!, forKey: "SnoozeTo")
                        }
                        
                        arrEventList.add(dictEvent)
                    }
                    
                    completionHandler(arrEventList, true)
                }
            })
        }
    }
    
    class func removeEvent(eventId: String, completionHandler: @escaping ([NSError]?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "begins_with(#id, :id)"
        scanExpression.expressionAttributeNames = ["#id": "id"]
        scanExpression.expressionAttributeValues = [":id": eventId]
        
        objectMapper.scan(EventProfile.self, expression: scanExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if let error = error as NSError? {
                DispatchQueue.main.async(execute: {
                    completionHandler([error]);
                })
            } else {
                var errors: [NSError] = []
                let group: DispatchGroup = DispatchGroup()
                for item in response!.items {
                    group.enter()
                    objectMapper.remove(item, completionHandler: {(error: Error?) in
                        if let error = error as NSError? {
                            DispatchQueue.main.async(execute: {
                                errors.append(error)
                            })
                        }
                        group.leave()
                    })
                }
                group.notify(queue: DispatchQueue.main, execute: {
                    if errors.count > 0 {
                        completionHandler(errors)
                    }
                    else {
                        completionHandler(nil)
                    }
                })
            }
        }
    }
}
