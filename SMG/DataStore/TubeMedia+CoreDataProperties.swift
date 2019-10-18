//
//  TubeMedia+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 8/2/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension TubeMedia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TubeMedia> {
        return NSFetchRequest<TubeMedia>(entityName: "TubeMedia")
    }

    @NSManaged public var image: String?
    @NSManaged public var tube: Tube?

}

extension TubeMedia :MediaViewable {
    public var url: URL? {
        return image?.makeURL()
    }
    public var thumb: URL? {
        return nil
    }
    public var dataType: MediaContentType? {
        return .image
    }
}
