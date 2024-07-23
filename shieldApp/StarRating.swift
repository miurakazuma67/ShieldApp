//
//  StarRating.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/23.
//
import SwiftUI

// 使用するViewでStateを定義する必要がある
struct StarRating: View {
    @Binding var rating: Int    // バインドを受け取る

    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { value in
                Image(systemName: "star")
                    .symbolVariant(value <= rating ? .fill : .none)
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        if value != rating {
                            rating = value
                        } else {
                            rating = 0
                        }
                    }
            }
        }
    }
}
