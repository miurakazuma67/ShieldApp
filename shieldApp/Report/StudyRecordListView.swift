//
//  a.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/09/25.
//

import SwiftUI
import SwiftData

struct StudyRecordListView: View {
    @Query(sort: \StudyRecord.date, order: .reverse) private var studyRecords: [StudyRecord]
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        NavigationView {
            Button("Show Graph") {
                router.viewPath.append(.graph) // グラフ表示
            }
            List {
                ForEach(studyRecords) { record in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("日付:")
                            Spacer()
                            Text(record.date, style: .date)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("勉強時間:")
                            Spacer()
                            Text("\(record.studyHours) 時間 \(record.studyMinutes) 分")
                                .foregroundColor(.secondary)
                        }
                        
                        if let memo = record.memo, !memo.isEmpty {
                            HStack {
                                Text("メモ:")
                                Spacer()
                                Text(memo)
                                    .foregroundColor(.secondary)
                            }
                        }

                        if let material = record.material, !material.isEmpty {
                            HStack {
                                Text("教材:")
                                Spacer()
                                Text(material)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .onDelete(perform: deleteRecord) // スワイプで削除
            }
            .navigationTitle("学習記録")
            .toolbar {
                EditButton() // 編集モードボタン（削除用）
            }
        }
    }

    // データ削除のためのメソッド
    private func deleteRecord(at offsets: IndexSet) {
        for index in offsets {
            let record = studyRecords[index]
            modelContext.delete(record) // レコードをコンテキストから削除
        }
        
        do {
            try modelContext.save() // データベースに反映
        } catch {
            print("データ削除中にエラーが発生しました: \(error)")
        }
    }

    private func handleShowGraph() {
        
    }
}
