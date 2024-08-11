//
//  Color+.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/08/11.
//

import SwiftUI

/// カラーコード指定を可能にするためのExtension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }

/// テーマカラー
    static var themeGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#1CD8D2"),
                Color(hex: "#93EDC7")
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
