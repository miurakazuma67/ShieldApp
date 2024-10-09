//
//  StudyTimeViewModel.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/10/05.
//

import SwiftUI
import Charts

class StudyTimeViewModel: ObservableObject {
    @Published var weeklyData: [(date: String, count: Double, isToday: Bool, isSelected: Bool)] = []
    @Published var selectedStudyTime: (hours: Int, minutes: Int)? = nil

    let totalStudyCount: Int = 12112
    let todayStudyCount: Int = 12

    // 一週間分の日付を取得する関数
    func getLastWeekDates(from date: Date) -> [String] {
        var dates: [String] = []
        let calendar = Calendar.current
        
        // 今日を含む過去6日間分の日付を取得（計7日間）
        for i in 0..<7 {
            if let pastDate = calendar.date(byAdding: .day, value: -i, to: date) {
                let formattedDate = DateFormatter.customFormatter.string(from: pastDate)
                dates.append(formattedDate)
            }
        }
        return dates.reversed() // 昇順に表示するために逆順に
    }

    init() {
        let todayDate = DateFormatter.customFormatter.string(from: Date()) // 今日の日付取得
        
        // 今日を基準に一週間分の日付を取得
        let weekDates = getLastWeekDates(from: Date()) // もう少し簡単にできそう
        let sampleData: [(String, Double)] = [
            ("10/25", 7), ("10/26", 8), ("10/27", 6), ("10/28", 10),
            ("10/29", 9), ("10/30", 10), ("10/31", 7)
        ]

        self.weeklyData = sampleData.map { (date, count) in
            let isToday = (date == todayDate)
            return (date: date, count: count, isToday: isToday, isSelected: false)
        }
    }

    // 平均値の計算
    var averageValue: Double {
        let total = weeklyData.reduce(0) { $0 + $1.count }
        return total / Double(weeklyData.count)
    }

    // 棒グラフをタップした際の処理
    func selectBar(at index: Int) {
        for i in 0..<weeklyData.count {
            weeklyData[i].isSelected = (i == index) // 選択状態の更新
        }
        let selectedCount = weeklyData[index].count
        let hours = Int(selectedCount)
        let minutes = Int((selectedCount - Double(hours)) * 60)
        selectedStudyTime = (hours: hours, minutes: minutes)
    }
}

// カスタムDateFormatterを用意
extension DateFormatter {
    static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd" // "10/31" のようなフォーマット
        return formatter
    }()
}

