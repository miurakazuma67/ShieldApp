//
//  BlockMainView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/12.
//
// 一番最初に表示したいView

import SwiftUI

struct QuickBlockView: View {
//  @State private var hour: Int = 1
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
          print("Selected applications: \($0.applicationTokens)")
          print("Selected categories: \($0.categoryTokens)")
        DataModel.shared.setShieldRestrictions()
        isDiscouragedSelected = true // ボタンを活性にする
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

//      VStack(alignment: .leading, spacing: 10) {
//        Text("7月の集中時間ゴール \(Int(totalHours))時間/月")
//          .font(.subheadline)
//
//        GeometryReader { proxy in
//          ZStack(alignment: .leading) {
//            RoundedRectangle(cornerRadius: 10)
//              .fill(Color(UIColor.systemGray4))
//              .frame(height: 40)
//
//            RoundedRectangle(cornerRadius: 10)
//              .fill(Color.green.opacity(0.5))
//              .frame(width: proxy.size.width * (completedHours / totalHours), height: 40)
//
//            Text("\(Int(completedHours))時間0分")
//              .padding(.horizontal)
//          }
//        }
//        .frame(height: 40)
//      }
//      .padding()
//      .background(Color.pink.opacity(0.2))
//      .cornerRadius(20)
//      .padding()

      Button(action: {
          startFocusSession(selectedMinutes: 5)
//          router.viewPath.append(.timer(totalMinutes: selectedMinutes)) // 入力した時間を遷移先に渡す
      }) {
        Text("集中する！")
          .font(.title2)
          .bold()
          .foregroundColor(.white)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.blue)
          .cornerRadius(20)
      }
      .padding()
    }
    .padding()
  }

    private func startFocusSession(selectedMinutes: Int) {
    // ブロックスターターボタンのアクション
    let focusDuration = TimeInterval(selectedMinutes * 60)

    // アプリ使用制限を設定
    DataModel.shared.setShieldRestrictions()

    // 指定された時間後に解除
    DispatchQueue.main.asyncAfter(deadline: .now() + focusDuration) {
      DataModel.shared.clearShieldRestrictions()
    }
  }
}
