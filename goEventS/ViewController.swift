//
//  ViewController.swift
//  goEventS
//
//  Created by vika on 3/19/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import UIKit
import Alamofire



class ViewController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var BarButton: UIBarButtonItem!
  
    struct event {
        var eventName : String!
        var eventId : String!
        var eventPicture: String!
        var eventDescription: String!
        var eventCategory: String!
        var eventStartTime: String!
        var eventEndTime: String!
        var city: String!
        var country: String!
        var latitude: String!
        var longitude: String!
        var street: String!
    }
    
    struct eventFormat {
        var eventTime: String!
        var eventLocation: String!
    }
    
    var events = [event]()
    var eventsFormat = [eventFormat]()
    
    typealias JSONStandard = [String: AnyObject]
    let URL_EVENT = "https://goeventapp.herokuapp.com/v1.0/events"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    
        BarButton.target = self.revealViewController()
        BarButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.downloadEvent(url: URL_EVENT)
        self.collectionView.reloadData()
        
    }
    
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
                    
                    var eventEndTime: String
                    if let _eventEndTime = newEvents["eventEndTime"] as? String {
                        eventEndTime = _eventEndTime
                    } else{
                        eventEndTime = " "
                    }
                    
                    var eventPicture: String
                    if let _eventPicture = newEvents["eventPicture"] as? String {
                        eventPicture = _eventPicture
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
                            print(location)
                            
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
                            
                            var latitude: String
                            if let _latitude = location["latitude"] as? String {
                                latitude  = _latitude
                            } else{
                                latitude  = ""
                            }
                            
                            var longitude: String
                            if let _longitude = location["longitude"] as? String {
                                longitude  = _longitude
                            } else{
                                longitude  = ""
                            }
                            
                            var street: String
                            if let _street = location["street"] as? String {
                                street  = _street
                            } else{
                                street  = ""
                            }
                    events.append(event.init(eventName: eventName, eventId: eventId, eventPicture: eventPicture, eventDescription: eventDescription, eventCategory: eventCategory, eventStartTime: eventStartTime, eventEndTime: eventEndTime, city: city, country: country, latitude: latitude, longitude: longitude, street: street))
                            
                    }
                }
            }
          self.formatData()
          //self.collectionView.reloadData()
        }
        catch{
            print(error)
        }
        
    }
    
    func formatData() {
        for i in 0..<events.count{
            
            let startTime = events[i].eventStartTime
            let endTime = events[i].eventEndTime
            var formatEndTime = String()
            var formatStartTime = String()
            
            if startTime != " " {
                let dateFormatter = DateFormatter()
                let tempLocale = dateFormatter.locale
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let start = dateFormatter.date(from: startTime!)!
                dateFormatter.dateFormat = "E,MMM d,HH:mm"
                dateFormatter.locale = tempLocale
                formatStartTime = dateFormatter.string(from: start)
            }
            
            if endTime != " " {
                
                let dateFormatter = DateFormatter()
                let tempLocale = dateFormatter.locale
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let end = dateFormatter.date(from: endTime!)!
                dateFormatter.dateFormat = "HH:mm"
                dateFormatter.locale = tempLocale
                formatEndTime = dateFormatter.string(from: end)
            }
            
            let _eventTime = formatStartTime + "-" + formatEndTime
            print(_eventTime)
            
            var city = events[i].city
            if city != "" {
                city = city! + ","
            }
            
            var country = events[i].country
            if (country != "" && events[i].street != "") {
                country = country! + ","
            }
            
            let _eventLocation = city! + country! + events[i].street
            print(_eventLocation)
            
            eventsFormat.append(eventFormat.init(eventTime: _eventTime, eventLocation: _eventLocation))
            self.collectionView.reloadData()
        }
    }
 
    

       
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? eventCell {
            
           cell.eventNameLabel?.text = events[indexPath.row].eventName
            if events[indexPath.row].eventPicture != " "{
            let imgURL = NSURL(string: events[indexPath.row].eventPicture)
            let data = NSData(contentsOf: (imgURL as URL?)!)
            cell.eventImage?.image = UIImage(data: data! as Data)
            }
            cell.eventCategortLabel.text = events[indexPath.row].eventCategory
            cell.eventLocationLabel.text = eventsFormat[indexPath.row].eventTime
            cell.eventDateLabel.text = eventsFormat[indexPath.row].eventLocation
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UICollectionViewCell,
            let indexPath = self.collectionView.indexPath(for: cell) {
            
            let detail = segue.destination as! DetailsView
            detail.detailName = events[indexPath.row].eventName
            detail.detailCategory = events[indexPath.row].eventCategory
            detail.detailDescription = events[indexPath.row].eventDescription
            detail.city = events[indexPath.row].city
            detail.country = events[indexPath.row].country
            detail.street = events[indexPath.row].street
            detail.latitude = events[indexPath.row].latitude
            detail.longitude = events[indexPath.row].longitude
            detail.detailPicture = events[indexPath.row].eventPicture
            detail.detailTime = eventsFormat[indexPath.row].eventTime
        }
    }
}


