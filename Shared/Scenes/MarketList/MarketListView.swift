//
//  MarketListView.swift
//  BURT (iOS)
//
//  Created by Mathieu Perrais on 2/18/21.
//

import SwiftUI
import CoreData

struct MarketListView: View {
    @EnvironmentObject var appStoreRepository: AppStoreRepository
    @ObservedObject var storeApp: StoreApp
    
    @State var showAddMarketView = false
    
    private var marketsFetchRequest: FetchRequest<Market>
    private var markets: FetchedResults<Market> { marketsFetchRequest.wrappedValue }
    
    init(storeApp: StoreApp) {
        self.storeApp = storeApp
        marketsFetchRequest = FetchRequest<Market>(
            entity: Market.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Market.name, ascending: true)],
            predicate: NSPredicate(format: "app.id == %i", storeApp.id))
    }
    
    var body: some View {
        ZStack {
        List {
            ForEach(markets) { market in
                MarketCell(market: market)
                
            }
            .onDelete(perform: deleteMarket)
        }
        .navigationTitle(storeApp.name)
        .toolbar {
            Button(action: displayAddMarketSheet) {
                Label("Add", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showAddMarketView) {
            AddMarketListView(storeApp: storeApp, showView: self.$showAddMarketView)
                .environmentObject(appStoreRepository)
        }
        
        if markets.isEmpty {
            VStack {
                Spacer().frame(height: 200)
                VStack {
                    Button(action: displayAddMarketSheet){
                        Text("Add a new market")
                    }.padding(5)
                }
                Spacer()
            }
        }
        }
    }
    
    func displayAddMarketSheet() {
        self.showAddMarketView = true
    }
    
    func deleteMarket(offsets: IndexSet) {
        offsets.forEach {
            appStoreRepository.removeMarketToApp(appId: storeApp.id, marketName: MarketName(code: markets[$0].code))
        }
    }
}

struct MarketCell: View {
    @ObservedObject var market: Market
    
    var body: some View {
        NavigationLink(destination: ReviewList(market: market)) {
            VStack(alignment: .leading) {
                Text(market.name)
            }
        }
    }
}

//struct MarketListView_Previews: PreviewProvider {
//    
//    static var storeApp: StoreApp {
//        let context = PersistenceController.preview.container.viewContext
//
//        let request: NSFetchRequest<StoreApp> = StoreApp.fetchRequest()
//        return try! context.fetch(request).first!
//    }
////
//    static var previews: some View {
//        MarketListView(storeApp:MarketListView_Previews.storeApp)
//            .environment(\.managedObjectContext,
//                         PersistenceController.preview.container.viewContext)
//            .environmentObject(AppStoreRepository())
//    }
//}
