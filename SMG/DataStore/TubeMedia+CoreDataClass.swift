//
//  TubeMedia+CoreDataClass.swift
//  NTFGH
//
//  Created by Amzad Khan on 8/2/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TubeMedia)
public class TubeMedia: NSManagedObject {
    @nonobjc public class func createMedia(image:String) -> TubeMedia? {
        let managedObjectContext = DataStore.shared.managedObjectContext
        let newObject   = NSEntityDescription.insertNewObject(forEntityName: "TubeMedia", into: managedObjectContext) as! TubeMedia
        newObject.image    = image
        return newObject
    }
}
