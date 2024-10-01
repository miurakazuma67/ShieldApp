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
