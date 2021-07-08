//
//  Request+Reviews.swift
//  BURT
//
//  Created by Mathieu Perrais on 2/15/21.
//

import Foundation
import Envol

extension Request where ResponseType == Feed {
    static func reviews(id: Int64, marketCode: String) -> Request<ResponseType> {
        let request = HTTPRequest(path: "\(marketCode.lowercased())/rss/customerreviews/id=\(id)/sortby=mostrecent/json")
        return Request(underlyingRequest: request)
    }

}
