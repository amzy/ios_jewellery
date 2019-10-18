//
//  Abbreviation+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/12/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension Abbreviation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Abbreviation> {
        return NSFetchRequest<Abbreviation>(entityName: "Abbreviation")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var testID: String?
    @NSManaged public var tests: NSSet?

}
