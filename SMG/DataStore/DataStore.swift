//
//  DataStore.swift
//
//  Created by Amzad Khan on 6/28/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//


/*{"id":"1","name":"Culture and Sensitivity, Blood, Aerobic & Anaerobic","comment":"this is test","commonly_used":"1","whats_included":"","is_internal_or_external":"1","internal_id":"1","external":"","special_instructions":"BACTEC culture bottles are light sensitive and need to be stored in the dark at room temperature. Please make sure that you draw and inject 8 \u2013 10 mL of blood in each BACTEC blood culture bottle. Please follow \"standard order of draw\" when collecting blood samples, which could be found under \"Lab handbook\" in hamburger menu.","order_epic":[{"id":"1","name":"Can order on epic using the test name","status":"1","added_on":"2018-06-15 09:25:17","modified_on":"0000-00-00 00:00:00"}],"tat_routine":"2-5 days","tat_stat":"2-5 days","is_it_done_daily":"1","price_code":"BA0020 (Aerobic) BA9020 (Anaerobic) BA9021 (Both)","method":"Automated Bactec (Fluorescence) or Conventional culture","clinical_usages":"Blood cultures are used to detect blood stream infections\/ septicaemia. This enables identification of causative organisms and its anti-microbial susceptibility pattern to guide treatment. \r\nClinical chemistry investigations such as CRP, procalcitonin and haematological tests such as full blood count could help you understand\/ predict the likelihood of having bacteraemia among in-patients.","ref_range":"gram stain, fungus culture, tissue culture, urine culture","status":"1","is_completed":"1","added_on":"2018-06-28 09:54:56","modified_on":"0000-00-00 00:00:00","discpline":[{"id":"10","name":"Histopathology"},{"id":"12","name":"Microbiology"}],"specimen":[{"id":"4","name":"Fluids"}],"alt_names":[{"id":"16","test_id":"1","alt_name":"blood culture"}],"abbreviation":[{"id":"15","test_id":"1","abbreviation":"cs"}],"diseases":[{"id":"1","name":"sepsis"},{"id":"2","name":"bacteraemia"},{"id":"3","name":"bacteremia"},{"id":"4","name":"sirs"},{"id":"5","name":"bacterial infection"},{"id":"6","name":"blood stream infections"}],"medical_discpline":[{"id":"16","test_id":"1","medical_disp":"microbiology"}],"specimen_type":[{"id":"14","test_id":"1","name":"Whole blood"}],"related_test":[],"tubes":[{"id":"15","name":"aerobic","type":"Bactec Aerobic Culture Vials","no_of_tubes":"1"},{"id":"16","name":"anaerobic","type":"Bactec Anaerobic Culture Vials","no_of_tubes":"1"}],"days":[]}
 */
import CoreData
import Foundation

import UIKit
public extension NSSet {
    func toArray<T>() -> [T] {
        let array = self.map({ $0 as! T})
        return array
    }
}

public class DataStore:NSObject {
    
    
    
    static let shared = DataStore()
    
    // MARK: - Core Data stack
    private lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "DataStore", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("DataStore.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            // Configure automatic migration.
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        var managedObjectContext: NSManagedObjectContext?
//        if #available(iOS 10.0, *){
//
//            managedObjectContext = self.persistentContainer.viewContext
//        }
//        else {
            // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
            let coordinator = self.persistentStoreCoordinator
            managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext?.persistentStoreCoordinator = coordinator
        //}
        return managedObjectContext!
    }()
    
    // iOS-10
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DataStore")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        print("\(self.applicationDocumentsDirectory)")
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    
    @discardableResult func saveContext() -> Bool {
        guard managedObjectContext.hasChanges else {
            return false
        }
        
        do {
            try managedObjectContext.save()
            return true
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
            //abort()
            return false
        }
    }
}

