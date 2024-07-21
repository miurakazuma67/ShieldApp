//
//  ExampleView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/20.
//

//import SwiftUI
//import DeviceActivity
//import FamilyControls
//import ManagedSettings
//
//extension DeviceActivityReport.Context {
//    static let barGraph = DeviceActivityReport.Context("barGraph")
////    static let pieChart = DeviceActivityReport.Context("pieChart")
//    static let detailed = DeviceActivityReport.Context("detailed")
//    static let summary = DeviceActivityReport.Context("summary")
//}
//
//struct ExampleView: View {
//    let selectedApps: Set<ApplicationToken>
//    let selectedCategories: Set<ActivityCategoryToken>
//    let selectedWebDomains: Set<WebDomainToken>
//
//    @State private var context: DeviceActivityReport.Context = .detailed
//    @State private var filter: DeviceActivityFilter
//
//    init(selectedApps: Set<ApplicationToken>, selectedCategories: Set<ActivityCategoryToken>, selectedWebDomains: Set<WebDomainToken>) {
//        self.selectedApps = selectedApps
//        self.selectedCategories = selectedCategories
//        self.selectedWebDomains = selectedWebDomains
//        
//        let interval = Calendar.current.dateInterval(of: .weekOfYear, for: Date())!
//        self._filter = State(initialValue: DeviceActivityFilter(
//            segment: .daily(during: interval),
//            users: .children,
//            devices: .init([.iPhone, .iPad]),
//            applications: selectedApps,
//            categories: selectedCategories,
//            webDomains: selectedWebDomains
//        ))
//    }
//
//    var body: some View {
//        VStack {
//            DeviceActivityReport(context, filter: filter)
//
//            // A picker used to change the report's context.
//            Picker(selection: $context, label: Text("Context: ")) {
//                Text("Detailed")
//                    .tag(DeviceActivityReport.Context.detailed)
//                Text("Summary")
//                    .tag(DeviceActivityReport.Context.summary)
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding()
//
//            // A picker used to change the filter's segment interval.
//            Picker(
//                selection: $filter.segmentInterval,
//                label: Text("Segment Interval: ")
//            ) {
//                Text("Hourly")
//                    .tag(DeviceActivityFilter.SegmentInterval.hourly())
//                Text("Daily")
//                    .tag(DeviceActivityFilter.SegmentInterval.daily(
//                        during: Calendar.current.dateInterval(of: .weekOfYear, for: Date())!
//                    ))
//                Text("Weekly")
//                    .tag(DeviceActivityFilter.SegmentInterval.weekly(
//                        during: Calendar.current.dateInterval(of: .month, for: Date())!
//                    ))
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding()
//        }
//    }
//}
