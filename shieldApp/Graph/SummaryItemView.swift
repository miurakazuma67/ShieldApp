//
//  SummaryItemView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/10/01.
//

// 今日、今月、今年度の合計時間をそれぞれ表示するView
import SwiftUI

struct SummaryItemView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
            Text(value)
                .font(.headline)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
    }
}
