//
//  UserTest+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 8/2/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension UserTest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserTest> {
        return NSFetchRequest<UserTest>(entityName: "UserTest")
    }

    @NSManaged public var testID: String?
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for categories
extension UserTest {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: UserCategory)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: UserCategory)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
