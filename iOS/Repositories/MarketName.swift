//
//  MarketName.swift
//  BURT
//
//  Created by Mathieu Perrais on 2/22/21.
//

import Foundation

struct MarketName: Identifiable {
    var id: String { return code }
    
    let code: String
    let name: String
    let flag: String
    
    init(code: String, name: String, flag: String) {
        self.code = code
        self.name = name
        self.flag = flag
    }
    
    /// Convenience initializer with country code only
    init(code: String) {
        self.init(code: code, name: NSLocale.current.localizedString(forRegionCode: code) ?? "", flag: code.getFlagEmoji())
    }
}

private extension String {
    func getFlagEmoji() -> String {
        return self
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}
