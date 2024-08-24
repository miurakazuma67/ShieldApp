//
//  ShieldConfigurationExtension.swift
//  ShieldConfiguration+
//
//  Created by 三浦一真 on 2024/08/11.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit


class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        ShieldConfiguration(
            icon: UIImage(named: "AppIcon")!,
            title: .init(text: "Title", color: .white),
            subtitle: .init(text: "Subtitle", color: .white),
            primaryButtonLabel: .init(text: "Dismiss", color: .black),
            primaryButtonBackgroundColor: .blue,
            secondaryButtonLabel: .init(text: "Unlock", color: .red)
        )
    }
}
