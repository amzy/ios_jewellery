//
//  Contact+CoreDataClass.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/11/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {
    @nonobjc public class func getAppContacts () -> [Contact] {
        do {
            let fetchRequest : NSFetchRequest<Contact> = Contact.fetchRequest()
            //let sort = NSSortDescriptor(key: "id.integerValue", ascending: true)
            //fetchRequest.sortDescriptors = [sort]
    
            let fetchedResults = try DataStore.shared.managedObjectContext.fetch(fetchRequest)
            return fetchedResults
        }
        catch {
            print ("fetch task failed", error)
            return [Contact]()
        }
    }
}
