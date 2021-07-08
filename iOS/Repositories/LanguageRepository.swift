//
//  LanguageAnalysis.swift
//  BURT (iOS)
//
//  Created by Mathieu Perrais on 5/28/21.
//

import Foundation
import NaturalLanguage

struct LanguageAnalysis {
    
    let text: String
    let tagger = NLTagger(tagSchemes: [.language, .sentimentScore])
    
    init(text: String) {
        self.text = text
        tagger.string = text
    }
    
    func getLanguage() -> NLLanguage? {
        return tagger.dominantLanguage
    }
    
    func getSentiment() -> String? {
        let (sentiment,_) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        return sentiment?.rawValue
    }
    
}
