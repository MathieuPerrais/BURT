//
//  Review.swift
//  BURT
//
//  Created by Mathieu Perrais on 2/21/21.
//
//

import Foundation
import CoreData


@objc(Review)
public class Review: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var author: String
    @NSManaged public var content: String
    @NSManaged public var translatedContent: String?
    @NSManaged public var language: String?
    @NSManaged public var rating: Int16
    @NSManaged public var title: String
    @NSManaged public var translatedTitle: String?
    @NSManaged public var translated: Bool
    @NSManaged public var version: String
    @NSManaged public var market: Market
    @NSManaged public var link: URL
    @NSManaged public var sentiment: String?

    convenience init(entry: ReviewEntry, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.id = entry.id
        self.author = entry.author
        self.content = entry.content
        self.title = entry.title
        self.version = entry.version
        self.rating = Int16(entry.rating)
        self.link = entry.link
        
        let analysis = LanguageAnalysis(text: entry.content)
        self.sentiment = analysis.getSentiment()
        self.language = analysis.getLanguage()?.rawValue
    }
}

extension Review : Identifiable {

}
