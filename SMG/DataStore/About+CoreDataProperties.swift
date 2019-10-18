//
//  About+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/11/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension About {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<About> {
        return NSFetchRequest<About>(entityName: "About")
    }

    @NSManaged public var content: String?
    @NSManaged public var id: String?
    @NSManaged public var memoURL: String?
    @NSManaged public var slug: String?
    @NSManaged public var title: String?

}
