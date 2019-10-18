//
//  BroadcastMesssage+CoreDataClass.swift
//  NTFGH
//
//  Created by Amzad Khan on 8/10/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(BroadcastMesssage)
public class BroadcastMesssage: NSManagedObject {
    @nonobjc public class func loadNotifications() -> NSFetchedResultsController<BroadcastMesssage> {
        let fetchRequest : NSFetchRequest<BroadcastMesssage> = BroadcastMesssage.fetchRequest()
        let nameSort = NSSortDescriptor(key: "time", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataStore.shared.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultController
    }
    
    @nonobjc public class func unreadNotifications() -> Int {
        do {
            let fetchRequest : NSFetchRequest<BroadcastMesssage> = BroadcastMesssage.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isRead == false")
            let fetchedResults = try DataStore.shared.managedObjectContext.fetch(fetchRequest)
            return fetchedResults.count
        }
        catch {
            print ("fetch notifications failed", error)
            return 0
        }
    }
    
    public class func createNotification(infoData:[String:Any]) {
        let managedObjectContext = DataStore.shared.managedObjectContext
        let newObject       = NSEntityDescription.insertNewObject(forEntityName: "BroadcastMesssage", into: managedObjectContext) as! BroadcastMesssage
        newObject.id        = String(any:infoData["id"])
        newObject.title     = infoData["title"] as? String
        newObject.time      = Double(Int(any: infoData["time"])) * 1000
        newObject.message   = infoData["orginal"] as? String
        newObject.isRead    = false
        newObject.isLoaded  = false
        DataStore.shared.saveContext()
    }
}
