//
//  shieldAppApp.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/07.
//
import SwiftUI
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}

@main
struct shieldAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // AppDelegateを設定
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