extension DataStore {
    static func loadDataFromJSONFile(url:URL, handler:@escaping Constants.VoidHandler) {
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: Any] {
                DataStore.shared.deleteAll()
                DataStore.shared.insertData(jsonResult: jsonResult, handler:handler)
                // do stuff
            }
        } catch {
            handler()
            // handle error
        }
    }
    
    static func loadDataFromJSONFile(name:String) {
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let person = jsonResult["person"] as? [Any] {
                    // do stuff
                }
            } catch {
                // handle error
            }
        }
    }
    
    static func downloadJsonFileFromServer(handler:@escaping Constants.VoidHandler){
        if let request = API.empty.download(url:"https://syonservices.com/jurong/assets/uploads/databasefile.txt", with: [String:Any](), fileName: "json.txt") {
            let hud = Global.showLoadingSpinner("Loading data, Please wait.")
            let topVC = UIApplication.topViewController()
            hud.offset.y = topVC!.view.frame.size.height*(1/3);
            request.responseData { (response) in
                Global.dismissLoadingSpinner()
                if let destinationUrl = response.destinationURL {
                    UserDefaults.standard.set(destinationUrl, forKey: Constants.kAppDisplayName + "jsonData")
                    UserDefaults.standard.synchronize()
                    DataStore.loadDataFromJSONFile(url: destinationUrl, handler:handler)
                    print("destinationUrl \(destinationUrl.absoluteURL)")
                }else {
                    handler()
                }
            }
        }else {
            handler()
        }
    }
}

extension DataStore {

