//
//  FinishView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/16.
//

import SwiftUI
import DeviceActivity
import ScreenTime
import FamilyControls

// 認可状態ステータス
enum AuthorizationStatus: String {
    case authorized, unauthorized
}

struct FinishView: View {
    @State private var showAlert = false
    @State private var activitySummary: String = "No data yet"
    
    var body: some View {
        VStack {
            Text(activitySummary)
            Button("完了画面") {
                Task { await checkAndHandleAuthorizationStatus() }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("“ShieldApp”がスクリーンタイムへのアクセスを求めています"),
                    message: Text("“ShieldApp”でスクリーンタイムにアクセスできるようにすると、“ShieldApp”であなたのアクティビティデータを表示したり、コンテンツを制限したり、アプリやWebサイトの使用を制限することが許可される可能性があります。"),
                    primaryButton: .default(Text("続ける"), action: {
                        Task {
                            await authorize()
                        }
                    }),
                    secondaryButton: .cancel(Text("許可しない"))
                )
            }
        }
        .onAppear {
            Task { await checkAndHandleAuthorizationStatus() }
        }
    }

    /// 認可状態チェックの関数
    func checkAndHandleAuthorizationStatus() async {
        let status = AuthorizationCenter.shared.authorizationStatus
        if status != .approved && !UserDefaults.standard.bool(forKey: "isAuthorized") {
            showAlert = true
        } else {
            print("承認済み")
            UserDefaults.standard.set(true, forKey: "isAuthorized")
        }
    }

    func authorize() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            UserDefaults.standard.set(true, forKey: "isAuthorized")
            showAlert = false
        } catch {
            print("エラーが発生しました: \(error.localizedDescription)")
        }
    }
}
