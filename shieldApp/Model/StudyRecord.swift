//
//  StudyRecord.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/09/25.
//

import SwiftData
import Foundation

// SwiftDataのエンティティモデル
@Model
class StudyRecord { // struct ではなく class に変更
    var date: Date // 日付
    var studyHours: Int // 勉強時間(h）
    var studyMinutes: Int // 勉強時間(m）
    var memo: String? // メモ
    var material: String? // 教材

    // イニシャライザ
    init(date: Date, studyHours: Int, studyMinutes: Int, memo: String? = nil, material: String? = nil) {
        self.date = date
        self.studyHours = studyHours
        self.studyMinutes = studyMinutes
        self.memo = memo
        self.material = material
    }
}
