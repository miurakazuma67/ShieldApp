//
//  SafariView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/19.
//
import UIKit
import SwiftUI
import WebKit

struct SafariView: View {
    var urlString: URL

    @State var isSafariWebView: Bool = false
    private var url = "https://danielsaidi.github.io/WebViewKit/documentation/webviewkit/getting-started/"
    var body: some View {
        VStack {
            Button {
                isSafariWebView = true
            } label: {
                Text("表示")
            }
        }
        .fullScreenCover(isPresented: $isSafariWebView) {
            SafariWebView(url: URL(string: url)!) { configuration in
                configuration.dismissButtonStyle = .close
                configuration.preferredBarTintColor = .green
                configuration.preferredControlTintColor = .purple
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
