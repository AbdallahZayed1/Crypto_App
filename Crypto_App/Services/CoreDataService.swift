//
//  PortfolioDataService.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 08/08/2024.
//

import Foundation
import CoreData

class CoreDataService : ObservableObject {
     let container : NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entityName = "PortfolioEntity"
   @Published var entities : [PortfolioEntity] = []
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("error loading core data" , error)
            }
        }
    }
    
    //MARK: Public
    
    func updatePortfolio(coin : Coin , amount : Double ) {
        if let entity = entities.first(where: { $0.coinId == coin.id } ) {
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
    
    func getPortfolio ()  throws  {
       let request = NSFetchRequest <PortfolioEntity> (entityName: entityName )
       do {
           entities = try container.viewContext.fetch(request)
           
       } catch let error {
           print(" error fetching request " , error)
           throw error
       }
   }
    
    
    //MARK: Private

    private func add ( coin : Coin , amount : Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinId = coin.id
        entity.amount = amount
        applyChanges()
    }
     private func save (){
        do {
            try container.viewContext.save()
        } catch let error {
            print("error saving to core data" , error)
        }
    }
     private func update (entity : PortfolioEntity , amount : Double){
        entity.amount = amount
        applyChanges()
    }
     func delete (entity : PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func applyChanges () {
        save()
        try? getPortfolio()
    }
}
