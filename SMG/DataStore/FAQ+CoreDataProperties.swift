//
//  FAQ+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/11/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension FAQ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FAQ> {
        return NSFetchRequest<FAQ>(entityName: "FAQ")
    }

    @NSManaged public var answer: String?
    @NSManaged public var id: String?
    @NSManaged public var question: String?
    
}
