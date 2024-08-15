//
//  MarketDataService.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 06/08/2024.
//

import Foundation

actor MarketDataService {
    @Published var marketData : MarketDataModel? = nil
    init() {
        Task{
            try await getMarketData()
        }
    }
     func getMarketData () async throws  {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global")
        else{
            print("no url")
            throw URLError(.badURL)}
        do {
            let (data , _ ) =  try await URLSession.shared.data(from: url)
            let globalData = try JSONDecoder().decode((GlobalData).self, from: data)
            guard let marketdata = globalData.data else { throw URLError(.badURL) }
            marketData = marketdata
        } catch  {
            throw error
            
        }
    }
    
}
