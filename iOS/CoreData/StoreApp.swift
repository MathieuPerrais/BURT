//
//  StoreApp.swift
//  BURT
//
//  Created by Mathieu Perrais on 2/21/21.
//
//

import Foundation
import CoreData

@objc(StoreApp)
public class StoreApp: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoreApp> {
        return NSFetchRequest<StoreApp>(entityName: "StoreApp")
    }
    
    @NSManaged public var averageRating: NSDecimalNumber
    @NSManaged public var icon: Data?
    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var ratingCount: Int
    @NSManaged public var storeDescription: String
    @NSManaged public var version: String
    @NSManaged public var markets: Set<Market>
    
    convenience init(appResult: AppResult, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.id = appResult.id
        self.name = appResult.name
//        self.icon = appResult.icon
        self.storeDescription = appResult.storeDescription
        self.version = appResult.version
        self.averageRating = appResult.averageUserRating as NSDecimalNumber
        self.ratingCount = appResult.userRatingCount
    }
}

// MARK: Generated accessors for markets
extension StoreApp {

    @objc(addMarketsObject:)
    @NSManaged public func addToMarkets(_ value: Market)

    @objc(removeMarketsObject:)
    @NSManaged public func removeFromMarkets(_ value: Market)

    @objc(addMarkets:)
    @NSManaged public func addToMarkets(_ values: Set<Market>)

    @objc(removeMarkets:)
    @NSManaged public func removeFromMarkets(_ values: Set<Market>)

}

extension StoreApp : Identifiable {

}
