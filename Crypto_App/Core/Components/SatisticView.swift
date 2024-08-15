//
//  SatisticView.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 06/08/2024.
//

import SwiftUI

struct StatisticView: View {
    let stat : Statistic
    var body: some View {
        VStack(
            alignment: .leading, spacing: 4, content: {
                Text(stat.title)
                    .font(.caption)
                    .foregroundStyle(Color.secondaryText)
                Text(stat.value)
                    .font(.headline)
                    .foregroundStyle(.accent)
                HStack ( spacing : 4){
                    Image(systemName: "triangle.fill")
                        .font(.caption2)
                        .rotationEffect(
                            Angle(degrees: (stat.percentagechange ?? 0) >= 0 ? 0 : 180))
                        .foregroundStyle((stat.percentagechange ?? 0) >= 0 ? Color.greeny : Color.redy)
                        .opacity(stat.percentagechange == nil ? 0 : 1)
                    Text(stat.percentagechange?.asPercentString() ?? "")
                        .font(.caption)
                        .bold()
                }
            })
    }
}

#Preview {
    StatisticView(stat: dev().state3)
}
