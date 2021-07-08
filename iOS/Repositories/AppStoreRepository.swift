//
//  AppStoreRepository.swift
//  BURT
//
//  Created by Mathieu Perrais on 2/15/21.
//

import Foundation
import CoreData
import Combine
import Envol


final class AppStoreRepository: ObservableObject {
    @Published var storeApps = [StoreApp]()
    
    private let persistenceController: PersistenceController // Make a general protocol pour save and retrieve
    // Make NSManagedObjectContext extend this protocol (save / retrieve / store) and match the custom protocol with underlying NSManagedObjectContext implementation
    
    init(persistenceController: PersistenceController = PersistenceController.shared) {
        self.persistenceController = persistenceController
    }
    
    // MARK: - API
    func syncDownStoreApp(id: Int64) {
        fetchAppLookup(id: id) { [weak self] appResult in
            self?.storeAppLookup(result: appResult)
        }
    }
    
    func syncDownReviews(id: Int64, marketCode: String) {
        fetchMarketReviews(appId: id, marketCode: marketCode) { [weak self] entries in
            self?.storeMarketReviews(result: entries, appId: id, marketCode: marketCode)
        }
    }
    
    func syncDownMarket(code: String) {
//        fetch
    }
    
    func deleteStoreApps(_ ids: [Int64]) {
        persistenceController.container.performBackgroundTask { (context) in
            let fetchRequest: NSFetchRequest<StoreApp> = StoreApp.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
            
            do {
                let storeApps = try context.fetch(fetchRequest) // TODO: handle error
                for storeApp in storeApps {
                    context.delete(storeApp)
                }
                try context.save() // TODO: handle error
            } catch {
                print(error)
            }
        }
    }
    
    func deleteStoreAppsVar(_ ids: Int64...) {
        deleteStoreApps(ids)
    }
    
    func addMarketToApp(appId: Int64, marketName: MarketName) {
        persistenceController.container.performBackgroundTask { (context) in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            let fetchRequest: NSFetchRequest<StoreApp> = StoreApp.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %i", appId)
            
            do {
                guard let storeApp = try context.fetch(fetchRequest).first else {
                    throw RepositoryError.storeAppNotFound(appId)
                }

                let market = Market(context: context)
                market.code = marketName.code
                market.name = marketName.name + " " + marketName.flag // Make better
                
                storeApp.addToMarkets(market)

                try context.save()
            } catch {
                print(error) // TODO: handle error
            }
        }
    }
    
    func removeMarketToApp(appId: Int64, marketName: MarketName) {
        persistenceController.container.performBackgroundTask { (context) in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            let fetchRequest: NSFetchRequest<StoreApp> = StoreApp.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %i", appId)
            
            do {
                guard let storeApp = try context.fetch(fetchRequest).first else {
                    throw RepositoryError.storeAppNotFound(appId)
                }

                guard let market = storeApp.markets.first(where: { $0.code == marketName.code }) else {
                    throw RepositoryError.marketNotFound(appId, marketName.code)
                }
                
                storeApp.removeFromMarkets(market)
                context.delete(market)
                
                try context.save()
            } catch {
                print(error) // TODO: handle error
            }
        }
    }
    
    
    // MARK: - Inner logic
    func fetchAppLookup(id: Int64, completionHandler: @escaping (AppResult) -> () ) {
        iTunesConnection.request(.lookupApp(id: id)) { (result) in
            switch result {
            case .success(let response):
                guard let appResult = response.body.results.first else {
                    loggerNetwork.error("API ERROR no lookup (no result?)") // TODO
                    return
                }
                completionHandler(appResult)
            case .failure(let error):
                // TODO handle errors
                loggerNetwork.critical("fetchAppLookup error: \(error.localizedDescription, privacy: .public)")
            }
        }
    }
    
    
    func fetchAppLookup(id: Int64) -> Future<Response<LookupResults>, Error> {
        return iTunesConnection.publisher(for: .lookupApp(id: id))
    }
    
    func storeAppLookup(result: AppResult) {
        persistenceController.container.performBackgroundTask { (context) in
            
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
             
            let _ = StoreApp(appResult: result, context: context)
            do {
                try context.save() // TODO: handle error
            } catch {
                print(error)
            }
        }
    }
    

    // TODO: use native enum for countries (should exist somewhere)
    private func fetchMarketReviews(appId: Int64, marketCode: String, completionHandler: @escaping ([ReviewEntry]) -> () ) {
        iTunesConnection.request(.reviews(id: appId, marketCode: marketCode)) { (result) in
            switch result {
            case .success(let response):
                let entries = response.body.entry
                completionHandler(entries)
            case .failure(let error):
                // TODO handle errors
                loggerNetwork.critical("fetchMarketReviews error: \(error.localizedDescription, privacy: .public)")
            }
        }
    }
    
    private func storeMarketReviews(result: [ReviewEntry], appId: Int64, marketCode: String) {
        persistenceController.container.performBackgroundTask { (context) in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            let fetchRequest: NSFetchRequest<StoreApp> = StoreApp.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %i", appId)
            
            do {
                guard let storeApp = try context.fetch(fetchRequest).first else {
                    throw RepositoryError.storeAppNotFound(appId)
                }

                guard let market = storeApp.markets.first(where: { $0.code == marketCode }) else {
                    throw RepositoryError.marketNotFound(appId, marketCode)
                }
                
                for entry in result {
                    let review = Review(entry: entry, context: context)
                    market.addToReviews(review)
                }
                
                try context.save()
            } catch {
                print(error)
            }
        }
    }

}


