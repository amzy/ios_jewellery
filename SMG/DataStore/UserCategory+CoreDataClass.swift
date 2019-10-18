//
//  UserCategory+CoreDataClass.swift
//  NTFGH
//
//  Created by Amzad Khan on 8/2/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(UserCategory)
public class UserCategory: NSManagedObject {
    
    @nonobjc public class func categoriesForType(type:TestType) -> [UserCategory] {
        do {
            let fetchRequest : NSFetchRequest<UserCategory> = UserCategory.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "type == %i", Int16(type.rawValue))
            let fetchedResults = try DataStore.shared.managedObjectContext.fetch(fetchRequest)
            
            return fetchedResults
        }
        catch {
            print ("fetch task failed", error)
            return [UserCategory]()
        }
    }
    
    @nonobjc public class func createUserCategory(name:String, type:TestType) -> UserCategory? {
        
        let managedObjectContext = DataStore.shared.managedObjectContext
        do {
            let fetchRequest : NSFetchRequest<UserCategory> = UserCategory.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            let fetchedResults = try managedObjectContext.fetch(fetchRequest)
            if fetchedResults.count > 0 {
                return fetchedResults.first
            }else {
                let newObject   = NSEntityDescription.insertNewObject(forEntityName: "UserCategory", into: managedObjectContext) as! UserCategory
                newObject.id    = ""
                newObject.name  =  name
                newObject.type  = Int16(type.rawValue)
                DataStore.shared.saveContext()
                return newObject
            }
        }
        catch {
            print ("fetch task failed", error)
            return nil
        }
    }
    func addTest(testID:String) -> Bool {
        if self.tests == nil {
            self.tests = NSSet()
        }
        if let test:[UserTest] = self.tests?.toArray() {
            let savedTests  = test.filter { (item) -> Bool in
                return item.testID == testID
            }
            if savedTests.count > 0  {
                return false
            }else {
                let testObj = UserTest.createUserTest(testID: testID)
                let test = self.mutableSetValue(forKey: "tests")
                test.add(testObj)
                return true
            }
        }else {
            let testObj = UserTest.createUserTest(testID: testID)
            let test = self.mutableSetValue(forKey: "tests")
            test.add(testObj)
            return true
        }
    }
    
    func removeTest(test:Test) -> Bool {

        guard let testID = test.id else {return false}
        if self.tests == nil {
            self.tests = NSSet()
        }
        if let test:[UserTest] = self.tests?.toArray() {
            let savedTests = test.filter { (item) -> Bool in
                return item.testID == testID
            }
            if savedTests.count == 0  {
                return false
            }else {
                guard let firstTest = savedTests.first else {return false }
                let testList = self.mutableSetValue(forKey: "tests")
                testList.remove(firstTest)
                DataStore.shared.saveContext()
                return true
            }
        }else {
            return false
        }
    }
}
