//
//  QuickGuide+CoreDataClass.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/11/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(QuickGuide)
public class QuickGuide: NSManagedObject {
   @nonobjc public class func getQuickGuide () -> QuickGuide? {
        do {
            let fetchRequest : NSFetchRequest<QuickGuide> = QuickGuide.fetchRequest()
            let fetchedResults = try DataStore.shared.managedObjectContext.fetch(fetchRequest)
            if let aContact = fetchedResults.first {
                return aContact
            }else {
                return nil
            }
        }
        catch {
            print ("fetch task failed", error)
            return nil
        }
    }
}
