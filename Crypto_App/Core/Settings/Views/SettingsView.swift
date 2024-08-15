//
//  SettingsView.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 11/08/2024.
//

import SwiftUI

struct SettingsView: View {
    private let defaultURL = URL(string: "https://www.google.com")!
    private let youtubetURL = URL(string: "https://www.youtube.com/c/swiftfulthinking")!
    private let CoffeetURL = URL(string: "https://www.buymeacoffee.com/nicksarno")!
    private let coingeckoURL = URL(string: "https://www.coingecko.com")!
    private let personalURL = URL(string:  "https://www.linkedin.com/in/abdallah-zayed-368494303")!
    var body: some View {
        NavigationStack{
            ZStack {
                //background
                Color.background.ignoresSafeArea()
                
                //content
                List {
                    swiftfulThinkingSection
                        .listRowBackground(Color.background.opacity(0.5))
                    coinGeckoSection
                        .listRowBackground(Color.background.opacity(0.5))
                    developerSection
                        .listRowBackground(Color.background.opacity(0.5))
                    applicationSection
                }.scrollContentBackground(.hidden)
     }
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    XmarkButton()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
   private var swiftfulThinkingSection : some View {
        Section("Swiftful thinking") {
            VStack (alignment : .leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100 , height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following @swiftfulThinking course  on youtube by adapting certain functions to match the updates that happpend in the period between the made of this course (2021) and the actual developement of the app (2024)")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(.accent)
            }
            .padding(.vertical)
            Link("Subscribe on youtube", destination: youtubetURL)
            Link("Buy him a coffee", destination: CoffeetURL)
        }.tint(Color.blue)
    }
    private var coinGeckoSection : some View {
         Section("CoinGecko ") {
             VStack (alignment : .leading){
                 Image("coingecko")
                     .resizable()
                     .frame( height: 100)
                     .clipShape(RoundedRectangle(cornerRadius: 20))
                 Text("The cryptocurrency data used in this app comes from a free API from CoinGecko , please note that prices may be delayed and the limit of API calls is 5 per min , So sometimes the description of coins will not load , so wait a minute and then try again ...")
                     .font(.callout)
                     .fontWeight(.medium)
                     .foregroundStyle(.accent)
             }
             .padding(.vertical)
             Link("Visit CoinGecko", destination: coingeckoURL)
         }
         .tint(Color.blue)
     }
    private var developerSection : some View {
         Section("Developer") {
             VStack (alignment : .leading){
                 Image("Me")
                     .resizable()
                     .frame(width: 100 , height: 100)
                     .clipShape(RoundedRectangle(cornerRadius: 20))
                 Text("This app was developed by me 'Abdallah Zayed'. It uses swiftui , swiftdata (and a non activated core data service ) , async swift. Also , it uses MVVM . Also , it is completley thread safe ")
                     .font(.callout)
                     .fontWeight(.medium)
                     .foregroundStyle(.accent)
             }
             .padding(.vertical)
             Link("Linkedin profile", destination: personalURL)
         }
         .tint(Color.blue)
     }
    private var applicationSection : some View {
         Section("Developer") {
             Link("Terms of Service", destination: defaultURL)
             Link("Privacy Policy", destination: defaultURL)
             Link("Company Website", destination: defaultURL)
             Link("Learn More", destination: defaultURL)

         }
         .tint(Color.blue)
     }
}
