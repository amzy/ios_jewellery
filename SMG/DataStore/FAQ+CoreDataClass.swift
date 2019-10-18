//
//  FAQ+CoreDataClass.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/11/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(FAQ)
public class FAQ: NSManagedObject {
    @nonobjc public class func getFAQ () -> [FAQ] {
        do {
            let fetchRequest : NSFetchRequest<FAQ> = FAQ.fetchRequest()
            //fetchRequest.predicate = NSPredicate(format: "uniqueId == %@", contactIdentifier)
            let fetchedResults = try DataStore.shared.managedObjectContext.fetch(fetchRequest)
            return fetchedResults
        }
        catch {
            print ("fetch task failed", error)
            return [FAQ]()
        }
    }
}
