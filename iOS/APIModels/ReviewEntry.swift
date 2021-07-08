//
//  ReviewEntry.swift
//  BURT
//
//  Created by Mathieu Perrais on 3/3/21.
//

import Foundation

struct ReviewEntry: Decodable {
    let id: Int64
    let author: String
    let title: String
    let content: String
    let rating: Int
    let version: String
    let link: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case title
        case content
        case rating = "im:rating"
        case version = "im:version"
        case link
    }
    
    
    enum AuthorKeys: String, CodingKey {
        case name
    }
    
    enum LabelKeys: String, CodingKey {
        case label
    }
    
    enum LinkKeys: String, CodingKey {
        case attributes
    }
    
    enum AttributesKeys: String, CodingKey {
        case href
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let idInfo = try values.nestedContainer(keyedBy: LabelKeys.self, forKey: .id)
        let idString = try idInfo.decode(String.self, forKey: .label)
        guard let idInt = Int64(idString) else {
            throw RepositoryError.stringNotConvertibleToInt(field: "review id", value: idString)
        }
        id = idInt
        
        let authorInfo = try values.nestedContainer(keyedBy: AuthorKeys.self, forKey: .author)
        let authorName = try authorInfo.nestedContainer(keyedBy: LabelKeys.self, forKey: .name)
        author = try authorName.decode(String.self, forKey: .label)
        
        let titleInfo = try values.nestedContainer(keyedBy: LabelKeys.self, forKey: .title)
        title = try titleInfo.decode(String.self, forKey: .label)
        
        let contentInfo = try values.nestedContainer(keyedBy: LabelKeys.self, forKey: .content)
        content = try contentInfo.decode(String.self, forKey: .label)
        
        let ratingInfo = try values.nestedContainer(keyedBy: LabelKeys.self, forKey: .rating)
        let ratingString = try ratingInfo.decode(String.self, forKey: .label)
        
        guard let ratingInt = Int(ratingString) else {
            throw RepositoryError.stringNotConvertibleToInt(field: "review rating", value: ratingString)
        }
        rating = ratingInt
        
        let versionInfo = try values.nestedContainer(keyedBy: LabelKeys.self, forKey: .version)
        version = try versionInfo.decode(String.self, forKey: .label)
        
        let linkInfo = try values.nestedContainer(keyedBy: LinkKeys.self, forKey: .link)
        let linkAttributes = try linkInfo.nestedContainer(keyedBy: AttributesKeys.self, forKey: .attributes)
        link = try linkAttributes.decode(URL.self, forKey: .href)
    }
}
 extension String: Error {}

