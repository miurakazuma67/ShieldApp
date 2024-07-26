//
//  TimerView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/26.
//

import SwiftUI

struct TimerView: View {
  @State private var isFinished: Bool = false  //完了かどうか
  @StateObject var viewModel = TimerViewModel()
  private var totalMinutes: Int

  init(totalMinutes: Int) {
    self.totalMinutes = totalMinutes
      print(self.totalMinutes)
  }

  // 初期化する時、遷移元(クイックブロック、)から
  var body: some View {
    VStack {
      ZStack {
        Circle()
          .stroke(lineWidth: 8)
          .foregroundColor(Color.green)

        Circle()
          .trim(from: 0.0, to: CGFloat(viewModel.progress))
          .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))

          .foregroundColor(Color.gray)
          .rotationEffect(Angle(degrees: -90))  // 0度の位置を上にする

        // 残り時間をパーセンテージで表示
        VStack(content: {
          IconAndTextView(imageName: "clock.arrow.circlepath", text: "終了時間", spacing: 4)
            .frame(height: 20)  // HStack自体の高さを指定
          Text("\(totalMinutes):00")
            .font(.largeTitle)
          Text(String(format: "%.0f%%", viewModel.progress * 100))
            .font(.largeTitle)
        })
      }
      .padding()
    }
    .onAppear {
      viewModel.startTimer()  // timer開始
    }
  }
}
