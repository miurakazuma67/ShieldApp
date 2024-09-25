//
//  SaveDataView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/09/11.
//

import SwiftUI

// 使ってない
/// SwiftData保存処理を実装したサンプルビュー memoがない
struct SaveDataView: View {
    @State private var studyDataList: [StudyData] = []
    @State private var date = Date()
    @State private var studyHour: Int = 0
    @State private var studyMinute: Int = 0
    @State private var category: String = ""
    @State private var color: Color = .blue
    @State private var isTimePickerOpen: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    HStack {
                        Text("学習時間")
                        Spacer()
                        Button(action: {
                            isTimePickerOpen.toggle()
                        }) {
                            Text("\(studyHour)時間 \(studyMinute)分")
                        }
                    }
                    TextField("Category", text: $category)
                    ColorPicker("Select Color", selection: $color)
                }

                Button(action: saveData) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                List(studyDataList) { data in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Date: \(data.date, formatter: dateFormatter)")
                            Text("Study Time: \(Int(data.studyTime) / 60)時間 \(Int(data.studyTime) % 60)分")
                            Text("Category: \(data.category)")
                        }
                        Spacer()
                        data.color
                            .frame(width: 20, height: 20)
                            .cornerRadius(10)
                    }
                }
            }

            .navigationTitle("Study Tracker")
            .sheet(isPresented: $isTimePickerOpen) {
                NavigationView(content: {
                    SelectTimeWheelView(hour: $studyHour, minute: $studyMinute, isOpen: $isTimePickerOpen).presentationDetents([.medium])    // 高さを低く
                        .presentationDragIndicator(.visible)
                        .navigationBarTitle("学習時間", displayMode: .inline)
                        .navigationBarItems(leading: Button("キャンセル") {
                            isTimePickerOpen = false
                        }, trailing: Button("登録") {
                            isTimePickerOpen = false
                        })
                })
            }
        }
    }

    func saveData() {
        let studyTimeInMinutes = Double(studyHour * 60 + studyMinute)
        let newData = StudyData(date: date, studyTime: studyTimeInMinutes, category: category, color: color)
        studyDataList.append(newData)
        print("🐈studydata: \(studyDataList)") // データの中身チェック　あとで消す
        resetForm()
    }

    func resetForm() {
        date = Date()
        studyHour = 0
        studyMinute = 0
        category = ""
        color = .blue
    }

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}
