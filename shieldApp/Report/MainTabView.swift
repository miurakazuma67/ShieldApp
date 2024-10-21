//
//  MainTimeLineView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/10/10.
//
import SwiftUI

// 以下画面を表示
// 勉強記録画面、
struct MainTabView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var model: DataModel

    var body: some View {
        TabView {
            StudyRecordListView()
                .tabItem {
                    Label("学習記録", systemImage: "timer")
                }

            QuickBlockView()
                .environmentObject(router)
                .environmentObject(model)
                .tabItem {
                    Label("クイックブロック", systemImage: "shield.slash")
                }

            StudyTimeGraphView()
                .environmentObject(router)
                .environmentObject(model)
                .tabItem {
                    Label("グラフ", systemImage: "chart.bar.xaxis")
                }
            // TODO: 設定画面を追加する必要
        }
//        .onAppear{print("🐈router.selectedTab: \(router.selectedTab)")}
    }
}
