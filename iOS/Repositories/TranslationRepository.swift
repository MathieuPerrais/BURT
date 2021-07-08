//
//  TranslationRepository.swift
//  BURT (iOS)
//
//  Created by Mathieu Perrais on 3/23/21.
//

import Combine
import MLKitTranslate




extension TranslateRemoteModel : Identifiable {
    public var id: String { language.rawValue }
}

protocol Language {
    
}

protocol TranslationProvider {
    func translate(text input: String) -> Future<String, Error>
}





func translate(text: String) {
    let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .french)
        let englishFrenchTranslator = Translator.translator(options: options)


//    englishFrenchTranslator.downloadModelIfNeeded(with: conditions) { error in
//        guard error == nil else { return }
//
//        englishFrenchTranslator.translate(text) { (translatedText, error) in
//            print("error: \(error)")
//            print("text: \(translatedText)")
//        }
//    }


}


// DO A PUBLISHER WITH PROGRESS THEN COMPLETION FOR DOWNLOAD MODEL

//make a general app banner at bottom with download with progress, and a combine publisher / or stack depending on the languages


struct TranslationRepository {//: TranslationProvider {
    
    private let conditions = ModelDownloadConditions(
        allowsCellularAccess: true,
        allowsBackgroundDownloading: true
    )
    
    func isModelDownloaded(language: TranslateLanguage) -> Bool {
        return true
    }
    
    func listDownloadedTranslateModels() -> Set<TranslateRemoteModel>{
        let localModels = ModelManager.modelManager().downloadedTranslateModels
        return localModels
    }
    
//    func translate(text input: String,
//                   sourceLanguage: TranslateLanguage,
//                   targetLanguage: TranslateLanguage = .english) -> Future<String, Error> {
//        
//        let options = TranslatorOptions(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage)
//        
//        let translator = Translator.translator(options: options)
//        print(TranslateLanguage.french)
//        
//    }
}


extension TranslateLanguage: Language {
    
    
}
