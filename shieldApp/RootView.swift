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
    case content
    case finish     // スクリーンタイムAPI許可画面
    case blockTime  // 時間制限画面
    case quickBlock  // クイックブロック画面
    case form  // お問い合わせフォーム画面
    case timer(totalMinutes: Int) // timer
}

class NavigationRouter: ObservableObject {
  /// 現在の画面遷移先を保持する配列
  @Published var viewPath: [ViewPath] = []
}

struct RootView: View {
  @StateObject var router = NavigationRouter()
  @StateObject var model = DataModel.shared
  @StateObject var store = ManagedSettingsStore()
  @AppStorage("hasSeenTutorial") private var hasSeenTutorial: Bool = false // チュートリアルを見たかどうか

  var body: some View {
    NavigationStack(path: $router.viewPath) {
      VStack {
          Button(action: {
              router.viewPath.append(.quickBlock) // クイックブロック画面に遷移
          }, label: {
              Text("クイックブロック")
          })
      }  // 空のVStack
        .navigationDestination(for: ViewPath.self) { value in
          switch value {
          case .content:
              ContentView()
          case .blockTime:
            BlockTimeView()
          case .quickBlock:
            QuickBlockView()
             .environmentObject(router)
             .environmentObject(model)
          case .form:
            FormWebView()
          case .timer(let totalMinutes):
              TimerView(totalMinutes: totalMinutes) // 仮置き
                  .navigationBarBackButtonHidden(true)
                  .navigationTitle(String("制限時間: \(totalMinutes)分"))
                  .navigationBarTitleDisplayMode(.inline)
          case .finish:
              FinishView()
          }
        }
        .environmentObject(router)
        .environmentObject(model)
        .environmentObject(store)
    }.onAppear {
        let status = AuthorizationCenter.shared.authorizationStatus
        print("🍣status \(status)")

      // 初期表示する画面を設定
        if UserDefaults.standard.bool(forKey: "isAuthorized") {
            router.viewPath.append(.quickBlock)
        } else {
            router.viewPath.append(.finish)
        }
    }
  }
}

//#Preview {
//  RootView()
//}
