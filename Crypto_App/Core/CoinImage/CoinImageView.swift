//
//  CoinImageView.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 05/08/2024.
//

import SwiftUI

struct CoinImageView: View {
    @State var vm : CoinImageViewModel
    init(coin: Coin) {
        vm = CoinImageViewModel(coin: coin)
    }
    var body: some View {
        if let image = vm.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else if vm.isLoading {
            ProgressView()
        } else {
            Image(systemName: "questionmark")
                .foregroundStyle(Color.secondaryText)
        }
    }
}

#Preview {
    CoinImageView(coin:dev().coin)
}
