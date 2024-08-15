//
//  LaunchView.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 12/08/2024.
//

import SwiftUI

struct LaunchView: View {
    @State private var loadingText : [String] = "Loading your portfolio...".map({String($0)})
    @State private var showLoadingtext : Bool = false
    @State private var counter  : Int = 0
    @State private var loops : Int = 0
    @Binding  var showLaunchView : Bool
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .frame(width: 100 , height: 100 )
            ZStack{
                if showLoadingtext {
                    HStack(spacing : 0){
                        ForEach(loadingText.indices , id: \.self) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .foregroundStyle(.launchAccent)
                                .offset(y: counter == index ? -5 : 0 )
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(y: 70)
        }
        .onAppear(perform: {
            showLoadingtext.toggle()
        })
        .onReceive(timer, perform: { _ in
            withAnimation(.spring) {
                let lastIndex = loadingText.count - 1
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false
                    }
                }else {
                    counter += 1
                }
                
            }
        })
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
