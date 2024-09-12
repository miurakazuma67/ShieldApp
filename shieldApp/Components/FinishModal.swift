//
//  FinishModalView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/08/06.
//

import SwiftUI
struct FinishModal: View {
    @Binding var showModal: Bool // モーダル表示用フラグ

    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack(spacing: 30) {
                    AnimatedCheckmarkView()
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

// アニメーションするチェックマーク
struct AnimatedCheckmarkView: View {
    @State private var isCircleDrawn = false
    @State private var isCheckMarkShown = false
    @State private var isUnderTextShown = false

    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 5)
                    .frame(width: 100, height: 100)
                    .foregroundColor(isCircleDrawn ? .green : .clear)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.green)
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
                    Text("お疲れ様でした！\n学習を記録しましよう") //改行したい
                        .multilineTextAlignment(.center) // 文字を真ん中よせ
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .transition(.opacity)
                    Button(action: {
                        router.viewPath.append(.save)
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
