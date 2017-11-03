//
//  ViewController.swift
//  goEventS
//
//  Created by vika on 3/19/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI

struct EventLists {
    var eventName: String!
    var eventPicture: NSData!
    var eventDescription: String!
    var eventCategory: String!
    var latitude: Double!
    var longitude: Double!
    var eventTime: String!
    var eventLocation: String!
    var city: String!
    var country: String!
    var street: String!
    var eventStartTime: String!
}

class EventList:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, MFMailComposeViewControllerDelegate{

    @IBOutlet weak var BarButton: UIBarButtonItem!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var eventListCollectionView: UICollectionView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var messageButtonOutlet: UIButton!
    
  
    var categoryArray = [String]()
    var category = "All"
    var (startDate, endDate) = (Date(), Date())
    var date = ["Today","Tomorrow","Weekend","Custom date"]
    var eventsList = [EventLists]()
    var events:[GoEvent] = []
    weak var delegate: CustomDateView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if revealViewController() != nil {
            BarButton.target = revealViewController()
            BarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        self.fetchData()
        
        self.createCategoryArray()
        
        eventListCollectionView.delegate = self
        eventListCollectionView.dataSource = self
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        messageButtonOutlet.layer.cornerRadius = 24
        

        
        self.entries(from: startDate, to: endDate)
    }

    @IBAction func categoryList(_ sender: Any) {
        
       let indexPath = categoryCollectionView?.indexPath(for: (((sender as AnyObject).superview??.superview) as! UICollectionViewCell))
        print(categoryArray[(indexPath?.row)!])
        category = categoryArray[(indexPath?.row)!]
        eventsList.removeAll()
        self.entries(from: startDate, to: endDate)
    }
   
    @IBAction func dateButton(_ sender: Any) {
        
        let indexPath = dateCollectionView?.indexPath(for: (((sender as AnyObject).superview??.superview) as! UICollectionViewCell))
        var index = Int()
        index = (indexPath?.row)!
        switch index {
        case 0:
            (startDate, endDate) = Calendar.current.todayRange()
            eventsList.removeAll()
            self.entries(from: startDate, to: endDate)

        case 1:
            (startDate, endDate) = Calendar.current.tomorrowRange()
            eventsList.removeAll()
            self.entries(from: startDate, to: endDate)

        case 2:
            (startDate, endDate) = Calendar.current.thisWeekRange()
            eventsList.removeAll()
            self.entries(from: startDate, to: endDate)

        case 3:
            if let dateView = self.storyboard?.instantiateViewController(withIdentifier: "customDateView") as? CustomDateView {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController!.present(dateView, animated: true, completion: nil)
                eventsList.removeAll()
            }
            print(startDate,endDate)
            eventsList.removeAll()
            self.entries(from: startDate, to: endDate)

        default:
            let (startDate, endDate) = Calendar.current.todayRange()
            eventsList.removeAll()
            self.entries(from: startDate, to: endDate)
        }
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
        
    }
    
       
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (collectionView) {
        case categoryCollectionView:
            return categoryArray.count
        case eventListCollectionView:
            return eventsList.count
        case dateCollectionView:
            return date.count
        default:
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? eventCell {
            if collectionView == eventListCollectionView {
                cell.eventNameLabel?.text = eventsList[indexPath.row].eventName
                cell.eventImage?.image = UIImage(data: eventsList[indexPath.row].eventPicture as! Data)
                cell.eventCategortLabel.text = eventsList[indexPath.row].eventCategory
                cell.eventDateLabel.text = eventsList[indexPath.row].eventTime
                cell.eventLocationLabel.text = eventsList[indexPath.row].eventLocation
            }
            if collectionView == categoryCollectionView {
                print(categoryArray[indexPath.row])
                cell.categoryButton.setTitle(categoryArray[indexPath.row], for: .normal)
                
                /*if categoryArray[indexPath.row] == category {
                    cell.categoryButton.backgroundColor = .black
                }*/
            }
            if collectionView == dateCollectionView {
                cell.dateButton.setTitle(date[indexPath.row], for: .normal)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UICollectionViewCell,
            let indexPath = self.eventListCollectionView.indexPath(for: cell) {
            
            let detail = segue.destination as! DetailsView
            let event = eventsList[indexPath.row]
            detail.detailName = event.eventName!
            detail.detailCategory = event.eventCategory!
            detail.detailDescription = event.eventDescription!
            detail.city = event.city!
            detail.country = event.country!
            detail.street = event.street!
            detail.latitude = event.latitude
            detail.longitude = event.longitude
            detail.detailPicture = event.eventPicture!
        }
    }
    
    
    func fetchData(){
        do{
            events = try AppDelegate.getContext().fetch(GoEvent.fetchRequest())
        }
        catch{
            print(error)
        }
    }
    
    func createCategoryArray(){
        categoryArray.append("All")
        for i in 0..<events.count{
            var buf = 0
            for j in 0..<categoryArray.count{
                if events[i].eventCategory == categoryArray[j]{
                    buf += 1
                }
            }
            if buf == 0{
                categoryArray.append(events[i].eventCategory!)
            }
        }
        print(categoryArray)
        self.categoryCollectionView.reloadData()
    }
    
    func entries(from: Date, to: Date){
        print(from,to)
        for i in 0..<events.count {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let time = events[i].eventStartTime
            let date = dateFormatter.date(from: time!)
            let timeCreated = date
            
            if category == events[i].eventCategory! && (from < timeCreated!||from == timeCreated!) && timeCreated! < to{
                eventsList.append(EventLists.init(eventName: events[i].eventName, eventPicture: events[i].eventPicture, eventDescription: events[i].eventDescription, eventCategory: events[i].eventCategory, latitude: events[i].latitude, longitude: events[i].longitude, eventTime: events[i].eventTime, eventLocation: events[i].eventLocation, city: events[i].city, country: events[i].country, street: events[i].street, eventStartTime: events[i].eventStartTime))
            }
            if category == "All" && (from < timeCreated!||from == timeCreated!) && timeCreated! < to{
                eventsList.append(EventLists.init(eventName: events[i].eventName, eventPicture: events[i].eventPicture, eventDescription: events[i].eventDescription, eventCategory: events[i].eventCategory, latitude: events[i].latitude, longitude: events[i].longitude, eventTime: events[i].eventTime, eventLocation: events[i].eventLocation, city: events[i].city, country: events[i].country, street: events[i].street, eventStartTime: events[i].eventStartTime))
            }
        }
        self.eventListCollectionView.reloadData()
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["vikamaksymuk@gmail.com"])
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could no send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}



extension Calendar {
    func todayRange() -> (Date, Date) {
        let startDate = self.startOfDay(for: Date())
        let endDate   = self.date(byAdding: .day, value: 1, to: startDate)!
        return (startDate, endDate)
    }
    
    func tomorrowRange() -> (Date, Date) {
        let endDate   = self.startOfDay(for: Date())
        let startDate = self.date(byAdding: .day, value: +1, to: endDate)!
        return (startDate, endDate)
    }
    
    func thisWeekRange() -> (Date, Date) {
        var components = DateComponents()
        components.weekday = self.firstWeekday
        
        let startDate = self.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime, direction: .backward)!
        let endDate   = self.nextDate(after: startDate, matching: components, matchingPolicy: .nextTime)!
        return (startDate, endDate)
    }
    
    func thisMonthRange() -> (Date, Date) {
        var components = self.dateComponents([.era, .year, .month], from: Date())
        components.day = 1
        
        let startDate = self.date(from: components)!
        let endDate   = self.date(byAdding: .month, value: 1, to: startDate)!
        
        return (startDate, endDate)
    }
}


