//
//  CoinDataService.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 04/08/2024.
//

import Foundation

actor CoinDataService {
   @Published var allcoins : [Coin] = []
    init() {
        Task{
            try await getCoins()
        }
    }
     func getCoins () async throws  {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
        else{
            print("no url")
            throw URLError(.badURL)}
        do {
            let (data , _ ) =  try await URLSession.shared.data(from: url)
            allcoins = try JSONDecoder().decode([Coin].self, from: data)
            
           
        } catch  {
            throw error
        }
    }
    
    
}
