//
//  DetailView.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 11/08/2024.
//

import SwiftUI

struct DetailView: View {
    @State private var vm : DetailViewModel
    @State private var showFullDescription : Bool = false
    private let columns : [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        ]
    
    private let spacingg : CGFloat = 30
    init( coin: Coin) {
        vm = DetailViewModel(coin: coin)
    }
    var body: some View {
        ScrollView{
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack ( spacing : 20) {
                    overViewTitle
                    Divider()
                    descriptionSection
                    overViewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    websiteSection 
                }
                .padding()

            }
        }
        .background(Color.background.ignoresSafeArea())
        .navigationTitle(vm.coin.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItems
            }
        }
        .task {
            await vm.getDetailCoin()
        }
        }
    }


#Preview {
    NavigationStack{
        DetailView( coin: dev().coin)
    }
}

extension DetailView {
    
    private var navigationBarTrailingItems : some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(.accent)
            CoinImageView(coin: vm.coin)
                .frame(width: 25 , height: 25 , alignment: .center )
        }
    }
    
    private var overViewTitle : some View {
        Text("OverView")
            .font(.title)
            .bold()
            .foregroundStyle(.accent)
            .frame(maxWidth: .infinity ,  alignment: .leading)
    }
    
    private var additionalTitle : some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(.accent)
            .frame(maxWidth: .infinity ,  alignment: .leading)
    }
    private var descriptionSection : some View {
        ZStack{
            if let coinDescription = vm.coinDescription , !coinDescription.isEmpty {
                VStack (alignment : .leading){
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(.secondaryText)
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    },
                           label: {
                        Text(showFullDescription ? "Less.." : "Read more..")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical , 4)
                    })
                    .tint(.blue)
                }
                .frame(maxWidth: .infinity , alignment: .leading)
            }
        }
    }
    
    private var overViewGrid : some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacingg ,
            content: {
                ForEach(vm.overViewStatistics) { stat in
                    StatisticView(stat: stat)
                }
            })

    }
    private var additionalGrid : some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacingg ,
            content: {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticView(stat: stat)
                }
            })

    }
    private var websiteSection : some View {
        VStack  ( alignment : .leading , spacing : 20 ){
            if let websiteString = vm.websiteURL,
               let url = URL(string: websiteString)
            {
                 Link("website", destination: url)
            }
            if let redditString = vm.redditURL ,
               let url = URL(string: redditString)
            {
                Link("Reddit", destination: url)
            }
        }
        .tint(.blue )
        .frame(maxWidth: .infinity , alignment: .leading)
        .font(.headline)
    }

}
