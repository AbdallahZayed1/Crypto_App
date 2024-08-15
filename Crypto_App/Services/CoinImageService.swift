//
//  CoinImageService.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 05/08/2024.
//

import Foundation
import SwiftUI

actor CoinImageService {
   private let filemanagg = LocalFileManager()
   private let coin : Coin
   private let folderName = "coin_images"
   private let imageName : String
    
    init(coin : Coin) {
        self.coin = coin
        self.imageName = coin.id
        Task{
            try await getCoinImage()
        }
            }
    func getCoinImage ()  async throws -> UIImage {
        if let image = filemanagg.get_image(imageName: imageName, folderName: folderName) {
            return image
        }
        else {
            guard let image = try? await downloadCoinImage() else {throw URLError(.badURL)}
            
            try? filemanagg.save_image(image: image, imageName: imageName, folderName: folderName)
            return image
        }
    }
    func downloadCoinImage () async throws -> UIImage {
        guard let url = URL(string: coin.image)
        else{
            print("no url")
            throw URLError(.badURL)}
        do {
            let (data , _ ) =  try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {throw URLError(.badURL) }
           return image
        } catch  {
            throw error
        }
    }
    
    

}
