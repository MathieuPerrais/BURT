//
//  Feed.swift
//  BURT
//
//  Created by Mathieu Perrais on 3/3/21.
//

import Foundation

struct Feed: Decodable {
    let entry: [ReviewEntry]
    
    enum CodingKeys: String, CodingKey {
        case feed
    }
    
    enum FeedKeys: String, CodingKey {
        case entry
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let feed = try values.nestedContainer(keyedBy: FeedKeys.self, forKey: .feed)
        entry = try feed.decode([ReviewEntry].self, forKey: .entry)
    }
}
