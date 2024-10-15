//
//  StudyTimeGraphView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/10/04.
//

import SwiftUI
import Charts

// TODO: State StateObj EnvironmentObjを使用したコードに変更する
// グラフの上側のみ丸くするために使用
struct TopRoundedRectangle: Shape {
    var cornerRadius: CGFloat // 角丸の半径

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // 四角形の上部だけ角丸、下部はそのままにする
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY)) // 左下
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius)) // 左上
        path.addQuadCurve(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY)) // 左上の角丸
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY)) // 上部
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius), control: CGPoint(x: rect.maxX, y: rect.minY)) // 右上の角丸
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // 右下
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // 底辺に戻る
        path.closeSubpath()

        return path
    }
}

struct StudyTimeGraphView: View {
    @StateObject private var viewModel = StudyTimeViewModel()

    var body: some View {
        VStack(spacing: 20) {
            // 上部の「学習数」「今日」「平均」の部分
            HStack(spacing: 40) {
                VStack {
                    Text("総学習時間")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(viewModel.totalStudyCount)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                VStack {
                    Text("今日")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(viewModel.todayStudyCount)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                VStack {
                    Text("平均（過去7日間）")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(String(format: "%.1f", viewModel.averageValue))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal)

            // グラフ部分
            Chart {
                ForEach(Array(viewModel.weeklyData.enumerated()), id: \.element.date) { index, data in
                    BarMark(
                        x: .value("日付", data.date),
                        y: .value("学習時間", data.count)
                    )
                    .foregroundStyle(Color.green)
                    .opacity(data.isToday ? 1.0 : 0.5) // 今日の日付は1.0、それ以外は0.5
                    .clipShape(TopRoundedRectangle(cornerRadius: 5)) // 上側のみ角丸にする
                }

                // 平均値の点線
                RuleMark(y: .value("平均", viewModel.averageValue))
                    .foregroundStyle(Color.orange)
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5])) // 点線を定義
            }
            .frame(height: 200)
            .padding(.horizontal)

            // Y軸に単位 (h) を追加
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let doubleValue = value.as(Double.self) {
                            Text(String(format: "%.0fh", doubleValue)) // h単位を追加
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
    }
}
