//
//  CoinLogoView.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 07/08/2024.
//

import SwiftUI

struct CoinLogoView: View {
    let coin : Coin
    var body: some View {
        VStack{
            CoinImageView(coin: coin)
                .frame(width: 50 , height: 50 )
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5 )
            Text(coin.name)
                .font(.caption)
                .foregroundStyle(.secondaryText )
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    CoinLogoView(coin:dev().coin)
}
