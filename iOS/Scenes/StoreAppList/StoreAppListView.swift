//
//  StoreAppListView.swift
//  Shared
//
//  Created by Mathieu Perrais on 2/10/21.
//

import SwiftUI

struct StoreAppListView: View {
    @EnvironmentObject var appStoreRepository: AppStoreRepository
    @State var showAddAppView = false

    // Convenience FetchRequest wrapper
    // thoughts: seems like it's for beginners, will be limited pretty fast
    @FetchRequest(
        entity: StoreApp.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \StoreApp.name, ascending: false)
        ]
    ) var storeApps: FetchedResults<StoreApp>
    
    
    var body: some View {
        ZStack {
            List {
                ForEach(storeApps) { storeApp in
                    StoreAppCell(storeApp: storeApp)
                }
                .onDelete(perform: deleteStoreApp)
            }
            .navigationTitle(Text("App list"))
            .navigationBarItems(leading: Image("Head")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25)
            )
            .toolbar {
                Button(action: addStoreApp) {
                    Label("Add", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showAddAppView) {
                AddStoreAppView(showView: self.$showAddAppView)
                    .environmentObject(appStoreRepository)
            }
            
            if storeApps.isEmpty {
                VStack {
                    Spacer().frame(height: 200)
                    VStack {
                        Text("No apps are registered")
                        Button(action: addStoreApp){
                            Text("Add a new app")
                        }.padding(5)
                    }
                    Spacer()
                }
            }
        }
    }
    
    func addStoreApp() {
        showAddAppView = true
    }
    
    // Swipe to delete function
    func deleteStoreApp(offsets: IndexSet) {
        let idsToRemove = offsets.map { storeApps[$0].id }
        appStoreRepository.deleteStoreApps(idsToRemove)
    }
}

struct StoreAppCell: View {
    @EnvironmentObject var appStoreRepository: AppStoreRepository
   	@ObservedObject var storeApp: StoreApp
    
    var body: some View {
        NavigationLink(destination: MarketListView(storeApp: storeApp)) {
            VStack(alignment: .leading) {
                Text(storeApp.name)
                StarRatingView(rating: Float(truncating: storeApp.averageRating))
            }
        }
    }
}
