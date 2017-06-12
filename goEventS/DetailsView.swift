//
//  DetailView.swift
//  goEventS
//
//  Created by vika on 4/4/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DetailsView : UIViewController{
  
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UITextView!
    @IBOutlet weak var detailTimeLabel: UILabel!
    @IBOutlet weak var detailStreetLabel: UILabel!
    @IBOutlet weak var detailLocationLabel: UILabel!
    @IBOutlet weak var detailAttendingLabel: UILabel!

    var detailName = String()
    var detailPicture = String()
    var detailDescription = String()
    var detailCategory = String()
    var detailTime = String()
    var city = String()
    var country = String()
    var latitude = String()
    var longitude = String()
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
        
        if detailPicture != " "{
            let imgURL = NSURL(string: detailPicture)
            let data = NSData(contentsOf: (imgURL as URL?)!)
            detailImage.image = UIImage(data: data! as Data)
        }
    }




}
