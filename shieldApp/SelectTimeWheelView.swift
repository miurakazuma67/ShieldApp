//
//  SelectTimeWheelView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/09/11.
//

import SwiftUI

struct SelectTimeWheelView: View {
    // バインド変数
    @Binding var hour: Int
    @Binding var minute: Int
    @Binding var isOpen: Bool
    // 時・分の選択肢
    let hourList: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
                           13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
    let minuteList: [Int] = Array(0...59)
    
    var body: some View {
        VStack {
            Text("閉じる")
            HStack{
                // 時
                Picker(selection: $hour) {
                    ForEach(0..<Int(hourList.count), id: \.self) { index in
                        Text(String(format: "%2d", hourList[index]) + "時間")
                            .tag(hourList[index])
                    }
                } label: {}
                // 分
                Picker(selection: $minute) {
                    ForEach(0..<Int(minuteList.count), id: \.self) { index in
                        Text(String(format: "%2d", minuteList[index]) + "分")
                            .tag(minuteList[index])
                    }
                } label: {}
            }
            // ホイールスタイル
            .pickerStyle(.wheel)
        }
    }
}
