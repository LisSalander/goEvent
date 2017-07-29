//
//  File.swift
//  goEventS
//
//  Created by vika on 7/17/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class LoadData: NSObject{
    
    typealias JSONStandard = [String: AnyObject]
    
    func downloadEvent(url: String) {
        Alamofire.request(url).responseJSON(completionHandler:{
            response in
            
            self.parseData(JSONData: response.data!)
        })
    }
    
    
    func parseData(JSONData: Data){
        do{
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as? JSONStandard
            if let newEvents = readableJSON?["events"]{
                for i in 0..<newEvents.count{
                    let newEvents = newEvents[i] as! JSONStandard
                    
                    var eventName: String
                    if let _eventName = newEvents["eventName"] as? String {
                        eventName = _eventName
                    } else{
                        eventName = " "
                    }
                    
                    var eventId: String
                    if let _eventId = newEvents["eventId"] as? String {
                        eventId = _eventId
                    } else{
                        eventId = " "
                    }
                    
                    var eventStartTime: String
                    if let _eventStartTime = newEvents["eventStartTime"] as? String {
                        eventStartTime = _eventStartTime
                    } else{
                        eventStartTime = " "
                    }
                    
                    var formatStartTime = String()
                    if eventStartTime != " " {
                        let dateFormatter = DateFormatter()
                        let tempLocale = dateFormatter.locale
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        let start = dateFormatter.date(from: eventStartTime)!
                        dateFormatter.dateFormat = "E,MMM d,HH:mm"
                        dateFormatter.locale = tempLocale
                        formatStartTime = dateFormatter.string(from: start)
                    }
                
                    var eventEndTime: String
                    if let _eventEndTime = newEvents["eventEndTime"] as? String {
                        eventEndTime = _eventEndTime
                    } else{
                        eventEndTime = " "
                    }
                    
                    var formatEndTime = String()
                    if eventEndTime != " " {
                        let dateFormatter = DateFormatter()
                        let tempLocale = dateFormatter.locale
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        let end = dateFormatter.date(from: eventEndTime)!
                        dateFormatter.dateFormat = "HH:mm"
                        dateFormatter.locale = tempLocale
                        formatEndTime = dateFormatter.string(from: end)
                    }
                    
                    
                    var eventPicture: String
                    var image = UIImage()
                    if let _eventPicture = newEvents["eventPicture"] as? String {
                        eventPicture = _eventPicture
                        let imgURL = NSURL(string: eventPicture)
                        let data = NSData(contentsOf: (imgURL as URL?)!)
                        image = UIImage(data: data! as Data)!
                    } else{
                        eventPicture = " "
                    }
                    
                    var eventCategory: String
                    if let _eventCategory = newEvents["eventCategory"] as? String {
                        eventCategory = _eventCategory
                    } else{
                        eventCategory = "No category"
                    }
                    
                    
                    var eventDescription: String
                    if let _eventDescription = newEvents["eventDescription"] as? String {
                        eventDescription = _eventDescription
                    } else{
                        eventDescription = " "
                    }
                    
                    if let eventLocation = newEvents["eventLocation"] as? JSONStandard {
                        let location = eventLocation["location"] as! JSONStandard
                        //print(location)
                        
                        var city: String
                        if let _city = location["eventCategory"] as? String {
                            city = _city
                        } else{
                            city = ""
                        }
                        
                        var country: String
                        if let _country = location["country"] as? String {
                            country  = _country
                        } else{
                            country  = ""
                        }
                        
                        var latitude: Double
                        if let _latitude = location["latitude"] as? Double {
                            latitude  = _latitude
                        } else{
                            latitude  = 0
                        }
                        
                        var longitude: Double
                        if let _longitude = location["longitude"] as? Double {
                            longitude  = _longitude
                        } else{
                            longitude  = 0
                        }
                        
                        var street: String
                        if let _street = location["street"] as? String {
                            street  = _street
                        } else{
                            street  = ""
                        }
                        
                        var eventTime: String
                        if formatEndTime != ""{
                            eventTime = formatStartTime + "-" + formatEndTime
                        }
                        else {
                            eventTime = formatStartTime
                        }
                        
                        var formatCity = String()
                        if city != "" {
                            formatCity = city + ","
                        }
                        var formatCountry = String()
                        if (country != "" && street != "") {
                            formatCountry = country + ","
                        }
                        
                        let _eventLocation: String
                            _eventLocation = formatCity + formatCountry + street
                        
                        let eventClassName:String = String(describing: GoEvent.self)
                        
                        let event:GoEvent = NSEntityDescription.insertNewObject(forEntityName: eventClassName, into: AppDelegate.getContext()) as! GoEvent
                        event.city = city
                        event.country = country
                        event.eventCategory = eventCategory
                        event.eventDescription = eventDescription
                        event.eventEndTime = eventEndTime
                        event.eventStartTime = eventStartTime
                        event.eventPicture = UIImagePNGRepresentation(image) as! NSData
                        event.eventName = eventName
                        event.eventId = eventId
                        event.latitude = latitude
                        event.longitude = longitude
                        event.street = street
                        event.eventLocation = _eventLocation
                        event.eventTime = eventTime
                        
                        AppDelegate.saveContext()
                
                       
                    }
                }
            }
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "control"), object: nil)
        }
        catch{
            print(error)
        }
        
    }
   
}
