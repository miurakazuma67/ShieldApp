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

