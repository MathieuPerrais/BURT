//
//  SwiftUIView.swift
//  BURT
//
//  Created by Mathieu Perrais on 2/11/21.
//

import SwiftUI
import NaturalLanguage

struct ReviewList: View {
    
    @EnvironmentObject var appStoreRepository: AppStoreRepository
    @ObservedObject var market: Market
    
    
    @State var showModelView = false
    
    var body: some View {
        List {
            ForEach(market.reviews.sorted(by: {$0.id > $1.id })) { review in
                ReviewCell(review: review)
            }
        }
        .onAppear {
            appStoreRepository.syncDownReviews(id: market.app.id, marketCode: market.code)
        }
        .navigationTitle(market.name)
        .toolbar {
            Button(action: displayModelsSheet) {
                Label("Language", systemImage: "quote.bubble")
            }
        }.sheet(isPresented: $showModelView) {
            ModelListView(showView: self.$showModelView)
                .environmentObject(appStoreRepository)
        }
    }
    
    func displayModelsSheet() {
        self.showModelView = true
    }
}



struct ReviewCell: View {
    var review: Review     // passed in just ONE sandwich
    
    var body: some View {
        
        //            Image(sandwich.thumbnailName)
        //                .resizable()        // our thumbnails are not all the same size
        //                .aspectRatio(contentMode: .fit )
        //                .cornerRadius(8)
        //                .frame(width: 50, height: 50 )
        
        
        
        VStack(alignment: .leading) {
            
            HStack {
                ForEach(0..<Int(review.rating), id: \.self) { _ in
                    FittedSystemImage(imageName: "star.fill", width: 15, height: 15)
                        .foregroundColor(.orange)
                }
                Spacer()
                Text(review.author).foregroundColor(Color(.systemGray))
            }
            .padding(.top, 5)
            
            Text(review.title).foregroundColor(.primary).fontWeight(.bold)
                .padding(.bottom, 3)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Text(review.content).foregroundColor(.primary).lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 3)
            
            HStack {
                Text(review.version)
                    .font(.footnote)
                    .foregroundColor(Color(.systemGray))
           
                    .padding(.bottom, 3)
                Spacer()
                HStack {
                    Text(review.language ?? "")
                        .font(.footnote)
                        .foregroundColor(
                            NLLanguage.english.rawValue == review.language ?
                                Color(.systemGreen) : Color(.systemGray))
                    
                    Image(systemName: "arrow.right").fixedSize()
                    
                    // USE JOHN SUNDELL DEFAULT THING WRAPPER FOR CONFIG
                    Text("en")
                        .font(.footnote)
                        .foregroundColor(Color(.systemGreen))
                }
            }
        }.onTapGesture {
            //            AppStoreRepository().translate(text: review.content)
        }
    }
}


struct ReviewList_Previews: PreviewProvider {
    static var previews: some View {
        ReviewList(market: Market())
    }
}


