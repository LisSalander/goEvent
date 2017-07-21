//
//  ViewController.swift
//  goEventS
//
//  Created by vika on 3/19/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import UIKit
import Alamofire


class ViewController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var BarButton: UIBarButtonItem!
    var categoryArray = ["All"]
    
    let URL_EVENT = "https://goeventapp.herokuapp.com/v1.0/events-location?lat=50.43&lng=30.52&distance=4000"
    let loadData = LoadData()
    var events:[GoEvent] = []
    let customSegmente = CustomSegmenteControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        BarButton.target = self.revealViewController()
        BarButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.loadData.downloadEvent(url: URL_EVENT)
        self.collectionView.reloadData()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
      //  CustomSegmenteControl.items = [""]
        
    }

    func loadList(){
        //load data here
        self.fetchData()
        self.collectionView.reloadData()
        self.createCategoryArray()
        customSegmente.items = categoryArray
        customSegmente.setupAllLabels()
    }
    
    @IBAction func update(sender: CustomSegmenteControl) {
        self.collectionView.reloadData()
        let index = sender.selectedIndex
        for i in 0..<events.count{
            if categoryArray[index] == events[i].eventCategory{
                
            }
        }
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
        return events.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? eventCell {
            let event = events[indexPath.row]
        
            cell.eventNameLabel?.text = event.eventName
            cell.eventImage?.image = UIImage(data: event.eventPicture as! Data)
            cell.eventCategortLabel.text = event.eventCategory
            cell.eventDateLabel.text = event.eventTime
            cell.eventLocationLabel.text = event.eventLocation

           
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UICollectionViewCell,
            let indexPath = self.collectionView.indexPath(for: cell) {
            
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
    }
    
}


