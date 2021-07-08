//
//  Market.swift
//  BURT
//
//  Created by Mathieu Perrais on 2/21/21.
//
//

import Foundation
import CoreData


@objc(Market)
public class Market: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Market> {
        return NSFetchRequest<Market>(entityName: "Market")
    }

    @NSManaged public var code: String
    @NSManaged public var name: String
    @NSManaged public var flag: String
    @NSManaged public var averageRating: NSDecimalNumber?
    @NSManaged public var lastRatingRefresh: Date?
    @NSManaged public var app: StoreApp
    @NSManaged public var reviews: Set<Review>
}

// MARK: Generated accessors for reviews
extension Market {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: Review)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: Review)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: Set<Review>)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: Set<Review>)

}

extension Market : Identifiable {

}
