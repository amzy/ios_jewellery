//
//  FeedbackCategory+CoreDataClass.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/11/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(FeedbackCategory)
public class FeedbackCategory: NSManagedObject {
    @nonobjc public class func getFeedbackCategories(parentID:String? = "0") -> [FeedbackCategory] {
        do {
            let fetchRequest : NSFetchRequest<FeedbackCategory> = FeedbackCategory.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "parentID == %@", parentID!)
            let fetchedResults = try DataStore.shared.managedObjectContext.fetch(fetchRequest)
            return fetchedResults
        }
        catch {
            print ("fetch task failed", error)
            return [FeedbackCategory]()
        }
    }
}
