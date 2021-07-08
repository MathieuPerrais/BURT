//
//  AddMarketListView.swift
//  BURT
//
//  Created by Mathieu Perrais on 2/19/21.
//

import SwiftUI

struct AddMarketListView: View {
    @EnvironmentObject var appStoreRepository: AppStoreRepository
    @ObservedObject var storeApp: StoreApp
    @Binding var showView: Bool
    
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText).padding(8)
                
                let filteredResult = NSLocale.getAllMarkets().filter({ searchText.isEmpty ? true : $0.name.contains(searchText)})
                List {
                    ForEach(filteredResult)
                    { marketName in
                        MarketCodeCell(marketName: marketName, storeApp: storeApp)
                        // add closure to call for adding to model
                    }
                }
                .navigationTitle("Selected markets")
                .toolbar {
                    Button(action: {
                        self.showView = false
                    }) {
                        Text("Done")
                    }
                }
            }
        }
    }
}

struct MarketCodeCell: View {
    var marketName: MarketName
    @ObservedObject var storeApp: StoreApp
    @EnvironmentObject var appStoreRepository: AppStoreRepository
    
    var body: some View {
        HStack { //
            Text(marketName.name + " " + marketName.flag)
            Spacer()
            if storeApp.markets.contains { return $0.code == marketName.code } {
                Image(systemName: "checkmark").foregroundColor(.accentColor)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if storeApp.markets.contains(where: { return $0.code == marketName.code }) {
                appStoreRepository.removeMarketToApp(appId: storeApp.id, marketName: marketName)
            } else {
                appStoreRepository.addMarketToApp(appId: storeApp.id, marketName: marketName)
            }
        }
    }
}
