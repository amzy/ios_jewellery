//
//  RelatedTest+CoreDataClass.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/20/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(RelatedTest)
public class RelatedTest: NSManagedObject {
    @nonobjc public class func createRelatedTest(data:[String:Any]) -> RelatedTest? {
        let managedObjectContext = DataStore.shared.managedObjectContext
        
        if let id = data["id"] as? String {
            do {
                let fetchRequest : NSFetchRequest<RelatedTest> = RelatedTest.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                let fetchedResults = try managedObjectContext.fetch(fetchRequest)
                if fetchedResults.count > 0 {
                    return fetchedResults.first
                }else {
                    let newObject   = NSEntityDescription.insertNewObject(forEntityName: "RelatedTest", into: managedObjectContext) as! RelatedTest
                    newObject.id    = data["id"] as? String
                    newObject.name  = data["name"] as? String
                    return newObject
                }
            }
            catch {
                print ("fetch task failed", error)
                return nil
            }
        }else {
            return nil
        }
    }
}
