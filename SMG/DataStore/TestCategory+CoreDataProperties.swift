//
//  TestCategory+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/12/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData

public enum TestType:Int {
    case none = 0
    case specimen = 1
    case discipline = 2
}

extension TestCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestCategory> {
        return NSFetchRequest<TestCategory>(entityName: "TestCategory")
    }

    @NSManaged public var comments: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var parentId: String?
    @NSManaged public var shortName: String?
    @NSManaged public var type: Int16

    public var testType:TestType {
        if self.type > 0 && self.type < 3 {
            return TestType(rawValue: Int(self.type))!
        }else {
            return .none
        }
    }
}
