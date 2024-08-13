//
//  ThemeColorButton.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/08/12.
//

import SwiftUI

// geometryReaderも渡せるようにしたい
struct ThemeColorButton: View {
    var title: String
    var action: () -> Void // ボタンのアクションをクロージャとして受け取る

    var body: some View {
        Button(action: {
            action() // 渡されたアクションを実行
        }) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity) // ボタンの幅を最大に設定
                .background(
                    LinearGradient(
                        gradient: Gradient(colors:
                                           [Color(hex: "#1CD8D2"),
                                           Color(hex: "#93EDC7")]), // 渡されたグラデーションの色を使用
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20) // 角丸の設定
        }
        .padding()
    }
}

