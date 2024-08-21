//
//  ShowTutorialView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/08/21.
//

import SwiftUI

struct ShowTutorialView: View {
    @State var views = [
        TutorialView(imageName: "gakkari_tameiki_man", text: "First"),
        TutorialView(imageName: "hirameki_man", text: "Second"),
        TutorialView(imageName: "yaruki_moeru_man", text: "Third"),
        TutorialView(imageName: "pose_galpeace_schoolgirl", text: "Fourth"),
    ]
    
    var body: some View {
            PageView(views)
                .background(Color.gray)
                .edgesIgnoringSafeArea(.all)
        }
    }

#Preview {
    ShowTutorialView()
}
