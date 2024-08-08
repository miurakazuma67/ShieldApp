//
//  BlockMainView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/12.
//

import SwiftUI

struct QuickBlockView: View {
    @State private var selectedMinutes: Int = 0
    let minutesRange = Array(1...90)
    @State private var repeatEnabled: Bool = false
    @State private var totalHours: CGFloat = 30 // 1ヶ月の合計(目標)
    @State private var completedHours: CGFloat = 10 // 1ヶ月の合計
    @State private var isDiscouragedPresented = false  // アプリ制限画面表示用のフラグ
    @State private var isDiscouragedSelected = false  // アプリ選択済みフラグ
    @State private var isShowTimePicker = false       // 時間指定ピッカー表示フラグ
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var model: DataModel

    var body: some View {
        VStack(spacing: 20) {
            Text("集中しよう")
                .font(.title2)
                .padding(.top)

            Button(
                action: {
                    isDiscouragedPresented = true
                },
                label: {
                    HStack {
                        Image(systemName: "circle.grid.3x3.fill")
                        Text(isDiscouragedSelected ? "選択済み" : "制限するアプリを選択する")
                            .font(.subheadline)
                    }
                }
            )
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(20)
            .familyActivityPicker(
                isPresented: $isDiscouragedPresented, selection: $model.selectionToDiscourage
            )  // アプリ一覧表示
            .onChange(of: model.selectionToDiscourage) {
                DataModel.shared.setShieldRestrictions()
                isDiscouragedSelected = !model.selectionToDiscourage.applicationTokens.isEmpty // ボタンを活性にする
            }

            Spacer()

            VStack {
                Text("\(selectedMinutes):00") // 最大3時間くらい
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.green)
                    .onTapGesture {
                        isShowTimePicker = true    // 時間選択ピッカーの表示
                    }
            }

            VStack {
                Text("集中したい時間を選択する")
                    .font(.headline)
                Picker("Study Time", selection: $selectedMinutes) {
                    ForEach(minutesRange, id: \.self) { minute in
                        Text("\(minute):00").tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 150)
                .clipped()
            }
            .padding()

            Spacer()

            Button(action: {
                startFocusSession(selectedMinutes: selectedMinutes)
                router.viewPath.append(.timer(totalMinutes: selectedMinutes))
            }) {
                Text("集中する！")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isDiscouragedSelected ? Color.blue : Color.gray)
                    .cornerRadius(20)
            }
            .padding()
            .disabled(!isDiscouragedSelected) // 何もアプリを選んでないときは非活性
        }
        .padding()
    }

    private func startFocusSession(selectedMinutes: Int) {
        let focusDuration = TimeInterval(selectedMinutes * 60)
        DataModel.shared.setShieldRestrictions()

        DispatchQueue.main.asyncAfter(deadline: .now() + focusDuration) {
            // アプリケーションの利用制限を解除
            DataModel.shared.clearShieldRestrictions()
            // 2. 完了モーダルの表示
            
            // 3. メニュー画面に遷移する
            
        }
    }
}
