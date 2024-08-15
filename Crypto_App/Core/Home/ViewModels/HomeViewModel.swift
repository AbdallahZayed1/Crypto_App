//
//  HomeViewModel.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 04/08/2024.
//

import Foundation
import SwiftUI
import CoreData
import SwiftData

 @Observable class HomeViewModel {
    
     var allCoins : [Coin] = []
     var portfolioCoins : [Coin] = []
     var stats : [Statistic] = []
     let CoinService = CoinDataService()
     let MarketService = MarketDataService()
     let DataService : SwiftDataService
     var sortOption : sortOptions = .holdings
     private var PortfolioValue : Double = 0
     private var PreviousPortfolioValue : Double = 0
     enum sortOptions {
     case rank , rankReversed , holdings , holdingsReversed , price , priceReversed
     }
     init(modelContext : ModelContext ) {
         DataService = SwiftDataService(modelContext: modelContext)
     }
    
     
     
     @MainActor func getCoins () async {
        
             for await coin in await CoinService.$allcoins.values{
                 allCoins.removeAll()
                 allCoins.append(contentsOf: coin)
                 Homesortlist(sort: sortOption, coins: &allCoins)
             }
         
     }
     //MARK: StatsManagment
     
     @MainActor func getStatistics () async {

         for await data in await MarketService.$marketData.values {
             if let data = data {
                 let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentagechange: data.marketCapChangePercentage24HUsd)
                             let volume = Statistic(title: "24h Volume", value: data.volume)
                             let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
                             let portfolio =  Statistic(title: "Portfolio Value", value: "")
                             stats = [
                                marketCap ,
                                volume ,
                                btcDominance ,
                                portfolio
                             ]
                            await getPortfolioValue()
             }
             
         }
     }
     @MainActor func getPortfolioValue () async {
         
         for await entities in DataService.$savedlist.values {
             for await coins in  await CoinService.$allcoins.values{
                 
                 let filtered =  coins.filter { Coin in
                     entities.contains(where: {$0.coinId == Coin.id})
                 }
                 PortfolioValue = 0.0
                 PreviousPortfolioValue = 0.0
                 
                 for coin in filtered {
                     guard let entity =  DataService.savedlist.first(where: {$0.coinId == coin.id}) else { return}
                     let coina = coin.updateHoldings(amount: entity.amount)
                     
                     PortfolioValue += coina.currentHoldingsPrice
                     let currentPrice = coina.currentHoldingsPrice
                     let Coinpercentagechange = (coina.priceChangePercentage24H ?? 0) / 100
                     let previousValue = currentPrice / (1 + Coinpercentagechange)
                     
                     PreviousPortfolioValue += previousValue
                 }
                 let percentageChange = ((PortfolioValue - PreviousPortfolioValue) / PreviousPortfolioValue) * 100
                 guard let stat = stats.first(where: {$0.title == "Portfolio Value"}) else {return}
                 let  newSt =
                 stat.updateValue("$" + PortfolioValue.formattedWithAbbreviations(), percentageChange)
                 withAnimation(.easeIn) {
                     stats.removeAll(where: {$0.id == stat.id})
                     stats.append(newSt)
                 }
             }
         }
     }
         
        
     
     
     
     
     
     //MARK: PortfolioManagment
     @MainActor func updatePortfolio  (coin: Coin, amount: Double)  async{
         Task {
               DataService.updatePortfolio(coin: coin, amount: amount)
             portfolioCoins.removeAll(where: {$0.id == coin.id})
             portfolioCoins.append(coin.updateHoldings(amount: amount))
              await getPortfolioCoins()
         }
         Task {
             await getPortfolioValue()
         }
    }
     
      func deleteIt ( coin : Coin) {
//          let coin = portfolioCoins[indexSet.first ?? 0]
          guard let  entity = DataService.savedlist.first(where: {$0.coinId == coin.id}) else {print ("no") ; return}
          DataService.delete(entity: entity)
         Task {
           await getPortfolioValue()
         }
          Task {
             await getPortfolioCoins()
          }

     }
     
     @MainActor func getPortfolioCoins () async {
         
             for await entities in DataService.$savedlist.values {
             for await coins in  await CoinService.$allcoins.values{
                 portfolioCoins.removeAll()
                 let filtered =  coins.filter { Coin in
                      entities.contains(where: {$0.coinId == Coin.id})
                  }
                
                 for coin in filtered {
                     guard let entity = DataService.savedlist.first(where: {$0.coinId == coin.id}) else { return}
                     let coinx = coin.updateHoldings(amount: entity.amount)
                     portfolioCoins.append(coinx)
                 }
                 PorfolioSortlist(sort: sortOption , coins: &portfolioCoins)
                
                }
         }
         


         
    }

         
        
         @MainActor func refresh () async {
             Task {
                 await getCoins()
             }
             Task {
                await  getPortfolioCoins()
             }
             Task{
                await getStatistics()
             }
            
         }
     
     
