//
//  SearchBar.swift
//  BURT
//
//  Created by Mathieu Perrais on 3/10/21.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            
            TextField("Search", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(colorScheme == .dark ? .systemGray5 : .systemGray6))
                .cornerRadius(8)
                .onTapGesture {
                    self.isEditing = true
                }
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(.systemGray))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(Color(.systemGray))
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""// Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}
