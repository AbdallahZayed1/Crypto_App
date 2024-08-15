//
//  NewPortfolioDataService.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 10/08/2024.
//

import Foundation
import SwiftData
class SwiftDataService {
    var container : ModelContext
    @Published var savedlist : [CoinData] = []

    init(modelContext : ModelContext) {
        container = modelContext
        fetchSwiftData()
    }
    
    func updatePortfolio(coin : Coin , amount : Double  ) {
      
        if let entity = savedlist.first(where: {$0.coinId == coin.id}) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        }
        else {
            add(coin: coin, amount: amount)
        }
    }

    func fetchSwiftData () {
        do {
            let descriptor = FetchDescriptor<CoinData>()
            savedlist = try container.fetch(descriptor)
            } catch let error {
            print("error getting new data ", error)
        }
    }
    
    //MARK: Private

    private func add ( coin : Coin , amount : Double){
        let new = CoinData(coinId: coin.id, amount: amount )
        container.insert(new)
        fetchSwiftData()
        print("coin added succcessfully")
    }

    private func update (entity : CoinData , amount :  Double){
        container.delete(entity)
        let new = CoinData(coinId: entity.coinId, amount: amount)
        container.insert(new)
        fetchSwiftData()
        try? container.save()
        print("coin updated succcessfully")
        }
     func delete (entity : CoinData) {
        container.delete(entity)
        fetchSwiftData()
        print("coin deleted succcessfully")
    }
}
