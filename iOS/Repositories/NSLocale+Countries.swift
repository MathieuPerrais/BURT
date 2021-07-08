//
//  NSLocale+Countries.swift
//  BURT
//
//  Created by Mathieu Perrais on 2/22/21.
//

import Foundation

extension NSLocale {
    static func getAllMarkets() -> [MarketName] {
        let marketNames = NSLocale.isoCountryCodes.map { code in
            return MarketName(code: code)
        }
        
        return marketNames.sorted { (mn1, mn2) -> Bool in
            mn1.name < mn2.name
        }
    }
}


