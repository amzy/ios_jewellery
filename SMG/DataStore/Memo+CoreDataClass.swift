//
//  Memo+CoreDataClass.swift
//  NTFGH
//
//  Created by Amzad Khan on 14/08/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Memo)
public class Memo: NSManagedObject {
    
    @nonobjc public class func loadMemo() -> NSFetchedResultsController<Memo> {
        let fetchRequest : NSFetchRequest<Memo> = Memo.fetchRequest()
        let nameSort = NSSortDescriptor(key: "time", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataStore.shared.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultController
    }

    public class func createMemo(infoData:[String:Any]) {
        let managedObjectContext = DataStore.shared.managedObjectContext
        let newObject       = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: managedObjectContext) as! Memo
        newObject.title     = infoData["title"] as? String
        newObject.time      = Double(Int(any: infoData["time"]))
        newObject.details   = infoData["memo_number"] as? String
        if let url = infoData["pdf_link"] as? String {
            newObject.pdfPath = url
            newObject.isPDF = true
        }else {
            newObject.isPDF    = false
        }
        DataStore.shared.saveContext()
    }
}
