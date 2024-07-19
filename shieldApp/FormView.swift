//
//  GoogleFormView.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/19.
//

import SwiftUI

struct FormView: View {
    var body: some View {
        if let urlString = URL(string: "https://forms.gle/sample") {
            SafariContent(urlString: urlString)
                .ignoresSafeArea()
        }
    }
}
