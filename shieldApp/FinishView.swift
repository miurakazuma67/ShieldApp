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

struct FinishView: View {
    @State private var showAlert = false
    @State private var activitySummary: String = "No data yet"
    
    var body: some View {
        VStack {
            Text(activitySummary)
            Button("完了画面") {
                Task { await confirmAuthorization() }
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
            Task { await checkAuthorizationStatus() }
        }
    }

    func checkAuthorizationStatus() async {
        let status = AuthorizationCenter.shared.authorizationStatus

        if status == .approved {
            print("承認済み")
            print()
            UserDefaults.standard.set(true, forKey: "isAuthorized")
            return
        } else if !UserDefaults.standard.bool(forKey: "isAuthorized") {
            showAlert = true
        }
    }

    func confirmAuthorization() async {
        let status = AuthorizationCenter.shared.authorizationStatus
        if status == .approved {
            print("承認済み")
        }
        else {
            showAlert = true
        }
    }

    func authorize() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            UserDefaults.standard.set(true, forKey: "isAuthorized")
            showAlert = false
        } catch {
             print("error: 登録ずみです")
        }
    }
}
