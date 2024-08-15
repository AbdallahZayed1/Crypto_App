//
//  StatisticModel.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 06/08/2024.
//

import Foundation

struct Statistic : Identifiable{
    let id = UUID().uuidString
    let title : String
    let value : String
    let percentagechange : Double?
    
    init(title: String, value: String, percentagechange: Double? = nil) {
        self.title = title
        self.value = value 
        self.percentagechange = percentagechange
    }
    func updateValue (_ value : String , _ percentage : Double?) -> Statistic{
        Statistic(title: self.title, value: value, percentagechange: percentage)
    }
}
