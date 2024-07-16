//
//  RootView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/13.
//
import Foundation
import SwiftUI

enum ViewPath: Hashable {
    /// 画面遷移先のパスを定義
    /// 画面遷移先を定義
    case blockTime       // グラフ画面
    case quickBlock
}

class NavigationRouter: ObservableObject {
    /// 現在の画面遷移先を保持する配列
    @Published var viewPath: [ViewPath] = []
}

struct RootView: View {
    @StateObject var router = NavigationRouter()
    var body: some View {
        NavigationStack(path: $router.viewPath) {
            VStack{} // 空のVStack
            .navigationDestination(for: ViewPath.self) { value in
                switch (value) {
                case .blockTime:
                    BlockTimeView()
                case .quickBlock:
                    QuickBlockView()
                }
            }.environmentObject(router)
        }.onAppear {
            // 初期表示する画面を設定
            router.viewPath.append(.quickBlock)
        }
    }
}

#Preview {
    RootView()
}
