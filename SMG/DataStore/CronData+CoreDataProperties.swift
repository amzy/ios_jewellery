//
//  CronData+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/20/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension CronData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CronData> {
        return NSFetchRequest<CronData>(entityName: "CronData")
    }

    @NSManaged public var timestamp: String?

}
