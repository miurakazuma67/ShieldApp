//
//  ScreenTimeViewModel.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/20.
//
//import SwiftUI
//import DeviceActivity
//import FamilyControls
//import ManagedSettings
//import Combine
//
//class ScreenTimeViewModel: ObservableObject {
//    @Published var dailyUsage: String = "Loading..."
//    private var cancellables = Set<AnyCancellable>()
//    
//    private let center = DeviceActivityCenter()
//    
//    init() {
//        startMonitoring()
//    }
//    
//    private func startMonitoring() {
//        let schedule = DeviceActivitySchedule(
//            intervalStart: DateComponents(hour: 0, minute: 0),
//            intervalEnd: DateComponents(hour: 23, minute: 59),
//            repeats: true
//        )
//        
//        do {
//            try center.startMonitoring(.daily, during: schedule)
//            fetchDailyUsage()
//        } catch {
//            dailyUsage = "Failed to start monitoring: \(error.localizedDescription)"
//        }
//        
//        // Observe changes in activity data
//        NotificationCenter.default.publisher(for: .deviceActivityUpdated)
//            .sink { [weak self] notification in
//                self?.fetchDailyUsage()
//            }
//            .store(in: &cancellables)
//    }
//    
//    private func fetchDailyUsage() {
//        let store = ManagedSettingsStore(named: .default) // 一旦Default
//        store.queryActivity(for: Date()) { result in
//            switch result {
//            case .success(let activity):
//                self.processActivity(activity)
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self.dailyUsage = "Failed to fetch data: \(error.localizedDescription)"
//                }
//            }
//        }
//    }
//    
//    private func processActivity(_ activity: DeviceActivity) {
//        let totalDuration = activity.totalUsage
//        let hours = Int(totalDuration) / 3600
//        let minutes = (Int(totalDuration) % 3600) / 60
//        
//        DispatchQueue.main.async {
//            self.dailyUsage = "\(hours) hours \(minutes) minutes"
//        }
//    }
//}
//
//extension DeviceActivityName {
//    static let daily = Self("daily") // 1日あたり
//
//}
//
//
//extension Notification.Name {
//    static let deviceActivityUpdated = Notification.Name("DeviceActivityUpdated")
//}
