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
    @State private var isShowAlert = false // アラート表示フラグ
    @State private var deleteIndex: IndexSet? // 削除対象のインデックス

    var body: some View {
        NavigationView {
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
                    .overlay(alignment: .topTrailing) {
                        Menu {
                            Button(role: .destructive) {
                                if let index = studyRecords.firstIndex(of: record) {
                                    deleteIndex = IndexSet(integer: index) // 削除対象を保存
                                    isShowAlert = true // アラート表示
                                }
                            } label: {
                                Label("削除", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.secondary)
                                .padding()
                        }
                    }
                }
                .onDelete(perform: deleteRecord) // スワイプで削除
            }
            .navigationTitle("勉強記録一覧")
            .navigationBarTitleDisplayMode(.inline)
            .alert("確認", isPresented: $isShowAlert) {
                Button("キャンセル", role: .cancel) {}
                Button("削除", role: .destructive) {
                    if let offsets = deleteIndex {
                        deleteRecord(at: offsets) // 削除実行
                    }
                }
            } message: {
                Text("この記録を削除してもよろしいですか？")
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
            print("データ削除中にエラーが発生しました: \(error.localizedDescription)")
        }
    }
}
