//
//  YearSummeryView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/10/01.
//

import SwiftUI
import Foundation
import Charts
import SwiftData

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
