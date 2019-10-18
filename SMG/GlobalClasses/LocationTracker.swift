//
//  GlobalLocationTracker.swift
//  Fodder
//
//  Created by Himanshu Parashar on 20/07/15.
//  Copyright (c) 2015 syoninfomedia. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationTrackerDelegate: class {
    func didUpdate(withLocation location: CLLocation)
}

public class LocationTracker: NSObject {
    static let shared = LocationTracker()
    weak var delegate: LocationTrackerDelegate?
    var currentLocation: CLLocation?

    private let locationManager: CLLocationManager = {
        // Initialize Location Manager
        let locationManager = CLLocationManager()
        
        // Configure Location Manager
        /* Pinpoint our location with the following accuracy:
         *
         *     kCLLocationAccuracyBestForNavigation  highest + sensor data
         *     kCLLocationAccuracyBest               highest
         *     kCLLocationAccuracyNearestTenMeters   10 meters
         *     kCLLocationAccuracyHundredMeters      100 meters
         *     kCLLocationAccuracyKilometer          1000 meters
         *     kCLLocationAccuracyThreeKilometers    3000 meters
         */
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        /* Notify changes when device has moved x meters.
         * Default value is kCLDistanceFilterNone: all movements are reported.
         */
        locationManager.distanceFilter = 10.0
        
        /* Notify heading changes when heading is > 5.
         * Default value is kCLHeadingFilterNone: all movements are reported.
         */
        locationManager.headingFilter = 5
        return locationManager
    }()
    
    override init() {
        super.init()
        /*
         *  Don't forget to add NSLocationWhenInUseUsageDescription in MyApp-Info.plist and give it a string
        */
    }
    
    func requestUpdating() {
        // Configure Location Manager
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // Request Current Location
            locationManager.startUpdatingLocation()
        } else {
            // Request Authorization
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func stopUpdating() {
        // Reset Delegate
        LocationTracker.shared.locationManager.delegate = nil
        // Stop Location Manager
        LocationTracker.shared.locationManager.stopUpdatingLocation()
    }
}

/*
 //MARK:- CLLocationManagerDelegate
 */

extension LocationTracker: CLLocationManagerDelegate {
    
    // MARK: - Location Updates
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        //printDebug("didUpdateLocations \(location)")
        
        // Stop Location Manager and Reset Delegate
        //LocationTracker.shared.stopUpdating()
        guard let current = currentLocation else {
            // Update Current Location
            currentLocation = location
            delegate?.didUpdate(withLocation: location)
            return
        }
        guard location.coordinate != current.coordinate else {
            return
        }
        
        // Update Current Location
        currentLocation = location
        delegate?.didUpdate(withLocation: location)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        printDebug("didFailWithError \(error.localizedDescription)")
    }
    
    // MARK: - Authorization
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: break
            // User has not yet made a choice with regards to this application
        case .restricted: break
            // This application is not authorized to use location services.  Due
            // to active restrictions on location services, the user cannot change
            // this status, and may not have personally denied authorization
            //Global.locationDisableAlert()
        case .denied: break
            // User has explicitly denied authorization for this application, or
            // location services are disabled in Settings
            //Global.locationDisableAlert()
            //For IOS 8 or Later
        case .authorizedWhenInUse, .authorizedAlways:
            // User has authorized this application to use location services
            // Request Location
            LocationTracker.shared.requestUpdating()
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    static public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
    }
}
