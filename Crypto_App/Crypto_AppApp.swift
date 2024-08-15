//
//  Crypto_AppApp.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 03/08/2024.
//

import SwiftUI
import SwiftData
@main
struct Crypto_AppApp: App {
    let container: ModelContainer
    
    @State private  var vm  : HomeViewModel
    @State private var showLaunchView : Bool = true
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(.accent)]
        UITableView.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().tintColor = UIColor(Color.accent)
        
        do {
            container = try ModelContainer(for : CoinData.self)
        } catch  {
            fatalError("Error creating model container for el araf")
        }
        vm = HomeViewModel(modelContext: container.mainContext)
    }
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack{
                    HomeView()
                    
                        .toolbar(.hidden)
                } .environment(vm)
                ZStack {
                    if showLaunchView{
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                    
                } .zIndex(2.0)
            } .modelContainer(container)
        }
    }
}
