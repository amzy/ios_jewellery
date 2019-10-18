//
//  BroadcastMesssage+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 8/10/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension BroadcastMesssage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BroadcastMesssage> {
        return NSFetchRequest<BroadcastMesssage>(entityName: "BroadcastMesssage")
    }

    @NSManaged public var time: Double
    @NSManaged public var title: String?
    @NSManaged public var message: String?
    @NSManaged public var id: String?
    @NSManaged public var isRead: Bool
    @NSManaged public var isLoaded: Bool

}