    func deleteAll(){
        let managedObjectContext = DataStore.shared.managedObjectContext
        let deleteAbout = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<About>(entityName: "About") as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedObjectContext.execute(deleteAbout)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
        let deleteTestCategory = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<TestCategory>(entityName: "TestCategory") as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedObjectContext.execute(deleteTestCategory)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
        let deleteFAQ = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<FAQ>(entityName: "FAQ") as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedObjectContext.execute(deleteFAQ)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
        let deleteQuickGuide = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<QuickGuide>(entityName: "QuickGuide") as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedObjectContext.execute(deleteQuickGuide)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
        let deleteContact = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<Contact>(entityName: "Contact") as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedObjectContext.execute(deleteContact)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
        let deleteFeedbackCategory = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<FeedbackCategory>(entityName: "FeedbackCategory") as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedObjectContext.execute(deleteFeedbackCategory)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
        let deleteTest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<Test>(entityName: "Test") as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedObjectContext.execute(deleteTest)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
        let deleteTag = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<Tag>(entityName: "Tag") as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedObjectContext.execute(deleteTag)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
        let deleteAltName = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<AltName>(entityName: "AltName") as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedObjectContext.execute(deleteAltName)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
        let deleteDiscipline = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<Discipline>(entityName: "Discipline") as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedObjectContext.execute(deleteDiscipline)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
        let deleteSpecimen = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<Specimen>(entityName: "Specimen") as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedObjectContext.execute(deleteSpecimen)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
        let deleteSpecimenType = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<SpecimenType>(entityName: "SpecimenType") as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedObjectContext.execute(deleteSpecimenType)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
        let deleteAbbreviation = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<Abbreviation>(entityName: "Abbreviation") as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedObjectContext.execute(deleteAbbreviation)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
        let deleteOrderEpic = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<OrderEpic>(entityName: "OrderEpic") as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedObjectContext.execute(deleteOrderEpic)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
        let deleteTube = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<Tube>(entityName: "Tube") as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedObjectContext.execute(deleteTube)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func insertData(jsonResult:[String:Any], handler:@escaping Constants.VoidHandler) {
        
        let hud = Global.showLoadingSpinner("Synconizing data, Please wait.")
        let topVC = UIApplication.topViewController()
        hud.offset.y = topVC!.view.frame.size.height*(1/3);
        let managedObjectContext = DataStore.shared.managedObjectContext

        managedObjectContext.perform { // runs asynchronously
            autoreleasepool { // auto release objects after the batch save
                // insert new entity object
                
                if let displine = jsonResult["discipline"] as? [String: Any] {
                    if let data = displine["data"] as? [[String:Any]] {
                        for item in data {
                            let newObject   = NSEntityDescription.insertNewObject(forEntityName: "TestCategory", into: managedObjectContext) as! TestCategory
                            newObject.id    = item["id"] as? String
                            newObject.type  = Int16(Int(any: item["cat_type_id"]))
                            newObject.name  = item["name"] as? String
                            newObject.shortName = item["short_name"] as? String
                            newObject.comments  = item["comment"] as? String
                            newObject.parentId  = item["parent_id"] as? String
                        }
                    }
                }
                if let specimen = jsonResult["specimen"] as? [String: Any] {
                    if let data = specimen["data"] as? [[String:Any]] {
                        for item in data {
                            let newObject   = NSEntityDescription.insertNewObject(forEntityName: "TestCategory", into: managedObjectContext) as! TestCategory
                            newObject.id    = item["id"] as? String
                            newObject.type  = Int16(Int(any: item["cat_type_id"]))
                            newObject.name  = item["name"] as? String
                            newObject.shortName = item["short_name"] as? String
                            newObject.comments  = item["comment"] as? String
                            newObject.parentId  = item["parent_id"] as? String
                        }
                    }
                }
                if let data = jsonResult["tests"] as? [String: Any] {
                    if let testData = data["data"] as? [[String:Any]] {
                        for item in testData {
                            DataStore.createTest(data: item)
                        }
                    }
                }
                if let data = jsonResult["about_us"] as? [String: Any] {

                    var aboutData = data
                    if let memo = jsonResult["mamos"] as? String {
                        aboutData["mamos"] = memo
                    }
                    let newObject = NSEntityDescription.insertNewObject(forEntityName: "About", into: managedObjectContext) as! About
                    newObject.id = aboutData["id"] as? String
                    newObject.title = aboutData["title"] as? String
                    newObject.content = aboutData["content"] as? String
                    newObject.slug = aboutData["slug"] as? String
                    newObject.memoURL = aboutData["mamos"] as? String
                    
                }
                
                if let data = jsonResult["mamos"] as? [[String: Any]] {
                    for item in data {
                         Memo.createMemo(infoData: item)
                    }
                }
               
                if let data = jsonResult["faq"] as? [[String: Any]] {
                    for item in data {
                        let newObject       = NSEntityDescription.insertNewObject(forEntityName: "FAQ", into: managedObjectContext) as! FAQ
                        newObject.id        = item["id"] as? String
                        newObject.answer    = item["answer"] as? String
                        newObject.question  = item["question"] as? String
                    }
                }
                if let data = jsonResult["quick_guide"] as? [String: Any] {
                    let newObject       = NSEntityDescription.insertNewObject(forEntityName: "QuickGuide", into: managedObjectContext) as! QuickGuide
                    newObject.id        = data["id"] as? String
                    newObject.title     = data["title"] as? String
                    newObject.content   = data["content"] as? String
                    newObject.slug      = data["slug"] as? String
                }
                if let data = jsonResult["feedback_categories"] as? [[String: Any]] {
                    for item in data {
                        let newObject       = NSEntityDescription.insertNewObject(forEntityName: "FeedbackCategory", into: managedObjectContext) as! FeedbackCategory
                        newObject.id        = item["id"] as? String
                        newObject.name      = item["name"] as? String
                        newObject.parentID  = item["parent_id"] as? String
                        if let subcategory = item["sub_category"] as? [[String:Any]] {
                            for item in subcategory {
                                let object       = NSEntityDescription.insertNewObject(forEntityName: "FeedbackCategory", into: managedObjectContext) as! FeedbackCategory
                                object.id        = item["id"] as? String
                                object.name      = item["name"] as? String
                                object.parentID  = item["parent_id"] as? String
                            }
                        }
                    }
                }
                if let data = jsonResult["contact"] as? [[String: Any]] {
                    for item in data {
                        let newObject       = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: managedObjectContext) as! Contact
                        newObject.id        = item["id"] as? String
                        newObject.title     = item["title"] as? String
                        newObject.value     = item["value"] as? String
                        newObject.comments  = item["comment"] as? String
                        newObject.color     = item["color"] as? String
                    }
                }
            }
            // only save once per batch insert
            do {
                try managedObjectContext.save()
                Global.dismissLoadingSpinner()
            } catch {
                Global.dismissLoadingSpinner()
                print(error)
            }
            managedObjectContext.reset()
            handler()
        }
    }
    
