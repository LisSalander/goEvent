//
//  ViewController.swift
//  goEventS
//
//  Created by vika on 7/26/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var mainImageCollectionView: UICollectionView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var BarButton: UIBarButtonItem!
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    @IBOutlet weak var locationButtonOutlet: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var mapLocationButton: UIButton!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var categoryArray = [String]()
    
    var lat = Double()
    var lng = Double()
    var URL_EVENT = String()
    var city = String()
    var country = String()
    
    let loadData = LoadData()
    var events:[GoEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.deleteAllRecords()

        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        mainImageCollectionView.delegate = self
        mainImageCollectionView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.stopMonitoringSignificantLocationChanges()
        //locationManager.startUpdatingLocation()
        
        //if revealViewController() != nil {
            BarButton.target = revealViewController()
            BarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //}
        
        NotificationCenter.default.addObserver(self, selector: #selector(controlActivityIndecator), name: NSNotification.Name(rawValue: "control"), object: nil)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.activityIndecator.startAnimating()

        locationAuthStatus()
    }

    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = AppDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GoEvent")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            currentLocation = locationManager.location
            if currentLocation != nil {
                lat = currentLocation.coordinate.latitude
                lng = currentLocation.coordinate.longitude
                URL_EVENT = "https://goeventapp.herokuapp.com/v1.0/events-location?lat=\(lat)&lng=\(lng)&distance=4000"
                self.loadData.downloadEvent(url: URL_EVENT)
            
                let loca = CLLocation(latitude: lat, longitude: lng)
                CLGeocoder().reverseGeocodeLocation(loca) { (placemarks, error) in                    var placemark : CLPlacemark!
                    placemark = placemarks?.first
                    self.city = (placemark.addressDictionary?["City"] as! String)
                    self.country = (placemark.addressDictionary?["Country"] as! String)
                    print(self.city)
                  
                }
            
            } else {
                //locationManager.requestWhenInUseAuthorization()
                locationAuthStatus()
            }
            
        } else {
          locationManager.requestWhenInUseAuthorization()
          locationAuthStatus()
        }
    }
    
    @objc func controlActivityIndecator() {
        self.fetchData()
        print(events)
       // self.mainCollectionView.reloadData()
        self.activityIndecator.stopAnimating()
        activityIndecator.isHidden = true
        
        self.locationButtonOutlet.setTitle(self.city + "," + self.country, for: .normal)
        self.mapLocationButton.setTitle("Біля мене", for: .normal)
        mainImageCollectionView.reloadData()
        self.createCategoryArray()
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
        self.categoryLabel.text = "Категорії"
        mainCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollectionView {
            return categoryArray.count
        } else {
            return events.count
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as? eventCell {
            if collectionView == mainCollectionView {
                cell.mainCategoryLabel.text = categoryArray[indexPath.row]
                cell.mainCategoryLabel.layer.masksToBounds = true
                cell.mainCategoryLabel.layer.cornerRadius = 15
                cell.mainCategoryLabel.layer.borderWidth = 1
                cell.mainCategoryLabel.layer.borderColor = UIColor.black.cgColor
                
                
            } else {
                cell.mainImage?.image = UIImage(data: events[indexPath.row].eventPicture as! Data)
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UICollectionViewCell,
            let indexPath = self.mainImageCollectionView.indexPath(for: cell) {
            
            let detail = segue.destination as! DetailsView
            let event = events[indexPath.row]
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
        if let cell = sender as? UICollectionViewCell,
        let indexPath = self.mainCollectionView.indexPath(for: cell){
            
            let list = segue.destination as! EventList
            //let event = events[indexPath.row]
            list.category = categoryArray[indexPath.row]
        }
        
    }


}
