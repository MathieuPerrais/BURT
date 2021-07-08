//
//  AddStoreAppView.swift
//  BURT
//
//  Created by Mathieu Perrais on 3/7/21.
//

import SwiftUI


struct AddStoreAppView: UIViewControllerRepresentable {
    @Binding var showView: Bool

    func makeCoordinator() -> AddStoreAppView.Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> AddStoreAppViewController {
        return AddStoreAppViewController()
    }
    
    func updateUIViewController(_ uiViewController: AddStoreAppViewController, context: Context) {
        
    }
}

extension AddStoreAppView {
    class Coordinator: NSObject {
        var parent: AddStoreAppView
        @Environment(\.presentationMode) var presentationMode
        
        init(_ parent: AddStoreAppView) {
            self.parent = parent
        }
    }
}
