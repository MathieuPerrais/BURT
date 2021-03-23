//
//  StarRatingView.swift
//  BURT
//
//  Created by Mathieu Perrais on 3/19/21.
//

import SwiftUI

struct StarRatingView: View {
    
    let maximumStars = 5
    let rating: Float
    
    private var numberOfFullStars: Int {
        return Int(rating.round(nearest: 0.5))
    }
    
    private var hasHalfStar: Bool {
        return (rating.round(nearest: 0.5).truncatingRemainder(dividingBy: 1)) == 0.5
    }
    
    private var numberOfEmptyStars: Int {
        return maximumStars - numberOfFullStars - (hasHalfStar ? 1 : 0)
    }
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<numberOfFullStars) { _ in
                FittedSystemImage(imageName: "star.fill", width: 15, height: 15)
                    .foregroundColor(.orange)
            }
            if hasHalfStar {
                FittedSystemImage(imageName: "star.leadinghalf.fill", width: 15, height: 15)
                        .foregroundColor(.orange)
            }
            ForEach(0..<numberOfEmptyStars) { _ in
                FittedSystemImage(imageName: "star", width: 15, height: 15)
                    .foregroundColor(.orange)
            }
            
            Text(String(format: "%.2f", rating.round(nearest: 0.01))).font(.footnote)
                .foregroundColor(Color(.systemGray)).padding(.top, 2)
        }
    }
}
