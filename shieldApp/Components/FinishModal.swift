//
//  FinishModalView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/08/06.
//

import SwiftUI
struct FinishModal: View {
    @EnvironmentObject var router: NavigationRouter // Router
    @Binding var showModal: Bool // モーダル表示用フラグ
    @Binding var studyTime: Int // 学習時間

    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack(spacing: 30) {
                    AnimatedCheckmarkView(studyTime: $studyTime)
                }
                .frame(width: geometry.size.width * 2/3, height: geometry.size.height / 2.5)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        // 背景をタップしたときにdismissActionを呼び出す
        .background(
            Color.black.opacity(0.5)
                .onTapGesture {
                    showModal = false // モーダルを閉じる
                    // モーダルを閉じたら、記録画面に遷移
                    // QuickBlock画面に遷移
                }
        )
    }
}

struct AnimatedCheckmarkView: View {
    @EnvironmentObject var router: NavigationRouter // Router
    @Binding var studyTime: Int // 学習時間をBindingとして受け取る

    @State private var isCircleDrawn = false
    @State private var isCheckMarkShown = false
    @State private var isUnderTextShown = false

    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 5)
                    .frame(width: 100, height: 100)
                    .foregroundColor(isCircleDrawn ? Color.circleFillColor : .clear)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(Color.circleFillColor)
                            .opacity(isCheckMarkShown ? 1 : 0)
                            .scaleEffect(isCheckMarkShown ? 1 : 0.1)
                    )
            }
            .onAppear {
                animateDrawing()
            }
            .animation(.easeIn(duration: 0.25), value: isCheckMarkShown)
            .animation(.linear(duration: 1), value: isCircleDrawn)

            if isUnderTextShown {
                VStack(alignment: .center) {
                    Text("お疲れ様でした！\n学習を記録しましょう")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .transition(.opacity)
                    Button(action: {
                        // studyTimeを使って画面遷移
                        router.viewPath.append(.save(studyTime: studyTime))
                    }) {
                        Text("学習を記録する")
                    }
                }
            }
        }
        .animation(.easeIn(duration: 0.5), value: isUnderTextShown)
    }

    private func animateDrawing() {
        withAnimation {
            isCircleDrawn = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                isCheckMarkShown = true
            }
            Task {
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5秒待機
                await MainActor.run {
                    isUnderTextShown = true
                }
            }
        }
    }
}
