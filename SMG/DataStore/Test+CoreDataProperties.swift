//
//  Test+CoreDataProperties.swift
//  NTFGH
//
//  Created by Amzad Khan on 7/12/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
//

import Foundation
import CoreData


extension Test {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Test> {
        return NSFetchRequest<Test>(entityName: "Test")
    }
    
    @NSManaged public var clinicalUsages: String?
    @NSManaged public var comments: String?
    @NSManaged public var isCommonlyUsed: Bool
    @NSManaged public var externalID: String?
    @NSManaged public var id: String?
    @NSManaged public var instructions: String?
    @NSManaged public var internalID: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var isDoneDaily: Bool
    @NSManaged public var isInternal: Bool
    @NSManaged public var method: String?
    @NSManaged public var name: String?
    @NSManaged public var priceCode: String?
    @NSManaged public var refRange: String?
    @NSManaged public var tatRoutine: String?
    @NSManaged public var tatStat: String?
    @NSManaged public var categoris: String?
    @NSManaged public var specimens: NSSet?
    @NSManaged public var specimenTypes: NSSet?
    @NSManaged public var tags: NSSet?
    @NSManaged public var tubes: NSSet?
    @NSManaged public var alternateNames: NSSet?
    @NSManaged public var orderEpics: OrderEpic?
    @NSManaged public var abbreviations: NSSet?
    @NSManaged public var disciplines: NSSet?
    @NSManaged public var relatedTests: NSSet?
    @NSManaged public var location:String?
    @NSManaged public var dayPerformed:String?
    @NSManaged public var whatsInclude:String?
    
    public var allCategories:[String] {
        if let categories = self.categoris {
            let components = categories.components(separatedBy: ",")
            return components
        }else{
            return [String]()
        }
    }
    @objc public var initialName: String {
        self.willAccessValue(forKey: "initialName")
        let initial = (self.name! as NSString).substring(to: 1)
        self.didAccessValue(forKey: "initialName")
        return initial
    }
}


// MARK: Generated accessors for specimens
extension Test {
    
    @objc(addSpecimensObject:)
    @NSManaged public func addToSpecimens(_ value: Specimen)
    
    @objc(removeSpecimensObject:)
    @NSManaged public func removeFromSpecimens(_ value: Specimen)
    
    @objc(addSpecimens:)
    @NSManaged public func addToSpecimens(_ values: NSSet)
    
    @objc(removeSpecimens:)
    @NSManaged public func removeFromSpecimens(_ values: NSSet)
    
}

// MARK: Generated accessors for specimenTypes
extension Test {
    
    @objc(addSpecimenTypesObject:)
    @NSManaged public func addToSpecimenTypes(_ value: SpecimenType)
    
    @objc(removeSpecimenTypesObject:)
    @NSManaged public func removeFromSpecimenTypes(_ value: SpecimenType)
    
    @objc(addSpecimenTypes:)
    @NSManaged public func addToSpecimenTypes(_ values: NSSet)
    
    @objc(removeSpecimenTypes:)
    @NSManaged public func removeFromSpecimenTypes(_ values: NSSet)
    
}

// MARK: Generated accessors for tags
extension Test {
    
    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)
    
    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)
    
    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)
    
    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)
    
}

// MARK: Generated accessors for tubes
extension Test {
    
    @objc(addTubesObject:)
    @NSManaged public func addToTubes(_ value: Tube)
    
    @objc(removeTubesObject:)
    @NSManaged public func removeFromTubes(_ value: Tube)
    
    @objc(addTubes:)
    @NSManaged public func addToTubes(_ values: NSSet)
    
    @objc(removeTubes:)
    @NSManaged public func removeFromTubes(_ values: NSSet)
    
}

// MARK: Generated accessors for alternateNames
extension Test {
    
    @objc(addAlternateNamesObject:)
    @NSManaged public func addToAlternateNames(_ value: AltName)
    
    @objc(removeAlternateNamesObject:)
    @NSManaged public func removeFromAlternateNames(_ value: AltName)
    
    @objc(addAlternateNames:)
    @NSManaged public func addToAlternateNames(_ values: NSSet)
    
    @objc(removeAlternateNames:)
    @NSManaged public func removeFromAlternateNames(_ values: NSSet)
    
}

// MARK: Generated accessors for abbreviations
extension Test {
    
    @objc(addAbbreviationsObject:)
    @NSManaged public func addToAbbreviations(_ value: Abbreviation)
    
    @objc(removeAbbreviationsObject:)
    @NSManaged public func removeFromAbbreviations(_ value: Abbreviation)
    
    @objc(addAbbreviations:)
    @NSManaged public func addToAbbreviations(_ values: NSSet)
    
    @objc(removeAbbreviations:)
    @NSManaged public func removeFromAbbreviations(_ values: NSSet)
    
}

// MARK: Generated accessors for disciplines
extension Test {
    
    @objc(addDisciplinesObject:)
    @NSManaged public func addToDisciplines(_ value: Discipline)
    
    @objc(removeDisciplinesObject:)
    @NSManaged public func removeFromDisciplines(_ value: Discipline)
    
    @objc(addDisciplines:)
    @NSManaged public func addToDisciplines(_ values: NSSet)
    
    @objc(removeDisciplines:)
    @NSManaged public func removeFromDisciplines(_ values: NSSet)
    
}

