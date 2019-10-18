//
//  UserCategory+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 8/2/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension UserCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCategory> {
        return NSFetchRequest<UserCategory>(entityName: "UserCategory")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var type: Int16
    @NSManaged public var tests: NSSet?
    
    public var testType:TestType {
        if self.type > 0 && self.type < 3 {
            return TestType(rawValue: Int(self.type))!
        }else {
            return .none
        }
    }
}

// MARK: Generated accessors for tests
extension UserCategory {

    @objc(addTestsObject:)
    @NSManaged public func addToTests(_ value: UserTest)

    @objc(removeTestsObject:)
    @NSManaged public func removeFromTests(_ value: UserTest)

    @objc(addTests:)
    @NSManaged public func addToTests(_ values: NSSet)

    @objc(removeTests:)
    @NSManaged public func removeFromTests(_ values: NSSet)

}
