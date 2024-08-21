//
//  PageView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/08/21.
//


import SwiftUI

struct PageView<Page: View>: View {
    var viewControllers: [UIHostingController<Page>]
    @State var currentPage = 0
    
    init(_ views: [Page]) {
        self.viewControllers = views.map { UIHostingController(rootView: $0) }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            PageViewController(controllers: viewControllers, currentPage: $currentPage)
            PageControl(numberOfPages: viewControllers.count, currentPage: $currentPage)
                .padding(.trailing)
                .padding(.bottom, 20)
        }
    }
}

struct PageView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var views = [Text("First"), Text("Second"), Text("Third")]
        var body: some View {
            PageView(views)
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
