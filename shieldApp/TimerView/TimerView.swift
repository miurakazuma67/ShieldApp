//
//  TimerView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/26.
//
import SwiftUI

struct TimerView: View {
    @State private var isFinished: Bool = false  // 完了かどうか
    @StateObject var viewModel = TimerViewModel()
    @State private var totalMinutes: Int // 遷移元画面で設定した時間

    init(totalMinutes: Int) {
        self.totalMinutes = totalMinutes
    }

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 8)
                    .foregroundColor(Color.gray)

                Circle()
                    .trim(from: 0.0, to: CGFloat(viewModel.progress))
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.green)
                    .rotationEffect(Angle(degrees: -90))  // 0度の位置を上にする

                VStack {
                    IconAndTextView(imageName: "clock.arrow.circlepath", text: "終了時間", spacing: 4)
                        .frame(height: 20)  // HStack自体の高さを指定
                    Text("\(totalMinutes):00")
                        .font(.largeTitle)
                    Text(String(format: "%.0f%%", viewModel.progress * 100))
                        .font(.largeTitle)
                }
                if viewModel.finishFlag {
                    Text("勉強が完了したよ")
                }
            }
            .padding()

            Text("経過時間: \(viewModel.elapsedTimeString)")
                .font(.title2)
                .padding(.top)
        }
        .onAppear {
            viewModel.startTimer(totalMinutes: totalMinutes)  // timer開始
            viewModel.startFocusSession(selectedMinutes: totalMinutes)
        }
    }
}
