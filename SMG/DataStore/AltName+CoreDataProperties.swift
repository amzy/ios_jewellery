//
//  AltName+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/12/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension AltName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AltName> {
        return NSFetchRequest<AltName>(entityName: "AltName")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var testID: String?
    @NSManaged public var tests: NSSet?

}

// MARK: Generated accessors for test
extension AltName {

    @objc(addTestObject:)
    @NSManaged public func addToTest(_ value: Test)

    @objc(removeTestObject:)
    @NSManaged public func removeFromTest(_ value: Test)

    @objc(addTest:)
    @NSManaged public func addToTest(_ values: NSSet)

    @objc(removeTest:)
    @NSManaged public func removeFromTest(_ values: NSSet)

}
