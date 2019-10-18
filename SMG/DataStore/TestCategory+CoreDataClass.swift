//
//  TestCategory+CoreDataClass.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/12/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TestCategory)
public class TestCategory: NSManagedObject {
    @nonobjc public class func categoriesForType(type:TestType) -> [TestCategory] {
        do {
            let fetchRequest : NSFetchRequest<TestCategory> = TestCategory.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "type == %i", Int16(type.rawValue))
            let fetchedResults = try DataStore.shared.managedObjectContext.fetch(fetchRequest)
            return fetchedResults
        }
        catch {
            print ("fetch task failed", error)
            return [TestCategory]()
        }
    }
}