    @nonobjc public class func createTest(data:[String:Any]) {
        
        let managedObjectContext = DataStore.shared.managedObjectContext
        let newObject   = NSEntityDescription.insertNewObject(forEntityName: "Test", into: managedObjectContext) as! Test
        
        newObject.isCompleted       = Bool(any: data["is_completed"])
        newObject.isDoneDaily       = Bool(any: data["is_it_done_daily"])
        newObject.isInternal        = Bool(any: data["is_internal_or_external"])
        newObject.isCommonlyUsed    = Bool(any: data["commonly_used"])
        
        //12
        newObject.id                = data["id"] as? String
        newObject.name              = data["name"] as? String
        newObject.instructions      = data["special_instructions"] as? String
        newObject.comments          = data["comment"] as? String
        newObject.tatRoutine        = data["tat_routine"] as? String
        newObject.tatStat           = data["tat_stat"] as? String
        newObject.priceCode         = data["price_code"] as? String
        newObject.method            = data["method"] as? String
        newObject.clinicalUsages    = data["clinical_usages"] as? String
        newObject.internalID        = data["internal_id"] as? String
        newObject.externalID        = data["external_id"] as? String
        newObject.refRange          = data["ref_range"] as? String
        newObject.location          = data["location"] as? String
        newObject.whatsInclude      = data["whatsInclude"] as? String
        
        if let dayPerformed = data["is_it_done_daily"] as? String {
            if dayPerformed == "1" {
                newObject.dayPerformed  = "Daily"
            } else {
                newObject.dayPerformed  = dayPerformed
            }
        }
        
        var categories:String?
        if let disciplines = data["discipline"] as? [[String:Any]] {
            for item in disciplines {
                if let catID = item["id"] as? String {
                    if let categoryString = categories {
                        categories = categoryString + "," + catID
                    }else {
                        categories = catID
                    }
                }
            }
        }
        if let specimen = data["specimen"] as? [[String:Any]] {
            for item in specimen {
                if let catID = item["id"] as? String {
                    if let categoryString = categories {
                        categories = categoryString + "," + catID
                    }else {
                        categories = catID
                    }
                }
            }
        }
        newObject.categoris = categories
        
