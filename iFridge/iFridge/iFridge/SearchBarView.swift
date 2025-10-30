//
//  SearchBar.swift
//  iFridge
//
//  Created by Luigi Mario Aliberti on 05/05/24.
//

import Foundation
// SearchBar.swift
import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            // Campo di testo per la ricerca
            TextField("Search", text: $searchText)
                .padding(.leading, 24)
                .onChange(of: searchText) { newValue in
                    // Imposta isSearching su true quando il testo viene modificato
                    isSearching = !newValue.isEmpty
                }
            
            // Bottone per cancellare il testo di ricerca
            Button(action: {
                searchText = ""
                isSearching = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(frameYellow)
                    .padding(.trailing, 8)
                    .opacity(searchText == "" ? 0 : 1)
            }
        }
        .padding()
        .background(Color(.white))
        //.background(Color(.systemGray5))
        .frame(width: 377.0, height: 40.0)
        .cornerRadius(10)
        .padding(.horizontal)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
        .onTapGesture {
            isSearching = true
        }
    }
}
