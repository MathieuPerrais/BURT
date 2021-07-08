//
//  RepositoryError.swift
//  BURT
//
//  Created by Mathieu Perrais on 2/19/21.
//

import Foundation

enum RepositoryError: Error {
    case storeAppNotFound(Int64)
    case marketNotFound(Int64, String)
    case countryCodeInvalid(String)
    case stringNotConvertibleToInt(field: String, value: String)
}

extension RepositoryError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .storeAppNotFound(let appId):
            return NSLocalizedString("Store app not found with id: \(appId)", comment: "")
            
        case .marketNotFound(let appId, let code):
            return NSLocalizedString("Market Code: '\(code)' is not found for app id: \(appId)", comment: "")
            
        case .countryCodeInvalid(let code):
            return NSLocalizedString("Country name can't be derived from code: \(code)", comment: "")
            
        case .stringNotConvertibleToInt(let field, let value):
            return NSLocalizedString("Can't convert field: \(field) from String (value: '\(value)') to Int", comment: "")
        }
    }
}
