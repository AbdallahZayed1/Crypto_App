//
//  SearchBarView.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 05/08/2024.
//

import SwiftUI

struct SearchBarView: View {
    @FocusState private var IsFocused: Bool
    @Binding var searchText : String
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ? Color.secondaryText : Color.accent
                )
            TextField("Search by name or Symbol..", text: $searchText)
                .focused($IsFocused)
                .foregroundStyle(Color.accent)
                .autocorrectionDisabled()
                .overlay(alignment: .trailing) {
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10.0)
                        .foregroundStyle(Color.accent)
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .onTapGesture {
                            searchText = ""
                            IsFocused = false
                        }
                }
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.background)
                .shadow(
                    color: Color.accent.opacity(0.15)
                        , radius: 10)
        )
        .padding()
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
