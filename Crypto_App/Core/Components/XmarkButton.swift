//
//  XmarkButton.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 06/08/2024.
//

import SwiftUI

struct XmarkButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button(action: {dismiss()}, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

#Preview {
    XmarkButton()
}
