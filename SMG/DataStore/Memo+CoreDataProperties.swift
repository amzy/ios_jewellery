//
//  Memo+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 14/08/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var title: String?
    @NSManaged public var details: String?
    @NSManaged public var time: Double
    @NSManaged public var pdfPath: String?
    @NSManaged public var isPDF: Bool

}
