//
//  CoinDetailDataService.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 11/08/2024.
//

import Foundation

actor CoinDetailDataService {
    
    @Published var coinDetails : CoinDetail? = nil
    let coin : Coin
    init(coin : Coin) {
        self.coin = coin
         Task{
             try await getCoinDetails()
         }
     }
      func getCoinDetails () async throws  {
          guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
         else{
             print("no url")
             throw URLError(.badURL)}
         do {
             let (data , _ ) =  try await URLSession.shared.data(from: url)
             coinDetails = try JSONDecoder().decode(CoinDetail.self, from: data)
         } catch  {
             throw error
         }
     }
     
}
