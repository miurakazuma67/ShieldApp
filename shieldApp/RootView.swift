//
//  RootView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/13.
//

import SwiftUI

/// 画面遷移先を定義
enum ViewPath {
    case blockTime       // グラフ画面
    case quickBlock
}

struct RootView: View {
    @State private var viewPath: [ViewPath] = []
    var body: some View {
        NavigationStack(path: $viewPath) {

        }.onAppear {
            // 初期表示する画面を設定
            viewPath.append(.quickBlock)
        }
        .navigationDestination(for: ViewPath.self) { value in
            switch (value) {
            case .blockTime:
                BlockTimeView()
            case .quickBlock:
                QuickBlockView()
            }
        }
    }
}

#Preview {
    RootView()
}
