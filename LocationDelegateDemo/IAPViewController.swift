//
//  IAPViewController.swift
//  LocationDelegateDemo
//
//  Created by Bhuman Soni on 8/9/19.
//  Copyright © 2019 Bhuman Soni. All rights reserved.

import UIKit

class IAPViewController: UIViewController, IAPProductDelegate, IAPTransDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //code is not stateless after this
    //but I will address this in another post
    var iapList: [MDTIapProduct] = []
    
    // MARK: IAP protocol methods
    func iapLoaded() {
        print("IAP's have been loaded")
        for iap in iapList {
            print(iap.name)
        }
    }
    func purchaseComplete(identifier: String) {
        print("Purchase complete!")
    }
    
    func purchasesRestored(identifier: String) {
        print("Purchases restored")
    }
}
