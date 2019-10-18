//
//  UserTest+CoreDataClass.swift
//  NTFGH
//
//  Created by Amzad Khan on 8/2/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(UserTest)
public class UserTest: NSManagedObject {
    @nonobjc public class func createUserTest(testID:String) -> UserTest {
        let managedObjectContext = DataStore.shared.managedObjectContext
        let newObject   = NSEntityDescription.insertNewObject(forEntityName: "UserTest", into: managedObjectContext) as! UserTest
        newObject.testID = testID
        return newObject
    }
    @nonobjc public class func testForID(testID:String) -> UserTest? {
        do {
            let fetchRequest : NSFetchRequest<UserTest> = UserTest.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "testID == %@", testID)
            let fetchedResults = try DataStore.shared.managedObjectContext.fetch(fetchRequest)
            return fetchedResults.first
        }
        catch {
            print ("fetch task failed", error)
            return nil
        }
    }
}
