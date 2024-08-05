//
//  DataModel.swift
//  shieldApp
//
//  Created by 三浦一真 on 2024/07/21.
//

import Foundation
import FamilyControls
import ManagedSettings

private let _DataModel = DataModel()

class DataModel: ObservableObject {
    let store = ManagedSettingsStore()
    
    @Published var selectionToDiscourage: FamilyActivitySelection
    @Published var selectionToEncourage: FamilyActivitySelection
    
    init() {
        selectionToDiscourage = FamilyActivitySelection()
        selectionToEncourage = FamilyActivitySelection()
    }
    
    class var shared: DataModel {
        return _DataModel
    }

    // shield制限をかけるメソッド
    func setShieldRestrictions() {
        let applications = DataModel.shared.selectionToDiscourage
        print("🐕app: \(applications)")
        store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
        store.shield.applicationCategories = applications.categoryTokens.isEmpty
            ? nil
            : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
    }

    /// shield解除用のメソッド
    func clearShieldRestrictions() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
    }
}
