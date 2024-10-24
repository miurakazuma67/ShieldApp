//
//  StudyTimeGraphView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/10/04.
//

import SwiftUI
import Charts
import SwiftData

// 上側のみ角丸にするためのカスタムシェイプ
struct TopRoundedRectangle: Shape {
    var cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        path.addQuadCurve(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY),
                          control: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius),
                          control: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        return path
    }
}

struct StudyTimeGraphView: View {
    // SwiftDataからのデータ取得を宣言
    @Query(sort: \StudyRecord.date, order: .reverse) private var studyRecords: [StudyRecord]

    // Viewのロジックと状態を保持
    @State private var weeklyData: [(date: String, count: Double, isToday: Bool)] = []
    @State private var totalStudyCount: Double = 0
    @State private var todayStudyCount: Double = 0

    var body: some View {
        VStack(spacing: 20) {
            // 上部情報表示
            studySummaryView

            // グラフ描画部分
            chartView

            Spacer()
        }
        .padding()
        .onAppear {
            calculateWeeklyStudyTime() // Viewが表示された時にデータを集計
        }
    }

    // 総学習時間、今日の学習時間、平均学習時間の表示
    private var studySummaryView: some View {
        HStack(spacing: 0) {
            summaryColumn(title: "総学習時間", value: "\(Int(totalStudyCount)) 時間")
            summaryColumn(title: "今日", value: "\(Int(todayStudyCount)) 時間")
            summaryColumn(title: "平均（過去7日間）", value: String(format: "%.1f", averageValue))
        }
        .padding(.horizontal)
    }

    // グラフ部分の描画
    private var chartView: some View {
        Chart {
            ForEach(weeklyData, id: \.date) { data in
                BarMark(
                    x: .value("日付", data.date),
                    y: .value("学習時間", data.count)
                )
                .foregroundStyle(data.isToday ? Color.green : Color.green.opacity(0.5))
                .clipShape(TopRoundedRectangle(cornerRadius: 5))
            }

            RuleMark(y: .value("平均", averageValue))
                .foregroundStyle(Color.green)
                .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))

            // Annotationを使って平均値のラベルを右側に表示
                .annotation(position: .topTrailing) {
                    Text("平均 \(String(format: "%.1f", averageValue))h")
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(.leading, 4)  // ラベルと線の間に余白を追加
                }
        }
        .frame(height: 200)
        .padding(.horizontal)
        .chartYAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let doubleValue = value.as(Double.self) {
                        Text(String(format: "%.1fh", doubleValue))
                    }
                }
            }
        }
    }

    // 日付と学習時間を表示する列のレイアウト
    private func summaryColumn(title: String, value: String) -> some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 80)
                .background(Color.green)
            Text(value)
                .font(.system(size: 12, weight: .bold))
                .fontWeight(.bold)
                .padding(5)
        }.overlay(
                Rectangle()
                    .stroke(Color.green, lineWidth: 1)
            )
    }

    // 学習データを集計するメソッド
    private func calculateWeeklyStudyTime() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // 過去7日分の初期化
        var dailyStudyTime: [String: Double] = (0..<7).reduce(into: [:]) { result, dayOffset in
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                let formattedDate = DateFormatter.customFormatter.string(from: date)
                result[formattedDate] = 0
            }
        }

        // レコードを集計
        for record in studyRecords {
            let recordDate = DateFormatter.customFormatter.string(from: record.date)
            let totalHours = Double(record.studyHours) + Double(record.studyMinutes) / 60.0
            dailyStudyTime[recordDate, default: 0] += totalHours
        }

        // 集計結果をViewの状態に反映
        self.weeklyData = dailyStudyTime.sorted(by: { $0.key < $1.key }).map { (date, count) in
            let isToday = date == DateFormatter.customFormatter.string(from: today)
            return (date: date, count: count, isToday: isToday)
        }

        // 総学習時間と今日の学習時間を計算
        totalStudyCount = weeklyData.reduce(0) { $0 + $1.count }
        todayStudyCount = weeklyData.first(where: { $0.isToday })?.count ?? 0
    }

    // 過去7日間の平均学習時間
    private var averageValue: Double {
        let total = weeklyData.reduce(0) { $0 + $1.count }
        return total / Double(weeklyData.count)
    }
}

// カスタムフォーマッタ
extension DateFormatter {
    static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()
}
