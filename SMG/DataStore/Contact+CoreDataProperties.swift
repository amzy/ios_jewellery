//
//  Contact+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/11/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var color: String?
    @NSManaged public var comments: String?
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var value: String?

}
