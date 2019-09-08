//
//  MDTIapProduct.swift
//  LocationDelegateDemo
//
//  Created by Bhuman Soni on 8/9/19.
//  Copyright © 2019 Bhuman Soni. All rights reserved.
//

import Foundation

class MDTIapProduct {
    var identifier = ""
    var price: NSNumber?
    var name = ""
    var desc: String?
    var priceLocale: Locale!
    var regularPrice: String?
    //intro or offer price, when we have some
    init() {}
    convenience init(identifier: String, price: NSNumber?, name: String, desc: String?, priceLocale: Locale, regularPrice: String?) {
        self.init()
        self.identifier = identifier
        self.price = price
        self.name = name
        self.desc = desc
        self.priceLocale = priceLocale
        self.regularPrice = regularPrice
    }
    func summary() -> String {
        return "\(name) \n\(desc ?? "") \nPrice:\(priceLocale.currencySymbol!)\(String(describing: price?.doubleValue))"
    }
}
