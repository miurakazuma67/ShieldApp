//
//  shieldAppApp.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/07.
//
import SwiftUI
import GoogleMobileAds
import SwiftData

// AppDelegateクラスを定義
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Google Mobile Adsの初期化
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}

@main
struct shieldAppApp: App {
    // AppDelegateの設定
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            // ContentViewを表示し、SwiftDataのModelContainerを設定
            ContentView()
                .modelContainer(for: StudyRecord.self) // StudyRecordモデルのコンテナを設定
        }
    }
}
