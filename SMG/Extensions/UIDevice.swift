//
//  UIDevice.swift
//  Fodder
//
//  Created by Himanshu Parashar on 02/03/16.
//  Copyright © 2016 syoninfomedia. All rights reserved.
//

import UIKit

extension UIDevice {
    static var isSimulator: Bool {
        if #available(iOS 9, *) {
            return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
        } else {
            return UIDevice.current.model == "iPhone Simulator"
        }
    }
}
