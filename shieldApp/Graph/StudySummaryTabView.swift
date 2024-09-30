//
//  StudySummaryView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/09/25.
//
import Foundation
import SwiftUI
import SwiftData
import Charts

struct StudySummaryTabView: View {
    var body: some View {
        TabView {
            WeeklyStudySummaryView()
                .tabItem {
                    Label("週", systemImage: "calendar")
                }
            
            MonthlyStudySummaryView()
                .tabItem {
                    Label("月", systemImage: "calendar.circle")
                }
            
            YearlyStudySummaryView()
                .tabItem {
                    Label("年", systemImage: "calendar.circle.fill")
                }
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
                    Text(totalToday().formatted())
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                
                VStack {
                    Text("今月")
                    Text(String(format: "%.1f", totalThisMonth())) // 小数点1桁まで表示
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                
                VStack {
                    Text("総計")
                    Text(String(format: "%.1f", totalThisYear())) // 小数点1桁まで表示
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
    private func totalToday() -> Double {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let filteredRecords = studyRecords.filter { calendar.isDate($0.date, inSameDayAs: today) }
        let totalMinutes = filteredRecords.reduce(0) { $0 + ($1.studyHours * 60 + $1.studyMinutes) }
        
        return Double(totalMinutes) / 60 // 時間に変換
    }

    // 今月の勉強時間の合計を計算
    private func totalThisMonth() -> Double {
        let calendar = Calendar.current
        let today = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        
        let filteredRecords = studyRecords.filter { $0.date >= startOfMonth && $0.date <= today }
        let totalMinutes = filteredRecords.reduce(0) { $0 + ($1.studyHours * 60 + $1.studyMinutes) }
        
        return Double(totalMinutes) / 60 // 時間に変換
    }

    // 今年の勉強時間の合計を計算
    private func totalThisYear() -> Double {
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
struct MonthlyStudySummaryView: View {
    @Query(sort: \StudyRecord.date, order: .reverse) private var studyRecords: [StudyRecord]

    var body: some View {
        VStack {
            Text("1ヶ月の勉強時間")
                .font(.headline)
                .padding()

            Chart(calculateMonthlyTotal(studyRecords: studyRecords), id: \.date) { record in
                BarMark(
                    x: .value("日付", record.date, unit: .month),
                    y: .value("勉強時間 (時間)", record.totalHours)
                )
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { value in
                    AxisValueLabel(format: .dateTime.month())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let doubleValue = value.as(Double.self) {
                            Text(String(format: "%.1f", doubleValue)) // 小数点1桁まで表示
                        }
                    }
                }
            }
            .frame(height: 300)
            .padding()
        }
        .navigationTitle("勉強時間グラフ (月)")
    }
    private func calculateMonthlyTotal(studyRecords: [StudyRecord]) -> [(date: Date, totalHours: Double)] {
        let calendar = Calendar.current
        let today = Date()
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: today)!

        // 日付ごとに勉強時間を集計
        let filteredRecords = studyRecords.filter { $0.date >= oneMonthAgo && $0.date <= today }
        let groupedRecords = Dictionary(grouping: filteredRecords) { record in
            calendar.startOfDay(for: record.date)
        }

        return (0..<12).compactMap { offset in
            if let date = calendar.date(byAdding: .day, value: -offset, to: today) {
                let totalMinutes = groupedRecords[calendar.startOfDay(for: date)]?.reduce(0) { $0 + ($1.studyHours * 60 + $1.studyMinutes) } ?? 0
                return (date, Double(totalMinutes) / 60)
            }
            return nil
        }
        .sorted { $0.date < $1.date }
    }
}

struct YearlyStudySummaryView: View {
    @Query(sort: \StudyRecord.date, order: .reverse) private var studyRecords: [StudyRecord]

    var body: some View {
        VStack {
            Text("1年の勉強時間")
                .font(.headline)
                .padding()

            Chart(calculateYearlyTotal(studyRecords: studyRecords), id: \.date) { record in
                BarMark(
                    x: .value("Year", record.date, unit: .year),
                    y: .value("勉強時間 (時間)", record.totalHours)
                )
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .year)) { value in
                    AxisValueLabel(format: .dateTime.year())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let doubleValue = value.as(Double.self) {
                            Text(String(format: "%.1f", doubleValue)) // 小数点1桁まで表示
                        }
                    }
                }
            }
            .frame(height: 300)
            .padding()
        }
        .navigationTitle("勉強時間グラフ (年)")
    }

    private func calculateYearlyTotal(studyRecords: [StudyRecord]) -> [(date: Date, totalHours: Double)] {
        let calendar = Calendar.current
        let today = Date()
        let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: today)!

        let filteredRecords = studyRecords.filter { $0.date >= oneYearAgo && $0.date <= today }

        let groupedRecords = Dictionary(grouping: filteredRecords) { record in
            calendar.startOfDay(for: record.date)
        }

        return (0..<12).compactMap { offset in
            if let date = calendar.date(byAdding: .month, value: -offset, to: today) {
                let totalMinutes = groupedRecords[calendar.startOfDay(for: date)]?.reduce(0) { $0 + ($1.studyHours * 60 + $1.studyMinutes) } ?? 0
                return (date, Double(totalMinutes) / 60)
            }
            return nil
        }
        .sorted { $0.date < $1.date }
    }
}

