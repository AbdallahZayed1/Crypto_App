//
//  CircleButtonAnimationView.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 03/08/2024.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding  var animate : Bool 
    var body: some View {
        
        Circle()
            .stroke(lineWidth: 5)
            .animation(animate ? .none : .easeOut) { content in
            content
                .scaleEffect(animate ? 0 : 1)
                .opacity(animate ? 1 : 0)
            }
        
        .onAppear(perform: {
            animate.toggle()
        })
            
        
           
            
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(false))
}
