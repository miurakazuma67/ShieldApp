//
//  Date+.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/10/01.
//
import Foundation

extension Date {
    init(year: Int, month: Int, day: Int) {
        let calendar = Calendar(identifier: .gregorian)

        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        self = calendar.date(from: components)!
    }
}

// .date表記を日本語表記の日付フォーマットに変換するメソッド
func dateToJapaneseString(_ date: Date) -> String {
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ja_JP")
    
    if calendar.isDateInToday(date) {
        return "今日"
    } else if calendar.isDateInYesterday(date) {
        return "昨日"
    } else {
        formatter.dateFormat = "yyyy年MM月dd日（EEEE）" // 日付と曜日を表示
        return formatter.string(from: date)
    }
}

