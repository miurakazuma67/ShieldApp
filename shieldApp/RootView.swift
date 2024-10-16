//
//  RootView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/13.
//
import Foundation
import ManagedSettings
import DeviceActivity
import SwiftUI
import FamilyControls

enum ViewPath: Hashable {
    /// 画面遷移先のパスを定義
    case main       // メイン画面となるTabView
    case content
    case finish     // スクリーンタイムAPI許可画面
    case blockTime  // 時間制限画面
    case quickBlock  // クイックブロック画面
    case form        // お問い合わせフォーム画面
    case timer(totalMinutes: Int) // timer
    case save(studyTime: Int) // 記録画面
    case recordList // 学習記録一覧
    case graph // グラフ画面
}

class NavigationRouter: ObservableObject {
  /// 現在の画面遷移先を保持する配列
  @Published var viewPath: [ViewPath] = []
}

struct RootView: View {
  @StateObject var router = NavigationRouter()
  @StateObject var model = DataModel.shared
  @StateObject var store = ManagedSettingsStore()
  @AppStorage("hasSeenTutorial") private var hasSeenTutorial: Bool = false
    // チュートリアルを見たかどうか

  var body: some View {
    NavigationStack(path: $router.viewPath) {
      VStack {
          Button(action: {
              router.viewPath.append(.quickBlock) // クイックブロック画面に遷移
          }, label: {
              Text("クイックブロック")
          })
      } // VStack
        .navigationDestination(for: ViewPath.self) { value in
          switch value {
          case .main:
              MainTabView()
                  .navigationBarBackButtonHidden(true)
                  .navigationBarTitleDisplayMode(.inline)
                  .environmentObject(router)
                  .environmentObject(model)
          case .content:
              ContentView()
          case .blockTime:
            BlockTimeView()
          case .quickBlock:
            QuickBlockView()
             .navigationTitle("クイックブロック")
             .navigationBarTitleDisplayMode(.inline)
             .environmentObject(router)
             .environmentObject(model)
          case .form:
            FormWebView()
          case .timer(let totalMinutes):
              TimerView(totalMinutes: totalMinutes) // 仮置き
                  .navigationBarTitleDisplayMode(.inline)
                  .navigationTitle("ブロック中")
                  .navigationBarTitleDisplayMode(.inline)
                  .environmentObject(router)
          case .finish:
              FinishView()
          case .save(let studyTime):
              RecordEntryView(studyTime: studyTime)
                  .navigationBarBackButtonHidden(true)
                  .environmentObject(router)
//                  .navigationTitle("学習記録")
          case .recordList:
              StudyRecordListView()
          case .graph:
              StudyTimeGraphView()
                  .navigationTitle("学習時間グラフ")
                  .navigationBarTitleDisplayMode(.inline)
          }
        } // NavigationStack
        .environmentObject(router)
        .environmentObject(model)
        .environmentObject(store)
    }.onAppear {
        checkAuthorizedStatus()
    }
  }
    func checkAuthorizedStatus() {
        let status = AuthorizationCenter.shared.authorizationStatus // 利用許可を確認
        print("🍣status \(status)")
        print("viewPath before: \(router.viewPath)")

      // 初期表示する画面を設定
        if UserDefaults.standard.bool(forKey: "isAuthorized") {
            router.viewPath.append(.main)  // メイン画面に遷移
        } else {
            router.viewPath.append(.finish) 
        }
        print("viewPath after: \(router.viewPath)")
    }
}
