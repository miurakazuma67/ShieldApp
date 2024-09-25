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
    var date: Date
    var studyHours: Int
    var studyMinutes: Int
    var memo: String?
    var material: String?

    // イニシャライザ
    init(date: Date, studyHours: Int, studyMinutes: Int, memo: String? = nil, material: String? = nil) {
        self.date = date
        self.studyHours = studyHours
        self.studyMinutes = studyMinutes
        self.memo = memo
        self.material = material
    }
}
