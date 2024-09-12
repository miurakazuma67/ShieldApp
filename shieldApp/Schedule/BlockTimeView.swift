//
//  BlockTimeView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/07.
//

import SwiftUI

struct BlockTimeView: View {
    @State private var blockStart = Date()
    @State private var blockEnd = Date()
    @State private var selectedDays = Set<String>()
    let days = ["月", "火", "水", "木", "金", "土", "日"]

    var body: some View {
        VStack {
            Text("スマホを封印したい時間帯を選択")
                .font(.headline)
                .padding(.top, 20)

            Text("時計上（24時間）の🕒🕓を動かして選択してください")
                .font(.subheadline)
                .padding(.top, 5)
                .padding(.bottom, 20)

            HStack {
                DatePicker("ブロック開始", selection: $blockStart, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .frame(width: 100)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                DatePicker("ブロック終了", selection: $blockEnd, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .frame(width: 100)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            .padding(.bottom, 30)

            CircularTimePicker(blockStart: $blockStart, blockEnd: $blockEnd)
                .frame(width: 250, height: 250)
                .padding(.bottom, 30)

            Text("封印したい曜日を選択")
                .font(.headline)

            HStack {
                ForEach(days, id: \.self) { day in
                    DayButton(day: day, isSelected: selectedDays.contains(day)) {
                        if selectedDays.contains(day) {
                            selectedDays.remove(day)
                        } else {
                            selectedDays.insert(day)
                        }
                    }
                }
            }
            .padding(.bottom, 30)

            HStack {
                Button(action: {
                    // 戻るアクション
                }) {
                    Text("もどる")
                        .bold()
                        .foregroundStyle(Color.gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }

                Button(action: {
                    // 次へアクション
                }) {
                    Text("つぎへ")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .padding()
    }
}

struct DayButton: View {
    let day: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(day)
                .bold()
                .padding()
                .background(isSelected ? Color.green : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(10)
        }
    }
}

struct CircularTimePicker: View {
    @Binding var blockStart: Date
    @Binding var blockEnd: Date
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                
                if angle(for: blockEnd) < angle(for: blockStart) {
                    Circle()
                        .trim(from: angle(for: blockStart), to: 1.0)
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .foregroundColor(Color.green)
                        .rotationEffect(.degrees(-90))
                    Circle()
                        .trim(from: 0.0, to: angle(for: blockEnd))
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .foregroundColor(Color.green)
                        .rotationEffect(.degrees(-90))
                } else {
                    Circle()
                        .trim(from: angle(for: blockStart), to: angle(for: blockEnd))
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .foregroundColor(Color.green)
                        .rotationEffect(.degrees(-90))
                }
                
                ForEach(0..<24) { hour in
                    Text("\(hour)")
                        .position(position(for: hour, in: geometry.size))
                }
            }
        }
    }
    
    func angle(for date: Date) -> CGFloat {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let hours = CGFloat(components.hour ?? 0)
        let minutes = CGFloat(components.minute ?? 0)
        return (hours + minutes / 60.0) / 24.0
    }
    
    func position(for hour: Int, in size: CGSize) -> CGPoint {
        let angle = Angle.degrees(Double(hour) / 24.0 * 360.0 - 90)
        let radius = min(size.width, size.height) / 2.0 - 20
        let x = cos(angle.radians) * radius + size.width / 2.0
        let y = sin(angle.radians) * radius + size.height / 2.0
        return CGPoint(x: x, y: y)
    }
}


struct BlockTimeView_Previews: PreviewProvider {
    static var previews: some View {
        BlockTimeView()
    }
}


