//
//  BlockMainView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/12.
//

import FamilyControls
import SwiftUI

struct QuickBlockView: View {
  @State private var selectedMinutes: Int = 0 // ピッカーで選択した時間(Timerに渡)
  let minutesRange = Array(0...180) // 時間の選択範囲
  @State private var totalHours: CGFloat = 30  // 1ヶ月の合計(目標)
  @State private var completedHours: CGFloat = 10  // 1ヶ月の合計
  @State private var isDiscouragedPresented = false  // アプリ制限画面表示用のフラグ
  @State private var isDiscouragedSelected = false  // アプリ選択済みフラグ
  @State private var isShowTimePicker = false  // 時間指定ピッカー表示フラグ 必要？？
  @State private var isAlertMessageShow: Bool = false  // 制限アプリセレクトを促すText表示用フラグ
  @EnvironmentObject var router: NavigationRouter
  @EnvironmentObject var model: DataModel

  var body: some View {
    VStack(spacing: 20) {

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
        isDiscouragedSelected =
          !model.selectionToDiscourage.applicationTokens.isEmpty
          || !model.selectionToDiscourage.categoryTokens.isEmpty  // ボタンを活性にする
          if isAlertMessageShow {
              isAlertMessageShow = false // 選択したらアラートメッセージは非表示に
          }
      }  // Button
      .padding(.top, 10)
        if isAlertMessageShow {
            Text("↑ここから制限するアプリを選択してください！")
                .font(.caption)
                .foregroundStyle(Color.aaaRed)
        }
      Spacer()
      VStack
      {
        Text("\(selectedMinutes):00")  // 最大3時間くらい
          .font(.system(size: 60, weight: .bold))
          .foregroundColor(.green)
          .onTapGesture {
            isShowTimePicker = true  // 時間選択ピッカーの表示
          }
      }

      VStack {
        Text("集中したい時間(分)を選択する")
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

      ThemeColorButton(
        title: "集中する",
        action: {
          if isDiscouragedSelected {
            // 選択されている時に実行
            startFocusSession(selectedMinutes: selectedMinutes)
            router.viewPath.append(.timer(totalMinutes: selectedMinutes))
          } else {
            // 制限するアプリを選択してください！の文言を出す
            isAlertMessageShow = true
          }
        }
      )
      .padding()
    }
    .padding(.top, 80)
    //        BannerView()
    //            .frame(height: 60)
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
