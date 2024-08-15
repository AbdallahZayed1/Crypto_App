//
//  DetailViewModel.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 11/08/2024.
//

import Foundation

@Observable class DetailViewModel {
    let coin : Coin
    private let CoinDetailService : CoinDetailDataService
    var overViewStatistics : [Statistic] =  []
    var additionalStatistics : [Statistic] = []
    var coinDescription : String? = nil
    var websiteURL : String? = nil
    var redditURL : String? = nil
    
    
    
    init(coin : Coin) {
        self.coin = coin
        CoinDetailService = CoinDetailDataService(coin: coin)
 
    }
    
    func getDetailCoin () async {
        for await Detailcoin in await CoinDetailService.$coinDetails.values {
            if let Detailcoin = Detailcoin {
                additionalStatistics = getAdditionalStats(Detailcoin)
                overViewStatistics = getOverViewStats()
                coinDescription = Detailcoin.readableDescription
                websiteURL = Detailcoin.links?.homepage?.first
                redditURL = Detailcoin.links?.subredditURL


            }
        }

    }

    
    
    
    
    private func getOverViewStats () -> [Statistic] {
        let price = coin.currentPrice.asCurrencywith2decimals()
        let priceChangePercentage = coin.priceChangePercentage24H
        let priceStat = Statistic(title: "Current Price", value: price, percentagechange: priceChangePercentage)
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChangePercentage = coin.marketCapChangePercentage24H
        let marketCapStat = Statistic(title: "Market Capitlization", value: marketCap, percentagechange: marketCapChangePercentage)
        let rank = "\(coin.rank)"
        let rankStat = Statistic(title: "Rank", value: rank)
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistic(title: "Volume", value: volume )
        return [priceStat , marketCapStat , rankStat , volumeStat]
    }
    
    
    
    private func getAdditionalStats (_ Detailcoin : CoinDetail) -> [Statistic] {
        let high = coin.high24H?.asCurrencywith6decimals() ?? "n/a"
        let highStat = Statistic(title: "24h High", value: high)
        let low = coin.low24H?.asCurrencywith6decimals() ?? "n/a"
        let lowStat = Statistic(title: "24h Low", value: low)
        let priceChange = coin.priceChange24H?.asCurrencywith6decimals() ?? "n/a"
        let priceChangePercentage2 = coin.priceChangePercentage24H
        let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentagechange: priceChangePercentage2)
        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapChangePercentage2 = coin.marketCapChangePercentage24H
        let marketCapChangeStat = Statistic(title: "24h Market Cap Change", value: marketCapChange, percentagechange: marketCapChangePercentage2)
        let blockTime = Detailcoin.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = Statistic(title: "Block Time", value: blockTimeString)
        let hashing = Detailcoin.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistic(title: "Hashing Algorithm", value: hashing)
        
        return [highStat , lowStat , priceChangeStat , marketCapChangeStat , blockStat , hashingStat]
    }
}
