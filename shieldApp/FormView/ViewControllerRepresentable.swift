//
//  ViewControllerRepresentable.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/20.
//

import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {

  func makeUIViewController(context: Context) -> ViewController {
    // ビューコントローラーオブジェクトを作成し、その初期状態を設定します。
    return ViewController()
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    // SwiftUI からの新しい情報で指定したビューコントローラの状態を更新
  }
}
