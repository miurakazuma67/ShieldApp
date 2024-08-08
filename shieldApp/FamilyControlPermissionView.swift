//
//  FamilyControlPermissionView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/16.
//

import SwiftUI

struct FamilyControlPermissionView: View {
    @State private var showAlert = false

    var body: some View {
        VStack {
            Text("Family Controlを使用するには許可が必要です。")
                .padding()
            Button(action: {
                showAlert = true
            }) {
                Text("許可を求める")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("使用許可のリクエスト"),
                message: Text("Family Controlを使用するために許可が必要です。設定画面に移動して許可を与えてください。"),
                primaryButton: .default(Text("設定画面に移動"), action: {
                    // 設定画面に移動するアクションをここに追加
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }),
                secondaryButton: .cancel(Text("キャンセル"))
            )
        }
    }
}
