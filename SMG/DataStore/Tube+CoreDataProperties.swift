//
//  Tube+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/12/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension Tube {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tube> {
        return NSFetchRequest<Tube>(entityName: "Tube")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var tubeCount: String?
    @NSManaged public var tests: NSSet?
    @NSManaged public var media: NSSet?

}

// MARK: Generated accessors for test
extension Tube {

    @objc(addTestObject:)
    @NSManaged public func addToTest(_ value: Test)

    @objc(removeTestObject:)
    @NSManaged public func removeFromTest(_ value: Test)

    @objc(addTest:)
    @NSManaged public func addToTest(_ values: NSSet)

    @objc(removeTest:)
    @NSManaged public func removeFromTest(_ values: NSSet)

}
