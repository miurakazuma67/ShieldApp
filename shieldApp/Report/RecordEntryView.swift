//
//  RecordEntryView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/09/25.
//

import SwiftUI
import SwiftData

struct RecordEntryView: View {
    @State private var isPickerPresented = false
    @State private var studyTime = (hours: 0, minutes: 0)
    @State private var currentDate = Date()
    @State private var memo: String = "" // メモの入力を管理するための変数
    @State private var material: String = "" // 教材の入力を管理するための変数
    @Environment(\.modelContext) private var modelContext // SwiftDataのコンテキスト
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        NavigationView {
            Form {
                DatePicker("日付", selection: $currentDate, displayedComponents: [.date, .hourAndMinute])

                HStack {
                    Text("勉強時間")
                    Spacer()
                    Text("\(studyTime.hours) 時間 \(studyTime.minutes) 分")
                        .onTapGesture {
                            isPickerPresented.toggle()
                        }
                }
                
                if isPickerPresented {
                    PickerSelectionView(studyTime: $studyTime, isPickerPresented: $isPickerPresented)
                }

                Section(header: Text("要点・ひとことメモ")) {
                    TextEditor(text: $memo)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.vertical, 5)
                }

                Section(header: Text("教材")) {
                    TextField("教材名を入力", text: $material)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .navigationBarTitle("記録を入力", displayMode: .inline)
            .navigationBarItems(trailing: Button("記録する") {
                saveStudyRecord()
                router.viewPath.append(.recordList)
            })
        }
    }

    // データ保存のメソッド
    private func saveStudyRecord() {
        // StudyRecordエンティティの新しいインスタンスを作成
        let newRecord = StudyRecord(date: currentDate, studyHours: studyTime.hours, studyMinutes: studyTime.minutes, memo: memo, material: material)
        
        // モデルコンテキストに追加
        modelContext.insert(newRecord)
        
        do {
            // データの保存を実行
            try modelContext.save()
            print("データが保存されました")
        } catch {
            print("データの保存中にエラーが発生しました: \(error)")
        }
    }
}

struct PickerSelectionView: View {
    @Binding var studyTime: (hours: Int, minutes: Int)
    @Binding var isPickerPresented: Bool

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("閉じる") {
                    isPickerPresented = false
                }
            }
            .padding()
            
            HStack {
                Picker(selection: $studyTime.hours, label: Text("時間")) {
                    ForEach(0..<24) { hour in
                        Text("\(hour) 時間").tag(hour)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)

                Picker(selection: $studyTime.minutes, label: Text("分")) {
                    ForEach(0..<60) { minute in
                        Text("\(minute) 分").tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)
            }
            .frame(height: 150)
        }
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .padding()
    }
}
