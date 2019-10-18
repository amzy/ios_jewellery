//
//  Test+CoreDataClass.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/12/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Test)
public class Test: NSManagedObject {
    @nonobjc public class func allTest() -> [Test]? {
        do {
            let fetchRequest : NSFetchRequest<Test> = Test.fetchRequest()
            //fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            let fetchedResults = try DataStore.shared.managedObjectContext.fetch(fetchRequest)
            return fetchedResults
        }
        catch {
            print ("fetch task failed", error)
            return [Test]()
        }
    }
    
    @nonobjc public class func categoryFetchedResultController(userCategory:UserCategory) -> NSFetchedResultsController<Test> {
        
        let fetchRequest : NSFetchRequest<Test> = Test.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        if let tests = userCategory.tests {
            let userTestList:[UserTest] = tests.toArray()
            let testList  = userTestList.map { (userCat) -> String in
                return userCat.testID ?? ""
            }
            //fetchRequest.predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicates)
            fetchRequest.predicate = NSPredicate(format: "id IN %@", testList)
        }
        
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataStore.shared.managedObjectContext,
            sectionNameKeyPath: "initialName",
            cacheName: nil)
        
        return fetchedResultController
        
    }
    
    @nonobjc public class func categoryFetchedResultController(catID:String) -> NSFetchedResultsController<Test> {
        
        let fetchRequest : NSFetchRequest<Test> = Test.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        fetchRequest.predicate = NSPredicate(format: "(ANY specimens.id == %@) OR (ANY disciplines.id == %@)", catID, catID)
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataStore.shared.managedObjectContext,
            sectionNameKeyPath: "initialName",
            cacheName: nil)
        
        return fetchedResultController
        
    }
    @nonobjc public class func testForCategory(catID:String) -> [Test]? {
        do {
            let fetchRequest : NSFetchRequest<Test> = Test.fetchRequest()
            //fetchRequest.predicate = NSPredicate(format: "allCategories CONTAINS[cd] %@", catID)
            fetchRequest.predicate = NSPredicate(format: "(ANY specimens.id == %@) OR (ANY disciplines.id == %@)", catID, catID)
            
            //fetchRequest.predicate = NSPredicate(format: "allCategories contains[c] %@", catID)
            let fetchedResults = try DataStore.shared.managedObjectContext.fetch(fetchRequest)
            return fetchedResults
        }
        catch {
            print ("fetch task failed", error)
            return [Test]()
        }
    }
    @nonobjc public class func testForID(testID:String) -> Test? {
        do {
            let fetchRequest : NSFetchRequest<Test> = Test.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", testID)
            let fetchedResults = try DataStore.shared.managedObjectContext.fetch(fetchRequest)
            return fetchedResults.first
        }
        catch {
            print ("fetch task failed", error)
            return nil
        }
    }
    
    @nonobjc public class func searchFetchedResultController() -> NSFetchedResultsController<Test> {
        
        let fetchRequest : NSFetchRequest<Test> = Test.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataStore.shared.managedObjectContext,
            sectionNameKeyPath: "initialName",
            cacheName: nil)
        return fetchedResultController
        
    }
    
    @nonobjc public class func commonTestFetchedResultController() -> NSFetchedResultsController<Test> {
        
        let fetchRequest : NSFetchRequest<Test> = Test.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        //fetchRequest.predicate = NSPredicate(format: "allCategories CONTAINS[c] %@", catID)
        fetchRequest.predicate = NSPredicate(format: "isCommonlyUsed == YES")
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataStore.shared.managedObjectContext,
            sectionNameKeyPath: "initialName",
            cacheName: nil)
        
        return fetchedResultController
        
    }
    
    
}

