//
//  CoreMedia+CoreDataClass.swift
//
//  Created by Amzad Khan on 26/01/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//
//
import UIKit
import Foundation
import CoreData

@objc(CoreMedia)
public class CoreMedia: NSManagedObject {

}
extension CoreMedia {
    class func getMediaForURL(url: URL) -> CoreMedia! {
        var result: CoreMedia! = nil
        let context: NSManagedObjectContext = MediaStore.sharedInstance.managedObjectContext
            let request: NSFetchRequest<CoreMedia> = CoreMedia.fetchRequest()
            request.predicate = NSPredicate(format: "mediaURI == %@", url.absoluteString)
        let results:[CoreMedia]! = try! context.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [CoreMedia]
            if results  != nil, results.count > 0 {
                result = results.last
                let searchURL: String = url.absoluteString
                let localURL: String = result!.localURL!
                let serverURL: String = result!.url!
                NSLog("Serch: %@\nServer: %@\nLocal: %@ ", searchURL, serverURL, localURL)
            }
            return result!
        }
    class func saveImage(image: UIImage, withURL serverImageURL: URL) -> Bool {
        let context: NSManagedObjectContext = MediaStore.sharedInstance.managedObjectContext
        let documentDirectory = URL(string:self.documentsMediaPath())!
        let newImageName: String = self.newImageName()
        let fileURL = documentDirectory.appendingPathComponent(newImageName)
        do {
            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                try imageData.write(to: fileURL)
                
                let newImageMedia: CoreMedia! = NSEntityDescription.insertNewObject(forEntityName: "CoreMedia", into: context) as! CoreMedia
                newImageMedia.type = "image"
                newImageMedia.url = serverImageURL.absoluteString
                newImageMedia.localURL = newImageName
                
                try context.save()
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
    class func saveVedio(videoData: Data, withURL serverVideoURL: URL) -> String! {
        let context: NSManagedObjectContext = MediaStore.sharedInstance.managedObjectContext
        let documentDirectory = URL(string:self.documentsMediaPath())!
        let newVideoName: String = self.newVideoName()
        let fileURL = documentDirectory.appendingPathComponent(newVideoName)
        do {
            try videoData.write(to: fileURL)
            let newImageMedia: CoreMedia! = NSEntityDescription.insertNewObject(forEntityName: "CoreMedia", into: context) as! CoreMedia
            newImageMedia.type = "video"
            newImageMedia.url = serverVideoURL.absoluteString
            newImageMedia.localURL = newVideoName
            try context.save()
            return fileURL.absoluteString
            
        } catch {
            print(error)
        }
        return nil
    }
    class func newImageName() -> String {
        let newFileName: String = "MZ_\(self.timeStamp()).jpg"
        return newFileName
    }
    
    class func newImageFilePath() -> String {
        let newFileName: String = "MZ_\(self.timeStamp()).jpg"
        let newPath: String = self.documentsPathForFileName(name: newFileName)
        return newPath
    }
    
    class func newVideoName() -> String {
        let newFileName: String = "MZ_\(self.timeStamp()).mp4"
        return newFileName
    }
    
    class func newVideoFilePath() -> String {
        let newFileName: String = "MZ_\(self.timeStamp()).mp4"
        let newPath: String = self.documentsPathForFileName(name: newFileName)
        return newPath
    }
    
    class func documentsPathForFileName(name: String) -> String! {
        var path: String
        var paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [AnyObject]
        path = paths[0].appendingPathComponent("MZMedia")
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
                return nil
            }
        }
        return path + "\\" + name
    }
    func loacalPath() -> String {
        let documentPath: String = CoreMedia.documentsMediaPath()
        let lacalPath: String = documentPath + "\\" + self.localURL!
        return lacalPath
    }
    
    func loacalURL() -> URL {
        let documentPath: String = CoreMedia.documentsMediaPath()
        let lacalpath: String = documentPath + "\\" + self.localURL!
        let localurl  = URL(fileURLWithPath: lacalpath)
        return localurl
    }
    class func documentsMediaPath() -> String! {
        var path: String
        var paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [AnyObject]
        path = paths[0].appendingPathComponent("MZMedia")
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
                return nil
            }
        }
        return path
    }
    
    class func timeStamp() -> String {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }
}
