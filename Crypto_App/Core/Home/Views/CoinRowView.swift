//
//  CoinRowView.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 03/08/2024.
//

import SwiftUI

struct CoinRowView: View {
    @Environment(HomeViewModel.self ) private var vm
     let coin : Coin
    let showHoldingColumn : Bool
    var body: some View {
        GeometryReader(content: { geometry in
            HStack(spacing : 0){
                leftColumn
                Spacer()
                if showHoldingColumn{
                    centerColumn
                }
                rightcolumn
                .padding(.trailing , 5)
                .frame(width: geometry.size.width / 3.5 , alignment: .trailing)
                    
            }

            .font(.subheadline)
        })
    }
        
}



#Preview {
    CoinRowView( coin: dev().coin, showHoldingColumn: true)
}

extension CoinRowView {
     private var leftColumn : some View {
         HStack(spacing : 0) {
             Text("\(coin.rank)")
                 .font(.headline)
                 .foregroundStyle(Color.secondaryText)
                 .frame(minWidth: 30)
             CoinImageView(coin: coin)
                 .frame(width: 30 , height: 30)
             Text(coin.symbol.uppercased())
                 .font(.headline)
                 .padding(.leading , 6)
                 .foregroundStyle(Color.accent)
         }
    }
    private var centerColumn : some View {
        VStack(alignment: .trailing, spacing : 0 ){
            Text(coin.currentHoldingsPrice.asCurrencywith2decimals() )
                .bold()
            Text(coin.currentHoldings?.asNumberString() ?? "")
                
        }.foregroundStyle(Color.accent)
    }
    private var rightcolumn : some View {
        VStack(alignment: .trailing  , spacing : 0 ){
            Text(coin.currentPrice.asCurrencywith6decimals())
                .bold()
                .foregroundStyle(Color.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundStyle(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                    Color.greeny
                    : Color.redy
                )
        }
    }
}