//MARK: SearchHandlers
     
     @MainActor func HomeSearchHandler (searchtext : String)   {
         
         Task{
             for await entities in DataService.$savedlist.values {
                 for await coins in await CoinService.$allcoins.values {
                    let filtered =  coins.filter { Coin in
                         entities.contains(where: {$0.coinId == Coin.id})
                     }
                     if !searchtext.isEmpty {
                        portfolioCoins = filtered.filter { Coin in
                             filter(coin: Coin, text: searchtext)
                         }
                         allCoins = coins.filter { Coin in
                             filter(coin: Coin, text: searchtext)
                         }
                     }else  {
                        portfolioCoins = filtered
                         allCoins = coins
                     }
                 }
              }
            }
     }

     @MainActor func PortfolioSearchHandler (searchtext : String)   {
         Task{
             for await coin in  await CoinService.$allcoins.values{
                 if !searchtext.isEmpty{
                     let filtred = coin.filter({ coin in filter(coin: coin, text: searchtext)})
                     allCoins = filtred
                 }
                 else {
                     allCoins = coin
                 }
             }
         }
     }
     // Search filter logic
     private func filter(coin : Coin , text : String)  -> Bool {
         
         coin.name.lowercased().contains(text.lowercased()) ||
         coin.id.lowercased().contains(text.lowercased()) ||
         coin.symbol.lowercased().contains(text.lowercased())
         
     }
     
     
     
     //MARK: Sorting Managment
     func SortListsUI () {
         Task {await getCoins()}
         Task {
            await getPortfolioCoins()
         }
     }
     private func Homesortlist (sort : sortOptions , coins:  inout [Coin]) {
         switch sort {
         case .rank , .holdings , .holdingsReversed:
             coins.sort(by: {$0.rank < $1.rank})
         case .rankReversed :
             coins.sort(by: {$0.rank > $1.rank})
         case .price :
             coins.sort(by: {$0.currentPrice < $1.currentPrice})
         case .priceReversed :
             coins.sort(by: {$0.currentPrice > $1.currentPrice})

         }
    
     }
     private func PorfolioSortlist (sort : sortOptions , coins:  inout [Coin]) {
         switch sort {
         case .rank :
             coins.sort(by: {$0.rank < $1.rank})
         case .rankReversed :
             coins.sort(by: {$0.rank > $1.rank})
         case .price :
             coins.sort(by: {$0.currentPrice < $1.currentPrice})
         case .priceReversed :
             coins.sort(by: {$0.currentPrice > $1.currentPrice})
         case .holdings :
             coins.sort(by: {$0.currentHoldingsPrice  < $1.currentHoldingsPrice })
         case .holdingsReversed :
             coins.sort(by: {$0.currentHoldingsPrice > $1.currentHoldingsPrice })

         }
    
     }
     
}
