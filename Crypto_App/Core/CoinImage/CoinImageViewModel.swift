//
//  CoinImageViewModel.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 05/08/2024.
//

import Foundation
import SwiftUI

@Observable class CoinImageViewModel {
    private let coin : Coin
    private let service : CoinImageService
   @MainActor var image : UIImage? = nil
    var isLoading : Bool = false
    
    init(coin : Coin) {
        self.coin = coin
        service = CoinImageService(coin: coin)
        Task {
            await getImage()
        }
    }
    
   @MainActor func getImage () {
        Task{
            isLoading = true
            image = try await service.getCoinImage()
            isLoading = false
        }
    }
}
