//
//  StudyTimeViewModel.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/10/05.
//

//import SwiftUI
//import Charts
//import SwiftData
//
//class StudyTimeViewModel: ObservableObject {
//    @Query(sort: \StudyRecord.date, order: .reverse) private var studyRecords: [StudyRecord] // データ型を定義
//    @Published var weeklyData: [(date: String, count: Double, isToday: Bool, isSelected: Bool)] = []
//    @Environment(\.modelContext) private var modelContext // SwiftDataコンテキスト
//    @Published var selectedStudyTime: (hours: Int, minutes: Int)? = nil
//
//    let totalStudyCount: Int = 12112 // TODO: fix 総学習時間
//    let todayStudyCount: Int = 12 // TODO: fix 今日
//
//    // 一週間分の日付を取得する関数
//    func getLastWeekDates(from date: Date) -> [String] {
//        var dates: [String] = []
//        let calendar = Calendar.current
//
//        // 今日を含む過去6日間分の日付を取得（計7日間）
//        for i in 0..<7 {
//            if let pastDate = calendar.date(byAdding: .day, value: -i, to: date) {
//                let formattedDate = DateFormatter.customFormatter.string(from: pastDate)
//                dates.append(formattedDate)
//            }
//        }
//        return dates.reversed() // 昇順に表示するために逆順に
//    }
//
//    init() {
//        print("🐈studyRecords: \(studyRecords)") // データ確認
//        calculateWeeklyStudyTime() // 初期化時に計算
//    }
//
//    // 1週間の勉強時間を日ごとに合計
//    private func calculateWeeklyStudyTime() {
//        let calendar = Calendar.current // calender初期化
//        let today = calendar.startOfDay(for: Date()) // 今日を取得
//
//        // 過去7日間の日付ごとの合計時間を保存する辞書
//        var dailyStudyTime: [String: Double] = [:]
//
//        // 今日から過去6日分のデータを取得 ⭕️
//        for i in 0..<7 {
//            if let targetDate = calendar.date(byAdding: .day, value: -i, to: today) {
//                let formattedDate = DateFormatter.customFormatter.string(from: targetDate)
//                dailyStudyTime[formattedDate] = 0 // 初期化
//            }
//        }
//
//        // レコードを日付ごとに集計 ❌
//        for record in studyRecords {
//            let recordDate = DateFormatter.customFormatter.string(from: record.date)
//            let totalHours = Double(record.studyHours) + Double(record.studyMinutes) / 60.0
//            print("🐈totalHours: \(totalHours)")
//            dailyStudyTime[recordDate, default: 0] += totalHours
//        }
//
//        // weeklyDataに格納し、グラフに使用できる形にする ❌
//        self.weeklyData = dailyStudyTime.sorted(by: { $0.key < $1.key }).map { (date, count) in
//            let isToday = date == DateFormatter.customFormatter.string(from: today)
//            print("🐈weeklyData: \(self.weeklyData)")
//            return (date: date, count: count, isToday: isToday, isSelected: false)
//        }
//    }
//
//    // 平均値の計算
//    var averageValue: Double {
//        let total = weeklyData.reduce(0) { $0 + $1.count }
//        return total / Double(weeklyData.count)
//    }
//
//    // 棒グラフをタップした際の処理
//    func selectBar(at index: Int) {
//        for i in 0..<weeklyData.count {
//            weeklyData[i].isSelected = (i == index) // 選択状態の更新
//        }
//        let selectedCount = weeklyData[index].count
//        let hours = Int(selectedCount)
//        let minutes = Int((selectedCount - Double(hours)) * 60)
//        selectedStudyTime = (hours: hours, minutes: minutes)
//    }
//}
//
//// カスタムDateFormatterを用意
//extension DateFormatter {
//    static let customFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/dd" // "10/31" のようなフォーマット
//        return formatter
//    }()
//}
