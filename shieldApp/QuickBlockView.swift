//
//  BlockMainView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/12.
//
// 一番最初に表示したいView

import SwiftUI

struct QuickBlockView: View {
    @State private var time: Int = 30
    @State private var repeatEnabled: Bool = false
    @State private var totalHours: CGFloat = 30
    @State private var completedHours: CGFloat = 10

    var body: some View {
        VStack(spacing: 20) {
            Text("スマホを封印しよう")
                .font(.title2)
                .padding(.top)

            HStack {
                Image(systemName: "circle.grid.3x3.fill")
                Text("+31 を除く")
                    .font(.subheadline)
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(20)

            Spacer()

            VStack {
                Text("\(time):00")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.green)
            }

            Spacer()

            VStack(alignment: .leading, spacing: 10) {
                Text("7月の集中時間ゴール \(Int(totalHours))時間/月")
                    .font(.subheadline)

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(UIColor.systemGray4))
                            .frame(height: 40)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green.opacity(0.5))
                            .frame(width: proxy.size.width * (completedHours / totalHours), height: 40)
                        
                        Text("\(Int(completedHours))時間0分")
                            .padding(.horizontal)
                    }
                }
                .frame(height: 40)
            }
            .padding()
            .background(Color.pink.opacity(0.2))
            .cornerRadius(20)
            .padding()

            Button(action: {
                // ブロックスターターボタンのアクション
            }) {
                Text("集中する！")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(20)
            }
            .padding()
        }
        .padding()
    }
}

struct QuickBlockView_Previews: PreviewProvider {
    static var previews: some View {
        QuickBlockView()
    }
}
