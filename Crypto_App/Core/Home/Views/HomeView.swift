//
//  HomeView.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 03/08/2024.
//

import SwiftUI

struct HomeView: View {
    @State private var searchtext = ""
    @Environment(HomeViewModel.self ) private var vm
    @State private var showPortfolio : Bool = false
    @State private var showPortfolioView : Bool = false
    @State private var showSettingsView : Bool = false
    @State private var animate : Bool = false
    @State private var selectedCoin : Coin? = nil

    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView(showPortfolio: $showPortfolio , showPortfolioView: $showPortfolioView)
                        .environment(vm)
                    
                })
            VStack{
                
                header
                HomeStatsView(showportfolio: $showPortfolio)
                SearchBarView(searchText: $searchtext)
                columnTitles

                if !showPortfolio {
                   allCoinsList
                    .transition(.move(edge: .leading))
                }
                if showPortfolio {
                   PortfolioCoinsList
                    .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
            .sheet(item: $selectedCoin, content: { coin in
                ZStack {
                    Color.background.ignoresSafeArea()
                    SheetView(coin: coin) 
                        
                }
                    .presentationDetents([.fraction(0.3)])
            }
            )
            .sheet(isPresented: $showSettingsView, content: {
                SettingsView()
            })
            .refreshable {
                    await vm.refresh()
            }
            .onChange(of: searchtext) {
                Task{
                    try await Task.sleep(for: .seconds(0.5))
                    vm.HomeSearchHandler(searchtext: searchtext)
                }
                
                }
            .onChange(of: vm.sortOption, {vm.SortListsUI()})
            
            .navigationDestination(for: Coin.self, destination: { coin in
                DetailView(coin: coin)
            }
            )
            .task {
                await vm.getStatistics()
            }
            .task {
                await vm.getCoins()
            }
            .task {
               await vm.getPortfolioCoins()
            }

             }

           
        }
   }
    

#Preview {
    NavigationStack{
        HomeView()
    }
    .modelContainer(for : [CoinData.self])
    .environment(dev().HomeVm)
}




extension HomeView {
    
    private var header : some View {
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none , value: showPortfolio)
                .background(
                    CircleButtonAnimationView(animate: $animate)
                )
                .onTapGesture {
                    if showPortfolio {
                        searchtext = ""
                        showPortfolioView.toggle()
                    }else {
                        showSettingsView.toggle()
                    }
                }
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .animation(.none)
                .fontWeight(.heavy)
                .foregroundStyle(Color.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0) )
                
                .onTapGesture {
                    withAnimation(.spring) {
                        showPortfolio.toggle()
                        animate.toggle()
                    }
                }
        }.padding(.horizontal)
    }
    
    private var allCoinsList : some View {
        List{
            ForEach( vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: false)
                    .overlay {
                        NavigationLink(value: coin) {
                            EmptyView()
                        }.opacity(0.0)
                    }
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 12, leading: 0, bottom: 15, trailing: 10))
        }
        .listStyle(.plain)
            }
    
    private var PortfolioCoinsList : some View {
        List{
            ForEach(vm.portfolioCoins) { coin in
//                CoinRowView(coin: coin, showHoldingColumn: true)
//                Text("\(coin.currentHoldings)")
                GeometryReader(content: { geometry in
                    HStack(spacing : 0){
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
                        Spacer()
                        
                            VStack(alignment: .trailing, spacing : 0 ){
                                Text(coin.currentHoldingsPrice.asCurrencywith2decimals() )
                                    .bold()
                                Text(coin.currentHoldings?.asNumberString() ?? "")
                                    
                            }.foregroundStyle(Color.accent)

                        
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
                        .padding(.trailing , 5)
                        .frame(width: geometry.size.width / 3.5 , alignment: .trailing)
                            
                    }

                    .font(.subheadline)
                }).transaction { transaction in
                    transaction.animation = nil
                }
                .swipeActions(
                    allowsFullSwipe : false
                       , content : {
                            Button(role: .destructive) {
                                vm.deleteIt(coin: coin)
                            } label: {
                                Text("Delete")
                            }
                            Button {
                                selectedCoin = coin
                            } label: {
                                    Text("Edit")
                            }
                            .tint(.yellow)

                        }
                    )
              
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 12, leading: 0, bottom: 15, trailing: 10))
        }
        .listStyle(.plain)
    }

    private var columnTitles : some View {
        GeometryReader(content: { geometry in
            HStack{
                HStack (spacing : 4){
                    Text("Coin")
                    Image(systemName: "chevron.down")
                        .opacity(( vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1 : 0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
                }.onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                    }
                    
                }
                Spacer()
                if showPortfolio {
                    HStack (spacing : 4){
                        Text("Holdings")
                        Image(systemName: "chevron.down")
                            .opacity(( vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1 : 0)
                            .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                    }.onTapGesture {
                        withAnimation( .default) {
                            vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                        }
                    }
                }
                
                HStack (spacing : 4){
                    Text("Price")
                    Image(systemName: "chevron.down")
                        .opacity(( vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1 : 0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
                }.onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                    }
                }
                    .frame(width: geometry.size.width / 3.5 , alignment: .trailing)
            }

        })
        .frame(height: 12)
        .font(.caption)
        .foregroundStyle(Color.secondaryText)
        .padding(.horizontal)
    }
        
        
}


