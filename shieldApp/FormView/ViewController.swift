//
//  ViewController.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/20.
//

import UIKit
import WebKit

// Webサイト表示用のViewController
class ViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let myURL = URL(string:"https://forms.gle/XCbudAt7nioCVfsA8")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
