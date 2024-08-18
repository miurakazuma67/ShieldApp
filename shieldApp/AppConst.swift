//
//  AppConst.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/08/17.
//

// staticで定義した、使いまわしたい定数を記載
import Foundation

final class AppConst {
    static let env = try! LoadEnv() // 環境変数を使用する時に使用
}
