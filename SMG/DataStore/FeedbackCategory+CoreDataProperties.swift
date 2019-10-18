//
//  FeedbackCategory+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/11/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension FeedbackCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedbackCategory> {
        return NSFetchRequest<FeedbackCategory>(entityName: "FeedbackCategory")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var parentID: String?
}
