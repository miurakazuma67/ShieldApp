//
//  TutorialView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/08/21.
//

import SwiftUI

struct TutorialView: View {
    let imageName: String
    let text: String
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                Text(text)
                HStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    Spacer()
                }
                Spacer()
            }
            .padding()
            .background(Color.gray)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
