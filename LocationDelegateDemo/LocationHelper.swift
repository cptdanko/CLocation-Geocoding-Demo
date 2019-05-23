//
//  LocationHelper.swift
//  LocationDelegateDemo
//
//  Created by Bhuman Soni on 23/5/19.
//  Copyright © 2019 Bhuman Soni. All rights reserved.
//

import Foundation
import CoreLocation

/*
 As standard practice to increase code reusability, I isolate
 all the function specific functionality in it's own class
 */

protocol LocationUpdatesDelegate {
    func locationUpdated(lat: Double, lon: Double)
}

struct Address {
    //setting them as optional because
    //sometimes the GeoCoder cannot find
    //these from a placemark
    var name: String? = nil
    var postCode: String? = nil
    var locality: String? = nil
    var city: String? = nil
    var country: String? = nil
    var state: String? = nil //could be state or province
    
    func toString() -> String {
        if let n = name,
            let cty = city,
            let ctry = country {
            return "\(n), \(cty) (\(ctry))"
        }
        return "\(name ?? ""), \(locality ?? ""), \(city ?? ""), \(state ?? ""),  \(postCode ?? "") \(country ?? "")"
    }
}

class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager? = nil
    var locationUpdatesDelegate: LocationUpdatesDelegate?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager!.requestWhenInUseAuthorization()
        locationManager!.delegate = self
        locationManager!.startUpdatingLocation()
    }
    //MARK: Location manager delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            locationUpdatesDelegate?.locationUpdated(lat: lat, lon: lon)
        }
    }
    /*
    Technically we could separate out the Geolocation to it's own
     GeoLocationHelper wrapper class but for this, we will just
     keep it simple
    */
    func getCoordinateAddress(lat: Double, lon: Double, completion: @escaping (_ address: Address?) -> ()) {
        let location = CLLocation(latitude: lat, longitude: lon)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                return
            }
            if let placesFound = placemarks {
                // if you want to know more about everything that the CLLPlacemark class
                //offers the checkout the offical docs
                //https://developer.apple.com/documentation/corelocation/clplacemark
                for place in placesFound {
                    var address = Address()
                    address.city = place.locality
                    address.country = place.country
                    address.postCode = place.postalCode
                    address.name = place.name
                    address.state = place.administrativeArea
                    completion(address)
                }
            }
        }
    }
}
