//
//  FileManager.swift
//
//  Created by Amzad Khan on 26/01/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import Foundation

extension FileManager {
    var documentDirectory: URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if paths.count > 0 {
            let path = paths[0]
            if let directory = URL(string: path) {
                return directory
            }
        }
        return nil
    }
    func removeAllContents() -> Bool {
        guard let directoryPath = self.documentDirectory?.path else { return false }
        do {
            let contents = try self.contentsOfDirectory(atPath: directoryPath)
            for path in contents {
                let fullPath = (directoryPath as NSString).appendingPathComponent(path)
                try self.removeItem(atPath: fullPath)
            }
            return true
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
    }
    func removeFile(of title: String) -> Bool {
        guard let directory = self.documentDirectory else { return false }
        do {
            let path = directory.appendingPathComponent(title)
            try self.removeItem(atPath: path.path)
            return true
        } catch let error as NSError {
            print(error.debugDescription)
            if error.code == 4 { //No such file or directory
                return true
            }
            return false
        }
    }
    func isDownloaded(url: URL) -> Bool {
        guard let directoryPath = self.documentDirectory?.path else { return false }
        return self.fileExists(atPath: directoryPath)
    }
}

extension URL {
    public static func temporaryFile(extension ext: String) -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(ext)
    }
}


public final class TemporaryFileURL: ManagedURL {
    public let contentURL: URL
    public init(extension ext: String) {
        contentURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(ext)
    }
    deinit {
        DispatchQueue.global(qos: .utility).async { [contentURL = self.contentURL] in
            try? FileManager.default.removeItem(at: contentURL)
        }
    }
}

public protocol ManagedURL {
    var contentURL: URL { get }
    func keepAlive()
}

public extension ManagedURL {
    public func keepAlive() { }
}

extension URL: ManagedURL {
    public var contentURL: URL { return self }
}


