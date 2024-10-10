//
//  MainTimeLineView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/10/10.
//
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // 受信タブ
            StudyRecordListView()
                .tabItem {
                    Label("学習記録", systemImage: "timer")
                }

            // TODO: 送信タブ 最初はこのViewを表示するようにしたい
            QuickBlockView()
                .tabItem {
                    Label("クイックブロック", systemImage: "shield.slash")
                }
            
            StudyTimeGraphView()
                .tabItem {
                    Label("グラフ", systemImage: "chart.bar.xaxis")
                }
            // TODO: 設定画面を追加する必要
        }
    }
}
