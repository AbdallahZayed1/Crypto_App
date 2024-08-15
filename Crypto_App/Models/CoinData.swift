//
//  PortfolioData.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 10/08/2024.
//

import Foundation
import SwiftData

@Model
class CoinData : Codable {
    let coinId : String
    let amount : Double
    
    init(coinId: String, amount: Double) {
        self.coinId = coinId
        self.amount = amount
    }
    enum CodingKeys: String , CodingKey {
        case coinId
        case amount

    }
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coinId = try container.decode(String.self, forKey: .coinId)
        self.amount = try container.decode(Double.self, forKey: .amount)
    }
    func encode (to encoder : any Encoder) throws {
        
    }
}
