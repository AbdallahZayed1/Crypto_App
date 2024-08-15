//
//  CircleButtonView.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 03/08/2024.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName : String
    var body: some View {
        
       Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(.accent)
            .frame(width: 50 , height: 50)
            .background(
                Circle()
                    .foregroundStyle(Color.background)
            )
            .shadow(color: Color.accent.opacity(0.25),
                    radius: 10 )
            .padding()
    }
}

#Preview {
    CircleButtonView(iconName: "heart")
        .previewLayout(.sizeThatFits)
}
