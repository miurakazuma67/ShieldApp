//
//  RootView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/13.
//
import Foundation
import ManagedSettings
import SwiftUI
import FamilyControls

enum ViewPath: Hashable {
  /// 画面遷移先のパスを定義
  case finish // スクリーンタイムの許可画面
  case content
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
          case .finish:
              FinishView()
          case .content:
              ContentView()
          case .blockTime:
            BlockTimeView()
          case .quickBlock:
            QuickBlockView()
             .environmentObject(model)
          case .form:
            FormWebView()
          case .timer(let totalMinutes):
              TimerView(totalMinutes: totalMinutes) // 仮置き
          }
        }
        .environmentObject(router)
        .environmentObject(model)
        .environmentObject(store)
    }.onAppear {
      // 初期表示する画面を設定
//      router.viewPath.append(.quickBlock)

// TODO: 遷移先を分岐できるようにする
        let status = AuthorizationCenter.shared.authorizationStatus
        print("🐈status: \(status)")
        if status == .approved {
            print("承認済み")
            router.viewPath.append(.quickBlock)
        }
        else {
            router.viewPath.append(.finish)
        }
    }
  }
}

#Preview {
  RootView()
}
