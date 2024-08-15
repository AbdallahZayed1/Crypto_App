//
//  PortfolioView.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 06/08/2024.
//

import SwiftUI

struct PortfolioView: View {
    @Environment(HomeViewModel.self) private var vm
    @State private var searchtext = ""
    @State private var selectedCoin : Coin? = nil
    @State private var quantity = ""
    @State private var showCheckMark : Bool = false
    @Binding  var showPortfolio : Bool
    @Binding  var showPortfolioView : Bool
    @FocusState private var IsFocused: Bool

    var body: some View {
        NavigationStack{
            ScrollView {
                SearchBarView(searchText: $searchtext).focused($IsFocused)
                coinLogoList
                if selectedCoin != nil {
             portfolioInputSection
              }
            }
            .background(
                Color.background.ignoresSafeArea() 
            )
            .navigationTitle("Edit Portfolio")
           
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    XmarkButton( )
                }
                ToolbarItem(placement: .topBarTrailing) {
                  trailingNavBar
                }
            })
        }
        .onChange(of: searchtext) {
            Task{
                if searchtext .isEmpty {
                    removeSelectedCoin()
                }
                try await Task.sleep(for: .seconds(0.5))
                vm.PortfolioSearchHandler(searchtext: searchtext)
                }
            }
        

    }
}



#Preview {
    PortfolioView(showPortfolio: .constant(true), showPortfolioView: .constant(true))
        .environment(dev().HomeVm)
}

extension PortfolioView {
    private var coinLogoList : some View {
        ScrollView {
            VStack(alignment : .leading , spacing : 0){
                ScrollView(.horizontal , showsIndicators: false ) {
                    LazyHStack (spacing : 10) {
                        ForEach( (!searchtext.isEmpty || vm.portfolioCoins.isEmpty) ? vm.allCoins : vm.portfolioCoins) { coin in
                            CoinLogoView(coin: coin)
                                .frame(width: 75)
                                .padding(4)
                                .onTapGesture {
                                    withAnimation(.easeIn){
                                       updateSelectedCoin(coin: coin)
                                    }
                                }
                    .background(RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedCoin?.id == coin.id ? Color.greeny : Color.clear , lineWidth: 1)
                                )
                        }
                    }
                    .padding(.vertical , 4)
                    .padding(.leading)
                }
            }
        }
    }
    private func updateSelectedCoin ( coin : Coin ) {
        selectedCoin = coin
        if let coin = vm.portfolioCoins.first(where: {$0.id == coin.id}){
            quantity = "\(coin.currentHoldings ?? 0 )"
        }
        else {
            quantity = ""
        }
    }
    private func getCurrentValue () -> Double {
        if let quantity = Double(quantity) {
            return quantity * (selectedCoin?.currentPrice ?? 0 )
        }
        return 0
    }
    
    private var portfolioInputSection : some View {
        VStack(spacing : 20){
        HStack{
        Text("Current price of \(selectedCoin?.symbol.uppercased() ?? "")")
        Spacer()
        Text(selectedCoin?.currentPrice.asCurrencywith6decimals() ?? "")
        }
            Divider()
            HStack{
                Text("Amount in your portfolio")
                Spacer()
                TextField("Ex 1.4" , text: $quantity)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value :")
                Spacer()
                Text(getCurrentValue().asCurrencywith2decimals())
            }
        }.transaction { transaction in
            transaction.animation = nil
        }
        
        .padding()
        .font(.headline)
    }
    private var trailingNavBar : some View {
        HStack( spacing : 10 , content: {
           Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1 : 0)
            
            Button(action: {saveButtonPressed() }, label: {
                Text("Save".uppercased())
                   
            })
            .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantity) ) ? 1 : 0 )
           
        })
        .font(.headline)
    }
    private func saveButtonPressed () {
        guard 
            let coin = selectedCoin ,
            let amount = Double(quantity)
        else {return}
        Task {
            await vm.updatePortfolio(coin: coin , amount: amount)
        }
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
            IsFocused = false
        }
        Task{
            
            try await Task.sleep(for: .seconds(2))
            await MainActor.run {
                withAnimation(.easeOut) {
                    showCheckMark = false
                }
            }
        }
        
    }
    private func removeSelectedCoin () {
        selectedCoin = nil
        searchtext = ""
        quantity = ""
    }
}
