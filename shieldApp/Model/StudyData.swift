//
//  STudyData.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/09/11.
//
// not use

import Foundation
import SwiftUI

// グラフで使うデータ
struct StudyData: Identifiable {
    var id = UUID() // データを一意に識別するためのID
    var date: Date // 日付
    var studyTime: Double // 学習時間
    var category: String // 教材のカテゴリ
    var color: Color // Colorプロパティを追加
}

// 管理方法
// dateごとに合計の学習時間を計算し、グラフに描画する
// categoryごとに棒グラフの色を変更する → ok
