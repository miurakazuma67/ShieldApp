//
//  あ.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/26.
//

import SwiftUI

struct IconAndTextView: View {
    let imageName: String
    let text: String
    let spacing: CGFloat

    var body: some View {
        HStack(spacing: spacing) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(.gray)

            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.black)
        }
        .frame(height: 20)
    }
}

//struct IconAndTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        IconAndTextView(imageName: "flag", text: "終了時間", spacing: 8)
//    }
//}
