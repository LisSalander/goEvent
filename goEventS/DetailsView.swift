//
//  DetailView.swift
//  goEventS
//
//  Created by vika on 4/4/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//


import UIKit
import GoogleMaps


class DetailsView : UIViewController, GMSMapViewDelegate{
  
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UITextView!
    @IBOutlet weak var detailTimeLabel: UILabel!
    @IBOutlet weak var detailStreetLabel: UILabel!
    @IBOutlet weak var detailLocationLabel: UILabel!
    @IBOutlet weak var detailAttendingLabel: UILabel!
    @IBOutlet weak var datailMapView: GMSMapView!
    
    var detailName = String()
    var detailPicture = String()
    var detailDescription = String()
    var detailCategory = String()
    var detailTime = String()
    var city = String()
    var country = String()
    var latitude = NSNumber()
    var longitude = NSNumber()
    var street = String()
    var location = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (city != "" && country != ""){
            location = city + "," + country
        } else {
            location = city + country
        }
        
        detailNameLabel.text = detailName
        detailDescriptionLabel.text = detailDescription
        detailTimeLabel.text = detailTime
        detailStreetLabel.text = street
        detailLocationLabel.text = location
        detailAttendingLabel.text = "no attention"
        
        print(longitude)

        if detailPicture != " "{
            let imgURL = NSURL(string: detailPicture)
            let data = NSData(contentsOf: (imgURL as URL?)!)
            detailImage.image = UIImage(data: data! as Data)
            
            let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude), zoom: 15.0)
            
            self.datailMapView.camera = camera
            self.datailMapView.delegate = self
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            marker.map = datailMapView
        }
        
    }




}
