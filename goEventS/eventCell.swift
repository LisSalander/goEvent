//
//  File.swift
//  goEventS
//
//  Created by vika on 3/27/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import Foundation
class eventCell: UICollectionViewCell {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventCategortLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    
    @IBOutlet weak var mapEventImage: UIImageView!
    @IBOutlet weak var mapEventName: UILabel!
    @IBOutlet weak var mapEventDate: UILabel!

    //ROUNDING THE CELL'S BORDER
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Each cell has a layer level where we can modify how it looks
        layer.cornerRadius = 5.0
        
    }
    

    
}
