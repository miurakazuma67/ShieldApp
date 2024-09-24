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
}

// Custom Color Set
extension Color {
  static let circleFillColor = Color("circleFillColor")  // timer circle メインカラー
  static let lightThemeColor = Color("lightThemeColor")  // timer circle サブカラー
  static let circleShadowColor = Color("circleShadowColor")
  static let aaaRed = Color("primaryRed") // mainRed
}
