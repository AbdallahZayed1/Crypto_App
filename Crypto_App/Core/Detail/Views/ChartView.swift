//
//  ChartView.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 11/08/2024.
//

import SwiftUI

struct ChartView: View {
@State private var percentage : CGFloat = 0
   private let data : [Double]
   private let minY : Double
   private let maxY : Double
   private let lineColor : Color
   private let startingDate : Date
   private let endingDate : Date

    
    init(coin : Coin) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        let priceChange = (data.last ?? 0) - (data.first ?? 0 )
        lineColor = priceChange > 0 ? Color.greeny : Color.redy
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60)
    }
    var body: some View {
        VStack{
            chartView
                .frame(height: 200)
                .background(chartBackground )
                .overlay(alignment: .leading) {chartYaxis}
            shartDataLabel
        }
        .font(.caption)
        .foregroundStyle(.secondaryText)
        .onAppear(perform: {
            Task{
                try await Task.sleep(for: .seconds(0.2))
                withAnimation(.linear(duration: 2)) {
                    percentage = 1.0
                }
            }
        })
         
    }
}
#Preview {
    ChartView(coin: dev().coin)
}

extension ChartView {
     
    private var chartView : some View {
        GeometryReader { geometry in
            Path { path in for index in data.indices {
                let xPosition =
                geometry.size.width / CGFloat(data.count)  * CGFloat(index + 1)
                let yAxis = maxY - minY
                let yPosition = (1 - (data[index] - minY ) / yAxis) * geometry.size.height
                if index == 0 {
                    path.move(to: CGPoint(x: xPosition, y: yPosition))
                }
                path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0 , to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2 , lineCap: .round , lineJoin: .round))
            .shadow(color: lineColor, radius: 10 , x : 0.0 , y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10 , x : 0.0 , y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10 , x : 0.0 , y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10 , x : 0.0 , y: 40)
            
        }
    }
    private var chartBackground : some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }

    }
    private var chartYaxis : some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            let mean = (maxY + minY) / 2
            Text(mean.formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
        .padding(.horizontal , 4)
 
    }
    private var shartDataLabel : some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
        .padding(.horizontal , 4)
    }
}
