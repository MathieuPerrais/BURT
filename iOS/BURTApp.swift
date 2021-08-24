//
//  BURTApp.swift
//  Shared
//
//  Created by Mathieu Perrais on 2/10/21.
//

import SwiftUI

@main
struct BURTApp: App {
    // PersistenceController as Singleton for now
    let persistenceController = PersistenceController.shared
    
    // only owner of the object (top) declare it as State, down the chain we use ObservableObject
    @StateObject var appStoreRepository = AppStoreRepository()
    
    init(){
        UITableView.appearance().backgroundColor = .clear
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "BalooTamma-Regular", size: 35)!]
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "BalooTamma-Regular", size: 20)!]
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                StoreAppListView()
            }
            // Thoughts: StackNavigationViewStyle leads to a bug in the UI, the row doesn't get deselected on pop
            // SwiftUI is getting there, I guess.
            .navigationViewStyle(StackNavigationViewStyle())
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(appStoreRepository)
        }
    }
}
