//
//  LookupResults.swift
//  BURT
//
//  Created by Mathieu Perrais on 2/15/21.
//

import Foundation

struct LookupResults: Decodable {
    let resultCount: Int
    let results: [AppResult]
}
