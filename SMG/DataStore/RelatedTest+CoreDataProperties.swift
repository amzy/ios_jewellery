//
//  RelatedTest+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/20/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension RelatedTest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RelatedTest> {
        return NSFetchRequest<RelatedTest>(entityName: "RelatedTest")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var tests: NSSet?

}
