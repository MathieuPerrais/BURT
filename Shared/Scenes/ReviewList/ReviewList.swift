//
//  SwiftUIView.swift
//  BURT
//
//  Created by Mathieu Perrais on 2/11/21.
//

import SwiftUI

struct ReviewList: View {
    
    @EnvironmentObject var appStoreRepository: AppStoreRepository
    @ObservedObject var market: Market
    
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
            Text(review.version)
                .font(.footnote)
                .foregroundColor(Color(.systemGray))
                .padding(.bottom, 3)
        }
    }
}


struct ReviewList_Previews: PreviewProvider {
    static var previews: some View {
        ReviewList(market: Market())
    }
}


