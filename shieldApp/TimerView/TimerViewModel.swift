//
//  TimerViewModel.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/26.
//
import Foundation
import Combine
// スマホロック後、残り時間を表示・管理するビュー

class TimerViewModel: ObservableObject {
  @Published var progress: Double = 1.0  // タイマーの進捗（1.0で100%）
  private var totalTime: Double = 0.0  // タイマーの総時間（秒）
  private var timer: Timer?  // タイマーオブジェクト
  private var startTime: Date?  // タイマー開始時刻
  private var endTime: Date?  // タイマー終了時刻
  private var showModal = false  // 完了画面を表示するかどうか

//  init(totalTime: Double) {
//    self.totalTime = totalTime
//  }

  // timer測定開始のメソッド
  func startTimer() {
    startTime = Date()  //タイマー起動時の開始時刻
    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
      guard let strongSelf = self, let startTime = strongSelf.startTime else { return }

      let elapsedTime = Date().timeIntervalSince(startTime)
      if elapsedTime >= strongSelf.totalTime {
        strongSelf.progress = 0.0
        strongSelf.timer?.invalidate()
        strongSelf.timer = nil
      } else {
        let remainingTime = strongSelf.totalTime - elapsedTime
        strongSelf.progress = remainingTime / strongSelf.totalTime
      }
    }
  }

  func stopTimer() {
    timer?.invalidate()
    timer = nil
    progress = 1.0
  }
}
