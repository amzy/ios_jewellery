//
//  Specimen+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/12/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension Specimen {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Specimen> {
        return NSFetchRequest<Specimen>(entityName: "Specimen")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var tests: NSSet?

}

// MARK: Generated accessors for test
extension Specimen {

    @objc(addTestObject:)
    @NSManaged public func addToTest(_ value: Test)

    @objc(removeTestObject:)
    @NSManaged public func removeFromTest(_ value: Test)

    @objc(addTest:)
    @NSManaged public func addToTest(_ values: NSSet)

    @objc(removeTest:)
    @NSManaged public func removeFromTest(_ values: NSSet)

}
