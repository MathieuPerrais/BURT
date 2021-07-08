//
//  AppResult.swift
//  BURT
//
//  Created by Mathieu Perrais on 2/15/21.
//

import Foundation

struct AppResult: Identifiable, Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case name = "trackName"
        case icon = "artworkUrl100"
        case storeDescription = "description"
        case version, averageUserRating, userRatingCount
    }
    
    let id: Int64
    let name: String
    let storeDescription: String
    let icon: URL
    let version: String
    let averageUserRating: Decimal
    let userRatingCount: Int
}
