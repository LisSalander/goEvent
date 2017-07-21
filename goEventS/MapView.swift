//
//  MapView.swift
//  goEventS
//
//  Created by vika on 6/15/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import UIKit
import GoogleMaps


class MapView: UIViewController, GMSMapViewDelegate, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
 
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchMap: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!

    var events:[GoEvent] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchData()
        
        searchMap.delegate = self
        let camera = GMSCameraPosition.camera(withLatitude: 50.43, longitude: 30.52, zoom: 13.0)
        
        mapView.camera = camera
        mapView.delegate = self
        
       self.collectionView.reloadData()
       
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mapCell", for: indexPath) as? eventCell {
        
            let event = events[indexPath.row]
            cell.mapEventName.text = event.eventName
            cell.mapEventImage?.image = UIImage(data: event.eventPicture as! Data )
            cell.mapEventDate.text = event.eventTime
            let camera = GMSCameraPosition.camera(withLatitude: event.latitude, longitude: event.longitude, zoom: 15.0)
            
            mapView.camera = camera
            mapView.delegate = self

            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(event.latitude), longitude: CLLocationDegrees(event.longitude))
            marker.map = mapView

 
            return cell
        } else {
            return UICollectionViewCell()
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

}
