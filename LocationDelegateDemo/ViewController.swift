//
//  ViewController.swift
//  LocationDelegateDemo
//
//  Created by Bhuman Soni on 23/5/19.
//  Copyright © 2019 Bhuman Soni. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LocationUpdatesDelegate {
    
    @IBOutlet var locationLbl: UILabel!
    
    var address: Address? = nil {
        willSet {
            locationLbl.text = newValue?.toString()
        }
    }

    var locationHelper: LocationHelper? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        locationHelper = LocationHelper()
        locationHelper?.locationUpdatesDelegate = self
        // Do any additional setup after loading the view.
    }
    func locationUpdated(lat: Double, lon: Double) {
        locationHelper?.getCoordinateAddress(lat: lat, lon: lon, completion: { (reverseGeocodedAddress) in
            if reverseGeocodedAddress != nil {
                self.address = reverseGeocodedAddress
            }
        })
    }
}

