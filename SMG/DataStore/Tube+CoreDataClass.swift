//
//  Tube+CoreDataClass.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/12/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Tube)
public class Tube: NSManagedObject {
    @nonobjc public class func createTube(data:[String:Any]) -> Tube? {
        let managedObjectContext = DataStore.shared.managedObjectContext
        if let id = data["id"] as? String {
            do {
                let fetchRequest : NSFetchRequest<Tube> = Tube.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                let fetchedResults = try managedObjectContext.fetch(fetchRequest)
                if fetchedResults.count > 0 {
                    return fetchedResults.first
                }else {
                    let newObject   = NSEntityDescription.insertNewObject(forEntityName: "Tube", into: managedObjectContext) as! Tube
                    newObject.id    = data["id"] as? String
                    newObject.name  = data["name"] as? String
                    newObject.type  = data["type"] as? String
                    newObject.tubeCount  = data["no_of_tubes"] as? String
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
