//
//  ViewController.swift
//  goEventS
//
//  Created by vika on 3/19/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import UIKit
import Alamofire

struct eventList {
    var eventName: String!
    var eventPicture: NSData!
    var eventDescription: String!
    var eventCategory: String!
    var latitude: Double!
    var longitude: Double!
    var eventTime: String!
    var eventLocation: String!
}

class EventList:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var BarButton: UIBarButtonItem!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var eventListCollectionView: UICollectionView!
    
  
    var categoryArray = [String]()
    var category = "All"
    var eventsList = [eventList]()
    var events:[GoEvent] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if revealViewController() != nil {
            BarButton.target = revealViewController()
            BarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        self.fetchData()
        self.eventListCategory()
        self.createCategoryArray()
        
        eventListCollectionView.delegate = self
        eventListCollectionView.dataSource = self
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }

    func eventListCategory() {
        for i in 0..<events.count {
            if category == events[i].eventCategory{
               eventsList.append(eventList.init(eventName: events[i].eventName, eventPicture: events[i].eventPicture, eventDescription: events[i].eventDescription, eventCategory: events[i].eventCategory, latitude: events[i].latitude, longitude: events[i].longitude, eventTime: events[i].eventTime, eventLocation: events[i].eventLocation))
            }
            if category == "All"{
                 eventsList.append(eventList.init(eventName: events[i].eventName, eventPicture: events[i].eventPicture, eventDescription: events[i].eventDescription, eventCategory: events[i].eventCategory, latitude: events[i].latitude, longitude: events[i].longitude, eventTime: events[i].eventTime, eventLocation: events[i].eventLocation))
            }
        }
        self.eventListCollectionView.reloadData()
    }
    /*func loadList(){
        //load data here
        self.fetchData()
        collectionView.reloadData()
        self.createCategoryArray()
        
        }*/
    
    @IBAction func categoryList(_ sender: Any) {
    }
   
    @IBAction func searchWithAddress(_ sender: Any) {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }

       
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categoryArray.count
        } else {
            return eventsList.count
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
                cell.categoryButton.setTitle(categoryArray[indexPath.row], for: .normal)
                if categoryArray[indexPath.row] == category {
                    cell.categoryButton.backgroundColor = .black
                }
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
           /* let event = events[indexPath.row]
            detail.detailName = event.eventName!
            detail.detailCategory = event.eventCategory!
            detail.detailDescription = event.eventDescription!
            detail.city = event.city!
            detail.country = event.country!
            detail.street = event.street!
            detail.latitude = event.latitude
            detail.longitude = event.longitude
            detail.detailPicture = event.eventPicture!*/
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
    
}


