//
//  SpecimenType+CoreDataClass.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/12/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SpecimenType)
public class SpecimenType: NSManagedObject {
    @nonobjc public class func createSpecimenType(data:[String:Any]) -> SpecimenType? {
        let managedObjectContext = DataStore.shared.managedObjectContext
        if let id = data["id"] as? String {
            do {
                let fetchRequest : NSFetchRequest<SpecimenType> = SpecimenType.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                let fetchedResults = try managedObjectContext.fetch(fetchRequest)
                if fetchedResults.count > 0 {
                    return fetchedResults.first
                }else {
                    let newObject   = NSEntityDescription.insertNewObject(forEntityName: "SpecimenType", into: managedObjectContext) as! SpecimenType
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
