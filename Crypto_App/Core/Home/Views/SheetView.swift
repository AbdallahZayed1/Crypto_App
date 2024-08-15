//
//  SheetView.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 13/08/2024.
//

import SwiftUI

struct SheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(HomeViewModel.self) private var vm
    let coin : Coin
    @State var quantity : String
    @State var searchtext = ""
    init(coin : Coin) {
        self.coin = coin
        quantity =  "\(coin.currentHoldings ?? 0 )"
    }
    var body: some View {
        VStack {
            VStack(spacing : 20){
            HStack{
            Text("Current price of \(coin.symbol.uppercased() )")
            Spacer()
            Text(coin.currentPrice.asCurrencywith6decimals() )
            }
                Divider()
                HStack{
                    Text("Desired amount:")
                    Spacer()
                    TextField(coin.currentHoldingsPrice.asCurrencywith2decimals() , text: $quantity)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                Divider()
                HStack {
                    Text("Current value :")
                    Spacer()
                    Text(getCurrentValue().asCurrencywith2decimals())
                       
                }
                Button(action: {
                    Task {
                        await vm.updatePortfolio(coin: coin, amount: Double( quantity ) ?? 0)
                        dismiss()
                        await vm.getPortfolioCoins()
                      
                        
                       
                        
                      
                    }
                    
                }, label: {
                    Text("Update")
                        .foregroundStyle(.accent)
                })
                .frame(width: 60)
            }
        }
        .foregroundStyle(.secondaryText)
    }
}

#Preview {
    SheetView(coin: dev().coin)
}
extension SheetView {
    private func getCurrentValue () -> Double {
        if let quantity = Double(quantity) {
            return quantity * (coin.currentPrice)
        }
        return 0
    }

}