        if let data = data["discipline"] as? [[String:Any]] {
            newObject.disciplines = NSSet()
            for item in data {
                if let mgObject = Discipline.createDiscipline(data: item) {
                    if mgObject.tests == nil {
                        mgObject.tests = NSSet()
                    }
                    let test = mgObject.mutableSetValue(forKey: "tests")
                    test.add(newObject)
                    let disciplines = newObject.mutableSetValue(forKey: "disciplines")
                    disciplines.add(mgObject)
                }
            }
        }
        if let data = data["specimen"] as? [[String:Any]] {
            newObject.specimens = NSSet()
            for item in data {
                if let mgObject = Specimen.createSpecimen(data: item) {
                    if mgObject.tests == nil {
                        mgObject.tests = NSSet()
                    }
                    let test = mgObject.mutableSetValue(forKey: "tests")
                    test.add(newObject)
                    let specimens = newObject.mutableSetValue(forKey: "specimens")
                    specimens.add(mgObject)
                }
            }
        }
        if let data = data["alt_names"] as? [[String:Any]] {
            newObject.alternateNames = NSSet()
            for item in data {
                if let mgObject = AltName.createAltName(data: item) {
                    if mgObject.tests == nil {
                        mgObject.tests = NSSet()
                    }
                    let test = mgObject.mutableSetValue(forKey: "tests")
                    test.add(newObject)
                    let alternateNames = newObject.mutableSetValue(forKey: "alternateNames")
                    alternateNames.add(mgObject)
                }
            }
        }
        if let data = data["abbreviation"] as? [[String:Any]] {
            newObject.abbreviations = NSSet()
            for item in data {
                if let mgObject = Abbreviation.createAbbreviation(data: item) {
                    if mgObject.tests == nil {
                        mgObject.tests = NSSet()
                    }
                    let test = mgObject.mutableSetValue(forKey: "tests")
                    test.add(newObject)
                    let abbreviations = newObject.mutableSetValue(forKey: "abbreviations")
                    abbreviations.add(mgObject)
                }
            }
        }
        if let data = data["tags"] as? [[String:Any]] {
            newObject.tags = NSSet()
            for item in data {
                if let mgObject = Tag.createTag(data:item) {
                    if mgObject.tests == nil {
                        mgObject.tests = NSSet()
                    }
                    let test = mgObject.mutableSetValue(forKey: "tests")
                    test.add(newObject)
                    let tags = newObject.mutableSetValue(forKey: "tags")
                    tags.add(mgObject)
                }
            }
        }
        if let data = data["specimen_type"] as? [[String:Any]] {
            newObject.specimenTypes = NSSet()
            for item in data {
                if let mgObject = SpecimenType.createSpecimenType(data:item) {
                    if mgObject.tests == nil {
                        mgObject.tests = NSSet()
                    }
                    let test = mgObject.mutableSetValue(forKey: "tests")
                    test.add(newObject)
                    let specimenTypes = newObject.mutableSetValue(forKey: "specimenTypes")
                    specimenTypes.add(mgObject)
                }
            }
        }
        if let data = data["tubes"] as? [[String:Any]] {
            newObject.tubes = NSSet()
            for item in data {
                if let mgObject = Tube.createTube(data:item) {
                    if mgObject.tests == nil {
                        mgObject.tests = NSSet()
                    }
                    let test = mgObject.mutableSetValue(forKey: "tests")
                    test.add(newObject)
                    let tubes = newObject.mutableSetValue(forKey: "tubes")
                    tubes.add(mgObject)
                    
                    if let mediaData =  item["media"] as? [String] {
                        if mgObject.media == nil {
                            mgObject.media = NSSet()
                        }
                        let mediaObj = mgObject.mutableSetValue(forKey: "media")
                        for media in mediaData {
                            if let mediaCoreData = TubeMedia.createMedia(image: media) {
                                mediaCoreData.tube = mgObject
                                mediaObj.add(mediaCoreData)
                            }
                        }
                    }
                }
            }
        }
        if let data = data["order_epic"] as? [String:Any] {
            if let mgObject = OrderEpic.createOrderEpic(data:data) {
                if mgObject.tests == nil {
                        mgObject.tests = NSSet()
                }
                let test = mgObject.mutableSetValue(forKey: "tests")
                test.add(newObject)
                newObject.orderEpics = mgObject
            }
        }
        if let data = data["related_test"] as? [[String:Any]] {
            newObject.relatedTests = NSSet()
            let relatedTests = newObject.mutableSetValue(forKey: "relatedTests")
            for item in data {
                if let mgObject = RelatedTest.createRelatedTest(data:item) {
                    if mgObject.tests == nil {
                        mgObject.tests = NSSet()
                    }
                    let test = mgObject.mutableSetValue(forKey: "tests")
                    test.add(newObject)
                    relatedTests.add(mgObject)
                }
            }
        }
    }
}


