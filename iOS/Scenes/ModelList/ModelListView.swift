//
//  ModelListView.swift
//  BURT (iOS)
//
//  Created by Mathieu Perrais on 5/28/21.
//

import SwiftUI

struct ModelListView: View {
    
    @Binding var showView: Bool
    
    var translationRepository: TranslationRepository = TranslationRepository()
    
    var body: some View {
        VStack {
            List {
                ForEach(translationRepository.listDownloadedTranslateModels().sorted(by: {$0.language.rawValue > $1.language.rawValue })) { model in
                    //                ReviewCell(review: review)
                    Text(model.language.rawValue)
                }
            }
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Add new translate model")
            })
            
        }
    }
}

struct ModelListView_Previews: PreviewProvider {
    static var previews: some View {
        ModelListView(showView: .constant(true))
    }
}
