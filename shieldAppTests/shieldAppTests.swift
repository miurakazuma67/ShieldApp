//
//  shieldAppTests.swift
//  shieldAppTests
//
//  Created by 三浦一真 on 2024/07/07.
//

import XCTest
@testable import shieldApp

final class shieldAppTests: XCTestCase {
    func testAngleForDate() {
        let calendar = Calendar.current
        let date1 = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let date2 = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        let date3 = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
        
        let picker = CircularTimePicker(blockStart: .constant(date1), blockEnd: .constant(date2))
        
        XCTAssertEqual(picker.angle(for: date1), 0.0)
        XCTAssertEqual(picker.angle(for: date2), 0.5)
        XCTAssertEqual(picker.angle(for: date3), 0.75)
    }
    
    func testPositionForHour() {
        let size = CGSize(width: 200, height: 200)
        let picker = CircularTimePicker(blockStart: .constant(Date()), blockEnd: .constant(Date()))
        
        let pos0 = picker.position(for: 0, in: size)
        let pos6 = picker.position(for: 6, in: size)
        let pos12 = picker.position(for: 12, in: size)
        let pos18 = picker.position(for: 18, in: size)
        
        XCTAssertEqual(pos0.x, size.width / 2, accuracy: 0.1)
        XCTAssertEqual(pos0.y, size.height / 2 - size.height / 2 + 20, accuracy: 0.1)
        XCTAssertEqual(pos6.x, size.width - 20, accuracy: 0.1)
        XCTAssertEqual(pos6.y, size.height / 2, accuracy: 0.1)
        XCTAssertEqual(pos12.x, size.width / 2, accuracy: 0.1)
        XCTAssertEqual(pos12.y, size.height - 20, accuracy: 0.1)
        XCTAssertEqual(pos18.x, 20, accuracy: 0.1)
        XCTAssertEqual(pos18.y, size.height / 2, accuracy: 0.1)
    }
    
    func testDrawingRange() {
        let calendar = Calendar.current
        let date1 = calendar.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!
        let date2 = calendar.date(bySettingHour: 1, minute: 0, second: 0, of: Date())!
        
        let picker = CircularTimePicker(blockStart: .constant(date1), blockEnd: .constant(date2))
        
        XCTAssertNotNil(picker.body)
    }
}
