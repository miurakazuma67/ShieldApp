//
//  a.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/10/01.
//

import SwiftUI
import Foundation
import Charts
import SwiftData

// 日ごと、週ごと、月ごとの合計時間を表示を切り替えるenum
enum SummaryType {
    case daily, weekly, monthly, yearly
    
    var title: String {
        switch self {
        case .daily: return "今日"
        case .weekly: return "週"
        case .monthly: return "月"
        case .yearly: return "年"
        }
    }
    
    // studyRecordsを渡して、それに基づいて合計時間を計算
    func calculateTotalValue(for studyRecords: [StudyRecord]) -> Double {
        switch self {
        case .daily:
            return calculateTotalToday(studyRecords: studyRecords)
        case .weekly:
            return calculateTotalThisWeek(studyRecords: studyRecords)
        case .monthly:
            return calculateTotalThisMonth(studyRecords: studyRecords)
        case .yearly:
            return calculateTotalThisYear(studyRecords: studyRecords)
        }
    }
}

struct WeeklyStudySummaryView: View {
    @Query(sort: \StudyRecord.date, order: .reverse) private var studyRecords: [StudyRecord]
    
    var body: some View {
        VStack(spacing: 20) {
            // 上部の「今日」「今月」「総計」部分
            HStack {
                VStack {
                    Text("今日")
                    Text(calculateTotalToday(studyRecords: studyRecords).formatted())
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                
                VStack {
                    Text("今月")
                    Text(String(format: "%.1f", calculateTotalThisMonth(studyRecords: studyRecords))) // 小数点1桁まで表示
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                
                VStack {
                    Text("総計")
                    Text(String(format: "%.1f", calculateTotalThisYear(studyRecords: studyRecords))) // 小数点1桁まで表示
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 60)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // グラフ表示部分
            Chart(calculateWeeklyTotal(studyRecords: studyRecords), id: \.date) { record in
                BarMark(
                    x: .value("日付", record.date, unit: .day),
                    y: .value("勉強時間 (時間)", record.totalHours)
                )
                .foregroundStyle(Color.blue) // 統一されたグラフの色
            }
            .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.5) // 縦: 画面の1/2、横: 3/4
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisValueLabel(format: .dateTime.day())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let doubleValue = value.as(Double.self) {
                            Text(String(format: "%.1f", doubleValue)) // 軸の値をフォーマットして表示
                        }
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("学習時間（週）")
    }

    // 今日の勉強時間の合計を計算
    private func calculateTotalToday(studyRecords: [StudyRecord]) -> Double {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let filteredRecords = studyRecords.filter { calendar.isDate($0.date, inSameDayAs: today) }
        let totalMinutes = filteredRecords.reduce(0) { $0 + ($1.studyHours * 60 + $1.studyMinutes) }
        
        return Double(totalMinutes) / 60 // 時間に変換
    }

    // 今月の勉強時間の合計を計算
    private func calculateTotalThisMonth(studyRecords: [StudyRecord]) -> Double {
        let calendar = Calendar.current
        let today = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        
        let filteredRecords = studyRecords.filter { $0.date >= startOfMonth && $0.date <= today }
        let totalMinutes = filteredRecords.reduce(0) { $0 + ($1.studyHours * 60 + $1.studyMinutes) }
        
        return Double(totalMinutes) / 60 // 時間に変換
    }

    // 今年の勉強時間の合計を計算
    private func calculateTotalThisYear(studyRecords: [StudyRecord]) -> Double {
        let calendar = Calendar.current
        let today = Date()
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: today))!
        
        let filteredRecords = studyRecords.filter { $0.date >= startOfYear && $0.date <= today }
        let totalMinutes = filteredRecords.reduce(0) { $0 + ($1.studyHours * 60 + $1.studyMinutes) }
        
        return Double(totalMinutes) / 60 // 時間に変換
    }

    // 1週間分のデータを日付ごとに集計する関数
    private func calculateWeeklyTotal(studyRecords: [StudyRecord]) -> [(date: Date, totalHours: Double)] {
        let calendar = Calendar.current
        let today = Date()
        let oneWeekAgo = calendar.date(byAdding: .day, value: -6, to: today)!
        
        let filteredRecords = studyRecords.filter { $0.date >= oneWeekAgo && $0.date <= today }
        let groupedRecords = Dictionary(grouping: filteredRecords) { record in
            calendar.startOfDay(for: record.date)
        }
        
        return (0..<7).compactMap { offset in
            if let date = calendar.date(byAdding: .day, value: -offset, to: today) {
                let totalMinutes = groupedRecords[calendar.startOfDay(for: date)]?.reduce(0) { $0 + ($1.studyHours * 60 + $1.studyMinutes) } ?? 0
                return (date, Double(totalMinutes) / 60)
            }
            return nil
        }
        .sorted { $0.date < $1.date }
    }
}
