//
//  TimerViewModel.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/26.
//
import Foundation
import Combine

class TimerViewModel: ObservableObject {
    @Published var progress: Double = 0.0  // タイマーの進捗（0.0で0%、1.0で100%）
    @Published var elapsedTimeString: String = "00:00"

    private var totalTime: Double = 0.0  // タイマーの総時間（秒）
    private var timer: Timer?  // タイマーオブジェクト
    private var startTime: Date?  // タイマー開始時刻
    var finishFlag: Bool = false  // 終了フラグ

    func startTimer(totalMinutes: Int) {
        self.totalTime = Double(totalMinutes * 60) // 最大時間
        self.startTime = Date() // 開始時間
        self.progress = 0.0

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }
    }

    private func updateProgress() {
        guard let startTime = startTime else { return }
        
        let elapsedTime = Date().timeIntervalSince(startTime)
        if elapsedTime >= totalTime {
            progress = 1.0
            timer?.invalidate()
            timer = nil
        } else {
            progress = elapsedTime / totalTime
            elapsedTimeString = formatTime(elapsedTime)
        }
    }

    // ブロックをスタートする関数
    func startFocusSession(selectedMinutes: Int) {
    print(" 🐈\(selectedMinutes)")
    // ブロックスターターボタンのアクション
    let focusDuration = TimeInterval(selectedMinutes * 60)
    print(" 🐈フォーカス；\(selectedMinutes)")
    // アプリ使用制限を設定
    DataModel.shared.setShieldRestrictions()

    // 指定された時間後に解除
    DispatchQueue.main.asyncAfter(deadline: .now() + focusDuration) {
      DataModel.shared.clearShieldRestrictions()
    }
  }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        progress = 0.0
        elapsedTimeString = "00:00"
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
