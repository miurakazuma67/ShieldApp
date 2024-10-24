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
        // アプリ起動時に前回の終了時刻を取得
        if let lastExitTime = UserDefaults.standard.object(forKey: "lastExitTime") as? Date {
            let currentTime = Date()  // 現在の時刻
            let elapsedTime = currentTime.timeIntervalSince(lastExitTime)  // 経過時間（秒）
            
            print("前回の終了から経過した時間: \(elapsedTime) 秒")

            // 経過時間が有効であればTimerViewに渡して処理
//            if elapsedTime > 0 {
//                // 必要に応じて画面遷移やViewModelに経過時間を渡す処理
//                router.viewPath
////                TimerViewModel.shared.resumeTimer(after: elapsedTime)　これはTimerViewで実施
//            }
        }
        // Google Mobile Adsの初期化
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("アプリが終了します。状態を保存します。") // ここから時間をカウントし、今保持しているタイマーの時間と合わせ、アプリ起動時に渡す
        
        // アプリ起動時　"lastExitTime"が存在していたら計算をし、Timer画面に遷移する！
        // 必要な状態を保存する処理
        UserDefaults.standard.set(Date(), forKey: "lastExitTime")
    }
}

@main
struct shieldAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate  // AppDelegateの設定
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel = TimerViewModel()  // TimerVMのインスタンス

    var body: some Scene {
        WindowGroup {
            // ContentViewを表示し、SwiftDataのModelContainerを設定
            ContentView()
                .modelContainer(for: StudyRecord.self) // StudyRecordモデルのコンテナを設定
        }.onChange(of:scenePhase) {
            if scenePhase == .background{
                print(scenePhase)
            } else if scenePhase == .inactive{
                print(scenePhase)
            } else {
                print(scenePhase)
            }
        }
    }
}
