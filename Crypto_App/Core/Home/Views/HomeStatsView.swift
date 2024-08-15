//
//  HomeStatsView.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 06/08/2024.
//

import SwiftUI

struct HomeStatsView: View {
    @Environment(HomeViewModel.self) private var vm
    @Binding var showportfolio : Bool
    var body: some View {
        GeometryReader(content: { geometry in
            HStack(content: {
                ForEach(vm.stats) { stat in
                    StatisticView(stat: stat)
                        .frame(width: geometry.size.width / 3)
                }
            }).frame(width: geometry.size.width ,
                     
                     alignment: showportfolio ? .trailing : .leading )
        }).frame(height: 80 )
    }
}

//#Preview {
//    HomeStatsView(showportfolio: .constant(false))
//        .environment(dev.instance.HomeVm)
//}

