//
//  CoreMedia+CoreDataProperties.swift
//  RealFriend
//
//  Created by Amzad Khan on 26/01/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//
//

import Foundation
import CoreData


extension CoreMedia {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreMedia> {
        return NSFetchRequest<CoreMedia>(entityName: "CoreMedia")
    }

    @NSManaged public var localURL: String?
    @NSManaged public var type: String?
    @NSManaged public var url: String?

}
