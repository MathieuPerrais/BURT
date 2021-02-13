//
//  FittedSystemImage.swift
//  BURT
//
//  Created by Mathieu Perrais on 3/10/21.
//

import SwiftUI

struct FittedSystemImage: View
{
    let imageName: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
        }
        .frame(width: width, height: height)
    }
}
