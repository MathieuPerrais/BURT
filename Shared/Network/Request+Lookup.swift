//
//  Request+Lookup.swift
//  BURT
//
//  Created by Mathieu Perrais on 2/15/21.
//

import Foundation
import Envol

extension Request where ResponseType == LookupResults {
    static func lookupApp(id: Int64) -> Request<ResponseType> {
        let queryId = URLQueryItem(name: "id", value: "\(id)")
        let request = HTTPRequest(path: "us/lookup", queryItems: [queryId])
        return Request(underlyingRequest: request)
    }
}
