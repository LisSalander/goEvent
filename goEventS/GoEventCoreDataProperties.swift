//
//  GoEvent+CoreDataProperties.swift
//  goEventS
//
//  Created by vika on 7/18/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import Foundation
import CoreData


extension GoEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoEvent> {
        return NSFetchRequest<GoEvent>(entityName: "GoEvent")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var eventCategory: String?
    @NSManaged public var eventDescription: String?
    @NSManaged public var eventEndTime: String?
    @NSManaged public var eventStartTime: String?
    @NSManaged public var eventPicture: NSData?
    @NSManaged public var eventName: String?
    @NSManaged public var eventId: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var street: String?
    @NSManaged public var eventLocation: String?
    @NSManaged public var eventTime: String?

}
