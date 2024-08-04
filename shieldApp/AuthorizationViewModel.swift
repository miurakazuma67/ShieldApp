//
//  AuthorizationViewModel.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/08/03.
//

import FamilyControls
import SwiftUI

class AuthorizationViewModel: ObservableObject {
    @Published var isAuthorized = false

    func checkAuthorizationStatus() async {
        let status = AuthorizationCenter.shared.authorizationStatus
        DispatchQueue.main.async {
            self.isAuthorized = (status == .approved)
        }
    }

    func authorize() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            DispatchQueue.main.async {
                self.isAuthorized = true
            }
        } catch {
            print("error: 登録ずみです")
            DispatchQueue.main.async {
                self.isAuthorized = false
            }
        }
    }
}
