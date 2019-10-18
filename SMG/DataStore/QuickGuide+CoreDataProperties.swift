//
//  QuickGuide+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/11/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension QuickGuide {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuickGuide> {
        return NSFetchRequest<QuickGuide>(entityName: "QuickGuide")
    }

    @NSManaged public var content: String?
    @NSManaged public var id: String?
    @NSManaged public var slug: String?
    @NSManaged public var title: String?

}
