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

    @State private var currentPage: Int = 0
    private let recordsPerPage: Int = 10
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationStack {
            List {
                // 各ページに対応する学習記録を表示
                ForEach(paginatedRecords) { record in
                    StudyRecordView(record: record) // 各学習記録をカスタムビューで表示
                }
                .onDelete(perform: deleteRecord) // スワイプで記録を削除可能にする

                // さらにページがある場合は「もっと見る」ボタンを表示
                if hasNextPage {
                    Button("もっと見る") {
                        loadNextPage() // 次のページの記録を読み込む
                    }
                    .foregroundColor(.blue)
                }
            }
            .listStyle(PlainListStyle()) // モダンな外観のためにプレーンリストスタイルを使用
            .navigationTitle("学習記録") // ナビゲーションタイトルを設定
            .navigationBarTitleDisplayMode(.inline) // タイトルをインライン形式で表示
            .toolbar {
                EditButton() // 複数の記録を削除するための編集ボタンを追加
            }
            .padding(.horizontal, 16) // より良いスペーシングのために横方向のパディングを追加
            .alert("エラー", isPresented: $showErrorAlert) { // エラーが発生した場合にアラートを表示
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage) // エラーメッセージを表示
            }
        }
    }

    // ページネーションに基づいて現在の記録セットを取得する計算プロパティ
    private var paginatedRecords: [StudyRecord] {
        let startIndex = currentPage * recordsPerPage
        let endIndex = min(startIndex + recordsPerPage, studyRecords.count)
        return Array(studyRecords[startIndex..<endIndex])
    }

    // さらにページを読み込む必要があるかどうかを確認
    private var hasNextPage: Bool {
        return (currentPage + 1) * recordsPerPage < studyRecords.count
    }

    // 現在のページカウンターを増やして次のページを読み込む
    private func loadNextPage() {
        currentPage += 1
    }

    // 選択された記録を削除し、エラーを適切に処理
    private func deleteRecord(at offsets: IndexSet) {
        for index in offsets {
            let record = studyRecords[index]
            modelContext.delete(record) // コンテキストから記録を削除
        }
        
        do {
            try modelContext.save() // データベースに変更を保存
        } catch {
            errorMessage = "データ削除中にエラーが発生しました: \(error.localizedDescription)" // エラーメッセージを設定
            showErrorAlert = true // エラーアラートを表示
        }
    }
}

struct StudyRecordView: View {
    let record: StudyRecord

    var body: some View {
        contentView // メインのコンテンツビューを表示
    }

    // 記録の詳細を表示するメインコンテンツビュー
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerView // 日付情報を含むヘッダービュー
            studyTimeView // 勉強時間の情報
            memoView // メモがある場合に表示
            materialView // 教材情報がある場合に表示
        }
        .padding(.vertical, 12) // スペーシングのための縦方向のパディング
        .background(Color.white) // カードの背景色
        .cornerRadius(12) // モダンな外観のための角の丸み
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2) // 奥行きを出すためのシャドウ
        .listRowSeparator(.hidden) // よりクリーンな見た目のために行セパレーターを非表示
    }

    // 日付を表示するヘッダービュー
    private var headerView: some View {
        HStack {
            Spacer() // 日付テキストを右に押し出す
            Text(dateToJapaneseString(record.date)) // 日本語形式で日付を表示
                .font(.system(size: 12))
                .foregroundColor(.secondary) // 控えめな色を使用
        }
        .padding(.top, 8) // 上方向のパディングを追加
    }

    // 勉強時間を表示するビュー
    private var studyTimeView: some View {
        HStack {
            Text("勉強時間:")
                .font(.headline) // 強調するためのヘッドラインフォント
            Spacer() // 勉強時間を右に押し出す
            Text("\(record.studyHours) 時間 \(record.studyMinutes) 分") // 時間と分を表示
                .font(.system(size: 14))
                .foregroundColor(.secondary) // 控えめな色を使用
        }
    }

    // メモがある場合に表示するビュー
    private var memoView: some View {
        if let memo = record.memo, !memo.isEmpty {
            return AnyView(
                Text(memo)
                    .font(.body)
                    .foregroundColor(.primary) // 読みやすさのためにメインの色を使用
                    .padding(8) // メモボックス内のパディング
                    .background(Color.gray.opacity(0.1)) // 薄いグレーの背景で区別
                    .cornerRadius(8) // メモボックスの角を丸める
            )
        } else {
            return AnyView(EmptyView()) // メモがない場合は空のビューを表示
        }
    }

    // 教材情報がある場合に表示するビュー
    private var materialView: some View {
        if let material = record.material, !material.isEmpty {
            return AnyView(
                HStack {
                    Text(material)
                        .font(.caption) // 教材には小さめのフォントを使用
                        .padding(.horizontal, 8) // タグの横方向のパディング
                        .padding(.vertical, 4) // タグの縦方向のパディング
                        .background(Color.blue.opacity(0.2)) // タグに薄い青の背景を使用
                        .foregroundColor(.blue) // 青色のテキスト
                        .cornerRadius(8) // タグの角を丸める
                    Spacer() // タグを左に押し出す
                }
            )
        } else {
            return AnyView(EmptyView()) // 教材がない場合は空のビューを表示
        }
    }
}
