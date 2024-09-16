//
//  TimerView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/26.
//
import SwiftUI

struct TimerView: View {
    @State private var isFinished: Bool = false  // 完了かどうか
    @StateObject var viewModel = TimerViewModel() // Timer VM
    @State private var totalMinutes: Int // 遷移元画面で設定した時間
    @EnvironmentObject var router: NavigationRouter

    init(totalMinutes: Int) {
        self.totalMinutes = totalMinutes
    }

    // 現在時刻を計算し、表示するための関数
    func calculateFutureTime(totalMinutes: Int) -> String {
        // 現在の日時を取得
        let currentDate = Date()

        // DateComponentsを使って指定された分数を足す
        var dateComponents = DateComponents()
        dateComponents.minute = totalMinutes

        // カレンダーを使って現在の日時に分数を足した日時を計算
        let futureDate = Calendar.current.date(byAdding: dateComponents, to: currentDate) ?? currentDate

        // 日時を文字列に変換するためのフォーマッタを作成
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // 表示形式を指定（例: "HH:mm"）

        // 計算された日時を文字列に変換
        return dateFormatter.string(from: futureDate)
    }

    var body: some View {
        Text(String("制限時間: \(totalMinutes)分"))
            .font(.headline)

        ZStack {
            VStack {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .foregroundColor(Color.lightThemeColor)

                    Circle()
                        .trim(from: 0.0, to: CGFloat(viewModel.progress))
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.circleFillColor)
                        .opacity(0.6) // 少し薄く
                        .rotationEffect(Angle(degrees: -90))  // 0度の位置を上にする

                    VStack {
                        IconAndTextView(imageName: "clock.arrow.circlepath", text: "終了時間", spacing: 4)
                            .frame(height: 20)  // HStack自体の高さを指定
                        Text(calculateFutureTime(totalMinutes: totalMinutes))
                            .font(.largeTitle)
                    }
                }
                .padding()
            } //VStack
            .padding() // 少しだけ余白
            if viewModel.isFinished {
                FinishModal(showModal: $viewModel.isFinished)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 3.0), value: viewModel.isFinished)
                    .environmentObject(router)
            }
        }
        .onAppear {
            viewModel.startTimer(totalMinutes: totalMinutes)  // timer開始
        }
    }
}
