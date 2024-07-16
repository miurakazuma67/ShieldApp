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
                showAlert = true
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("“ShieldApp”がスクリーンタイムへのアクセスを求めています"),
                    message: Text("“ShieldApp”でスクリーンタイムにアクセスできるようにすると、“ShieldApp”であなたのアクティビティデータを表示したり、コンテンツを制限したり、アプリやWebサイトの使用を制限することが許可される可能性があります。"),
                    primaryButton: .default(Text("続ける"), action: {
                        requestScreenTimeAuthorization()
                    }),
                    secondaryButton: .cancel(Text("許可しない"))
                )
            }
        }
    }
    
//    private func requestScreenTimeAuthorization() {
//        let center = DeviceActivityCenter()
//        let schedule = DeviceActivitySchedule(
//            intervalStart: DateComponents(hour: 0, minute: 0),
//            intervalEnd: DateComponents(hour: 23, minute: 59),
//            repeats: true
//        )
//        
//        do {
//            try center.startMonitoring(.init(rawValue: "customActivityName"), during: schedule)
//            print("Monitoring started successfully.")
//        } catch {
//            activitySummary = "Failed to start monitoring: \(error.localizedDescription)"
//        }
//    }
    
    private func requestScreenTimeAuthorization() {
        // Request authorization for Family Controls
        AuthorizationCenter.shared.requestAuthorization { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    if let url = URL(string: "App-Prefs:root=SCREEN_TIME") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            case .failure(let error):
                activitySummary = "Authorization failed: \(error.localizedDescription)"
            }
        }
    
//    private func processActivityData(_ data: DeviceActivityResults<DeviceActivityEvent>) {
//        // Process and summarize the activity data
//        var summary = "Screen Time Data:\n"
//        for (eventName, activity) in data.activities {
//            summary += "Event: \(eventName), Duration: \(activity.totalDuration)\n"
//        }
//        activitySummary = summary
    }
}

struct FinishView_Previews: PreviewProvider {
    static var previews: some View {
        FinishView()
    }
}
