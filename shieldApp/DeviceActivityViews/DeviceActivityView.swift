//
//  DeviceActivityView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/20.
//

////import SwiftUI
////import DeviceActivity
//
//extension DeviceActivityReport.Context {
//    static let pieChart = Self("Pie Chart")
//}
////
////struct DeviceActivityView: View {
////    var thisWeek: DateInterval {
////        // 現在の週のDateIntervalを返す
////        let calendar = Calendar.current
////        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
////        let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
////        return DateInterval(start: startOfWeek, end: endOfWeek)
////    }
////     
////    @State private var context: DeviceActivityReport.Context = .pieChart
////    @State private var filter: DeviceActivityFilter
////    
////    init() {
////        let thisWeek = DateInterval(start: Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!,
////                                    end: Calendar.current.date(byAdding: .day, value: 7, to: Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!)!)
////        self._filter = State(initialValue: DeviceActivityFilter(segment: .daily(during: thisWeek)))
////    }
////    
////    var body: some View {
////        VStack {
////            Text("使用状況")
////            DeviceActivityReport(context, filter: filter)
////                .frame(width: 300, height: 500)
////        }
////    }
////}
//
//import SwiftUI
//import DeviceActivity
//
//// 仮のActivityCategory定義
//enum ActivityCategory: String, CaseIterable, Identifiable {
//    case social
//    case entertainment
//    case productivity
//    case other
//    
//    var id: String { self.rawValue }
//}
//
//// 簡単な円グラフの実装
//struct PieChart: View {
//    let usage: [ActivityCategory: TimeInterval]
//    
//    var body: some View {
//        GeometryReader { geometry in
//            VStack {
//                ZStack {
//                    ForEach(Array(usage.keys.enumerated()), id: \.element) { index, category in
//                        PieSliceView(startAngle: self.angle(for: category, in: usage), endAngle: self.angle(for: category, in: usage, isEnd: true))
//                            .fill(self.color(for: category))
//                            .frame(width: geometry.size.width, height: geometry.size.width)
//                    }
//                }
//                .aspectRatio(1, contentMode: .fit)
//            }
//        }
//    }
//    
//    private func angle(for category: ActivityCategory, in usage: [ActivityCategory: TimeInterval], isEnd: Bool = false) -> Angle {
//        let total = usage.values.reduce(0, +)
//        var currentTotal: TimeInterval = 0
//        
//        for (key, value) in usage {
//            if key == category {
//                if isEnd {
//                    currentTotal += value
//                    return .degrees((currentTotal / total) * 360)
//                } else {
//                    return .degrees((currentTotal / total) * 360)
//                }
//            }
//            currentTotal += value
//        }
//        
//        return .degrees(0)
//    }
//    
//    private func color(for category: ActivityCategory) -> Color {
//        switch category {
//        case .social:
//            return .blue
//        case .entertainment:
//            return .yellow
//        case .productivity:
//            return .orange
//        case .other:
//            return .gray
//        }
//    }
//}
//
//struct PieSliceView: Shape {
//    var startAngle: Angle
//    var endAngle: Angle
//    
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        
//        let center = CGPoint(x: rect.midX, y: rect.midY)
//        path.move(to: center)
//        
//        path.addArc(center: center, radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//        
//        path.closeSubpath()
//        
//        return path
//    }
//}
//
//struct PieChartView: View {
//    struct Configuration {
//        let totalUsageByCategory: [ActivityCategory: TimeInterval]
//    }
//
//    let configuration: Configuration
//
//    var body: some View {
//        PieChart(usage: configuration.totalUsageByCategory)
//    }
//}
//
//class DeviceActivityData: ObservableObject {
//    @Published var usageData: [ActivityCategory: TimeInterval] = [:]
//        @State private var context: DeviceActivityReport.Context = .pieChart
//    
//    init() {
//        fetchData()
//    }
//    
//    func fetchData() {
//        // DeviceActivityデータの取得ロジックをここに記述します
//        let store = DeviceActivityReport(context)
//        
//        let center = DeviceActivityCenter()
//        let thisWeek = DateInterval(start: Calendar.current.startOfDay(for: Date()), duration: 7 * 24 * 60 * 60)
//        
//        let filter = DeviceActivityFilter(segment: .daily(during: thisWeek))
//        
////        let predicate = NSPredicate(format: "category IN %@", [ActivityCategory.social.rawValue, ActivityCategory.entertainment.rawValue, ActivityCategory.productivity.rawValue, ActivityCategory.other.rawValue])
//        // 取得したレポートデータを使用してusageDataを更新します
//        center.loadReport(for: DeviceActivityName("com.example.myapp.pieChart"), with: filter) { report, error in
//            guard let report = report else {
//                print("Failed to load report: \(String(describing: error))")
//                return
//            }
//            
//            // 取得したレポートデータを使用してusageDataを更新します
//            DispatchQueue.main.async {
//                self.usageData = [
//                    .social: report.totalUsage(for: .social),
//                    .entertainment: report.totalUsage(for: .entertainment),
//                    .productivity: report.totalUsage(for: .productivity),
//                    .other: report.totalUsage(for: .other)
//                ]
//            }
//        }
//        
////        store.reports(matching: predicate) { result in
////        store.reports(matching: predicate) { result in
////            switch result {
////            case .success(let reports):
////                // 取得したレポートデータを使用してusageDataを更新します
////                DispatchQueue.main.async {
////                    self.usageData = reports.reduce(into: [:]) { (result, report) in
////                        result[.social] = report.totalUsage(for: .social)
////                        result[.entertainment] = report.totalUsage(for: .entertainment)
////                        result[.productivity] = report.totalUsage(for: .productivity)
////                        result[.other] = report.totalUsage(for: .other)
////                    }
////                }
////            case .failure(let error):
////                print("Failed to fetch reports: \(error)")
////            }
////        }
//        
//    }
//}
//
//struct DeviceActivityView: View {
//    var body: some View {
//        @StateObject var activityData = DeviceActivityData()
////
//        let usageData: [ActivityCategory: TimeInterval] = [:]
//        
//        PieChartView(configuration: PieChartView.Configuration(totalUsageByCategory: activityData.usageData))
//            .padding()
//    }
//}
//
//#Preview {
//    DeviceActivityView()
//}
